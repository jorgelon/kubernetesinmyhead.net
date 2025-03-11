# Create a dockerconfigjson

## Using user, password and url

With this template we can create an external secret to pull images from a private repository if we have the username, password and url stored in our secret store.
The important thing here is the template. The data section can be different for every secret store.

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: privatepull
spec:
  data:
  - remoteRef:
      key: PULL-APPS-U
    secretKey: username
  - remoteRef:
      key: PULL-APPS-P
    secretKey: password
  - remoteRef:
      key: PULL-APPS-URL
    secretKey: url
  secretStoreRef:
    kind: SecretStore
    name: mystore
  target:
    template:
      data:
        .dockerconfigjson: |
          {
            "auths": {
              "{{ .url  }}": {
                "username": "{{ .username }}",
                "password": "{{ .password }}",
                "email": ""
              }
            }
          }
      type: kubernetes.io/dockerconfigjson
```

## Using the base64

pending
