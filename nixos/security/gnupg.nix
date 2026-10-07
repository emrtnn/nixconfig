# OpenPGP via Sequoia's GnuPG Chameleon. The Chameleon still delegates
# secret-key operations to GnuPG's gpg-agent, which keeps the pinentry and the
# passphrase cache.
{
  lib,
  pkgs,
  ...
}: {
  programs.gnupg.agent = {
    enable = true;
    pinentryPackage = pkgs.pinentry-qt;
    settings = {
      default-cache-ttl = 7200;
      max-cache-ttl = 14400;
    };
  };

  environment.systemPackages = with pkgs; [
    # We use hiPrio to keep just the chameleon files and ignore the ones coming from `programs.gnupg`
    (lib.hiPrio sequoia-chameleon-gnupg)
    sequoia-sq
  ];
}
