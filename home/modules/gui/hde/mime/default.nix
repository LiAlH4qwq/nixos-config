{ config, lib, ... }: {
  config = lib.mkIf config.liuxu.home.internal.gui.enable (
    let
      withPrefix = prefix: map (x: "${prefix}${x}");
      mapping = {
        web = {
          handler = "zen-beta.desktop";
          formats =
            (withPrefix "application/x-extension-" [
              "http"
              "https"
              "chrome"
            ])
            ++ (withPrefix "x-scheme-handler/" [
              "htm"
              "html"
              "shtml"
              "xht"
              "xhtml"
            ])
            ++ [
              "application/xhtml+xml"
              "text/html"
            ];
        };
      };
    in
    {
      xdg.mimeApps = {
        enable = true;
        associations.added = config.xdg.mimeApps.defaultApplications;
        defaultApplications =
          mapping
          |> builtins.mapAttrs (
            _: v:
            (
              v.formats
              |> map (x: {
                name = x;
                value = v.handler;
              })
            )
          )
          |> builtins.attrValues
          |> builtins.concatLists
          |> builtins.listToAttrs;
      };
    }
  );
}
