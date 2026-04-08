# LoadBalancer services

## How LoadBalancer services in IONOS managed kubernetes

In IONOS LoadBalancer services, the platform **assigns a public IP as a
secondary IP to one worker node**. That node acts as the entry point and
`kube-proxy` routes traffic to the target pods.

> This works using **"externalTrafficPolicy: Cluster"**

IONOS can assign the public IP automatically (dynamic) or use one you
pre-reserved (static).

- **Dynamic**: IONOS assigns one automatically; it is released when the
  service is deleted
- **Static**: set `loadBalancerIP` on the service with a predeployed ip
  address; the IP persists even if the service is deleted

If you have **external-dns** deployed (with any supported DNS provider),
dynamic IPs are viable: external-dns watches the
`status.loadBalancer.ingress` field on Services and automatically creates
or updates DNS records whenever IONOS assigns an IP. The remaining risk is
operational — if the service is accidentally deleted, the IP is released
and DNS will not resolve until external-dns processes the new IP after
recreation.

### Limitations

- LoadBalancer services in IONOS managed kubernetes are only supported in
  **Public Node Pools**.
- The public interfaces are limited to 2 Gbit/s throughput

### Architecture decisions

- Do we want to deploy the gateway with a replica or more in separate
  nodes (HA)
- In multi replica gateway, do we also want to scale the traffic beyond
  the 2 Gbit/s limitation?

## Preserve source ip

If we want to preserve the original source ip via
**externalTrafficPolicy: Local** service we must ensure the nodes that
will receive the traffic will have pods of our service. If not, the
traffic will be dropped. These are 2 options to achieve that

### The Daemonset approach

Deploying our workload using a Daemonset will ensure a pod of our service
will be available in every node. But it has some cons:

- Resource consumption. Only one pod will be doing the job, where the
  loadbalancer ip is deployed, and the other nodes will have idle
  instances.
- The traffic keeps being limited to ~2 Gbit/s

### Making the Loadbalancer smart

This is a more efficient and complex alternative. We need to tell the
loadbalancer in what nodes our gateway instances are deployed.

- First we must **label the nodes or node pools** that will allocate the
  pods. The label is arbitrary

- Then we must deploy our service related pods **in every labeled node or
  node pool**. We can use things like nodeSelector,
  topologySpreadConstraints or podAntiAffinity.

- Finally we must add the annotation
  `cloud.ionos.com/node-selector: <label>` to the service. This special
  IONOS annotation selects what nodes can receive the LoadBalancer IP

### Scaling via DNS loadbalancing

Every kubernetes node has a limitation of 2 Gbit/s on the public
interface. If we want to scale, for example, to 2 nodes to support 4
theoretical Gbit/s we need to send traffic to 2 pods at the same time.
IONOS suggests to make it via DNS loadbalancing:

- We need 2 LoadBalancer services with dynamic or static ip addresses
  targeting our pods.
- Then create 2 DNS A-records to every assigned IP address
- Make the LoadBalancer smart (see the section) for at least 2 nodes or
  2 nodepools with 1 node

## References

- [Assign static IP address](https://docs.ionos.com/cloud/containers/managed-kubernetes/use-cases/assign-static-ip-address)
- [Horizontal scaling](https://docs.ionos.com/cloud/containers/managed-kubernetes/use-cases/horizontal-scaling)
- [Preserve source IP from internet](https://docs.ionos.com/cloud/containers/managed-kubernetes/use-cases/preserve-source-internet)
- [Assigning Pods To Nodes](https://kubernetes.io/docs/concepts/scheduling-eviction/assign-pod-node/)
