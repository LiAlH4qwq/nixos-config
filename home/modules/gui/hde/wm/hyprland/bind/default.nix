{
  config,
  lib,
  ...
}:
{
  config = lib.mkIf config.liuxu.home.gui.hyprland.enable {
    wayland.windowManager.hyprland.settings.bind = with lib.liuxu.hyprland; [
      (mkNormalLuaBind "hl.dsp.window.float()" "SUPER + F")
      (mkRepeatingExecrBind "hyprnome -c" "SUPER + Tab")
      (mkRepeatingExecrBind "hyprnome -cp" "SUPER + ALT + Tab")
      (mkNormalExecrBind "hyprnome -mc" "SUPER + SHIFT + Tab")
      (mkNormalExecrBind "hyprnome -mcp" "SUPER + ALT + SHIFT + Tab")
      (mkNormalLuaBind ''hl.dsp.focus({ workspace = "emptymn" })'' "SUPER + grave")
      (mkNormalLuaBind ''hl.dsp.window.move({ workspace = "emptymn" })'' "SUPER + SHIFT + grave")
      (mkMouseLuaBind "hl.dsp.window.drag()" "SUPER + mouse:272")
      (mkMouseLuaBind "hl.dsp.window.resize()" "SUPER + ALT+ mouse:272")
      (mkNormalLuaBind ''hl.dsp.layout("colresize +0.05")'' "SUPER + Equal")
      (mkNormalLuaBind ''hl.dsp.layout("colresize -0.05")'' "SUPER + Minus")
    ];
  };
}
