# Send alerts

## To slack

Create a Slack Incoming Webhook

- Go to <https://api.slack.com/apps> and create a new app (or use existing)

Then enable "Incoming Webhooks""

![alt text](image.png)

And add a webhook to your workspace, select the channel where you want to post alerts and click allow.

Take note of the webhook URL

It looks like <https://hooks.slack.com/services/T00000000/B00000000/XXXXXXXXXXXX>

## To Microsoft Teams 2

Choose a channel and go to "Workflows"

Here create a workflow

- using the template "send webhook alerts to a channel"
- choosing the team and channel
- finally take note of the url

> In order to make this work we need Alertmanager >= 0.28.0. If using prometheus operator we also need the crds that supports it
