{
  flake.modules.nixos.desktop = _: {
    services.gnome.gnome-keyring.enable = true;
  };
}
