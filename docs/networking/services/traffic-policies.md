# Kubernetes Service Traffic Policies

## Overview

Traffic policies in Kubernetes Services control how traffic is routed to pods through kube-proxy. Understanding `externalTrafficPolicy` and `internalTrafficPolicy` is crucial when using LoadBalancer or NodePort services, especially in on-premise environments.

## externalTrafficPolicy

Describes how nodes distribute service traffic they receive on **externally-facing addresses (NodePorts, ExternalIPs, and LoadBalancer IPs)**. This field does NOT apply to traffic from within the cluster destined to LoadBalancer or ExternalIP—such traffic always uses `Cluster` semantics.

### externalTrafficPolicy Cluster (Default)

With externalTrafficPolicy Cluster, kube-proxy sends the traffic to any pod in the cluster matched by the service.

> Here the client source IP is masqueraded (hidden)

**Advantages:**

- Better load distribution across all pods
- No traffic concentration on specific nodes
- Works with any pod placement strategy

**Disadvantages:**

- Additional network hop (latency)
- Client source IP is not preserved
- Breaks internal pod-to-external-IP communication (pods cannot reach the service's external LoadBalancer IP)

**Use case:** External clients connecting to your service

### externalTrafficPolicy Local

Here the externalTrafficPolicy Local, each node delivers traffic only to node-local endpoints without masquerading the client source IP. Traffic mistakenly sent to a node with no endpoints is dropped (not forwarded).

**How it works:**

- Node receives traffic and only proxies to pods on the same node
- Client source IP is preserved
- Assumes external load balancers will balance traffic between nodes
- If a node has no local endpoints, traffic is dropped (not redirected)

**Advantages:**

- Preserves client source IP (visible to pods)
- Lower latency (no cross-node network hop)
- Better performance (minimal proxying)
- Internal pods CAN reach the service's external IP

**Disadvantages:**

- Uneven load distribution
- Traffic concentrates on nodes where pods are running
- Dropped traffic if receiving node has no local endpoints
- Requires external load balancer intelligence
- Doesn't work well with single-replica deployments on unscheduled nodes

**Use case:** On-premise environments, performance-critical services, source IP preservation, or with external load balancers that understand node topology

## internalTrafficPolicy

Describes how nodes distribute service traffic they receive **on the ClusterIP**. Controls pod-to-service communication within the cluster. Only applies to traffic destined to the ClusterIP; similar logic applies to NodePort access from within the cluster.

### internalTrafficPolicy Cluster (Default)

Routes internal traffic to all ready endpoints in the cluster evenly. Pods can reach any service endpoint regardless of node location.

### internalTrafficPolicyLocal

Routes traffic only to node-local endpoints. Reduces cross-node traffic and improves latency for latency-sensitive applications. Requires at least one endpoint per node for reliability. Works with ClusterIP, NodePort, and LoadBalancer services.

## Internal Cluster Access to External IP

When a pod calls an ExternalIP, the request doesn't actually travel out to the Physical Load Balancer and back in.

- The Linux networking stack (via kube-proxy) intercepts the packet as soon as it leaves the pod.
- kube-proxy sees the destination is an ExternalIP that it "owns."
- It immediately applies the routing rules defined by your externalTrafficPolicy right there on the source node.

**With externalTrafficPolicy local if there are not pods in the same node where the call is done, the traffic is dropped**. A best practice here is to use the internal service: `my-service.namespace.svc.cluster.local`

The behaviour tries to avoid

- routing loops: If the node sent the packet out to the Load Balancer, and the Load Balancer sent it right back to the same node (which can happen), you would create an infinite loop
- hairpinning: Most Cloud Provider Load Balancers are not designed to handle "hairpin" traffic (traffic originating from one of its own targets and coming back to itself).

## Load Balancer Responsibilities

### Cluster Mode

**What the load balancer must do:**

- Distribute traffic to ANY node in the cluster
- Doesn't need to know which nodes have service endpoints
- All traffic reaching any node is handled by kube-proxy and forwarded to correct endpoints

**Best for:** Cloud environments where load balancer has no visibility into cluster topology

### Local Mode

**What the load balancer must do:**

- Discover which nodes have endpoints for the service (via health checks or endpoint watcher)
- Only send traffic to nodes that actually have service endpoints
- Remove nodes from the load balancer pool if they have no endpoints
- Monitor endpoint changes and update pool membership

**Requirements:**

- Load balancer must support endpoint-aware routing
- Requires integration with cluster (health check endpoint, endpoint discovery, or controller)

**Load Balancer Support:**

- **MetalLB:** Speaker daemon announces service endpoints via BGP/ARP
- **AWS NLB:**
  - **Instance target type:** Native support for `Local` via NodePort health checks
  - **IP target type:** Direct pod routing; `Local` may not be effective (recommended: use `Cluster`)
- **Azure LB:** Integrated with AKS, automatic endpoint tracking per node
- **GCP LB:** Native support via Network Endpoint Groups (NEGs)
- **F5/Citrix/HAProxy:** Requires external controller integration

**Best for:** On-premise environments with sophisticated load balancers, or cloud providers with native integration

## Recommendations

### externalTrafficPolicy Selection

| Scenario                                | Recommended |
|-----------------------------------------|-------------|
| Public cloud (auto-scaling, many nodes) | `Cluster`   |
| On-premise (fixed node topology)        | `Local`     |
| Internal pod-to-external-IP needed      | `Cluster`   |
| Source IP preservation critical         | `Local`     |
| Performance critical (lower latency)    | `Local`     |

### internalTrafficPolicy Selection

| Scenario                       | Recommended                                 |
|--------------------------------|---------------------------------------------|
| Standard pod communication     | `Cluster` (default)                         |
| Reduce cross-node traffic      | `Local`                                     |
| Topology-aware routing desired | Consider `trafficDistribution: PreferClose` |
| Zone-local deployments         | `Local` + multi-zone pods                   |

## Links

- [Kubernetes Service - externalTrafficPolicy](https://kubernetes.io/docs/concepts/services-networking/service/#external-traffic-policy)
- [Kubernetes Service - internalTrafficPolicy](https://kubernetes.io/docs/concepts/services-networking/service/#internal-traffic-policy)
- [Kubernetes Service API Reference](https://kubernetes.io/docs/reference/kubernetes-api/service-resources/service-v1/)
