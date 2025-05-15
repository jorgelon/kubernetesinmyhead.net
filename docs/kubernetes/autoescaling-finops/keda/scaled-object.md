# Scaled Object

## Behaviour

### spec.pollingInterval

This field defines the interval to check each trigger, in seconds, to determine if scaling actions are needed.

> The default value (if not specified) is 30

When the deployment or other workload is at 0 replicas, KEDA will check the triggers every seconds defined in spec.pollingInterval. The polling interval is controlled by KEDA.

When the deployment is running (with replicas), the HPA

A lower value makes KEDA checks more frequently and react faster, but increases API calls/load
A higher value makes KEDA checks less frequently with an slower reaction, but less load

When scaling from 0 to 1

### spec.cooldownPeriod

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

This is an optional setting.

- If not specified, it is ignored
- The only supported value is 0
- Must be less than minReplicaCount

When there is no activity

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

## spec.scaleTargetRef

pending

## Links

- Scaling Deployments, StatefulSets & Custom Resources

<https://keda.sh/docs/2.17/concepts/scaling-deployments/>

- ScaledObject specification

<https://keda.sh/docs/latest/reference/scaledobject-spec/>
