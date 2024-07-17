# Metrics documentation for apps

## Cilium

To enable the service monitors and metrics for the agent and the operator in the values.yaml file

```yaml
# Enable the agent metrics
prometheus:
  enabled: true
  serviceMonitor:
    enabled: true
    labels:
      theprometheus: label
# To enable the operator metrics
operator:
  prometheus:
    enabled: true
    serviceMonitor:
      enabled: true
      labels:
        theprometheus: label
```

> You can also enable more additional metrics and servicemonitor for hubble, hubble relay, clustermesh and envoy

- Monitoring & Metrics  
<https://docs.cilium.io/en/stable/observability/metrics/>

- Running Prometheus & Grafana  
<https://docs.cilium.io/en/stable/observability/grafana/>

- Example dashboards  
<https://github.com/cilium/cilium/tree/main/install/kubernetes/cilium/files/cilium-agent/dashboards>  
<https://github.com/cilium/cilium/tree/main/install/kubernetes/cilium/files/cilium-operator/dashboards>  
<https://github.com/cilium/cilium/tree/main/install/kubernetes/cilium/files/hubble/dashboards>  

## External secrets

- Metrics docs  
<https://external-secrets.io/latest/api/metrics/>

- Official dashboard  
<https://raw.githubusercontent.com/external-secrets/external-secrets/main/docs/snippets/dashboard.json>

## Karpenter

- Metrics docs  
<https://karpenter.sh/docs/reference/metrics/>  

- Example dashboards
<https://github.com/aws/karpenter-provider-aws/tree/main/website/content/en/preview/getting-started/getting-started-with-karpenter>

## Argocd

- Metrics docs  
<https://argo-cd.readthedocs.io/en/stable/operator-manual/metrics/>

- Example dashboard  
<https://github.com/argoproj/argo-cd/blob/master/examples/dashboard.json>

## Argo Workflows

- Metrics docs  
<https://argo-workflows.readthedocs.io/en/latest/metrics/>

- Official dashboard  
<https://grafana.com/grafana/dashboards/20348-argo-workflows-metrics/>

## Cert Manager

- Metrics docs  
<https://cert-manager.io/docs/devops-tips/prometheus-metrics/>

- Dashboards and more in the mixin project  
<https://gitlab.com/uneeq-oss/cert-manager-mixin>

## Quarkus metrics

- Metrics docs  
<https://es.quarkus.io/guides/telemetry-micrometer>

## Kured

- Metrics docs  
<https://kured.dev/docs/configuration/>

## Cloud native pg

- Metrics docs  
<https://cloudnative-pg.io/documentation/1.23/monitoring/>

- Official Dashboard  
<https://github.com/cloudnative-pg/grafana-dashboards/blob/main/charts/cluster/grafana-dashboard.json>

## Grafana Loki

Enable the service monitor in the helm chart and disable dashboards and self monitoring

```yaml
monitoring:
  serviceMonitor:
    enabled: true
    labels:
      theprometheus: label
  dashboards:
    enabled: false
  selfMonitoring:
    enabled: false
```
