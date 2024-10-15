# Vertical por autoescaling

In the context of Vertical Pod Autoscaling (VPA) in Kubernetes, the terms lower bound, target, uncapped target, and upper bound refer to the recommendations provided by the VPA for setting the resource requests for pods. These recommendations are calculated based on historical usage data, current resource requests, and limits defined in the pod's specification. Here's what each term means:

## Recommendations

### Lower Bound

This is the minimum amount of resources the VPA recommends for the pod to function correctly based on its observed resource usage. Setting the resource requests below this value might lead to insufficient resources for the pod, potentially causing performance issues or even failures

### Target

This is the VPA's recommendation for the resource requests that should be set for the pod to ensure optimal performance under normal workload conditions. The target value is calculated based on the pod's historical resource usage, aiming to balance resource efficiency with sufficient headroom for typical workload variations

### Uncapped Target

The uncapped target is similar to the target but without considering the resource limits set on the pod. This value represents what the VPA calculates the pod needs based on its usage, without being constrained by the current resource limits. If the uncapped target is higher than the upper bound (i.e., the current limit), it indicates that the pod's performance might be constrained by its resource limits

### Upper Bound

This is the maximum amount of resources the VPA believes the pod might need under peak conditions observed during the analysis period. Setting the resource requests or limits at or above this value should ensure that the pod has enough resources to handle spikes in workload without being throttled or running out of resources
