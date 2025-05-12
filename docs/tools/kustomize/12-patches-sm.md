
# Strategic Merge Patch (SMP)

An strategic merge patch is a yaml file or yaml file content that includes the group/version/kind/name of the resource to patch and the desired values

An strategic merge patch is a kubernetes k8s resource that needs to include:

- the group
- the version
- the kind
- the metadata name

## Using a file (path)

add-label.patch.yaml

```yaml
apiVersion: apps/v1
kind: Deployment
metadata:
  name: dummy-app
  labels:
    app.kubernetes.io/version: 1.21.0
```

kustomization.yaml

```yaml
patches:
  - path: add-label.patch.yaml

```

### path without target

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

## Using inline patch

If we want to use the inline option in a SMP, we must provide the content as is

```yaml
...
patches:
  - patch: |-
      apiVersion: apps/v1
      kind: Deployment
      metadata:
        name: dummy-app
        labels:
          app.kubernetes.io/version: 1.21.0
...
```

## Links

- patchStrategicMerge

<https://github.com/kubernetes/community/blob/master/contributors/devel/sig-api-machinery/strategic-merge-patch.md>
