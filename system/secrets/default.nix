{ inputs, ... }:
{
  imports = [ inputs.ragenix.nixosModules.default ];

  age = {
    # Fix conflicting with impermanence.
    # Otherwise, the agenix will try to do decryption
    # before impermanence mounts keys in `/etc/ssh`
    # which results in decryption failed.
    identityPaths = [ "/persist/etc/ssh/ssh_host_ed25519_key" ];
    secrets = {
      mihoyo-alink.file = ./def/mihoyo-alink.age;
      "devices.LiAlH4-Laptop.users.lialh4.password".file =
        ./def/devices.LiAlH4-Laptop.users.lialh4.password.age;
      "devices.LiAlH4-Server.users.lialh4.password".file =
        ./def/devices.LiAlH4-Server.users.lialh4.password.age;
    };
  };
}
