{ config, pkgs, ... }: {
  here = { };
  services.sing-box.settings = {
    experimental = {
      clash_api = {
        external_controller = "[::1]:9090";
        external_ui = "${pkgs.metacubexd}";
      };
      cache_file = {
        enabled = true;
        store_dns = true;
        store_fakeip = true;
      };
    };
    outbounds = [
      {
        tag = "direct";
        type = "direct";
      }
      {
        type = "anytls";
        tag = "vps-anytls";
        server = "speedtest.lialh4.cyou";
        server_port = 443;
        password = {
          _secret = config.vaultix.secrets."anytls/password".path;
        };
        tls = {
          enabled = true;
          server_name = "speedtest.lialh4.cyou";
        };
      }
    ];
    inbounds = [
      {
        type = "tun";
        strict_route = true;
        auto_route = true;
        auto_redirect = true;
        address = [
          "172.18.0.1/30"
          "fdfe:dcba:9876::1/126"
        ];
      }
    ];
  };
}
