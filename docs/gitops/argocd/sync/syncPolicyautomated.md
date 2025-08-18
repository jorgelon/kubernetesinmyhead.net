# Automated sync

By default, after a reconciliation/refresh, an Application does not make and automatic sync when it detects differences between the target and the live state. So the differences between them are not applied in an automated way. For that we need to enable the autosync feature in the Application (or Applicationset)

## Enabling autosync

We can enable autosync with this setting in the Application resource

```yaml
spec:
  syncPolicy:
    automated: {}
```

## autosync options

There some options here to configure the automated sync.

- prune

Enables automatic deletion of resources that they are not defined in the Application but they were. The default value is false.

- allowEmpty

This setting is disabled by default and prevents a pruning operation can remove all the resources in the Application.

- selfHeal

When a change in detected in the kubernetes cluster that generates a drift, argocd by default ignores it. Enabling selfHeal triggers a new sync.

## Toggling autosync

Since argocd 3.1 we can also enable/disable for an Application resource using a new feature:

```yaml
spec:
  syncPolicy:
    automated:
      enabled: true # or false
```

### Some notes about this new feature

- Setting this value to false, disables autosync but permits to configure prune, allowEmpty and selfHeal

- This setting is currently not working because of a bug <https://github.com/argoproj/argo-cd/issues/24171>

- This setting has no effect in Applications managed by ApplicationSets.
  
To enable/disable autosync in an Application managed by ApplicationSet without changing the setting in all generated Applications, we have some options. For example we can use **templatePatch** or **ignoring that field in the ApplicationSet** and then changing manually the desired value in our Application

```yaml
apiVersion: argoproj.io/v1alpha1
kind: ApplicationSet
spec:
  ignoreApplicationDifferences:
    - jsonPointers:
        - /spec/syncPolicy/automated/enabled
```

> This permits enabling and disabling the autosync manually and directly in the Application resource but loosing gitops control of desired state.

## Links

<https://argo-cd.readthedocs.io/en/stable/user-guide/auto_sync/>
