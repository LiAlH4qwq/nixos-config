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
      ai.accessToken =
        let
          args = {
            _isArgs = true;
            keys = lib.attrValuesRecursive config.keys;
            user = "lialh4";
            group = "users";
          };
        in
        {
          kimi = args;
          mimo = args;
          deepseek = args;
        };
      mihoyo.alink = true;
      smartd.bot = {
        target = true;
        token = true;
      };
      devices = {
        LiAlH4-Laptop.users.lialh4.password = true;
        LiAlH4-Server = {
          users.lialh4.password = true;
          samba.users.lialh4.passwordFile = true;
          cloudflare-ddns.credentialsFile = {
            _isArgs = true;
            keys = lib.attrValuesRecursive config.keys;
            user = "cloudflare-ddns";
            group = "cloudflare-ddns";
          };
          cloudflared.tunnels.LiAlH4-Server.credentialsFile = true;
          hermes.environmentFile = true;
        };
      };
    };
  };
}
