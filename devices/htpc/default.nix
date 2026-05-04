_: {
  imports = [
    ./fs
    ./users
  ];

  liuxu = {
    nixos = {
      bluetooth.enable = true;
      brightness.enable = false;
      fingerprint.enable = false;
      laptop.enable = false;
      network = {
        enable = true;
        firewalld.enable = true;
        mihoyo.enable = true;
      };
      pin.enable = true;
      podman.enable = true;
      secureboot.enable = true;
      tlp.enable = false;
      user-support = {
        gui = {
          agl.enable = false;
          display-manager.enable = false;
          plymouth.enable = false;
        };
      };
      virtualbox.enable = false;
    };
    system = {
      better-shell.enable = true; # Default enable
      helix.enable = true; # Default enable

      # Reflects NixOS version **when system get installed**.
      # Do not change it after install **unless needed**!
      version-when-installed = "25.11";

    };
  };

  networking.hostName = "LiAlH4-Server";
  time.timeZone = "Asia/Shanghai";
  nixpkgs.hostPlatform = "x86_64-linux";

  services.logind.settings.Login = {
    HandlePowerKey = "ignore";
  };
}
