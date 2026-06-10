{pkgs, ...}: {
  languages.nix.enable = true;

  packages = [
    pkgs.alejandra
    pkgs.deadnix
    pkgs.statix
  ];
  scripts = {
    fmt.exec = ''
      echo "Formatting Nix files..."
      alejandra .
    '';

    lint.exec = ''
      echo "Checking for dead code..."
      deadnix .

      echo "Checking for Nix anti-patterns..."
      statix check .
    '';

    check.exec = ''
      fmt
      lint
    '';
  };
}
