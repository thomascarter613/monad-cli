# Monad v1 Defaults

```txt
canonical_manifest = "monad.toml"
canonical_lockfile = "monad.lock"
state_directory = ".monad/"
default_package_manager = "bun"
default_scope = "@monad"
default_init_preset = "governed"
```

## Default directory structure

```txt
apps/
services/
packages/
libs/
tools/
infra/
configs/
contracts/
policies/
docs/
scripts/
tests/
agents/
.monad/
```

## First built-in packs

```txt
typescript-bun
rust-crate
go-service
python-package
docs
adr
workpacket
policy
github-actions
docker
```

## Implementation doctrine

```txt
Every mutating command generates a plan internally.
Every mutating command supports --dry-run.
Plan files are JSON.
Packs v1 are built-in Rust modules.
Plugins v1 are declarative external command adapters only.
Task execution delegates to native tools.
Git integration shells out to git.
No async runtime initially unless later needed.
```
