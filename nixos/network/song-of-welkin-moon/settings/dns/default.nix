_: {
  here = { };
  services.sing-box.settings.dns = {
    optimistic = true;
    reverse_mapping = true;
    strategy = "prefer_ipv6";
    final = "cloudflare";
    servers = [
      {
        tag = "cloudflare";
        type = "tls";
        server = "1.1.1.1";
      }
      {
        tag = "alidns";
        type = "tls";
        server = "223.5.5.5";
      }
      {
        tag = "fakeip";
        type = "fakeip";
        inet4_range = "198.18.0.0/15";
        inet6_range = "fc00::/18";
      }
    ];
    rules = [
      # Fix connection reset of some client when no ipv6 address.
      {
        type = "logical";
        mode = "and";
        action = "predefined";
        rules = [
          { query_type = [ "AAAA" ]; }
          {
            default_interface_address = [ "2000::/3" ];
            invert = true;
          }
        ];
      }
      {
        tag = "query_cloudflare";
        action = "evaluate";
        server = "cloudflare";
      }
      {
        match_response = "query_cloudflare";
        rule_set = [
          "geosite-cn"
          "geoip-cn"
        ];
        server = "alidns";
      }
      {
        query_type = [
          "A"
          "AAAA"
        ];
        server = "fakeip";
      }
    ];
  };
}
