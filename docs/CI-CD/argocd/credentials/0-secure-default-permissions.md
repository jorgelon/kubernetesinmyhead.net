# Secure default argocd permissions

## Change default admin password

### Get the value of the default admin password

```shell
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode; echo
```

### Login to argocd

Via port forwarding and web ui

```shell
kubectl -n argocd port-forward svc/argocd-server 9191:443
```

then go to <http://localhost:9191>

via grpcweb

```shell
argocd login --grpc-web "fqdn of the server"
```

### Change the default admin password (optional)

- Via web ui

Change the password to the desired one in the "user info" section. Logout and try to access with the new one.

- Via argocd cli

```shell
argocd account update-password
```

### Delete the original secret

```shell
kubectl -n argocd delete secret argocd-initial-admin-secret
```

## Change default rbac policy

With this setting in the argocd-rbac-cm ConfigMap. With this, users can login but without permissions. We need to give permissions via rbac

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-rbac-cm
  namespace: argocd
data:
  policy.default: ""
```

> Consider to add a new admin user
