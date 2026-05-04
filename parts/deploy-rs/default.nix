{ inputs, ... }:
{
  flake = {
    deploy = {
      fastConnection = true;
      nodes = {
        LiAlH4-Server = {
          hostname = "LiAlH4-Server.lan";
          sshUser = "root";
          profiles.system = {
            user = "root";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations.LiAlH4-Server;
          };
        };
      };
    };
  };
  perSystem =
    { system, ... }:
    {
      checks = inputs.deploy-rs.lib.${system}.deployChecks inputs.self.deploy;
    };
}
