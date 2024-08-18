{
  description = "A collection of development environments";

  outputs = _:
    {
      lib = {
        hello = pkgs: with pkgs; [ cowsay hello ];
        lua = pkgs: with pkgs; [ lua-language-server stylua luajitPackages.luacheck ];
        nix = pkgs: with pkgs; [ nixd deadnix statix nixfmt-rfc-style ];
      };
    };
}
