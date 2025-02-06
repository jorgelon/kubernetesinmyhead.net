# Scheduling

In kubernetes we can define some settings to limit where a pod can be scheduled, and this affects karpenter.

## Resources (requests and limits)

It is a kubernetes best practice to define in our workload **correct values for CPU/Memory requests and limits**. In Karpenter scenarios this particularly important.

In terms of karpenter scheduling, the important setting here is the **CPU/Memory request value**, because if a pod does not have a node where to be deployed, it will be in "Pending" state, triggering a new nodeclaim.

But it is a karpenter best practice to **give the memory request and limit the same value** to avoid (OOM) conditions in situations where some pods can exceed their requests and the same time. For example, during a consolidation or a simply drain.

## Restrict nodes

There are some ways to restrict the nodes where the pods can be scheduled.

- nodeSelector is the simplest way, using node labels in the definition of the pods.

- affinity is for more complex situations we can use affinity in pods. Here we can use nodeAffinity, podAffinity and podAntiAffinity.

- taints and tolerations. Here we define taints in the nodes. Then we define tolerations at pod level to permit them.

- topologySpreadConstraints permits to control de distribution of pods in your cluster using.

>Karpenter supports the following topologyKey(s):  
>
>- topology.kubernetes.io/zone  
>- kubernetes.io/hostname  
>- karpenter.sh/capacity-type  

For more information visit the folling links

## Links

- Scheduling

<https://karpenter.sh/docs/concepts/scheduling/>

- Karpenter Best practices

<https://docs.aws.amazon.com/eks/latest/best-practices/karpenter.html>

- Pod Scheduling API
  
<https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#scheduling>
