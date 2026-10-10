{
  flakeConfig,
  inputs,
  lib,
  pkgs,
  root,
  scopes,
  ...
}:
let
  tree =
    base: dir:
    lib.nix-tree-modules.mkTree {
      inherit scopes base dir;
      scopeName = "nixos";
    };
in
{
  imports = [
    (lib.nix-tree-modules.mkTree {
      inherit scopes;
      scopeName = "id";
      dir = root + "/ids";
      base = [ ];
    })
    (root + "/system")
    (tree [ "boot" ] ./boot)
    (tree [ "btrbk" ] ./btrbk)
    (tree [ "microcode" ] ./microcode)
    (tree [ "network" ] ./network)
    (tree [ "pin" ] ./pin)
    (tree [ ] ./globals)
    (tree [ "home-manager" ] ./home-manager)
    (tree [ "internal" ] ./internal)
    (tree [ ] ./modules)
    (tree [ "nix" ] ./nix)
    (tree [ "nt" ] ./nt)
    (tree [ "persist" ] ./persist)
    (tree [ "sops" ] ./sops)
    (tree [ "users" ] ./users)
    (tree [ "uutils" ] ./uutils)
  ];

  systemd.oomd = {
    enable = true;
    enableRootSlice = true;
    enableSystemSlice = true;
    enableUserSlices = true;
  };

  programs = {
    # Used when rebuilding.
    git.enable = true;
    nix-ld.enable = true;
  };

  nixpkgs = {
    # We won't sacrifice our experience for FOSS.
    config.allowUnfree = true;
    overlays = [
      flakeConfig.flake.overlays.default
      inputs.tg-transient.overlays.default
      inputs.cachyos-kernel.overlays.pinned
      inputs.firefox-addons.overlays.default
    ];
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
