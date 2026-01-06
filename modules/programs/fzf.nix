{pkgs, ...}: {
  programs.fzf = {
    enable = true;
    enableZshIntegration = true;
    defaultOptions = [
      "--height=40%"
      "--layout=reverse"
      "--border=rounded"
      "--info=inline"
      "--cycle"
      "--margin=1"
      "--padding=1"
      "--no-mouse"
    ];
    changeDirWidgetOptions = [
      "--preview 'tree -C {} | head -200'"
    ];
    fileWidgetOptions = [
      "--preview 'bat -n --color=always {}' --preview-window=right:50%"
    ];
    historyWidgetOptions = [
      "--sort --preview 'echo {}' --preview-window=down:3:hidden:wrap"
    ];
  };
}
