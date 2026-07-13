_: {
  programs.fzf = {
    enable = true;
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
    changeDirWidget.options = [
      "--preview 'tree -C {} | head -200'"
    ];
    fileWidget.options = [
      "--preview 'bat -n --color=always {}' --preview-window=right:50%"
    ];
    historyWidget.options = [
      "--sort --preview 'echo {}' --preview-window=down:3:hidden:wrap"
    ];
  };
}
