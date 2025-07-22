
# Send notifications to Microsoft Teams

## Create the webhoook

First we need to create a webhook in Microsoft Teams.

Choose the desired channel and go to "Manage channel" > "Conectors" > "Edit" and add an incoming webhook.
At the end we get and Url we must copy and configure in argocd

> We can configure a custom image for this webhook

## Configure argocd-notifications-cm configmap

In this configmap we can setup the recipients, the destinations. If we want to add a chanel called argocdNotify, the configmap can be

```yaml
apiVersion: v1
kind: ConfigMap
metadata:
  name: argocd-notifications-cm
data:
  service.teams: |
    recipientUrls:
      argocdNotify: $channel-teams-url
```

> Do not change $channel-teams-url with the former url

## Configure argocd-notifications-cm secret

Argocd will search the url in the argocd-notifications-cm secret

```yaml
apiVersion: v1
kind: Secret
metadata:
  name: argocd-notifications-cm
stringData:
  channel-teams-url: MYWEBHOOKURL
```

> Don't forget to setup subscriptions

## Links

- Teams

<https://argo-cd.readthedocs.io/en/stable/operator-manual/notifications/services/teams/>
