{ inputs, ... }: {
  imports = [ inputs.sops.nixosModules.default ];

  sops = {
    age.sshKeyPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
  };
}
