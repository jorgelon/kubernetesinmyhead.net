# Cilium

At argocd-cm level

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
data:
  resource.exclusions: |
    - apiGroups: 
      - cilium.io
      kinds:
      - CiliumIdentity
      clusters:
      - "*"
```

At application level

```yaml
      ignoreDifferences:
        - group: ""
          kind: ConfigMap
          name: hubble-ca-cert
          jsonPointers:
          - /data/ca.crt
        - group: ""
          kind: Secret
          name: hubble-relay-client-certs
          jsonPointers:
          - /data/ca.crt
          - /data/tls.crt
          - /data/tls.key
        - group: ""
          kind: Secret
          name: hubble-server-certs
          jsonPointers:
          - /data/ca.crt
          - /data/tls.crt
          - /data/tls.key
        - group: ""
          kind: Secret
          name: cilium-ca
          jsonPointers:
          - /data/ca.crt
          - /data/ca.key
```

More info here

<https://docs.cilium.io/en/latest/configuration/argocd-issues/>
