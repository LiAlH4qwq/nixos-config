# Read-only Agents

## Summary

This repo is a NixOS configuration, with lots of modern and bleeding-edge settings.

## Features

- Modern CLI:
  - nushell, fish <- bash
  - starship <- PS1
  - zoxide <- cd
  - eza <- ls
  - fd <- find
  - ripgrep <- grep
  - bat <- cat
  - fzf
- State-less System:
  - Root (/) -> tmpfs
  - Home (/home) -> tmpfs
  - Required states -> Explicitly declare -> Into /persist
- Decoupled Layers
  - ./system: Generic config, for both NixOS and Nix-on-Droid (WIP)
  - ./nixos: Generic NixOS config, decoupled with devices config
  - ./home: Generic Home Manager config, decoupled with specific user config
  - ./devices: Device specific config
  - ./devices/users/<name>: Specific user config for specific device
  - ./parts: flake-parts modules
- Custom library extension:
  - lib.kdl: kdl generator from github:lhcfl/nix-kdl
  - lib.liuxu: helpers for this repo
  - lib.hm: helpers from Home Manager
  - All of these available anywhere!
- Centralized own packages
  - ./packages/<name>: real package defination
  - ./parts/packages: attach own packages above to flake first
  - ./parts/overlays: own overlay, add above own packages by access flake config, while modify some packages in nixpkgs


## Rules

- Usage of nix profile, nix env or any other imperative tools to install softwares is strictly **prohibited**, use nix run instead
- Usage of global python, pip is also strictly **prohibited**, use uv instead
- ts / js is prefered than python, pnpm, npm, node, deno, bun is globally available
- Althrough tsc is available, but ts can run directly thanks of node 26, deno, bun, writing ts is prefered than js due to less bug
- Using nixos mcp is prefered than querying nix store directly
- In addition of traditional cli tools, modern cli tools above is also available, and they're more friendly

## Known Issues