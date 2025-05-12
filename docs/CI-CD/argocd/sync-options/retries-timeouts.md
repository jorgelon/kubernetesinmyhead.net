# Control retries and timeouts

## Control retries in syncPolicy

We can control the retries when a sync operation starts. We can configure it with spec.syncPolicy.retry at application definition level or as a parameter with the argocd binary

### Retry limit

The number of failed retries is configured with the retry limit option. If a sync attempt fails, ArgoCD will automatically retry the sync up to the number of times defined by the retry.limit
If the value in less than 0, ArgoCD will retry indefinitely until the sync succeeds or is manually stopped.

### Backoff

With retry.backoff we can configure the delay between sync attempts with the possibility to increase the time between every failed attempt to avoid overwhelming the system or external resources.

- **duration** is the delay between attempts (default 5s)

- **factor** multiplies the delay (duration) after each failed retry (default 2)

- **maxDuration** is the max delay between retry attempts (default 3m0s)

### Example in the application spec

```txt
3 retries
1st retry delay: 10 seconds
2st retry delay: 30 seconds
3st retry delay: 60 seconds
```

... (but never exceeding 5 minutes between retries)

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Application
metadata:
  name: guestbook
spec:
  syncPolicy:
    retry:
      limit: 3
      backoff:
        duration: 10
        factor: 3 
        maxDuration: 5m
```

### Related argocd app sync parameters

```txt
--retry-limit
--retry-backoff-duration
--retry-backoff-factor
--retry-backoff-max-duration
```

## Setup a timeout for app sync

It is possible, and probably recommended to configure a timeout in seconds when an application starts a sync operation.

It is configured at controller level, and sets the maximum time allowed for a single sync operation to complete before it is considered failed.

This is done with the controller.sync.timeout.seconds setting in the argocd-cmd-params-cm configmap

```txt
controller.sync.timeout.seconds: "1800" # 30 minutes
```

> The default value is "0", no timeout
