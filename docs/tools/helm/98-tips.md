# Tips

## Keep a resource

Add the following annotation to keep a resource when a helm uninstall, upgrade or rollback operation is done

```yaml
  annotations:
    helm.sh/resource-policy: keep
```

## Links

- Chart Development Tips and Tricks

<https://helm.sh/docs/howto/charts_tips_and_tricks/>
