{
  lib,
  openssh,
  pkgs,
  sops,
  ssh-to-age,
  writers,
}:
writers.writeNuBin "sops-ssh-key" (
  pkgs.replaceVars ./sops-ssh-key.nu {
    chmod = lib.getExe' pkgs.coreutils "chmod";
    ssh-keygen = lib.getExe' openssh "ssh-keygen";
    sshToAge = lib.getExe ssh-to-age;
    sops = lib.getExe sops;
  }
)
