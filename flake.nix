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

      lua = pkgs: mkToolSuite {
        lang = pkgs.lua;
        lsps = [ pkgs.lua-language-server ];
        linters = [ pkgs.selene ];
        formatters = [ pkgs.stylua ];
      };

      ocaml = pkgs: mkToolSuite {
        lang = pkgs.ocaml;
        lsps = [ pkgs.ocamlPackages.ocaml-lsp ];
        formatters = [ pkgs.ocamlPackages.ocamlformat pkgs.ocamlPackages.ocp-indent ];
        other = [ pkgs.opam pkgs.ocamlPackages.utop ];
      };
    };
  };
}
# {
#   description = "A collection of development environments";
#
#   outputs = _:
#     {
#       lib = {
#         # ada als
#         # agda
#         # aiken
#         # angularls
#         # ansibells
#         # antlersls
#         # assembly
#         # astro
#         # awk = pkgs: builtins.attrValues { };
#         bash = pkgs: builtins.attrValues {
#           inherit (pkgs) shellcheck shfmt;
#           inherit (pkgs.nodePackages) bash-language-server;
#         };
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
#         lua = pkgs: builtins.attrValues {
#           inherit (pkgs) lua-language-server selene stylua;
#         };
#         latex = pkgs: builtins.attrValues {
#           inherit (pkgs) latexindent chktex texlab;
#         };
#         # kotlin
#         nickel = pkgs: builtins.attrValues {
#           inherit (pkgs) nickel nls;
#         };
#         nix = pkgs: builtins.attrValues {
#           inherit (pkgs)
#             nixd
#             deadnix
#             statix
#             nixfmt-rfc-style
#             # nixdoc
#             ;
#         };
#         # nvim
#         ocaml = pkgs: builtins.attrValues {
#           inherit (pkgs) ocaml opam;
#           inherit (pkgs.ocamlPackages) ocaml-lsp ocamlformat ocp-indent utop;
#         };
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
#         # vhdl
#         xml = pkgs: builtins.attrValues {
#           inherit (pkgs) xmlformat lemminx libxml2;
#         };
#         yaml = pkgs: builtins.attrValues {
#           inherit (pkgs) yamlfmt yamllint yaml-language-server; #yamlfix
#         };
#         zig = pkgs: builtins.attrValues {
#           inherit (pkgs) zls;
#         };
#         # zsh = pkgs: builtins.attrValues {
#         #   inherit (pkgs) 
#         # };
#       };
#     };
# }
