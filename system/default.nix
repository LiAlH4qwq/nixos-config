{ lib, ... }: {
  networking.networkmanager.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  # To make distro bundled auto-completion rules work.
  programs.fish.enable = true;
  # it can't simply enabled in only user scope.
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
}