{
  lib,
  pi-coding-agent,
  pkgs,
  writers,
}:
writers.writeNuBin "pi" (
  pkgs.replaceVars ./pi-catppuccin-latte.nu {
    pi = lib.getExe pi-coding-agent;
  }
)
