# Roles and Users

## CREATE USER vs CREATE ROLE

`CREATE USER` is an alias for `CREATE ROLE ... LOGIN`. The key differences:

- `CREATE ROLE` without `LOGIN` creates a group role (no login allowed)
- `CREATE USER` implicitly adds `LOGIN`, so the role can authenticate

## Creating a Login User

```postgresql
CREATE USER company_x WITH PASSWORD 'strong-password-here';
-- equivalent to:
CREATE ROLE company_x WITH LOGIN PASSWORD 'strong-password-here';
```

`ENCRYPTED PASSWORD` is a no-op since PostgreSQL 10 — passwords are always stored encrypted. Use `PASSWORD` instead.

## Group Roles (RBAC Pattern)

Define a role that holds privileges, then assign it to login users:

```postgresql
CREATE ROLE readonly;
GRANT readonly TO alice;
GRANT readonly TO bob;
```

Common group role patterns: `readonly`, `readwrite`, `reporting`, `app_backend`.

## List roles

```postgresql
SELECT rolname FROM pg_roles;
SELECT * FROM pg_roles;
```

## Documentation

- [CREATE ROLE](https://www.postgresql.org/docs/current/sql-createrole.html)
- [CREATE USER](https://www.postgresql.org/docs/current/sql-createuser.html)
