{
  config,
  inputs,
  lib,
  self,
  ...
}:
{
  options.liuxu.fp.nixos = {
    sharedModules = lib.mkOption {
      type = lib.types.unspecified;
      default = [ ];
      example = [ (lib.literalMD "`./nixos`") ];
      description = ''
        Liuxu (FP): Common modules for NixOS hosts.
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
      description = ''
        Liuxu (FP): NixOS hosts.
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
                  description = ''
                    Liuxu (FP): Host name of device,
                      defaults to `<name>`.
                  '';
                };
                modules = lib.mkOption {
                  type = lib.types.unspecified;
                  default = [ ];
                  example = [ (lib.literalMD "`./devices/thinkbook-14-g4p-iap`") ];
                  description = ''
                    Liuxu (FP): Modules of devices.
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
      { name, modules }:
      inputs.nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs self;
          inherit (self) lib;
        };
        modules = modules ++ config.liuxu.fp.nixos.sharedModules ++ [ { networking.hostName = name; } ];
      }
    );
}
