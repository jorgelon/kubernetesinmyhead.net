# Updates

First update to the latest patch release of the current installed major version
Next update to latest patch releaes of the next major version

## From 0.15.X to 0.16.X

Some breaking changes

- Removal of Conversion Webhooks and SecretStore/v1alpha1, ExternalSecret/v1alpha1 and their cluster counterparts
- Promotion of ExternalSecret/v1 and SecretStore/v1 and their cluster counterparts
- Removal of v1 templating engine

Check if you can upgrade

```shell
kubectl get crd \
    externalsecrets.external-secrets.io\
    secretstores.external-secrets.io\
    clustersecretstores.external-secrets.io\
    clusterexternalsecrets.external-secrets.io\
    -o jsonpath='{.items[*].status.storedVersions[?(@=="v1alpha1")]}' | \
    grep -q v1alpha1 && echo "NOT SAFE! REMOVE v1alpha1 FROM YOUR STORED VERSIONS" || echo "Safe to Continue"
```

If you get this error

```txt
conversion webhook for external-secrets.io/v1, Kind=ExternalSecret failed: the server could not find the requested resource
```

Simply force a refresh in an external secret from that cluster external secret

```shell
kubectl annotate externalsecrets.external-secrets.io MYCES force-sync=$(date +%s) --overwrite
```

- Promoting to 0.16 #4662

<https://github.com/external-secrets/external-secrets/issues/4662>

## From 0.16.X to 0.17.X

Breaking change

- v0.17.0 Stops serving v1beta1 apis

So it is needed to update the manifests v1beta1 to v1 prior to updating from v0.16 to v0.17. We need at least v0.16.2 because it supports v1.

```bash
#!/bin/bash

echo "Searching apiVersion: external-secrets.io/v1 in yaml files"
echo "############### Showing alpha references ###############"
grep --recursive --include="*.yaml" "apiVersion: external-secrets.io/v1alpha"
echo

echo "############### Showing beta references ###############"
echo
grep --recursive --include="*.yaml" "apiVersion: external-secrets.io/v1beta"

echo "############### Showing non alpha or beta references ###############"
echo
grep --recursive --include="*.yaml" "apiVersion: external-secrets.io/v1" | grep -v "v1alpha" | grep -v "v1beta"
```

```bash
#!/bin/bash
echo "Changing all v1beta1 references to v1"
find . \( -name "*.yaml" -o -name "*.yml" \) -print0 | while IFS= read -r -d '' yaml_file; do
    if grep "apiVersion: external-secrets.io/v1beta1" "$yaml_file" >/dev/null; then
        echo "Changing v1beta1 to v1 in $yaml_file"
        sed -i 's/apiVersion: external-secrets.io\/v1beta1/apiVersion: external-secrets.io\/v1/g' "$yaml_file"
    fi
done
```
