{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    inputs.hermes.nixosModules.default
    (lib.mkAliasOptionModule
      [ "liuxu" "nixos" "hermes" "enable" ]
      [ "services" "hermes-agent" "enable" ]
    )
    (lib.mkAliasOptionModule
      [ "liuxu" "nixos" "hermes" "environmentFiles" ]
      [ "services" "hermes-agent" "environmentFiles" ]
    )
    (lib.mkAliasOptionModule
      [ "liuxu" "nixos" "hermes" "settings" ]
      [ "services" "hermes-agent" "settings" ]
    )
  ];

  options.liuxu.nixos.hermes.allowNixAccess = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu: Whether to allow hermes to access nix daemon,
        just allow to access, not trusted users.
    '';
  };

  config = lib.mkIf config.liuxu.nixos.hermes.enable {
    services.hermes-agent = {
      addToSystemPackages = true;
    };
    nix.settings.allowed-users = [ config.services.hermes-agent.user ];
    intransience.datastores.persist.dirs = [
      {
        inherit (config.services.hermes-agent) user group;
        path = config.services.hermes-agent.stateDir;
      }
    ];
    systemd.services.hermes-agent-setup =
      let
        before = [ "hermes-agent.service" ];
        after = [
          "userborn.service"
          "agenix-install-secrets.service"
        ];
      in
      {
        inherit before after;
        requiredBy = before;
        requires = after;
        script = config.system.activationScripts.hermes-agent-setup.text;
      };
  };
}
