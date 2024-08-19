{
  description = "A collection of development environments";
  inputs.nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";

  outputs =
    inputs:
    let
      forAllSystems = inputs.nixpkgs.lib.genAttrs [
        "x86_64-linux"
        "x86_64-darwin"
        "aarch64-linux"
        "aarch64-darwin"
      ];
    in
    {
      lib = rec {
        mkToolSuite = { lang ? null, lsps ? [ ], linters ? [ ], formatters ? [ ], other ? [ ] }:
          builtins.attrValues (
            builtins.foldl'
              (
                acc: list:
                  acc //
                  builtins.listToAttrs (map (pkg: { inherit (pkg) name; value = pkg; }) list)
              )
              (if lang != null then { ${lang.name} = lang; } else { })
              [ lsps linters formatters other ]
          );

        bash = pkgs: mkToolSuite {
          lang = pkgs.bash;
          lsps = [ pkgs.nodePackages.bash-language-server ];
          linters = [ pkgs.shellcheck ];
          formatters = [ pkgs.shfmt ];
        };

        lua = pkgs: mkToolSuite {
          lang = pkgs.lua;
          lsps = [ pkgs.lua-language-server ];
          linters = [ pkgs.luajitPackages.luacheck ];
          formatters = [ pkgs.stylua ];
        };

        latex = pkgs: mkToolSuite {
          lsps = [ pkgs.texlab ];
          linters = [ pkgs.texlivePackages.chktex ];
          formatters = [ pkgs.texlivePackages.latexindent ];
        };

        nix = pkgs: mkToolSuite {
          lsps = [ pkgs.nixd ];
          linters = [ pkgs.statix pkgs.deadnix ];
          formatters = [ pkgs.nixfmt-rfc-style ];
          # other = [ pkgs.nixdoc ];
        };

        # ocaml = pkgs: mkToolSuite {
        #   lang = pkgs.ocaml;
        #   lsps = [ pkgs.ocamlPackages.ocaml-lsp ];
        #   formatters = [ pkgs.ocamlPackages.ocamlformat pkgs.ocamlPackages.ocp-indent ];
        #   other = [ pkgs.opam pkgs.ocamlPackages.utop ];
        # };

        xml = pkgs: mkToolSuite {
          lsps = [ pkgs.lemminx ];
          linters = [ pkgs.libxml2 ]; # provides xmllint
          formatters = [ pkgs.xmlformat ];
        };

        yaml = pkgs: mkToolSuite {
          lsps = [ pkgs.yaml-language-server ];
          linters = [ pkgs.yamllint ];
          formatters = [ pkgs.yamlfmt ];
        };
      };

      # FIX: not working
      checks = forAllSystems (
        system:
        {
          pre-commit-check = inputs.pre-commit-hooks.lib.${system}.run {
            src = ./.;
            hooks = {
              # nix
              nixd.enable = true;
              statix.enable = true;
              nixfmt.enable = false;
              deadnix = {
                enable = true;
                settings.noLambdaPatternNames = true;
              };
              # lua
              lua-ls.enable = true;
              luacheck.enable = true;
              stylua.enable = true;
            };
          };
        }
      );

      devShells = forAllSystems (
        system:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            name = "dev-environments";
            packages = [
              (inputs.self.lib.lua pkgs)
              (inputs.self.lib.nix pkgs)
              # (inputs.self.lib.git pkgs)
            ];
          };
        }
      );

    };
}
