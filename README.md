# shellhazard's Nix flake

Various components that I've hacked together that are certainly useful, but unsuitable for upstream.

## Usage

Example Flake:
```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    shellhazard-nix.url = "git+ssh://git@github.com/shellhazard/nix.git?ref=main";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      shellhazard-nix,
    }:
    {
      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ./configuration.nix
            shellhazard-nix.nixosModules.breezewiki
            shellhazard-nix.nixosModules.neko-rooms
          ];
        };
      };
    };
}
```

### Breezewiki

Packaged from the binary distribution [provided here](https://docs.breezewiki.com/Running.html#%28part._.Running_a_compiled_executable%29), mirrored to archive.org. All options are configurable from the service definition. For a full list, [see the docs](https://docs.breezewiki.com/Configuration.html). Packaging from source didn't seem worth it at this stage considering the source repository is offline most of the time.

```nix
{ ... }:
{
  services.breezewiki = {
    enable = true;
    config = {
      bind_host = "127.0.0.1";
      canonical_origin = "https://bw.example.com";
    };
  };
}
```
### neko-rooms

Packaged from a minimal docker-compose using compose2nix. For the full list of options, see [the module definition](https://github.com/shellhazard/nix/blob/main/modules/neko-rooms/default.nix). Note that at this stage the module assumes the use of Docker, not Podman.

```nix
{ ... }:
{
  services.nekorooms = {
    enable = true;
    port = 4001;
    instanceURL = "https://party.example.com";

    # can specify public IP here or allow it to be automatically resolved
    nat1to1 = "127.0.0.1"; 
  };
}
```

## Testing package builds

```sh
nix-build -E "with import <nixpkgs> {}; callPackage ./breezewiki.nix {}"
```


