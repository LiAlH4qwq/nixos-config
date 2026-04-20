{ inputs, ... }:
{
  flake = {
    deploy = {
      sudo = "run0 -u";
      interactiveSudo = true;
      fastConnection = true;
      nodes = {
        LiAlH4-Server = {
          hostname = "LiAlH4-Server";
          profiles.system = {
            user = "root";
            path = inputs.deploy-rs.lib.x86_64-linux.activate.nixos inputs.self.nixosConfigurations.LiAlH4-Server;
          };
        };
      };
    };
  };
}
