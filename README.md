# ❄️ Nixconfig

> Modular nixos & home-manager dotfiles. 

A perpetually work-in-progress declarative configuration.

## What it has

- **os**: nixos (unstable) _with separated stable pin_
- **wm**: Mango on personal hosts; bspwm/X11 with sxhkd on Argos; Niri and Hyprland remain opt-in modules
- **shell**: zsh + starship; Nushell remains opt-in
- **editor**: neovim (custom lua config)
- **terminal**: Foot on personal hosts; Kitty on Argos
- **browser**: Helium (default) Firefox (secondary)
- **secrets**: Home Manager sops-nix + age; each host declares its secret source and external key
- **signing**: jj + git commits signed with each host's `~/.ssh/id_ed25519` through gcr-ssh-agent
- OpenPGP is Sequoia's `sq`, no GnuPG

## Hosts

- **monad:** x86_64 NVIDIA desktop (`hosts/monad`)
- **arpano:** x86_64 AMD workstation (`hosts/arpano`)
- **argos:** VMware lab guest with bspwm/X11 (`hosts/argos`); 

> IMPORTANT: Argos hardware configuration must come from that guest and replace the dummy one in `hosts/argos/hardware-configuration.nix`

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
│   ├── monad/                # configuration.nix + home.nix + hardware-configuration.nix
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
Home Manager shell/editor/VCS utilities, including SSH commit signing for Git
and jj. It declares no account, desktop, secrets, Docker, gaming or
coding-agent suite. Hosts declare their account and access groups,
OpenPGP/SSH-agent policy, author identity, secret locations, application choices and machine-specific desktop settings.
Development tools and Pi/OMP/tmux are explicitly selected by every host.

The age key stays outside the repository at
`/home/impuremonad/.config/sops/age/keys.txt`. Builds do not decrypt secrets or
replace account passwords. No unused system-level SOPS defaults are declared.

# Keys and signing

`nixos/security/ssh-agent.nix` runs gcr-ssh-agent: it serves every key in
`~/.ssh` and asks for passphrases graphically.

OpenPGP is handled by Sequoia's `sq` alone (`home/security/sequoia.nix`); GnuPG
and `gpg-agent` are not installed. Certificates live in `~/.local/share/pgp.cert.d`
and secret keys in sq's key store, `~/.local/share/sequoia/keystore`, which asks
for key passwords on the terminal. `~/.config/sequoia/sq/config.toml` is generated
from Nix: new keys and password-only encryption use RFC 9580 (v6), which GnuPG
cannot read. Run `sq config inspect paths` to see the files in use.

Git (`home/programs/git.nix`) and jj (`home/programs/jujutsu.nix`) sign every
commit with `~/.ssh/id_ed25519.pub`. Before the first rebuild on a host:

# Networking

## Tor Network

`nixos/networking/tor.nix` installs Tor Browser, ProxyChains-NG (`proxychains4`)
and `torsocks`. NixOS manages `tor.service` and generates `/etc/proxychains.conf`—do not
edit either configuration by hand.

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
security tools to work through it. The daemon enables `SafeSocks` to reject
potentially unsafe locally resolved requests (including some IP-only requests);
use hostnames and remote DNS rather than disabling that protection. This cannot
undo a DNS lookup an application already made. Avoid torrents, keep HTTPS enabled,
and do not assume Tor conceals personal logins or application identifiers. Private
VPN lab targets should use the lab VPN directly, not public Tor exits; only test
systems you have permission to assess.

# Themes

## Oxocarbon dark

The theme is configured per application; there is no global theming framework.
`home/themes/oxocarbon.nix` holds the [official dark palette](https://github.com/nyoom-engineering/base16-oxocarbon)
for native Nix themes. Existing fonts, transparency, layouts and keybindings are retained.

| Application | Integration |
| --- | --- |
| Neovim / lualine | Official [`oxocarbon.nvim`](https://github.com/nyoom-engineering/oxocarbon.nvim), pinned in `dotfiles/nvim/lazy-lock.json` |
| Kitty / Foot / Helix | Commit- and hash-pinned community ports linked by the [upstream ports catalog](https://github.com/nyoom-engineering/oxocarbon), fetched by each program module |
| bat | Pinned Carbonizer TextMate theme; Home Manager rebuilds bat's theme cache at activation |
| Yazi / tuicr | Native Nix-defined UI themes and the same TextMate theme for code previews |
| Dolphin / Qt | Generated `OxocarbonDark.colors` and a matching qt6ct palette in `home/programs/dolphin.nix` |
| Herdr | All custom color tokens merged in `home/programs/herdr.nix`; non-theme preferences remain in `dotfiles/herdr/config.toml` |
| tmux | Native styling in `home/programs/tmux.nix`; avoids the upstream port's tmux 3.5 incompatibility and preserves Continuum's autosave hook |
| Noctalia | Existing Oxocarbon community palette; GTK, btop and enabled community templates follow it |
| Desktop accents | Mango, BSPWM, opt-in Niri/Hyprland, Dunst, Polybar, Rofi and i3lock |
