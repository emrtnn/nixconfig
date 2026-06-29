{pkgs, ...}: let
  # Upstream split the legacy app to logseq-og (1.0.0). Nixpkgs' source
  # build still uses insecure Electron 39, while Electron 40+ currently breaks
  # Logseq OG plugin loading; use the upstream AppImage instead.
  logseq-og-bin = pkgs.appimageTools.wrapType2 rec {
    pname = "logseq-og";
    version = "1.0.0";

    src = pkgs.fetchurl {
      url = "https://github.com/logseq/og/releases/download/${version}/Logseq-OG-linux-x64-${version}.AppImage";
      hash = "sha256-pr9Rp5xSOkVy1cIcv6Ezu3ZOyZCBy1bbgmFtqjD/lNE=";
    };

    appimageContents = pkgs.appimageTools.extractType2 {
      inherit pname version src;
    };

    extraInstallCommands = ''
      install -Dm444 ${appimageContents}/Logseq-OG.desktop $out/share/applications/logseq.desktop
      substituteInPlace $out/share/applications/logseq.desktop \
        --replace-fail 'Exec=Logseq-OG %u' 'Exec=logseq-og %u' \
        --replace-fail 'Icon=Logseq-OG' 'Icon=logseq'
      install -Dm444 ${appimageContents}/Logseq-OG.png $out/share/icons/hicolor/512x512/apps/logseq.png
    '';

    meta = {
      description = "Privacy-first, open-source platform for knowledge management and collaboration (OG AppImage)";
      homepage = "https://github.com/logseq/og";
      mainProgram = "logseq-og";
    };
  };
in {
  home.packages = [logseq-og-bin];
}
