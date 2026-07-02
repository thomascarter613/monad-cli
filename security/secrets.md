# Secret Governance

## Rules

- Never commit real secrets.
- Use `.env.example` for names and safe placeholders only.
- Use local `.env` files for development.
- Use a secret manager for shared environments.
- Rotate secrets after exposure.
- Document every required secret with purpose, owner, and environment.

## Recommended Secret Managers

- 1Password
- Infisical
- HashiCorp Vault
- Doppler
- Cloud provider secret managers

## Rotation Procedure

1. Identify exposed or stale secret.
2. Revoke old value.
3. Generate new value.
4. Update secret store.
5. Update dependent environment.
6. Record evidence in the relevant work packet or incident note.

## Environment Files

Allowed:

```txt
.env.example
.env.local.example
```

Forbidden:

```txt
.env
.env.local
.env.production
```
