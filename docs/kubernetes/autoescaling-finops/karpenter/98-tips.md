# Tips

## Show karpenter nodes

```shell
eks-node-viewer -disable-pricing -node-selector karpenter.sh/registered=true
```

```shell
kubectl get node -o yaml | grep -A 1 finalizer
```

## Get the node events

```shell
kubectl get events --all-namespaces --field-selector involvedObject.kind=Node
```

### Cannot disrupt Node

```txt
Cannot disrupt Node: state node doesn't contain both a node and a nodeclaim
```

This can tell you this node is not managed by karpenter

### SpotToSpotConsolidation is disabled

```txt
SpotToSpotConsolidation is disabled, can't replace a spot node with a spot node
```

### Can't replace with a cheaper node

### Pdb XXX prevents pod evictions

```txt
Pdb XXX prevents pod evictions
```
