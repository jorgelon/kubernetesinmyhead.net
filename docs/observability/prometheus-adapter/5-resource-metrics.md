# Kubernetes resource metrics

The most simple way to make **horizontal pod autoescaler** and **kubectl top** work is to deploy metrics adapter. But if we want, for example, to use custom metrics with HPA, we need prometheus adapter.

In order to make prometheus adapter the application who provides that functions, we need:

- Deploy metrics adapter deployment

- Create an v1beta1.metrics.k8s.io apiService

- Configure the prometheus adapter (ConfigMap)

## Deployment

We have 2 ways to deploy the prometheus adapter:

- Official manifests

They include the deployment, the v1beta1.metrics.k8s.io apiService and the ConfigMap

<https://github.com/kubernetes-sigs/prometheus-adapter/tree/master/deploy/manifests>

- Helm chart

They include the deployment. To deploy the apiService and the ConfigMap we need to enable the **rules.resource** section in our values.yaml file and enable the APIVersions Capability with "apiregistration.k8s.io/v1" as value.

<https://github.com/prometheus-community/helm-charts/tree/main/charts/prometheus-adapter>

## Configuration

I have found 3 different configurations of the adapter. They are similar but not exactly the same

- From prometheus-adapter github repo

<https://raw.githubusercontent.com/kubernetes-sigs/prometheus-adapter/refs/heads/master/deploy/manifests/config-map.yaml>

- From kube-prometheus

<https://raw.githubusercontent.com/prometheus-operator/kube-prometheus/refs/heads/main/manifests/prometheusAdapter-configMap.yaml>

- From prometheus-community helm chart

In the default values.yaml file from the prometheus-adapter helm chart, we have some commented lines about the resource rules.

<https://raw.githubusercontent.com/prometheus-community/helm-charts/refs/heads/main/charts/prometheus-adapter/values.yaml>
