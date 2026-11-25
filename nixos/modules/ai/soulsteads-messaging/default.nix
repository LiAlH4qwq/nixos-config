{
  config,
  here,
  lib,
  pkgs,
  ...
}:
let
  inherit (lib) mkOption types;
in
{
  here = {
    switch.generate = true;

    options = {
      package = mkOption {
        type = types.package;
        default = pkgs.soulsteads-messaging;
        description = "soulsteads-agent-messaging package.";
      };

      user = mkOption {
        type = types.str;
        default = "soulsteads-messaging";
        description = "Unix user running the bridge.";
      };

      group = mkOption {
        type = types.str;
        default = "soulsteads-messaging";
        description = "Unix group running the bridge.";
      };

      home = mkOption {
        type = types.str;
        default = "/var/lib/soulsteads-messaging";
        description = "Persistent home of the bridge user.";
      };

      botName = mkOption {
        type = types.str;
        default = "soulsteads";
        description = "Display name of the bridge.";
      };

      opencode = {
        package = mkOption {
          type = types.package;
          default = pkgs.opencode;
          description = "OpenCode package used as the ACP harness.";
        };

        model = mkOption {
          type = types.str;
          default = "command-code/deepseek/deepseek-v4.1-flash";
          description = "Model passed to OpenCode.";
        };

        permission = mkOption {
          type = types.anything;
          default = {
            edit = "deny";
            bash = "ask";
            webfetch = "allow";
            external_directory = {
              "*" = "deny";
            };
          };
          description = "OpenCode permission block.";
        };
      };

      matrix = {
        homeserver = mkOption {
          type = types.str;
          example = "https://matrix.example.org";
          description = "Matrix homeserver base URL.";
        };

        userId = mkOption {
          type = types.str;
          example = "@bot:example.org";
          description = "Full Matrix user ID of the bot.";
        };

        tokenSecret = mkOption {
          type = types.str;
          default = "soulsteads-messaging/matrix-token";
          description = ''
            vaultix secret id holding the bot access token.
            Declare it on the device, e.g. under
            `liuxu.nixos.vaultix.localMachine.secrets`.
          '';
        };

        allowedUsers = mkOption {
          type = types.listOf types.str;
          default = [ ];
          example = [ "@operator:example.org" ];
          description = "Matrix user IDs allowed to talk to the bot.";
        };

        allowedRooms = mkOption {
          type = types.listOf types.str;
          default = [ ];
          example = [ "!room:example.org" ];
          description = "Matrix room IDs the bot may answer in.";
        };

        trigger = mkOption {
          type = types.str;
          default = "!agent";
          description = "Message prefix that starts a request.";
        };

        interactivePermissions = mkOption {
          type = types.bool;
          default = true;
          description = "Ask for /approve or /deny in Matrix for gated tools.";
        };

        encryption = mkOption {
          type = types.bool;
          default = false;
          description = "Handle encrypted Matrix rooms (requires the matrix-encryption build feature).";
        };
      };

      extraSettings = mkOption {
        type = types.attrs;
        default = { };
        description = "Extra bridge.json settings, merged last.";
      };
    };

    apply =
      let
        cfg = here.config;
        agentHome = "${cfg.home}/agent";
        credentialsTemplate = "soulsteads-messaging/credentials";
        authTemplate = "soulsteads-messaging/auth.json";
        opencodeConfig = pkgs.writeText "soulsteads-messaging-opencode.json" (
          builtins.toJSON {
            "$schema" = "https://opencode.ai/config.json";
            autoupdate = false;
            model = cfg.opencode.model;
            provider = {
              deepseek.blacklist = [ "deepseek-v4-pro" ];
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
            permission = cfg.opencode.permission;
          }
        );
        bridgeConfig = pkgs.writeText "soulsteads-messaging.json" (
          builtins.toJSON (
            {
              botName = cfg.botName;
              trigger = cfg.matrix.trigger;
              sessionStorePath = "${cfg.home}/state/chat-sessions.json";
              toolMessages = {
                mode = "events";
                showCalls = true;
                showArguments = false;
                showOutputFor = [ "bash" ];
                maxTraceEntries = 20;
              };
              acp = {
                defaultBackend = "opencode";
                command = "${cfg.opencode.package}/bin/opencode";
                args = [ "acp" ];
                agentHome = agentHome;
                backends.opencode = {
                  command = "${cfg.opencode.package}/bin/opencode";
                  args = [ "acp" ];
                  agentHome = agentHome;
                };
              };
              matrix = {
                enabled = true;
                homeserver = cfg.matrix.homeserver;
                userId = cfg.matrix.userId;
                accessToken = "{env:MATRIX_ACCESS_TOKEN}";
                encryption.enabled = cfg.matrix.encryption;
                autoJoin = true;
                allowedUsers = cfg.matrix.allowedUsers;
                allowedRooms = cfg.matrix.allowedRooms;
                strictAllowedRooms = true;
                triggerPatterns = [ "${cfg.matrix.trigger} " ];
                threadIsolation = true;
                respondToThreadReplies = true;
                respondToAllMessages = false;
                interactivePermissions = cfg.matrix.interactivePermissions;
                formatHtml = true;
              };
            }
            // cfg.extraSettings
          )
        );
      in
      {
        assertions = [
          {
            assertion = cfg.matrix.allowedUsers != [ ];
            message = "liuxu.nixos.ai.soulsteads-messaging.matrix.allowedUsers must not be empty.";
          }
          {
            assertion = builtins.hasAttr cfg.matrix.tokenSecret config.vaultix.secrets;
            message = "liuxu.nixos.ai.soulsteads-messaging.matrix.tokenSecret must be declared as a vaultix secret on the device.";
          }
        ];

        users.groups.${cfg.group} = { };

        users.users.${cfg.user} = {
          isSystemUser = true;
          inherit (cfg) home;
          group = cfg.group;
          createHome = true;
          homeMode = "0700";
          description = "Soulsteads messaging bridge";
        };

        preservation.preserveAt.persist.directories = [
          {
            directory = cfg.home;
            inherit (cfg) user group;
            mode = "0700";
            parent.mode = "0700";
          }
        ];

        vaultix.secrets = {
          "ai/accessTokens/command-code" = { };
          "ai/accessTokens/deepseek" = { };
          "ai/accessTokens/kimi" = { };
        };

        vaultix.templates.${credentialsTemplate} = {
          content = "MATRIX_ACCESS_TOKEN=${config.vaultix.placeholder.${cfg.matrix.tokenSecret}}\n";
          owner = "root";
          group = "root";
          mode = "0400";
        };

        vaultix.templates.${authTemplate} = {
          content = builtins.toJSON (
            builtins.mapAttrs
              (_: v: {
                type = "api";
                key = v;
              })
              {
                deepseek = config.vaultix.placeholder."ai/accessTokens/deepseek";
                kimi-for-coding = config.vaultix.placeholder."ai/accessTokens/kimi";
                command-code = config.vaultix.placeholder."ai/accessTokens/command-code";
              }
          );
          owner = "root";
          group = "root";
          mode = "0400";
        };

        systemd.tmpfiles.rules = [
          "d ${cfg.home}/work 0700 ${cfg.user} ${cfg.group} -"
          "d ${cfg.home}/state 0700 ${cfg.user} ${cfg.group} -"
          "d ${cfg.home}/state/sessions 0700 ${cfg.user} ${cfg.group} -"
          "d ${cfg.home}/state/matrix 0700 ${cfg.user} ${cfg.group} -"
          "d ${cfg.home}/agent 0700 ${cfg.user} ${cfg.group} -"
          "d ${cfg.home}/agent/.opencode 0700 ${cfg.user} ${cfg.group} -"
          "d ${cfg.home}/agent/.opencode/skills 0700 ${cfg.user} ${cfg.group} -"
          "d ${cfg.home}/.config 0700 ${cfg.user} ${cfg.group} -"
          "d ${cfg.home}/.config/opencode 0700 ${cfg.user} ${cfg.group} -"
          "d ${cfg.home}/.local 0700 ${cfg.user} ${cfg.group} -"
          "d ${cfg.home}/.local/share 0700 ${cfg.user} ${cfg.group} -"
          "d ${cfg.home}/.local/share/opencode 0700 ${cfg.user} ${cfg.group} -"
          "d ${cfg.home}/.local/state 0700 ${cfg.user} ${cfg.group} -"
          "d ${cfg.home}/.cache 0700 ${cfg.user} ${cfg.group} -"
          "Z ${agentHome} 0700 ${cfg.user} ${cfg.group} -"
          "L+ ${cfg.home}/.config/opencode/opencode.json - - - - ${opencodeConfig}"
        ];

        systemd.services.soulsteads-messaging-init = {
          description = "Prepare Soulsteads Agent Messaging directories";
          before = [ "soulsteads-messaging.service" ];
          serviceConfig = {
            Type = "oneshot";
            RemainAfterExit = true;
            ExecStart = "${pkgs.systemd}/bin/systemd-tmpfiles --create --prefix=${cfg.home}";
          };
        };

        systemd.services.soulsteads-messaging = {
          description = "Soulsteads Agent Messaging (Matrix)";
          wantedBy = [ "multi-user.target" ];
          wants = [
            "network-online.target"
            "systemd-tmpfiles-setup.service"
          ];
          after = [
            "network-online.target"
            "systemd-tmpfiles-setup.service"
            "soulsteads-messaging-init.service"
            "vaultix-activate.service"
          ];
          requires = [
            "soulsteads-messaging-init.service"
            "vaultix-activate.service"
          ];

          environment = {
            HOME = cfg.home;
            SHELL = "${pkgs.bash}/bin/bash";
            XDG_CONFIG_HOME = "${cfg.home}/.config";
            XDG_DATA_HOME = "${cfg.home}/.local/share";
            XDG_STATE_HOME = "${cfg.home}/.local/state";
            XDG_CACHE_HOME = "${cfg.home}/.cache";
            SESSION_BASE_DIR = "${cfg.home}/state/sessions";
            MATRIX_STORAGE_PATH = "${cfg.home}/state/matrix";
          };

          path = [
            cfg.opencode.package
            pkgs.bash
            pkgs.coreutils
            pkgs.curl
            pkgs.fd
            pkgs.findutils
            pkgs.git
            pkgs.gnugrep
            pkgs.gnused
            pkgs.jq
            pkgs.nushell
            pkgs.ripgrep
            pkgs.which
          ];

          serviceConfig = {
            Type = "simple";
            User = cfg.user;
            Group = cfg.group;
            WorkingDirectory = "${cfg.home}/work";
            EnvironmentFile = config.vaultix.templates.${credentialsTemplate}.path;
            ExecStartPre = [
              "+${pkgs.coreutils}/bin/install -m 0400 -o ${cfg.user} -g ${cfg.group} ${
                config.vaultix.templates.${authTemplate}.path
              } ${cfg.home}/.local/share/opencode/auth.json"
              "${cfg.package}/bin/soulsteads-messaging --config ${bridgeConfig} --check-config"
            ];
            ExecStart = "${cfg.package}/bin/soulsteads-messaging --config ${bridgeConfig} --serve";
            Restart = "on-failure";
            RestartSec = 5;
            UMask = "0077";

            NoNewPrivileges = true;
            PrivateTmp = true;
            ProtectSystem = "strict";
            ProtectHome = true;
            ReadWritePaths = [ cfg.home ];
            RestrictAddressFamilies = [
              "AF_UNIX"
              "AF_INET"
              "AF_INET6"
              "AF_NETLINK"
            ];
            LockPersonality = true;
            ProtectKernelTunables = true;
            ProtectKernelModules = true;
            ProtectControlGroups = true;
          };
        };
      };
  };
}
