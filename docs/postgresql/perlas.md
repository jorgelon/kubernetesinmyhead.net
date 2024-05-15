# Perlas

## listar roles

```postgresql
SELECT rolname FROM pg_roles;
```

## listar roles y atributos

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

## Crear role con contraseña y base de datos con owner

```postgresql
CREATE ROLE owner WITH LOGIN PASSWORD 'whatever';
CREATE DATABASE database WITH OWNER = 'owner';
```

## Borrar rol/user

```postgresql
DROP USER role;
```
