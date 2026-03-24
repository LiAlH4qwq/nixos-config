{
  pkgs,
  ...
}:
{
  imports = [
    ./hw
  ];

  liuxu = {
    system = {
      fprint.enable = true;
      laptop.enable = true;
      podman.enable = true;
      virtualbox.enable = true;
    };
  };

  networking.hostName = "LiAlH4-Laptop-Nix";

  time.timeZone = "Asia/Shanghai";

  environment.systemPackages = with pkgs; [
    sbctl
    brightnessctl
  ];
}
