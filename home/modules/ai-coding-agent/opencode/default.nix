{
  inputs,
  lib,
  osConfig,
  pkgs,
  ...
}:
{
  imports = [ inputs.opencode-sanitizer.homeModules.default ];

  here.config = {
    programs = {
      opencode = {
        enable = true;
        enableMcpIntegration = true;
        skills.nushell = "${pkgs.nushell-skill}/share/nushell-skill/skills/nushell";
        settings = {
          autoupdate = false;
          model = "command-code/deepseek/deepseek-v4.1-flash";
          provider = {
            deepseek = {
              blacklist = [ "deepseek-v4-pro" ];
            };
            command-code = {
              npm = "@ai-sdk/openai-compatible";
              name = "Command Code";
              options.baseURL = "https://api.commandcode.ai/provider/v1";
              models."deepseek/deepseek-v4.1-flash" = {
                name = "DeepSeek V4.1 Flash (Command Code)";
                reasoning = true;
                limit = {
                  context = 1000000;
                  output = 65536;
                };
                modalities = {
                  input = [
                    "text"
                    "image"
                  ];
                  output = [ "text" ];
                };
                cost = {
                  input = 0.15;
                  output = 0.6;
                  cache_read = 0.003;
                  cache_write = 0;
                };
              };
            };
          };
          permission =
            let
              roDirs = [
                "/etc/*"
                "/nix/store/*"
                "/run/booted-system/*"
                "/run/current-system/*"
              ];
              rwDirs = [
                "/sys"
              ];
            in
            {
              external_directory = (roDirs ++ rwDirs) |> lib.flip lib.genAttrs (_: "allow");
              edit = roDirs |> lib.flip lib.genAttrs (_: "deny");
            };
        };
      };
      mcp = {
        enable = true;
        servers.nixos.command = lib.getExe <| pkgs.mcp-nixos;
      };
    };

    services.opencode-sanitizer.opencode.enable = true;

    systemd.user.services.opencode-secrets = {
      Install.WantedBy = [ "default.target" ];
      Service = {
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
    };

    liuxu.home.preservation =
      let
        withOpdir = x: ".local/share/opencode/${x}";
      in
      {
        directories = map withOpdir [
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
