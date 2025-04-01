# Vmware harbor auth

This recipe permits to create string to authenticate against the vmware harbor api

```txt
 -H 'authorization: Basic THIS_WILL_BE_CREATED'
```

Recipe, using the list, join and b64enc sprig functions

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
        auth: '{{ list .username .password | join ":" | b64enc }}'
  secretStoreRef:
    ...
```
