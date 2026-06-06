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
          mkBind = o: v: k: {
            _args = [
              k
              v
            ]
            ++ lib.optional (o != { }) o;
          };
          mkLuaBind =
            o: v: k:
            mkBind o (lib.generators.mkLuaInline v) k;
          mkExecrBind =
            o: v: k:
            mkLuaBind o ''hl.dsp.exec_raw("${v}")'' k;
        in
        {
          inherit mkBind mkLuaBind mkExecrBind;
          mkNormalLuaBind = v: k: mkLuaBind { } v k;
          mkNormalExecrBind = v: k: mkExecrBind { } v k;
          mkMouseLuaBind = v: k: mkLuaBind { mouse = true; } v k;
          mkLockedExecrBind = v: k: mkExecrBind { locked = true; } v k;
          mkRepeatingExecrBind = v: k: mkExecrBind { repeating = true; } v k;
          mkLockedRepeatingExecrBind =
            v: k:
            mkExecrBind {
              locked = true;
              repeating = true;
            } v k;
        };
    };
}
