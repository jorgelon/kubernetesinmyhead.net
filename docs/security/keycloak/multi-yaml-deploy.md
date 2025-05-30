# Deploy multiple operators via yaml

## Provided manifests

Keycloak team offers 3 yaml files:

- The keycloak resource crd
- The keycloakrealmimports crd
- The operator depllyment and other needed resources

## The problems

- The keycloak operator does not support watching the resources it manages created in all namespaces, so the operator must me deployed in every namespace you create that resources.

- Updating the crds must be aligned with every operator instance

- Most of the resources in the operator yaml file are namespaced, but this includes a ClusterRoleBinding binded to the keycloak-operator service account in the keycloak namespace.

```yaml
subjects:
  - kind: ServiceAccount
    name: keycloak-operator
    namespace: keycloak
```

But this gives openshift related permissions, so it can be ignored if you dont use Openshift

```yaml
apiVersion: rbac.authorization.k8s.io/v1
kind: ClusterRole
metadata:
  name: keycloak-operator-clusterrole
rules:
  - apiGroups:
      - config.openshift.io
...
```

## The deployment

So we can do this via kustomize

The operator-crds folder and its kustomization.yaml file

```yaml
resources:
  - https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.2.5/kubernetes/keycloaks.k8s.keycloak.org-v1.yml
  - https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.2.5/kubernetes/keycloakrealmimports.k8s.keycloak.org-v1.yml
```

The operator-base folder and its kustomization.yaml file

```yaml
resources:
  - https://raw.githubusercontent.com/keycloak/keycloak-k8s-resources/26.2.5/kubernetes/kubernetes.yml
```

Our deployment folder and its kustomization.yaml file will deploy the operator in 2 namespaces but the crds once

```yaml
resources:
  - ../operator-crds-folder-location
  - namespace-1
  - namespace-2
```

Inside every namespace folder, we need a kustomization file with a suffix (or prefix). This adds a suffix or prefix to the resource name.

```yaml
nameSuffix: -mysuffix
resources:
  - ../operator-base-folder-location
```

> The ClusterRoleBinding created with our prefix is binded to an unexistant service account, but it is openshift related.

## Update the release

In order to update the release we only need to change the urls in the operator-crds and operator-base folders
