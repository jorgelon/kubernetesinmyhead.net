# Tips

## Add label using Scrape Classes

We can use spec.scrapeClasses to add a global label to all metrics in a prometheus instance

```yaml
apiVersion: monitoring.coreos.com/v1
kind: Prometheus
metadata:
  name: prometheus
spec: 
  scrapeClasses:
    - name: default-cluster
      default: true # this is the default scrape class
      relabelings:
        - action: replace
          targetLabel: mylabel
          replacement: "mydeiredvalue"
```

More info here <https://prometheus-operator.dev/docs/developer/scrapeclass/>

## Job label and Prometheus Operator

A job label is an special prometheus label used by create a logical organization of labels

> When using dashboards, specially 3rd party dashboards, it is very relevant to check if the queries expect a concrete job name. Different dashboards for the same application can require different job names

Using Prometheus operator in kubernetes, the typical way to scrape metrics is using the following resources:

- Servicemonitor
- PodMonitor

In both resources we can use the following key to configure the value of the job label:

```yaml
spec.jobLabel
```

This key offers the possibility to configure the job label value:

- Choosing the value of a label in the matched service
- If we dont use spec.jobLabel or leave it empty, the job label will have the value of the matching service

Example:

We have a service called "myservice" with the label **component: frontend** and we use a Servicemonitor matching this service

- with spec.jobLabel: component, job label will have "frontend" for all scraped metrics
- if we we dont use spec.jobLabel or is it empty, the value of the job label will "myservice"

### Relabeling

Sometimes using spec.jobLabel or leaving empty does not meet our requirements, because we want a value that is not provided by any label or the service name.
In that case we can use relabelings at endpoint level to give the desired value

```yaml
apiVersion: monitoring.coreos.com/v1
kind: ServiceMonitor
metadata:
  name: myservicemonitor
spec:
  endpoints:
    - relabelings:
        - action: replace
          targetLabel: job
          replacement: mydesiredjoblabel
```
