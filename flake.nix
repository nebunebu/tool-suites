{
  description = "A collection of development environments";

  outputs = _: {
    lib = rec {
      mkToolSuite = { lang ? null, lsps ? [ ], linters ? [ ], formatters ? [ ], other ? [ ] }:
        builtins.attrValues (
          builtins.foldl' (acc: list: acc // builtins.listToAttrs (map (pkg: { name = pkg.name; value = pkg; }) list))
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
        linters = [ pkgs.selene ];
        formatters = [ pkgs.stylua ];
      };

      latex = pkgs: mkToolSuite {
        lsps = [ pkgs.texlab ];
        linters = [ pkgs.chktex ];
        formatters = [ pkgs.latexindent ];
      };

      nix = pkgs: mkToolSuite {
        lsps = [ pkgs.nixd ];
        linters = [ pkgs.statix pkgs.deadnix ];
        formatters = [ pkgs.nixfmt-rfc-style ];
        # other = [ pkgs.nixdoc ];
      };

      ocaml = pkgs: mkToolSuite {
        lang = pkgs.ocaml;
        lsps = [ pkgs.ocamlPackages.ocaml-lsp ];
        formatters = [ pkgs.ocamlPackages.ocamlformat pkgs.ocamlPackages.ocp-indent ];
        other = [ pkgs.opam pkgs.ocamlPackages.utop ];
      };

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
  };
}
#         # ada als
#         # agda
#         # aiken
#         # angularls
#         # ansibells
#         # antlersls
#         # assembly
#         # astro
#         # awk = pkgs: builtins.attrValues { };
#         # c
#         # cpp
#         # clojure
#         crystal = pkgs: builtins.attrValues {
#           inherit (pkgs) crystalline icr ameba crystal;
#         };
#         # csharp
#         # d
#         # dart
#         # TODO: add lsp, formatter
#         css = pkgs: builtins.attrValues {
#           inherit (pkgs) stylelint;
#         };
#         # d
#         # docker
#         # elixir
#         elm = pkgs: builtins.attrValues {
#           inherit (pkgs.elmPackages) elm-format;
#         };
#         # emmet
#         # erlang
#         fennel = pkgs: builtins.attrValues {
#           inherit (pkgs) fennel-ls fnlfmt;
#           inherit (pkgs.luajitPackages) fennel;
#         };
#         # fish
#         # fsharp
#         # fortran
#         # gleam
#         # groovy
#         # graphql
#         # html
#         # haskell
#         # java
#         # javascript = pkgs: builtins.attrValues { };
#         # julia
#         json = pkgs: builtins.attrValues {
#           inherit (pkgs.nodePackages) jsonlint;
#         };
#         # kotlin
#         nickel = pkgs: builtins.attrValues {
#           inherit (pkgs) nickel nls;
#         };
#         # nvim
#         # objectivc
#         # powershell
#         # protobuf
#         # python
#         # r
#         # ruby
#         # rust
#         # scala
#         # shell
#         # sql
#         # swift
#         # terraform
#         # toml
#         # typescript
#         vala = pkgs: builtins.attrValues {
#           inherit (pkgs) uncrustify vala vala-lint vala-language-server xmlbird;
#         };
#         zig = pkgs: builtins.attrValues {
#           inherit (pkgs) zls;
#         # zsh = pkgs: builtins.attrValues {
