{ config, lib }: {
  keys = {
    users.lialh4 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKPzvkOPfWZmx2zE6cJY4Qz+Z1dKXTgd6Y2I/RgIc86T";
    systems = {
      LiAlH4-Laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ0MgEBFCBkrbZIi9JLRWGN17846odM3KMj+21eko4RK";
      LiAlH4-Server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHgPw52HnxnsDNsnUxOLdMxfMiRdF7T0zbqO6dlBFgZ";
    };
  };
  items = {
    os = {
      accessToken =
        let
          args = {
            _isArgs = true;
            keys = lib.attrValuesRecursive config.keys;
            perm = "0440";
            group = "users";
          };
        in
        {
          ai = {
            kimi = args;
            mimo = args;
            deepseek = args;
          };
          github.public-ro = args;
          ssh.nix-build = true;
        };
      devices.LiAlH4-Server = {
        samba.users.lialh4.passwordFile = true;
        cloudflared.tunnels.LiAlH4-Server.credentialsFile = true;
      };
    };
  };
}
