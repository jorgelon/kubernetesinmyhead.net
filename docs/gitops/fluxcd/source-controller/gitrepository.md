
# GitRepository

It produces an artifact for a git repository revision. This is a tarball artifact with the fetched data.

When defining a GitRepository, we can specify some options

## Repo settings

We can configure

- the url of the repository (spec.url)
- the proxy, if needed (spec.proxySecretRef)
- the credentials, if needed (spec.secretRef)
- the provider. It can be generic(default), github or azure (spec.provider)

## What to include in the tarball

- sparseCheckout

With spec.sparseCheckout we can specify a list of directories we want to be the only included in the tarball

- ignore

With spec.ignore we can we can specify a list of directories that they will be excluded in the tarball
Use with caution because there is default exclusion list

## Checkout (spec.ref)

- the commit sha
- the name of the reference
- a SemVer tag expression
- a tag
- a branch (default master)

What takes precedecens follows this order

```txt
commit > name > semver > tag > branch
```

## Repo operations

- the checkout frequency (spec.interval)
- the timeout (spec.timeout)
- if we want to stop the reconciliation (spec.suspend)
- if we want to verify the commit (spec.verify)
- if we want to initialize and fetch all Git submodules recursively when cloning the repository (spec.recurseSubmodules)
- if we want to include artifacts from another GitRepository (spec.include)

More info here

<https://fluxcd.io/flux/components/source/gitrepositories/>

and the spec here

<https://fluxcd.io/flux/components/source/api/v1/#source.toolkit.fluxcd.io/v1.GitRepository>
