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
        cat = pkgs.uutils-coreutils-noprefix |> (p: "${p}/bin/cat") |> lib.escapeShellArg;
        notify = pkgs.writers.writeFishBin "smartd-notify" ''
          set -x TG_TRANSIENT_TOKEN (${cat} ${lib.escapeShellArg config.age.secretsV2.smartd.bot.token})
          ${
            pkgs.tg-transient |> lib.getExe |> lib.escapeShellArg
          } (${cat} ${lib.escapeShellArg config.age.secretsV2.smartd.bot.target}) "Smartd Notification"\n\n"$SMARTD_FAILTYPE"\n\n"$SMARTD_MESSAGE"
        '';
      in
      "-a -m smartd@lialh4.nix -M test -M exec ${lib.getExe notify |> lib.escapeShellArg}";
  };
}
