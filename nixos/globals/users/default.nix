{ config, lib, ... }: {
  options.liuxu.nixos.users = lib.mkOption {
    description = lib.liuxu.mkOsDesc ''
      Users config.
    '';
    default = { };
    example = {
      lialh4 = {
        username = "lialh4";
        identity = lib.literalMD ''root + "/identities/lialh4"'';
        trustedSshPubkeys = [ (lib.literalMD "<REDACTED>") ];
      };
    };
  };
}
