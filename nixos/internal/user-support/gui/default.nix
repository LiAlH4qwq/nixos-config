{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./agl
    ./hyprland
    ./niri
    ./zen
  ];

  options.liuxu.nixos.internal.user-support.gui.enable = lib.liuxu.modules.mkComputedSwitchOption (
    config.liuxu.nixos.internal.user-support.gui.hyprland.enable
    || config.liuxu.nixos.internal.user-support.gui.niri.enable
  );

  config = lib.mkIf config.liuxu.nixos.internal.user-support.gui.enable {
    programs = {
      # these programs can't simply be enabled only in the user scope.
      _1password.enable = true;
      _1password-gui = {
        enable = true;
        polkitPolicyOwners =
          config.home-manager.users
          |> lib.filterAttrs (_: cfg: cfg.liuxu.home.internal.gui.enable)
          |> lib.attrNames;
      };
      steam.enable = true;
    };

    services = {
      gnome.gnome-keyring.enable = true;
      pipewire = {
        enable = true;
        socketActivation = true;
        audio.enable = true;
        pulse.enable = true;
        jack.enable = true;
        wireplumber.enable = true;
        alsa = {
          enable = true;
          support32Bit = true;
        };
      };
    };

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };
  };
}
