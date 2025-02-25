{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
  };

  outputs =
    { self, nixpkgs }:
    let
      pkgs = import nixpkgs { system = "x86_64-linux"; };
    in
    {
      nixosModules.breezewiki = import ./modules/breezewiki;
      nixosModules.neko-rooms = import ./modules/neko-rooms;
    };
}
