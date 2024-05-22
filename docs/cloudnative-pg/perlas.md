# Perlas

## Cluster minimo

El cluster con la menor configuracion posible solo lleva el tamaño del almacenamiento, si tienes una storageclass por defecto
Sino, tambien hay que indicarla

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

## Obtener listado de backups fallidos

```shell
kubectl get backups -o jsonpath='{range .items[?(@.status.phase==failed")]}{.metadata.name}{"\n"}{end}'
```

## Obtener listado de backups de tipo volumeSnaphot

```shell
kubectl get backups -o jsonpath='{range .items[?(@.spec.method=="volumeSnapshot")]}{.metadata.name}{"\n"}{end}'
```

## Obtener listado de los backups de tipo volumeSnaphot con creationTimestamp que no estan en los 30 mas recientes

```shell
kubectl get backups --sort-by=.metadata.creationTimestamp -o jsonpath='{range .items[?(@.spec.method=="volumeSnapshot")]}{.metadata.name}{"\n"}{end}' | head -n -30
```

## borrarlos (por namespace)

```shell
for backup in $(kubectl get backups  --sort-by=.metadata.creationTimestamp -o jsonpath='{range .items[?(@.spec.method=="volumeSnapshot")]}{.metadata.name}{"\n"}{end}' | head -n -30); do kubectl delete backup $backup;done
```

## Listar por estado

### Completados

```shell
kubectl get backups -o jsonpath='{range .items[?(@.status.phase=="completed")]}{.metadata.name}{"\n"}{end}'
```

### No completados

```shell
kubectl get backups -o jsonpath='{range .items[?(@.status.phase!="completed")]}{.metadata.name}{" - Status: "}{.status.phase}{"\n"}{end}'
```

### Fallidos

```shell
kubectl get backups -o jsonpath='{range .items[?(@.status.phase=="failed")]}{.metadata.name}{"\n"}{end}'
```
