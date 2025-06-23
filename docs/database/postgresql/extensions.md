# Tips: extensions

To determine where a PostgreSQL extension is installed, you can query the pg_extension system catalog. This catalog contains information about all the extensions installed in the current database, including the schema in which each extension is installed.

SQL Query to Find Extension Installation Schema
Here is a query to list all extensions installed in the current database along with the schema in which each extension is installed:

```postgresql
SELECT
    e.extname AS extension_name,
    n.nspname AS schema_name
FROM
    pg_extension e
JOIN
    pg_namespace n ON e.extnamespace = n.oid
ORDER BY
    extension_name;
```

Explanation

- pg_extension: This catalog contains information about all the extensions installed in the current database.
- pg_namespace: This catalog contains information about schemas.
- extname: The name of the extension.
- extnamespace: The OID of the schema where the extension is installed.
- nspname: The name of the schema.
