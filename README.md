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
-- configure lua and nix lang servers
require("lspconfig").lua_ls.setup({})
require("lspconfig").nixd.setup({})

-- configure lua and nix linters
require("lint").linters_by_ft = {
 lua = { "selene" },
 nix = { "deadnix", "statix" },
}

-- configure lua and nix formatters
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

## TODO

Create relevant functions for the following and example configurations
in `lua/lspconfig.lua`, `lua/nvim-lint.lua`, and `lua/conform.nvim`:

```txt
    - [ ] ada
    - [ ] agda
    - [ ] aiken
    - [ ] angularls
    - [ ] ansibells
    - [ ] antlersls
    - [ ] assembly
    - [ ] astro
    - [ ] awk 
    - [x] bash 
    - [ ] c
    - [ ] cpp
    - [ ] clojure
    - [ ] crystal 
    - [ ] csharp
    - [ ] d
    - [ ] dart
    - [ ] css 
    - [ ] d
    - [ ] docker
    - [ ] elixir
    - [ ] elm 
    - [ ] emmet
    - [ ] erlang
    - [ ] fennel 
    - [ ] fish
    - [ ] fsharp
    - [ ] fortran
    - [ ] gleam
    - [ ] groovy
    - [ ] graphql
    - [ ] html
    - [ ] haskell
    - [ ] java
    - [ ] javascript 
    - [ ] julia
    - [ ] json 
    - [x] lua 
    - [x] latex 
    - [ ] kotlin
    - [ ] nickel 
    - [ ] markdown
    - [x] nix 
    - [ ] nvim
    - [ ] ocaml 
    - [ ] objectivc
    - [ ] powershell
    - [ ] protobuf
    - [ ] python
    - [ ] r
    - [ ] ruby
    - [ ] rust
    - [ ] scala
    - [ ] shell
    - [ ] sql
    - [ ] swift
    - [ ] terraform
    - [ ] toml
    - [ ] typescript
    - [ ] vala 
    - [ ] vhdl
    - [x] xml 
    - [x] yaml 
    - [ ] zig 
    - [ ] zsh 
```
