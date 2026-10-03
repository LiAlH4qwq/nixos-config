{ config, pkgs, ... }:
{
  liuxu.nixos.users.lialh4 = {
    id = config.liuxu.id.lialh4;
    # Test host: no per-host sops file, so use a locked password.
    hashedPasswordFile = toString (pkgs.writeText "deploy-test-hashed-password" "!");
  };
  users.extraUsers.lialh4 = {
    useDefaultShell = true;
    extraGroups = [
      "wheel"
    ];
  };
  home-manager.users.lialh4 = {
    liuxu.home = {
      gui.umbriel.enable = true;
      ai-coding-agent.opencode.enable = true;
    };
  };
}
