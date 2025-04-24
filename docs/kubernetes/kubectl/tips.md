# Tips

## Delete all evicted pods

```shell
kubectl get pods --all-namespaces | awk '/Evicted/ {print "kubectl delete po -n ",$1,$2}'|bash -x  
```
