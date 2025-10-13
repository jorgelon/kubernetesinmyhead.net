# Kubernetes Events Visibility

Kubernetes events are ephemeral (stored for only 1 hour in etcd). To maintain visibility and enable historical analysis, events need to be exported to an observability backend.

## Solutions for Events Export

### Grafana Alloy (Recommended for Loki)

**Status:** Active - Replacement for deprecated Grafana Agent (EOL Nov 2025)

[Grafana Alloy](https://grafana.com/docs/alloy/) with the `loki.source.kubernetes_events` component tails events from the Kubernetes API and forwards them to Loki.

### kubernetes-event-exporter

**Status:** Active - Maintained by [resmoio](https://github.com/resmoio/kubernetes-event-exporter) (fork of deprecated opsgenie version)

Exports events to multiple destinations: Loki, Elasticsearch, Kafka, Webhooks, etc.

**Bitnami Helm Chart:** `bitnami/kubernetes-event-exporter`

### Fluent Bit

**Status:** Active - Native kubernetes_events input plugin (v3.1+)

Uses Kubernetes watch stream (not polling) to collect events.

**Important:** Must be deployed as a **Deployment with single replica**, NOT as DaemonSet (no leader election).

### Fluentd

**Status:** Active - No native events input plugin

Can output to Loki via `fluent-plugin-grafana-loki`, but requires another tool (like Fluent Bit or Event Exporter) to collect events first.

**Use case:** Events processing pipeline (not collection)

### Logstash + Metricbeat

**Status:** Active - Requires Metricbeat for events collection

Metricbeat has a kubernetes event metricset that collects from the API, then forwards to Logstash for processing.

**Use case:** Elastic stack processing pipeline, not for direct collection

### Data Prepper

**Status:** Active - OpenSearch alternative to Logstash, no native events input

Data Prepper is a server-side data collector for filtering, enriching, and transforming data for OpenSearch. Requires another tool (Fluent Bit, kubernetes-event-exporter, or OTel Collector) to collect events first.

**Use case:** OpenSearch stack processing pipeline, not for direct collection

### OpenTelemetry Collector

**Status:** Active - Vendor-neutral observability data collector with native Kubernetes events receivers

Has two receivers for events collection:

- **k8seventsreceiver** - Dedicated Kubernetes events receiver
- **k8sobjectsreceiver** - General Kubernetes objects receiver (commonly used for events)

Can export to multiple backends: Loki (otlphttp), Elasticsearch, OpenSearch, Prometheus, etc.

**Important:** Deploy as single-replica Deployment (not DaemonSet)

**Helm chart preset:** Use `kubernetesEvents` preset for quick setup

### kube-state-metrics (Prometheus Only)

**Status:** Active

Exposes limited event metrics for Prometheus (not full event details):

- `kube_event_count` - Count of events
- `kube_event_unique_events_total` - Unique events by reason

**Use case:** High-level alerting, not event investigation

## Deprecated Solutions

- **EventRouter** (vmware-archive) - Archived, no longer maintained
- **Grafana Agent** - EOL November 1, 2025, replaced by Grafana Alloy
- **opsgenie/kubernetes-event-exporter** - Deprecated, use resmoio fork

## Best Practices

1. **Use JSON format** - Faster LogQL queries than logfmt
2. **Filter namespaces** - Reduce noise by watching specific namespaces
3. **Store in Loki** - Events are text/structured data, not time-series metrics
4. **Set retention** - Configure Loki retention based on compliance needs
5. **Use labels wisely** - Namespace, type, reason are good labels; avoid pod names (high cardinality)
6. **Single replica deployment** - Deploy Fluent Bit and OTel Collector as Deployment (not DaemonSet) to avoid duplicate event collection

## Recommendation

- **For Loki users**: Use **Grafana Alloy** with `loki.source.kubernetes_events` (recommended) or **Fluent Bit**
- **For vendor-neutral/multi-backend**: Use **OpenTelemetry Collector** (supports Loki, Elasticsearch, OpenSearch, etc.)
- **For multi-destination needs**: Use **resmoio/kubernetes-event-exporter**
- **For Elastic stack**: Use **Metricbeat + Logstash** or **kubernetes-event-exporter**
- **For OpenSearch stack**: Use **OpenTelemetry Collector**, **Fluent Bit + Data Prepper**, or **kubernetes-event-exporter**
- **For Prometheus metrics only**: Use **kube-state-metrics**

## Links

- [Grafana Alloy](https://grafana.com/docs/alloy/latest/)
- [loki.source.kubernetes_events](https://grafana.com/docs/alloy/latest/reference/components/loki/loki.source.kubernetes_events/)
- [resmoio/kubernetes-event-exporter](https://github.com/resmoio/kubernetes-event-exporter)
- [Fluent Bit kubernetes_events](https://docs.fluentbit.io/manual/data-pipeline/inputs/kubernetes-events)
- [Fluent Bit Loki output](https://docs.fluentbit.io/manual/data-pipeline/outputs/loki)
- [Fluent Bit OpenSearch output](https://docs.fluentbit.io/manual/pipeline/outputs/opensearch)
- [OpenTelemetry Collector for Kubernetes](https://opentelemetry.io/docs/platforms/kubernetes/collector/)
- [OTel k8seventsreceiver](https://github.com/open-telemetry/opentelemetry-collector-contrib/blob/main/receiver/k8seventsreceiver/README.md)
- [OTel k8sobjectsreceiver](https://github.com/open-telemetry/opentelemetry-collector-contrib/tree/main/receiver/k8sobjectsreceiver)
- [kube-state-metrics](https://github.com/kubernetes/kube-state-metrics)
- [Metricbeat Kubernetes event metricset](https://www.elastic.co/guide/en/beats/metricbeat/current/metricbeat-metricset-kubernetes-event.html)
- [OpenSearch Data Prepper](https://opensearch.org/docs/latest/data-prepper/)
- [Kubernetes Events API](https://kubernetes.io/docs/reference/kubernetes-api/cluster-resources/event-v1/)
