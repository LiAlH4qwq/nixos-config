{ pkgs, ... }: {
  here = { };
  environment.systemPackages = with pkgs; [ fd ];
}
