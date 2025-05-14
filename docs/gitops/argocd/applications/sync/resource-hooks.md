# Resource Hooks

Resource hooks are ways to execute some actions at certain moments of the sync operation.
They are typically used in resources like Pods, Jobs and Workflows (from Argo workflows)

For this we only need to add the following anotation to the resource:

```yaml
argocd.argoproj.io/hook: HOOK
```

The HOOK can be:

- PreSync

It will run in the PreSync phase

- Sync

It will run in the Sync phase

- PostSync

It will run in the PostSync phase

- SyncFail

It will run if a sync operation fails

- PostDelete

It will run  after all Application resources are deleted

- Skip

Argocd will skip the application of the manifest

## Important notes

- Hooks are not run during selective sync

- Multiple hooks can be specified as a comma separated list

## Deletion policy

We can also define when to delete the hook with the following annotation:

```yaml
argocd.argoproj.io/hook-delete-policy: POLICY
```

Where the policy can be:

- HookSucceeded

The hook is deleted after the hook ends ok

- HookFailed

The hook is deleted is it fails

- BeforeHookCreation (default)

The hook is deleted before the new one is created. It exits to be used with named hooks

## Named hooks

If the Resource hook have a name, it is considered a named hook and it will be only created once. If we want to create it at every sync, we have 2 options:

- use generateName instead of name
- use BeforeHookCreation as deletion policy

## Jobs and workflows (from Argo workflows)

A job has the field **ttlSecondsAfterFinished** and a workflow (from Argo Workflows) have **ttlStrategy**. Both properties offer autoclean after some time.

Using this fields can cause an OutOfSync state when the deletion comes. Using deletion hooks instead of ttlSecondsAfterFinished and ttlStrategy avoids this situation.

## Links

- Resource Hooks

<https://argo-cd.readthedocs.io/en/stable/user-guide/resource_hooks/>
