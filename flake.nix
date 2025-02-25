{
  description = "shellhazard's Nix outputs";

  outputs = {
    nixosModules.breezewiki = import ./modules/breezewiki;
    nixosModules.neko-rooms = import ./modules/neko-rooms;
  };
}
