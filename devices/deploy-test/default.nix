_: {
  imports = [
    ./fs
    ./users
  ];

  liuxu = {
    # No `pin/users/<user>/hashedPassword` secret is configured for this host.
    nixos.pin.enable = false;
    system.version-when-installed = "26.05";
  };
}
