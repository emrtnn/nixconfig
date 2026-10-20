# KVM/QEMU virtual machines managed by libvirt, with virt-manager as the GUI.
#
# - UEFI (OVMF, incl. Secure Boot variants) is shipped with QEMU by default.
# - swtpm provides a software TPM 2.0 (needed for Windows 11 guests).
# - virtiofsd enables fast host <-> guest directory sharing (virtiofs).
# - SPICE USB redirection lets you pass USB devices into a running VM.
# - Nested virtualization is enabled for AMD/Intel KVM.
{pkgs, ...}: {
  virtualisation = {
    libvirtd = {
      enable = true;
      onBoot = "ignore"; # don't autostart guests unless they're marked autostart
      onShutdown = "shutdown"; # cleanly shut guests down with the host
      qemu = {
        package = pkgs.qemu_kvm; # host-arch only, smaller than full qemu
        runAsRoot = false;
        swtpm.enable = true;
        vhostUserPackages = [pkgs.virtiofsd];
      };
    };

    spiceUSBRedirection.enable = true;
  };

  programs.virt-manager.enable = true;

  users.users.impuremonad.extraGroups = ["libvirtd" "kvm"];

  boot.extraModprobeConfig = ''
    options kvm_amd nested=1
    options kvm_intel nested=1
  '';

  # Make the NAT bridge (virbr0) work: allow DHCP/DNS from guests and
  # let the host firewall trust it. Docker sets the FORWARD policy to DROP,
  # so explicitly allow forwarding for libvirt's bridge.
  networking.firewall = {
    trustedInterfaces = ["virbr0" "virbr1"];
    interfaces.virbr0.allowedUDPPorts = [53 67];
    extraCommands = ''
      iptables -I FORWARD -i virbr0 -j ACCEPT
      iptables -I FORWARD -o virbr0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT
    '';
    extraStopCommands = ''
      iptables -D FORWARD -i virbr0 -j ACCEPT 2>/dev/null || true
      iptables -D FORWARD -o virbr0 -m conntrack --ctstate RELATED,ESTABLISHED -j ACCEPT 2>/dev/null || true
    '';
  };

  # Ensure libvirt's "default" NAT network exists and is autostarted.
  systemd.services.libvirt-default-network = {
    description = "Autostart libvirt default NAT network";
    after = ["libvirtd.service"];
    requires = ["libvirtd.service"];
    wantedBy = ["multi-user.target"];
    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
    };
    path = [pkgs.libvirt];
    script = ''
      virsh net-info default >/dev/null 2>&1 || exit 0
      virsh net-autostart default || true
      virsh net-start default 2>/dev/null || true
    '';
  };

  environment.systemPackages = with pkgs; [
    virt-viewer # remote-viewer for SPICE/VNC consoles
    spice-gtk
    virtio-win # Windows virtio drivers ISO (/run/current-system/sw/share/virtio-win)
    quickemu # quickget/quickemu: one-command OS downloads + VMs
    libguestfs-with-appliance # virt-* tools for inspecting/editing disk images
  ];
}
