# LibreWolf: default browser, Oxocarbon "TUI" theme (dotfiles/librewolf/chrome)
# and the prefs it needs, shared by every host. The package itself stays in
# the hosts' home.nix (wrapped with KeePassXC's native messaging host).
#
# LibreWolf names profile directories randomly per host
# (e.g. zcqencts.default-1791644758831), and they are LibreWolf's own state:
# Home Manager does not own profiles.ini or create profiles here. Instead,
# every activation (each switch, and each boot) finds the existing profiles
# and copies into each one:
#   <profile>/chrome/userChrome.css   browser UI
#   <profile>/chrome/userContent.css  about: pages
#   <profile>/user.js                 only the marked "nixconfig" block is
#                                     rewritten; other lines are kept
# Profiles are read from profiles.ini and from the profile manager's
# "Profile Groups" database, in the XDG root (~/.config/librewolf/librewolf)
# and in the legacy one (~/.librewolf). Neither root is ever created.
# A stylesheet that this module did not write is kept as <file>.backup
# before it is replaced. Files are copied rather than symlinked into the
# store, so the Browser Toolbox (when enabled in prefs below) can save live
# edits; they are overwritten on the next switch, so make lasting changes
# here.
#
# First run on a new host: a profile only exists after LibreWolf has been
# started once, so the theme needs two activations:
#   1. nixos-rebuild switch: no profile yet, activation prints a note
#   2. start LibreWolf and quit it: LibreWolf creates its profile
#   3. activate again: nixos-rebuild switch, a reboot, or
#      systemctl restart home-manager-$USER.service
#   4. start LibreWolf: chrome/*.css are read at startup
# Afterwards every switch keeps all profiles in sync.
{
  config,
  lib,
  pkgs,
  ...
}: let
  chrome = ../../dotfiles/librewolf/chrome;
  marker = "home/programs/librewolf.nix"; # present in the managed CSS headers

  # Links and web pages open in LibreWolf (Helium was the default before).
  desktop = "librewolf.desktop";
  webTypes = [
    "text/html"
    "application/xhtml+xml"
    "x-scheme-handler/http"
    "x-scheme-handler/https"
    "x-scheme-handler/about"
    "x-scheme-handler/unknown"
  ];

  prefs = {
    # Load chrome/userChrome.css and chrome/userContent.css.
    "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
    # Browser Toolbox (Ctrl+Shift+Alt+I) off: while open it runs a debugging
    # server on localhost. Set both to true to inspect or live-edit the UI CSS.
    # Kept as false rather than removed: removing a pref from user.js leaves
    # its last value in prefs.js, so false is what turns it off everywhere.
    "devtools.chrome.enabled" = false;
    "devtools.debugger.remote-enabled" = false;
  };

  userJs = pkgs.writeText "librewolf-user.js" ''
    // BEGIN nixconfig: ${marker} (rewritten on every switch)
    ${lib.concatLines (lib.mapAttrsToList (name: value: "user_pref(${builtins.toJSON name}, ${builtins.toJSON value});") prefs)}// END nixconfig
  '';

  sync = pkgs.writeShellApplication {
    name = "librewolf-chrome-sync";
    runtimeInputs = with pkgs; [coreutils diffutils gawk gnugrep gnused sqlite];
    text = ''
      roots=(
        "${config.xdg.configHome}/librewolf/librewolf"
        "${config.home.homeDirectory}/.librewolf"
      )
      tmp="$(mktemp)"
      trap 'rm -f "$tmp"' EXIT

      # Profile directories under one root, one per line.
      profiles() {
        local root="$1" db path relative
        if [ -f "$root/profiles.ini" ]; then
          # [ProfileN] sections: Path= is relative unless IsRelative=0.
          while IFS=$'\t' read -r relative path; do
            if [ "$relative" = 0 ]; then echo "$path"; else echo "$root/$path"; fi
          done < <(awk -F= '
            /^\[/ { if (p != "") print r "\t" p; p = ""; r = 1; next }
            $1 == "Path" { p = substr($0, 6) }
            $1 == "IsRelative" { r = $2 }
            END { if (p != "") print r "\t" p }
          ' "$root/profiles.ini")
        fi
        # Profiles made with the profile menu are only listed in this
        # database, relative to the root. Read-only; never fails activation.
        for db in "$root/Profile Groups"/*.sqlite; do
          [ -f "$db" ] || continue
          sqlite3 -readonly "file:''${db// /%20}?immutable=1" \
            'SELECT path FROM Profiles;' 2>/dev/null |
            while read -r path; do
              case "$path" in
                /*) echo "$path" ;;
                ?*) echo "$root/$path" ;;
              esac
            done || true
        done
      }

      found=0
      for root in "''${roots[@]}"; do
        while read -r profile; do
          [ -d "$profile" ] || continue
          found=1

          for css in userChrome.css userContent.css; do
            dst="$profile/chrome/$css"
            if cmp -s "${chrome}/$css" "$dst"; then continue; fi
            if [ -s "$dst" ] && ! grep -qF "${marker}" "$dst"; then
              cp -p "$dst" "$dst.backup"
              echo "librewolf: kept previous $css as $dst.backup"
            fi
            install -D -m644 "${chrome}/$css" "$dst"
            echo "librewolf: updated $dst"
          done

          userjs="$profile/user.js"
          : >"$tmp"
          if [ -f "$userjs" ]; then
            sed '\|^// BEGIN nixconfig:|,\|^// END nixconfig|d' "$userjs" >"$tmp"
          fi
          cat "${userJs}" >>"$tmp"
          if ! cmp -s "$tmp" "$userjs"; then
            install -m644 "$tmp" "$userjs"
            echo "librewolf: updated $userjs"
          fi
        done < <(profiles "$root" | sort -u)
      done

      if [ "$found" = 0 ]; then
        echo "librewolf: no profile yet; start LibreWolf once, quit it, then activate again (see ${marker})"
      fi
    '';
  };
in {
  home.sessionVariables.BROWSER = "librewolf";

  xdg.mimeApps = {
    enable = true;
    associations.added = lib.genAttrs webTypes (_: desktop);
    defaultApplications = lib.genAttrs webTypes (_: desktop);
  };

  home.activation.librewolfChrome = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run ${lib.getExe sync}
  '';
}
