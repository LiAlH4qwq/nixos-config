{
  config,
  inputs,
  lib,
  pkgs,
  ...
}:
let
  libSelf = import ./lib.nix;
  partialConfigSelf = import ./config.nix;
  configSelf = libSelf.evalConfig {
    lib = libSelf;
    partialConfig = partialConfigSelf;
  };
  itemsSelf = configSelf.items;
  osItemsSelf = itemsSelf.os;
  finalOsItemsSelf = libSelf.pipe osItemsSelf [
    (libSelf.mapAttrsUntilArgs (
      p: v:
      {
        _isArgs = true;
        file = ./. + "/os/${libSelf.pathToStr p}";
      }
      // (
        if v == true then
          { }
        else
          (
            { }
            // (if (v ? perm) then { mode = v.perm; } else { })
            // (if (v ? user) then { owner = v.user; } else { })
            // (if (v ? group) then { inherit (v) group; } else { })
          )
      )
    ))
  ];
  flatOsItemsSelf = libSelf.pipe finalOsItemsSelf [ libSelf.attrsToFlatAttrs ];
in
{
  imports = [ inputs.ragenix.nixosModules.default ];

  options.age.secretsV2 = lib.mkOption {
    readOnly = true;
    type =
      # Nix modules system doesn't allow it 😭.
      # let
      #   inherit (lib.types) either path lazyAttrsOf;
      #   pathTree = lazyAttrsOf (either path pathTree);
      # in
      # pathTree;
      lib.types.anything;
    default = libSelf.pipe finalOsItemsSelf [
      (libSelf.mapAttrsUntilArgs (
        p: v: { _isArgs = true; } // builtins.getAttr (libSelf.pathToStr p) config.age.secrets
      ))
    ];
    description = ''
      Liuxu: Read only wrapper of config.age.\$\{name}.path.
        For example:
          config.age.secretsV2.path.to.secret translates to config.age.secrets."path.to.secrets".path
    '';
  };

  config.age = {
    ageBin = lib.getExe pkgs.rage;
    # Fix conflicting with impermanence.
    # Otherwise, the agenix will try to do decryption
    # before impermanence mounts keys in `/etc/ssh`
    # which results in decryption failed.
    identityPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
    secrets = flatOsItemsSelf;
  };
}
