{
  lib,
  pkgs,
  ...
}:
{
  here = {
    switch.generate = true;
    apply = {
      home.packages = [ pkgs.rustdesk ];

      # Autostart in the session, minimized to the tray.
      liuxu.home.gui.wm.autostart = [
        [
          (lib.getExe pkgs.rustdesk)
          "--tray"
        ]
      ];

      # RustDesk keeps its id, keys and permanent password here;
      # persist so unattended access survives.
      liuxu.home.preservation.directories = [
        ".config/rustdesk"
        ".local/share/rustdesk"
      ];
    };
  };
}
