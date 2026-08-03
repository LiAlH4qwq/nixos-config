{
  inputs,
  lib,
  self,
  ...
}:
{
  perSystem = { pkgs, system, ... }: {
    packages =
      let
        osModules = lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs self;
            inherit (self) lib;
          };
          modules = [
            { _module.check = false; }
            self.nixosModules.default
          ];
        };
        homeModules = inputs.home-manager.lib.homeManagerConfiguration {
          inherit pkgs;
          check = false;
          extraSpecialArgs = {
            inherit inputs self;
            inherit (self) lib;
            osConfig = osModules.config;
          };
          modules = [
            self.homeModules.default
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
            transformOptions = o: if (builtins.head o.loc) == "liuxu" then o else o // { visible = false; };
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
              --title="liuxu options" \
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
