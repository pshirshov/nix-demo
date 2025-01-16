{
  inputs.nixpkgs.url = "github:NixOS/nixpkgs/24.05";

  inputs.nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixpkgs-unstable";

  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    { self
    , nixpkgs
    , nixpkgs-unstable
    , flake-utils
    ,
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
        pkgs-unstable = nixpkgs-unstable.legacyPackages.${system};
      in
      {
        devShells.default = pkgs.mkShell {
          nativeBuildInputs = with pkgs.buildPackages; [
            nodejs
            nodePackages.npm
            typescript
          ] ++ (with pkgs-unstable;[
            scala
          ]);

          shellHook = ''
            export DEMO_TYPESCRIPT=${pkgs.typescript}
            env|grep -e "^DEMO"
          '';
        };
      }
    );
}
