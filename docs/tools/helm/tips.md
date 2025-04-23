# Tips

## Keep a resource

Add the following annotation to keep a resource when helm uninstall is done

```yaml
  annotations:
    helm.sh/resource-policy: keep
```
