# Increase

The "increase" function must be used with

- counters (floats and histograms)
- range vector

This function calculates if a counter has increased in the time series in the range vector.

This example calculates if http_requests_total counter has increased during the last 5 minutes

```txt
increase(http_requests_total{job="api-server"}[5m])
```

if we want to trigger an alert we can use

```txt
increase(http_requests_total{job="api-server"}[5m]) > 0
```

increase acts on histogram samples by calculating a new histogram where each component (sum and count of observations, buckets) is the increase between the respective component in the first and last native histogram in v. However, each element in v that contains a mix of float samples and histogram samples within the range, will be omitted from the result vector, flagged by a warn-level annotation.

increase should only be used with counters (for both floats and histograms). It is syntactic sugar for rate(v) multiplied by the number of seconds under the specified time range window, and should be used primarily for human readability. Use rate in recording rules so that increases are tracked consistently on a per-second basis.
