{
  config,
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.sops-nix.homeManagerModules.sops];

  home.packages = with pkgs; [
    sops
    age
    (pass.withExtensions (exts: [exts.pass-otp]))
  ];

  sops = {
    defaultSopsFile = ../../../secrets/secrets.yaml;
    age.keyFile = "/home/impuremonad/.config/sops/age/keys.txt";

    secrets.brave_api_key = {};
  };

  home.sessionVariables.BRAVE_API_KEY_FILE = "${config.home.homeDirectory}/.config/sops-nix/secrets/brave_api_key";
}
