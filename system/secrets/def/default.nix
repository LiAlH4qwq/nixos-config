let
  alls = users ++ systems;
  users = [ lialh4 ];
  lialh4 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKPzvkOPfWZmx2zE6cJY4Qz+Z1dKXTgd6Y2I/RgIc86T";
  systems = [
    LiAlH4-Laptop
    LiAlH4-Server
  ];
  LiAlH4-Laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ0MgEBFCBkrbZIi9JLRWGN17846odM3KMj+21eko4RK";
  LiAlH4-Server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHgPw52HnxnsDNsnUxOLdMxfMiRdF7T0zbqO6dlBFgZ";
  flip =
    f: a: b:
    f b a;
  foldl = builtins.foldl';
  pipe = foldl (acc: cur: cur acc);
  compose =
    f: g: x:
    pipe x [
      g
      f
    ];
  o = compose;
  mkKvp = v: k: {
    name = k;
    value = v;
  };
  mkEntry = mkKvp {
    armor = true;
    publicKeys = alls;
  };
  objVEnrich = builtins.mapAttrs (flip mkKvp);
  obj2Arr = o builtins.attrValues objVEnrich;
  items = {
    mihoyo-alink = true;
    devices = {
      LiAlH4-Laptop.users.lialh4.password = true;
      LiAlH4-Server = {
        users.lialh4.password = true;
        cloudflared.tunnels.LiAlH4-Server.credentialsFile = true;
      };
    };
  };
  mkEntries =
    let
      mkEntries' =
        p: o:
        let
          isAtom = !(builtins.isAttrs o);
          forAtom = if o != true then [ ] else [ "${(builtins.concatStringsSep "." p)}.age" ];
          forNonAtom =
            let
              forNonAtomE = e: mkEntries' (p ++ [ e.name ]) e.value;
            in
            pipe o [
              obj2Arr
              (builtins.concatMap forNonAtomE)
            ];
        in
        if isAtom then forAtom else forNonAtom;
    in
    mkEntries' [ ];
in
pipe items [
  mkEntries
  (map mkEntry)
  builtins.listToAttrs
]
