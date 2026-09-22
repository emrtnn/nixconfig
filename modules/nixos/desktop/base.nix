{...}: {
  imports = [./fonts.nix];

  programs.dconf.enable = true;

  hardware.graphics.enable = true;

  services = {
    pipewire = {
      enable = true;
      alsa.enable = true;
      pulse.enable = true;
    };

    gnome.gnome-keyring.enable = true;
    gvfs.enable = true;
  };
}
