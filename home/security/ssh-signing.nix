{config, ...}: let
  key = "${config.home.homeDirectory}/.ssh/id_ed25519.pub";
in {
  programs.git.signing = {
    format = "ssh";
    inherit key;
    signByDefault = true;
    # Keys trusted when verifying signatures locally; add each host's key here.
    allowedSigners = ''
      emrtnn@proton.me ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAINq9LHmDASE2/Wn0/cqtS4HNOB5m4r26QeD7pgZiX8di arpano
    '';
  };

  programs.jujutsu.settings.signing = {
    backend = "ssh";
    behavior = "own";
    inherit key;
    backends.ssh.allowed-signers = "${config.xdg.configHome}/git/allowed_signers";
  };
}
