{ inputs, ... }:
{
  flake = {
    overlays = {
      default = final: prev: {
        unstable = import inputs.nixpkgs-unstable {
          inherit (prev) config system;
        };
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
        zellij = prev.zellij.override (old: {
          rustPlatform = final.makeRustPlatform {
            cargo = final.rust-bin.stable.latest.minimal;
            rustc = final.rust-bin.stable.latest.minimal;
          };
        });
      };
    };
  };
}
