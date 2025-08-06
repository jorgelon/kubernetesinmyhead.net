# Intro

Reloader permits to restart some kubernetes resources when some defined configmaps or secrets has changed.

It Works with these kubernetes resources:

- Deployments
- Daemonsets
- Statefulsets
- DeploymentConfigs (from openshift, needs to be enabled via isOpenshift: true)
- Rollouts (from Argo rollouts, needs to be enabled via isArgoRollouts: true)

## How it works

Reloader tracks the kubernetes resources configured. When a secret or configmap is updated, reloader triggers a restart of the resource.

For this, it watches the data section of the secret

There are 2 reload strategies here. The default one (env-vars) creates an environment variable in the restarted pods. The "annotations" mode add an annotation "reloader.stakater.com/last-reloaded-from" in the pods (via template spec)

## More info

- Github  
<https://github.com/stakater/Reloader>

- Github docs  
<https://github.com/stakater/Reloader/tree/master/docs>
