{
  pkgs,
  inputs,
  ...
}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;

    # UWSM
    withUWSM = true;

    # Set the flake package
    package = inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.hyprland;
    # Make sure to also set the portal package, so that they are in sync
    portalPackage =
      inputs.hyprland.packages.${pkgs.stdenv.hostPlatform.system}.xdg-desktop-portal-hyprland;
  };

  security.pam.services.hyprland.enableGnomeKeyring = true;
}
