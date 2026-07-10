{
  config,
  inputs,
  lib,
  ...
}:
let
  common = import ./common.nix;
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
    default =
      common.items
      |> lib.mapAttrsRecursive (
        p: _:
        config.age.secrets |> builtins.getAttr (builtins.concatStringsSep "." p) |> builtins.getAttr "path"
      );
    description = ''
      Liuxu: Read only wrapper of config.age.\$\{name}.path.
        For example:
          config.age.secretsV2.path.to.secret translates to config.age.secrets."path.to.secrets".path
    '';
  };

  config.age = {
    # Fix conflicting with impermanence.
    # Otherwise, the agenix will try to do decryption
    # before impermanence mounts keys in `/etc/ssh`
    # which results in decryption failed.
    identityPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
    secrets = common.module;
  };
}
