# External secret

At argocd-cm level

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
data:
  resource.customizations.ignoreDifferences.external-secrets.io_ExternalSecret:
    |
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
