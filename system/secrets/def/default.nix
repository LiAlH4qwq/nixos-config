let
  alls = users ++ systems;
  users = [ lialh4 ];
  lialh4 = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIKPzvkOPfWZmx2zE6cJY4Qz+Z1dKXTgd6Y2I/RgIc86T";
  systems = [
    LiAlH4-Laptop
    LiAlH4-Server
  ];
  LiAlH4-Laptop = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIJ0MgEBFCBkrbZIi9JLRWGN17846odM3KMj+21eko4RK";
  LiAlH4-Server = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIEHgPw52HnxnsDNsnUxOLdMxfMiRdF7T0zbqO6dlBFgZ";
in
{
  "mihoyo-alink.age" = {
    publicKeys = alls;
    armor = true;
  };
  "devices.LiAlH4-Laptop.users.lialh4.password.age" = {
    publicKeys = alls;
    armor = true;
  };
  "devices.LiAlH4-Server.users.lialh4.password.age" = {
    publicKeys = alls;
    armor = true;
  };
}
