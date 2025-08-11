# CPU requests and limits

## Units

The CPU requests and limits can be specified in some formats:

- Using a number, with or without decimals
- Using milicores / milicpu (a cpu capacity / 1000)

> For values less that 1 CPU, it is recommended to use the milicpu format and not the decimal format

```yaml
resources:
    requests:
    cpu: 2 # 2 CPU
```

```yaml
resources:
    requests:
    cpu: 0.5 # Half CPU
```

```yaml
resources:
    requests:
    cpu: "200m" # 200 milicores = 0.2
```

> If we define a cpu limit but not a CPU request, kubernetes gives both the same value.

## CPU request

Giving a CPU request to a kubernetes container has some implications:

- Scheduling:

Kube scheduler will assign that pod to a node that has that CPU resources as available. If no node has that resources the pod will be in Pending state until they new resources are available.

- Guarantee:

Once the container is up in the node, that CPU resources will be guaranteed.

- Weight in CPU contention:

The requested CPU will be used during CPU contention situations in the node. Containers with higher CPU requests will have higher priority accesing the node CPU.

Este maximo de cpu que puede lograr vendra dado por la capacidad del nodo o, si el container tiene cpu limit, por dicho limite.

- HPA

That value will be used in the CPU horizontal pod autoescaler

## CPU limit

The CPU limit in kubernetes is controlled by the linux kernel and the Completely Fair Scheduler (CFS).

It can be defined as **the maximum CPU time a container can use every in a CPU cycle interval**

The CPU limit is translated to the CFS as the **cpu_quota_us** setting, and the cycle interval as the **cpu_period_us**

> The default cpu_period_us is 100 ms

So a container with 200m as limit, cannot use more than 200 milicpu at every 100 miliseconds.

Using CPU limits has some implications:

- Protecting other containers

Ensures a container cannot use too much resources and affect others

- CPU throttling

CPU under kubernetes is a compressible resource. When a container reaches that quota, it will have to wait to the next period (100 ms) to try to access to the CPU resources.
This affects the performance and latency in the container and unwanted an uncontrolled situations can appear, like readiness or liveness probe failures.

- Underutilization

Also, the node can have free CPU resources available, but they are not accesible by the limited container (**underused**)
Not using CPU limits permits a better use of the CPU node resources

## Some thougts and best practices

- Always define CPU requests. This also avoids the qos class besteffort

- In order to define a good value it is very important to have access to metrics about cpu consumption. Utilities like Goldilocks (vpa) o Robusta KRR can give recommendations.

- Using CPU limits gives more importance to protect the nodes and other containers during high CPU usage and to having a controlled environment.

- Some people recommends not using CPU limits and only use good CPU request values. It can also be disabled at kubelet level using cpuCFSQuota=0.

- For pods that can have more that 1 replicas it can be useful to use horizontal pod autoescaler or Keda

- For pods with only 1 replica,  it can be useful to use vertical pod autoescaling

- In some environments can be a good practice to change the cpu_period_us

## Links

- Resource Management for Pods and Containers  

<https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/>

- Assign CPU Resources to Containers and Pods  

<https://kubernetes.io/docs/tasks/configure-pod-container/assign-cpu-resource/>

- Pod Overhead  

<https://kubernetes.io/docs/concepts/scheduling-eviction/pod-overhead/>

- For the Love of God, Stop Using CPU Limits on Kubernetes  

<https://home.robusta.dev/blog/stop-using-cpu-limits>

- For the love of god, learn when to use CPU limits on Kubernetes  

<https://medium.com/@eliran89c/for-the-love-of-god-learn-when-to-use-cpu-limits-on-kubernetes-2225341e9dbd>

- Why You Should Keep Using CPU Limits on Kubernetes  

<https://dnastacio.medium.com/why-you-should-keep-using-cpu-limits-on-kubernetes-60c4e50dfc61>

- Kubernetes resources under the hood – Part 1  

<https://directeam.io/blog/kubernetes-resources-under-the-hood-part-1/>

- Kubernetes resources under the hood – Part 2  

<https://directeam.io/blog/kubernetes-resources-under-the-hood-part-2/>

- Kubernetes resources under the hood – Part 3  

<https://directeam.io/blog/kubernetes-resources-under-the-hood-part-3/>

- CPU Limits in Kubernetes: Why Your Pod is Idle but Still Throttled: A Deep Dive into What Really Happens from K8s to Linux Kernel and Cgroups v2

<https://www.reddit.com/r/kubernetes/comments/1k28c00/cpu_limits_in_kubernetes_why_your_pod_is_idle_but/>

### Tools

- Kube capacity  
<https://github.com/robscott/kube-capacity>

- Robusta KRR  
<https://github.com/robusta-dev/krr>

- Goldilocks  
<https://github.com/FairwindsOps/goldilocks>
