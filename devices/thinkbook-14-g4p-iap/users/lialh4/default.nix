{ config, pkgs, ... }:
{
  environment.etc = {
    # newuidmap/newgidmap open these with O_NOFOLLOW, so they must be real
    # files; with system.etc.overlay the default "symlink" mode would point
    # into the store and make rootless podman fail with ELOOP.
    subuid = {
      mode = "0644";
      # newuidmap's commonio parser treats a final line without "\n" as an
      # ENOMEM failure, so keep the trailing newline.
      text = "lialh4:100000:65536\n";
    };
    subgid = {
      mode = "0644";
      text = "lialh4:100000:65536\n";
    };
  };

  liuxu.nixos.users.lialh4 = {
    id = config.liuxu.id.lialh4;
    hashedPasswordFile = config.vaultix.secrets."users/lialh4/hashedPassword".path;
  };

  users.extraUsers.lialh4 = {
    # useDefaultShell = true;
    shell = pkgs.nushell;
    extraGroups = [
      "wheel"
      "dialout"
    ];
  };
  home-manager.users.lialh4 = {
    liuxu.home = {
      ai-coding-agent = {
        opencode.enable = true;
        pi.enable = true;
      };
      gui = {
        agl.enable = true;
        hyprland.enable = true;
        niri.enable = true;
        rustdesk.enable = true;
        umbriel.enable = true;
      };
      preservation.directories = [ ".local/share/fonts" ];
      sdk.enable = true;
    };
    services.podman = {
      enable = true;
      settings.storage.storage.graphRoot = "/mnt/data/lialh4/ProgramFiles/Podman";
    };
  };
  services.libpam-pwdfile-rs.instances.pin.users.lialh4.hashedPasswordFile =
    config.vaultix.secrets."pin/users/lialh4/hashedPassword".path;
}
