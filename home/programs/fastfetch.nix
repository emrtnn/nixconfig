_: {
  programs.fastfetch = {
    enable = true;

    settings = {
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

        # --- Hardware (Green) ---
        {
          type = "custom";
          # Use {#32} for Green instead of \\u001b[32m
          format = "{#32}┌──────────────────────Hardware──────────────────────┐";
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
          format = "{#32}└────────────────────────────────────────────────────┘";
        }

        "break"

        # --- Software (Yellow) ---
        {
          type = "custom";
          # Use {#33} for Yellow
          format = "{#33}┌──────────────────────Software──────────────────────┐";
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
          # Note: We use printf instead of echo -e for better reliability
          text = ''printf "$theme \033[38m●\033[37m●\033[36m●\033[35m●\033[34m●\033[33m●\033[32m●\033[31m●"'';
        }
        {
          type = "terminalfont";
          key = "└ └";
          keyColor = "yellow";
        }
        {
          type = "custom";
          format = "{#33}└────────────────────────────────────────────────────┘";
        }

        "break"

        # --- Uptime / Age (Magenta) ---
        {
          type = "custom";
          # Use {#35} for Magenta
          format = "{#35}┌────────────────────Uptime / Age────────────────────┐";
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
          format = "{#35}└────────────────────────────────────────────────────┘";
        }

        "break"
      ];
    };
  };
}
