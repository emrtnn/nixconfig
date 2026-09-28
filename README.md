# ❄️ Nixconfig

> Modular nixos & home-manager dotfiles. 

A perpetually work-in-progress declarative configuration.

## What it has

- **os**: nixos (unstable)
- **wm**: Mango on personal hosts; bspwm/X11 with sxhkd on Argos; Niri and Hyprland remain opt-in modules
- **shell**: zsh + starship; Nushell remains opt-in
- **editor**: neovim (custom lua config)
- **terminal**: Foot on personal hosts; Kitty on Argos
- **browser**: Helium (default) Firefox (secondary)
- **secrets**: Home Manager sops-nix + age; each host declares its secret source and external key

## Hosts

- **monad:** x86_64 NVIDIA desktop (`hosts/monad`)
- **arpano:** x86_64 AMD workstation (`hosts/arpano`)
- **argos:** VMware lab guest with bspwm/X11 (`hosts/argos`); hardware configuration must come from that guest

## Use it

```bash
# deploy the main desktop
sudo nixos-rebuild switch --flake .#monad

# deploy the workstation
sudo nixos-rebuild switch --flake .#arpano

# deploy the virtual machine
sudo nixos-rebuild switch --flake .#argos
```

## Structure

```text
.
├── base/                     # universal Nix, locale, CLI and Home Manager integration
├── dotfiles/                 # application configs; Argos's X11 configs are store-backed
├── home/                     # reusable Home Manager programs, desktops and security tools
├── hosts/
│   ├── monad/                # configuration.nix + home.nix + hardware-conf.nix
│   ├── arpano/               # independent AMD workstation composition
│   └── argos/                # independent VMware guest composition
├── nixos/                    # reusable system services, desktops and optional features
├── secrets/                  # encrypted personal secrets
├── wallpapers/
└── flake.nix                 # one NixOS entry point per host
```

Each host's `configuration.nix` explicitly selects its hardware, `base/base.nix`,
and system features, and imports its own `home.nix` through Home Manager.
The flake factory receives only that single system entry point; it does not
discover hosts, infer hardware, or independently select a user composition.

`base/base.nix` provides Nix settings, locale, system CLI utilities and shared
Home Manager shell/editor/VCS utilities. It declares no account, desktop,
secrets, signing policy, Docker, gaming or coding-agent suite. Hosts declare
their account and access groups, GPG/SSH-agent policy, author identity, signing,
secret locations, application choices and machine-specific desktop settings.
Development tools and Pi/OMP/Herdr are explicitly selected by every host.

Monad and Arpano independently select Mango, Foot/Noctalia/Swappy, gaming,
OnlyOffice PDF handling and signed Jujutsu. Argos selects VMware, BSPWM/Kitty,
Evince PDF handling and unsigned Jujutsu. All retain Docker, Wireshark/hacking
tools and the Brave API secret. Niri, Hyprland, Nushell, Helix, tmux and Fastfetch
remain available but unselected.

The age key stays outside the repository at
`/home/impuremonad/.config/sops/age/keys.txt`. Builds do not decrypt secrets or
replace account passwords. No unused system-level SOPS defaults are declared.

## Argos: fresh VMware installation

Argos selects VMware guest support, Xorg, SDDM, bspwm, PipeWire,
NetworkManager, a firewall, and explicitly selected user applications,
agents and credentials. Its existing `hardware-conf.nix` comes from the
installed guest; neither personal host's hardware configuration is suitable.

The X11 desktop uses nine named bspwm desktops, sxhkd, four separate Polybar
bubbles, Rofi, Kitty, Helium, CopyQ, Picom, Dunst, Scrot/Ksnip, and i3lock.
The network bubble toggles between ipify's public IPv4 and the local source
address selected by `ip route get`; it is not a pentest target detector.
`argos-target set <IP> [label]`, `get`, `show`, `copy`, `clear`, and `menu`
manage the explicitly chosen pentest target in
`${XDG_STATE_HOME:-$HOME/.local/state}/argos/target.json`. Click the target
bubble to copy its canonical IP, or right-click to edit it. Super+Alt+T opens
the same editor; Super+Alt+P and Controls → Passwords run the unchanged
upstream `passmenu` through dmenu. Its normal 45-second clipboard expiry does
not erase CopyQ history.

CopyQ mirrors CLIPBOARD text to PRIMARY so Herdr's mouse/copy-mode selections
can reach the VMware host. Herdr 0.9.1 writes through `xclip`, which does not
provide the selection timestamp VMware uses to choose between CLIPBOARD and
PRIMARY; CopyQ supplies a timestamped PRIMARY selection. Consequently,
middle-click also pastes the latest copied text. Synchronization is configured
when the CopyQ user service starts, not during headless Home Manager activation.
To apply it to an already-running desktop without rebuilding:
`copyq config copy_clipboard true`. Verify by selecting text in Herdr and
pasting on the host; guest-side clipboard checks alone cannot prove host receipt.

Before rebuilding **inside the actual guest**:

1. Commit/push the configuration before cloning it; a clone needs all new modules.
2. Install an x86_64 NixOS guest with UEFI, Secure Boot disabled, and its EFI
   system partition mounted at `/boot`. Argos selects systemd-boot, not the
   personal hosts' Limine configuration.
3. Create the `impuremonad` user with a login password during installation.
   Passwords remain mutable; this repository supplies no guest password.
4. Clone into `/home/impuremonad/nixconfig`. Keep the checkout there: Neovim still
   uses the existing mutable `dotfiles/nvim` link. Clone tracked source rather
   than copying live `.pi` state from a personal checkout.
5. Check `system.stateVersion` against the freshly installed system's
   `/etc/nixos/configuration.nix`. Argos currently declares `"26.11"` for a fresh
   installation of that release. If installing another release, retain that
   installation's state version instead; this is not a package-version selector.

Then, from the guest checkout:

```bash
cd /home/impuremonad/nixconfig
# Only on a new guest without its generated hardware file:
sudo nixos-generate-config --show-hardware-config > hosts/argos/hardware-conf.nix
git add hosts/argos/hardware-conf.nix
# Build first without changing the installed system.
sudo env NIX_CONFIG='experimental-features = nix-command flakes' \
  nixos-rebuild build --flake .#argos

# Activate only after that guest build succeeds.
sudo env NIX_CONFIG='experimental-features = nix-command flakes' \
  nixos-rebuild switch --flake .#argos
```

The `git add` matters: a local Git-backed flake excludes untracked hardware
files. Never replace an existing guest-generated hardware file with another
host's root/EFI UUIDs, storage modules, or architecture.

After the first switch, flakes are enabled by the shared base module, so
normal rebuilds use `sudo nixos-rebuild switch --flake .#argos`. At a safe
logout boundary, select bspwm in SDDM and verify X11 session variables, the
four bubbles, workspace movement, target copy, public/local toggling, screen
lock, GPG graphical unlock, PipeWire keys, and VMware resolution changes.
Keep previous Nix generations for rollback; an isolated X11 smoke or build
does not prove the interactive VMware login.
