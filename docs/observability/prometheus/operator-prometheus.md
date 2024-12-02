# Define a prometheus resource

This will deploy a prometheus statefulset and its settings

| Section                              | Explanation                                                       |
|--------------------------------------|-------------------------------------------------------------------|
| spec.serviceMonitorSelector          | The serviceMonitor resources with these labels will be discovered |
| spec.serviceMonitorNamespaceSelector | Namespaces where to discover serviceMonitor resources             |
| spec.podMonitorSelector              | The podMonitor resources with these labels will be discovered     |
| spec.podMonitorNamespaceSelector     | Namespaces where to discover podMonitor resources                 |
| spec.probeSelector                   | The probe resources with these labels will be discovered          |
| spec.probeNamespaceSelector          | Namespaces where to discover probe resources                      |
| spec.scrapeConfigSelector            | The scrapeConfig resources with these labels will be discovered   |
| spec.scrapeConfigNamespaceSelector   | Namespaces where to discover scrapeConfig resources               |

## Links

- Prometheus Operator

<https://prometheus-operator.dev/>

- Prometheus Operator Api reference
  
<https://prometheus-operator.dev/docs/api-reference/api/>
