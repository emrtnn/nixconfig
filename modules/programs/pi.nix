{pkgs, ...}: {
  home.packages = with pkgs; [
    pi-coding-agent
  ];

  home.file.".pi/agent/keybindings.json".text = builtins.toJSON {
    "tui.input.newLine" = "ctrl+n";
  };
}
