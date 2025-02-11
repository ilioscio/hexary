# Hexary
A hexagonal engine to rule them all and in the darkness bind them.

# Install

## Windows

Install zig via winget:
```
winget install -e --id zig.zig
```
Clone repo:
```
git clone https://github.com/ilioscio/hexary.git
```

## NixOS

Clone repo:
```
git clone https://github.com/ilioscio/hexary.git
```
Get build enviroment with zig LSP via nix:
```
cd hexary
nix-shell
```

# Build
```
cd hexary
zig build
```

# Run

Built binaries are available in the zig-out directory eg.
```
/hexary/zig-out/hexary.exe
```

