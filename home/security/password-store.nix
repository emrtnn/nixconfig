{pkgs, ...}: {
  home.packages = with pkgs; [
    (pass.withExtensions (exts: [exts.pass-otp]))
  ];
}
