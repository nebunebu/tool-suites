{
  description = "A collection of development environments";

  outputs = _:
    {
      lib = {
        # css = pkgs: with pkgs; [ prettierd ];
        # js = pkgs: with pkgs; [ prettierd ];
        lua = pkgs: builtins.attrValues {
          inherit (pkgs) lua lua-language-server stylua;
          inherit (pkgs.luajitPackages) luacheck;
        };

        # md = pkgs: with pkgs; [ markdownlint ];
        ocaml = pkgs: builtins.attrValues {
          inherit (pkgs) ocaml opam;
          inherit (pkgs.ocamlPackages) ocaml-lsp ocamlformat ocp-indent utop;
        };
        nix = pkgs: builtins.attrValues {
          inherit (pkgs)
            nixd
            deadnix
            statix
            nixfmt-rfc-style
            # nixdoc
            ;
        };

        # scss = pkgs: with pkgs; [ prettierd ];
        latex = pkgs: builtins.attrValues {
          inherit (pkgs) latexindent chktex texlab;
        };
        # ts = pkgs: with pkgs; [ prettierd ];
      };
    };
}
