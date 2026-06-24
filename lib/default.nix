{ lib, ... }:
lib
// {
  liuxu =
    let
      inherit (lib) flip;
      o = compose;
      compose =
        f: g: x:
        x |> g |> f;
      oo = compose2;
      compose2 = compose compose compose;
      on2 = o (o flip) (o o flip);
    in
    {
      inherit
        o
        oo
        compose
        compose2
        on2
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
      niri =
        let
          mkBind = o: v: v // lib.optionalAttrs (o != { }) { _props = o; };
          mkExecrBind =
            let
              f = v: { spawn = v; };
            in
            on2 mkBind f;
        in
        {
          inherit mkBind mkExecrBind;
          mkNormalBind = mkBind { repeat = false; };
          mkRepeatingBind = mkBind { repeat = true; };
          mkNormalExecrBind = mkExecrBind { repeat = false; };
          mkLockedExecrBind = mkExecrBind {
            allow-when-locked = true;
            repeat = false;
          };
          mkRepeatingExecrBind = mkExecrBind { repeat = true; };
          mkLockedRepeatingExecrBind = mkExecrBind {
            allow-when-locked = true;
            repeat = true;
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
