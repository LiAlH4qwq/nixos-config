# Replace gnu utils to uutils one.
# Source: https://wiki.nixos.org/wiki/Uutils

{
  config,
  pkgs,
  lib,
  ...
}:
{
  system = {
    replaceDependencies.replacements =
      let
        coreutils-full-name =
          "coreuutils-full"
          + builtins.concatStringsSep "" (
            builtins.genList (_: "_") (builtins.stringLength pkgs.coreutils-full.version)
          );

        coreutils-name =
          "coreuutils"
          + builtins.concatStringsSep "" (
            builtins.genList (_: "_") (builtins.stringLength pkgs.coreutils.version)
          );

        findutils-name =
          "finduutils"
          + builtins.concatStringsSep "" (
            builtins.genList (_: "_") (builtins.stringLength pkgs.findutils.version)
          );

        diffutils-name =
          "diffuutils"
          + builtins.concatStringsSep "" (
            builtins.genList (_: "_") (builtins.stringLength pkgs.diffutils.version)
          );
      in
      [
        # coreutils
        {
          # system
          oldDependency = pkgs.coreutils-full;
          newDependency = pkgs.symlinkJoin {
            # Make the name length match so it builds
            name = coreutils-full-name;
            paths = [ pkgs.uutils-coreutils-noprefix ];
          };
        }
        {
          # applications
          oldDependency = pkgs.coreutils;
          newDependency = pkgs.symlinkJoin {
            # Make the name length match so it builds
            name = coreutils-name;
            paths = [ pkgs.uutils-coreutils-noprefix ];
          };
        }
        # findutils
        {
          # applications
          oldDependency = pkgs.findutils;
          newDependency = pkgs.symlinkJoin {
            # Make the name length match so it builds
            name = findutils-name;
            paths = [ pkgs.uutils-findutils ];
          };
        }
        # diffutils
        {
          # applications
          oldDependency = pkgs.diffutils;
          newDependency = pkgs.symlinkJoin {
            # Make the name length match so it builds
            name = diffutils-name;
            paths = [ pkgs.uutils-diffutils ];
          };
        }
      ];

    # Fix `nix-rebuild`,
    # add `-f` to `mv` call,
    # so it do not asks for confirmation.
    activationScripts = {
      # Source: https://github.com/NixOS/nixpkgs/blob/4e92bbcdb030f3b4782be4751dc08e6b6cb6ccf2/nixos/modules/config/shells-environment.nix#L270
      binsh = {
        deps = [ "stdio" ];
        text = lib.mkForce ''
          # Create the required /bin/sh symlink; otherwise lots of things
          # (notably the system() function) won't work.
          mkdir -p /bin
          chmod 0755 /bin
          ln -sfn "${config.environment.binsh}" /bin/.sh.tmp
          mv -f /bin/.sh.tmp /bin/sh # atomically replace /bin/sh
        '';
      };
      # Source: https://github.com/NixOS/nixpkgs/blob/3b8ea39fed3e5134ba8441abd1b420cc16040fec/nixos/modules/system/activation/activation-script.nix#L287-L300
      usrbinenv =
        if config.environment.usrbinenv != null then
          lib.mkForce ''
            mkdir -p /usr/bin
            chmod 0755 /usr/bin
            ln -sfn ${config.environment.usrbinenv} /usr/bin/.env.tmp
            mv -f /usr/bin/.env.tmp /usr/bin/env # atomically replace /usr/bin/env
          ''
        else
          ''
            rm -f /usr/bin/env
            if test -d /usr/bin; then rmdir --ignore-fail-on-non-empty /usr/bin; fi
            if test -d /usr; then rmdir --ignore-fail-on-non-empty /usr; fi
          '';
    };
  };
}
