{ pkgs, ... }: {
  imports = [
    ./xcursor
    ./hyprtoolkit
    ./vscode
  ];

  users.extraUsers.lialh4 = {
    isNormalUser = true;
    useDefaultShell = true;
    extraGroups = [ "wheel" ];
    hashedPassword = "$y$j9T$L8jOFAGx53V0Cfgcrk6PV1$ej1axuFpwU07.zKv3oH4vzOJT2pooeS/fJu/uoCckR5";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDT8vagjK0tG4HNgk5vAPtIXyHJdEwg7dNPRsapZIObvShj7I92HxvWPqI/4ApkcWrTAB3z076S4H8cIuGxD4MTV4L55M/o5lfqcqdSlBv5H+u/r74FdQCo8uQXNqxo2gkO1Fhj3Ub8iGXe7nxjn6OUJdBnwDDBU/0YCgVwtiAesvsZwClLt5B0o/1F6MPUGTDQU3QYGV5F8baiabzi1lwh0utViM4PZzU9RbizcTf1nvuYQE9BTJdvgB/7R4/CgRxyURIDBPxznkse6eUMUHrsl/MxRUxsdjJS7b9FVYNpMJ8w53YCa0CBtIu6mXUd63PidmjV+O00RapxK7Q/rgqiaHUAHku8kew6yLBExpQh+d2IlLpijN7hYP7y06/FZcR5/dLXGw3dNKkCLr6lMx0AEAdpethUx5Tby8gkQ5wFO0omH3WS8dsYJ/3d7lOPvtKjEAOXwP23rAmZGgUhl6zK85B2KdROrRPCuzxAOrPevRgtpVhza9EABTzgVrg+jRs="
    ];
  };
  home-manager.users.lialh4 = {
    wayland.windowManager.hyprland = {
      enable = true;
      # Due to conflict with home-manager
      systemd.enable = false;
      settings = import ./hyprland;
    };
    # these hasn't been available as a program in release 25.11.
    home.packages = with pkgs; [
      # hyprlauncher
      nixfmt
      materialgram
    ];
    i18n.inputMethod = {
      enable = true;
      type = "fcitx5";
      fcitx5 = {
        waylandFrontend = true;
        addons = with pkgs; [
          fcitx5-gtk
          fcitx5-rose-pine
          fcitx5-pinyin-zhwiki
          fcitx5-pinyin-moegirl
          fcitx5-pinyin-minecraft
          kdePackages.fcitx5-qt
          kdePackages.fcitx5-chinese-addons
        ];
      };
    };
    services = {
      hyprpolkitagent.enable = true;
      hyprpaper.enable = true;
      mako.enable = true;
    };
    services.hyprpaper.settings = import ./hyprpaper;
    services.mako.settings = import ./mako;
    # when using genAttrs,
    # it will broken with error:
    # programs field already defined.
    programs = {
      home-manager.enable = true;
      fish.enable = true;
      firefox.enable = true;
      kitty.enable = true;
      foot.enable = true;
      git.enable = true;
      ashell.enable = true;
      vicinae = {
        enable = true;
        systemd = {
          enable = true;
          autoStart = true;
        };
      };
    };
    programs.ashell.settings = import ./ashell;
    programs.kitty.settings = import ./kitty;
    programs.git.settings = import ./git;

    # Reflects NixOS version when system installed.
    # Do not change it unless needed.
    home.stateVersion = "25.11";
  };
}
