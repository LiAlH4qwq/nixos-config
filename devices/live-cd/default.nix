{ inputs, ... }: {
  imports = [
    ./users
    "${inputs.nixpkgs}/nixos/modules/installer/cd-dvd/iso-image.nix"
  ];

  isoImage = {
    makeEfiBootable = true;
    makeUsbBootable = true;
  };

  nixpkgs.hostPlatform = "x86_64-linux";
}
