# Rust to Haskell FFI cross-compilation demo

This project aim's to demonstrate how to cross-compile (targeting
`x86_64-w64-mingw32` platform) a Haskell binary that call a static library (the
`libgreetings.a`) built from a Rust codebase.

This project is built using `haskell.nix`, so just:

```shell
nix build # depends on https://github.com/yvan-sraka/greetings flake
nix-shell -p wineWowPackages.stable
wine64 ./result/bin/haskell-demo.exe # print "Hello, Haskell!" to the stdout
```
