{
  lib,
  openssh,
  pkgs,
  sops,
  writers,
}:
writers.writeNuBin "sops-ssh-key" (
  pkgs.replaceVars ./sops-ssh-key.nu {
    chmod = lib.getExe' pkgs.coreutils "chmod";
    ssh-keygen = lib.getExe' openssh "ssh-keygen";
    sops = lib.getExe sops;
  }
)
