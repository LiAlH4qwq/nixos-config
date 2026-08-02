{ lib, pkgs, ... }: {
  imports = [
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
      # measured-boot.enable = true;
      laptop.enable = true;
      network = {
        enable = true; # Default enable
        mihoyo = {
          enable = true;
          settingsOverride = { };
        };
      };
      pin.enable = true; # Default enable
      podman.enable = true;
      secureboot.enable = true;
      tlp = {
        # Default enable when enabling laptop.
        enable = true;
        disks = [
          "nvme-Micron_MTFDKBA512TFH_222138471762"
          "nvme-WD_Blue_SN5000_1TB_251308802891"
        ];
      };
      user-support = {
        gui = {
          display-manager.enable = true; # Default enable when enabling GUI and requires enabling GUI
          # Default enable when enabling GUI.
          # Takes no effect when GUI is not enabled.
          intel-graphics.enable = true;
          # Default enable when enabling GUI.
          # But can be enabled seperately.
          plymouth.enable = true;
        };
      };
      windows-guest.enable = true;
    };
    system = {
      better-shell.enable = true; # Default enable
      helix.enable = true; # Default enable

      # Reflects NixOS version **when system get installed**.
      # Do not change it after install **unless needed**!
      version-when-installed = "25.11";

    };
  };

  networking.hostName = "LiAlH4-Laptop";
  time.timeZone = "Asia/Shanghai";
  nixpkgs.hostPlatform = "x86_64-linux";

  services.logind.settings.Login = {
    # 😭 The fingerprint reader is on the power button.
    HandlePowerKey = "ignore";
    HandleLidSwitch = "suspend-then-hibernate";
    HandleLidSwitchExternalPower = "suspend-then-hibernate";
    HandleLidSwitchDocked = "suspend-then-hibernate";
  };
  systemd.sleep.settings.Sleep.HibernateDelaySec = "30min";

  boot.kernelParams =
    let
      id = "46a6";
    in
    [
      "i915.force_probe=!${id}"
      "xe.force_probe=${id}"
    ];

  home-manager.sharedModules = [
    {
      liuxu.home.gui.keybinds.execr = with lib.liuxu.wm; [
        # Screenshot key on this laptop.
        # Yes, it's hard-coded as Win + Shift + S.
        # That's definately WinBook.
        (mkNormalExecrBind [ "noctalia" "msg" "screenshot-region" ] "S" [
          "SUPER"
          "SHIFT"
        ])
        (mkNormalExecrBind [ "noctalia" "msg" "screenshot-fullscreen" ] "Print" [ ])
      ];
    }
    {
      liuxu.home.gui.niri.settings = lib.mkAfter (
        lib.kdl.formats.v1 (
          with lib.kdl.extras.niri;
          [
            (include (
              lib.liuxu.o2 toString pkgs.writeText "niri-laptop-screen.kdl" (
                lib.kdl.formats.v1 [ (output "eDP-1" [ (scale 2) ]) ]
              )
            ))
          ]
        )
      );
    }
  ];
}
