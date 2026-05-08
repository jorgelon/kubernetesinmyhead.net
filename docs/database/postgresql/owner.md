# Database Owner

A database owner is the PostgreSQL role that created the database or was explicitly assigned ownership of it. The owner has full control over the database: they can drop it, modify its parameters, and grant or revoke privileges on it to other roles — regardless of the privileges that other superusers or roles might hold.

Key points:

- Ownership is stored in `pg_database.datdba`.
- Only the owner (or a superuser) can drop the database or alter its definition.
- The owner does **not** automatically have privileges on all objects inside the database — object-level privileges are separate.
- A non-superuser owner can only own a database if they have the `CREATEDB` privilege.

## Permissions of the Database Owner

| Action                           | Owner                | Superuser | Other roles               |
|----------------------------------|----------------------|-----------|---------------------------|
| Drop the database                | Yes                  | Yes       | No                        |
| Alter database parameters        | Yes                  | Yes       | No                        |
| Connect to the database          | Yes (unless revoked) | Yes       | Only if `CONNECT` granted |
| Create schemas inside it         | Yes                  | Yes       | Only if `CREATE` granted  |
| Grant privileges on the database | Yes                  | Yes       | No                        |

Owning the database does **not** grant automatic access to schemas, tables, or other objects created by other roles inside it. Those require explicit `GRANT` statements.

## Set the Owner at Creation

```sql
CREATE DATABASE mydb OWNER myrole;
```

## Change the Owner of an Existing Database

```sql
ALTER DATABASE mydb OWNER TO newrole;
```

Only a superuser or the current owner can transfer ownership. The new owner must also have the `CREATEDB` privilege (unless they are a superuser).

## Get the database owner

of the current database

```postgresql
SELECT u.usename AS owner
FROM pg_database d
JOIN pg_user u ON (d.datdba = u.usesysid)
WHERE d.datname = current_database();
```

of a database

```postgresql
SELECT d.datname as "Name",
pg_catalog.pg_get_userbyid(d.datdba) as "Owner"
FROM pg_catalog.pg_database d
WHERE d.datname = 'mydatabase'
ORDER BY 1;
```
