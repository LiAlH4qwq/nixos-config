{ lib, ... }:
lib
// {
  liuxu =
    let
      compose =
        f: g: x:
        x |> g |> f;
      compose2 = compose compose compose;
    in
    {
      inherit compose compose2;
      o = compose;
      oo = compose2;
      mkIfElse =
        cond: onTrue: onFalse:
        lib.mkMerge [
          (lib.mkIf cond onTrue)
          (lib.mkIf (!cond) onFalse)
        ];
      hyprland =
        let
          mkBind' = v: o: k: {
            _args = [
              k
              v
            ]
            ++ lib.optional (o != { }) o;
          };
          mkLuaBind' = compose mkBind' lib.generators.mkLuaInline;
          mkExecrBind' =
            let
              f = v: ''hl.dsp.exec_raw("${v}")'';
            in
            compose mkLuaBind' f;
          mkBind = lib.flip mkBind';
          mkLuaBind = lib.flip mkLuaBind';
          mkExecrBind = lib.flip mkExecrBind';
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
          mkBind' = v: o: v // lib.optionalAttrs (o != { }) { _props = o; };
          mkExecrBind' =
            let
              f = v: { spawn = v; };
            in
            compose mkBind' f;
          mkBind = lib.flip mkBind';
          mkExecrBind = lib.flip mkExecrBind';
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
          mkRepeatingExexrBind = mkExecrBind { repeat = true; };
          mkLockedRepeatingExecrBind = mkExecrBind {
            lock = true;
            repeat = true;
          };
        };
    };
}
