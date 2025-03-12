# Crossplane

At application level

```yaml
      ignoreDifferences:
      - group: apps
        kind: Deployment
        jqPathExpressions: 
          - .spec.template.spec.containers[].env[].valueFrom.resourceFieldRef.divisor
          - .spec.template.spec.initContainers[].env[].valueFrom.resourceFieldRef.divisor
```
