# Tips

## Minimal cluster

This is the minimal cluster spec

```yaml
apiVersion: postgresql.cnpg.io/v1
kind: Cluster
metadata:
  name: sinbootstrap
spec:
  storage:
    storageClass: standard
    size: 1Gi
```

## Disable non ssl connections

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
- We can get the current rules with this

```postgresql
select pg_reload_conf();
table pg_hba_file_rules;
```

> <https://www.postgresql.org/docs/current/auth-pg-hba-conf.html>

## Recreate all the cluster nodes

- Destroy 2 replicas

```shell
kubectl cnpg destroy MYCLUSTER ONE-REPLICA
kubectl cnpg destroy MYCLUSTER ANOTHER-REPLICA
```

Once they are ok, promote a replica to be primary

```shell
kubectl cnpg promote MYCLUSTER ONE-REPLICA
```

Once is prometed, destroy the older primary

```shell
kubectl cnpg destroy MYCLUSTER OLD-PRIMARY
```

## Info about primary replicas

Show the nodes where the replicas are located

```shell
kubectl get pod -A -l cnpg.io/instanceRole=primary -o custom-columns=NAME:.metadata.name,NAMESPACE:.metadata.namespace,NODE:.spec.nodeName
```

## get an sql session

```shell
kubectl cnpg psql mycluster
```

```shell
SELECT timeline_id FROM pg_control_checkpoint();
```
