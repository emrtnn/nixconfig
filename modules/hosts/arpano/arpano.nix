{
  config,
  inputs,
  ...
}: {
  flake.nixosConfigurations.arpano = inputs.nixpkgs.lib.nixosSystem {
    modules = with config.flake.modules.nixos; [base desktop workstation mango amd-rocm printing bluetooth arpano];
  };

  flake.modules.nixos.arpano = {
    config,
    lib,
    pkgs,
    ...
  }: {
    imports = [./_hardware.nix];

    networking.hostName = "arpano";

    # lib.mkBefore is mkOrder 500: 501 keeps this right after plymouth's "quiet splash", as before the migration.
    boot.kernelParams = lib.mkOrder 501 ["boot.initrd.verbose=false"];

    powerManagement = {
      enable = true;
      resumeCommands = ''
        ${pkgs.kmod}/bin/modprobe -r r8125
        ${pkgs.kmod}/bin/modprobe r8125
        sleep 2
        systemctl restart NetworkManager.service
      '';
    };

    system.stateVersion = "25.11";

    assertions = [
      {
        assertion = !config.programs.steam.enable && !config.programs.gamemode.enable;
        message = "arpano is work-only";
      }
    ];
  };

  flake.modules.homeManager.arpano = {
    config,
    pkgs,
    ...
  }: {
    home = {
      stateVersion = "26.05";
      packages = with pkgs; [
        blender
      ];

      sessionVariables = {
        ANTHROPIC_API_KEY_FILE = "${config.sops.secrets.anthropic_api_key.path}";
      };
    };
  };
}
