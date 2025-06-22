{ config-files, pkgs, inputs, ...}:
{

	programs.hyprland = {
		enable = true;
		xwayland.enable = true;
	};

	programs.regreet = {
		enable = true;
	};


	programs.waybar = {
		enable = true;
	};
	
	environment.sessionVariables = {
		NIXOS_OZONE_WL = "1";
	};

	xdg.portal.enable = true;
	xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland];

}
