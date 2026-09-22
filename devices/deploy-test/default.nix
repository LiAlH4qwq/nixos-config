{ root, ... }: {
  imports = [
    ./fs
    ./users
  ];

  liuxu = {
    nixos.sops.localMachine.secrets."users/lialh4/hashedPassword".neededForUsers = true;
    system.version-when-installed = "26.05";
  };
}
