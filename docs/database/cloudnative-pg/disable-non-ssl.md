# Disable non ssl connections

If we want to deny all non ssl connections to the cluster, we can add this sections to the cluster

```yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: postgre
spec:
  postgresql:
    pg_hba:
      - hostssl all all all scram-sha-256
      - hostnossl all all all reject
```

This setting add 2 rules between some fixed rules (system rules) and the default rule that permits both ssl and non ssl connections.
The fist rule permit ssl connections via password and the second one denies non ssl connections.

> The postgresql documentation says "The first record with a matching connection type, client address, requested database, and user name is used to perform authentication."

Some tips:

- We can do better rules specifying users, databases and hosts
- The controller applies these rules without restarting the pods

## Links

- PostgreSQL Configuration

<https://cloudnative-pg.io/documentation/1.24/postgresql_conf/#the-pg_hba-section>

- The pg_hba.conf File

<https://www.postgresql.org/docs/current/auth-pg-hba-conf.html>
