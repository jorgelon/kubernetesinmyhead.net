# Tips

## Incorrect values in kubectl top

If we have incorrect and very high values using "kubectl top" we are probably getting the same values twice:

- From kubelet /metrics/resource
- From kubelet /metrics/cadvisor

"This is because container_cpu_usage_seconds_total and container_memory_working_set_bytes used there are exposed by both endpoints, resulting in double counting. Therefore, you will need to take measures such as assigning a metrics_path label using relabel_configs and narrowing it down to one.

As an alternative solution to avoid using /metrics/resource, you could follow the approach mentioned here(I used it). However, in that case, you'll need Prometheus Node Exporter, and you'll also need to assign node names to node label using relabel_configs.

More info at:

<https://github.com/kubernetes-sigs/prometheus-adapter/issues/639>

> Another option is that we can have more that one service being matched by the kubelet service monitor
