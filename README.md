# shellhazard's Nix flake

Various components that I've hacked together that are certainly useful, but unsuitable for upstream.

## Usage

Example Flake:
```nix
{
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-unstable";
    sh-flake.url = "github:shellhazard/flake";
  };

  outputs =
    inputs@{
      self,
      nixpkgs,
      sh-flake,
    }:
    {
      nixosConfigurations = {
        default = nixpkgs.lib.nixosSystem {
          system = "x86_64-linux";

          modules = [
            ./configuration.nix
            sh-flake.nixosModules.breezewiki
            sh-flake.nixosModules.neko-rooms
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

Shouldn't be too much effort to avoid running the main service in Docker but since it depends on it being present anyway I've gone for the strategic approach of "getting it working".

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


