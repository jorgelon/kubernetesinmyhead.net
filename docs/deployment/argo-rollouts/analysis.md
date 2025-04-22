# Analysis

Analysis is argo workflows are tests that can be launched in a kubernetes cluster, typically inside a Rollout or using Kargo promotions, but they can be used without referencing them in that applications

That analysis make some queries to systems like prometheus, Datadog,... Also supports web queries and executing a kubernetes job.

We can template that analysis using AnalysisTemplate or ClusterAnalysisTemplate kubernetes resources. And they are instanciated via an AnalysisRun resource.

## Analysis Spec

When defining an AnalysisTemplate, ClusterAnalysisTemplate or AnalysisRun we have this fields

## spec.metrics

This is where we define the queries|tests|measurements via the following fields

- **name**

The name we give to the test, query or measurement

- **provider**

It includes the query|test itself and provider configuration. There are some supported providers like prometheus, Datadog, CloudWatch, InfluxDB, Web, Job, Graphite,...

- **initialDelay**

It adds a delay to the test execution. Example: 30s, 5m,...

- **count and interval**

Count is the number of times we want to repeat the test, query or measurement and interval is the time to wait between tests. Example: 15s

### **Test, query or measurement result**

The query|test|measurement itself is done against a provider, and we can consider it as successful or failed with the **SuccessCondition and failureCondition** settings.

Sometimes the query|test|measurement cannot be evaluated as successful or failed and they are considered as an **inconclusive** result. This could happen due to missing data, timeouts, or other issues that prevent the metric from being evaluated.
One example of how analysis runs could become Inconclusive, is when a metric defines no success or failure conditions. They also can

### Handling Success results

**consecutiveSuccessLimit** define the required consecutive number of successes to consider the analysis to succeed

> consecutiveSuccessLimit default value is 0 (disabled) and it is available since v1.8 release

### Handling Error results

- With **failureLimit** we can define the maximum number of test errors we want to tolerate.

> The default value of failureLimit is 0 so no failures are tolerated. To disable we can set it to "-1".
> failureLimit has precedence over consecutiveSuccessLimit. Also failureLimit or consecutiveSuccessLimit are not reached, the test (measurement) is considered as inconclusive.

- **consecutiveErrorLimit** defines the maximum number of consecutive errors that are allowed for a metric before the analysis is considered to have failed.

### Handling inconclusive results

**InconclusiveLimit** sets a threshold for how many inconclusive results are acceptable during an analysis. If the number of inconclusive results exceeds this limit, the analysis is marked as failed.
If inconclusiveLimit is not specified, the default behavior is to allow unlimited inconclusive results, meaning the analysis will not fail due to inconclusive results

### Example

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AnalysisRun
metadata:
  generateName: test-
  namespace: argocd
spec:
  metrics:
    - name: argocd-app-health-sync  # name of the measurement
      initialDelay: 30s # wait 30 seconds to start doing queries
      count: 15 # 15 times
      interval: 10s # every 10 seconds. Mix this when the metric is updated
      provider:
        prometheus:
          address: "http://prometheus-operated.monitoring:9090"
          query: |
            argocd_app_info{name="my-argocd-app",health_status="Healthy", sync_status="Synced"}
      successCondition: len(result) == 1 && result[0] == 1  # only 1 result with value 1
      failureCondition: len(result) == 0 || result[0] != 1 # empty array or result not 1
      failureLimit: 3 # tolerate 3 errors max
      consecutiveErrorLimit: 3 # tolerate 3 consecutive errors max
      consecutiveSuccessLimit: 8 # its ok with 8 consecutiveSuccessLimit
      inconclusiveLimit: 2 # tolerate 2 inconclusive results
```

## spec.args

Inside a template we can define arguments

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AnalysisTemplate
metadata:
  name: mytemplate
spec:
  args:
  - name: service-name
  - name: prometheus-port
```

And they can used later as variables in the query

```txt
{{args.service-name}}
{{args.prometheus-port}}"
```

## spec.ttlStrategy

ttlStrategy permits to control the the lifetime of an analysis run and delete them after a period of time. If this field is unset, the analysis controller will not delete them and they must be deleted manually or via other garbage collection policies (e.g. successfulRunHistoryLimit and unsuccessfulRunHistoryLimit).

```yaml
apiVersion: argoproj.io/v1alpha1
kind: AnalysisRun
spec:
  ...
  ttlStrategy:
    secondsAfterCompletion: 3600
    secondsAfterSuccess: 1800
    secondsAfterFailure: 1800
```

## spec.terminate

pending

## spec.measurementRetention

pending

## spec.dryRun

pending

## Links

- Analysis & Progressive Delivery

<https://argoproj.github.io/argo-rollouts/features/analysis/>

- Argo Rollouts FAQ

<https://argoproj.github.io/argo-rollouts/FAQ/>

- Kargo Analysis Templates Reference

<https://docs.kargo.io/user-guide/reference-docs/analysis-templates/>
