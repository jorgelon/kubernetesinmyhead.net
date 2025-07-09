# Observatility Tool

## Ecosystems

| Ecosystem     | Metrics       | Collector    | Traces  | Collector        | Logs | Collector    | Dashboard | Enterprise                         |
|---------------|---------------|--------------|---------|------------------|------|--------------|-----------|------------------------------------|
| Opentelemetry |               | OT Collector |         | OT Collector     |      | OT Collector |           |                                    |
| Grafana       | G.Mimir       | Alloy        | G.Tempo | Alloy / Beyla    | Loki | Alloy        | Grafana   | Grafana Cloud / Grafana Enterprise |
| Prometheus    | Prometheus    |              |         |                  |      |              |           |                                    |
| Elasticsearch | Elasticsearch |              |         |                  |      |              | Kibana    | Elastic Cloud                      |
| Jaeger        |               |              |         | Jaeger Collector |      |              | Jaeger UI |                                    |

## Log collectors

- Logstash

It is the logs collector from the Elasticsearch ecosystem

- Opentelemetry collector

Thel opentelemetry collector can act as a log collector

- Grafana Alloy

It is the new name of the Grafana Agent, an Opentelemetry collector distribution from the grafana ecosystem. It also replaces Grafana Promtail.

- Fluentbit and fluentd

Both are well known logs collector. Fluentbit is lightweight and simpler.

- Vector

Vector is the collector from datadog
