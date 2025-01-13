{
  inputs.flake-utils.url = "github:numtide/flake-utils";

  outputs =
    { self
    , nixpkgs
    , flake-utils
    }:
    flake-utils.lib.eachDefaultSystem (
      system:
      let
        pkgs = nixpkgs.legacyPackages.${system};
      in
      {
        packages = rec {
          my-package = pkgs.stdenv.mkDerivation {
            version = "1.0.0";
            name = "my-demo-package";
            src = ./.;

            nativeBuildInputs = with pkgs; [
              nodejs
            ];

            buildPhase = ''
              echo "#!${pkgs.nodejs}/bin/node" > ./my-package
              cat demo.js >> ./my-package
              chmod +x ./my-package
            '';

            installPhase = ''
              mkdir -p $out/bin
              cp my-package $out/bin/my-package
            '';
          };
          default = my-package;
        };
      }
    );
}
