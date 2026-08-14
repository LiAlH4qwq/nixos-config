let
  # BEGIN Export
  attrsToFlatAttrs = flip pipe [
    (attrsToListRecursiveCond (const notArgs))
    listToFlatAttrs
  ];
  attrValuesRecursive = flip pipe [
    attrsToListRecursive
    (map ({ value, ... }: value))
  ];
  evalConfig =
    { lib, partialConfig }:
    fix (
      config:
      partialConfig {
        inherit config lib;
      }
    );
  mapAttrsUntilArgs = mapAttrsRecursiveCond (const notArgs);
  pathToStr = flip pipe [
    (map escapeDot)
    (concatStringsSep ".")
  ];
  pipe = foldl (flip id);
  # END Export

  fix =
    f:
    let
      x = f x;
    in
    x;
  notArgs = x: !(isAttrs x) || !(hasAttr "_isArgs" x) || (x._isArgs != true);
  listToFlatAttrs = o listToAttrs (
    map (
      { value, name }: {
        value = if !(isAttrs value) then value else removeAttrs value [ "_isArgs" ];
        name = pathToStr name;
      }
    )
  );
  escapeDot = replaceString "." "\\.";
  replaceString = apply2 replaceStrings singleton;
  attrsToListRecursive = attrsToListRecursiveCond (_: _: true);
  attrsToListRecursiveCond = flip mapAttrsToListRecursiveCond nameValuePair;
  mapAttrsToListRecursiveCond = mapAttrsToListRecursiveCond' [ ];
  mapAttrsToListRecursiveCond' =
    p: c: f: x:
    if (!((isAttrs x) && (c p x))) then
      [ (f p x) ]
    else
      concatMap ({ value, name }: mapAttrsToListRecursiveCond' (p ++ [ name ]) c f value) (attrsToList x);
  mapAttrsRecursiveCond = mapAttrsRecursiveCond' [ ];
  mapAttrsRecursiveCond' =
    p: c: f: x:
    if (!((isAttrs x) && (c p x))) then
      f p x
    else
      mapAttrs (n: v: mapAttrsRecursiveCond' (p ++ [ n ]) c f v) x;
  mapAttrs' = oo listToAttrs mapAttrsToList;
  attrsToList = mapAttrsToList nameValuePair;
  mapAttrsToList = oo attrValues mapAttrs;
  nameValuePair = flip valueNamePair;
  valueNamePair = value: name: { inherit value name; };
  singleton = x: [ x ];

  # Begin combinators
  apply2 =
    f: g: x: y:
    f (g x) (g y);
  oo = o o o;
  o =
    f: g: x:
    f (g x);
  flip =
    f: a: b:
    f b a;
  const = x: _: x;
  id = x: x;
  # End combinators

  # Begin inherit
  foldl = builtins.foldl';
  inherit (builtins)
    attrValues
    concatMap
    concatStringsSep
    hasAttr
    isAttrs
    listToAttrs
    mapAttrs
    replaceStrings
    ;
  # End inherit
in
{
  inherit
    attrsToFlatAttrs
    attrValuesRecursive
    evalConfig
    mapAttrs'
    mapAttrsUntilArgs
    pathToStr
    pipe
    ;
}
