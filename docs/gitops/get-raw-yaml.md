# Ways to get a raw yaml

## From kustomize

If using kustomize based specifications, we can use

```shell
kustomize build
kubectl kustomize
```

## From helm

If using native helm, we can use

```shell
helm template
```

If using helmCharts inside a kustomization yaml, we wan use

```shell
kustomize build --enable-helm
kubectl kustomize --enable-helm
```

<https://kubectl.docs.kubernetes.io/references/kustomize/kustomization/helmcharts/>

> It has some limitations and it will be deprecated in favour of KRM functions

<https://github.com/kubernetes-sigs/kustomize/issues/4401>

## Using KRM (kpt) functions

KRM functions are pluggable, reusable scripts or containers that automate the transformation, validation, and generation of Kubernetes YAML resources, enabling powerful and flexible configuration workflows.

However, support in kustomize and kubectl kustomize is still experimental or alpha, and may not be recommended for production use yet. The ecosystem is growing, but you should check the documentation and maturity of the specific tool and function you plan to use.

<https://kpt.dev/book/02-concepts/03-functions>

## Gitops

### From an argocd applcation

We can use

```shell
argocd app manifest <app-name>
```

### Fluxcd

FluxCD’s source-controller can fetch and output raw manifests from Git, Helm, or OCI sources.
