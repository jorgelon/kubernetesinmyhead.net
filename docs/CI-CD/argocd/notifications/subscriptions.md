# Setup subscriptions

There are 2 places where to setup what notifications to send

## Default subscriptions

The default subscriptions are defined in in the argocd-notifications-cm configMap in the data.subscriptions field.

This settings sends notifications when all the applications have the health degraded to the "MYRECIPIENT" destination.

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-notifications-cm
data:
  subscriptions: |
    - recipients:
      - MYRECIPIENT
      triggers:
      - on-health-degraded
```

> In this configmap we also configure that recipient for the notification service we want to use

## At application level

At application level we can choose what events we want to receive adding an annotation to the application using this format

```txt
notifications.argoproj.io/subscribe.<trigger>.<service>: <recipient>
```

The trigger is the event. We have this default triggers

- on-created
- on-deleted
- on-deployed
- on-health-degraded
- on-sync-failed
- on-sync-running
- on-sync-status-unknown
- on-sync-succeeded

The service is the notification service or provider.

Finally the recipient is configured in the argocd-notifications-cm configMap. We can separate more than one recipient separated with ";"

An example to send when the application is has the unknown status via telegram to the sre and developers recipient is adding this annotation to the application:

```txt
notifications.argoproj.io/subscribe.on-sync-status-unknown.telegram: sre;developers
```

## Links

- Subscriptions

<https://argo-cd.readthedocs.io/en/stable/user-guide/subscriptions/>
