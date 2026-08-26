let
  lib = import ./lib.nix;
  partialConfig = import ./config.nix;
  config = lib.evalConfig { inherit lib partialConfig; };
  inherit (config) items keys;
  flatKeys = lib.attrValuesRecursive keys;
  osItems = items.os;
  flatOsItems = lib.attrsToFlatAttrs osItems;
  finalOsItems = lib.mapAttrs' (n: v: {
    name = "./os/${n}";
    value = {
      armor = true;
    }
    // (if (v == true) then { publicKeys = flatKeys; } else { publicKeys = v.keys; });
  }) flatOsItems;
in
finalOsItems
