{ inputs, ... }:
{
  flake = {
    overlays = {
      default = final: prev: {
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
        wechat = prev.symlinkJoin {
          name = "wechat";
          paths = [ prev.wechat ];
          nativeBuildInputs = [ prev.makeWrapper ];
          postBuild = ''
            wrapProgram $out/bin/wechat \
              --set QT_IM_MODULE fcitx \
          '';
        };
        wpsoffice-cn = prev.wpsoffice-cn.overrideAttrs (old: {
          nativeBuildInputs = old.nativeBuildInputs ++ [ prev.makeWrapper ];
          postFixup = (old.postFixup or "") + ''
            for bin in $out/bin/*; do                                                                                                                    
              wrapProgram "$bin" --set QT_IM_MODULE fcitx                                                                                                
            done
          '';
        });
      };
    };
  };
}
