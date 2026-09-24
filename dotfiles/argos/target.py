#!/usr/bin/env python3
"""Manage Argos's explicitly selected pentest target."""

import argparse
import ipaddress
import json
import os
from pathlib import Path
import re
import subprocess
import sys
import tempfile
import unicodedata


DISPLAY_LABEL_UNSAFE = re.compile(r"[^A-Za-z0-9 ._/-]")


class InvalidTarget(ValueError):
    """An address or label is not valid target input."""


class InvalidState(ValueError):
    """The stored target is not a valid address and label pair."""


def state_file():
    state_home = os.environ.get("XDG_STATE_HOME") or str(Path.home() / ".local" / "state")
    return Path(state_home) / "argos" / "target.json"


def validate_target(ip, label):
    if type(ip) is not str or "%" in ip:
        raise InvalidTarget("target IP must be an IPv4 or IPv6 literal without a scope")
    try:
        canonical_ip = str(ipaddress.ip_address(ip))
    except ValueError as error:
        raise InvalidTarget("target IP must be an IPv4 or IPv6 literal") from error
    if type(label) is not str or any(unicodedata.category(char) == "Cc" for char in label):
        raise InvalidTarget("target label must not contain control characters")
    return canonical_ip, label


def read_target():
    try:
        contents = state_file().read_text(encoding="utf-8")
    except FileNotFoundError:
        return None
    except (OSError, UnicodeError):
        raise InvalidState("target state is unreadable") from None
    try:
        data = json.loads(contents)
        if type(data) is not dict or set(data) != {"ip", "label"}:
            raise InvalidState("target state must contain only ip and label")
        return validate_target(data["ip"], data["label"])
    except (ValueError, UnicodeError) as error:
        raise InvalidState("target state is invalid") from error


def write_target(ip, label):
    # Validate before touching either the directory or the existing state file.
    canonical_ip, label = validate_target(ip, label)
    path = state_file()
    path.parent.mkdir(mode=0o700, parents=True, exist_ok=True)
    if path.parent.is_symlink():
        raise OSError("target state directory must not be a symlink")
    path.parent.chmod(0o700)

    temporary_path = None
    try:
        with tempfile.NamedTemporaryFile(
            mode="w", encoding="utf-8", prefix=".target-", dir=path.parent, delete=False
        ) as temporary:
            temporary_path = Path(temporary.name)
            os.fchmod(temporary.fileno(), 0o600)
            json.dump({"ip": canonical_ip, "label": label}, temporary, ensure_ascii=False)
            temporary.write("\n")
            temporary.flush()
            os.fsync(temporary.fileno())
        os.replace(temporary_path, path)
    finally:
        if temporary_path is not None:
            temporary_path.unlink(missing_ok=True)


def display_target(target):
    if target is None:
        return "No target"
    ip, label = target
    safe_label = DISPLAY_LABEL_UNSAFE.sub("_", label)[:24]
    return ip + (" " + safe_label if safe_label else "")


def rofi_choice(prompt, items="", only_match=False):
    command = ["rofi", "-dmenu", "-i", "-p", prompt]
    if only_match:
        command.append("-only-match")
    result = subprocess.run(command, input=items, text=True, capture_output=True, check=False)
    if result.returncode == 1 and not result.stderr.strip():
        return None  # Rofi cancel / Escape.
    if result.returncode != 0:
        raise OSError(result.stderr.strip() or "rofi failed")
    return result.stdout.removesuffix("\n")


def target_menu():
    choice = rofi_choice("Target", "Set target\nClear target\n", only_match=True)
    if choice == "Clear target":
        state_file().unlink(missing_ok=True)
    elif choice == "Set target":
        ip = rofi_choice("Target IP")
        if ip is None:
            return
        try:
            validate_target(ip, "")
        except InvalidTarget as error:
            subprocess.run(["rofi", "-e", str(error)], check=False)
            return
        label = rofi_choice("Target label (optional)", "\n")
        if label is None:
            return
        try:
            write_target(ip, label)
        except InvalidTarget as error:
            subprocess.run(["rofi", "-e", str(error)], check=False)


def main(argv=None):
    parser = argparse.ArgumentParser(prog="argos-target")
    commands = parser.add_subparsers(dest="command", required=True)
    set_command = commands.add_parser("set", help="store an IP address and optional label")
    set_command.add_argument("ip")
    set_command.add_argument("label", nargs="?", default="")
    for name in ("get", "show", "copy", "clear", "menu"):
        commands.add_parser(name)
    args = parser.parse_args(argv)

    try:
        if args.command == "set":
            write_target(args.ip, args.label)
        elif args.command == "clear":
            state_file().unlink(missing_ok=True)
        elif args.command == "menu":
            target_menu()
        else:
            try:
                target = read_target()
            except InvalidState:
                if args.command == "show":
                    print("Target invalid")
                    return 0
                return 1
            if args.command == "show":
                print(display_target(target))
            elif target is None:
                return 1
            elif args.command == "get":
                print(target[0])
            elif args.command == "copy":
                subprocess.run(
                    ["xclip", "-selection", "clipboard"],
                    input=target[0],
                    text=True,
                    stdout=subprocess.DEVNULL,
                    stderr=subprocess.DEVNULL,
                    check=True,
                )
    except InvalidTarget as error:
        print(f"argos-target: {error}", file=sys.stderr)
        return 2
    except (OSError, subprocess.CalledProcessError) as error:
        print(f"argos-target: {error}", file=sys.stderr)
        return 1
    return 0


if __name__ == "__main__":
    raise SystemExit(main())
