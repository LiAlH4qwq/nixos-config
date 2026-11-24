_: {
  here = { };
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
          { protocol = "dns"; }
          { port = 53; }
        ];
        action = "hijack-dns";
      }
      {
        type = "logical";
        mode = "or";
        rules = [
          { protocol = "bittorrent"; }
          {
            process_name = [
              ".qbittorrent-nox-wrapped"
              "qbittorrent-nox"
            ];
          }
        ];
        outbound = "direct";
      }
      {
        process_name = [
          "ddns"
          "wineserver"
        ];
        outbound = "direct";
      }
      {
        process_name = [ "cloudflared" ];
        outbound = "vps-anytls";
      }
      {
        domain = [ "genshin.lialh4.cyou" ];
        outbound = "direct";
      }
      {
        ip_is_private = true;
        outbound = "direct";
      }
      {
        rule_set = "geosite-category-ai-!cn";
        outbound = "ai-not-cn";
      }
      {
        rule_set = "geosite-github";
        outbound = "github";
      }
      {
        type = "logical";
        mode = "or";
        rules = [
          { rule_set = "geosite-cn"; }
          { rule_set = "geoip-cn"; }
        ];
        outbound = "direct";
      }
      {
        user = [ "misskey" ];
        outbound = "vps-anytls";
      }
    ];
    rule_set =
      {
        geosite = [
          "category-ai-!cn"
          "github"
          "cn"
          "cloudflare"
        ];
        geoip = [ "cn" ];
      }
      |> builtins.mapAttrs (
        n:
        map (x: {
          tag = "${n}-${x}";
          type = "remote";
          format = "binary";
          download_detour = "default";
          url = "https://raw.githubusercontent.com/SagerNet/sing-${n}/rule-set/${n}-${x}.srs";
        })
      )
      |> builtins.attrValues
      |> builtins.concatLists;
  };
}
