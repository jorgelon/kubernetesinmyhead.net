# Tips

## Keep a resource

Add the following annotation to keep a resource when a helm uninstall, upgrade or rollback operation is done

```yaml
  annotations:
    helm.sh/resource-policy: keep
```

## nil pointer evaluating interface with range loop, no accede al values

<https://stackoverflow.com/questions/57475521/ingress-yaml-template-returns-error-in-renderring-nil-pointer-evaluating-int>

## Iterate over range

<https://stackoverflow.com/questions/56224527/helm-iterate-over-range>

## Links

- Chart Development Tips and Tricks

<https://helm.sh/docs/howto/charts_tips_and_tricks/>
