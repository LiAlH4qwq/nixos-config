lib: {
  liuxu =
    let
      # BEGIN toplevel
      I = x: x;
      id = I;
      K = x: _: x;
      const = K;
      C =
        f: a: b:
        f b a;
      flip = C;
      B =
        f: g: x:
        x |> g |> f;
      o = B;
      compose = B;
      oo = compose2;
      o2 = compose2;
      compose2 = B B B;
      oN = composeN;
      composeN = n: if n < 1 then I else B B (composeN (n - 1));
      on = B;
      on2 = B (B C) B B;
      onN =
        n:
        if n < 1 then
          K
        else if n < 2 then
          B
        else
          B (B C) B (onN (n - 1));
      rN = n: if n < 2 then I else B (B C) B (rN (n - 1));
      arN = n: if n < 2 then I else oN (n - 1) C (arN (n - 1));
      # END toplevel

      # BEGIN .modules
      mkIfElse =
        cond: onTrue: onFalse:
        lib.mkMerge [
          (lib.mkIf cond onTrue)
          (lib.mkIf (!cond) onFalse)
        ];
      mkOsDesc = desc: "Liuxu (OS): ${desc}";
      mkHomeDesc = desc: "Liuxu (Home): ${desc}";
      mkFpDesc = desc: "Liuxu (FP): ${desc}";
      mkComputedOption =
        type: by:
        lib.mkOption {
          inherit type;
          internal = true;
          readOnly = true;
          default = by;
        };
      mkSwitchOption =
        default: description:
        lib.mkOption {
          inherit default description;
          type = lib.types.bool;
          example = !default;
        };
      mkComputedSwitchOption = mkComputedOption lib.types.bool;
      mkSwitchOnOption = mkSwitchOption false;
      mkSwitchOffOption = mkSwitchOption true;
      mkOsSwitchOption = on2 mkSwitchOption mkOsDesc;
      mkOsSwitchOnOption = o mkSwitchOnOption mkOsDesc;
      mkOsSwitchOffOption = o mkSwitchOffOption mkOsDesc;
      mkHomeSwitchOption = on2 mkSwitchOption mkHomeDesc;
      mkHomeSwitchOnOption = o mkSwitchOnOption mkHomeDesc;
      mkHomeSwitchOffOption = o mkSwitchOffOption mkHomeDesc;
      mkFpSwitchOption = on2 mkSwitchOption mkFpDesc;
      mkFpSwitchOnOption = o mkSwitchOnOption mkFpDesc;
      mkFpSwitchOffOption = o mkSwitchOffOption mkFpDesc;
      # END .modules
    in
    {
      inherit
        # BEGIN toplevel
        I
        id
        K
        const
        C
        flip
        B
        o
        compose
        oo
        o2
        compose2
        oN
        composeN
        on
        on2
        onN
        rN
        arN
        # END toplevel

        # BEGIN .modules
        mkIfElse
        mkOsDesc
        mkHomeDesc
        mkFpDesc
        mkComputedOption
        mkSwitchOption
        mkComputedSwitchOption
        mkSwitchOnOption
        mkSwitchOffOption
        mkOsSwitchOption
        mkOsSwitchOnOption
        mkOsSwitchOffOption
        mkHomeSwitchOption
        mkHomeSwitchOnOption
        mkHomeSwitchOffOption
        mkFpSwitchOption
        mkFpSwitchOnOption
        mkFpSwitchOffOption
        # END .modules
        ;
      modules = {
        inherit
          mkIfElse
          mkOsDesc
          mkHomeDesc
          mkFpDesc
          mkComputedOption
          mkSwitchOption
          mkComputedSwitchOption
          mkSwitchOnOption
          mkSwitchOffOption
          mkOsSwitchOption
          mkOsSwitchOnOption
          mkOsSwitchOffOption
          mkHomeSwitchOption
          mkHomeSwitchOnOption
          mkHomeSwitchOffOption
          mkFpSwitchOption
          mkFpSwitchOnOption
          mkFpSwitchOffOption
          ;
      };
      hyprland =
        let
          mkBind = o: v: k: {
            _args = [
              k
              v
            ]
            ++ lib.optional (o != { }) o;
          };
          mkLuaBind = on2 mkBind lib.generators.mkLuaInline;
          mkExecrBind =
            let
              f = v: ''hl.dsp.exec_raw("${v}")'';
            in
            on2 mkLuaBind f;
        in
        {
          inherit mkBind mkLuaBind mkExecrBind;
          mkNormalLuaBind = mkLuaBind { };
          mkNormalExecrBind = mkExecrBind { };
          mkMouseLuaBind = mkLuaBind { mouse = true; };
          mkLockedExecrBind = mkExecrBind { locked = true; };
          mkRepeatingExecrBind = mkExecrBind { repeating = true; };
          mkLockedRepeatingExecrBind = mkExecrBind {
            locked = true;
            repeating = true;
          };
        };
      wm =
        let
          mkExecrBind = o: v: k: m: {
            opt = o;
            cmd = v;
            key = k;
            mod = m;
          };
        in
        {
          inherit mkExecrBind;
          mkNormalExecrBind = mkExecrBind { };
          mkLockedExecrBind = mkExecrBind { lock = true; };
          mkRepeatingExecrBind = mkExecrBind { repeat = true; };
          mkLockedRepeatingExecrBind = mkExecrBind {
            lock = true;
            repeat = true;
          };
        };
    };
}
