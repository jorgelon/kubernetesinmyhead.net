# Kyverno and policy reporter

At argocd-cm level

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-cm
data:
  resource.exclusions: |
    - apiGroups:
        - kyverno.io
      kinds:
        - AdmissionReport
        - BackgroundScanReport
        - ClusterAdmissionReport
        - ClusterBackgroundScanReport
      clusters:
        - '*'
    - apiGroups:
        - wgpolicyk8s.io
      kinds:
        - ClusterPolicyReport
        - PolicyReport
      clusters:
        - '*'
```

More info about

<https://kyverno.io/docs/installation/platform-notes/>
