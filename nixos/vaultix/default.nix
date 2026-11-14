{
  config,
  inputs,
  lib,
  pkgs,
  root,
  ...
}:
{
  imports = [ inputs.vaultix.nixosModules.default ];

  here = {
    options = {
      hostPubkey = lib.mkOption {
        type = lib.types.nullOr lib.types.str;
        default = null;
        example = lib.literalMD "`config.liuxu.id.lialh4.ssh.key.primary`";
        description = lib.liuxu.mkOsDesc ''
          SSH public key of this host,
            used by vaultix to re-encrypt secrets for the host.
        '';
      };
      hostKeys = lib.mkOption {
        type = lib.types.listOf (
          lib.types.coercedTo lib.types.path (path: {
            inherit path;
            type = "age";
          }) lib.types.attrs
        );
        default = [
          {
            path = "/persist/etc/ssh/ssh_host_ed25519_key";
            type = "ed25519";
          }
        ];
        description = lib.liuxu.mkOsDesc ''
          Host private keys used by vaultix to decrypt secrets while deploying.

          Defaults to the persisted SSH host key, which is the layout used by
          all regular NixOS hosts in this repo. Hosts without preservation
          (e.g. the live CD) must override this.
        '';
      };
      localMachine = {
        secrets = lib.mkOption {
          type = with lib.types; attrsOf unspecified;
          default = { };
          description = lib.liuxu.mkOsDesc ''
            Vaultix-native local machine secrets.
              Each key is the vaultix secret id and is mapped to
              `config.vaultix.secrets.<name>`. If `file` is omitted it defaults
              to `secrets/hosts/<hostName>/<name>.age`.
          '';
        };
        templates = lib.mkOption {
          type = with lib.types; attrsOf unspecified;
          default = { };
          description = lib.liuxu.mkOsDesc ''
            Vaultix-native local machine templates,
              mapped directly to `config.vaultix.templates.<name>`.
          '';
        };
        beforeUserborn = lib.mkOption {
          type = with lib.types; listOf str;
          default = [ ];
          description = lib.liuxu.mkOsDesc ''
            Secret/template ids that vaultix must deploy before userborn runs.
          '';
        };
      };
    };

    apply =
      let
        cfg = config.liuxu.nixos.vaultix;
        hostDir = root + "/secrets/hosts/${config.networking.hostName}";
        localSecrets =
          cfg.localMachine.secrets |> lib.mapAttrs (n: v: v // { file = v.file or (hostDir + "/${n}.age"); });
      in
      {
        vaultix = {
          settings = lib.mkMerge [
            (lib.mkIf (cfg.hostPubkey != null) { inherit (cfg) hostPubkey; })
            { inherit (cfg) hostKeys; }
          ];
          secrets = localSecrets;
          templates = cfg.localMachine.templates;
          inherit (cfg.localMachine) beforeUserborn;
        };

        environment.systemPackages = with pkgs; [
          age
          ssh-to-age
        ];
      };
  };
}
