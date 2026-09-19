{ root, ... }: {
  imports = [
    ./fs
    ./users
  ];

  liuxu.system.version-when-installed = "26.05";

  sops.secrets."localMachine/users/lialh4/hashedPassword" = {
    sopsFile = "${root}/sops/LiAlH4-DeployTest.yaml";
    neededForUsers = true;
  };
}
