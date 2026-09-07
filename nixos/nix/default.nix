{
  config,
  inputs,
  lib,
  ...
}:
{
  imports = [
    ./lix
    ./nixos
  ];

  nix = {
    channel.enable = false;
    distributedBuilds = true;
    buildMachines = [
      {
        systems = import inputs.systems;
        hostName = "genshin.lialh4.cyou:14159";
        sshUser = "builder";
        sshKey = config.age.secretsV2.accessToken.ssh.nix-build.path;
      }
    ];
    settings =
      let
        admins = [
          "root"
          "@wheel"
        ];
      in
      {
        allowed-users = admins;
        trusted-users = admins;
        auto-allocate-uids = true;
        builders-use-substitutes = true;
        http3 = true;
        use-cgroups = true;
        use-xdg-base-directories = true;
      };
  };
  intransience.datastores.persist.files = lib.singleton "/root/.local/share/nix/trusted-settings.json";
}
