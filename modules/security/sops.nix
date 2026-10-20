{inputs, ...}: {
  flake.modules.homeManager.desktop = {
    config,
    pkgs,
    ...
  }: {
    imports = [inputs.sops-nix.homeManagerModules.sops];

    home.packages = with pkgs; [
      sops
      age
    ];

    sops = {
      defaultSopsFile = ../../secrets/secrets.yaml;
      age.keyFile = "/home/impuremonad/.config/sops/age/keys.txt";
      secrets = {
        brave_api_key = {};
        exa_api_key = {};
        anthropic_api_key = {};
      };
    };

    home.sessionVariables.BRAVE_API_KEY_FILE = "${config.sops.secrets.brave_api_key.path}";
  };

  flake.modules.homeManager.workstation = {config, ...}: {
    home.sessionVariables.EXA_API_KEY_FILE = "${config.sops.secrets.exa_api_key.path}";
  };
}
