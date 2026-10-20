{
  flake.modules.nixos.workstation = {...}: {
    programs.localsend = {
      enable = true;
      openFirewall = true;
    };
  };
}
