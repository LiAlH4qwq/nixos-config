{ pkgs, ... }:
{
  home-manager.users.lialh4.i18n.inputMethod = {
    enable = true;
    type = "fcitx5";
    fcitx5 = {
      waylandFrontend = false;
      addons = with pkgs; [
        fcitx5-gtk
        fcitx5-rose-pine
        fcitx5-pinyin-zhwiki
        fcitx5-pinyin-moegirl
        fcitx5-pinyin-minecraft
        kdePackages.fcitx5-qt
        kdePackages.fcitx5-chinese-addons
      ];
    };
  };
}
