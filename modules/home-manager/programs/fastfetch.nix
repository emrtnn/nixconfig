{ ... }:
{
  programs.fastfetch = {
    enable = true;
    settings = {
      logo = {
        source = "nixos";
        padding = {
          right = 1;
          top = 1;
        };
      };
      display = {
        color = "blue";
      };
      modules = [
        "break"
        {
          type = "datetime";
          key = "Date";
          format = "{1}-{3}-{11}";
        }
        {
          type = "datetime";
          key = "Time";
          format = "{14}:{17}:{20}";
        }
        "break"
        "os"
        "kernel"
        "board"
        "bios"

        "break"
        "cpu"
        "cpuusage"
        "cpucache"
        "gpu"
        "memory"
        "swap"
        "disk"

        "break"
        "localip"

        "break"
        "colors"
      ];
    };
  };
}
