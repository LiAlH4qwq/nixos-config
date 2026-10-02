{
  config,
  lib,
  pkgs,
  ...
}:
{
  here = {
    switch = {
      default = true;
      children = {
        mode = "any";
        of = [
          "hyprland"
          "niri"
          "umbriel"
        ];
      };
    };
    config = {
      programs = {
        # these programs can't simply be enabled only in the user scope.
        _1password.enable = true;
        _1password-gui = {
          enable = true;
          polkitPolicyOwners =
            config.home-manager.users
            |> lib.filterAttrs (_: cfg: cfg.liuxu.home.internal.final.gui.enable)
            |> lib.attrNames;
        };
      };

      services = {
        gnome.gnome-keyring.enable = true;
        gvfs.enable = true;
        pipewire = {
          enable = true;
          socketActivation = true;
          audio.enable = true;
          pulse.enable = true;
          jack.enable = true;
          wireplumber.enable = true;
          alsa = {
            enable = true;
          };
        };
      };
      environment.systemPackages = with pkgs; [ bitwarden-desktop ];
    };
  };
}
