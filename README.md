# shellhazard's Nix components

Assorted modules that I've hacked together while learning that work but are unsuitable for upstream.

## Testing package builds

```sh
nix-build -E "with import <nixpkgs> {}; callPackage ./breezewiki.nix {}"
```