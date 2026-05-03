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
    };
}
