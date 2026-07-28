{ inputs, ... }:
{
  flake.overlays.default = final: prev: {
    unstable = import inputs.nixpkgs-unstable {
      inherit (prev) config system;
    };
    hyprland = prev.hyprland.overrideAttrs (old: {
      cmakeFlags =
        (builtins.filter (f: !(final.lib.hasPrefix "-DNO_UWSM=" f)) (old.cmakeFlags or [ ]))
        ++ [ (final.lib.strings.cmakeBool "NO_UWSM" true) ];
      passthru = (old.passthru or { }) // {
        providedSessions = builtins.filter (s: s != "hyprland-uwsm") (old.passthru.providedSessions or [ ]);
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
