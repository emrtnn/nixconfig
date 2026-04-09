{pkgs, ...}: {
  home.packages = with pkgs; [
    pi-coding-agent
    nodejs_25
    pnpm
  ];

  home.file.".pi/agent/keybindings.json".text = builtins.toJSON {
    "tui.input.newLine" = "ctrl+n";
  };
}
