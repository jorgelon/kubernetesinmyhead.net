# Tips

## Multiple triggers

KEDA allows you to use multiple triggers as part of the same ScaledObject or ScaledJob.

By doing this, your autoscaling becomes better:

- All your autoscaling rules are in one place
- You will not have multiple ScaledObject’s or ScaledJob’s interfering with each other

KEDA will start scaling as soon as when one of the triggers meets the criteria. Horizontal Pod Autoscaler (HPA) will calculate metrics for every scaler and use the highest desired replica count to scale the workload to.

## HPA and keda

We recommend not to combine using KEDA’s ScaledObject with a Horizontal Pod Autoscaler (HPA) to scale the same workload.

They will compete with each other resulting given KEDA uses Horizontal Pod Autoscaler (HPA) under the hood and will result in odd scaling behavior.

If you are using a Horizontal Pod Autoscaler (HPA) to scale on CPU and/or memory, we recommend using the CPU scaler & Memory scaler scalers instead.
