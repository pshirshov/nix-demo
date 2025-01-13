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
              system.stateVersion = 5;
            }
            home-manager.darwinModules.home-manager
            {
              home-manager.useGlobalPkgs = true;
              home-manager.useUserPackages = true;

              # TODO: show how we can use import instead during the demo
              home-manager.users.demo = { pkgs, lib, ... }: {
                home.stateVersion = "25.05";
                home.homeDirectory = lib.mkForce "/Users/demo";

                programs.zsh = {
                  enable = true;
                };
                programs.direnv = {
                  enable = true;
                  config = {
                    whitelist.prefix = [ "~/" ]; # this is unsafe for real workstations
                  };
                };

                home.packages = with pkgs; [
                  ammonite
                ];
              };
            }
          ];
        };
      };
  };
}
