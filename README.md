# dev-environments

A simple library that consolidates packages into flake
outputs for use in devShells.

## Usage

Configure language server, formatter, and linter setups
in your text editor's configuration, and make the relevant
language servers, formatters and linters available within
a devshell with a nix flake. In the example below lspconfig,
nvim-lint, and conform are used to do this.

```lua
require("lspconfig").lua_ls.setup({})
require("lspconfig").nixd.setup({})


require("lint").linters_by_ft = {
 lua = { "luacheck" },
 nix = { "deadnix", "statix" },
}

vim.api.nvim_create_autocmd({ "BufWritePost" }, {
 callback = function()
  require("lint").try_lint()
 end,
})

require("conform").setup({
 formatters_by_ft = {
  lua = { "stylua" },
  nix = { "nixfmt" },
 },
})
```

```nix
{
  description = "dev-enviornments example usage";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    dev-environments = {
      url = "github:nebunebu/dev-environments";
    };
  };

  outputs = inputs:
    let
      supportedSystems = [
        "x86_64-linux"
        "aarch64-linux"
        "x86_64-darwin"
        "aarch64-darwin"
      ];
      forAllSystems = inputs.nixpkgs.lib.genAttrs supportedSystems;
    in
    {
      devShells = forAllSystems (
        system:
        let
          pkgs = inputs.nixpkgs.legacyPackages.${system};
        in
        {
          default = pkgs.mkShell {
            name = "exampleShell";
            packages = [
              (inputs.dev-environments.lib.lua pkgs)
              (inputs.dev-environments.lib.nix pkgs)
            ];
          };
        }
      );
    };
}
```
