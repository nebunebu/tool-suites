# tool-suites

A simple library that consolidates packages into flake
outputs.

## Why?

Nix users can create development environments with the [pkgs.mkShell](https://ryantm.github.io/nixpkgs/builders/special/mkshell/)
function. Often there are collections of packages routinely added to such a
developer environment. For instance a target language and linters, formatters,
and language servers for that target language. This repository aims to collect
such packages together into flake outputs for convenience.

## Usage

> [!Note]
> This flake is merely for the installation of tools such as linters,
> formatters, and language servers. It is agnostic as to what text editor you
> use and by what means you configure these tools for your editor

```nix
{
  description = "tool-suites example";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    tool-suites.url = "path:nebunebu/tool-suites";
  };

  outputs = inputs: {
    devShells = builtins.mapAttrs
      (
        system: _:
          let
            pkgs = import inputs.nixpkgs {
              inherit system;
              overlays = [
                inputs.tool-suites.overlays.default
              ];
            };
          in
          {
            default = pkgs.mkShell {
              name = "testShell";
              packages = [
                pkgs.tool-suite.bash
                pkgs.tool-suite.html
                pkgs.tool-suite.lua
                pkgs.tool-suite.latex
                pkgs.tool-suite.nix
                pkgs.tool-suite.yaml
              ];
            };
          }
      )
      inputs.nixpkgs.legacyPackages;
  };
}
```

## Customization

<!-- FIX: elaborate for clarity -->

```nix
devShells = builtins.mapAttrs
  (
    system: _:
      let
        pkgs = import inputs.nixpkgs {
          inherit system;
          overlays = [
            inputs.tool-suites.overlays.default

            # Overriding bash for all of pkgs
            (final: prev: { bash = prev.bash.overrideAttrs {name = "my-bash";};})
          ];
        };
      in
      {
        default = pkgs.mkShell {
          name = "testShell";
          packages = [
            # Overriding bash for only this recipe
            (inputs.tool-suite.recipe.bash { pkgs = pkgs.extend (final: prev:
              { bash = prev.bash.overrideAttrs {name = "my-bash";};}
            );})

            # Overriding bash (but only the package, not its use as a dependency)
            (inputs.tool-suite.recipe.bash { 
              pkgs = pkgs // { bash = prev.bash.overrideAttrs {name = "my-bash";};};
            })

            # If recipes has a "bash" formal arg:
            (inputs.tool-suite.recipe.bash
              { bash = prev.bash.overrideAttrs {name = "my-bash";};}
            )
          ];
        };
      }
  )
  inputs.nixpkgs.legacyPackages;
```

## Contributing

Feel free to contribute.

## Tool Suites

| suite  |             |            |
| ------ | ----------- | ---------- |
| *bash* |             |            |
|        | langs       | bash       |
|        | langServers | bashls     |
|        | linters     | shellcheck |
|        | formatters  | shfmt      |
| *json* |             |            |
|        | langServers | jsonls     |
|        | linters     | jsonlint   |
|        | formatters  | fixjson    |

<!-- | html        |                | -->
<!-- | ----------- | -------------- | -->
<!-- | langServers | htmlls         | -->
<!-- | linters     | htmlhint       | -->
<!-- | formatters  | htmlbeautifier | -->
<!---->
<!-- | lua         |          | -->
<!-- | ----------- | -------- | -->
<!-- | langs       | lua      | -->
<!-- | langServers | lua-ls   | -->
<!-- | linters     | luacheck | -->
<!-- | formatters  | stylua   | -->
<!---->
<!-- | nix         |                  | -->
<!-- | ----------- | ---------------- | -->
<!-- | langServers | nixd             | -->
<!-- | linters     | statix, deadnix  | -->
<!-- | formatters  | nixfmt-rfc-style | -->
<!---->
<!-- | tex         |             | -->
<!-- | ----------- | ----------- | -->
<!-- | langServers | texlab      | -->
<!-- | linters     | chktex      | -->
<!-- | formatters  | latexindent | -->
<!---->
<!-- | xml         |           | -->
<!-- | ----------- | --------- | -->
<!-- | langServers | lemminx   | -->
<!-- | linters     | xmllint   | -->
<!-- | formatters  | xmlformat | -->
<!---->
<!-- | yaml        |          | -->
<!-- | ----------- | -------- | -->
<!-- | langServers | yamlls   | -->
<!-- | linters     | yamllint | -->
<!-- | formatters  | yamlfmt  | -->

## TODO

### Make tool-suites

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
    - [x] html
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
