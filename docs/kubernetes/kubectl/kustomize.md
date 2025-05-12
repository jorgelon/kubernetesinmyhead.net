# Kustomize

## Patches without target

```yaml
resources:
  - original.yaml
patches:
  - path: mypatch.yaml
```

Using patches without target section, 4 fields must match between the original manifiest and the patch

- apiVersion
- kind
- metadata.name
- metadata.namespace, if it is specified in the original manifiest

If this not matches, we will get the **find unique target for patch** error

## Escape / character using patches

We must change / with ~1 characters

```yaml
- op: add
  path: "/metadata/annotations/traefik.ingress.kubernetes.io~1redirect-permanent"
  value: false
```
<https://github.com/kubernetes-sigs/kustomize/issues/1256>
