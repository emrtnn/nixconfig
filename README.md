# ❄️ Nixconfig

> Modular nixos & home-manager dotfiles, in the dendritic layout.

A perpetually work-in-progress declarative configuration.

## What it has

- **os**: nixos (unstable)
- **layout**: dendritic: flake-parts + import-tree, one file per feature under `modules/`
- **wm**: Mango on personal hosts; bspwm/X11 with sxhkd on Argos; Niri and Hyprland remain opt-in modules
- **shell**: zsh + starship; Nushell remains opt-in
- **editor**: neovim (custom lua config)
- **terminal**: Foot on personal hosts; Kitty on Argos
- **browser**: LibreWolf (default) Helium (secondary, the Chromium for tools that need one)
- **secrets**: Home Manager sops-nix + age; one shared secret file and an external key (`modules/security/sops.nix`)
- **signing**: jj + git commits signed with each host's `~/.ssh/id_ed25519` through gcr-ssh-agent
- OpenPGP is Sequoia's `sq`, no GnuPG

## Hosts

- **monad:** x86_64 NVIDIA desktop (`modules/hosts/monad`)
- **arpano:** x86_64 AMD workstation, work-only (`modules/hosts/arpano`)
- **argos:** VMware lab guest with bspwm/X11 (`modules/hosts/argos`)

> IMPORTANT: Argos hardware configuration must come from that guest and replace the dummy one in `modules/hosts/argos/_hardware.nix`

## Use it

```bash
# deploy the main desktop
sudo nixos-rebuild switch --flake .#monad

# deploy the workstation
sudo nixos-rebuild switch --flake .#arpano

# deploy the virtual machine
sudo nixos-rebuild switch --flake .#argos
```

> NOTE: Neovim, Mango, Niri and Hyprland configs are out-of-store symlinks into
> `~/nixconfig/modules/…`, so edits apply without a rebuild. They assume the
> repository is cloned at `~/nixconfig`; anywhere else those links dangle.

## Structure

```text
.
├── flake.nix                 # inputs; outputs = flake-parts + import-tree ./modules
├── modules/                  # every .nix file here is a flake-parts module
│   ├── flake-parts.nix       # flakeModules.modules, systems
│   ├── aggregates.nix        # the list of module names (the only place)
│   ├── theme/                # caelus.nix (theme option), _palette.nix, _tmtheme.nix
│   ├── base/                 # nix, locale, cli, home-manager, session
│   ├── users/                # impuremonad.nix: account, HM user, author identity
│   ├── audio/                # pipewire.nix
│   ├── boot/                 # plymouth.nix, limine.nix
│   ├── desktop/              # session-support, fonts, appearance, wallpapers, silent-sddm
│   │   ├── mango/            # mango, foot, noctalia, satty + dotfiles/{mango,xdg-desktop-portal}/
│   │   ├── bspwm/            # bspwm, kitty + dotfiles/{argos,bspwm,polybar,rofi,sxhkd}/
│   │   ├── niri/             # niri.nix + dotfiles/
│   │   └── hyprland/         # hyprland.nix + dotfiles/
│   ├── gaming/               # gaming.nix
│   ├── hardware/             # nvidia, amd-rocm, amd-cpu, printing, bluetooth
│   ├── networking/           # openvpn, tor, proxychains, syncthing, quad9, firewall, hosts-file
│   ├── programs/             # one file per program, e.g. git.nix, tmux.nix, yazi.nix
│   │   ├── bat/ glow/ herdr/ librewolf/ tuicr/   # <name>.nix + dotfiles/
│   │   └── nvim/             # nvim.nix, _toolchain.nix, dotfiles/
│   ├── security/             # gnome-keyring, ssh-agent, sops, keepass
│   ├── services/             # openssh, tailscale
│   ├── system/               # zram, auto-upgrade
│   ├── virtualisation/       # docker, libvirt, vmware-guest
│   └── hosts/
│       ├── monad/            # monad.nix + _hardware.nix
│       ├── arpano/           # arpano.nix + _hardware.nix
│       └── argos/            # argos.nix + _hardware.nix
├── assets/                   # account picture
├── secrets/                  # encrypted personal secrets
├── wallpapers/
└── scripts/fix-urls.sh
```

The age key stays outside the repository at
`/home/impuremonad/.config/sops/age/keys.txt`. Builds do not decrypt secrets or
replace account passwords. No unused system-level SOPS defaults are declared.

## How it works

`flake.nix` only declares inputs. Its outputs are
`inputs.flake-parts.lib.mkFlake {inherit inputs;} (inputs.import-tree ./modules)`:
import-tree loads every `.nix` file under `modules/` as a flake-parts module,
skipping any path that contains `/_`. Nothing is imported by hand.

`modules/flake-parts.nix` enables flake-parts' `flakeModules.modules`. Feature
files then add their settings to a small, fixed set of names:

- `flake.modules.nixos.<name>`: a NixOS module
- `flake.modules.homeManager.<name>`: a Home Manager module

Every file that writes to the same name is merged into that one module. A
feature keeps both halves (and its dotfiles) in one place, for example
`modules/desktop/mango/mango.nix` sets `nixos.mango` and `homeManager.mango`.
Modules are stamped with their class, so loading a Home Manager module into
NixOS (or the reverse) is an evaluation error.

| Kind | Names |
| --- | --- |
| Profiles | `base`, `desktop`, `workstation` |
| Window managers | `mango`, `bspwm`, `niri`, `hyprland` |
| Features | `gaming`, `helix`, `herdr`, `nushell`, `fastfetch` |
| Hardware | `nvidia`, `amd-rocm`, `printing`, `bluetooth`, `vmware-guest` |
| Hosts | `monad`, `arpano`, `argos` |

- `base`: on every host; Nix, locale, the account, shell, editor and VCS.
- `desktop`: on every host; the graphical session, apps, Tor, secrets.
- `workstation`: monad and arpano only.
- `niri`, `hyprland`, `helix`, `herdr`, `nushell` and `fastfetch` are opt-in:
  no host lists them, but they still evaluate.

`modules/aggregates.nix` holds the list of names. It declares every name on
both sides and makes each NixOS name add its Home Manager half to
`home-manager.sharedModules`. A host therefore lists NixOS names only: listing
`mango` brings in `homeManager.mango` for the user as well.

The theme is a top-level flake-parts option. `modules/theme/caelus.nix`
declares `theme` and sets `config.theme.caelus` (the palette, from
`_palette.nix`) and `config.theme.caelusTmTheme` (a function of `pkgs`, from
`_tmtheme.nix`). Feature files read it from the outer, flake-parts `config`:

```nix
# modules/programs/tuicr/tuicr.nix
{config, ...}: let
  c = config.theme.caelus; # top-level config, bound outside
  tmTheme = config.theme.caelusTmTheme;
in {
  flake.modules.homeManager.base = {pkgs, ...}: {
    # this inner module has its own config; it uses c and tmTheme
    xdg.configFile."tuicr/themes/caelus.tmTheme".source = tmTheme pkgs;
  };
}
```

## Host compositions

Each host file builds its system with `inputs.nixpkgs.lib.nixosSystem` from a
list of names, with no `specialArgs`:

| Host | `modules = with config.flake.modules.nixos; [ … ]` |
| --- | --- |
| monad | `base desktop workstation mango gaming nvidia monad` |
| arpano | `base desktop workstation mango amd-rocm printing bluetooth arpano` |
| argos | `base desktop bspwm vmware-guest argos` |

The last name is the host itself: `nixos.<host>` imports `./_hardware.nix` and
holds the hostname, `system.stateVersion` and host-only settings;
`homeManager.<host>` holds `home.stateVersion` and host-only home settings.

## Adding a feature

Add a file under `modules/` that writes to an existing name. No import list
needs editing:

```nix
# modules/programs/foo.nix
{
  flake.modules.homeManager.desktop = {pkgs, ...}: {
    home.packages = [pkgs.foo];
  };
}
```

- Pick the name by where it should apply: `base` or `desktop` for every host,
  `workstation` for monad and arpano, or a host name for one host.
- A feature with config files gets a directory:
  `modules/programs/foo/foo.nix` plus `modules/programs/foo/dotfiles/`,
  referenced as `./dotfiles/<file>`.
- External modules are imported in place, e.g.
  `imports = [inputs.<input>.homeManagerModules.<module>];`, with `inputs`
  taken from the file's own arguments.
- `git add` new files before evaluating: flakes ignore untracked files.

## Adding a host

1. Create `modules/hosts/<host>/_hardware.nix` from `nixos-generate-config` on
   the machine.
2. Create `modules/hosts/<host>/<host>.nix`:

   ```nix
   {config, inputs, ...}: {
     flake.nixosConfigurations.<host> = inputs.nixpkgs.lib.nixosSystem {
       modules = with config.flake.modules.nixos; [base desktop <host>];
     };

     flake.modules.nixos.<host> = {
       imports = [./_hardware.nix];
       networking.hostName = "<host>";
       system.stateVersion = "…";
     };

     flake.modules.homeManager.<host> = {
       home.stateVersion = "…";
     };
   }
   ```

3. Add `"<host>"` to the `names` list in `modules/aggregates.nix`. New names
   are only ever added there.
4. `git add modules/hosts/<host>`, then `sudo nixos-rebuild switch --flake .#<host>`.

## Conventions

1. **`_` prefix for non-modules.** Data, functions and hardware configs under
   `modules/` start with `_`; import-tree skips them.
2. **Only `modules/aggregates.nix` and `modules/hosts/*/*.nix` reference
   `config.flake.modules`.** Feature files never import other named modules:
   there is no module `key`, so a module reached twice is applied twice (lists
   duplicate, `lines` repeat). External modules (`inputs.<x>.nixosModules.*`,
   `homeManagerModules.*`) are fine.
3. **Keep the two `config`s apart.** Bind top-level values in a `let` outside
   the inner module; the inner module takes its own `{config, pkgs, lib, ...}`.
4. **No `specialArgs` or `extraSpecialArgs`, no `enable` options.** Inner
   modules close over the file's `inputs`; listing a name enables it.
5. **Dotfiles live in `<feature>/dotfiles/`**, never with `.nix` files in it.
   Keep file and directory basenames: store paths depend on them. Multi-app
   features keep one subdirectory per app.
6. **Deduplicate only identical settings**, compared by evaluated value
   (`nix eval`), not by spelling. Shared by all three hosts: `base` (system,
   account) or `desktop` (GUI, session, apps); by monad and arpano: `workstation`.
   Differing values and every `stateVersion` stay in the host file. Keep
   priority wrappers (`lib.mkBefore`, `lib.mkAfter`) when moving a setting.
7. **Git hygiene.** Move files with `git mv` in a commit of their own, so
   `git log --follow` works; `git add` before evaluating; format with
   `alejandra`.

**arpano is work-only.** It never gets `gaming`: an assertion in
`modules/hosts/arpano/arpano.nix` fails evaluation if Steam or GameMode is
enabled.

# Keys and signing

`modules/security/ssh-agent.nix` runs gcr-ssh-agent: it serves every key in
`~/.ssh` and asks for passphrases graphically.

OpenPGP is handled by Sequoia's `sq` alone (`sequoia-sq` in
`modules/programs/desktop-apps.nix`); GnuPG and `gpg-agent` are not installed.
Certificates live in `~/.local/share/pgp.cert.d` and secret keys in sq's key
store, `~/.local/share/sequoia/keystore`, which asks for key passwords on the
terminal. This repository does not manage sq's configuration. Run
`sq config inspect paths` to see the files in use.

Git (`modules/programs/git.nix`) and jj (`modules/programs/jujutsu.nix`) sign every
commit with `~/.ssh/id_ed25519.pub`.

# Networking

## Tor Network

`modules/networking/tor.nix` installs Tor Browser and `torsocks`, and
`modules/networking/proxychains.nix` ProxyChains-NG (`proxychains4`). NixOS
manages `tor.service` and generates `/etc/proxychains.conf`—do not edit either
configuration by hand.

The system Tor daemon is a **client only**, listening on `127.0.0.1:9050`.
It does not run a relay/exit node, expose a control port, open firewall ports,
change system DNS, or transparently route the machine's traffic. ProxyChains
uses a strict, single SOCKS5 hop with proxied DNS; intercepted connections fail
if Tor is unavailable rather than falling back to a direct connection. Its
NixOS default loopback exception remains in place for local services.

#### Wait for "Bootstrapped 100%" before testing.
systemctl status tor
journalctl -u tor -b --no-pager

#### Browsing: launch directly, not through proxychains/torsocks.
tor-browser

#### CLI: explicitly select the declarative config, avoiding per-user overrides.
proxychains4 -f /etc/proxychains.conf curl https://check.torproject.org/api/ip

#### Tor-specific wrapper (default endpoint is 127.0.0.1:9050).
torsocks curl https://check.torproject.org/api/ip

#### Prefer native SOCKS support when available; socks5h resolves names via Tor.

> IMPORTANT: the 'h' is crucial or you'll send the IP to the proxy, with the 'h' the proxy itself will resolve the DNS

curl --proxy socks5h://127.0.0.1:9050 https://check.torproject.org/api/ip

### Limits
These wrappers are not a VPN, sandbox, or kill switch. They rely on
library interception and cannot reliably cover static binaries, raw sockets,
privileged programs, or applications with their own networking implementations.
Tor carries TCP, not UDP/ICMP: do not expect ping, SYN/UDP scans, or arbitrary
security tools to work through it. `SafeSocks` is disabled (Telegram connects to
its servers by raw IP), so the daemon accepts locally resolved, IP-only requests
without rejecting or warning about them; use hostnames and remote DNS (socks5h,
torsocks) so names are resolved through Tor. Nothing can undo a DNS lookup an
application already made. Avoid torrents, keep HTTPS enabled,
and do not assume Tor conceals personal logins or application identifiers. Private
VPN lab targets should use the lab VPN directly, not public Tor exits; only test
systems you have permission to assess.

# Themes

## Caelus

The theme is configured per application; there is no global theming framework.
`modules/theme/_palette.nix` holds the palette, exposed to every module as
`config.theme.caelus` by `modules/theme/caelus.nix`: warm cream (`#f4decd`) on near-black
(`#0f0f0f`) with a saturated orange accent (`#ef934d`), green-tinted greys and a
muted 16-color terminal palette. The colors come from dacctal's
[caelus](https://git.symlinx.net/daccfiles); the syntax roles, UI mappings and
diff tints are local. Existing fonts, transparency, layouts and keybindings are retained.

Syntax roles are shared by every highlighter: keywords orange, functions yellow,
strings green, types cyan, numbers/constants magenta, modules blue, fields light
blue, builtins light red, operators grey, comments italic grey.

| Application | Integration |
| --- | --- |
| Neovim / lualine | Local colorscheme `modules/programs/nvim/dotfiles/colors/caelus.lua` (treesitter, LSP and plugin groups) and `lua/lualine/themes/caelus.lua` |
| Kitty / Foot | Native colors generated from the palette in `modules/desktop/bspwm/kitty.nix` and `modules/desktop/mango/foot.nix` |
| Helix | Native `caelus` theme in `modules/programs/helix.nix` |
| bat / Yazi / tuicr | TextMate theme generated by `modules/theme/_tmtheme.nix` (`config.theme.caelusTmTheme`); Yazi and tuicr UI themes are native Nix |
| Dolphin / Qt | Generated `Caelus.colors` and a matching qt6ct palette in `modules/programs/dolphin.nix` |
| Herdr | All custom color tokens merged in `modules/programs/herdr/herdr.nix`; non-theme preferences remain in `modules/programs/herdr/dotfiles/config.toml` |
| tmux | Native styling in `modules/programs/tmux.nix`; preserves Continuum's autosave hook |
| Noctalia | Custom palette `~/.config/noctalia/palettes/Caelus.json` generated in `modules/desktop/mango/noctalia.nix`; GTK, btop and enabled community templates follow it |
| LibreWolf | `modules/programs/librewolf/dotfiles/chrome/*.css` (hand-copied palette) |
| Desktop accents | Mango, BSPWM, opt-in Niri/Hyprland, Dunst, Polybar, Rofi and i3lock |

Files that cannot import Nix (Neovim, LibreWolf CSS, Mango, Niri, Hyprland,
Polybar, Rofi) carry hand-copied hex values; keep them in sync with the palette.
