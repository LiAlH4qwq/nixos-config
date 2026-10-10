{ pkgs, ... }: {
  here = { };
  environment.systemPackages = with pkgs; [ ripgrep ];
}
