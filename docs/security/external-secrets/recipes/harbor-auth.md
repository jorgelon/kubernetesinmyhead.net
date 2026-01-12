# Vmware harbor auth

This recipe creates the Authorization header using the username and password

> The spec.data section changes depending of the secret store provider

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: harbor-credentials
spec:
  data:
    - remoteRef:
        key: secret/harbor-credentials-u
      secretKey: username
    - remoteRef:
        key: secret/harbor-credentialsr-p
      secretKey: password
  target:
    template:
      data:
        auth: '{{ printf "Basic %s" (printf "%s:%s" .username .password | b64enc) }}'
  secretStoreRef:
    ...
```
