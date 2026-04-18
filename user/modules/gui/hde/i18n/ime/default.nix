{
  config,
  lib,
  pkgs,
  ...
}:
{
  config = lib.mkIf config.liuxu.user.gui.enable {
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-gtk
          fcitx5-rose-pine
          fcitx5-pinyin-zhwiki
          fcitx5-pinyin-moegirl
          fcitx5-pinyin-minecraft
          kdePackages.fcitx5-qt
          kdePackages.fcitx5-chinese-addons
        ];
        settings = {
          inputMethod = {
            GroupOrder."0" = "Default";
            "Groups/0" = {
              Name = "Default";
              "Default Layout" = "us";
              DefaultIM = "shuangpin";
            };
            "Groups/0/Items/0".Name = "keyboard-us";
            "Groups/0/Items/1".Name = "shuangpin";
          };
          globalOptions = {
            Behavior = {
              # It needs string, otherwise it will break.
              # What a hell?
              AllowInputMethodForPassword = "True";
            };
            "Behavior/DisabledAddons" = {
              "0" = "clipboard";
            };
            # Free Win + Space.
            Hotkey = {
              EnumerateGroupForwardKeys = "";
              EnumerateGroupBackwardKeys = "";
            };
            # Switch
            "Hotkey/TriggerKeys" = {
              "0" = "Super+space";
            };
            # Temporary switch
            "Hotkey/AltTriggerKeys" = {
              "0" = "Shift_L";
              # Right Shift
              "1" = "Shift+Shift_R";
            };
          };
          addons = {
            classicui.globalSection = {
              Font = "Sans 12";
              MenuFont = "Sans 12";
              TrayFont = "Sans Bold 12";
              TrayOutlineColor = "#575279";
              TrayTextColor = "#575279";
              PreferTextIcon = "True"; # Tray
              Theme = "rose-pine-dawn";
              DarkTheme = "rose-pine-moon";
              UseDarkTheme = "True"; # Theme auto switch
            };
            punctuation.globalSection.TypePairedPunctuationsTogether = "True";
            chttrans.globalSection = {
              OpenCCS2TProfile = "s2twp.json";
              OpenCCT2SProfile = "tw2sp.json";
            };
            pinyin.globalSection = {
              ShuangpinProfile = "MS";
              CloudPinyinEnabled = "True";
            };
          };
        };
      };
    };
    home.file.fcitx5-punctuations = {
      force = true;
      source = ./punctuations.kv;
      target = ".local/share/fcitx5/punctuation/punc.mb.zh_CN";
    };
  };
}
