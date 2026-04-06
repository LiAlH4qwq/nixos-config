{ lib, ... }:
let
  urlTestArgs = {
    lazy = true;
    interval = 300;
    timeout = 5000;
    expected-status = 204;
    url = "https://cp.cloudflare.com";
  };
in
{
  allow-lan = false;
  ipv6 = true;
  unified-delay = true;
  tcp-concurrent = true;
  external-controller = "[::1]:9090";
  profile = {
    store-selected = true;
    store-fakeip = true;
  };

  mixed-port = 7890;

  tun = {
    enable = true;
    stack = "gvisor";
    device = "mihoyo";
    auto-route = true;
    strict-route = true;
    auto-redirect = true;
    auto-detect-interface = true;
    gso = true;
    dns-hijack = [
      "any:53"
      "tcp://any:53"
    ];
  };

  geodata-mode = true;
  geo-auto-update = true;
  geo-update-interval = 24;
  geox-url = {
    geoip = "https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geoip.dat";
    geosite = "https://cdn.jsdelivr.net/gh/Loyalsoldier/v2ray-rules-dat@release/geosite.dat";
  };

  sniffer = {
    enable = true;
    parse-pure-ip = true;
    force-dns-mapping = true;
    override-destination = true;
    sniff =
      let
        httpsPort = 443;
      in
      {
        HTTP = {
          ports = [
            80
          ];
        };
        TLS = {
          ports = [
            httpsPort
          ];
        };
        QUIC = {
          ports = [
            httpsPort
          ];
        };
      };
  };

  dns =
    let
      doh-cn = [
        "https://223.5.5.5/dns-query"
        "https://119.29.29.29/dns-query"
      ];
    in
    {
      enable = true;
      ipv6 = true;
      # According to Genshin Impact Wiki
      # It's not recommended to enable `prefer-h3` and `respect-rules`
      # **simultaneously**.
      prefer-h3 = false;
      respect-rules = true;
      cache-algorithm = "arc";
      enhanced-mode = "fake-ip";
      fake-ip-filter = [
        "*"
        "+.lan"
      ];
      default-nameserver = doh-cn;
      proxy-server-nameserver = doh-cn;
      direct-nameserver = doh-cn;
      direct-nameserver-follow-policy = false;
      nameserver-policy = {
        "geosite:cn" = doh-cn;
      };
      nameserver = [
        "https://1.1.1.1/dns-query"
        "https://8.8.8.8/dns-query"
      ];
    };

  proxies =
    let
      proxyArgs = {
        udp = true;
        tfo = true;
        mptcp = true;
      };
    in
    [
      {
        inherit (proxyArgs) udp tfo mptcp;
        name = "Dns";
        type = "dns";
      }
      {
        inherit (proxyArgs) udp tfo mptcp;
        name = "Direct";
        type = "direct";
      }
    ];

  proxy-providers = {
    alink = {
      type = "http";
      url = lib.trim <| lib.readFile <| "/persist/secret/mihoyo/alink.url";
      interval = 21600;
      health-check = {
        enable = true;
        inherit (urlTestArgs)
          lazy
          interval
          timeout
          expected-status
          url
          ;
      };
    };
  };

  proxy-groups =
    let
      regs = [
        {
          name = "HK";
          emoji = "🇭🇰";
        }
        {
          name = "TW";
          emoji = "🇹🇼";
        }
        {
          name = "JP";
          emoji = "🇯🇵";
        }
        {
          name = "SG";
          emoji = "🇸🇬";
        }
        {
          name = "UK";
          emoji = "🇬🇧";
        }
        {
          name = "US";
          emoji = "🇺🇸";
        }
      ];
      grpArgs = {
        inherit (urlTestArgs)
          lazy
          interval
          timeout
          expected-status
          url
          ;
        include-all = true;
      };
      genRegAutoGrp =
        { name, emoji }:
        {
          inherit (grpArgs)
            lazy
            interval
            timeout
            expected-status
            url
            include-all
            ;
          name = "${name} Auto";
          type = "url-test";
          exclude-type = "dns|direct";
          filter = "^${emoji}";
        };
      genRouteGrp = name: {
        inherit (grpArgs)
          lazy
          interval
          timeout
          expected-status
          url
          include-all
          ;
        inherit name;
        type = "select";
        exclude-type = "dns";
        proxies = regAutoGrps;
      };
      regAutoGrps = map genRegAutoGrp regs;
    in
    (map genRouteGrp [
      "General"
      "AI Aborad"
    ])
    ++ regAutoGrps;

  rules = [
    "DST-PORT, 53, Dns"
    "GEOIP, lan, Direct, no-resolve"
    "GEOSITE, private, Direct, no-resolve"
    "GEOSITE, category-ai-!cn, AI Abroad"
    "GEOSITE, cn, Direct"
    "GEOIP, cn, Direct"
    "MATCH, General"
  ];
}
