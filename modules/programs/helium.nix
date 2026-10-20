{inputs, ...}: {
  flake.modules.homeManager.desktop = {pkgs, ...}: let
    helium = inputs.helium-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
  in {
    home.packages = [helium];

    # LibreWolf is the default browser (librewolf.nix); Helium remains the
    # Chromium for tools that need one.
    home.sessionVariables = {
      CHROME_PATH = "${helium}/bin/helium";
      PUPPETEER_EXECUTABLE_PATH = "${helium}/bin/helium";
      PUPPETEER_SKIP_DOWNLOAD = "true";
    };
  };
}
