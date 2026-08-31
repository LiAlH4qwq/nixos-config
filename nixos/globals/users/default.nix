{ config, lib, ... }: {
  options.liuxu.nixos.users =
    let
      inherit (lib.types)
        attrsOf
        nullOr
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
          options.id = lib.mkOption {
            type = nullOr unspecified;
            default = null;
            example = lib.literalMD "`config.liuxu.id.lialh4`";
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
          {
          }
          // (
            if (v.id == null) || (v.id.ssh.authorizedKeys == [ ]) then
              { }
            else
              { openssh.authorizedKeys.keys = v.id.ssh.authorizedKeys; }
          )
        );
      home-manager.users =
        cfg |> builtins.mapAttrs (_: v: { } // (if v.id == null then { } else { liuxu.home.id = v.id; }));
    };
}
