# Change default admin credentials

Recommended by ArgoCD
"As soon as additional users are created it is recommended to disable admin user"

## Change default admin password

Get the value of the default admin password

```shell
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode; echo
```

Login to argocd with admin and that password using, for example, port-forward

```shell
kubectl -n argocd port-forward svc/argocd-server 8080:443
```

And change the password to the desired one in the "user info" section. Logout and try to access with the new one.

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

Login via url, for example

```shell
argocd login --grpc-web myargocd.instance.com
```

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
