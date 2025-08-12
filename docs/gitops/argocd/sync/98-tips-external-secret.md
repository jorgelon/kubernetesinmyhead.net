
# External-secret OutOfSync

Sometimes we can get an argocd Application OutOfSync because an external-secret is OutOfSync with some differences in this places:

- conversionStrategy
- decodingStrategy
- decodingStrategy

... and we did not define that values.

The root cause is that External Secrets Operator acts as a mutating admission controller, modifying resources after they're applied. It adds default values for conversionStrategy, decodingStrategy, and metadataPolicy fields when they're not explicitly specified in the ExternalSecret manifest. This creates a drift between your Git source (without these fields) and the live cluster state (with default values added), causing ArgoCD to show the resources as OutOfSync

## Solution 1: ignoreDifferences

We can ignore that fields at controller level. This is not the best option because we are ignoring some fields in the resource.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
data:
  resource.customizations.ignoreDifferences.external-secrets.io_ExternalSecret: |
      jqPathExpressions:
      - '.spec.data[]?.remoteRef.conversionStrategy'
      - '.spec.data[]?.remoteRef.decodingStrategy'
      - '.spec.data[]?.remoteRef.metadataPolicy'
      - '.spec.dataFrom[]?.extract.conversionStrategy'
      - '.spec.dataFrom[]?.extract.decodingStrategy'
      - '.spec.dataFrom[]?.extract.metadataPolicy'
      - '.spec.dataFrom[]?.find.conversionStrategy'
      - '.spec.dataFrom[]?.find.decodingStrategy'
      - '.spec.dataFrom[]?.find.metadataPolicy'
```

This can also be configured at Application level with spec.ignoreDifferences. It must be configured in all drifted Applications

We also neeed to ignore that differences when syncing

```yaml
apiVersion: external-secrets.io/v1
kind: ExternalSecret
metadata:
  annotations:
    argocd.argoproj.io/sync-options: RespectIgnoreDifferences=true
```

## Solution 2: add default values

Another option is to add to the external-secret the default values the external secret operator adds. For example

```yaml
apiVersion: external-secrets.io/v1
kind: ExternalSecret
spec:
  data:
  - secretKey: mykey
    remoteRef:
      key: mykey
      conversionStrategy: Default
      decodingStrategy: None
      metadataPolicy: None
```

## Solution 3: use Server Side Apply

Another option is to use Server Side Apply. With this:

- ArgoCD declares ownership of only the fields it manages
- Other controllers can own and modify their own fields (like external secrets operator)
- Kubernetes merges changes from multiple sources without conflicts

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  annotations:
    argocd.argoproj.io/sync-options: ServerSideApply=true
spec:
  ...
```

> Note: I did not make this work for now.
