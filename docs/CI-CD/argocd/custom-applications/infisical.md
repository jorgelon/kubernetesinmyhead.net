# Infisical

At application level

```yaml
      ignoreDifferences:
        - group: apps
          kind: Deployment
          name: infisical
          jsonPointers:
          - /metadata/annotations/updatedAt
          - /spec/template/metadata/annotations
```
