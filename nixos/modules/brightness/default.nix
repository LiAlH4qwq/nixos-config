{ pkgs, ... }:
{
  here = {
    switch.generate = true;
    apply = {
      environment.systemPackages = with pkgs; [
        brightnessctl
      ];
      # Prevent brightness setting loss when rebooting.
      preservation.preserveAt.persist.directories = [ "/var/lib/systemd/backlight" ];
    };
  };
}
