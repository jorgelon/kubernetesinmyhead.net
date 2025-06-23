# Memory requests and limits

## Recommendations

- The values need regular observation to see the baseline memory usage and spikes
- Always use memory limits
- If you want overprovisioning, add memory requests to a level slightly above the average baseline memory usage and add memory limits to absorbe spikes.
- If not, always set your memory requests equal to your limits to a level to absorbe spikes.
- Use Horizontal pod autoescaler for workloads with replicas
- Investigate to use vertical pod autoescaling in workloads without replicas

Example:

- Observed Peak: 2000Mi
- Observed Baseline: 1000Mi
- Request with Overprovision: 1100Mi
- Limit: 2300Mi or greater

## Links

- Kubernetes OOM and CPU Throttling

<https://sysdig.com/blog/troubleshoot-kubernetes-oom/>

- What Everyone Should Know About Kubernetes Memory Limits, OOMKilled Pods, and Pizza Parties

<https://home.robusta.dev/blog/kubernetes-memory-limit>
