{
  description = "Rust to Haskell FFI demo project";
  inputs.haskellNix.url = "github:input-output-hk/haskell.nix";
  inputs.nixpkgs.follows = "haskellNix/nixpkgs-unstable";
  inputs.flake-utils.url = "github:numtide/flake-utils";
  inputs.greetings.url = "github:yvan-sraka/greetings";
  outputs = { self, nixpkgs, flake-utils, haskellNix, greetings }:
    flake-utils.lib.eachSystem [
      # List of supported target systems:
      "x86_64-linux"
      "aarch64-darwin"
      "x86_64-w64-mingw32"
    ] (system:
    let overlays = [ haskellNix.overlay
        (final: prev: {
          # Add `extra-libraries` dependencies
          greetings = greetings.packages.${system}.${final.stdenv.hostPlatform.config};
          # This overlay adds our project to pkgs
          demoProject =
            final.haskell-nix.project' {
              src = ./.;
              compiler-nix-name = "ghc8107";
              # `cabal`, `hlint` and `haskell-language-server`
              shell.tools = {
                cabal = "latest";
                hlint = "latest";
                haskell-language-server = "latest";
              };
              # Non-Haskell shell tools go here
              shell.buildInputs = with pkgs; [ ];
            };
        })
      ];
      pkgs = (import nixpkgs {
        inherit system overlays; inherit (haskellNix) config;
      }).pkgsCross.mingwW64; # <-- set cross-compilation target!
      flake = pkgs.demoProject.flake {};
    in flake // {
      # Built by `nix build .`
      defaultPackage = flake.packages."haskell-demo:exe:haskell-demo";
    });
}
