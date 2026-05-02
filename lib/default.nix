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
    };
}
