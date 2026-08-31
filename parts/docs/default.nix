{
  config,
  inputs,
  lib,
  root,
  ...
}:
{
  perSystem = { pkgs, system, ... }: {
    packages =
      let
        osModules = lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs root;
            inherit (config.flake) lib;
            flakeConfig = config;
          };
          modules = [
            { _module.check = false; }
            config.flake.nixosModules.default
          ];
        };
        homeModules = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          check = false;
          extraSpecialArgs = {
            inherit inputs;
            inherit (config.flake) lib;
            osConfig = osModules.config;
          };
          modules = [
            config.flake.homeModules.default
            {
              home = {
                username = "user";
                homeDirectory = "/home/user";
              };
            }
          ];
        };
        toDoc =
          modules:
          pkgs.nixosOptionsDoc {
            inherit (modules) options;
            warningsAreErrors = false;
            transformOptions =
              o:
              o
              // {
                visible = "liuxu" == builtins.head o.loc;
                declarations = map (
                  x:
                  let
                    path = x |> lib.removePrefix "${root}" |> lib.removePrefix "/";
                  in
                  {
                    name = path;
                    url = "https://github.com/lialh4qwq/nixos-config/blob/main/${path}";
                  }
                ) o.declarations;
              };
          };
        toMdDoc = doc: doc.optionsCommonMark;
        osMdDoc = osModules |> toDoc |> toMdDoc;
        homeMdDoc = homeModules |> toDoc |> toMdDoc;
        docPackage = pkgs.stdenv.mkDerivation {
          pname = "liuxu-options-doc";
          version = "0";

          nativeBuildInputs = [ pkgs.mdbook ];

          dontUnpack = true;

          buildPhase = ''
            mkdir ./src

            cat > ./src/SUMMARY.md <<-EOF
            # Summary

            - [NixOS Options](os-options.md)
            - [Home Options](home-options.md)
            EOF

            mdbook init . \
              --title="Liuxu Options" \
              --ignore=none

            cp ${osMdDoc} ./src/os-options.md
            cp ${homeMdDoc} ./src/home-options.md

            mkdir -p $out

            mdbook build -d $out
          '';

          dontInstall = true;
        };
      in
      {
        default = docPackage;
        doc = docPackage;
      };
  };
}
