# tool-suites

A simple library that consolidates packages into flake
outputs for use in devShells.

## Why?

Nix users can create development environments with the [pkgs.mkShell](https://ryantm.github.io/nixpkgs/builders/special/mkshell/)
function. Given this, when using a text-editor like neovim you can declare your
language-specific linters, formatters, and language servers within a devShell.

This flake collects packages by language for use in these devShells.

## Usage

> [!Note] This flake is merely for the installation of tools such as linters,
> formatters, and language servers. It is agnostic as to what text editor you
> use and by what means you manage and configure these language servers,
> linters, and formatters

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
              # Use the nix tool-suite as it is defined
              (inputs.dev-environments.lib.${system}.nix pkgs).use


              # Override the lsp attribute of the nix tool-suite to use
              # nil instead of nixd

              ((inputs.dev-environments.lib.${system}.nix pkgs).override
                {
                  lsps = [ pkgs.nil ];
                }).use

              # Override the linters attribute to also include nix-lint
              ((inputs.dev-environments.lib.${system}.nix pkgs).override
                {
                  linters = [ pkgs.cowsay ];
                  formatters = (inputs.dev-environments.lib.${system}.nix pkgs).formatters 
                    ++ [ pkgs.nix-lint ];
                }).use
            ];
          };
        }
      );
    };
}
```

## TODO

Create relevant function calls for the following and example configurations
in `examples/lspconfig.lua`, `examples/nvim-lint.lua`, and `examples/conform.nvim`:

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
