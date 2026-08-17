{
  config,
  lib,
  pkgs,
  ...
}:
{
  services.smartd = {
    enable = true;
    defaults.monitored =
      let
        tg-transient-wrapped = pkgs.tg-transient.wrap {
          tokenFile = config.age.secretsV2.smartd.bot.token.path;
          chatFile = config.age.secretsV2.smartd.bot.target.path;
        };
        tg-transient-wrapped-sh-arg = tg-transient-wrapped |> lib.getExe |> lib.escapeShellArg;
        notify = pkgs.writers.writeFishBin "smartd-notify" ''
          ${tg-transient-wrapped-sh-arg} "Smartd Notification" \n "$SMARTD_FAILTYPE" \n "$SMARTD_MESSAGE"
        '';
        notify-sh-arg = notify |> lib.getExe |> lib.escapeShellArg;
      in
      "-a -m dummy -M test -M exec ${notify-sh-arg}";
  };
  systemd.services.smartd.after = [
    "network-online.target"
    "agenix-install-secrets.service"
  ];
}
