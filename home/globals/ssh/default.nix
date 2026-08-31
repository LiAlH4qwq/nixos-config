_: {
  programs.ssh = {
    enable = true;
    # See: https://mynixos.com/home-manager/option/programs.ssh.enableDefaultConfig
    enableDefaultConfig = false;
  };

  home.file = {
    ssh-id-pub = {
      target = ".ssh/id_ed25519.pub";
      text = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKPzvkOPfWZmx2zE6cJY4Qz+Z1dKXTgd6Y2I/RgIc86T";
    };
  };

  liuxu.home.internal.intransience.files = [
    {
      path = ".ssh/id_ed25519";
      mode = "0600";
    }
  ];
}
