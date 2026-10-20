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
      # Scroll previews by a page using vi-style forward/backward keys.
      "--bind=ctrl-f:preview-page-down,ctrl-b:preview-page-up"
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
