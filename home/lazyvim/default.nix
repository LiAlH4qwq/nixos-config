{ inputs, pkgs, ... }:
{
  imports = [ inputs.lazyvim.homeManagerModules.default ];

  programs.lazyvim = {
    enable = true;
    extras = {
      lang = {
        nix.enable = true;
      };
    };
    extraPackages = with pkgs; [
      statix # Nix Linter
    ];
    plugins = {
      theme = ''
        return {
          {
            "LazyVim/LazyVim",
            opts = {
              colorscheme = "catppuccin",
            },
          },
        }
      '';
      lsp = ''
        return {
          {
            "neovim/nvim-lspconfig",
            opts = {
              servers = {
                nil_ls = {
                  enabled = false,
                },
                nixd = {
                  cmd_env = {
                    NIX_CONFIG = "extra-experimental-features = pipe-operators",
                  },
                },
              },
            },
          },
        }
      '';
    };
  };
}
