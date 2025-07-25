# Errors and solutions

## Update to 2.12 breaks appset

Until argocd 2.11 there should be a relation between the repository url defined in the repository secret and the repoURL configured in the application and applicationset.

Since the 2.12 release there is another restriction. If you have a repository with a project configured, only the applications that belongs to that project can use the repository. So

But there is another problem related with the Git generator in applicationsets. The applicationset cannot belong to a project, so all the repositories used by that applicationsets must not have a project defined, or they will fail

Links

- v2.11 to 2.12

<https://argo-cd.readthedocs.io/en/stable/operator-manual/upgrading/2.11-2.12/>

- 2.12.x throws could not read Username for '<https://gitlab.com>' from the UI

<https://github.com/argoproj/argo-cd/issues/19585>

- rpc error: code = Internal desc

<https://github.com/argoproj/argo-cd/issues/19174>

> If you delete the project from the repositories and the errors in the appset don't dissapear, you can force a restart  with kubectl -n argocd rollout restart sts,deploy

## cache: key is missing

After an update we get this error in the web interface

```txt
error getting cached app managed resources: cache: key is missing
```

It seems the solution is restarting the argocd-application-controller

```shell
kubectl rollout restart statefulset -n argocd argocd-application-controller
```
