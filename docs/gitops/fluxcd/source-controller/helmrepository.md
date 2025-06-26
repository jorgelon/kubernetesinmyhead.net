# HelmRepository

There are 2 HelmRepository types

## Helm HTTP/S repository

Defines a Source to produce an Artifact for a Helm repository index YAML (index.yaml)

## OCI Helm repository

Defines a source that does not produce an Artifact. It’s a data container to store the information about the OCI repository that can be used by HelmChart to access OCI Helm charts.

> Because of that, an oci helm repository dont have ready or status

## Configuration

We can configure some options about the repository

- the url (spec.url) and type between default or oci (spec.type)
- the credentials, if needed (spec.secretRef and spec.passCredentials)
- The client certificates (spec.certSecretRef)

For default repositories

- the checkout frequency (spec.interval)

For oci repositories

- If we want permit non-tls connections to an oci repository (spec.insecure)
- The oci provider, between aws, azure, gcp or generic (spec.provider)

And about the operations

- the timeout (spec.timeout)
- if we want to stop the reconciliation (spec.suspend)

More info here

<https://fluxcd.io/flux/components/source/helmrepositories/>

and the spec here

<https://fluxcd.io/flux/components/source/api/v1/#source.toolkit.fluxcd.io/v1.HelmRepository>
