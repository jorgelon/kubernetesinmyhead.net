# Metrics types

Prometheus offer 4 core metric types

## Counter

A counter is a prometheus metric that represents a numeric value that can increase (cumulative) o be reset to zero on restart.

## Gauge

A gauge is a a prometheus metric that represents a numeric value that can increase o decrease.

## Histogram

An histogram is a prometheus metric that permits to see the evolution of a metric.

### Buckets

Histograms count observations in predefined buckets. Each bucket represents a range of values. Histogram buckets are useful for understanding the performance and latency of web services by providing a detailed breakdown of request durations.

```txt
<basename>_bucket{le="<upper inclusive bound>"}
```

This example tells asks for HTTP requests that had a duration of 0.1 seconds or less.

```promql
http_request_duration_seconds_bucket{le="0.1"}
```

### Sum of Observations

Histograms also keep a sum of all observed values, which can be used to calculate the average

```txt
<basename>_sum
```

This example is tracking the total sum of the durations of all HTTP requests in seconds

```promql
http_request_duration_seconds_sum
```

### Cumulative Counts

Histograms maintain a cumulative count of observations for each bucket. The count of events that have been observed

```txt
<basename>_count
```

or

```txt
<basename>_bucket{le="+Inf"}
```

> The le stands for "less than or equal to," and "+Inf" (positive infinity) means that this bucket includes all HTTP requests, regardless of their duration.

Lets see this example

```promql
http_request_duration_seconds_bucket{le="+Inf"}
http_request_duration_seconds_count
```

The metric name http_request_duration_seconds_count indicates that it is tracking the total number of HTTP requests that have been observed.

> It is useful for calculating the average request duration when combined with the corresponding sum metric (http_request_duration_seconds_sum). For example, dividing the sum of durations by the count gives the average duration of an HTTP request.

This gives the average duration of etcd commits called by backend

```promql
etcd_disk_backend_commit_duration_seconds_sum/etcd_disk_backend_commit_duration_seconds_count
```

## Summary

pending

## Links

- Metrics types
  
<https://prometheus.io/docs/concepts/metric_types/>

- Histograms and summaries

<https://prometheus.io/docs/practices/histograms/>
