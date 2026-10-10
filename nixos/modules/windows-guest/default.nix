{ pkgs, ... }:
{
  here = {
    switch.generate = true;
    apply = {
      programs.virt-manager.enable = true;
      virtualisation = {
        spiceUSBRedirection.enable = true;
        libvirtd = {
          enable = true;
          qemu = {
            package = pkgs.qemu_kvm;
            vhostUserPackages = with pkgs; [ virtiofsd ];
          };
        };
      };
      systemd.tmpfiles.settings.sr-iov."/sys/devices/pci0000:00/0000:00:02.0/sriov_numvfs".w.argument =
        "1";
      boot.kernelParams = [
        "intel_iommu=on"
        "xe.max_vfs=1"
      ];
      preservation.preserveAt.persist.directories = [ "/var/lib/libvirt" ];
    };
  };
}
