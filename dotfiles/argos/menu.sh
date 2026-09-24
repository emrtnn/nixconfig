#!/usr/bin/env bash

usage() {
  printf 'Usage: argos-menu controls|power|lock\n' >&2
}

choose() {
  local prompt=$1
  shift
  printf '%s\n' "$@" | rofi -dmenu -i -only-match -selected-row 0 -p "$prompt"
}

confirm() {
  local answer
  answer=$(choose "Confirm $1?" Cancel Confirm) || return 1
  [[ "$answer" == Confirm ]]
}

controls() {
  local action
  action=$(choose Controls Audio Network Displays Passwords Target Power) || return 0
  case "$action" in
    Audio) pavucontrol ;;
    Network) nm-connection-editor ;;
    Displays) arandr ;;
    Passwords)
      passmenu -i -l 10 -p Passwords -fn 'GeistMono Nerd Font Mono-10' -nb '#282828' -nf '#ebdbb2' -sb '#d79921' -sf '#282828'
      ;;
    Target) argos-target menu ;;
    Power) argos-menu power ;;
    *) return 0 ;;
  esac
}

power() {
  local action
  action=$(choose Power Lock 'Log out' Suspend Reboot 'Power off') || return 0
  case "$action" in
    Lock) argos-menu lock ;;
    'Log out')
      if confirm 'Log out'; then bspc quit; fi
      ;;
    Suspend) systemctl suspend ;;
    Reboot)
      if confirm Reboot; then systemctl reboot; fi
      ;;
    'Power off')
      if confirm 'Power off'; then systemctl poweroff; fi
      ;;
    *) return 0 ;;
  esac
}

if (( $# != 1 )); then
  usage
  exit 2
fi

case "$1" in
  controls) controls ;;
  power) power ;;
  lock)
    if [[ -z "${XDG_SESSION_ID:-}" ]]; then
      printf 'XDG_SESSION_ID is required to lock the current session.\n' >&2
      exit 1
    fi
    loginctl lock-session "$XDG_SESSION_ID"
    ;;
  *) usage; exit 2 ;;
esac
