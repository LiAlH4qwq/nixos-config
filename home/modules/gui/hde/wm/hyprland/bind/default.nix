{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.liuxu.home.gui.hyprland.enable {
    wayland.windowManager.hyprland.settings.bind =
      with lib.liuxu.hyprland;
      [
        (mkNormalLuaBind "hl.dsp.window.float()" "SUPER + F")
        (mkRepeatingExecrBind "hyprnome -c" "SUPER + Tab")
        (mkRepeatingExecrBind "hyprnome -cp" "SUPER + ALT + Tab")
        (mkNormalExecrBind "hyprnome -mc" "SUPER + SHIFT + Tab")
        (mkNormalExecrBind "hyprnome -mcp" "SUPER + ALT + SHIFT + Tab")
        (mkNormalLuaBind ''hl.dsp.focus({ workspace = "emptymn" })'' "SUPER + grave")
        (mkNormalLuaBind ''hl.dsp.window.move({ workspace = "emptymn" })'' "SUPER + SHIFT + grave")
        (mkMouseLuaBind "hl.dsp.window.drag()" "SUPER + mouse:272")
        (mkMouseLuaBind "hl.dsp.window.resize()" "SUPER + ALT+ mouse:272")
      ]
      ++ (lib.flip builtins.concatMap (lib.range 0 9) (
        k:
        let
          ks = toString k;
          w = if k == 0 then 10 else k;
          ws = toString w;
        in
        [
          (mkNormalLuaBind ''hl.dsp.focus({ workspace = "${ws}" })'' "SUPER + ${ks}")
          (mkNormalLuaBind ''hl.dsp.window.move({ workspace = "${ws}" })'' "SUPER + SHIFT + ${ks}")
        ]
      ));
  };
}
