# Tips

## Recover admin password

If we cannot login with our admin user, we can_

generate a new one with

```shell
argocd account bcrypt --password DESIRED-PASSWORD | base64 -w0 && echo
```

And put that string in the argocd-secret secret

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: argocd-secret
data:
  accounts.administrator.password: RESULTING-STRING
```
