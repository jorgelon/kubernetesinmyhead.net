# Tips

## Get all cluster scoped managed resource definitions

```shell
kubectl get mrd --no-headers -o name | grep .aws.upbound.io
kubectl get crd --no-headers -o name | grep .aws.upbound.io
```

Remove them

!!! danger "Danger"
    This will remove if managed resources used by that crds.
    It includes cluster scoped providerconfigs and providerconfigusages
    This is safe and useful if were are using namespaced MRDs and we are controlling their activation via mrap

```shell
for mrd in $(kubectl get mrd --no-headers -o name | grep .aws.upbound.io); do kubectl delete $mrd ; done
for crd in $(kubectl get crd --no-headers -o name |  grep .aws.upbound.io | grep -v providerconfig ); do kubectl delete $crd ; done 
```

## Get all namespaced scoped managed resource definitions

```shell
kubectl get mrd --no-headers -o name | grep .aws.m.upbound.io
kubectl get crd --no-headers -o name | grep .aws.m.upbound.io
```
