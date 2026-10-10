_: {
  # OpenSSH's native agent, managed by NixOS. Starts the agent on login and
  # exports SSH_AUTH_SOCK for the session. Replaces the old gcr-ssh-agent setup.
  programs.ssh.startAgent = true;

  # gnome-keyring enables gcr-ssh-agent by default, which conflicts with the
  # native agent (only one SSH agent allowed). Turn it off.
  services.gnome.gcr-ssh-agent.enable = false;
}
