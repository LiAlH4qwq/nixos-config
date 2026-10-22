# AGENTS.md

Instructions for AI agents working in this repository. Read this fully before editing.

## What this repo is

A NixOS configuration flake for personal machines, using flake-parts, a strict
directory = option-path module convention, and a custom switch system for
enabling features across NixOS / home-manager / nix-on-droid scopes.

## Git workflow (HARD RULES)

1. **Never commit on `main`.** `main` is protected by policy.
2. **Always create a new branch** for any change: `git switch -c <type>/<short-name>`.
3. Integrate only **after explicit approval**, by **squashing** the branch into `main`.
4. **Regular merge commits and rebase are forbidden.** The only allowed integration is a squash:

   ```sh
   git switch main
   git merge --squash <branch>   # stages the combined diff, no merge commit
   git commit -m "<message>"
   git branch -D <branch>
   ```

5. Do not push, delete branches, or rewrite history unless the user asks.
6. Keep commits focused; one logical change per commit on the branch.

## Repo map

| Path | Purpose |
| --- | --- |
| `flake.nix` | flake inputs, `nixConfig`, and the flake-parts entry (`liuxu.fp.nixos.hosts` lists hosts). |
| `parts/` | flake-parts modules (outputs wiring). `parts/default.nix` imports them all. |
| `scopes/` | **Data**: this repo's namespace and per-scope roots/deps. Schema/evaluation come from `nix-tree-modules`. |
| `lib/` | Extended `lib`, exposed as `lib.kdl`, `lib.liuxu`, `lib.hm`, `lib.nix-tree-modules`. |
| `lib/liuxu/` | Pure utilities: combinators + `<name>Desc` helpers. No settings. |
| `nix-tree-modules` (input) | External flake [`LiAlH4qwq/nix-tree-modules`](https://github.com/LiAlH4qwq/nix-tree-modules): the `here` DSL and scope registry schema. Exposed as `lib.nix-tree-modules`. |
| `system/` | OS-agnostic config shared by NixOS and nix-on-droid (WIP). |
| `nixos/` | Generic NixOS config, decoupled from devices. |
| `home/` | Generic home-manager config, decoupled from users. |
| `devices/` | Per-device config (`devices/<host>/`), including `devices/<host>/users/`. |
| `ids/` | Identity data (`liuxu.id.<name>`). |
| `packages/` | This repo's own packages; attached to the flake by `parts/packages`. |
| `nix-on-droid/` | nix-on-droid configuration. |
| `sops/`, `secrets/` | Secrets (sops-nix). Never print secret values. |

Flake outputs are assembled from `parts/`: `nixosConfigurations`, `nixosModules`,
`homeModules`, `nixOnDroidConfigurations`, `overlays`, `packages`, `checks`,
`lib`, `nixConfig`.

## Module layout: strict tree

Every module is a directory module at `a/b/.../z/default.nix`:

- Only a file named `default.nix` is a module. Any other `*.nix` in a module tree is an error.
- A directory may be **both** a module (`default.nix`) and a parent of child modules.
- Names starting with `_` are skipped by the walker.
- The option path equals the directory path under the scope root. Example:
  `home/modules/gui/niri/default.nix` → `liuxu.home.gui.niri.*`.

The walker is `lib.nix-tree-modules.mkTree { scopes; scopeName; dir; base ? [ ]; }` and is applied
by the parent module (see `nixos/default.nix`, `home/default.nix`, `home/modules/default.nix`,
`system/default.nix`).

## The `here` DSL

The `here` DSL (strict-tree walker + switch translation) lives in its own flake,
[`LiAlH4qwq/nix-tree-modules`](https://github.com/LiAlH4qwq/nix-tree-modules),
consumed here as the `nix-tree-modules` input and exposed as `lib.nix-tree-modules`.

Its [README](https://github.com/LiAlH4qwq/nix-tree-modules#readme) documents the
module shape (`here.switch` / `here.options` / `here.option` / `here.apply`), the
switch gating semantics (`generate`, `premise`, `internal.final`), the premise
boolean algebra, and the strict-tree rules. That repo also owns the regression
tests (`checks.<system>.switch`).

Local walker rules for this repo:

- Do not add local `imports = [ ./child ]` inside a walked tree — the walker collects children.
- Delete import-only umbrella `default.nix` files when converting a tree to a walker.
- If a module lives at a different path than its options, either move the file (preferred) or
  give the walker a matching `base`.

## Scope registry (`scopes/`)

The registry **schema and evaluator** live upstream in `nix-tree-modules`
(`scopeModule`, `mkScopes`); this repo keeps only the **data** in
`scopes/default.nix` (`namespace` plus each scope's `root`/`deps`/`switches`).
`parts/scopes/default.nix` calls `lib.nix-tree-modules.mkScopes` and injects the
result as the flake-parts module arg `scopes`. It is forwarded into NixOS
(`specialArgs`), home-manager (`extraSpecialArgs`), docs, and nix-on-droid.

- `namespace` — global option namespace (set here to `[ "liuxu" ]`).
- `scopes.<name>.root` — option path; `scopes.<name>.deps.<to>` — allowed premise edges
  with `cardinality` (`one`/`many`), `defaultQuant` (`any`/`all`), optional `prefix`,
  and `instances` (`args -> [ instanceConfig ]`, required for `many`).
- Scopes: `fp`, `nixos`, `nix-on-droid`, `home`, `id`, `system`, `device`.
- `lib.liuxu` must stay settings-free; do **not** put scope data back into `lib/`.

## Library

`lib.liuxu` (all available as `lib.liuxu.*` everywhere):

- `lib.nix-tree-modules` (the [`here` DSL](https://github.com/LiAlH4qwq/nix-tree-modules)):
  `mkTree`, `translateModule`, `evalPremise`, `mkSwitchRefType`, `mkPremiseType`,
  `mkSwitchOptionType`, `scopeModule`, `mkScopes`.
- Switches (legacy helpers still used outside `here`): `mkSwitchOnOption` (opt-in),
  `mkSwitchOffOption` (opt-out), `mkComputedOption` / `mkComputedSwitchOption`,
  `mkIfElse`, and the `mkOs*/mkHome*/mkFp*/mkId*` wrappers.
- Combinators: `I K C B o oo on on2 compose*`, `hyprland.{mkBind,...}`.
- `lib.kdl` (from `github:Lhcfl/nix-kdl`), `lib.hm` (home-manager lib).

## Commands

Local verification is **eval-only** — it evaluates every output but builds
nothing. CI (declared in `parts/gh-workflows`, rendered to
`.github/workflows/ci.yml`) is the authoritative check and does build:

```sh
nix flake check --no-build --all-systems   # local: eval only
nix fmt                                    # format (nixfmt, rfc style) — run before committing

nix flake check --repair --all-systems     # CI: the authoritative check (builds)
nix build .#doc                            # CI also builds the option docs
```

Do not treat an ad-hoc `nix eval` of a single option as a substitute for the
local `--no-build` check; it can pass while evaluation fails. Only build locally
when you need to exercise something that requires a derivation (tests, ISO,
toplevel). Other useful commands:

```sh
nix build .#checks.x86_64-linux.nix-tree-modules-switch   # library regression test
nix eval .#nixosConfigurations.<host>.config.<path>   # inspect an option
nix build .#nixosConfigurations.<host>.config.system.build.toplevel
nix build .#packages.x86_64-linux.live-cd      # live ISO
```

To inspect evaluated config across hosts, prefer `nix eval` on specific options; forcing
`config.system.build.toplevel.drvPath` triggers IFD (`references.nix`) and may fail in the
sandbox even when the config is valid.

## Style rules (enforced)

- Format with `nixfmt` (rfc style) via `nix fmt`.
- **Do not use `rec`.** Use `let` with the smallest necessary scope.
- Unused function argument → `_:`, not `{ ... }:`.
- **Module defaults and examples must be host-independent.** Anything tied to a
  specific machine (host name, DRM connector, disk, …) is set on the host side
  (`devices/<host>/`), not defaulted in `nixos/` or `home/`. Prefer `null` (let
  the underlying tool fall back) or a neutral constant over a real host value.
- **Option descriptions use the scope's `mk*Desc` helper**, never a hand-written
  `Liuxu (...)` prefix: `lib.liuxu.mkOsDesc` (nixos), `lib.liuxu.mkHomeDesc`
  (home), `lib.liuxu.mkFpDesc` (fp), `lib.liuxu.mkIdDesc` (id). Bind it once as
  `desc` in the module `let` and wrap every `description`.
- Hyphenated attribute names are valid identifiers; do not quote them:
  `ai-coding-agent.opencode`, `nix-on-droid`, not `."ai-coding-agent"`.
  (Quotes are still required for names with `/`, `.`, `+`, spaces, or leading digits.)
- Prefer `lib`/`builtins` helpers and the existing combinators over ad-hoc code.

## Environment rules

- **Never** install software imperatively (`nix profile`, `nix-env`, `pip install`).
  Use `nix run`, or add a package to the repo.
- Use `uv` for Python; never global `python`/`pip`.
- Prefer TS/JS over Python. `node`, `deno`, `bun`, `pnpm` are available; TS runs directly
  under node 26/deno/bun. `tsc` exists but is not required.
- Prefer the modern CLI tools already installed: `nu`/`fish`, `rg` (grep), `fd` (find),
  `eza` (ls), `bat` (cat), `zoxide`, `starship`, `fzf`.
- Prefer the NixOS MCP tool over querying the nix store directly.
- Never print secret values from `sops/` or `secrets/`.

## Known issues

- `https://cache.xinux.uz` returned 502 Bad Gateway (nginx) and is commented out in
  `flake.nix` (both the substituter and its public key). A flaky substituter can still
  make IFD builds fail (e.g. `references.nix` when forcing
  `config.system.build.toplevel`); retry, build the specific derivation, or pass
  `--fallback`. The authoritative verification stays the CI command:
  `nix flake check --repair --all-systems`.
- Some eval paths are lazy: a host may evaluate for selected options while forcing
  `config.system.build.toplevel` still triggers IFD.
