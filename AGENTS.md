# Repository Guidelines

## Project Structure & Module Organization
This repository is a flake-based NixOS and Home Manager setup for two machines: `monad` and `arpano`. Host-specific system definitions live under `hosts/desktop` and `hosts/workstation`. Reusable NixOS and Home Manager modules live in `modules/desktop` and `modules/programs`. The shared user profile is [home/desktop.nix](/home/impuremonad/nixconfig/home/desktop.nix). Custom packages belong in `pkgs/`, while UI assets and linked config trees live in `assets/`, `wallpapers/`, and `dotfiles/`.

## Build, Test, and Development Commands
Use flake-aware Nix commands from the repo root:

- `nix flake check` validates the flake and catches evaluation errors early.
- `nix build .#nixosConfigurations.monad.config.system.build.toplevel` builds the desktop host without switching.
- `nix build .#nixosConfigurations.arpano.config.system.build.toplevel` builds the workstation host.
- `sudo nixos-rebuild switch --flake .#monad` applies the desktop configuration locally.
- `sudo nixos-rebuild switch --flake .#arpano` applies the workstation configuration locally.

If you need a shell with project tooling, use `nix develop` when available in your environment.

## Coding Style & Naming Conventions
Write Nix in the existing style: two-space indentation, trailing semicolons, and compact attribute sets unless readability suffers. Keep modules focused and name them after the feature they configure, for example `modules/programs/git.nix` or `modules/desktop/niri.nix`. Prefer lowercase, hyphen-free file names matching the exported concern. Follow current comments and avoid adding noise.

## Testing Guidelines
There is no separate unit test suite here; validation is evaluation- and build-based. Run `nix flake check` before opening a PR, then build the affected host output. When changing linked configs under `dotfiles/`, also verify the target program starts cleanly after a rebuild.

## Commit & Pull Request Guidelines
Recent history uses short, imperative commit subjects such as `Add UV to facilitate desktop level scripting` and `Change git config`. Keep commits scoped to one concern. PRs should state which host or module was changed, list the commands used for validation, and include screenshots only for visible UI changes such as Hyprland, Niri, or Quickshell updates.

## Configuration Notes
`home/desktop.nix` links `dotfiles/hypr`, `dotfiles/niri`, and `dotfiles/quickshell` out of store. Treat edits there as live configuration changes and keep paths valid for `/home/impuremonad`.
