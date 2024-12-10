# Argocd Tips

## Treat some/thing as string in jsonPointers

We want to exclude a path like this using ignoreDifferences and jsonPointers

```txt
/spec/template/metadata/annotations/checksum/secret-jobservice
```

But the key to exclude is checksum/secret-jobservice and not secret-jobservice inside checksum

For this we must escape th "/" with "~1"

```yaml
      ignoreDifferences:
        - group: apps
          kind: Deployment
          name: harbor-core
          jsonPointers:
            - /spec/template/metadata/annotations/checksum~1secret-jobservice
```
