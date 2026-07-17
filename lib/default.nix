{
  lib ? { },
  ...
}:
lib
// {
  liuxu =
    let
      inherit (builtins) genList;
      foldl = builtins.foldl';
      I = x: x;
      id = I;
      K = x: _: x;
      const = K;
      C =
        f: a: b:
        f b a;
      flip = C;
      B =
        f: g: x:
        x |> g |> f;
      o = B;
      compose = B;
      oo = compose2;
      o2 = compose2;
      compose2 = B B B;
      oN = composeN;
      composeN = n: if n < 1 then I else foldl (C I) o (genList (_: B B) (n - 1));
      on = B;
      on2 = B (B C) B B;
      onN = n: if n < 1 then K else foldl (C I) B (genList (_: B (B C) B) (n - 1));
    in
    {
      inherit
        I
        id
        K
        const
        C
        flip
        B
        o
        compose
        oo
        o2
        compose2
        oN
        composeN
        on
        on2
        onN
        ;
      mkIfElse =
        cond: onTrue: onFalse:
        lib.mkMerge [
          (lib.mkIf cond onTrue)
          (lib.mkIf (!cond) onFalse)
        ];
      hyprland =
        let
          mkBind = o: v: k: {
            _args = [
              k
              v
            ]
            ++ lib.optional (o != { }) o;
          };
          mkLuaBind = on2 mkBind lib.generators.mkLuaInline;
          mkExecrBind =
            let
              f = v: ''hl.dsp.exec_raw("${v}")'';
            in
            on2 mkLuaBind f;
        in
        {
          inherit mkBind mkLuaBind mkExecrBind;
          mkNormalLuaBind = mkLuaBind { };
          mkNormalExecrBind = mkExecrBind { };
          mkMouseLuaBind = mkLuaBind { mouse = true; };
          mkLockedExecrBind = mkExecrBind { locked = true; };
          mkRepeatingExecrBind = mkExecrBind { repeating = true; };
          mkLockedRepeatingExecrBind = mkExecrBind {
            locked = true;
            repeating = true;
          };
        };
      wm =
        let
          mkExecrBind = o: v: k: m: {
            opt = o;
            cmd = v;
            key = k;
            mod = m;
          };
        in
        {
          inherit mkExecrBind;
          mkNormalExecrBind = mkExecrBind { };
          mkLockedExecrBind = mkExecrBind { lock = true; };
          mkRepeatingExecrBind = mkExecrBind { repeat = true; };
          mkLockedRepeatingExecrBind = mkExecrBind {
            lock = true;
            repeat = true;
          };
        };
    };
}
