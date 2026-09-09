{ pkgs, ... }:
{
  services.kmscon = {
    enable = true;
    hwRender = true;
    extraConfig = ''
      font-size=28
      dpms-timeout=300
      palette=custom
      palette-black=242,233,225
      palette-red=180,99,122
      palette-green=40,105,131
      palette-yellow=234,157,52
      palette-blue=86,148,159
      palette-magenta=144,122,169
      palette-cyan=215,130,126
      palette-light-grey=152,147,165
      palette-dark-grey=152,147,165
      palette-light-red=180,99,122
      palette-light-green=40,105,131
      palette-light-yellow=234,157,52
      palette-light-blue=86,148,159
      palette-light-magenta=144,122,169
      palette-light-cyan=215,130,126
      palette-white=87,82,121
      palette-foreground=87,82,121
      palette-background=250,244,237
    '';
  };
}
