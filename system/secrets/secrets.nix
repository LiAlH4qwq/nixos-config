let
  lib = import ./lib.nix;
  partialConfig = import ./config.nix;
  config = lib.evalConfig { inherit lib partialConfig; };
  inherit (config) items keys;
  flatItems = lib.attrsToFlatAttrs items;
  allKeys = lib.attrValuesRecursive keys;
  finalItems = lib.mapAttrs' (n: v: {
    name = "./${n}.age";
    value = {
      armor = true;
    }
    // (if (v == true) then { publicKeys = allKeys; } else { publicKeys = v.keys; });
  }) flatItems;
in
finalItems
