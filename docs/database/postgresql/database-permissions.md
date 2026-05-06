# Giving database permissions

## At creation time

We can simply create a database or give adittional permissions.

### WITH OWNER

The owner has full control over the database, including `DROP` and `ALTER` operations.

Use `WITH OWNER` to assign full ownership, inclRuding `DROP` and `ALTER` operations.

## After creation

After creating the database we can connect to it and assing some permissions

### ALL PRIVILEGES

`GRANT ALL PRIVILEGES ON DATABASE` grants the following database-level permissions:

- **CONNECT** — allows the role to connect to the database
- **TEMPORARY** — allows the role to create temporary tables
- **CREATE** — allows the role to create new schemas

It does not grant access to tables or other objects inside the database — those require schema-level grants.

> `WITH OWNER` grants full ownership (including `DROP` and `ALTER`) and cannot be revoked, while `GRANT ALL PRIVILEGES` grants only CONNECT, TEMPORARY, and CREATE and can be revoked at any time.

### SCHEMA public

`GRANT ALL ON SCHEMA public` grants:

- **USAGE** — allows the role to see and access objects within the schema. Without it, the role cannot access any tables even if table-level grants exist.
- **CREATE** — allows the role to create new objects in the schema.

`ALTER DEFAULT PRIVILEGES` ensures grants are automatically applied to tables and sequences
created in the future. Without it, any new object would be invisible to the role until
grants are manually re-run.

To check the current default privileges:

```postgresql
SELECT * FROM pg_default_acl;
```

## Examples

### Application user with a new database

Connected to `postgres`:

```postgresql
CREATE USER myapp WITH PASSWORD 'strong-password-here';
CREATE DATABASE myapp_db;
GRANT ALL PRIVILEGES ON DATABASE myapp_db TO myapp;
```

Connected to `myapp_db`:

```postgresql
GRANT ALL ON SCHEMA public TO myapp;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON TABLES TO myapp;
ALTER DEFAULT PRIVILEGES IN SCHEMA public GRANT ALL ON SEQUENCES TO myapp;
```

### Keycloak

Same as above, plus connected to `myapp_db`:

```postgresql
GRANT SELECT ON pg_class, pg_namespace TO myapp;
```

## Documentation

- [CREATE DATABASE](https://www.postgresql.org/docs/current/sql-createdatabase.html)
- [GRANT](https://www.postgresql.org/docs/current/sql-grant.html)
- [ALTER DEFAULT PRIVILEGES](https://www.postgresql.org/docs/current/sql-alterdefaultprivileges.html)
