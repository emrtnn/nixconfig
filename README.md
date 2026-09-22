# ❄️ Nixconfig

> Modular nixos & home-manager dotfiles. 

A perpetually work-in-progress declarative configuration.

## What it has

- **os**: nixos (unstable + stable pin)
- **wm**: Mango on personal hosts; Awesome/X11 on the lab guest; Niri and Hyprland remain opt-in modules
- **shell**: nushell & zsh + starship
- **editor**: neovim (custom lua config)
- **terminal**: Foot on personal hosts; Kitty on Awesome/X11
- **browser**: helium
- **secrets**: sops-nix + age on personal hosts only

## Hosts

- **monad:** x86_64 NVIDIA desktop (`hosts/desktop`)
- **arpano:** x86_64 AMD workstation (`hosts/workstation`)
- **argos:** VMware lab guest with Awesome/X11 (`hosts/argos`); real guest hardware configuration is deliberately not supplied

## Use it

```bash
# deploy the main desktop
sudo nixos-rebuild switch --flake .#monad

# deploy the workstation
sudo nixos-rebuild switch --flake .#arpano
```

> Personal hosts retain their existing SOPS/age setup. Argos does not import personal credentials or require their keys.

## Structure

```text
.
├── dotfiles/                 # application configs; Awesome is store-backed
├── home/profiles/            # base, terminal, personal, lab compositions
├── hosts/
│   ├── desktop/              # monad: configuration.nix + home.nix + hardware
│   ├── workstation/          # arpano: configuration.nix + home.nix + hardware
│   └── argos/                # guest composition; supply its own hardware file
├── modules/
│   ├── nixos/                # system policy, accounts, desktop sessions, VMware
│   └── home/                 # programs, desktop configuration, personal features
├── secrets/                  # encrypted personal secrets
├── wallpapers/
└── flake.nix                 # explicit hosts and shared NixOS/Home Manager wiring
```

Each host's `configuration.nix` selects NixOS modules and its own hardware file.
Its `home.nix` independently selects a Home Manager profile and desktop module.
`mkHost` only centralizes the existing Home Manager integration; it does not
discover hosts, infer hardware, or introduce a custom module framework.

Monad and Arpano share `modules/nixos/profiles/personal.nix` and
`home/profiles/personal.nix`. Kernels, GPU settings, hardware, and other
machine-specific policy stay in their host directories. Desktop changes select
the matching system and Home Manager modules rather than changing the terminal
or personal profile.

The Home Manager profiles separate common account defaults (`base`), CLI/editor
tools (`terminal`), personal applications/agents/credentials (`personal`), and
the non-personal lab environment (`lab`). Application leaves do not impose the
personal Git/Jujutsu identity or signing key.

## Argos: fresh VMware installation

Argos is prepared configuration, not a validated VMware deployment. It selects
VMware guest support, Xorg, SDDM, Awesome, PipeWire, NetworkManager, a firewall,
and the lab user environment. It does not select personal credentials, AI-agent
state, gaming, physical GPU configuration, or personal Tailscale trust.

The desktop is deliberately small: nine workspaces, native tiling, a top bar,
Rofi, Kitty, Helium, CopyQ, Picom, screenshots through Scrot/Ksnip, and i3lock.
There is no advanced recorder, scratchpad, resize, or control-menu framework.

Before rebuilding **inside the actual guest**:

1. Commit/push the refactor before cloning it; a clone needs all new modules.
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
sudo nixos-generate-config --show-hardware-config > hosts/argos/hardware-configuration.nix
git add hosts/argos/hardware-configuration.nix

# Build first without changing the installed system.
sudo env NIX_CONFIG='experimental-features = nix-command flakes' \
  nixos-rebuild build --flake .#argos

# Activate only after that guest build succeeds.
sudo env NIX_CONFIG='experimental-features = nix-command flakes' \
  nixos-rebuild switch --flake .#argos
```

The `git add` matters: a local Git-backed flake excludes untracked files.
Never substitute either physical host's hardware file; the guest's root/EFI
UUIDs, storage modules, and architecture must come from that guest.

After the first switch, flakes are enabled by the shared base module, so normal
rebuilds use `sudo nixos-rebuild switch --flake .#argos`. Reboot and verify SDDM,
Awesome login, network, resolution changes, clipboard, sound, and locking on the
actual guest. A successful workstation build cannot establish those properties.
