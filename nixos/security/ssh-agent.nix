_: {
  # Keyring-backed SSH agent: GNOME Keyring stores the key passphrase and
  # unlocks it at login, so git commit/push/ssh never re-prompt.
  services.gnome.gcr-ssh-agent.enable = true;

  # Make sure the native OpenSSH agent stays off on every host (it starts empty
  # each boot and would prompt for the passphrase on every signed commit).
  programs.ssh.startAgent = false;

  environment.extraInit = ''
    if [ -z "$SSH_AUTH_SOCK" ]; then
      export SSH_AUTH_SOCK="''${XDG_RUNTIME_DIR:-/run/user/$(id -u)}/gcr/ssh"
    fi
  '';
}
