# Deployment using operator

How to deploy a kubernetes cluster using cluster api operator

## Deploy cert-manager

This is a requirement so visit <https://cert-manager.io/>

## Deploy the operator it self

Using the operator-components.yaml file from  <https://github.com/kubernetes-sigs/cluster-api-operator/releases>

This deploys capi-operator-system namespace and the namespaced crds for the providers

- coreprovider
- bootstrap provider
- control plane provider
- infraestucture provider
- ...
