# Network policies

The kubernetes network policies control the traffic that enters and leaves the pod.

> The network policy api v1 is stable since kubernetes 1.7 (2017)

```yaml
apiVersion: networking.k8s.io/v1
kind: NetworkPolicy
metadata:
  name: my-network-policy
spec:
```

## Key concepts

- By default, all traffic is allowed unless there is a network policy selecting the pod

- By default, all traffic is denied if there is a network policy selecting the pod without rules allowing it

- The rules only can allow traffic. There is no way to deny traffic using rules.

- The way to deny traffic is with no rules (see below)

- If one rule at least allows the traffic, traffic is allowed.

- Connections between pods are bidirectional. If you want A and B to communicate, you need two rules, one matching each direction.

## Choose the pods the policy will apply

This is done via `spec.podSelector`.

An empty dictionary selects all pods. The selector only applies to pods in the **same namespace** as the policy, never pods from other namespaces.

```yaml
spec:
  podSelector: {}
```

Here we can use `matchLabels` and `matchExpressions`.

## Choose what traffic is permitted to enter the pod

Ingress traffic is the network traffic that enters the pod and it is controlled by `spec.ingress`.

An empty array denies all incoming traffic. Nothing is whitelisted.

```yaml
spec:
  ingress: []
```

### Rule

Inside an ingress rule we must indicate the origin of the traffic using `from`.

Multiple selectors inside the `from` array act as OR, not AND.

- `ipBlock.cidr`

With `ipBlock.cidr` we can define the source IPs via IPv4 or IPv6 CIDR ranges. `0.0.0.0/0` permits traffic from all IPs.
Use `ipBlock.except` to deny a sub-range within the allowed CIDR.

- `namespaceSelector`

With `namespaceSelector` we can use `matchLabels` and `matchExpressions` to select the namespaces the traffic comes from.
An empty dictionary selects all namespaces.

- `podSelector`

With `podSelector` we can use `matchLabels` and `matchExpressions` to select the pods the traffic comes from.
An empty dictionary selects all pods.

We can optionally add the port definition. Note that ports refer to **pod ports**, not service ports.

```txt
ports.port
ports.protocol can be TCP (default), UDP, or SCTP
ports.endPort
```

## Choose what traffic is permitted to leave the pod

Egress traffic is the network traffic that leaves the pod and it is controlled by `spec.egress`.

An empty array denies all outgoing traffic. Nothing is whitelisted.

```yaml
spec:
  egress: []
```

The same selectors as ingress apply: `ipBlock`, `namespaceSelector`, and `podSelector`.

Using only `to: namespaceSelector: {}` in egress restricts outgoing traffic to internal cluster traffic only.

## policyTypes

## Links

- Network Policies

<https://kubernetes.io/docs/concepts/services-networking/network-policies/>

- Network policy editor by isovalent

<https://editor.networkpolicy.io/>

- Securing Cluster Networking with Network Policies

<https://www.youtube.com/watch?v=3gGpMmYeEO8>
