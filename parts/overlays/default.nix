{ inputs, ... }:
{
  flake.overlays.default = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (prev) config system;
    };
    bottles = prev.bottles.override { removeWarningPopup = true; };
    hyprland = prev.hyprland.overrideAttrs (old: {
      cmakeFlags =
        (builtins.filter (f: !(final.lib.hasPrefix "-DNO_UWSM=" f)) (old.cmakeFlags or [ ]))
        ++ [ (final.lib.strings.cmakeBool "NO_UWSM" true) ];
      passthru = (old.passthru or { }) // {
        providedSessions = builtins.filter (s: s != "hyprland-uwsm") (old.passthru.providedSessions or [ ]);
      };
    });
    niri = prev.niri.overrideAttrs (old: {
      patches = (old.patches or [ ]) ++ [
        (prev.fetchpatch {
          url = "https://patch-diff.githubusercontent.com/raw/niri-wm/niri/pull/1791.patch";
          hash = "sha256-dyB6BMnrFi+DRI0q+sP4L17WvsxDmMjcV2ZVsCiGLis=";
        })
      ];
    });
    qq = prev.qq.overrideAttrs (old: {
      version = "3.2.32-2026-07-30";
      src = prev.fetchurl {
        url = "https://qqdl.gtimg.cn/qqfile/QQNT/9.9.33/release/c97651b2/QQ_3.2.32_260730_amd64_01.deb";
        hash = "sha256-ga4rhULvUxH8cuz1PJpSOSPINFacew2lLgv0Nguctfk=";
      };
    });
    wechat = prev.wechat.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ prev.makeWrapper ];
      postFixup = ''
        ${old.postFixup or ""}
        wrapProgram $out/bin/wechat \
          --set QT_IM_MODULE fcitx
      '';
    });
    wpsoffice-cn = prev.wpsoffice-cn.overrideAttrs (old: {
      nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ prev.makeWrapper ];
      postFixup = ''
        ${old.postFixup or ""}
        for p in $out/bin/*; do
          wrapProgram "$p" \
            --set QT_IM_MODULE fcitx
        done
      '';
    });
  };
}
