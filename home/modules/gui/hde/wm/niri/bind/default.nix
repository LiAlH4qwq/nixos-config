{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.liuxu.home = {
    internal.gui.niri.keybinds.kdl = lib.mkOption {
      internal = true;
      readOnly = true;
      default = lib.kdl.formats.v1 [ (lib.kdl.extras.niri.binds config.liuxu.home.gui.niri.keybinds) ];
    };
    gui.niri.keybinds = lib.mkOption {
      type = lib.types.listOf lib.types.anything;
      default = [ ];
      example = with lib.kdl.extras.niri; [ (n "Mod+Q" [ close-window ]) ];
      description = ''
        Liuxu (Home): keybinds for niri,
          KDL snippit in nix-kdl expression.
      '';
    };
  };

  config = lib.mkIf config.liuxu.home.gui.niri.enable {
    liuxu.home.gui.niri.settings = lib.mkAfter (
      lib.kdl.formats.v1 (
        with lib.kdl.extras.niri;
        [
          (include (
            lib.liuxu.oo toString pkgs.writeText "niri-keybinds.kdl"
              config.liuxu.home.internal.gui.niri.keybinds.kdl
          ))
        ]
      )
    );
    liuxu.home.gui.niri.keybinds =
      with lib.kdl.extras.niri;
      [
        (n "Mod+F" [ toggle-window-floating ])
        (n "Mod+Equal" [ (set-column-width "+5%") ])
        (n "Mod+Minus" [ (set-column-width "-5%") ])
        (n "Mod+M" [ maximize-column ])
      ]
      ++ (
        builtins.genList lib.id 10
        |> builtins.concatMap (
          x:
          let
            key = toString x;
            ws = if x == 0 then 10 else x;
          in
          [
            (n "Mod+${key}" [
              (focus-workspace ws)
            ])
            (n "Mod+Shift+${key}" [
              (move-window-to-workspace ws)
            ])
          ]
        )
      );
  };
}
