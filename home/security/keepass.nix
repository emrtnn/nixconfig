{
  config,
  lib,
  pkgs,
  ...
}: let
  # Syncthing device IDs live in secrets/secrets.yaml as `<name>_syncthing_id`
  # so they don't leak through this public repo (anyone holding an ID can look
  # up the device's IPs on the global discovery servers).
  deviceNames = ["arpano" "argos" "iphone" "windows"];
  secretName = name: "${name}_syncthing_id";

  folder = {
    id = "keepass";
    label = "keepass";
    path = "~/Passwords"; # Syncthing creates it if missing
    # When a sync replaces the database, keep the old copy in
    # ~/Passwords/.stversions for 90 days.
    versioning = {
      type = "staggered";
      params.maxAge = toString (90 * 24 * 60 * 60);
    };
  };

  # Home Manager's syncthing module needs device IDs at evaluation time, but
  # sops-nix only decrypts them at runtime. So devices and the folder that
  # references them are pushed through Syncthing's REST API by this script,
  # mirroring what Home Manager's own `syncthing-init` does (including
  # removing any device/folder that isn't declared here).
  syncthingSecretsInit = pkgs.writeShellApplication {
    name = "syncthing-secrets-init";
    runtimeInputs = with pkgs; [coreutils curl jq libxml2];
    text = ''
      umask 077

      st_dir="''${XDG_STATE_HOME:-$HOME/.local/state}/syncthing"
      api_base="http://${config.services.syncthing.guiAddress}/rest"

      until apikey="$(xmllint --xpath 'string(configuration/gui/apikey)' "$st_dir/config.xml" 2>/dev/null)" \
        && [[ -n "$apikey" ]]; do
        sleep 1
      done
      headers="$RUNTIME_DIRECTORY/headers"
      printf 'X-API-Key: %s\n' "$apikey" >"$headers"

      api() {
        curl -sSLk --fail-with-body -H "@$headers" \
          --retry 30 --retry-delay 1 --retry-connrefused "$@"
      }

      declare -A secret_files=(
        ${lib.concatMapStringsSep "\n    " (n: "[${n}]=${lib.escapeShellArg config.sops.secrets.${secretName n}.path}") deviceNames}
      )

      ids=()
      for name in "''${!secret_files[@]}"; do
        id="$(tr -d '[:space:]' <"''${secret_files[$name]}")"
        ids+=("$id")
        jq -n --arg id "$id" --arg name "$name" '{deviceID: $id, name: $name}' |
          api --json @- -X POST "$api_base/config/devices"
      done
      ids_json="$(printf '%s\n' "''${ids[@]}" | jq -R . | jq -s .)"

      jq -n --argjson folder ${lib.escapeShellArg (builtins.toJSON folder)} --argjson ids "$ids_json" \
        '$folder + {devices: [$ids[] | {deviceID: .}]}' |
        api --json @- -X POST "$api_base/config/folders"

      # Drop devices/folders that aren't declared here (never our own device).
      my_id="$(api "$api_base/system/status" | jq -r .myID)"
      api "$api_base/config/devices" |
        jq -r --arg me "$my_id" --argjson keep "$ids_json" \
          '.[].deviceID | select(. != $me and (IN($keep[]) | not))' |
        while read -r id; do api -X DELETE "$api_base/config/devices/$id"; done
      api "$api_base/config/folders" |
        jq -r --arg keep ${folder.id} '.[].id | select(. != $keep)' |
        while read -r id; do api -X DELETE "$api_base/config/folders/$id"; done

      if api "$api_base/config/restart-required" | jq -e .requiresRestart >/dev/null; then
        api -X POST "$api_base/system/restart"
      fi
    '';
  };

  keepassxcSettings = {
    GUI = {
      CheckForUpdates = false;
      ShowTrayIcon = true;
      MinimizeToTray = true;
      MinimizeOnClose = true;
    };
    Security.LockDatabaseIdleSeconds = 300;
    Browser = {
      Enabled = true;
      UpdateBinaryPath = false;
    };
  };
in {
  programs.keepassxc.enable = true;

  home.activation.keepassxcSettings = lib.hm.dag.entryAfter ["writeBoundary"] ''
    run install -D -m600 ${(pkgs.formats.ini {}).generate "keepassxc.ini" keepassxcSettings} \
      ${config.xdg.configHome}/keepassxc/keepassxc.ini
  '';

  # Tells Helium where KeePassXC is, for the KeePassXC-Browser extension.
  # (LibreWolf gets the same through its wrapper, see the hosts' home.nix.)
  xdg.configFile."net.imput.helium/NativeMessagingHosts/org.keepassxc.keepassxc_browser.json".source = "${config.programs.keepassxc.package}/etc/chromium/native-messaging-hosts/org.keepassxc.keepassxc_browser.json";

  sops.secrets = lib.genAttrs (map secretName deviceNames) (_: {});

  services.syncthing = {
    enable = true;
    # Devices and folders are managed by syncthing-secrets-init below; with
    # these left on, Home Manager would delete them since none are declared.
    overrideDevices = false;
    overrideFolders = false;
    settings.options.urAccepted = -1; # no anonymous usage reports
  };

  systemd.user.services.syncthing-secrets-init = {
    Unit = {
      Description = "Configure Syncthing devices and folders from sops secrets";
      Requires = ["syncthing.service"];
      Wants = ["sops-nix.service"];
      After = ["syncthing.service" "syncthing-init.service" "sops-nix.service"];
    };
    Service = {
      Type = "oneshot";
      ExecStart = lib.getExe syncthingSecretsInit;
      RuntimeDirectory = "syncthing-secrets-init";
      RemainAfterExit = true;
    };
    Install.WantedBy = ["default.target"];
  };
}
