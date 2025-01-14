{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    darwin.url = "github:lnl7/nix-darwin";
    darwin.inputs.nixpkgs.follows = "nixpkgs";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
  };

  outputs = inputs@{ nixpkgs, home-manager, darwin, ... }: {
    darwinConfigurations =
      {
        "demos-iMac-Pro" = darwin.lib.darwinSystem {
          system = "x86_64-darwin";
          modules = [
            {
              # all nix-darwin options: https://daiderd.com/nix-darwin/manual/index.html
              system.stateVersion = 5; # a rite, don't think about it
              nixpkgs.config.allowUnfree = true;
            }

            home-manager.darwinModules.home-manager
            {
              # all Home Manager options: https://home-manager-options.extranix.com/
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              # TODO: show how we can use import instead during the demo
              home-manager.users.demo = { pkgs, lib, ... }: {
                home.stateVersion = "25.05"; # a rite, don't think about it
                home.homeDirectory = lib.mkForce "/Users/demo";

                programs.zsh = {
                  enable = true;
                };

                programs.direnv = {
                  enable = true;
                  config = {
                    # This is unsafe for real workstations. Use subdirectories.
                    # Slash at the end is important
                    whitelist.prefix = [ "~/" ];
                  };
                };

                # nixpkgs packages: https://search.nixos.org/packages?
                home.packages = with pkgs; [
                  ammonite
                ];

                programs.vscode = {
                  enable = true; # TODO: explain the Spotlight issues
                  extensions = with pkgs.vscode-extensions; [
                    jnoortheen.nix-ide
                    mkhl.direnv
                  ];
                  userSettings = {
                    "workbench.startupEditor" = "newUntitledFile";
                    "window.openFoldersInNewWindow" = "on";
                    "telemetry.enableTelemetry" = false;
                    "telemetry.enableCrashReporter" = false;
                  };
                };

              };
            }
          ];
        };
      };
  };
}
