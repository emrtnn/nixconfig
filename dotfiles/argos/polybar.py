#!/usr/bin/env python3
"""Keep four detached Polybar windows on the active primary XRandR monitor."""

import os
import re
import selectors
import signal
import subprocess
import sys
import time
from collections import namedtuple
from pathlib import Path

Monitor = namedtuple("Monitor", "output width height x y")
MONITOR_LINE = re.compile(
    r"^\s*\d+:\s+(?P<flags>[+*]*)(?:\S+)\s+"
    r"(?P<width>\d+)/\d+x(?P<height>\d+)/\d+"
    r"(?P<x>[+-]\d+)(?P<y>[+-]\d+)\s+(?P<outputs>\S+)\s*$"
)
BAR_WIDTHS = {"network": 176, "workspaces": 216, "target": 208, "power": 40}
MONITOR_EVENTS = ("monitor_add", "monitor_remove", "monitor_geometry", "monitor_swap")


def active_monitor():
    result = subprocess.run(
        ["xrandr", "--listactivemonitors"], capture_output=True, text=True, check=True
    )
    monitors = []
    for line in result.stdout.splitlines()[1:]:
        match = MONITOR_LINE.fullmatch(line)
        if match is None:
            raise ValueError(f"Unexpected xrandr monitor entry: {line!r}")
        output = match.group("outputs").split(",", 1)[0]
        monitor = Monitor(
            output,
            int(match.group("width")),
            int(match.group("height")),
            int(match.group("x")),
            int(match.group("y")),
        )
        if monitor.width > 0 and monitor.height > 0:
            monitors.append(("*" in match.group("flags"), monitor))
    return next((monitor for primary, monitor in monitors if primary), None) or (
        monitors[0][1] if monitors else None
    )


def bar_layout(width):
    factor = min(width, 800)
    widths = {name: max(1, size * factor // 800) for name, size in BAR_WIDTHS.items()}
    margin = 12 * factor // 800
    gap = 8 * factor // 800
    power_x = width - margin - widths["power"]
    positions = {
        "network": margin,
        "workspaces": (width - widths["workspaces"]) // 2,
        "target": power_x - gap - widths["target"],
        "power": power_x,
    }
    font = f"GeistMono Nerd Font Mono:size={max(7, 10 * factor // 800)};2"
    return [(name, widths[name], positions[name], font) for name in BAR_WIDTHS]


def set_padding(output, pixels, required):
    result = subprocess.run(
        ["bspc", "config", "-m", output, "top_padding", str(pixels)],
        capture_output=True,
        text=True,
    )
    if result.returncode:
        message = f"Cannot set top padding for {output}: {result.stderr.strip()}"
        if required:
            raise RuntimeError(message)
        print(f"argos-polybar: {message}", file=sys.stderr, flush=True)


def set_wallpaper():
    wallpaper = Path.home() / "Pictures/Wallpapers/riots.png"
    if not wallpaper.is_file():
        print(
            f"argos-polybar: wallpaper missing: {wallpaper}",
            file=sys.stderr,
            flush=True,
        )
        return
    result = subprocess.run(["feh", "--bg-fill", "--no-fehbg", str(wallpaper)])
    if result.returncode:
        print(
            "argos-polybar: feh could not apply wallpaper", file=sys.stderr, flush=True
        )


def start_bars(monitor):
    config_home = Path(os.environ.get("XDG_CONFIG_HOME") or Path.home() / ".config")
    config = config_home / "polybar/config.ini"
    bars = []
    try:
        for name, width, x, font in bar_layout(monitor.width):
            environment = os.environ.copy()
            environment.update(
                MONITOR=monitor.output,
                ARGOS_BAR_WIDTH=str(width),
                ARGOS_BAR_X=str(x),
                ARGOS_BAR_FONT=font,
            )
            child = subprocess.Popen(
                ["polybar", f"--config={config}", name],
                env=environment,
                start_new_session=True,
            )
            bars.append((name, child))
        return bars
    except BaseException:
        stop_bars(bars)
        raise


def stop_bars(bars):
    for _, child in bars:
        try:
            os.killpg(child.pid, signal.SIGTERM)
        except ProcessLookupError:
            pass
    deadline = time.monotonic() + 2
    for _, child in bars:
        try:
            child.wait(timeout=max(0, deadline - time.monotonic()))
        except subprocess.TimeoutExpired:
            pass
    # Polybar's own exit does not guarantee its long-running script has exited.
    for _, child in bars:
        try:
            os.killpg(child.pid, signal.SIGKILL)
        except ProcessLookupError:
            pass
        child.wait()


def reflow(previous, selected, bars):
    stop_bars(bars)
    bars.clear()
    if previous is not None and (
        selected is None or previous.output != selected.output
    ):
        set_padding(previous.output, 8, required=False)
    if selected is not None:
        set_padding(selected.output, 44, required=True)
        set_wallpaper()
        bars.extend(start_bars(selected))
    return selected


def main():
    if len(sys.argv) != 1:
        print("Usage: argos-polybar", file=sys.stderr)
        return 2

    stopping = False

    def request_stop(_signal, _frame):
        nonlocal stopping
        stopping = True

    signal.signal(signal.SIGTERM, request_stop)
    signal.signal(signal.SIGINT, request_stop)
    subscription = None
    bars = []
    try:
        # Query before subscribing, then reconcile once the subscription exists
        # so a monitor change in between these calls cannot be lost.
        selected = active_monitor()
        subscription = subprocess.Popen(
            ["bspc", "subscribe", *MONITOR_EVENTS], stdout=subprocess.PIPE
        )
        latest = active_monitor()
        if latest != selected:
            selected = latest
        current = reflow(None, selected, bars) if selected is not None else None
        with selectors.DefaultSelector() as selector:
            selector.register(subscription.stdout, selectors.EVENT_READ)
            pending = b""
            while not stopping:
                events = selector.select(timeout=0.5)
                if stopping:
                    break
                if events:
                    chunk = os.read(subscription.stdout.fileno(), 4096)
                    if not chunk:
                        if stopping:
                            break
                        print(
                            "argos-polybar: bspwm monitor subscription ended",
                            file=sys.stderr,
                        )
                        return 1
                    pending += chunk
                    if b"\n" in pending:
                        pending = pending.rsplit(b"\n", 1)[1]
                        selected = active_monitor()
                        if selected != current:
                            current = reflow(current, selected, bars)
                for name, child in bars:
                    status = child.poll()
                    if status is not None:
                        print(
                            f"argos-polybar: {name} exited with status {status}",
                            file=sys.stderr,
                        )
                        return 1
        return 0
    except (OSError, ValueError, RuntimeError, subprocess.CalledProcessError) as error:
        print(f"argos-polybar: {error}", file=sys.stderr)
        return 1
    finally:
        stop_bars(bars)
        if subscription is not None:
            if subscription.poll() is None:
                subscription.terminate()
                try:
                    subscription.wait(timeout=2)
                except subprocess.TimeoutExpired:
                    subscription.kill()
                    subscription.wait()
            if subscription.stdout is not None:
                subscription.stdout.close()


if __name__ == "__main__":
    sys.exit(main())
