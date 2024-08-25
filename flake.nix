{
  description = "Tool suites for development environments";

  outputs = inputs: {
    recipes = {
      bash =
        { pkgs }:
        pkgs.lib.mkToolSuite {
          langs = [ pkgs.bash ];
          langServers = [ pkgs.nodePackages.bash-language-server ];
          linters = [ pkgs.shellcheck ];
          formatters = [ pkgs.shfmt ];
        };

      json =
        { pkgs }:
        pkgs.lib.mkToolSuite {
          langServers = [
            (pkgs.vscode-langservers-extracted.overrideAttrs (_: {
              buildPhase =
                let
                  extensions =
                    if pkgs.stdenv.isDarwin then
                      "../VSCodium.app/Contents/Resources/app/extensions"
                    else
                      "../resources/app/extensions";
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

      html =
        { pkgs }:
        pkgs.lib.mkToolSuite {
          langServers = [
            (pkgs.vscode-langservers-extracted.overrideAttrs (_: {
              buildPhase =
                let
                  extensions =
                    if pkgs.stdenv.isDarwin then
                      "../VSCodium.app/Contents/Resources/app/extensions"
                    else
                      "../resources/app/extensions";
                in
                ''
                  npx babel ${extensions}/json-language-features/server/dist/node \
                    --out-dir lib/html-language-server/node/
                '';
              installPhase = ''
                mkdir -p $out/bin $out/lib
                cp -r lib/html-language-server $out/lib/
                cat > $out/bin/vscode-html-language-server <<EOF
                #!/bin/sh
                exec ${pkgs.nodejs}/bin/node $out/lib/html-language-server/node/jsonServerMain.js "\$@"
                EOF
                chmod +x $out/bin/vscode-html-language-server
              '';
            }))
          ];
          linters = [ pkgs.htmlhint ];
          formatters = [ pkgs.rubyPackages.htmlbeautifier ];
        };

      lua =
        { pkgs }:
        pkgs.lib.mkToolSuite {
          langs = [ pkgs.lua ];
          langServers = [ pkgs.lua-language-server ];
          linters = [ pkgs.luajitPackages.luacheck ];
          formatters = [ pkgs.stylua ];
        };

      md =
        { pkgs }:
        pkgs.lib.mkToolSuite {
          langServers = [ pkgs.markdown-oxide ];
          linters = [ pkgs.markdownlint-cli ];
          formatters = [ pkgs.markdownlint-cli ];
        };

      nix =
        { pkgs }:
        pkgs.lib.mkToolSuite {
          langServers = [ pkgs.nixd ];
          linters = [
            pkgs.statix
            pkgs.deadnix
          ];
          formatters = [ pkgs.nixfmt-rfc-style ];
          # other = [ pkgs.nixdoc ];
        };

      nvim-tools =
        { pkgs }:
        pkgs.lib.mkToolSuite {
          other = [
            pkgs.curl
            pkgs.direnv
            pkgs.imagemagic
            pkgs.luajitPackages.magick
            pkgs.ripgrep
          ];
        };

      tex =
        { pkgs }:
        pkgs.lib.mkToolSuite {
          langServers = [ pkgs.texlab ];
          linters = [ pkgs.texlivePackages.chktex ];
          formatters = [ pkgs.texlivePackages.latexindent ];
        };

      # ocaml = pkgs: mkToolSuite {
      #   langs = pkgs.ocaml;
      #   langServers = [ pkgs.ocamlPackages.ocaml-lsp ];
      #   formatters = [ pkgs.ocamlPackages.ocamlformat pkgs.ocamlPackages.ocp-indent ];
      #   other = [ pkgs.opam pkgs.ocamlPackages.utop ];
      # };

      xml =
        { pkgs }:
        pkgs.lib.mkToolSuite {
          langServers = [ pkgs.lemminx ];
          linters = [ pkgs.libxml2 ]; # provides xmllint
          formatters = [ pkgs.xmlformat ];
        };

      yaml =
        { pkgs }:
        pkgs.lib.mkToolSuite {
          langServers = [ pkgs.yaml-language-server ];
          linters = [ pkgs.yamllint ];
          formatters = [ pkgs.yamlfmt ];
        };
    };

    overlays.default = final: prev: {
      lib = prev.lib // {
        mkToolSuite = (
          { langs ? [ ]
          , langServers ? [ ]
          , linters ? [ ]
          , formatters ? [ ]
          , other ? [ ]
          ,
          }:
          builtins.concatLists [
            langs
            langServers
            linters
            formatters
            other
          ]
        );
      };
      tool-suite = builtins.mapAttrs (name: recipe: final.callPackage recipe { }) inputs.self.recipes;
    };
  };
}
