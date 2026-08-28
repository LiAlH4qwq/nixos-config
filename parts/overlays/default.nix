{ inputs, ... }:
{
  flake.overlays.default = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (prev) config system;
    };
    bottles = prev.bottles.override { removeWarningPopup = true; };
    cloudflare-ddns = prev.cloudflare-ddns.overrideAttrs (
      new: old: {
        version = "1.17.0";
        src = prev.fetchFromGitHub {
          owner = "favonia";
          repo = "cloudflare-ddns";
          tag = "v${new.version}";
          hash = "sha256-03aXACmEXX75CGvnf1vuXhsMEcLb1W8/LL6GrdPORWE=";
        };
        vendorHash = "sha256-/vo5msKJ9J6Ga7BqGwavLlUGUSvkaCtmYFDI/2zBCv4=";
      }
    );
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
    pnpm_11 = final.unstable.pnpm_11;
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
