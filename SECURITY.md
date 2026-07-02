# Security Policy

Monad is pre-v1. Please report security issues privately to the maintainers.

## Security principles

- No silent destructive writes.
- No writes outside the workspace root.
- No destructive symlink traversal by default.
- No dynamic native plugins in v1.
- External plugin adapters are declarative and explicit.
- Mutating commands are plan-backed and dry-run capable.
