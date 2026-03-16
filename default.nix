{ config, lib, pkgs, ... }:

{
  imports =
    [
      ./hw.nix
      ./users
    ];


  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Virtualbox guest addons currently fails on kernel 6.19.
  boot.kernelPackages = pkgs.linuxPackages_6_18;

  networking.hostName = "LiAlH4-Nix";

  networking.networkmanager.enable = true;

  time.timeZone = "Asia/Shanghai";

  # Configure network proxy if necessary
  # networking.proxy.default = "http://user:password@proxy:port/";
  # networking.proxy.noProxy = "127.0.0.1,localhost,internal.domain";

  i18n.defaultLocale = "en_US.UTF-8";
  # console = {
  #   .font = "Lat2-Terminus16";
  #   keyMap = "us";
  #   useXkbConfig = true; # use xkb.options in tty.
  # };

  services.openssh.enable = true;

  # Enable CUPS to print documents.
  # services.printing.enable = true;

  services.pipewire = {
    enable = true;
    pulse.enable = true;
  };

  # Enable touchpad support (enabled default in most desktopManager).
  # services.libinput.enable = true;
  
  users = {
    mutableUsers = false;
    defaultUserShell = pkgs.fish;
    extraUsers.lialh4 = {
      isNormalUser = true;
      useDefaultShell = true;
      extraGroups = [ "wheel" ];
      hashedPassword = "$y$j9T$cBziI9e9scuRi5eybo9Te.$qIUfN3..ASc/yMcXbV4McCwN0pr9zvT/ihytrcd0j15";
      openssh.authorizedKeys.keys = [ "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDT8vagjK0tG4HNgk5vAPtIXyHJdEwg7dNPRsapZIObvShj7I92HxvWPqI/4ApkcWrTAB3z076S4H8cIuGxD4MTV4L55M/o5lfqcqdSlBv5H+u/r74FdQCo8uQXNqxo2gkO1Fhj3Ub8iGXe7nxjn6OUJdBnwDDBU/0YCgVwtiAesvsZwClLt5B0o/1F6MPUGTDQU3QYGV5F8baiabzi1lwh0utViM4PZzU9RbizcTf1nvuYQE9BTJdvgB/7R4/CgRxyURIDBPxznkse6eUMUHrsl/MxRUxsdjJS7b9FVYNpMJ8w53YCa0CBtIu6mXUd63PidmjV+O00RapxK7Q/rgqiaHUAHku8kew6yLBExpQh+d2IlLpijN7hYP7y06/FZcR5/dLXGw3dNKkCLr6lMx0AEAdpethUx5Tby8gkQ5wFO0omH3WS8dsYJ/3d7lOPvtKjEAOXwP23rAmZGgUhl6zK85B2KdROrRPCuzxAOrPevRgtpVhza9EABTzgVrg+jRs=" ];
      packages = with pkgs; [
        kitty
      ];
    };
  };

  # To make bundled auto-completion work
  programs.fish.enable = true;
  programs.hyprland = {
    enable = true;
    withUWSM = true;
    xwayland.enable = true;
  };

  # environment.systemPackages = with pkgs; [
  #  kitty
  # ];

  # Some programs need SUID wrappers, can be configured further or are
  # started in user sessions.
  # programs.mtr.enable = true;
  # programs.gnupg.agent = {
  #   enable = true;
  #   enableSSHSupport = true;
  # };

  # Open ports in the firewall.
  # networking.firewall.allowedTCPPorts = [ ... ];
  # networking.firewall.allowedUDPPorts = [ ... ];
  # Or disable the firewall altogether.
  # networking.firewall.enable = false;

  # Copy the NixOS configuration file and link it from the resulting system
  # (/run/current-system/configuration.nix). This is useful in case you
  # accidentally delete configuration.nix.
  # system.copySystemConfiguration = true;

  # This option defines the first version of NixOS you have installed on this particular machine,
  # and is used to maintain compatibility with application data (e.g. databases) created on older NixOS versions.
  #
  # Most users should NEVER change this value after the initial install, for any reason,
  # even if you've upgraded your system to a new NixOS release.
  #
  # This value does NOT affect the Nixpkgs version your packages and OS are pulled from,
  # so changing it will NOT upgrade your system - see https://nixos.org/manual/nixos/stable/#sec-upgrading for how
  # to actually do that.
  #
  # This value being lower than the current NixOS release does NOT mean your system is
  # out of date, out of support, or vulnerable.
  #
  # Do NOT change this value unless you have manually inspected all the changes it would make to your configuration,
  # and migrated your data accordingly.
  #
  # For more information, see `man configuration.nix` or https://nixos.org/manual/nixos/stable/options#opt-system.stateVersion .
  system.stateVersion = "25.11"; # Did you read the comment?

}

