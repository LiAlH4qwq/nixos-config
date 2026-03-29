{
  config,
  lib,
  pkgs,
  self,
  ...
}:
{
  options.security.pam.services = lib.mkOption {
    type = lib.types.attrsOf (
      lib.types.submodule {
        options.pwdfileAuth = {
          enable = lib.mkOption {
            type = lib.types.bool;
            default = false;
            example = true;
            description = "Enable pwdfile authentication by libpam_pwdfile_rs.";
          };
          pwdfile = lib.mkOption {
            type = lib.types.path;
            default = /etc/pwdfile;
            example = /etc/pin;
            description = "Path to pwdfile used for authentication";
          };
        };
      }
    );
  };

  config =
    let
      libpam-pwdfile-rs = pkgs.callPackage "${self}/packages/libpam-pwdfile-rs" { };
    in
    {
      security.pam.services = lib.mapAttrs (_: serviceCfg: {
        text = lib.mkBefore (
          lib.optionalString serviceCfg.pwdfileAuth.enable ''
            auth sufficient ${libpam-pwdfile-rs}/lib/security/pam_pwdfile_rs.so pwdfile ${serviceCfg.pwdfileAuth.pwdfile}
          ''
        );
      }) config.security.pam.services;
    };
}
