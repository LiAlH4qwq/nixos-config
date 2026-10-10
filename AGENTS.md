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
| `scopes/` | **Settings**: the scope registry, evaluated via `lib.evalModules`. Not library code. |
| `lib/` | Extended `lib`, exposed as `lib.kdl`, `lib.liuxu`, `lib.hm`, `lib.nix-tree-modules`. |
| `lib/liuxu/` | Pure utilities: combinators + `<name>Desc` helpers. No settings. |
| `nix-tree-modules/` | Separate flake: the `here` DSL (strict-tree walker + switch translation). Exposed as `lib.nix-tree-modules`. |
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

A module may take an injected read-only `here` handle (its file/path/own-subtree
config) and may return a `here` attribute declaring its switch metadata, options
and gated config:

```nix
{ here, lib, ... }:
{
  here.switch = {
    generate    = true;          # explicit bool; true generates the public <path>.enable
    default     = false;         # default of the generated enable
    description = "…";           # description of the generated enable
    premise     = <premise>;     # boolean over other switches
  };
  here.options = { /* sub-options, placed at <scope-root>.<path>.* */ };
  here.option  = <option>;       # an option at <scope-root>.<path> itself
  here.apply   = { /* gated config */ };

  # normal module surface is also honoured: `imports`, `options`, `config`.
}
```

Injected handle (read only): `here.file`, `here.path`, `here.config` (the config
at this node's own subtree), `here.options`.

Semantics:

- Generated per module at path `p` in scope with root `R`:
  - `R.<p>.enable` — public, only when `generate = true`.
  - `R.<p>.switch` — internal metadata, only when `generate = true`.
  - `R.internal.final.<p>.enable` — read-only computed final (always generated).
- Gating (there is no `configGating`): config is gated iff `generate` is true or
  `premise` is non-empty; `final = (if generate then <p>.enable else true) && premiseOk`.
- No switch and empty premise → a transparent/support node: config unconditional.
- `premise` is a boolean algebra over switch references:
  - `[ "a" "b" ]` — a path (one switch); a leading `"here"` makes it relative to
    the current node; `"a/b/c"` is equivalent. A list is never an AND.
  - `{ scope ? <self>; path = [ … ]; quant = "any" | "all"; }` — explicit ref.
  - `{ all = [ … ]; }` / `{ any = [ … ]; }` / `{ not = …; }` — combinators.
  A cross-scope ref is legal only along the scope DAG (`scopes/default.nix`) and
  reads the target's computed `internal.final`; a missing target errors immediately.
- `here.option` declares the node path itself as a leaf option (for modules whose
  own path is an attrset/submodule); it cannot be combined with `generate`.

A module without `here` is imported as-is (plain module).

### Strict tree rules recap

- Do not add local `imports = [ ./child ]` inside a walked tree — the walker collects children.
- Delete import-only umbrella `default.nix` files when converting a tree to a walker.
- If a module lives at a different path than its options, either move the file (preferred) or
  give the walker a matching `base`.

## Scope registry (`scopes/`)

`scopes/default.nix` is evaluated once through `lib.evalModules` and injected by
`parts/scopes/default.nix` as the flake-parts module arg `scopes`. It is forwarded into
NixOS (`specialArgs`), home-manager (`extraSpecialArgs`), docs, and nix-on-droid.

- `namespace` — global option namespace (default `[ "liuxu" ]`).
- `scopes.<name>.root` — option path; `scopes.<name>.deps.<to>` — allowed premise edges
  with `cardinality` (`one`/`many`), `defaultQuant` (`any`/`all`), optional `prefix`,
  and `instances` (`args -> [ instanceConfig ]`, required for `many`).
- Scopes: `fp`, `nixos`, `nix-on-droid`, `home`, `id`, `system`.
- `lib.liuxu` must stay settings-free; do **not** put scope data back into `lib/`.

## Library

`lib.liuxu` (all available as `lib.liuxu.*` everywhere):

- `lib.nix-tree-modules` (the `here` DSL, from the `nix-tree-modules` flake): `mkTree`, `translateModule`,
  `evalPremise`, `mkSwitchRefType`, `mkPremiseType`, `mkSwitchOptionType`.
- Switches (legacy helpers still used outside `here`): `mkSwitchOnOption` (opt-in),
  `mkSwitchOffOption` (opt-out), `mkComputedOption` / `mkComputedSwitchOption`,
  `mkIfElse`, and the `mkOs*/mkHome*/mkFp*/mkId*` wrappers.
- Combinators: `I K C B o oo on on2 compose*`, `hyprland.{mkBind,...}`.
- `lib.kdl` (from `github:Lhcfl/nix-kdl`), `lib.hm` (home-manager lib).

## Commands

**The correct way to check a change is exactly what CI runs**, i.e. the same
command declared in `parts/gh-workflows` (rendered to `.github/workflows/ci.yml`):

```sh
nix flake check --repair --all-systems   # the CI check — the authoritative one
nix build .#doc                          # CI also builds the option docs
```

Do not treat an ad-hoc `nix eval` of a single option as a substitute; it can pass
while CI fails. Other useful commands:

```sh
nix fmt                     # format (nixfmt, rfc style) — run before committing
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
