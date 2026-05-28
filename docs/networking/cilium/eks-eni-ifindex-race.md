# Cilium on EKS: stale ENI MAC and ifindex race

This page documents a race condition observed with Cilium in **ENI IPAM mode**
on EKS that leaves pods stuck in `ContainerCreating` indefinitely on a single
node. The fix is in Cilium v1.19.0 and has not been backported to v1.17 or
v1.18 at the time of writing.

## Symptom

New pods scheduled on the affected node never start. `kubectl describe pod`
shows a `FailedCreatePodSandBox` event from kubelet repeating every few
seconds:

```text
Failed to create pod sandbox: rpc error: code = Unknown desc =
failed to setup network for sandbox "<id>":
plugin type="cilium-cni" failed (add):
unable to setup interface datapath:
unable to install ip rules and routes:
unable to find ifindex for interface MAC:
interface with MAC 0a:xx:xx:xx:xx:xx not found
```

The affected node is `Ready` and other workloads on it keep running. Only new
pods (and pods that need to be re-created, including Argo Workflows `onExit`
hook pods, jobs, etc.) get stuck.

## Root cause

In ENI IPAM mode, the `cilium-operator` requests an extra ENI from AWS, attaches
it to the EC2 instance, and updates the `CiliumNode` custom resource with the
new ENI's identifier, MAC address and IP pool. The `cilium-agent` running on
that node then sets up IP rules and routes for the new ENI.

The agent looks up the kernel network interface by **MAC address**. If the
agent runs the lookup before the kernel has finished enumerating the freshly
attached ENI as a netdev, the lookup fails and the agent records the failure
state. From then on, any pod scheduled to an IP belonging to that ENI fails the
CNI sandbox step with the message above.

The mismatch can survive for the lifetime of the node:

- The `CiliumNode` CR still lists the ENI (correctly, from the AWS view).
- The host kernel does not have a netdev with that MAC (or it appeared late).
- The agent does not retry the lookup once it has been marked as failed.

## Affected versions

- Confirmed on Cilium **v1.17.x** and **v1.18.x**.
- Fixed on `main` and released in
  [**Cilium v1.19.0**](https://github.com/cilium/cilium/releases/tag/v1.19.0)
  via
  [PR #41954 — *ipam: Wait for ENI netlink interface before configuring routes*](https://github.com/cilium/cilium/pull/41954).
- No backport PRs to `v1.17` or `v1.18` branches exist at the time of writing.
  The labels `affects/v1.17` and `affects/v1.18` are present on the PR but no
  corresponding backport has been merged.

## Detection

Indicators that a node is affected:

- One or more pods on the node stuck in `ContainerCreating` or `Init:0/N`
  with the `FailedCreatePodSandBox` event quoted above.
- The MAC address in the error message corresponds to an ENI listed in the
  `CiliumNode` CR but absent from the host's `ip link show`.

The MAC-to-ENI mapping can be inspected with:

```shell
kubectl get ciliumnode <node-name> -o json | \
  jq '.status.eni.enis | to_entries[] | {id:.key, mac:.value.mac, number:.value.number}'
```

The IPs assigned by the operator to each ENI are visible in:

```shell
kubectl get ciliumnode <node-name> -o json | \
  jq '.spec.ipam.pool | to_entries[] | {ip:.key, eni:.value.resource}'
```

## Workarounds

There is no agent flag or Helm value that bypasses the failed MAC lookup on the
affected branches. The practical options are:

1. **Replace the node.** Cordon and drain the affected node, then terminate the
   EC2 instance and let the ASG or Karpenter provision a new one. The new node
   will perform a fresh ENI attach sequence; if it hits the same race, the
   problem reappears, but the node currently stuck is unblocked.
2. **Restart the `cilium-agent` pod** on the affected node. On agent restart
   the kernel netdev is usually already present, so the lookup succeeds. This
   does not always work — if the ENI is also missing on the AWS side (rare),
   only node replacement clears the state.
3. **Skip the affected IP range.** Once the IPs belonging to the missing MAC
   are identified (see *Detection*), pods that schedule on the node will draw
   from healthy ENIs only if those bad IPs are already removed from the pool.
   This requires manual edits to the `CiliumNode` CR and is brittle.

Until the fix is backported, the realistic preventive strategy is operational:

- Alert on pods stuck in `ContainerCreating` for longer than a few minutes.
- Auto-remediate by replacing nodes that accumulate sandbox-creation failures
  (for example with the
  [Node Health Check Operator](https://github.com/medik8s/node-healthcheck-operator)
  or a Karpenter low `expireAfter`).

## Related upstream reports

- [cilium/cilium#37948 — *CI: failed to configure router IP rules and routes:
  unable to find ifindex for interface MAC*](https://github.com/cilium/cilium/issues/37948).
  The issue that tracks the race on EKS clusters.
- [cilium/cilium#41954 — *ipam: Wait for ENI netlink interface before
  configuring routes*](https://github.com/cilium/cilium/pull/41954).
  The fix merged into `main`. Adds a polling loop that waits for the netdev to
  appear before configuring routes.
- [cilium/cilium#41922 — *Cilium failing to chain with OVN in ENI mode because
  two interfaces have the same mac*](https://github.com/cilium/cilium/issues/41922).
  A related but distinct failure mode where the MAC lookup matches more than
  one interface. Same code path, different symptom.

## Further reading

- [Cilium ENI IPAM documentation](https://docs.cilium.io/en/stable/network/concepts/ipam/eni/)
- [Cilium upgrade guide](https://docs.cilium.io/en/stable/operations/upgrade/)
