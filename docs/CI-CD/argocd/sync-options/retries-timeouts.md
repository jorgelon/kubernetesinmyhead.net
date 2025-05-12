# Control retries and timeouts

## Setup a timeout for app synchronization

It is possible, and probably recommended to configure a timeout in seconds when an application starts a sync operation.

This is done with the controller.sync.timeout.seconds setting in the argocd-cmd-params-cm configmap

```yaml
controller.sync.timeout.seconds: "1800" # 30 minutes
```

The default value is "0", no timeout
