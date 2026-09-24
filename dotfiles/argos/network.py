#!/usr/bin/env python3
"""Public and outbound-route IPv4 status for Argos's Polybar bubble."""

import argparse
import errno
import ipaddress
import json
import os
from pathlib import Path
import select
import signal
import stat
import subprocess
import sys
import tempfile
import time


PUBLIC_URL = "https://api.ipify.org"
CURL_COMMAND = (
    "curl",
    "-4",
    "--fail",
    "--silent",
    "--show-error",
    "--connect-timeout",
    "2",
    "--max-time",
    "3",
    "--max-filesize",
    "64",
    PUBLIC_URL,
)
ROUTE_COMMAND = ("ip", "-j", "-4", "route", "get", "1.1.1.1")


def mode_path():
    runtime = os.environ.get("XDG_RUNTIME_DIR")
    if not runtime or not os.path.isabs(runtime):
        raise ValueError("set XDG_RUNTIME_DIR to an absolute, private runtime directory")

    try:
        runtime_stat = os.lstat(runtime)
    except OSError as error:
        raise ValueError(f"XDG_RUNTIME_DIR is not accessible: {error}") from error
    if (
        not stat.S_ISDIR(runtime_stat.st_mode)
        or runtime_stat.st_uid != os.getuid()
        or stat.S_IMODE(runtime_stat.st_mode) != 0o700
    ):
        raise ValueError("XDG_RUNTIME_DIR must be a private (0700) directory owned by you")

    directory = Path(runtime) / "argos"
    try:
        directory.mkdir(mode=0o700)
    except FileExistsError:
        pass
    directory_stat = directory.lstat()
    if not stat.S_ISDIR(directory_stat.st_mode) or directory_stat.st_uid != os.getuid():
        raise ValueError("XDG_RUNTIME_DIR/argos must be a directory owned by you")
    if stat.S_IMODE(directory_stat.st_mode) != 0o700:
        directory.chmod(0o700)
    return directory / "network-mode"


def read_mode(path):
    try:
        fd = os.open(path, os.O_RDONLY | os.O_NONBLOCK | os.O_NOFOLLOW)
    except OSError as error:
        if error.errno in (errno.ENOENT, errno.ELOOP, errno.EACCES, errno.EISDIR):
            return "public"
        raise
    try:
        details = os.fstat(fd)
        if (
            not stat.S_ISREG(details.st_mode)
            or details.st_uid != os.getuid()
            or stat.S_IMODE(details.st_mode) != 0o600
        ):
            return "public"
        value = os.read(fd, 7)  # One more byte than the longest valid value.
        return value.decode("ascii") if value in (b"public", b"local") else "public"
    finally:
        os.close(fd)


def write_mode(path, value):
    fd, temporary = tempfile.mkstemp(prefix=".network-mode-", dir=path.parent)
    try:
        with os.fdopen(fd, "wb") as output:
            os.fchmod(output.fileno(), 0o600)
            output.write(value.encode("ascii"))
        os.replace(temporary, path)
    finally:
        if os.path.exists(temporary):
            os.unlink(temporary)


def ipv4(value):
    try:
        return str(ipaddress.IPv4Address(value))
    except (ipaddress.AddressValueError, TypeError, ValueError):
        return None


def public_result(data):
    try:
        return ipv4(data.decode("ascii").strip())
    except UnicodeDecodeError:
        return None


def route_result(data):
    try:
        routes = json.loads(data)
        source = routes[0]["prefsrc"]
        return ipv4(source) if isinstance(source, str) else None
    except (ValueError, TypeError, IndexError, KeyError):
        return None


def stop_child(child):
    if child is None:
        return
    if child.poll() is None:
        child.terminate()
    try:
        child.communicate(timeout=0.5)
    except subprocess.TimeoutExpired:
        child.kill()
        child.communicate()


def watch(path):
    stopping = False

    def stop(_signum, _frame):
        nonlocal stopping
        stopping = True

    old_term = signal.signal(signal.SIGTERM, stop)
    old_int = signal.signal(signal.SIGINT, stop)
    curl = None
    route = None
    next_mode_poll = 0.0
    next_public_request = 0.0
    next_route_request = 0.0
    public_ip = None
    public_known = False
    local_ip = None
    mode = "public"
    shown = None
    output_events = select.poll()
    output_events.register(sys.stdout.fileno(), select.POLLERR | select.POLLHUP | select.POLLNVAL)
    try:
        while not stopping:
            if output_events.poll(0):
                break
            now = time.monotonic()
            if now >= next_mode_poll:
                previous_mode = mode
                mode = read_mode(path)
                next_mode_poll = now + 0.5
                if mode == "local" and previous_mode != mode and now >= next_route_request:
                    local_ip = None

            if curl is not None:
                if curl.poll() is not None:
                    data, _ = curl.communicate()
                    public_ip = public_result(data) if curl.returncode == 0 else None
                    public_known = True
                    curl = None
                elif now - curl_started >= 4:
                    stop_child(curl)
                    public_ip = None
                    public_known = True
                    curl = None
            if curl is None and now >= next_public_request:
                next_public_request = now + 60
                try:
                    curl = subprocess.Popen(CURL_COMMAND, stdout=subprocess.PIPE)
                    curl_started = now
                except OSError as error:
                    print(f"argos-network: cannot start curl: {error}", file=sys.stderr)
                    public_ip = None
                    public_known = True

            if route is not None:
                if route.poll() is not None:
                    data, _ = route.communicate()
                    local_ip = route_result(data) if route.returncode == 0 else None
                    route = None
                elif now - route_started >= 1:
                    stop_child(route)
                    local_ip = None
                    route = None
            if mode == "local" and route is None and now >= next_route_request:
                next_route_request = now + 2
                try:
                    route = subprocess.Popen(
                        ROUTE_COMMAND, stdout=subprocess.PIPE, stderr=subprocess.DEVNULL
                    )
                    route_started = now
                except OSError as error:
                    print(f"argos-network: cannot start ip: {error}", file=sys.stderr)
                    local_ip = None

            label = (
                f"LAN {local_ip or 'offline'}"
                if mode == "local"
                else f"PUB {public_ip or 'offline'}" if public_known else "PUB ..."
            )
            if label != shown:
                print(label, flush=True)
                shown = label
            time.sleep(0.1)
    finally:
        signal.signal(signal.SIGTERM, old_term)
        signal.signal(signal.SIGINT, old_int)
        stop_child(curl)
        stop_child(route)
    return 0


def main(argv=None):
    parser = argparse.ArgumentParser(prog="argos-network")
    parser.add_argument("command", choices=("watch", "toggle"))
    args = parser.parse_args(argv)
    try:
        path = mode_path()
        if args.command == "toggle":
            write_mode(path, "local" if read_mode(path) == "public" else "public")
            return 0
        try:
            return watch(path)
        except BrokenPipeError:
            # Avoid Python's interpreter-shutdown flush on a closed Polybar pipe.
            sys.stdout = open(os.devnull, "w")
            return 0
    except (OSError, ValueError) as error:
        print(f"argos-network: {error}", file=sys.stderr)
        return 1


if __name__ == "__main__":
    sys.exit(main())
