{ config, lib, ... }:
{
  here = {
    switch = {
      generate = true;
      default = true;
    };
    options.variant = lib.mkOption {
      type = lib.types.enum [
        "intel"
        "amd"
      ];
      default = "intel";
      example = "amd";
      description = lib.liuxu.mkOsDesc ''
        CPU microcode variant,
          defaults to intel.
      '';
    };
    apply = lib.mkMerge [
      (lib.mkIf (config.liuxu.nixos.microcode.variant == "intel") {
        hardware.cpu.intel.updateMicrocode = true;
      })
      (lib.mkIf (config.liuxu.nixos.microcode.variant == "amd") {
        hardware.cpu.amd.updateMicrocode = true;
      })
    ];
  };
}
