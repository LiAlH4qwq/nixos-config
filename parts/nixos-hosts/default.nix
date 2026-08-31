{
  config,
  inputs,
  lib,
  root,
  self,
  ...
}:
{
  options.liuxu.fp.nixos = with lib.liuxu.modules; {
    sharedModules = lib.mkOption {
      type = lib.types.unspecified;
      default = [ ];
      example = [ (lib.literalMD "`./nixos`") ];
      description = mkLiuxuFpDesc ''
        Common modules for NixOS hosts.
      '';
    };
    hosts = lib.mkOption {
      default = { };
      example.LiAlH4-Laptop = {
        name = "LiAlH4-Laptop";
        modules = [
          (lib.literalMD "`./devices/thinkbook-14-g4p-iap`")
        ];
      };
      description = mkLiuxuFpDesc ''
        NixOS hosts.
      '';
      type =
        with lib.types;
        attrsOf (
          submodule (
            { name, ... }: {
              options = {
                name = lib.mkOption {
                  type = lib.types.singleLineStr;
                  default = name;
                  description = mkLiuxuFpDesc ''
                    Host name of device,
                      defaults to `<name>`.
                  '';
                };
                arch = lib.mkOption {
                  type = lib.types.singleLineStr;
                  default = "x86_64-linux";
                  example = "aarch64-linux";
                  description = mkLiuxuFpDesc ''
                    Arch of device,
                      default to `x86_64-linux`.
                  '';
                };
                tz = lib.mkOption {
                  type = lib.types.singleLineStr;
                  default = "Asia/Shanghai";
                  example = "Asia/Taipei";
                  description = mkLiuxuFpDesc ''
                    Timezone of device.
                  '';
                };
                modules = lib.mkOption {
                  type = with lib.types; coercedTo path lib.singleton (listOf path);
                  default = [ ];
                  example = [ (lib.literalMD "`./devices/thinkbook-14-g4p-iap`") ];
                  description = mkLiuxuFpDesc ''
                    Modules of devices,
                      in path or list of path.
                  '';
                };
              };
            }
          )
        );
    };
  };

  config.flake.nixosConfigurations =
    config.liuxu.fp.nixos.hosts
    |> builtins.mapAttrs (
      _:
      {
        name,
        arch,
        tz,
        modules,
      }:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs root self;
          inherit (config._module.args) lib;
        };
        modules =
          modules
          ++ config.liuxu.fp.nixos.sharedModules
          ++ [
            { networking.hostName = name; }
            { nixpkgs.hostPlatform.system = arch; }
            { time.timeZone = tz; }
          ];
      }
    );
}
