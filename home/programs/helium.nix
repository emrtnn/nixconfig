{
  inputs,
  pkgs,
  ...
}: {
  home.packages = [
    inputs.helium-browser.packages.${pkgs.stdenv.hostPlatform.system}.default
  ];

  home.sessionVariables.BROWSER = "helium";

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
