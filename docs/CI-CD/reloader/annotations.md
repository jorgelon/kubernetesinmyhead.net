# Annotations

The method to configure how we control how reloader restarts the workloads is via resource annotations.

There are 3 ways to the reload

## Automatic reload

This is the default behaviour. We have this 3 options: if any secret inside the workload or configmap changes, or if only a configmap or secret changes.

> It is possible to use a custom annotations with a reloader controller parameter

| Annotation                                   | Behaviour                               | Custom annotation parameter |
|----------------------------------------------|-----------------------------------------|-----------------------------|
| reloader.stakater.com/auto: "true"           | reload if a secret or configmap changes | --auto-annotation           |
| reloader.stakater.com/auto: "false"          | disables the reload in the workload     | --auto-annotation           |
| configmap.reloader.stakater.com/auto: "true" | reload if a configmap changes           | --configmap-auto-annotation |
| secret.reloader.stakater.com/auto: "true"    | reload if a secret changes              | --secret-auto-annotation    |

- **reloader.stakater.com/auto and reloader.stakater.com/search cannot be used together**. the auto annotation takes precedence.
- **If both configmap.reloader.stakater.com/auto and secret.reloader.stakater.com/auto are used**, only one needs to be true to trigger a reload.

> Enabling **--auto-reload-all** in the controller makes all workloads treated as **reloader.stakater.com/auto: "true"** unless they have **reloader.stakater.com/auto: "false"**

## Giving the name of the resource

We can be more specific giving the name(s) of the secret(s) or configmap(s) that must trigger the reload. Multiple configmaps or secrets can be specified, comma separated

> It is possible to use a custom annotations with a reloader controller parameter

| Annotation                                                      | Behaviour                             | Custom annotation parameter |
|-----------------------------------------------------------------|---------------------------------------|-----------------------------|
| configmap.reloader.stakater.com/reload: "NAME_OF_THE_CONFIGMAP" | reload if specified configmap changes | --configmap-annotation      |
| secret.reloader.stakater.com/reload: "NAME_OF_THE_SECRET"       | reload if specified secret changes    | --secret-annotation         |

## Search and match restart

Another way to control the reload is using a two way annotation

If we annotate the workload with this

```txt
reloader.stakater.com/search: "true"
```

... reload will trigger a reload if the configmap or secrets that the workload includes have the following annotation

```txt
reloader.stakater.com/match: "true"
```

> It is possible the override this annotation with the --auto-search-annotation flag

## Other annotations

| Annotation                                          | Where     | Behaviour                                                |
|-----------------------------------------------------|-----------|----------------------------------------------------------|
| reloader.stakater.com/ignore: "true"                | CM/Secret | The resource will not trigger reloads                    |
| reloader.stakater.com/rollout-strategy: "rollout"   | Workload  | A rollout is triggered patching the template             |
| reloader.stakater.com/rollout-strategy: "restart"   | Workload  | The pods are deleted without patching the template       |
| deployment.reloader.stakater.com/pause-period: "5m" | Workload  | Pause rollouts for a deployment for a specified duration |
