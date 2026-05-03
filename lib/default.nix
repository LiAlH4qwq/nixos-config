{ lib, ... }:
lib
// {
  liuxu =
    let
      compose =
        f: g: x:
        x |> g |> f;
    in
    {
      inherit compose;
      o = compose;
      mkIfElse =
        cond: onTrue: onFalse:
        lib.mkMerge [
          (lib.mkIf cond onTrue)
          (lib.mkIf (!cond) onFalse)
        ];
    };
}
