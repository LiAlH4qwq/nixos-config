{
  config,
  lib,
  ...
}:
let
  cfg = config.liuxu.nixos.sunshine;
  desc = lib.liuxu.mkOsDesc;
in
{
  here = {
    switch.generate = true;
    options = {
      sunshineName = lib.mkOption {
        type = lib.types.nullOr lib.types.singleLineStr;
        default = null;
        example = "Sunshine";
        description = desc ''
          Name displayed by Moonlight.
            Null lets Sunshine use the host name.
        '';
      };
      outputName = lib.mkOption {
        type = lib.types.nullOr lib.types.singleLineStr;
        default = null;
        example = "DP-1";
        description = desc ''
          Display to stream,
            as a stable DRM connector name.
            Null lets Sunshine select the default display.
        '';
      };
      capture = lib.mkOption {
        type = lib.types.enum [
          "kms"
          "wlr"
          "x11"
        ];
        default = "kms";
        example = "wlr";
        description = desc ''
          Sunshine capture backend.
            Umbriel exposes no wlr-screencopy,
            so DRM/KMS is required.
        '';
      };
      audioSink = lib.mkOption {
        type = lib.types.singleLineStr;
        default = "sunshine";
        example = "sunshine";
        description = desc ''
          Name of the virtual sink used for audio loopback.
        '';
      };
    };
    apply = {
      services.sunshine = {
        enable = true;
        # DRM/KMS capture needs CAP_SYS_ADMIN.
        capSysAdmin = true;
        settings = {
          capture = cfg.capture;
          origin_web_ui_allowed = "lan";
          # LAN only, so skip encryption for lower latency.
          lan_encryption_mode = 0;
          audio_sink = cfg.audioSink;
          virtual_sink = cfg.audioSink;
        }
        // lib.optionalAttrs (cfg.sunshineName != null) {
          sunshine_name = cfg.sunshineName;
        }
        // lib.optionalAttrs (cfg.outputName != null) {
          output_name = cfg.outputName;
        };
      };

      # Virtual sink so host audio can be streamed
      # (and the host muted while streaming).
      services.pipewire.extraConfig.pipewire."99-sunshine" = {
        "context.objects" = [
          {
            factory = "adapter";
            args = {
              "factory.name" = "support.null-audio-sink";
              "node.name" = cfg.audioSink;
              "node.description" = "Sunshine Sink";
              "media.class" = "Audio/Sink";
              "object.linger" = true;
              "audio.position" = [
                "FL"
                "FR"
              ];
            };
          }
        ];
      };
    };
  };
}
