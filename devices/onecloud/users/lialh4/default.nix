{ config, ... }: {
  users.users.lialh4 = {
    isNormalUser = true;
    extraGroups =
      let
        g = config.users.groups;
      in
      [
        g.wheel.name
      ];
    password = "testonly";
  };
}
