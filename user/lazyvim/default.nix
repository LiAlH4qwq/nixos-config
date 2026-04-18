{ inputs, ... }:
{
  imports = [ inputs.lazyvim.homeManagerModules.default ];

  programs.lazyvim = {
    enable = true;
    extras = {
      lang = {
        nix.enable = true;
      };
    };
    plugins = {
      theme = ''
        return {
          {
            "LazyVim/LazyVim",
            opts = {
              colorscheme = "catppuccin",
            },
          }
        }
      '';
    };
  };
}
