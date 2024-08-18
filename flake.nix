{
  description = "A collection of development environments";

  outputs = _:
    {
      lib = {
        # assembly
        # c
        # cpp
        # clojure
        crystal = pkgs: builtins.attrValues {
          inherit (pkgs) crystalline icr ameba crystal;
        };
        # csharp
        # d
        # dart
        # TODO: add lsp, formatter
        css = pkgs: builtins.attrValues {
          inherit (pkgs) stylelint;
        };
        # d
        # docker
        # elixir
        elm = pkgs: builtins.attrValues {
          inherit (pkgs.elmPackages) elm-format;
        };
        # emmet
        # erlang
        # fish
        # fsharp
        # fortran
        # gleam
        # groovy
        # graphql
        # html
        # haskell
        # java
        # javascript = pkgs: builtins.attrValues { };
        # julia
        # json
        lua = pkgs: builtins.attrValues {
          inherit (pkgs) lua lua-language-server stylua;
          inherit (pkgs.luajitPackages) luacheck;
        };
        latex = pkgs: builtins.attrValues {
          inherit (pkgs) latexindent chktex texlab;
        };
        # kotlin
        # nickel
        nix = pkgs: builtins.attrValues {
          inherit (pkgs)
            nixd
            deadnix
            statix
            nixfmt-rfc-style
            # nixdoc
            ;
        };
        ocaml = pkgs: builtins.attrValues {
          inherit (pkgs) ocaml opam;
          inherit (pkgs.ocamlPackages) ocaml-lsp ocamlformat ocp-indent utop;
        };
        # objectivc
        # powershell
        # protobuf
        # python
        # r
        # ruby
        # rust
        # scala
        # shell
        # sql
        # swift
        # terraform
        # toml
        # typescript
        # xml
        # yaml
        # zig
      };
    };
}
