{
  lib,
  fetchurl,
  appimageTools,
  stdenv,
}:
let
  pname = "helium";
  version = "0.8.4.1";

  sources = {
    x86_64-linux = {
      arch = "x86_64";
      sha256 = "sha256-y4KzR+pkBUuyVU+ALrzdY0n2rnTB7lTN2ZmVSzag5vE=";
    };
    aarch64-linux = {
      arch = "arm64";
      sha256 = "sha256-fTPLZmHAqJqDDxeGgfSji/AY8nCt+dVeCUQIqB80f7M=";
    };
  };

  currentSystem = sources.${stdenv.hostPlatform.system} or (throw "Unsupported system: ${stdenv.hostPlatform.system}");

  src = fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/${version}/helium-${version}-${currentSystem.arch}.AppImage";
    sha256 = currentSystem.sha256;
  };

  extracted = appimageTools.extractType2 {inherit pname version src;};
in
  appimageTools.wrapType2 {
    inherit pname version src;

    extraInstallCommands = ''
      # Install desktop file
      if [ -f "${extracted}/helium.desktop" ]; then
        mkdir -p $out/share/applications
        cp "${extracted}/helium.desktop" $out/share/applications/
        substituteInPlace $out/share/applications/helium.desktop \
          --replace-quiet "Exec=AppRun" "Exec=$out/bin/helium"
      fi

      # Install icon
      if [ -f "${extracted}/helium.png" ]; then
        mkdir -p $out/share/pixmaps
        cp "${extracted}/helium.png" $out/share/pixmaps/
      fi
    '';

    meta = with lib; {
      description = "Private, fast, and honest web browser based on ungoogled-chromium";
      homepage = "https://helium.computer";
      license = with licenses; [gpl3Plus bsd3];
      maintainers = [];
      platforms = ["x86_64-linux" "aarch64-linux"];
      mainProgram = "helium";
    };
  }
