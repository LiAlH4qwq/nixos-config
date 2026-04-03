_: {
  users.extraUsers.lialh4 = {
    isNormalUser = true;
    useDefaultShell = true;
    extraGroups = [ "wheel" ];
    hashedPassword = "$y$j9T$qYN7DaHGRbNISgIUKxLXc0$94rNlGWxfnPriGwCz7u9ASvCK4/MTpyPuGX.FrevJi5";
    openssh.authorizedKeys.keys = [
      "ssh-rsa AAAAB3NzaC1yc2EAAAADAQABAAABgQDT8vagjK0tG4HNgk5vAPtIXyHJdEwg7dNPRsapZIObvShj7I92HxvWPqI/4ApkcWrTAB3z076S4H8cIuGxD4MTV4L55M/o5lfqcqdSlBv5H+u/r74FdQCo8uQXNqxo2gkO1Fhj3Ub8iGXe7nxjn6OUJdBnwDDBU/0YCgVwtiAesvsZwClLt5B0o/1F6MPUGTDQU3QYGV5F8baiabzi1lwh0utViM4PZzU9RbizcTf1nvuYQE9BTJdvgB/7R4/CgRxyURIDBPxznkse6eUMUHrsl/MxRUxsdjJS7b9FVYNpMJ8w53YCa0CBtIu6mXUd63PidmjV+O00RapxK7Q/rgqiaHUAHku8kew6yLBExpQh+d2IlLpijN7hYP7y06/FZcR5/dLXGw3dNKkCLr6lMx0AEAdpethUx5Tby8gkQ5wFO0omH3WS8dsYJ/3d7lOPvtKjEAOXwP23rAmZGgUhl6zK85B2KdROrRPCuzxAOrPevRgtpVhza9EABTzgVrg+jRs="
    ];
  };
  home-manager.users.lialh4 = {
    liuxu.user = {
      gui.enable = true;
    };
  };
  libpam-pwdfile-rs = {
    pin.users.lialh4.secret = "$y$j9T$bjCgDKQCZmMhnca0Jw54X1$x4iqH6CXtKuBnFAPaO9M2Cdv6YMB.kPnFUBeGM4vUV4";
  };
}
