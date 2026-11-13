{ lib, ... }: {
  here.option =
    let
      inherit (lib.types) nullOr unspecified;
      desc = lib.liuxu.mkHomeDesc;
    in
    lib.mkOption {
      type = nullOr unspecified;
      default = null;
      example = lib.literalMD "`osConfig.id.lialh4`";
      description = desc "ID to use.";
    };
}
