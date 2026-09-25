_: {
  imports = [
    ./dns
    ./route
  ];

  services.sing-box.settings = {
    experimental = {
      clash_api = {
        external_controller = "[::1]:9090";
        external_ui = "ui";
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
