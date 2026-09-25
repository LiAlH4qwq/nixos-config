{ config, lib, ... }: {
  options.liuxu.nixos.microcode = {
    enable = lib.liuxu.mkOsSwitchOffOption ''
      Whether to enable CPU microcode loading.
        Not recommended to disable!
        Defaults to intel microcode,
        can be change in `config.liuxu.nixos.microcode.variant`
    '';
    variant = lib.mkOption {
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
  };

  config =
    let
      cfg = config.liuxu.nixos.microcode;
    in
    lib.mkIf cfg.enable (
      lib.mkMerge [
        (lib.mkIf (cfg.variant == "intel") { hardware.cpu.intel.updateMicrocode = true; })
        (lib.mkIf (cfg.variant == "amd") { hardware.cpu.amd.updateMicrocode = true; })
      ]
    );
}
