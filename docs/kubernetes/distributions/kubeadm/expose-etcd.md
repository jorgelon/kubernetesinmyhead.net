# Change listen address in etcd

In a non ha deployment, the etcd metrics listens in 127.0.0.1:2381 by default.

If we want to change to 0.0.0.0:2381 we need to change the kubeadm-config ConfigMap

```shell
kubectl edit cm kubeadm-config -n kube-system
```

And leave the etcd section this way

```yaml
apiVersion: v1
data:
  ClusterConfiguration: |
    etcd:
      local:
        dataDir: /var/lib/etcd
        extraArgs: 
          listen-metrics-urls: http://0.0.0.0:2381
kind: ConfigMap
metadata:
  name: kubeadm-config
  namespace: kube-system
```

And upgrade all the master nodes

```shell
kubeadm upgrade node --dry-run
kubeadm upgrade node
```

Check with

```shell
kubectl describe pod -l component=etcd
```
