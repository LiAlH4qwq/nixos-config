{ pkgs, ... }: {
  home-manager.users.lialh4.home.pointerCursor = {
    enable = true;
    package = pkgs.rose-pine-cursor;
    name = "BreezeX-RosePineDawn-Linux";
    gtk.enable = true;
    x11.enable = true;
    hyprcursor.enable = true;
  };
}