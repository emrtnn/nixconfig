{pkgs, ...}: {
  users.users.impuremonad = {
    isNormalUser = true;
    description = "impuremonad";
    extraGroups = [
      "networkmanager"
      "wheel"
      "video"
      "render"
    ];
    shell = pkgs.zsh;
  };
}
