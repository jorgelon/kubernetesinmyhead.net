# Perlas

## Agregar un cluster externo a argocd (o modificar uno existente)

> Aplica a kubeconfigs standard, no aws o similar

Si queremos modificar uno, listamos los clusters e identificamos el que queremos modificar

```shell
export KUBECONFIG=PATH_AL_KUBECONFIG_DEL_CLUSTER_DE_ARGOCD
kubens argocd
kubectl get secret -l argocd.argoproj.io/secret-type=cluster
```

Agregamos el nuevo

```shell
argocd cluster add -y --core \
kubernetes-admin@hyperv-testing  \
--kubeconfig PATH_AL_KUBECONFIG_DEL_NUEVO_CLUSTER \
--name NOMBRE_DEL_CLUSTER \
--project MI_PROYECTO \
--cluster-endpoint kubeconfig \
--upsert
```
