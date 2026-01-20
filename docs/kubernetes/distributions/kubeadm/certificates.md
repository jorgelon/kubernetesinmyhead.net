# Certificates

## Server certificates

They can be checked with

```shell
kubeadm certs check-expiration
```

## admin and super-admin certificates (kubeconfig)

There are 2 kubeconfigs in /etc/kubernetes: admin.conf and super-admin.conf (since kubeadm 1.29).

admin.conf should be the admin kubeconfig to be used. super-admin.conf is designed for emergency scenarios when:

- Regular admin access is broken or compromised
- You need to recover from certificate issues
- RBAC configuration is broken
- You need to bypass admission controllers or other security policies

Both uses system:masters RBAC group but super-admin.conf bypasses admission controllers and it is created for Emergency/recovery only. It should be highly restricted

Both can be renewed via

```shell
kubeadm init phase kubeconfig admin
kubeadm init phase kubeconfig super-admin
```

### the server has asked for the client to provide credentials

This is a typical error showing the admin client certificate expired and it should be renewed via kubeadm

```txt
couldn't get current server API group list: the server has asked for the client to provide credentials
```

## kubernetes control plane certificates

controller-manager, scheduler and kubeconfig related certificates can be updated via kubeadm too
