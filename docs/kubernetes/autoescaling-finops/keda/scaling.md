# Autoscaling

## What kuberenetes resources can keda scale

Keda can scale reources like:

- Deployments

- Statefulsets

- Custom Resources via ScaleTargetRef

KEDA can scale any Kubernetes resource that implements the /scale subresource such as Rollout, from Argo Rollouts.

## Caching metrics

pending

## Autoscaling Phases

- Activation/Desactivation phase

Here, the KEDA operator decides if the workload need to be scaled from zero to 1 or from 1 to zero.
This phase defines where the sacler is active.

> If spec.minReplicaCount is >= 1, the scaler is always active and the activation value will be ignored.

- Scaling phase

This phase scales from 1 to N or from N to 1. It defines the final Horizontal Pod Autoscaler to be created with the proper settings.
