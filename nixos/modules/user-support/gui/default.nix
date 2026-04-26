{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./agl
    ./display-manager
    ./intel-graphics
    ./plymouth
  ];

  options.liuxu.nixos.user-support.gui.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu: Whether to enable the GUI support for users.
        Note: If there's user uses GUI, this should be enabled.
    '';
  };

  config = lib.mkIf config.liuxu.nixos.user-support.gui.enable {
    programs = {
      # these programs can't simply be enabled only in the user scope.
      _1password.enable = true;
      _1password-gui = {
        enable = true;
        polkitPolicyOwners =
          config.home-manager.users |> lib.filterAttrs (_: cfg: cfg.liuxu.user.gui.enable) |> lib.attrNames;
      };
      steam.enable = true;
      hyprland = {
        enable = true;
        withUWSM = true;
        xwayland.enable = true;
      };
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

    environment.etc = {
      wallpaper = {
        target = "wallpapers/rainy-everything-in-the-night.png";
        source = "${inputs.self}/assets/rainy-everything-in-the-night.png";
      };
    };

    hardware = {
      graphics = {
        enable = true;
        enable32Bit = true;
      };
    };

    security.pam.services = {
      # Hyprlock supports parallel fingerprint and password auth like GDM.
      # But this default configuration cause a non-paralell and no-prompt auth.
      hyprlock.fprintAuth = false;
      # greetd.enableGnomeKeyring = true;
    };
  };
}
