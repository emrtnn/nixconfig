# nixconfig

Personal flake-based NixOS configuration for two machines, with Home Manager managing the user environment and desktop tooling. The setup centers on Wayland, a shared user profile, and a desktop stack that makes it easy to switch between Hyprland and Niri while keeping the rest of the system configuration stable. A small custom package overlay is used for local additions such as `helium`.

## Layout

- `flake.nix` defines inputs, overlays, and the exported host configurations.
- `hosts/desktop` contains the `monad` system configuration.
- `hosts/workstation` contains the `arpano` system configuration.
- `home/desktop.nix` is the shared Home Manager profile used by both hosts.
- `modules/desktop` and `modules/programs` hold reusable modules.
- `pkgs/helium.nix` packages a local AppImage-based browser derivation.
- `dotfiles/` contains out-of-store config trees for Hyprland, Niri, and Quickshell.
- `assets/` and `wallpapers/` store profile assets and desktop backgrounds.

## Hosts

`monad` is the desktop-oriented host with NVIDIA-specific settings and a tighter boot generation limit. `arpano` is the workstation host with AMD graphics, printer support, Bluetooth, and a few power-management adjustments. Both hosts import the same Home Manager profile and common desktop module stack, so compositor-specific work can stay isolated to the Hyprland and Niri config trees.

## Common Commands

```bash
nix flake check
nix build .#nixosConfigurations.monad.config.system.build.toplevel
nix build .#nixosConfigurations.arpano.config.system.build.toplevel
sudo nixos-rebuild switch --flake .#monad
sudo nixos-rebuild switch --flake .#arpano
```

Use builds to validate changes before switching. For module-level edits, start with `nix flake check`; for host-specific changes, build the corresponding output.

## Notes

The Home Manager profile links `dotfiles/hypr`, `dotfiles/niri`, and `dotfiles/quickshell` directly from this repository into `$XDG_CONFIG_HOME`. Changes in those directories are not copied into the Nix store, so broken paths or syntax errors will surface immediately in the live desktop session after a rebuild.
