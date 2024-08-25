{
  description = "tool-suites test";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    tool-suites.url = "path:./..";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs: {
    checks = builtins.mapAttrs (system: pkgs: {
      pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
        src = ./.;
        hooks = {
          # nix
          # nixd.enable = true;
          statix.enable = true;
          nixfmt.enable = false;
          deadnix = {
            enable = true;
            settings.noLambdaPatternNames = true;
          };
          # lua
          lua-ls.enable = false; # NOTE: error even though passing
          luacheck.enable = true;
          stylua.enable = true;
        };
      };
    }) inputs.nixpkgs.legacyPackages;

    devShells = builtins.mapAttrs (
      system: _:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.tool-suites.overlays.default

            # Overriding bash for all of pkgs
            # (final: prev: { bash = prev.bash.overrideAttrs {name = "my-bash";};})
          ];
        };
      in
      {
        default = pkgs.mkShell {
          name = "testShell";
          packages = [
            # Overriding bash for only this recipe
            # (inputs.tool-suite.recipe.bash { pkgs = pkgs.extend (final: prev: { bash = prev.bash.overrideAttrs {name = "my-bash";};});})

            # Overriding bash (but only the package, not its use as a dependency for shellcheck)
            # (inputs.tool-suite.recipe.bash { pkgs = pkgs // { bash = prev.bash.overrideAttrs {name = "my-bash";};};})

            # If recipes has a "bash" formal arg:
            # (inputs.tool-suite.recipe.bash { bash = prev.bash.overrideAttrs {name = "my-bash";};})

            pkgs.tool-suite.bash
            pkgs.tool-suite.html
            pkgs.tool-suite.lua
            pkgs.tool-suite.latex
            pkgs.tool-suite.nix
            pkgs.tool-suite.yaml
          ];
        };
      }
    ) inputs.nixpkgs.legacyPackages;
  };
}
