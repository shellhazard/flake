{
  description = "shellhazard's Nix outputs";

  outputs =
    { ... }:
    {
      nixosModules.breezewiki = import ./modules/bin/breezewiki;
      nixosModules.neko-rooms = import ./modules/docker/neko-rooms;
    };
}
