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
  description = "tool-suites example usage";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    dev-environments = {
      url = "github:nebunebu/tool-suites";
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
              (inputs.tool-suites.lib.${system}.nix pkgs).use
              (inputs.tool-suites.lib.${system}.lua pkgs).use
            ];
          };
        }
      );
    };
}
```

## Customization

The `flake.nix` defines a function `mkToolSuite` which accepts an attribute set
with the attributes `langs`, `langServers`, `linters`, `formatters`, and
`other`, all of which have a list value. There is no functional difference
between adding packages to any of these attribute-values, and they are only
for the sake of organization.

These values can be overrode to modify the packages present in any given
tool-suite. For instance,

```nix
packages = [
(inputs.tool-suites.lib.${system}.nix pkgs).override {
  langServers = [ pkgs.nil ];
  }).use
];
```

will override the default `nixd` language server in the nix tool-suite with the
`nil` language server.

> [!Caution]
> An attribute overriden with the method above will be replaced by the override.

You can extend what values an attribute contains as follows:

```nix
((inputs.tool-suites.lib.${system}.nix pkgs).override {
  linters = (inputs.tool-suites.lib.${system}.nix pkgs).linters
    ++ [ pkgs.nix-lint ];
}).use
```

The above adds the `nix-lint` package to the defaults linters in the nix
tool-suite, which are `statix` and `deadnix`.

## Contributing

Feel free to contribute.

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
