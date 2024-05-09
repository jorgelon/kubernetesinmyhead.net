# Perlas

## No installed keys could decrypt the message

Despues de actualizar una version, en los logs de los pods del daemonset se ven errores del tipo

```txt
memberlist: failed to receive: No installed keys could decrypt the message from=XXX.XXX.XXX.XXX:36946
```

Solution

```shell
kubectl delete pods -n metallb-system --all
```

Despues de actualizar

```txt
memberlist join successfully
```
