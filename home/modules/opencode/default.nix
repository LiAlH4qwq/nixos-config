{
  config,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  options.liuxu.home.opencode.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu (Home): Whether to enable opencode,
        a coding agent.
    '';
  };

  config = lib.mkIf config.liuxu.home.opencode.enable {
    programs = {
      opencode = {
        enable = true;
        enableMcpIntegration = true;
        skills.nushell = "${pkgs.nushell-skill}/share/nushell-skill/skills/nushell";
        settings = {
          autoupdate = false;
          model = "deepseek/deepseek-v4-flash-vision-exp";
          provider.deepseek = {
            blacklist = [ "deepseek-v4-pro" ];
            models."deepseek-v4.1-flash-expires-on-0910".name = "DeepSeek V4.1 Flash";
          };
          permission =
            let
              roDirs = [
                "/nix/store/*"
                "/run/booted-system/*"
                "/run/current-system/*"
              ];
              roDirsAttrsOf = x: roDirs |> map (lib.flip lib.nameValuePair x) |> builtins.listToAttrs;
            in
            {
              external_directory = roDirsAttrsOf "allow";
              edit = roDirsAttrsOf "deny";
            };
        };
      };
      mcp = {
        enable = true;
        servers.nixos.command = lib.getExe <| pkgs.mcp-nixos;
      };
    };

    systemd.user.services.opencode-secrets.Service = {
      Type = "oneshot";
      RemainAfterExit = true;
      ExecStart =
        let
          secrets = osConfig.sops.templates."opencode/auth.json".path;
        in
        lib.getExe
        <| pkgs.writers.writeNuBin "opencode-secrets" ''
          open -r ${secrets} | save -rf ~/.local/share/opencode/auth.json
        '';
    };

    liuxu.home.internal.intransience =
      let
        withOpdir = x: ".local/share/opencode/${x}";
      in
      {
        dirs = map withOpdir [
          "storage"
          "snapshot"
        ];
        files = map withOpdir [
          "opencode-stable.db"
          "opencode-stable.db-wal"
        ];
      };
  };
}
