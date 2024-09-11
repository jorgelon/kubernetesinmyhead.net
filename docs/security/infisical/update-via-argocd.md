# How to update infisical with argocd

In order to update infisical self hosted via slack we must do some steps

## Steps

- Backup the database
Do a backup in the database

- Disable autosync
Disable autosync if enabled in the argocd application

- Change the values.yaml
Change the values.yaml with the new image release.

We can get the infisical releases here:  
<https://github.com/Infisical/infisical/releases>

And the infisical container releases here:  
<https://hub.docker.com/r/infisical/infisical/tags>

- Sync the job  
Sync the job with Force and Replace options and see the log of the job's pod

- sync the deployment  
Sync the infisical deployment and see the log of the deployment's pod

- Enable autosync  
Enable autosync if needed in the argocd application

## Links

- Kubernetes via helm chart
<https://infisical.com/docs/self-hosting/deployment-options/kubernetes-helm>

- Schema migration  
<https://infisical.com/docs/self-hosting/configuration/schema-migrations>
