{ config, lib, ... }: {
  options.liuxu.nixos.users =
    let
      inherit (lib.types)
        attrsOf
        nullOr
        str
        submodule
        unspecified
        ;
      desc = lib.liuxu.mkOsDesc;
    in
    lib.mkOption {
      description = desc "Users config.";
      default = { };
      example.lialh4.id = config.liuxu.id.lialh4;
      type = attrsOf (
        submodule (_: {
          options = {
            id = lib.mkOption {
              type = nullOr unspecified;
              default = null;
              example = lib.literalMD "`config.liuxu.id.lialh4`";
              description = "User's ID.";
            };
            hashedPasswordFile = lib.mkOption {
              type = str;
              example = lib.literalMD "`config.sops.secrets.\"localMachine.users.lialh4.hashedPassword\".path`";
              description = "User's hashed password as a file path";
            };
          };
        })
      );
    };

  config =
    let
      cfg = config.liuxu.nixos.users;
    in
    lib.mkIf (cfg != { }) {
      users.users =
        cfg
        |> builtins.mapAttrs (
          n: v:
          lib.mkMerge [
            {
              inherit (v) hashedPasswordFile;
              isNormalUser = true;
            }
            (lib.mkIf (v.id != null && v.id.ssh.authorizedKeys != [ ]) {
              openssh.authorizedKeys.keys = v.id.ssh.authorizedKeys;
            })
          ]
        );
      home-manager.users =
        cfg |> builtins.mapAttrs (_: v: lib.mkIf (v.id != null) { liuxu.home.id = v.id; });
    };
}
