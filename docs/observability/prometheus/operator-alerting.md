# Prometheus operator and alerting

## Configure the prometheus resource

| Section                              | Explanation                                                       |
|--------------------------------------|-------------------------------------------------------------------|
| spec.alerting                        | Configure the alertmanager endpoints to send the alerts           |

There are a lot of other prometheus and kubernetes settings we can configure (replicas, retention, persistent storage, resources,...)

## Setup the alertmanager resource

This will deploy an alertmanager statefulset and its settings

- metadata.namespace

pending

- metadata.labels

pending

### Alertmanager configuration

There are 3 ways to configure alertmanager

- spec.configSecret  

With this we can choose a Kubernetes secret that contains a native alertmanager configuration (global) in the alertmanager.yaml key.

```shell
kubectl create secret generic myalertmanagerconfig --from-file=alertmanager.yaml=myfile.yaml
```

And in the alertmanager resource

```yaml
apiVersion: monitoring.coreos.com/v1
kind: Alertmanager
metadata:
  name: myalertmanager
spec:
  configSecret: myalertmanagerconfig
```

> The default value is alertmanager-name_of-the_alertmanager_instance. If the alertmanager.yaml key does not exist or a secret is not defined, a default configuration will deployed dropping alert notifications.

- spec.alertmanagerConfiguration  

Experimental feature that takes precedence over the configSecret field as a global configuration. We can choose an alertmanagerconfig kubernetes resource.

```yaml
apiVersion: monitoring.coreos.com/v1
kind: Alertmanager
metadata:
  name: myalertmanager
spec:
  alertmanagerConfiguration:
    name: myalertmanagerconfig
```

- spec.alertmanagerConfigSelector

Choose what labels should have an alertmanagerconfig resource to be selected for to merge and configure Alertmanager with.

```yaml
apiVersion: monitoring.coreos.com/v1
kind: Alertmanager
metadata:
  name: myalertmanager
spec:
  alertmanagerConfigSelector:
    matchLabels:
      mylabel: myvalue
```

- spec.alertmanagerConfigNamespaceSelector

Choose in what namespaces search for alertmanagerconfig resources to be selected for to merge and configure Alertmanager with.

- spec.alertmanagerConfigMatcherStrategy

pending

## Setup the alertmanagerconfig resource

pending

## Setup the prometheusrule resources

pending

## Links

- Prometheus: Alerting overwiew

<https://prometheus.io/docs/alerting/latest/overview/>

- Prometheus: Alerting rules

<https://prometheus.io/docs/prometheus/latest/configuration/alerting_rules/>

- Prometheus Operator: Alerting Routes

<https://prometheus-operator.dev/docs/developer/alerting/>

- Why does alertmanagerconfigs automatically add a namespace matcher

<https://github.com/prometheus-operator/prometheus-operator/discussions/3733>
