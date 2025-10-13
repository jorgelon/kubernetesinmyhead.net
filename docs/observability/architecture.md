# Architecture

This page outlines a pragmatic, operations-focused view of an observability stack.

## High‑level layers

1. Instrumentation (generation)
   - Application SDKs, auto-instrumentation, exporters emit logs/metrics/traces (L/M/T)
   - Standard protocols: OTLP over gRPC/HTTP; legacy inputs supported via receivers

2. Ingestion/collection
   - Agents/DaemonSets/sidecars and/or a gateway OpenTelemetry Collector receive telemetry
   - Fan‑in from nodes, apps, infrastructure, cloud services

3. Processing/enrichment
   - Pipelines apply sampling, filtering, redaction, resource detection, attribute transforms
   - Batching, retry, timeouts, queueing/backpressure control to stabilize flow
   - Routing by signal/tenant/team to specific backends

4. Export/transport
   - OTLP/gRPC or HTTP to remote backends; TLS/mTLS and auth (API keys, OIDC)
   - Circuit breakers, exponential backoff, persistent queues for resilience

5. Storage backends (by signal)
   - Metrics: Prometheus/Thanos/Mimir, VictoriaMetrics
   - Traces: Tempo/Jaeger/Elastic APM
   - Logs: Loki/Elasticsearch/OpenSearch
   - Sometimes a columnar data lake/warehouse for long‑term retention and cost control

6. Query/visualization & alerting
   - Grafana/Kibana/Tempo/Jaeger UIs; SLOs and alert rules
   - Routing to Alertmanager, PagerDuty, Opsgenie, Slack, email

### Where the OpenTelemetry Collector fits

The OTel Collector spans multiple layers:

- Layer 2 (Ingestion/collection): receivers (otlp, prometheus, filelog, k8s events)
- Layer 3 (Processing/enrichment): processors (batch, memory_limiter, attributes/resource, transform, tail_sampling, routing)
- Layer 4 (Export/transport): exporters (otlp[gRPC/HTTP], prometheusremotewrite, loki, tempo/jaeger), TLS/mTLS, retries/queues

It is not a storage backend or UI (does not cover layers 5 or 6).

## Reference view (Kubernetes + OpenTelemetry)

- Workloads emit OTLP → node/sidecar/agent collector (DaemonSet or sidecar)
- Optional gateway collector (centralized, stateless) → processes and routes signals
- Backends per signal; Grafana on top for dashboards, logs, traces, exemplars

```text
Apps/SDKs ──OTLP──> Node/Sidecar Collector ──OTLP──> Gateway Collector ──> Backends
                                              │                          ├─> Metrics TSDB
                                              │                          ├─> Traces Store
                                              │                          └─> Logs Store
                                              └── kube/system exporters (kube-state, cAdvisor)
```

### Collector deployment patterns

- Sidecar: per‑pod isolation; simplest context propagation; higher overhead
- DaemonSet (agent): per‑node collector for all workloads; good default
- Gateway: centralized fan‑in; enforces org‑wide policy (sampling, PII scrubbing)
  - Common to use Agent (DaemonSet) + Gateway for scale and control

## Signal‑specific notes

- Metrics: prefer low‑cardinality labels; use histograms; remote write to long‑term TSDB
- Traces: sampling strategies (tail‑based at gateway for best value; head‑based at source for low overhead)
- Logs: structure at source (JSON); drop/trim noisy lines early; labels/indices budgeted

## Reliability and cost levers

- Backpressure: memory_limiter + queued_retry processors in OTel Collector
- Batching: reduce connection churn and backend CPU
- Redaction: attributes and body processors for PII/compliance
- Multi‑route: split traffic by environment/tenant to different clusters/backends
- Retention tiers: hot (short), warm (mid), cold (cheap/archival)

## Minimal OTel pipeline (conceptual)

Receivers → processors → exporters, per signal:

```text
receivers: otlp, prometheus, filelog
processors: memory_limiter, batch, attributes(resource), transform, tail_sampling
exporters: otlphttp(tempo), prometheusremotewrite(mimir), loki
```

## Ops best practices

- Start with a single protocol (OTLP) end‑to‑end
- Keep metrics cardinality in check; gate label additions
- Make sampling an explicit decision (prove value, then tune)
- Treat collectors as stateless and horizontally scalable
- Version and test pipelines as code; lint configs; add golden queries/alerts

## See also

- OpenTelemetry Collector: pipelines and processors (receivers → processors → exporters)
- OTLP protocol (gRPC/HTTP)
- Backend options: Mimir/Thanos, Tempo/Jaeger, Loki/Elasticsearch
