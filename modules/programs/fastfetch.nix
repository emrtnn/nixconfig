{pkgs, ...}: {
  programs.fastfetch = {
    enable = true;

    settings = {
      "$schema" = "https://github.com/fastfetch-cli/fastfetch/raw/dev/doc/json_schema.json";

      logo = {
        color = {"1" = "green";};
        padding = {
          top = 2;
          right = 6;
          left = 2;
        };
      };

      modules = [
        "break"

        # --- Hardware ---
        {
          type = "custom";
          format = "\\u001b[32m┌──────────────────────Hardware──────────────────────┐";
        }
        {
          type = "host";
          key = " PC";
          keyColor = "green";
        }
        {
          type = "cpu";
          key = "│ ├";
          showPeCoreCount = true;
          keyColor = "green";
        }
        {
          type = "gpu";
          key = "│ ├";
          detectionMethod = "pci";
          keyColor = "green";
        }
        {
          type = "display";
          key = "│ ├󱄄";
          keyColor = "green";
        }
        {
          type = "disk";
          key = "│ ├󰋊";
          keyColor = "green";
        }
        {
          type = "memory";
          key = "│ ├";
          keyColor = "green";
        }
        {
          type = "swap";
          key = "└ └󰓡 ";
          keyColor = "green";
        }
        {
          type = "custom";
          format = "\\u001b[32m└────────────────────────────────────────────────────┘";
        }

        "break"

        # --- Software ---
        {
          type = "custom";
          format = "\\u001b[33m┌──────────────────────Software──────────────────────┐";
        }
        {
          type = "kernel";
          key = "│ ├";
          keyColor = "yellow";
        }
        {
          type = "wm";
          key = "│ ├";
          keyColor = "yellow";
        }
        {
          type = "de";
          key = " DE";
          keyColor = "yellow";
        }
        {
          type = "terminal";
          key = "│ ├";
          keyColor = "yellow";
        }
        {
          type = "packages";
          key = "│ ├󰏖";
          keyColor = "yellow";
        }
        {
          type = "wmtheme";
          key = "│ ├󰉼";
          keyColor = "yellow";
        }
        {
          type = "command";
          key = "│ ├󰸌";
          keyColor = "yellow";
          text = ''echo -e "$theme \e[38m●\e[37m●\e[36m●\e[35m●\e[34m●\e[33m●\e[32m●\e[31m●"'';
        }
        {
          type = "terminalfont";
          key = "└ └";
          keyColor = "yellow";
        }
        {
          type = "custom";
          format = "\\u001b[33m└────────────────────────────────────────────────────┘";
        }

        "break"

        # --- Uptime / Age ---
        {
          type = "custom";
          format = "\\u001b[35m┌────────────────────Uptime / Age────────────────────┐";
        }
        {
          type = "command";
          key = "󱦟 OS Age";
          keyColor = "magenta";
          text = "birth_install=$(stat -c %W /); current=$(date +%s); time_progression=$((current - birth_install)); days_difference=$((time_progression / 86400)); echo $days_difference days";
        }
        {
          type = "uptime";
          key = "󱫐 Uptime";
          keyColor = "magenta";
        }
        {
          type = "custom";
          format = "\\u001b[35m└────────────────────────────────────────────────────┘";
        }

        "break"
      ];
    };
  };
}
