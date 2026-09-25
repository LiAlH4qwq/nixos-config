_: {
  services.sing-box.settings.route = {
    auto_detect_interface = true;
    find_process = true;
    find_neighbor = true;
    default_domain_resolver = "alidns";
    final = "default";
    rules = [
      { action = "sniff"; }
      {
        type = "logical";
        mode = "or";
        rules = [
          {
            protocol = "dns";
          }
          {
            port = 53;
          }
        ];
        action = "hijack-dns";
      }
      {
        ip_is_private = true;
        outbound = "direct";
      }
      {
        rule_set = "geosite-cn";
        outbound = "direct";
      }
      {
        rule_set = "geoip-cn";
        outbound = "direct";
      }
    ];
    rule_set = [
      {
        tag = "geosite-cn";
        type = "remote";
        format = "binary";
        download_detour = "default";
        url = "https://raw.githubusercontent.com/SagerNet/sing-geosite/rule-set/geosite-cn.srs";
      }
      {
        tag = "geoip-cn";
        type = "remote";
        format = "binary";
        download_detour = "default";
        url = "https://raw.githubusercontent.com/SagerNet/sing-geoip/rule-set/geoip-cn.srs";
      }
    ];
  };
}
