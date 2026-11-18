{ inputs, pkgs, ... }:
{
  imports = [ inputs.umbriel.nixosModules.default ];

  here = {
    switch = {
      generate = true;
      default = true;
      premise = {
        scope = "home";
        path = [
          "gui"
          "umbriel"
        ];
      };
    };
    apply.programs.umbriel = {
      enable = true;
      portalPackage =
        (inputs.xdg-desktop-portal-umbriel.packages.${pkgs.stdenv.hostPlatform.system}.default)
        .overrideAttrs
          (old: {
            # Upstream's new tests spawn a dbus session daemon that reads
            # /etc/dbus-1/session.conf; the build sandbox mounts /etc read-only
            # without it, so the suite cannot pass here. Both inputs it needs are
            # restated because the package keeps a required dep in checkInputs and
            # probes for dbus-run-session at configure time only when doCheck = true.
            doCheck = false;
            buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.libei ];
            nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [ pkgs.dbus ];
          });
    };
  };
}
