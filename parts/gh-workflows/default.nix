{ lib, ... }: {
  perSystem = { config, pkgs, ... }: {
    githubActions = {
      enable = true;
      workflows.ci = {
        name = "CI";
        on = {
          push.branches = [ "main" ];
          workflowDispatch = { };
        };
        concurrency = {
          group = "check";
          cancelInProgress = true;
        };
        jobs =
          let
            stepsCommonLix = [
              {
                name = "Checkout";
                uses = "actions/checkout@v4";
              }
              {
                name = "Install Lix";
                uses = "samueldr/lix-gha-installer-action@v2026-06-15";
                with_.extra_nix_config = ''
                  accept-flake-config = true
                  access-tokens = github.com=''${{ secrets.GH_TOKEN }}
                '';
              }
              {
                name = "Setup Cachix";
                uses = "cachix/cachix-action@v17";
                with_ = {
                  name = "lialh4";
                  authToken = "\${{ secrets.CACHIX_TOKEN }}";
                };
              }
            ];
          in
          {
            check = {
              runsOn = "ubuntu-latest";
              steps = stepsCommonLix ++ [
                {
                  name = "Run checks";
                  run = "nix flake check --repair --all-systems";
                }
              ];
            };
            build-doc = {
              runsOn = "ubuntu-latest";
              needs = [ "check" ];
              steps = stepsCommonLix ++ [
                {
                  name = "Build doc package";
                  run = "nix build .#doc";
                }
                {
                  name = "Setup pages";
                  uses = "actions/configure-pages@v5";
                }
                {
                  name = "Upload artifact";
                  uses = "actions/upload-pages-artifact@v3";
                  with_.path = "./result";
                }
              ];
            };
            deploy-doc = {
              runsOn = "ubuntu-latest";
              needs = [ "build-doc" ];
              permissions = {
                id-token = "write";
                pages = "write";
              };
              environment = {
                name = "github-pages";
                url = "\${{ steps.deployment.outputs.page_url }}";
              };
              steps = [
                {
                  id = "deployment";
                  name = "Deploy to GitHub Pages";
                  uses = "actions/deploy-pages@v5";
                }
              ];
            };
          };
      };
    };

    packages.ci-yml = config.githubActions.workflowFiles."ci.yml";

    apps.update-ci-yml = {
      type = "app";
      program =
        pkgs.writers.writeFishBin "update-ci-yml" (
          let
            lixShArg = pkgs.lix |> lib.getExe |> lib.escapeShellArg;
            catShArg = "cat" |> lib.getExe' pkgs.uutils-coreutils-noprefix |> lib.escapeShellArg;
          in
          ''
            set -l yml (${lixShArg} build .#ci-yml --no-link --print-out-paths)
            ${catShArg} "$yml" > .github/workflows/ci.yml
          ''
        )
        |> lib.getExe;
    };
  };
}
