{ lib, ... }: {
  options.liuxu.home.id =
    let
      inherit (lib.types) nullOr unspecified;
    in
    lib.mkOption {
      type = nullOr unspecified;
      default = null;
      example = lib.literalMD "`osConfig.id.lialh4`";
      description = "ID to use.";
    };
}
