{
  lib,
  pkgs,
  root,
  scopes,
  ...
}:
let
  tree =
    base: dir:
    lib.liuxu.mkTree {
      inherit scopes base dir;
      scopeName = "nixos";
    };
in
{
  imports = [
    (lib.liuxu.mkTree {
      inherit scopes;
      scopeName = "id";
      dir = root + "/ids";
      base = [ ];
    })
    (root + "/system")
    (tree [ ] ./boot)
    (tree [ "btrbk" ] ./btrbk)
    (tree [ "microcode" ] ./microcode)
    (tree [ "network" ] ./network)
    (tree [ "pin" ] ./pin)
    (tree [ ] ./globals)
    (tree [ ] ./home-manager)
    (tree [ "internal" ] ./internal)
    (tree [ ] ./modules)
    (tree [ ] ./nix)
    (tree [ ] ./nt)
    (tree [ ] ./persist)
    (tree [ ] ./sops)
    (tree [ ] ./users)
  ];

  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableSystemSlice = true;
    enableUserSlices = true;
  };

  services = {
    power-profiles-daemon.enable = lib.mkDefault true;
    udisks2.enable = true;
  };

  environment = {
    enableAllTerminfo = true;
    defaultPackages = lib.mkForce [ ];
    systemPackages = with pkgs; [
      btdu
      cloudflared
      nix-output-monitor
      nushell
      pciutils # `lspci`
      usbutils # `lsusb`
    ];
  };

  hardware.enableRedistributableFirmware = true;
}
