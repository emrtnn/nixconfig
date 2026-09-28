{
  inputs,
  pkgs,
  ...
}: let
  helium = inputs.helium-browser.packages.${pkgs.stdenv.hostPlatform.system}.default;
in {
  home.packages = [helium];

  home.sessionVariables = {
    BROWSER = "helium";
    CHROME_PATH = "${helium}/bin/helium";
    PUPPETEER_EXECUTABLE_PATH = "${helium}/bin/helium";
    PUPPETEER_SKIP_DOWNLOAD = "true";
  };

  xdg.mimeApps = {
    enable = true;
    associations.added = {
      "text/html" = ["helium.desktop"];
      "x-scheme-handler/http" = ["helium.desktop"];
      "x-scheme-handler/https" = ["helium.desktop"];
      "x-scheme-handler/about" = "helium.desktop";
      "x-scheme-handler/unknown" = "helium.desktop";
      "application/xhtml+xml" = "helium.desktop";
    };
    defaultApplications = {
      "text/html" = "helium.desktop";
      "x-scheme-handler/http" = "helium.desktop";
      "x-scheme-handler/https" = "helium.desktop";
      "x-scheme-handler/about" = "helium.desktop";
      "x-scheme-handler/unknown" = "helium.desktop";
      "application/xhtml+xml" = "helium.desktop";
    };
  };
}
