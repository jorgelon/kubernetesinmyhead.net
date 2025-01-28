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
