# PostgreSQL Template Databases: template0 and template1

PostgreSQL ships with two special template databases used as the basis for creating new databases: `template1` and `template0`.

## template1

`template1` is the default template used by `CREATE DATABASE`. When you run:

```sql
CREATE DATABASE mydb;
```

PostgreSQL clones `template1`. This means anything inside `template1` — extensions, schemas, tables, functions — will be inherited by every new database.

You can modify `template1` to pre-populate new databases with shared objects:

```sql
\c template1
CREATE EXTENSION pg_trgm;
-- Every database created after this will have pg_trgm installed
```

**Limitations**: `template1` cannot be used as a template while any other session is connected to it.

## template0

`template0` is a clean, pristine copy of the initial database state. It is never modified after cluster initialization and should never be modified by the user.

Its main use cases are:

- **Restoring a dump** that may conflict with objects already in `template1`
- **Creating a database with a different encoding or locale** than `template1`

```sql
-- Restore a pg_dump without inheriting template1 customizations
CREATE DATABASE mydb TEMPLATE template0;

-- Create a database with a specific locale
CREATE DATABASE mydb
  TEMPLATE template0
  ENCODING 'UTF8'
  LC_COLLATE 'es_ES.UTF-8'
  LC_CTYPE 'es_ES.UTF-8';
```

Because `template0` contains no user-added objects, a dump/restore cycle against it is always safe.

## Key Differences

| Feature                  | template1       | template0         |
|--------------------------|-----------------|-------------------|
| Default template         | Yes             | No                |
| Can be modified          | Yes             | No (must not be)  |
| Allows connection        | Yes             | Only as superuser |
| Encoding/locale override | No              | Yes               |
| Use for pg_restore       | Not recommended | Recommended       |

## Specifying a Template Explicitly

Any database (not just the two built-ins) can serve as a template:

```sql
CREATE DATABASE newdb TEMPLATE mytemplate;
```

The source database must have no active connections when used as a template.

## Reference

- [PostgreSQL docs — Template Databases](https://www.postgresql.org/docs/current/manage-ag-templatedbs.html)
