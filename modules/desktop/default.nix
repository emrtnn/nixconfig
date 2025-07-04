{ pkgs, ...}:
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

	environment.systemPackages = with pkgs; [
		clang
    gcc
    mold
    lld
	];

	xdg.portal.enable = true;
	xdg.portal.extraPortals = [ pkgs.xdg-desktop-portal-gtk pkgs.xdg-desktop-portal-hyprland];

}
