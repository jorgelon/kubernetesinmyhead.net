# Perlas

## Grafana loki no inicia y se queda en ContainerCreating

En modo singlebinary

```shell
kubectl delete pod/loki-0 persistentvolumeclaim/storage-loki-0 --grace-period=0 --force
```
