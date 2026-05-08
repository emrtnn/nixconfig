{
  lib,
  stdenv,
  fetchzip,
  autoPatchelfHook,
}: let
  version = "0.10.0";

  sources = {
    "x86_64-linux" = {
      url = "https://registry.npmjs.org/hunkdiff-linux-x64/-/hunkdiff-linux-x64-${version}.tgz";
      hash = "sha256-luSKW73utCGHi+kotEanRy81ffH6l54oitohPB1quKE=";
    };
    "aarch64-linux" = {
      url = "https://registry.npmjs.org/hunkdiff-linux-arm64/-/hunkdiff-linux-arm64-${version}.tgz";
      hash = "sha256-eieNUZ0Xt24g3dPXEaSatDNTlvntLTyHsFurS5JNhYs=";
    };
    "x86_64-darwin" = {
      url = "https://registry.npmjs.org/hunkdiff-darwin-x64/-/hunkdiff-darwin-x64-${version}.tgz";
      hash = "sha256-wrCTJlMt/0D6Mp9Ii68YzMA7D/TFkiU1V7a102eP+Vw=";
    };
    "aarch64-darwin" = {
      url = "https://registry.npmjs.org/hunkdiff-darwin-arm64/-/hunkdiff-darwin-arm64-${version}.tgz";
      hash = "sha256-LW+wOmh32a86zulfoTAe2BZgE5MnOC2F6SRrLn/rKLw=";
    };
  };

  src = fetchzip {
    inherit (sources.${stdenv.hostPlatform.system}) url hash;
  };
in
  stdenv.mkDerivation {
    pname = "hunk";
    inherit version src;

    # Required by nixpkgs-vet (NPV-164)
    strictDeps = true;

    # Required by nixpkgs-vet (NPV-166)
    __structuredAttrs = true;

    nativeBuildInputs = lib.optionals stdenv.hostPlatform.isLinux [autoPatchelfHook];
    dontStrip = true;

    dontBuild = true;
    dontConfigure = true;

    installPhase = ''
      runHook preInstall
      mkdir -p $out/bin
      install -m755 bin/hunk $out/bin/hunk
      runHook postInstall
    '';

    meta = {
      description = "Terminal diff viewer for agentic changesets";
      homepage = "https://github.com/modem-dev/hunk";
      license = lib.licenses.mit;
      mainProgram = "hunk";
      platforms = builtins.attrNames sources;
      sourceProvenance = [lib.sourceTypes.binaryNativeCode];
      maintainers = [lib.maintainers.MarkusZoppelt];
    };
  }
