_: {
  perSystem = { config, pkgs, ... }: {
    githubActions = {
      enable = true;
      workflows.check = {
        name = "Check";
        on = {
          push.branches = [ "main" ];
          workflowDispatch = { };
        };
        concurrency = {
          group = "check";
          cancelInProgress = true;
        };
        jobs.check = {
          runsOn = "ubuntu-latest";
          steps = [
            {
              name = "Checkout";
              uses = "actions/checkout@v4";
            }
            {
              name = "Install Lix";
              uses = "samueldr/lix-gha-installer-action@v2026-06-15";
              with_.extra_nix_config = ''
                accept-flake-config = true
              '';
            }
            {
              name = "Run checks";
              run = "nix flake check";
            }
          ];
        };
      };
    };

    packages.gh-workflows = pkgs.runCommand "gh-workflows" { } ''
      mkdir -p $out/.github/workflows
      cp -r ${config.githubActions.workflowsDir}/* $out/.github/workflows/
    '';
  };
}
