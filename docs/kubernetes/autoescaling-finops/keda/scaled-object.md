# Scaled Object

## spec.scaleTargetRef

pending

## spec.triggers

Here we can define one or more triggers that can activate the autoescaling

## Replicas and fallback

We can control the replicas we want with this settings

### spec.minReplicaCount

The desired min replicas.

If the scaledobject has only cpu/memory triggers, minReplicaCount 0 is not permitted

> The default value is 0

### spec.maxReplicaCount

This will be spec.maxReplicas in the hpa and it is the maximum number of replicas of the target resource

> The default value is 100

### spec.idleReplicaCount

With this setting we can define the number of replicas to scale the target resource to when there is no activity detected by the triggers, but before scaling all the way down to zero.

Allows you to keep a minimum number of "idle" replicas running when there is no activity, instead of scaling directly to zero.

This is an optional setting.

- If not specified, it is ignored
- The only supported value is 0 (<https://github.com/kedacore/keda/issues/2314>) so it effectively behaves the same as scaling to zero.
- Must be less than minReplicaCount

### spec.fallback

This is an optional setting that permits to configure a default behaviour when an scaler fails getting metrics from the source.

> It only supports scalers whose target is an **AverageValue** metric (cpu/memory not supported) and **ScaledObjects** (not ScaledJobs)

Here we can define:

- spec.fallback.failureThreshold

As the number of failures needed to start the fallback

- spec.fallback.replicas

The desired replicas in fallback

- spec.fallback.behavior

The desired behaviour. There are some options here (static, currentReplicas, currentReplicasIfHigher and currentReplicasIfLower)

## Behaviour

### spec.pollingInterval

This field defines the interval to check each trigger, in seconds, to determine if scaling actions are needed.

> The default value (if not specified) is 30

When the deployment or other workload is at 0 replicas, KEDA will check the triggers every seconds defined in spec.pollingInterval. The polling interval is controlled by KEDA.

When the deployment is running (with replicas), the HPA

A lower value makes KEDA checks more frequently and react faster, but increases API calls/load
A higher value makes KEDA checks less frequently with an slower reaction, but less load

When scaling from 0 to 1, KEDA will poll for a metric value every pollingInterval seconds while the number of replicas is 0

> While scaling from 1 to N, this value is controlled by the horizontal-pod-autoscaler-sync-period parameter in the kube-controller-manager

### Cooldown

- spec.cooldownPeriod

It applies when scaling to 0 and when scaling to the minReplicaCount. KEDA waits for the cooldownPeriod after the last trigger reported active before scaling the resource down.

Prevents rapid scale-downs by introducing a delay after the last scaling activity.
Useful for workloads that may have intermittent spikes, ensuring that resources are not scaled down too quickly after a burst of activity.

> It is an optional setting with default value 300 (5 minutes)

- spec.initialCooldownPeriod

This is the time to wait to scale after the initial creation of the ScaledObject.

Prevents immediate scale-downs right after deployment or KEDA startup, giving the workload time to stabilize and process initial events. Useful for workloads that need a warm-up period or to avoid premature scaling down due to delayed metrics or triggers.

> It is an optional setting with default value 0, so no wait.

### Advanced

spec.advanced.scalingModifiers
spec.advanced.restoreToOriginalReplicaCount
spec.advanced.horizontalPodAutoscalerConfig

### Pause an scaled object

It is possible to pause the autoescaling adding this 2 annotations to an ScaledObject.

```yaml
autoscaling.keda.sh/paused: "true"
autoscaling.keda.sh/paused-replicas: "0"
```

If paused-replicas = 0, the hpa is deleted
If paused-replicas = NUMBER, the hpa has minReplicas and maxReplicas = NUMBER

To restart autoescaling, we only need to remove the annotations.

## Links

- Scaling Deployments, StatefulSets & Custom Resources

<https://keda.sh/docs/2.17/concepts/scaling-deployments/>

- ScaledObject specification

<https://keda.sh/docs/latest/reference/scaledobject-spec/>
