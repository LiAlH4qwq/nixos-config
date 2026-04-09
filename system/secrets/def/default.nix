let
  alls = users ++ systems;
  users = [ lialh4 ];
  lialh4 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOrK8/XY2U6HQJ79HourV5SBele6qPn83iAwBda6xozd";
  systems = [ thinkbook-14-g4p-iap ];
  thinkbook-14-g4p-iap = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ0MgEBFCBkrbZIi9JLRWGN17846odM3KMj+21eko4RK";
in
{
  "mihoyo-alink.age" = {
    publicKeys = alls;
    armor = true;
  };
}
