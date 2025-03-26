# shellhazard's Nix components

Assorted modules that I've hacked together that are certainly useful, but unsuitable for upstream.

## Testing package builds

```sh
nix-build -E "with import <nixpkgs> {}; callPackage ./breezewiki.nix {}"
```