# Pod readiness gate

There is a very useful setting we can easily enable to increase the high availability in our aws load balancer controller exposed pods. This feature i called Pod readiness gate.

## Explanation

Imagine we have a pod exposed to the internet using AWS Load Balancer Controller. For example:

- Using ALB and ingress annotations
- Using NLB and service annotations

There is race condition when a deployment is restarted between:

- the pod is restarted and becomes Ready
- the pod is registered as target in the load balancer

This settings injects an status in the pod that indicates if the pod is registered in the load balancer as target what avoid considering it as Ready until it can receive traffic. So the pod will not be Ready until it is registered

> This only works for loadbalancers where the target group has **ip as target-type**

## Enabling

To enable it we must only label the namespace where the exposed ports are with this:

```txt
elbv2.k8s.aws/pod-readiness-gate-inject: enabled
```

Then, we need to restart the pods

To check if it works, the pods must start with this new status.condition

```txt
target-health.elbv2.k8s.aws
```

False: when it is being registered
True: it is registered as target

## Links

- Pod readiness gate

<https://kubernetes-sigs.github.io/aws-load-balancer-controller/latest/deploy/pod_readiness_gate/>
