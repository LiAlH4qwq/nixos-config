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
    # I don't know why it didn't work :(
    # buildMachines =
    #   [
    #     "fd00::10"
    #     "fd00::20"
    #     "192.168.1.10"
    #     "192.168.1.20"
    #     "genshin.lialh4.cyou:14159"
    #   ]
    #   |> map (x: {
    #     systems = import inputs.systems;
    #     supportedFeatures = config.nix.settings.system-features;
    #     hostName = x;
    #     sshUser = "builder";
    #     sshKey = config.age.secretsV2.accessToken.ssh.nix-build.path;
    #   });
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
