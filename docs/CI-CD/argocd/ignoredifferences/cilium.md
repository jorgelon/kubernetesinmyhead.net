# Cilium

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
