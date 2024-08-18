{
  description = "A collection of development environments";

  outputs = _:
    {
      lib = {
        css = pkgs: with pkgs; [ prettierd ];
        hello = pkgs: with pkgs; [ cowsay hello ];
        js = pkgs: with pkgs; [ prettierd ];
        lua = pkgs: with pkgs; [ lua-language-server stylua luajitPackages.luacheck ];
        md = pkgs: with pkgs; [ markdownlint ];
        nix = pkgs: with pkgs; [ nixd deadnix statix nixfmt-rfc-style ];
        scss = pkgs: with pkgs; [ prettierd ];
        tex = pkgs: with pkgs; [ latexindent chktex ];
        ts = pkgs: with pkgs; [ prettierd ];
      };
    };
}
