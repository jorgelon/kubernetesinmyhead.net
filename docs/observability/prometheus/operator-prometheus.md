# Prometheus operator instance

This prometheus kubernetes resource will deploy a prometheus statefulset and its settings under "spec"

```yaml
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  name: prometheus
spec:
```

There are some the settings we can configure

## Choose what to discover

The prometheus operator also permits to define some namespaced kubernetes resources like:

- PodMonitor (scrape metrics from a group of pods)
- Probe (how to scrape metrics from prober exporters such as the blackbox exporter)
- PrometheusRule (defines alerting and recording rules)
- ScrapeConfig (currently at Alpha level)
- ServiceMonitor (scrape metrics from a group of services)

We must choose what ServiceMonitors, PodMonitors, Probes and ScrapeConfigs will be related with our prometheus instance. With the following settings we can select by labels the namespaces to discover that resources.

- spec.podMonitorNamespaceSelector
- spec.probeNamespaceSelector
- spec.ruleNamespaceSelector
- spec.scrapeConfigNamespaceSelector
- spec.serviceMonitorNamespaceSelector

> An empty label "{}" selector matches all namespaces

```yaml
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  name: prometheus
spec:
  podMonitorNamespaceSelector: {}
  probeNamespaceSelector: {}
  ruleNamespaceSelector: {}
  scrapeConfigNamespaceSelector: {}
  serviceMonitorNamespaceSelector: {}
```

> A "null" label selector matches the namespace where the prometheus instance has been deployed

Also we can filter by labels in those resources. Only the resources created with that labels defined here will be related with our prometheus instance.

- spec.podMonitorSelector
- spec.probeSelector
- spec.scrapeConfigSelector
- spec.serviceMonitorSelector
- spect.ruleSelector

> Again, an empty label "{}" selector matches all objects. A "null" label selector matches no objects.

## Alertmanager

With spec.alerting.alertmanagers we can define alertmanager endpoints where to send alerts

## Other settings

- spec.version and spec.image

With spec.version we can choose the prometheus release we want to deploy. It is neccesary to ensure the Prometheus Operator knows which version of Prometheus is being configured.
With spec.image we can configure the container image.

The operator itself has a default release for both settings

example:

```yaml
spec:
    image: quay.io/prometheus/prometheus:v3.1.0
    version: v3.1.0
```

- spec.replicas

With spec.replicas we can configure the name of instances we want in our prometheus statefulset. The default number is 1

- spec.storage, spec.volumes and spec.volumeMounts

We can configure the persistence here

- spec.retention and spec.retentionSize

Limit the data will be stored. Retention by date (24h default) and retentionSize by size.

- spec.logLevel and spec.logFormat

We can configure the logformat and change the verbosity of the prometheus and config-reloader containers

- spec.scrapeInterval, spec.scrapeTimeout and spec.scrapeProtocols

- spec.externalUrl

If we want to expose prometheus, for example, via ingress, we must configure this to generate correct URLs

- spec.resources

Tune the kubernetes requests and limits of the prometheus instance

- spec.priorityClassName

Give a priorityclass to the prometheus pods
