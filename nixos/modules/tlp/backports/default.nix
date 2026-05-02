# Backport from https://github.com/NixOS/nixpkgs/blob/c666480059915a1219d4e6226234cbd82a05384d/nixos/modules/services/hardware/tlp.nix
# to support `tlp-pd`.

{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.services.tlp.pd = {
    enable = lib.mkEnableOption "the power-rofiles-daemon like DBus interface for TLP";
    package = lib.mkPackageOption pkgs [ "unstable" "tlp-pd" ] { };
  };

  config =
    let
      cfg = config.services.tlp;
    in
    lib.mkIf cfg.enable {
      assertions = [
        {
          assertion = cfg.pd.enable -> !config.services.power-profiles-daemon.enable;
          message = ''
            `services.tlp.pd` and `services.power-profiles-daemon` cannot be enabled together,
            because they are using the same dbus interface and have the same functionality.
            Generally, `services.tlp.pd` should be preferred as upstream does not recommend
            using tlp together with power-profiles-daemon.
            Set `services.power-profiles-daemon.enable` to `false` to resolve this error.
          '';
        }
        {
          assertion = cfg.pd.enable -> !(config.services.tuned.enable && config.services.tuned.ppdSupport);
          message = ''
            `services.tlp.pd` and `services.tuned.ppdSupport` cannot be enabled together,
            because they are using the same dbus interface and have the same functionality.
          '';
        }
      ];

      services.tlp.package =
        let
          enableRDW = config.networking.networkmanager.enable;
        in
        pkgs.unstable.tlp.override { inherit enableRDW; };
      environment.systemPackages = lib.optional cfg.pd.enable cfg.pd.package;
      systemd = {
        packages = lib.optional cfg.pd.enable cfg.pd.package;
        services.tlp-pd = lib.mkIf cfg.pd.enable {
          # have to define again because [Install] in included file not honored
          # https://github.com/NixOS/nixpkgs/issues/81138
          wantedBy = [ "graphical.target" ];
        };
      };
    };
}
