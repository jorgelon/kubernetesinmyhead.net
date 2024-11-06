# Intro

Reloader permits to restart some kubernetes resources when some defined configmaps or secrets has changed.

It Works with these kubernetes resources:

- Deployments
- Daemonsets
- Statefulsets
- DeploymentConfigs (from openshift, needs to be enabled)
- Rollouts (from Argo rollouts, needs to be enabledg)

There are 3 ways to define the desired behaviour

## Automatic discovery

With the following annotation in the kubernetes resource, reloader search for configmaps and secrets defined and mounted in the pod as volume or loaded as environment variables. If the configmap and/or the secret is updated, the resource is restarted.

```txt
reloader.stakater.com/auto: "true"
```

> It is possible the override this annotation  with the --auto-annotation flag

We can restrict this behaviour to configmaps

```txt
configmap.reloader.stakater.com/auto: "true"
```

> It is possible the override this annotation  with the --configmap-auto-annotation flag

Same, but only the secrets will cause a restart

```txt
secret.reloader.stakater.com/auto: "true"
```

> It is possible the override this annotation  with the --secret-auto-annotation flag

## Search and match restart

If we use the folling annotation in the kubernetes resource...

```txt
reloader.stakater.com/search: "true"
```

> It is possible the override this annotation with the --auto-search-annotation flag

...reloader only triggers a restart if the secret or configmap has this annotation:

```txt
reloader.stakater.com/match: "true"
```

> It is possible the override this annotation with the --search-match-annotation flag

## Giving the name of th resource

It is possible to give the name of the configmap that can trigger a restart

```txt
configmap.reloader.stakater.com/reload: "NAME_OF_THE_CONFIGMAP"
```

multiple configmaps comma separated

```txt
configmap.reloader.stakater.com/reload: "NAME_OF_THE_CONFIGMAP,NAME_OF_THE_CONFIGMAP2"
```

> It is possible the override this annotation with the --configmap-annotation flag

And same with the secret

```txt
secret.reloader.stakater.com/reload: "NAME_OF_THE_SECRET"
```

multiple secrets comma separated

```txt
secret.reloader.stakater.com/reload: "NAME_OF_THE_SECRET,NAME_OF_THE_SECRET2"
```

> It is possible the override this annotation with the --secret-annotation flag

## How it works

Reloader tracks the kubernetes resources configured as explained before. When a secret or configmap is updated, reloader triggers a restart of the resource.

For this, it watches the data section of the secret

There are 2 reload strategies here. The default one (env-vars) creates an environment variable in the restarted pods. The "annotations" mode add an annotation "reloader.stakater.com/last-reloaded-from" in the pods (via template spec)

## More info

- Github  
<https://github.com/stakater/Reloader>

- Github docs  
<https://github.com/stakater/Reloader/tree/master/docs>
