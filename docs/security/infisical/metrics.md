# Metrics

## Prometheus metrics

In order to enable the infisical prometheus metrics we must add the following environment variables to the infisical pod

```txt
OTEL_TELEMETRY_COLLECTION_ENABLED: "true"
OTEL_EXPORT_TYPE: "prometheus"
```

> This enables the metrics in the port 9464 and /metrics path

### Relevant metrics

- API latency

```txt
API_latency_bucket
API_latency_count
API_latency_sum
```

- Http server duration:

Measures the duration of inbound HTTP requests

```txt
http_server_duration_bucket
http_server_duration_count
http_server_duration_sum
```

### Some tips

- If you have an old infisical version you must probably need to update to get the metrics
- The helm chart currently does not support adding the environment variables and pod's port. The environment variables can be provided via the infisical-secrets secret.

<https://github.com/Infisical/infisical/issues/3382>
