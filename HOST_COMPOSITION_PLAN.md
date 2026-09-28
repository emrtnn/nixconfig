# NixOS host composition refactor

## Context
Refactor the three-host NixOS configuration into `hosts/`, `nixos/`, `home/`, and `base/`, with explicit independent host compositions and reusable feature modules. The goal is ownership by behavior, not unique filenames: host policy belongs in each host's configuration, universal utilities in one base composition, and optional system/user features in their respective module trees. Preserve configured behavior unless a change is explicitly required by the refactor.

## Confirmed findings
- `flake.nix` exposes `nixosConfigurations.monad`, `.arpano`, and `.argos`; `mkHost` accepts separate `nixosModule`/`homeModule` arguments and wires Home Manager for `impuremonad`. LSP found exactly its three calls in `flake.nix` (lines 87, 92, 97).
- Current host directories are `hosts/desktop`, `hosts/workstation`, and `hosts/argos`. Every host has a populated hardware file declaring `x86_64-linux`; preserve its UUIDs, filesystems, swap, kernel modules, and microcode defaults. Arpano is AMD x86_64, not an ARM target.
- Read-only-mode evaluation returned Monad/Arpano hostname, architecture, and state version. Argos failed with `function 'anonymous lambda' called with unexpected argument 'config'` at its `{pkgs}:` module header. Nix was available at version 2.34.8. This was not a complete system build.
- System state versions: Monad/Arpano `"25.11"`, Argos `"26.11"`. Home Manager state version: `"26.05"` on all three.
- `home/profiles/personal.nix` supplies keyring, personal applications, OnlyOffice, and Jujutsu signing (`197CB7FC535093C4`) to Monad/Arpano. `home/profiles/lab.nix` supplies `tree` and Evince PDF handling to Argos without signing. Both profiles include hacking tools, AI tools, and credentials.
- System `sops` imports/defaults on Monad/Arpano declare no system secrets and reference nonexistent host-local `./secrets/secrets.yaml`. Actual consumption is Home Manager's `brave_api_key` from root `secrets/secrets.yaml`. `.sops.yaml` already includes all three recipients.
- Argos puts `pinentryPackage` inside raw `programs.gnupg.agent.settings`, while the bspwm module selects `pkgs.pinentry-qt` through the proper option. The locked NixOS GnuPG module serializes `settings` into `gpg-agent.conf`; `pinentryPackage` is a sibling option, not a valid raw setting.

## Approach

### 1. Establish the behavior baseline and fix the two broken declarations
Before moving modules, capture the verification projections below for Monad and Arpano. Record the existing Argos evaluation failure; then change `hosts/argos/configuration.nix` to `{pkgs, ...}:`, remove `settings.pinentryPackage`, and leave its currently selected Qt pinentry in the bspwm module until the ownership cutover. Capture the now-evaluable Argos baseline. These are correctness repairs, not a desktop change.

Do not upgrade `flake.lock`, change package versions, switch sessions, generate hardware files, or activate the running system. Stage the new definitions in steps 2–4 without changing the live import graph, then switch all three hosts and delete their obsolete sources together in step 5. Steps 2–4 are independent extractions; the final cutover depends on all three.

### 2. Build one universal base without a second profile hierarchy
Create `base/base.nix` as a NixOS module importing exactly `./nix.nix`, `./locale.nix`, `./cli.nix`, and `./home-manager.nix`. All new base modules are extractions of existing settings, not a custom option framework.

| New owner | Exact source and behavior |
| --- | --- |
| `base/nix.nix` | Move `nixpkgs.config.allowUnfree` and the entire `nix` block from `modules/nixos/profiles/base.nix`: GC, store optimization, flakes, caches and trusted keys unchanged. |
| `base/locale.nix` | Move its timezone and complete `i18n` block unchanged. These are the existing common locale choices for these three hosts. |
| `base/cli.nix` | Move system Zsh enablement, plocate, and the complete `lib.mkBefore` system package list from that file. |
| `base/home-manager.nix` | Import `inputs.home-manager.nixosModules.home-manager`; preserve `useGlobalPkgs = true`, `useUserPackages = true`, `extraSpecialArgs = { inherit inputs; }`, `backupFileExtension = "backup"`, and `overwriteBackup = true` from the flake. Set the exact shared Home Manager module list below, without declaring any user. |
| `home/session.nix` | Extract only `xdg.enable = true` and `systemd.user.sessionVariables = config.home.sessionVariables` from `home/profiles/base.nix`. |
| `home/cli.nix` | Extract packages `lazygit ripgrep fd dnsutils duckdb btop gh unzip file jq` from `home/profiles/terminal.nix`. These are the unconfigured common CLI utilities; do not create a file per bare package. |
| `home/programs/bat.nix`, `glow.nix`, `tuicr.nix` | Each owns its corresponding package plus its existing `xdg.configFile` source from the terminal profile. Use `../../dotfiles/bat/config`, `../../dotfiles/glow/glow.yml`, and `../../dotfiles/tuicr/config.toml`. |
| `home/development.nix` | Extract the remaining terminal-profile packages `devenv uv python3 ninja`. Every current host explicitly selects this feature; it is not an implicit shell dependency. |

`base/home-manager.nix` sets `home-manager.sharedModules` to `../home/session.nix`, `../home/cli.nix`, and `../home/programs/{bat,glow,tuicr,carapace,starship,yazi,zoxide,git,zsh,fzf,jujutsu,nvim}.nix` as an explicit list, not a glob. Preserve the existing bodies of the nine established program modules. Base contains no account identity, secrets, signing, GPG agent, desktop, GPU, gaming, Docker, hacking tools, or coding-agent suite. Common Home Manager utilities are installed when a host declares its user.

### 3. Extract cohesive system features and expose host policy
Move the following feature definitions into `nixos/`. Preserve every option value unless this table explicitly relocates ownership.

| Source responsibility | Destination and decision |
| --- | --- |
| `modules/nixos/desktop/base.nix`: graphics, dconf, GVFS | `nixos/desktop/session-support.nix`; this is graphical application infrastructure, not universal base. |
| Same file: PipeWire/ALSA/Pulse | `nixos/audio/pipewire.nix`; retain all three enablements. JACK stays host-selected; 32-bit compatibility moves with gaming. |
| Same file: GNOME keyring | `nixos/security/gnome-keyring.nix`; a selectable secret-service provider, not an account/signing module. |
| `modules/nixos/desktop/fonts.nix` | `nixos/desktop/fonts.nix`; retain the exact font list. Give that explicit collection `lib.mkAfter` ordering so SilentSDDM's font directory remains before it without import-depth tricks. |
| `modules/nixos/profiles/gaming.nix` | `nixos/programs/gaming.nix`; retain Steam/GameMode/packages/firewall settings. Also own `hardware.graphics.enable32Bit = true` and `services.pipewire.alsa.support32Bit = true` from personal policy as gaming compatibility. No user group grants here. |
| `modules/nixos/profiles/security-lab.nix` | `nixos/programs/wireshark.nix`; retain Wireshark enablement/package only. SSH-agent policy and account access are not packet-capture settings. |
| `modules/nixos/virtualisation/docker.nix` | `nixos/virtualisation/docker.nix`; retain Docker and `docker0` TCP `[80 443]`, move the user grant to each host. |
| `modules/nixos/virtualisation/vmware-guest.nix` | `nixos/virtualisation/vmware-guest.nix`; preserve guest/headless settings and architecture-conditional driver expression. |
| `modules/nixos/desktop/{mango,niri,hyprland}.nix` | Corresponding `nixos/desktop/` paths; preserve upstream imports, compositor/session/portal settings and GPU Screen Recorder. Niri/Hyprland remain unselected, not deleted. |
| `modules/nixos/desktop/bspwm.nix` | `nixos/desktop/bspwm.nix`; preserve Xorg/BSPWM/XKB/polkit/i3lock/portals. Move its entire display-manager block and GPG-agent block into Argos configuration, removing `lib.mkForce` pinentry ownership from the desktop module. |
| `personal.nix`: quiet kernel parameters, initrd, console, Plymouth | `nixos/boot/quiet-boot.nix`; move the full boot block except `boot.loader`, preserving `lib.mkBefore`, font path, theme and theme override. |
| `personal.nix`: `zramSwap` | `nixos/system/zram.nix`; retain enabled, `zstd`, and `memoryPercent = 100`. |
| `personal.nix`: NetworkManager/Quad9/resolved | `nixos/networking/quad9.nix`; move NetworkManager enable/dns/insertNameservers, global nameservers, and the entire resolved block. Wi-Fi powersaving remains explicit host policy. |
| `personal.nix`: Tailscale/firewall integration | `nixos/services/tailscale.nix`; retain service enablement, trusted `tailscale0`, UDP 41641. General firewall enablement stays in each host. |
| `personal.nix`: OpenSSH | `nixos/services/openssh.nix`; retain enablement, `PermitRootLogin = "no"`, `PasswordAuthentication = false`. |
| `personal.nix`: LocalSend | `nixos/programs/localsend.nix`; retain enablement and firewall opening. |
| `personal.nix`: SilentSDDM | `nixos/desktop/silent-sddm.nix`; import `inputs.silentSDDM.nixosModules.default` directly, retain enable/default theme. SDDM backend selection and `profileIcons.impuremonad` belong to host configuration. Do not retain the old artificial nested import. |

The remainder of `modules/nixos/profiles/personal.nix` becomes explicit host policy: loader selection, firewall enablement, Wi-Fi power saving, AMD microcode, PipeWire JACK, GPG/SSH-agent selection, account groups, weekly system upgrades, and login icon. Remove the unused system SOPS integration/defaults instead of inventing system secret consumers. Preserve Home Manager SOPS consumption in step 4.

### 4. Replace Home Manager roles with reusable tools plus host choices
Move every existing `modules/home/programs/*.nix` to `home/programs/` with its name and body unchanged unless an explicit extraction below applies. This includes the currently unselected `fastfetch`, `helix`, `nushell`, and `tmux`; do not activate them. Keep Git/Jujutsu defaults separate from author/signing policy. The large Helix/tmux/Zsh configurations remain cohesive application modules, not one file per setting.

| Current owner | New owner and exact split |
| --- | --- |
| `modules/home/desktop/browser.nix` | `home/programs/helium.nix`; keep its input-supplied package, `BROWSER`, and full MIME associations/defaults. |
| `modules/home/desktop/apps.nix` | Extract `imv` and its complete image MIME mapping into `home/programs/imv.nix`. Put bare packages `nautilus evince ffmpeg playerctl` in each host's `home.packages`. Delete the generic apps bundle. |
| `modules/home/personal/personal-apps.nix` | Delete it. Monad/Arpano explicitly import `home/programs/onlyoffice.nix` and list `obsidian firefox telegram-desktop mpv vesktop stremio-linux-shell` in their host `home.packages`; their `CHROME_PATH = "${pkgs.google-chrome}/bin/google-chrome"` stays in host policy. Preserve OnlyOffice's existing PDF default. |
| `modules/home/personal/agents.nix` | Delete it. Move Herdr package/config into `home/programs/herdr.nix` using `../../dotfiles/herdr/config.toml`. Move the `.pi` out-of-store link into existing `home/programs/pi.nix`; each host selects Pi, oh-my-pi, and Herdr explicitly. Keep Pi's Node 26/pnpm and all OMP model/settings values. |
| `modules/home/personal/credentials.nix` | Delete it. `home/security/sops.nix` owns only the upstream Home Manager SOPS import and `sops`/`age` packages. `home/security/password-store.nix` owns the current `pass.withExtensions (exts: [exts.pass-otp])` package. All secret names/source/key locations and the Brave environment variable move to each host's `home.nix`. No new fallback key, secret copy, or decryption during builds. |
| `modules/home/desktop/appearance.nix` | `home/desktop/appearance.nix` keeps GTK/Qt/cursor/dconf appearance. Extract `Pictures/Wallpapers` into `home/desktop/wallpapers.nix` with `../../wallpapers`. Move `.face.png` to each host's `home.nix` with `../../assets/.face`. |
| `modules/home/desktop/{keyring,mango,niri,hyprland,noctalia,swappy}.nix` | Move to matching `home/desktop/` paths, retaining session/tool dependencies and settings. Correct source-relative paths. Mango still imports Foot/Noctalia/Swappy; optional Niri retains `programs.niri.config = null`. |
| Noctalia's machine/account data | Move `programs.noctalia.settings.location`, the entire `lockscreen_widgets` subtree, `shell.avatar_path`, `wallpaper.directory`, and `plugins.source` to both Monad/Arpano `home.nix` verbatim. Keep their present DP-1 IDs/coordinates, Granada location, avatar path, wallpaper path, and all three plugin source entries. The remaining  application UI/theme/plugin settings stay together in `home/desktop/noctalia.nix`. Do not infer different monitors or fix user preferences during a structural move. |
| `modules/home/desktop/bspwm.nix` | Move to `home/desktop/bspwm.nix` as the cohesive X11 desktop integration (session, Kitty, shortcuts, bar, launcher, clipboard, locking, screenshot and Argos helper executables). Keep the scripts/runtime dependency closures and service overrides intact. Pull only `google-chrome` and `telegram-desktop` out to Argos's host package list: those are application choices, not X11 infrastructure. |

The existing bspwm helper suite is mutually wired by `sxhkdrc`, `bspwmrc`, Polybar and the Argos menu; keep that working integration rather than introducing a new package framework or one module per generated command. Keep all dotfile contents unchanged. Only module source references move.

For every moved Home Manager file at `home/programs/`, `home/security/`, or `home/desktop/`, a repository-root source now uses `../../...` rather than `../../../...`. This covers BSPWM's eight `dotfiles/` references, Mango's portal file, Herdr, wallpapers, and assets. The terminal-derived Bat/Glow/Tuicr leaves also use `../../dotfiles/...`. Preserve store-backed source/readFile semantics. Change absolute mutable link prefixes to `"${config.home.homeDirectory}/nixconfig/dotfiles/<name>"` for Pi, Mango, Niri, and Hyprland; their effective paths and out-of-store behavior remain unchanged, as does Neovim's existing expression.

### 5. Cut over three independent host compositions
Move `hosts/desktop` to `hosts/monad` and `hosts/workstation` to `hosts/arpano`; retain `hosts/argos`. Each contains exactly the composition files `configuration.nix`, `hardware-conf.nix`, and `home.nix`. Rename the existing hardware file; do not regenerate or alter its body. No additional host `modules.nix` is needed: `configuration.nix` already has the explicit system import list and `home.nix` is the explicit user composition.

Every `configuration.nix` imports `./hardware-conf.nix`, `../../base/base.nix`, and its feature list below, and sets `home-manager.users.impuremonad = import ./home.nix`. Declare the normal user, description `"impuremonad"`, `pkgs.zsh`, and full access groups locally instead of retaining `nixos/users/impuremonad.nix`.

Use these exact feature selections. The common rows are repeated as explicit imports in each host, not implemented as another shared role profile.

| Selection | NixOS modules, relative to repository root |
| --- | --- |
| All three | `nixos/desktop/session-support.nix`, `nixos/desktop/fonts.nix`, `nixos/audio/pipewire.nix`, `nixos/security/gnome-keyring.nix`, `nixos/programs/wireshark.nix`, `nixos/virtualisation/docker.nix` |
| Monad + Arpano only | `nixos/boot/quiet-boot.nix`, `nixos/system/zram.nix`, `nixos/networking/quad9.nix`, `nixos/services/openssh.nix`, `nixos/services/tailscale.nix`, `nixos/programs/localsend.nix`, `nixos/desktop/silent-sddm.nix`, `nixos/programs/gaming.nix`, `nixos/desktop/mango.nix` |
| Argos only | `nixos/virtualisation/vmware-guest.nix`, `nixos/desktop/bspwm.nix` |

Every host owns `networking.hostName`, `networking.firewall.enable = true`, `programs.ssh.startAgent = false`, its existing `system.stateVersion`, and the user declaration. User groups are `networkmanager wheel video render wireshark docker` on all three, plus `gamemode` on Monad/Arpano. These authorization grants stay alongside the account, not in reusable service modules.

Every host's `configuration.nix` explicitly defines:

```nix
programs.gnupg.agent = {
  enable = true;
  enableSSHSupport = true;
  pinentryPackage = pkgs.pinentry-curses; # pkgs.pinentry-qt on Argos
  settings = {
    default-cache-ttl = 7200;
    max-cache-ttl = 14400;
  };
};
```

There is no shared GPG module and no remaining desktop/Wireshark GPG/SSH-agent policy. The Argos Qt choice preserves its effective graphical pinentry rather than the misplaced curses value. GNOME secret-service configuration remains a different feature; do not replace it with another GPG agent or alter its current SSH component during this refactor.

Monad/Arpano additionally own these settings extracted verbatim from `personal.nix`: Limine enabled, systemd-boot disabled, EFI variable writes enabled; `networking.networkmanager.wifi.powersave = false`; `hardware.cpu.amd.updateMicrocode = true`; `services.pipewire.jack.enable = true`; SDDM enabled with `wayland.enable = true`; `programs.silentSDDM.profileIcons.impuremonad = ../../assets/.face`; `system.autoUpgrade = { enable = true; dates = "weekly"; }`.

Preserve the rest of their existing host configuration bodies:
- **Monad:** latest kernel; `nvidia-drm.modeset=1`; NVIDIA driver and complete `hardware.nvidia`; both WLR variables; Limine `maxGenerations = 2` and Windows chainload entry.
- **Arpano:** Zen kernel; AMDGPU/OpenCL/firmware/Bluetooth; Gutenprint and Avahi; `r8125` resume workaround; ROCm packages with `lib.mkAfter`, ROCm/HIP paths, HSA override, and `nixpkgs.config.rocmSupport`.
- **Argos:** systemd-boot/EFI; NetworkManager enablement; `users.mutableUsers = true`; move the exact old BSPWM display-manager block here (`sddm.enable = true`, `wayland.enable = false`, `defaultSession = "none+bspwm"`). Retain generated guest disks and `"26.11"`; do not substitute personal host hardware.

All three `home.nix` files become `{config, pkgs, ...}: { ... }` and explicitly set `home.username = "impuremonad"`, `home.homeDirectory = "/home/impuremonad"`, and `home.stateVersion = "26.05"`. They set Git and Jujutsu user `{ name = "emrtnn"; email = "emrtnn@proton.me"; }`, `.face.png`, and:

```nix
sops = {
  defaultSopsFile = ../../secrets/secrets.yaml;
  age.keyFile = "/home/impuremonad/.config/sops/age/keys.txt";
  secrets.brave_api_key = {};
};
home.sessionVariables.BRAVE_API_KEY_FILE =
  "${config.home.homeDirectory}/.config/sops-nix/secrets/brave_api_key";
```

| Selection | Home Manager imports, relative to repository root |
| --- | --- |
| All three | `home/development.nix`, `home/programs/helium.nix`, `home/programs/imv.nix`, `home/desktop/appearance.nix`, `home/desktop/wallpapers.nix`, `home/programs/hacking.nix`, `home/programs/pi.nix`, `home/programs/oh-my-pi.nix`, `home/programs/herdr.nix`, `home/security/sops.nix`, `home/security/password-store.nix` |
| Monad + Arpano only | `home/desktop/keyring.nix`, `home/programs/onlyoffice.nix`, `home/desktop/mango.nix` |
| Argos only | `home/desktop/bspwm.nix` |

Host `home.packages` lists are exactly:
- **Monad/Arpano:** `nautilus evince ffmpeg playerctl tor-browser obsidian firefox telegram-desktop mpv vesktop stremio-linux-shell`.
- **Argos:** `nautilus evince ffmpeg playerctl tor-browser tree google-chrome telegram-desktop`.

Monad/Arpano additionally own `CHROME_PATH`, the Noctalia policy extracted in step 4, and `programs.jujutsu.settings.signing = { backend = "gpg"; key = "197CB7FC535093C4"; sign-all = true; behavior = "own"; }`. Argos keeps no signing block and sets `xdg.mimeApps.defaultApplications."application/pdf" = "org.gnome.Evince.desktop"`. Monad/Arpano retain OnlyOffice's PDF association. Do not add Nushell/Helix/tmux/Fastfetch just because their modules exist.

Replace the flake factory with the exact interface:

```nix
mkHost = nixosModule:
  nixpkgs.lib.nixosSystem {
    specialArgs = { inherit inputs; };
    modules = [ nixosModule ];
  };
```

Its only callers become `nixosConfigurations.monad = mkHost ./hosts/monad/configuration.nix`, equivalent Arpano and Argos calls. Remove the old Home Manager wiring from `flake.nix` and the now-unused `home-manager` formal argument to `outputs` (keep the input used by base). The flake selects one entry point per host; it no longer reaches into a second `home.nix` independently.

Remove the obsolete `modules/` tree and `home/profiles/` once every caller uses the new owners, including the old account/desktop-base/role aggregates. Do not leave forwarding modules, deprecated paths, auto-discovery, host-name conditionals, or shared modules that import host files. Repeated filenames across the NixOS/Home Manager boundaries are acceptable when their responsibilities differ.

The three unused root inputs `nixpkgs-stable`, `yazi`, and `pi-mono` have no consumers in the audited Nix files; Yazi and Pi are supplied by `pkgs`. Remove these declarations and prune unreachable lock nodes with `nix flake lock --offline`, without updating any retained locked revision/hash. Keep `niri` because its opt-in module consumes it. In the current lock, the removed root stable input points to `nixpkgs-stable_2`; Niri's separate `nixpkgs-stable` node remains reachable and must stay. LSP references for these input keys are unsupported (`cannot find variable on given node`); scoped textual consumer search found only their declarations. No package-source migration is intended.

Static imports fail normally if a required module/hardware/source is missing. Do not introduce `pathExists` fallbacks or placeholder hardware. Preserve existing `mkBefore`/`mkAfter` merge intent and the BSPWM service-specific `mkForce` overrides; do not add `mkForce` to hide composition errors.

## Critical files & anchors
- `modules/nixos/profiles/personal.nix`, imports and boot/network/program blocks: the catch-all source; its SilentSDDM import-depth workaround is replaced by explicit font ordering.
- `modules/home/desktop/bspwm.nix`, helper definitions and `systemd.user.services`: keep screenshot guards, CopyQ post-start synchronization, Polybar lifetime, and store-backed scripts working.
- `modules/home/desktop/noctalia.nix`, `location`, `lockscreen_widgets`, `plugins.source`, `shell.avatar_path`, `wallpaper.directory`: move only account/machine-specific subtrees, preserving the rest of the UI schema.
- `home/profiles/personal.nix` and `home/profiles/lab.nix`, imports/signing/PDF policy: personally inspect the source bodies before migrating; the personal profile is the signing/OnlyOffice/keyring variant and lab is the tree/Evince variant.

## Verification
Run from `/home/impuremonad/nixconfig` after execution is approved, with Nix flakes enabled and the locked sources/build dependencies available. Use temporary artifacts outside the repository; do not add permanent tests that merely pin file layout/import forwarding. Do not run `nixos-rebuild switch`, `test`, `boot`, Home Manager activation, or secret decryption.

### Baseline and semantic equivalence
1. Before moves, save the three hardware-file SHA-256 values and a copy of `flake.lock` in the temporary verification directory. After moves, compare checksums against `hosts/{monad,arpano,argos}/hardware-conf.nix`: contents must match their corresponding originals exactly.
2. Write this temporary `snapshot.nix` and evaluate it before/after the cutover. Before the Argos repairs, pass `--arg hostNames '[ "monad" "arpano" ]'`; after those repairs, capture the authoritative three-host baseline with the default host list.

```nix
{ repo, hostNames ? [ "monad" "arpano" "argos" ] }:
let
  flake = builtins.getFlake repo;
  lib = flake.inputs.nixpkgs.lib;
  sorted = builtins.sort builtins.lessThan;
  packages = ps: sorted (map (p: "${lib.getName p}:${lib.getVersion p}") ps);
  snapshot = name:
    let
      c = flake.nixosConfigurations.${name}.config;
      h = c.home-manager.users.impuremonad;
    in {
      hostName = c.networking.hostName;
      system = c.nixpkgs.hostPlatform.system;
      stateVersion = c.system.stateVersion;
      kernel = c.boot.kernelPackages.kernel.version;
      kernelParams = c.boot.kernelParams;
      graphicsDrivers = c.services.xserver.videoDrivers;
      filesystems = builtins.mapAttrs (_: fs: {
        inherit (fs) device fsType options;
      }) c.fileSystems;
      groups = sorted c.users.users.impuremonad.extraGroups;
      systemPackages = packages c.environment.systemPackages;
      fonts = packages c.fonts.packages;
      systemEnvironment = c.environment.sessionVariables;
      firewall = {
        inherit (c.networking.firewall) enable;
        trustedInterfaces = sorted c.networking.firewall.trustedInterfaces;
        tcp = sorted c.networking.firewall.allowedTCPPorts;
        udp = sorted c.networking.firewall.allowedUDPPorts;
        docker = c.networking.firewall.interfaces.docker0.allowedTCPPorts or [];
      };
      gpg = {
        inherit (c.programs.gnupg.agent) enable enableSSHSupport settings;
        pinentry = lib.getName c.programs.gnupg.agent.pinentryPackage;
      };
      services = {
        docker = c.virtualisation.docker.enable;
        vmware = c.virtualisation.vmware.guest.enable;
        wireshark = c.programs.wireshark.enable;
        steam = c.programs.steam.enable;
        mango = c.programs.mango.enable or false;
        x11 = c.services.xserver.enable;
        bspwm = c.services.xserver.windowManager.bspwm.enable;
        sddmWayland = c.services.displayManager.sddm.wayland.enable;
        ssh = c.services.openssh.enable;
        tailscale = c.services.tailscale.enable;
        pipewire = c.services.pipewire.enable;
        jack = c.services.pipewire.jack.enable;
        alsa32 = c.services.pipewire.alsa.support32Bit;
      };
      home = {
        inherit (h.home) username homeDirectory stateVersion sessionVariables;
        packages = packages h.home.packages;
        files = sorted (builtins.attrNames h.home.file);
        git = h.programs.git.settings;
        jujutsu = h.programs.jujutsu.settings;
        mime = h.xdg.mimeApps.defaultApplications;
        keyring = h.services.gnome-keyring.enable;
        noctalia = h.programs.noctalia.settings or null;
        secrets = builtins.attrNames h.sops.secrets;
        secretSourceHash = builtins.hashFile "sha256" h.sops.defaultSopsFile;
        ageKeyFile = h.sops.age.keyFile;
      };
    };
in builtins.listToAttrs (map (name: {
  inherit name;
  value = snapshot name;
}) hostNames)
```

Evaluate using `nix eval --impure --json --no-update-lock-file --no-write-lock-file --file "$SMOKE_DIR/snapshot.nix" --argstr repo "$PWD"` and save stdout with the execution tool. `SMOKE_DIR` is a fresh temporary directory created only in the execution phase. Compare parsed JSON, not textual object ordering. Only normalize `/nix/store/<32-character-hash>-` hash prefixes in generated command/file references; do not normalize option values, package versions, filenames, user names, or signed-key data. A structural move can change source/derivation hashes, but cannot change the selected packages or effective settings.

3. After the Argos repairs and before cutover, retain the generated Home Manager outputs for later content comparison: for each `HOST` in `monad arpano argos`, run `nix build --no-link --print-out-paths --no-update-lock-file --no-write-lock-file ".#nixosConfigurations.$HOST.config.home-manager.users.impuremonad.home.activationPackage"`. Do not run `activate`.
4. Compare the ordered `boot.kernelParams` exactly. Independently inspect `fonts.packages` order before/after using `nix eval --json .#nixosConfigurations.monad.config.fonts.packages --apply 'map (p: p.name)'` (and Arpano): the SilentSDDM directory must precede the explicit font collection. For Argos, the exact font package set must stay unchanged. The new explicit font priority replaces import-depth dependence.
5. Compare all retained lock nodes' `locked` objects with the baseline; only unreachable input nodes/root edges may disappear. If `nix flake lock --offline` cannot resolve already-locked metadata, prune the three root input edges and graph-unreachable nodes from the existing JSON directly; keep reachable node IDs, follows references, and all `locked`/`original` objects unchanged. Do not run an input update.

Expected host distinctions remain:
- Monad/Arpano: Mango, Foot/Noctalia/Swappy, Steam/GameMode, GPG curses pinentry, signed Jujutsu, OnlyOffice PDF handling, Home Manager keyring; distinct NVIDIA/latest vs AMD/Zen/ROCm hardware.
- Argos: VMware, X11/BSPWM, Kitty, Qt pinentry, no Jujutsu signing, Evince PDF handling, no Home Manager keyring module and no Steam/Mango/Noctalia.
- All: base CLI/Zsh/editor/VCS, Docker, Wireshark/hacking tools, Pi/OMP/Herdr, the same Brave secret source/key path, and no declarative password replacement.

### New composition behavior
After creating the new files, expose only the intended Nix files to the Git-backed flake with `git add --intent-to-add -- base home hosts nixos` if they are untracked; do not stage unrelated files or commit. The checkout's Jujutsu store points at the root `.git`.

Run this actual NixOS evaluation through each single host entry point, independent of the flake's host factory:

```bash
nix eval --impure --json --no-write-lock-file --no-update-lock-file --expr '
let
  f = builtins.getFlake (toString ./.);
  names = [ "monad" "arpano" "argos" ];
  direct = name:
    let
      system = f.inputs.nixpkgs.lib.nixosSystem {
        specialArgs = { inputs = f.inputs; };
        modules = [ (./hosts + "/${name}/configuration.nix") ];
      };
    in {
      inherit name;
      value = {
        host = system.config.networking.hostName;
        home = system.config.home-manager.users.impuremonad.home.homeDirectory;
        state = system.config.system.stateVersion;
      };
    };
in builtins.listToAttrs (map direct names)'
```

Expected: keys `monad`, `arpano`, `argos`; each correct hostname; `/home/impuremonad` for each home; states `25.11`, `25.11`, `26.11`. The flake and direct-entry projections must agree.

Prove that the single base import supplies utilities without silently selecting a personal role:

```bash
nix eval --impure --json --no-write-lock-file --no-update-lock-file --expr '
let
  f = builtins.getFlake (toString ./.);
  s = f.inputs.nixpkgs.lib.nixosSystem {
    specialArgs = { inputs = f.inputs; };
    modules = [
      ./base/base.nix
      {
        nixpkgs.hostPlatform = "x86_64-linux";
        system.stateVersion = "25.11";
        users.users.probe = { isNormalUser = true; home = "/home/probe"; };
        home-manager.users.probe.home.stateVersion = "26.05";
      }
    ];
  };
  c = s.config;
  h = c.home-manager.users.probe;
in {
  shell = c.programs.zsh.enable && h.programs.zsh.enable;
  vcs = h.programs.git.enable && h.programs.jujutsu.enable;
  accountNeutral = h.home.homeDirectory == "/home/probe"
    && !(builtins.hasAttr "impuremonad" c.users.users);
  noOptionalSystem = !c.programs.gnupg.agent.enable
    && !c.virtualisation.docker.enable
    && !c.programs.wireshark.enable
    && !c.services.xserver.enable
    && !(c.programs.mango.enable or false);
  noOptionalHome = !(h.programs.omp.enable or false)
    && !(builtins.hasAttr "sops" h)
    && !(h.programs.jujutsu.settings ? signing);
}'
```

Expected: every field `true`. Also use the repository search tool over `flake.nix`, `hosts/`, `base/`, `nixos/`, and `home/` for `modules/(nixos|home)`, `home/profiles`, `hosts/(desktop|workstation)`, and `hardware-configuration.nix`: no executable references to the retired graph. No shared module may import a host directory.

### Build and exercise relocated runtime artifacts
Build without activation:

```bash
nix build --no-link --print-out-paths --no-update-lock-file --no-write-lock-file \
  .#nixosConfigurations.monad.config.system.build.toplevel \
  .#nixosConfigurations.arpano.config.system.build.toplevel \
  .#nixosConfigurations.argos.config.system.build.toplevel
nix build --no-link --print-out-paths --no-update-lock-file --no-write-lock-file \
  .#nixosConfigurations.argos.config.home-manager.users.impuremonad.home.path
```

Capture each output path separately by selector if output ordering is ambiguous; call them `MONAD_SYSTEM`, `ARPANO_SYSTEM`, `ARGOS_SYSTEM`, and `ARGOS_HOME`. A successful build is required, but does not prove an interactive login or hardware boot.

- For each system output, create a separate temporary mode-0700 GnuPG home and run `"$SYSTEM/sw/bin/gpg-agent" --homedir "$TEMP_GNUPGHOME" --options "$SYSTEM/etc/gnupg/gpg-agent.conf" --gpgconf-test`. Expect exit 0, TTLs 7200/14400, the correct `pinentry-program`, and no raw `pinentryPackage` directive. This exercises the relocated host GPG policy with the actual parser; do not use the user's keyring or start an agent.
- Exercise the built relocated script, not `python dotfiles/argos/target.py`: set `XDG_STATE_HOME` to a fresh temporary directory, run `"$ARGOS_HOME/bin/argos-target" set 2001:0db8::1 lab`, then `get` and `show`. Expect `2001:db8::1` and `2001:db8::1 lab`. `set not-an-ip` must exit 2 without replacing that state; `clear` followed by `show` must print `No target`. This proves the new module still embeds the real store-backed helper.
- Inspect the generated Home Manager files/units from each `home.activationPackage` (build that attribute again without executing its `activate` script). Compare generated Git/Jujutsu/MIME/Zsh/Noctalia configuration, session variables, desktop source contents, and user service definitions with the pre-cutover outputs, normalizing only source hash prefixes. Preserve the `.pi`/Neovim/compositor out-of-store targets, store-backed Argos sources, CopyQ's `ExecStartPost = ".../copyq config copy_clipboard true"`, empty CopyQ settings, and Polybar's existing lifecycle overrides.
- No visual behavior is intentionally changed. If the actual host sessions are accessible after separately authorized deployment, inspect Mango/Noctalia/Foot on Monad/Arpano and Argos's four bars, screenshot workflow, graphical GPG prompt, and guest-to-host Herdr clipboard. Do not claim this visual/VMware proof from a headless build. The current planning environment has no `bspwm`, `Xvfb`, or `Xephyr` on PATH; builds and non-GUI smoke are the available proof without changing the active session.

The planning phase exercised only the original limited host evaluation and inspected GnuPG's option schema/CLI capabilities. The new-base/direct-entry checks, builds, parser checks, and relocated-script scenarios above are execution acceptance criteria, not claimed results.

## Assumptions & contingencies
- Preserve the existing software/workflow selections: Arpano keeps its current gaming and security tools despite being work-oriented, and Argos keeps its existing coding agents and Brave secret. Changing those selections is a separate user policy choice; this refactor makes them visible rather than silently revising them.
- Preserve x86_64 hardware and all system/Home Manager state versions. If the intended Arpano target is actually a different ARM machine, that requires its own generated hardware configuration and an architecture migration, not a reinterpretation of the present AMD configuration.
- `dotfiles/`, `assets/`, `secrets/`, `wallpapers/`, and flake files remain supporting repository content; the four requested directories describe the Nix configuration layout, not a ban on non-Nix resources.
- This deliverable changes configuration source, not deployed systems. Credentials remain external runtime prerequisites: if an age key is unavailable, retain the real SOPS declaration and report that activation could not be checked; never create a fake key or disable the secret. Likewise, unavailable VMware/desktop access limits visual proof, not the host composition delivered.

