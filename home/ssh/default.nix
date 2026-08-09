{ self, ... }: {
  programs.ssh = {
    enable = true;
    # See: https://mynixos.com/home-manager/option/programs.ssh.enableDefaultConfig
    enableDefaultConfig = false;
  };

  home.file = {
    ssh-id-pub = {
      target = ".ssh/id_ed25519.pub";
      source = "${self}/assets/id_ed25519.pub";
    };
  };

  liuxu.home.internal.intransience.files = [ ".ssh/id_ed25519" ];
}
