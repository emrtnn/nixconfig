_: {
  services.gnome.gcr-ssh-agent.enable = true;

  environment.extraInit = ''
    if [ -z "$SSH_AUTH_SOCK" ]; then
      export SSH_AUTH_SOCK="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/gcr/ssh"
    fi
  '';
}
