# Prometheus Query Language

PromQL is a query language to select and aggregate time series data in real time.

## Simple query

We can ask for a literal metric

```promql
http_requests_total
```

or filtering with labels

```txt
http_requests_total{job="prometheus"}
```

We can match the strings in different ways

```txt
=: Select labels that are exactly equal to the provided string.
!=: Select labels that are not equal to the provided string.
=~: Select labels that regex-match the provided string.
!~: Select labels that do not regex-match the provided string.
```

- An empty label will match the time series that don't have that label

```txt
container_cpu_usage_seconds_total{pod=""}
```

- If we add multiple matches, all of them must pass

```txt
http_requests_total{job="prometheus",group="canary"}
```

- The "__name__" labels can be used by match different metrics by name

## Range Vector Selectors with []

We can specify how many seconds back in time values should be fetched adding [number] at the end.

This selects all http_requests_total samples from the last 5 minutes where the job label is prometheus.

```txt
http_requests_total{job="prometheus"}[5m]
```

## Offset modifier

## @ modifier

## Links

<https://prometheus.io/docs/prometheus/latest/querying/basics/>
<https://prometheus.io/docs/prometheus/latest/querying/operators/>
<https://prometheus.io/docs/prometheus/latest/querying/functions/>
