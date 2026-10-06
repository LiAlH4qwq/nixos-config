{ config, pkgs, ... }:
{
  here.config = {
    virtualisation.waydroid.enable = true;

    # The image package is exposed under /etc, which is one of Waydroid's
    # `preinstalled_images_paths`, so `waydroid init` never hits the OTA server.
    environment.etc = {
      waydroid-system = {
        target = "waydroid-extra/images/system.img";
        source = "${pkgs.waydroid-lineage-vanilla}/share/waydroid/images/system.img";
      };
      waydroid-vendor = {
        target = "waydroid-extra/images/vendor.img";
        source = "${pkgs.waydroid-lineage-vanilla}/share/waydroid/images/vendor.img";
      };
    };

    # Waydroid keeps its rootfs, overlays and /data under /var/lib/waydroid.
    preservation.preserveAt.persist.directories = [ "/var/lib/waydroid" ];

    # First-boot initialization from the preinstalled images. No Magisk / root.
    systemd.services.waydroid-init =
      let
        before = [ "waydroid-container.service" ];
      in
      {
        inherit before;
        wantedBy = before;
        description = "Initialize Waydroid from preinstalled LineageOS images";
        unitConfig.ConditionPathExists = "!/var/lib/waydroid/waydroid.cfg";
        path = with pkgs; [
          unzip
          util-linux
        ];
        serviceConfig = {
          Type = "oneshot";
          RemainAfterExit = true;
          ExecStart = "${config.virtualisation.waydroid.package}/bin/waydroid init -f";
        };
      };
  };
}
