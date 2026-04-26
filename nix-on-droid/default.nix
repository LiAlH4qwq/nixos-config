{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
{
  imports = [
    "${inputs.self}/system"
    ./proot
  ];

  options.environment.systemPackages = lib.mkOption {
    type = lib.types.listOf lib.types.package;
    default = [ ];
    example = with pkgs; [ git ];
  };

  config = {
    environment.packages = config.environment.systemPackages;
    nixpkgs.overlays = [
      inputs.self.overlays.default
      inputs.rust-overlay.overlays.default
      inputs.ragenix.overlays.default
      inputs.deploy-rs.overlays.default
    ];
  };
}
