{
  description = "A collection of development environments";


  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
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
      packages = forAllSystems
        (system:
          let
            pkgs = inputs.nixpkgs.legacyPackages.${system};
          in
          {
            luaBundle = pkgs: [
              pkgs.lua-language-server
              pkgs.stylua
              pkgs.luajitPackages.luacheck
            ];

            jsBundle = pkgs: [
              pkgs.prettierd
              pkgs.stylelint
            ];
          }
        );
    };
}
