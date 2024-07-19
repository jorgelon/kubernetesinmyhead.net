# Change default admin credentials

Recommended by ArgoCD
"As soon as additional users are created it is recommended to disable admin user"

## Login with the default admin credentials

Get the value of the default admin password

```shell
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode; echo
```

Login to argocd with admin and that password using, for example, port-forward

```shell
kubectl -n argocd port-forward svc/argocd-server 9191:443
```

then go to <http://localhost:9191>

or via grpcweb

```shell
argocd login --grpc-web "fqdn of the server"
```

## Change the default admin password (optional)

Change the password to the desired one in the "user info" section. Logout and try to access with the new one.

or use

```shell
argocd account update-password
```

Delete the original password

```shell
kubectl -n argocd delete secret argocd-initial-admin-secret
```

## New user

### Creation

Create a new user with this lines in the argocd-cm configmap

```txt
accounts.newuser: login
accounts.newuser.enabled: "true"
```

### Assign password

Update the password

```shell
argocd account update-password --account newuser
```

### Make it admin role

Add it as administrator

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-rbac-cm
  namespace: argocd
data:
  policy.default: ''
  policy.csv: |
    ...
    g, newuser, role:admin

```

And try to access with that credentials

## Disable admin

In the argocd-cm configmap add this line

```txt
admin.enabled: "false"
```

And test you cannot login with admin account
