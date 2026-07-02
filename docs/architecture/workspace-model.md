# Workspace Model

Monad's canonical source of truth is:

```txt
monad.toml
monad.lock
.monad/
```

Native files such as `package.json`, `turbo.json`, `moon.yml`, `biome.json`, `Cargo.toml`, `go.work`, `pyproject.toml`, and `.github/workflows/*` are synchronized outputs or external facts.

## Unit kinds

```txt
app
service
package
lib
tool
config
policy
infra
docs
contract
test
agent
```

## Unit ID format

```txt
<kind>:<name>
```

Examples:

```txt
app:web
service:api
package:ui
lib:core
tool:cli
```
