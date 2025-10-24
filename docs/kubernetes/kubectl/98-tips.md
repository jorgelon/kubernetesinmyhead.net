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

## Get etcd status

```shell
ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key  -w table endpoint health
ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key  -w table endpoint status
ETCDCTL_API=3 etcdctl --endpoints=https://127.0.0.1:2379 --cacert=/etc/kubernetes/pki/etcd/ca.crt --cert=/etc/kubernetes/pki/etcd/server.crt --key=/etc/kubernetes/pki/etcd/server.key  -w table member list
```
