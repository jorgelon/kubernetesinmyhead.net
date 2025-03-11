# Create a tls secret

If we have uploaded a certificate and private key, to our secret manager, we can create a tls kubernetes secret

## In aws secrets manager

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: tls-aws-secrets-mamager
spec:
  template:
    type: kubernetes.io/tls
    data:
        - remoteRef:
            decodingStrategy: Base64 # if the value is in base64
            key: my-aws-secret # name of the aws secret
            property: tls.crt # key inside the aws secret
        secretKey: tls.crt # key we want in the secret
        - remoteRef:
            decodingStrategy: Base64 # if the value is in base64
            key: my-aws-secret # name of the aws secret
            property: tls.key  # key inside the aws secret
        secretKey: tls.key # key we want in the secret
  secretStoreRef:
    kind: SecretStore
    name: mystore # it can be a ClusterSecretStore 
```
