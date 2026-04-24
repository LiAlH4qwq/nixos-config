{
  config,
  lib,
  ...
}:
{
  options.liuxu.nixos.virtualbox.enable = lib.mkOption {
    type = lib.types.bool;
    default = false;
    example = true;
    description = ''
      Liuxu: Whether to enable Virtualbox,
        an easy to use virtual machines manager.
    '';
  };

  config = lib.mkIf config.liuxu.nixos.virtualbox.enable {
    virtualisation.virtualbox.host = {
      enable = true;
      # For USB 3.0 support and more, we don't care about FOSS.
      enableExtensionPack = true;
      # No need for Virtualbox's kernel module.
      enableKvm = true;
      # Conflict with KVM mode above.
      addNetworkInterface = false;
    };
  };
}
