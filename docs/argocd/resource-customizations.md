# Resource customizations

Argocd is prepared to work with core kubernetes resources like deployments, secrets, network policies,... but it does not know how to manage custom resource definitions.

For example, Argocd knows what to do to restart a deployment. This is called an action in argocd terminology. Or it knows how to know if an ingress resource in a healthy state.

But one of the most important think in kubernetes is how extensible is via custom resource definitions, for example.
In order to understand them, argocd has the resource customizations folder.

<https://github.com/argoproj/argo-cd/tree/master/resource_customizations>

For example, here is defined the how to refresh an externalsecret resource, from external-secrets operator

<https://raw.githubusercontent.com/argoproj/argo-cd/master/resource_customizations/external-secrets.io/ExternalSecret/actions/refresh/action.lua>

Or here, we can see the definition of the health status of a rollout, from argo rollouts

<https://raw.githubusercontent.com/argoproj/argo-cd/master/resource_customizations/argoproj.io/Rollout/health.lua>

> If your company has created a kubernetes custom resource definition for your application, it can be a good idea to create here some settings to improve the compatibility with argocd
