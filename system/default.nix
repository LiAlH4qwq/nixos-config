{ lib, ... }: {
  imports = [
    ./fonts
  ];

  boot.plymouth.enable = true;
  nixpkgs.config.allowUnfree = true;
  networking.networkmanager.enable = true;
  services.displayManager.gdm.enable = true;
  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };
  # replace sudo with run0.
  security = {
    sudo.enable = false;
    polkit.enable = true;
  };
  # i hate bash btw.
  programs.fish.enable = true;
  # these programs can't simply be enabled only in the user scope.
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };
  programs.clash-verge = {
    enable = true;
    autoStart = true;
    serviceMode = true;
    tunMode = true;
  };
  # allow tun mode traffic.
  networking.firewall = {
    checkReversePath = false;
    trustedInterfaces = [
      "mihoyo"
    ];
  };
  programs._1password-gui.enable = true;
}
