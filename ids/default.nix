{ lib, ... }: {
  imports = [ ./lialh4 ];

  options.liuxu.id =
    let
      inherit (lib.types)
        attrsOf
        listOf
        singleLineStr
        submodule
        ;
      desc = lib.liuxu.mkIdDesc;
    in
    lib.mkOption {
      description = desc "Define ids.";
      default = { };
      example.lialh4 = {
        #    username = "lialh4";
        nickname = "LiAlH4";
        git = {
          name = "LiAlH4";
          email = "lialh4qwq@outlook.com";
        };
        ssh.authorizedKeys = [ (lib.literalMD "<REDACTED>") ];
      };
      type = attrsOf (
        submodule (
          { config, ... }: {
            options = {
              # username = lib.mkOption {
              #   type = singleLineStr;
              #   default = name;
              #   example = "lialh4";
              #   description = desc ''
              #     Username of ID,
              #       defaults to `<name>`.
              #   '';
              # };
              nickname = lib.mkOption {
                type = singleLineStr;
                default = config.username;
                example = "LiAlh4";
                description = desc ''
                  Nickname of ID,
                    defaults to `username`.
                '';
              };
              git = {
                name = lib.mkOption {
                  type = singleLineStr;
                  default = config.nickname;
                  example = "LiAlH4";
                  description = desc ''
                    Git name of ID,
                      defaults to `nickname`.
                  '';
                };
                email = lib.mkOption {
                  type = singleLineStr;
                  default = "${config.git.name}@example.com";
                  example = "lialh4qwq@outlook.com";
                  description = desc "Git email of ID";
                };
              };
              ssh.authorizedKeys = lib.mkOption {
                type = listOf singleLineStr;
                default = [ ];
                example = [ (lib.literalMD "<REDACTED>") ];
                description = desc "List of authorized ssh key of id.";
              };
            };
          }
        )
      );
    };
}
