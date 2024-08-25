{
  description = "test";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    tool-suites.url = "github:nebunebu/tool-suites";
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
            name = "testShell";
            packages = [
              (inputs.tool-suites.lib.${system}.bash pkgs).use
              (inputs.tool-suites.lib.${system}.json pkgs).use
              (inputs.tool-suites.lib.${system}.lua pkgs).use
              (inputs.tool-suites.lib.${system}.latex pkgs).use
              (inputs.tool-suites.lib.${system}.nix pkgs).use
              (inputs.tool-suites.lib.${system}.xml pkgs).use
              (inputs.tool-suites.lib.${system}.yaml pkgs).use
            ];
          };
        }
      );
    };
}
