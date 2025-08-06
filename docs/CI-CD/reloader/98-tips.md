# Tips

## Working with Argo Rollouts

We must enable this feature. In the helm chart:

```yaml
reloader:
  isArgoRollouts: true
```

Then we must annotate the Argo Rollout resource. See [annotations](annotations.md)

> Using workloadRef crashes the operator. See this bug: <https://github.com/stakater/Reloader/issues/751>
