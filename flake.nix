{
  description = "A collection of development environments";
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixpkgs-unstable";
    pre-commit-hooks = {
      url = "github:cachix/pre-commit-hooks.nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

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
      lib = forAllSystems
        (
          system:
          let
            pkgs = inputs.nixpkgs.legacyPackages.${system};
          in
          rec {
            mkToolSuite = pkgs.lib.makeOverridable
              (
                { langs ? [ ]
                , langServers ? [ ]
                , linters ? [ ]
                , formatters ? [ ]
                , other ? [ ]
                }:
                {
                  inherit langs langServers linters formatters other;
                  use = builtins.concatLists [
                    langs
                    langServers
                    linters
                    formatters
                    other
                  ];
                }
              );

            bash = pkgs: mkToolSuite {
              langs = [ pkgs.bash ];
              langServers = [ pkgs.nodePackages.bash-language-server ];
              linters = [ pkgs.shellcheck ];
              formatters = [ pkgs.shfmt ];
            };

            json = pkgs: mkToolSuite {
              # langServers = [ pkgs.vscode-langservers-extracted ]; # FIX: should use only jsonls
              langServers = [
                (pkgs.vscode-langservers-extracted.overrideAttrs (_: {
                  buildPhase =
                    let
                      extensions =
                        if pkgs.stdenv.isDarwin
                        then "../VSCodium.app/Contents/Resources/app/extensions"
                        else "../resources/app/extensions";
                    in
                    ''
                      npx babel ${extensions}/json-language-features/server/dist/node \
                        --out-dir lib/json-language-server/node/
                    '';
                  installPhase = ''
                    mkdir -p $out/bin $out/lib
                    cp -r lib/json-language-server $out/lib/
                    cat > $out/bin/vscode-json-language-server <<EOF
                    #!/bin/sh
                    exec ${pkgs.nodejs}/bin/node $out/lib/json-language-server/node/jsonServerMain.js "\$@"
                    EOF
                    chmod +x $out/bin/vscode-json-language-server
                  '';
                }))
              ];
              linters = [ pkgs.nodePackages.jsonlint ];
              formatters = [ pkgs.fixjson ];
            };

            lua = pkgs: mkToolSuite {
              langs = [ pkgs.lua ];
              langServers = [ pkgs.lua-language-server ];
              linters = [ pkgs.luajitPackages.luacheck ];
              formatters = [ pkgs.stylua ];
            };

            latex = pkgs: mkToolSuite {
              langServers = [ pkgs.texlab ];
              linters = [ pkgs.texlivePackages.chktex ];
              formatters = [ pkgs.texlivePackages.latexindent ];
            };

            nix = pkgs: mkToolSuite {
              langServers = [ pkgs.nixd ];
              linters = [ pkgs.statix pkgs.deadnix ];
              formatters = [ pkgs.nixfmt-rfc-style ];
              # other = [ pkgs.nixdoc ];
            };

            # ocaml = pkgs: mkToolSuite {
            #   langs = pkgs.ocaml;
            #   langServers = [ pkgs.ocamlPackages.ocaml-lsp ];
            #   formatters = [ pkgs.ocamlPackages.ocamlformat pkgs.ocamlPackages.ocp-indent ];
            #   other = [ pkgs.opam pkgs.ocamlPackages.utop ];
            # };

            xml = pkgs: mkToolSuite {
              langServers = [ pkgs.lemminx ];
              linters = [ pkgs.libxml2 ]; # provides xmllint
              formatters = [ pkgs.xmlformat ];
            };

            yaml = pkgs: mkToolSuite {
              langServers = [ pkgs.yaml-language-server ];
              linters = [ pkgs.yamllint ];
              formatters = [ pkgs.yamlfmt ];
            };
          }
        );

      checks = forAllSystems (
        system:
        {
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
              (inputs.self.lib.${system}.nix pkgs).use
            ];
          };
        }
      );
    };
}
