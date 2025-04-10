# Tips

## Reduce the secretstore and clustersecretstore calls

By default the controller validates the secretstore and clustersecretstore every 5 minutes
We can change this default behaviour with the **store-requeue-interval** parameter

In the helm chart

```yaml
extraArgs:
  store-requeue-interval: 1h # increase to 1 h
```

Also we can override the controller's default value in the secretstore resource

```yaml
apiVersion: external-secrets.io/v1beta1
kind: SecretStore
metadata:
  name: myss
spec:
  refreshInterval: 30m
```

and clustersecretstore resource

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ClusterSecretStore
metadata:
  name: mycss
spec:
  refreshInterval: 2h
```

## Reduce the externalsecret and clusterexternalsecret calls

pending
