# Tips

## Get all cluster scoped managed resource definitions

```shell
kubectl get mrd --no-headers -o name | grep .aws.upbound.io
```
