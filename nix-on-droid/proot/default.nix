_: {
  # Temporary fix proot failure.
  # See: https://github.com/nix-community/nix-on-droid/issues/519
  build.activation.z_replace_back_proot = ''
    echo "overwriting proot-static.new with old (and working) proot executable"
    cp -v /data/data/com.termux.nix/files/usr/bin/proot-static /data/data/com.termux.nix/files/usr/bin/.proot-static.new
  '';
}
