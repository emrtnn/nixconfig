{inputs, ...}: {
  flake.modules.nixos.workstation = {
    imports = [inputs.silentSDDM.nixosModules.default];

    services.displayManager.sddm = {
      enable = true;
      wayland.enable = true;
    };

    programs.silentSDDM = {
      enable = true;
      theme = "default";
      profileIcons.impuremonad = ../../assets/.face;
    };
  };
}
