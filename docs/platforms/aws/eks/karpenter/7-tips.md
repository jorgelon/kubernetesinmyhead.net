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

## Cannot disrupt Node: state node doesn't contain both a node and a nodeclaim

This can tell you this node is not managed by karpenter
