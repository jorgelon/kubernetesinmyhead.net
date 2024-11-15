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

## Info about primary replicas

Show the nodes where the replicas are located

```shell
kubectl get pod -A -l cnpg.io/instanceRole=primary -o custom-columns=NAME:.metadata.name,NAMESPACE:.metadata.namespace,NODE:.spec.nodeName
```

## Backups

List completed backups

```shell
kubectl get backups -o jsonpath='{range .items[?(@.status.phase=="completed")]}{.metadata.name}{"\n"}{end}'
```

List not completed backups

```shell
kubectl get backups -o jsonpath='{range .items[?(@.status.phase!="completed")]}{.metadata.name}{" - Status: "}{.status.phase}{"\n"}{end}'
```

List failed backups

```shell
kubectl get backups -o jsonpath='{range .items[?(@.status.phase=="failed")]}{.metadata.name}{"\n"}{end}'
```

List volume backup snaphots

```shell
kubectl get backups -o jsonpath='{range .items[?(@.spec.method=="volumeSnapshot")]}{.metadata.name}{"\n"}{end}'
```

Same but older thatn 30 days

```shell
kubectl get backups --sort-by=.metadata.creationTimestamp -o jsonpath='{range .items[?(@.spec.method=="volumeSnapshot")]}{.metadata.name}{"\n"}{end}' | head -n -30
```

Delete them, per namespace

```shell
for backup in $(kubectl get backups  --sort-by=.metadata.creationTimestamp -o jsonpath='{range .items[?(@.spec.method=="volumeSnapshot")]}{.metadata.name}{"\n"}{end}' | head -n -30); do kubectl delete backup $backup;done
```
