# Labels

The prometheus labels are key-value pairs attached to metrics. They offer additional context, information and metadata to the metrics and permit things like identify, filter and categorize metrics.

Example

```txt
 metric_name{label1="value1", label2="value2"} value
```

## Metric labels

This labels are generated from the application that expose the metrics:

- they are embedded in the metric data itself
- they describe the metric

> They have high cardinality risk

## Target labels

This labels are added during the scraping process. They describe where the metrics came from, not what they represent.

> They have low cardinality risk

### Core Target Label: job

The job label identifies the scrape configuration.

In prometheus operator we can give the job label the value of a kubernetes label from the associated pod. This is done using **spec.jobLabel** in a podmonitor or servicemonitor resource.

### Core Target Label: instance

Instance label is the host and port of the target

More information about Jobs and instances here <https://prometheus.io/docs/concepts/jobs_instances/>

### Internal labels (__)

There are some internal labels (prefixed with __) are temporary labels used by Prometheus during the scraping process. They're not stored with metrics but control how scraping happens.

Examples:

```yaml
__address_ # as the target's original address
__metrics_path__ # as the endpoint path
__scheme__="http" # as the protocol to use
__param_* # as query parameters
__meta_* # Contains discovery metadata
__meta_kubernetes_ # Contains kubernetes discovery metadata
__meta_consul_* # Consul discovery metadata
__meta_ec2_* # EC2 discovery metadata
```

> With Relabeling it is possible to use internal labels to create permanent labels using relabel_configs

There can be other informational labels, not true internal labels so they cannot be used in relabeling

```yaml
__scrape_interval__ # Shows configured interval
__scrape_timeout__ # Shows configured timeout
```

### Sources of Target Labels

Sources of Target Labels can be defined:

- using an static configuration

```yaml
  - job_name: 'api-servers'
    static_configs:
    - targets: ['api1:8080', 'api2:8080']
      labels:
        env: 'production'
        team: 'backend'
```

- using Service Discovery (Kubernetes, Consul, etc.)

```yaml
 - job_name: 'kubernetes-pods'
    kubernetes_sd_configs:
    - role: pod
```

Auto-discovers and adds labels like:

```yaml
  {
    job="kubernetes-pods",
    instance="10.244.0.15:8080",
    __meta_kubernetes_pod_name="webapp-123",
    __meta_kubernetes_namespace="production"
  }
```

- using ServiceMonitor/PodMonitor from prometheus operator

## honorLabels

honorLabels controls how Prometheus handles label conflicts when scraping metrics

  Default behavior (honorLabels: false):

- Prometheus overwrites target labels with its own labels
- Target's job label gets renamed to exported_job
- Target's instance label gets renamed to exported_instance
- Prometheus uses its own job and instance values

  With honorLabels: true:

- Prometheus keeps the target's original labels
- Target's labels take precedence over Prometheus labels
- No renaming happens

```txt
  Example: Target exposes: my_metric{job="custom-job", instance="app-1"}

honorLabels: false (default)
my_metric{job="serviceMonitor/namespace/name", instance="10.0.0.1:8080", exported_job="custom-job", exported_instance="app-1"}

honorLabels: true  
my_metric{job="custom-job", instance="app-1"}
```

Use honorLabels: true:

- When targets provide meaningful job/instance labels
- For federation setups
- When you want to preserve application-defined labels

Common use case: Kubernetes service discovery often uses honorLabels: true to preserve pod labels as metric labels.

## Cardinality risk

Cardinality is the number of unique label combinations for a metric.

The problem is each unique combination creates a separate time series. Prometheus stores each series individually.

Cardinality risk is when you create too many unique time series, causing Prometheus performance and storage problems. It can crash or severely degrade your monitoring system.

High Cardinality Risk is when too many label combinations create too many time series. This can be caused by:

- Unique Identifiers:

```txt
requests{user_id="abc123"}        # millions of users
requests{request_id="xyz789"}     # every request unique
requests{timestamp="1634567890"}  # every second unique
```

- Unbounded Values:

```txt
response_time{url="/user/12345/profile"}  # infinite URLs
errors{error_msg="Connection timeout"}    # many error messages
```

The solutions can be:

- Use Bounded Labels (limited values)

```txt
requests{user_type="premium"}     # premium, basic, free
requests{status_class="4xx"}      # 2xx, 3xx, 4xx, 5xx
```

- Group/Aggregate:

```txt
requests{region="us-east", user_tier="paid"}
```

- Use Histograms for Ranges (instead of exact response times)

```txt
http_request_duration_bucket{le="0.1"}  # predefined buckets
```

### Links

<https://github.com/prometheus-operator/prometheus-operator/issues/3246>

relabelings vs metricRelabelings
