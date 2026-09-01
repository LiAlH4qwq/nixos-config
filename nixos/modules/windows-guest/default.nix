{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.liuxu.nixos.windows-guest.enable = lib.liuxu.mkOsSwitchOnOption ''
    Whether to include a Windows guest configuration,
      by virt-manager, qemu, kvm, with SR-IOV.
  '';

  config = lib.mkIf config.liuxu.nixos.windows-guest.enable {
    programs.virt-manager.enable = true;
    virtualisation = {
      spiceUSBRedirection.enable = true;
      libvirtd = {
        enable = true;
        qemu.package = pkgs.qemu_kvm;
      };
    };
    systemd.tmpfiles.settings.sr-iov."/sys/devices/pci0000:00/0000:00:02.0/sriov_numvfs".w.argument =
      "1";
    boot.kernelParams = [
      "intel_iommu=on"
      "xe.max_vfs=1"
    ];
    intransience.datastores.persist.dirs = [ "/var/lib/libvirt" ];
  };
}
