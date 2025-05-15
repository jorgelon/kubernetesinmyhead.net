# Tips

## Extract crds

This tool extracts all CRDs from a kubernetes cluster and it writes the discovered json schemas in a local directory

<https://github.com/datreeio/CRDs-catalog/releases/latest/download/crd-extractor.zip>

## Tools to validate manifests

- kubeconform

```shell
kubectl kustomize . | kubeconform -schema-location default -schema-location '<https://raw.githubusercontent.com/datreeio/CRDs-catalog/main/{{.Group}}/{{.ResourceKind}}_{{.ResourceAPIVersion}}.json>' -verbose
```

- datree

```shell
datree test /path/to/file
```

- kubeval

```shell
kubeval --additional-schema-locations file:"/home/jorge.phiguera@bosonit.local/.datree/crdSchemas" /path/to/file
```
