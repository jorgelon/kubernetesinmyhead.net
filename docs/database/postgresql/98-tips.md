# Tips

## List all databases

```postgresql
SELECT datname FROM pg_database WHERE datistemplate = false;
```

## List roles

```postgresql
SELECT rolname FROM pg_roles;
SELECT * FROM pg_roles;
```

## List roles and attributes

```postgresql
SELECT r.rolname, r.rolsuper, r.rolinherit,
  r.rolcreaterole, r.rolcreatedb, r.rolcanlogin,
  r.rolconnlimit, r.rolvaliduntil,
  ARRAY(SELECT b.rolname
        FROM pg_catalog.pg_auth_members m
        JOIN pg_catalog.pg_roles b ON (m.roleid = b.oid)
        WHERE m.member = r.oid) as memberof
, r.rolreplication
, r.rolbypassrls
FROM pg_catalog.pg_roles r
WHERE r.rolname !~ '^pg_'
ORDER BY 1;
```

## Get the database owner

```postgresql
SELECT d.datname as "Name",
pg_catalog.pg_get_userbyid(d.datdba) as "Owner"
FROM pg_catalog.pg_database d
WHERE d.datname = 'tmb'
ORDER BY 1;
```

## Create role with password and DDBB with owner

```postgresql
CREATE ROLE owner WITH LOGIN PASSWORD 'whatever';
CREATE DATABASE database WITH OWNER = 'owner';
```

## Delete rol/user

```postgresql
REASSIGN OWNED BY grafanareader TO postgres;
DROP OWNED BY grafanareader;
DROP USER grafanareader;
```

## View the default privileges in a specific schema

To view the default privileges in a specific schema in PostgreSQL, you can query the pg_default_acl system catalog. This catalog contains information about the default access control lists (ACLs) for objects created in the database.

Query to Get Default Privileges
Here is a query to retrieve the default privileges for the tmb schema:

Explanation

- pg_default_acl: This catalog contains the default ACLs for objects created in the database.
- pg_namespace: This catalog contains information about schemas.
- pg_roles: This catalog contains information about roles.
- defaclobjtype: The type of object the default ACL applies to (e.g., r for tables, S for sequences, f for functions).
- defaclacl: The default ACLs for the specified object type.

```postgresql
SELECT
    n.nspname AS schema_name,
    r.rolname AS role_name,
    CASE d.defaclobjtype
        WHEN 'r' THEN 'TABLE'
        WHEN 'S' THEN 'SEQUENCE'
        WHEN 'f' THEN 'FUNCTION'
        ELSE d.defaclobjtype
    END AS object_type,
    d.defaclacl AS default_privileges
FROM
    pg_default_acl d
JOIN
    pg_namespace n ON n.oid = d.defaclnamespace
JOIN
    pg_roles r ON r.oid = d.defaclrole
WHERE
    n.nspname = 'myschema';
```
