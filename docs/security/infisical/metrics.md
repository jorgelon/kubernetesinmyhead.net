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
API_latency_count
API_latency_sum
API_latency_bucket
```

- Http server duration:

Measures the duration of inbound HTTP requests

```txt
http_server_duration_count
http_server_duration_sum
http_server_duration_bucket
```

```txt
API_errors_count
```

API_errors_count tracks the total number of errors that occurred for the specified route, method, and error type.

```txt
API_errors_sum
```

API_errors_sum tracks the cumulative value of the errors.

```txt
API_errors_bucket
```

API_errors_bucket is an histogram that measures the distribution of errors over different time buckets (latency or duration). Each bucket represents the number of errors that occurred within a specific time range (e.g., less than or equal to 5ms, 10ms, etc.).
Labels:
route: The API route (/api/v3/secrets/raw).
method: The HTTP method (GET).
type: The type of error (RateLimitError).
name: The specific error name (RateLimitExceeded).
le: The upper bound of the bucket (e.g., 5ms, 10ms, etc.).

### Some tips

- If you have an old infisical version you must probably need to update to get the metrics
- The helm chart currently does not support adding the environment variables and pod's port. The environment variables can be provided via the infisical-secrets secret.

<https://github.com/Infisical/infisical/issues/3382>
