_: {
  here = {
    switch.generate = true;
    apply.virtualisation.virtualbox.host = {
      enable = true;
      # For USB 3.0 support and more, we don't care about FOSS.
      enableExtensionPack = true;
      # No need for Virtualbox's kernel module.
      enableKvm = true;
      # Conflict with KVM mode above.
      addNetworkInterface = false;
    };
  };
}
