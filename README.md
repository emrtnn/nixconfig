# ❄️Nixconfig

> My personal nixos & home-manager dotfiles. 

A perpetually work-in-progress declarative configuration.

## What it has

- **os**: nixos (unstable + stable pin)
- **wm**: mango / niri / hyprland (pick your favorite by changing one line)
- **shell**: nushell & zsh + starship
- **editor**: neovim (custom lua config)
- **terminal**: foot
- **browser**: helium
- **secrets**: sops-nix + age

## Hosts

- **monad:** x86_64 desktop configuration
- **arpano:** ARM workstation

## Use it

```bash
# deploy the main desktop
sudo nixos-rebuild switch --flake .#monad

# deploy the workstation
sudo nixos-rebuild switch --flake .#arpano
```

> Note: requires proper sops and age keys set up in ~/.config/sops/age/keys.txt to decrypt secrets.yaml

## Structure

```text
.
├── dotfiles/       # standard config files symlinked through home-manager's mkOutOfStoreSymLink to enable hot reload (nvim, niri, hypr, pi agent)
├── home/           # home-manager configs (user-specific packages & theming)
├── hosts/          # machine-specific configurations
│   ├── desktop     # `monad`
│   └── workstation # `arpano`
├── modules/        # reusable nix modules
│   ├── desktop     # compositor configs, noctalia, swappy
│   └── programs    # cli tools, editors, browsers
├── secrets/        # encrypted secrets (sops)
├── wallpapers/     # everforest/dark aesthetics
└── flake.nix       # entrypoint
```
