# Tips

## Delete all evicted pods

```shell
kubectl get pods --all-namespaces | awk '/Evicted/ {print "kubectl delete po -n ",$1,$2}'|bash -x  
```

## Get the current cluster

```shell
kubectl config view --minify -o jsonpath='{.clusters[].cluster.server}'
```

## get all images

```shell
kubectl get pods --all-namespaces -o jsonpath="{.items[*].spec.containers[*].image}" |
    tr -s '[[:space:]]' '\n' |
    sort |
    uniq -c
```
