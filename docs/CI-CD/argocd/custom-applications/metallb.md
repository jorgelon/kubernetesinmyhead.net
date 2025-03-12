# Metallb

At application level

```yaml
      ignoreDifferences:
      - group: "apiextensions.k8s.io"
        kind: CustomResourceDefinition
        name: bgppeers.metallb.io
        jsonPointers:
        - /spec/conversion/webhook/clientConfig/caBundle
      - group: "apiextensions.k8s.io"
        kind: CustomResourceDefinition
        name: addresspools.metallb.io
        jsonPointers:
        - /spec/conversion/webhook/clientConfig/caBundle
```

More info at

<https://github.com/metallb/metallb/issues/1681>
