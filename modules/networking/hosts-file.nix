{
  flake.modules.nixos.base = {
    # Copy /etc/hosts instead of symlinking to the read-only store,
    # so it can be edited at runtime (overwritten on next rebuild).
    environment.etc.hosts.mode = "0644";
  };
}
