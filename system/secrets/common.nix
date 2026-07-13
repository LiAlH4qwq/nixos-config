let
  items = {
    mihoyo.alink = true;
    devices = {
      LiAlH4-Laptop.users.lialh4.password = true;
      LiAlH4-Server = {
        users.lialh4.password = true;
        cloudflared.tunnels.LiAlH4-Server.credentialsFile = true;
        hermes.environmentFile = true;
      };
    };
  };
  keys = {
    users.lialh4 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKPzvkOPfWZmx2zE6cJY4Qz+Z1dKXTgd6Y2I/RgIc86T";
    systems = {
      LiAlH4-Laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ0MgEBFCBkrbZIi9JLRWGN17846odM3KMj+21eko4RK";
      LiAlH4-Server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHgPw52HnxnsDNsnUxOLdMxfMiRdF7T0zbqO6dlBFgZ";
    };
  };
  attrsToMapping = o listToAttrs (
    o (map (attrs: {
      inherit (attrs) value;
      name = concatStringsSep "." attrs.name;
    })) traverseAttrs
  );
  traverseAttrs = traverseAttrs' [ ];
  traverseAttrs' =
    path: attrs:
    if (!(isAttrs attrs)) then
      [ (valueNamePair attrs path) ]
    else
      pipe attrs [
        attrsToList
        (concatMap (vnp: traverseAttrs' (path ++ [ vnp.name ]) vnp.value))
      ];
  mapAttrs' = o (o listToAttrs) mapAttrsToList;
  attrsToList = mapAttrsToList (flip valueNamePair);
  mapAttrsToList = o (o attrValues) mapAttrs;
  valueNamePair = value: name: { inherit value name; };
  pipe = foldl (flip id);
  o =
    f: g: x:
    f (g x);
  flip =
    f: a: b:
    f b a;
  id = x: x;
  foldl = builtins.foldl';
  inherit (builtins)
    isAttrs
    attrValues
    listToAttrs
    mapAttrs
    concatMap
    concatStringsSep
    ;
in
{
  inherit items;
  cli = o (mapAttrs' (
    name: _: {
      name = "./${name}.age";
      value = {
        armor = true;
        publicKeys = o attrValues attrsToMapping keys;
      };
    }
  )) attrsToMapping items;
  module = o (mapAttrs (
    name: _: {
      file = ./. + "/${name}.age";
    }
  )) attrsToMapping items;
}
