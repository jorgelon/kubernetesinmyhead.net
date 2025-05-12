# Jsonpatch (RFC 6902)

A jsonpatch is a json file or json file content that includes the desired changes to apply to a kubernetes resource

A jsonpatch can do almost everything a patchStrategicMerge can do, but with a briefer syntax

## Using a file (path)

ingress_patch.json

```json
[
  {"op": "replace",
   "path": "/spec/rules/0/host",
   "value": "foo.bar.io"},

  {"op": "replace",
   "path": "/spec/rules/0/http/paths/0/backend/servicePort",
   "value": 80},

  {"op": "add",
   "path": "/spec/rules/0/http/paths/1",
   "value": { "path": "/healthz", "backend": {"servicePort":7700} }}
]
```

kustomization.yaml

```yaml
patches:
- path: ingress_patch.json
  target:
    group: networking.k8s.io
    version: v1beta1
    kind: Ingress
    name: my-ingress
```

## Using inline patch

If we want to use the inline option in a json6902 patch, we must provide it this way.

"op" can be "add", "replace", or "remove".

```yaml
patches:
  - patch: |-
      - op: replace
        path: /spec/template/spec/containers/0/image
        value: nginx:1.21.0      
```

## Special characters

The ~ character is used as an escape character

## ~0

In Kustomize, "~0" typically refers to a special path indicating the current directory where the kustomization.yaml file is located. This is a shorthand for referencing files within the same directory as the Kustomization configuration. It's commonly used for defining paths to base Kubernetes manifests or patches that Kustomize will use to customize and deploy resources

~0 represents a ~ character itself.

## ~1

In Kustomize, "~1" represents a backslash, which is used to escape characters in a string. When used in a path, it means to include a forward slash ("/"). So, "~1" translates to "/" in Kustomize paths.

```yaml
patches:
  - patch: |-
      - op: add
        path: /metadata/labels/app.kubernetes.io~1version
        value: 1.21.0    
```

<https://github.com/kubernetes-sigs/kustomize/issues/1256>
<https://github.com/kubernetes-sigs/kustomize/issues/907>

## Notes

> In the standard JSON merge patch, JSON objects are always merged but lists are always replaced

## Links

- jsonpatch.com

<https://jsonpatch.com/>

- JavaScript Object Notation (JSON) Patch  RFC 6902

<https://datatracker.ietf.org/doc/html/rfc6902>

## JSON6902
