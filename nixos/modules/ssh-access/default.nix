{ config, lib, ... }:
{
  options.liuxu.nixos.ssh-access.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu: Whether to enable the SSH access.
        Attention please: It will open firewall port!
          Do not use weak password!!!
    '';
  };

  config = lib.mkIf config.liuxu.nixos.ssh-access.enable {
    services.openssh.openFirewall = true;
  };
}
