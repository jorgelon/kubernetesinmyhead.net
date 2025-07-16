# Change admin user

Argocd documentation recommends to disable the admin user.

## New user

First we will create a new user that will have adminpermissions

### Create the new user

To add the user we must add it in the argocd-cm ConfigMap. The user will have login permissions.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
data:
  accounts.myuser: login
  accounts.myuser.enabled: "true"
```

### Make it administrator

There is a predefined role called admin that our user will receive. Will will only remove all default permissions.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-rbac-cm
  namespace: argocd
data:
  policy.default: ""
  policy.csv: |
    g, myuser, role:admin
```

### Assign password

Get the value of the default admin password

```shell
kubectl -n argocd get secret argocd-initial-admin-secret -o jsonpath="{.data.password}" | base64 --decode; echo
```

Login to our argocd instance

```shell
argocd login "fqdn of the server"
```

And change give the new user a password

```shell
argocd account update-password --account myuser --grpc-web
```

Test login with the new user

```shell
argocd logout "fqdn of the server"
argocd login "fqdn of the server"
```

## Disable admin user

Change the default admin password (optional)

```shell
argocd account update-password --account admin --grpc-web
```

Disable the admin user

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
data:
  admin.enabled: "false"
```

And delete delete the original secret

```shell
kubectl -n argocd delete secret argocd-initial-admin-secret
