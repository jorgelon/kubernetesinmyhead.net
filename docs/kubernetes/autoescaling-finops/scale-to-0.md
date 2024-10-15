# Scale to 0

It can be useful to scale to 0 when desired some workloads in order to reduce resource utilizacion. In addition to this, downscaling nodes will make a cheaper deployment.

So, scale to 0 the deployments you need and the let karpenter o another tool to consolidate and delete nodes.

## Note about gitops tools

If you are using a gitops tool like argocd or flux, take care about the interactions with the original manifests. Argocd recommends to not specify the replicas in your manifests and let them to be managed by horizontal pod autoescaler or these tools.

 <https://argo-cd.readthedocs.io/en/stable/user-guide/best_practices/>

## Keda

Keda has a scaler called "cron" that permits to scale to 0 the desired workloads when needed. It alson contains a lot of ways to scale our workloads.

<https://keda.sh/docs/latest/scalers/cron/>

> Keda recommends not to use horizontal pod autoescaler with keda

## Kube-green

Kube green permit sto "sleep" your pods

<https://kube-green.dev/>

## Snorlax

Snorlax is a tool that also permits to sleep your workloads

<https://github.com/moonbeam-nyc/snorlax>

## Sleepcycles

Another tool. They say the argocd self healing must be disabled

<https://github.com/rekuberate-io/sleepcycles>
