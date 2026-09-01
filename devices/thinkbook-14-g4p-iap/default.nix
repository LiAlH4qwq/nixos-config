{
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    inputs.aml-flash-tool.nixosModules.default
    ./fs
    ./fingerprint
    ./users
  ];

  liuxu = {
    nixos = {
      bluetooth.enable = true;
      brightness.enable = true;
      fingerprint.enable = true;
      flatpak.enable = true;
      kernel = {
        package = pkgs.cachyosKernels.linuxPackages-cachyos-bore-lto-x86_64-v3;
        # Use Xe for better performance, maybe (?)
        params =
          let
            id = "46a6";
          in
          [
            "i915.force_probe=!${id}"
            "xe.force_probe=${id}"
          ];
      };
      laptop.enable = true;
      nh.flake = "/mnt/data/lialh4/Projects/nixos-config";
      podman.enable = true;
      secureboot.enable = true;
      tlp.disks = [
        "nvme-Micron_MTFDKBA512TFH_222138471762"
        "nvme-WD_Blue_SN5000_1TB_251308802891"
      ];
      windows-guest.enable = true;
    };
    system.version-when-installed = "25.11";
  };

  programs.aml-flash-tool.enable = true;

  services.logind.settings.Login = {
    # 😭 The fingerprint reader is on the power button.
    HandlePowerKey = "ignore";
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend-then-hibernate";
    HandleLidSwitchDocked = "suspend-then-hibernate";
  };
  systemd.sleep.settings.Sleep.HibernateDelaySec = "30min";

  home-manager.sharedModules = [
    {
      liuxu.home.gui.keybinds.execr = with lib.liuxu.wm; [
        # Screenshot key on this laptop.
        # Yes, it's hard-coded as Win + Shift + S.
        # That's definately WinBook.
        (mkNormalExecrBind [ "noctalia" "msg" "screenshot-region" ] "S" [
          "Mod"
          "Shift"
        ])
        (mkNormalExecrBind [ "noctalia" "msg" "screenshot-fullscreen" ] "Print" [ ])
      ];
    }
    {
      liuxu.home.gui.niri.settings =
        with lib.kdl.extras.niri;
        2
        |> scale
        |> lib.singleton
        |> output "eDP-1"
        |> lib.singleton
        |> lib.kdl.formats.v1
        |> pkgs.writeText "niri-laptop-screen.kdl"
        |> toString
        |> include
        |> lib.singleton
        |> lib.kdl.formats.v1
        |> lib.mkAfter;
    }
    {
      programs.umbriel.settings.output.eDP-1.scale = 2;
    }
  ];
}
