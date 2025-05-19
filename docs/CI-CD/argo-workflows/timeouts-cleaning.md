# Timeouts and self cleaning

## Workflow Timeout (activeDeadlineSeconds)

The maximum time allowed (timeout) for a workflow is configured with the spec.activeDeadlineSeconds fields. After this number of seconds, the workflow is terminated.

Changing this value to zero in a running workflow will terminate it

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: timeouts-
spec:
  activeDeadlineSeconds: 10
```

## Workflow auto deletion (TTLStrategy)

We can control the self deletion of a finished workflow with some spec.TTLStrategy fields:

- secondsAfterCompletion

Number of seconds the workflow we will be maintained after completion

- secondsAfterFailure

Number of seconds the workflow we will be maintained after failure

- secondsAfterSuccess

Number of seconds the workflow we will be maintained after Succeeded

> If we configure all 3, secondsAfterFailure and secondsAfterSucces have precedence

## Pod auto deletion (PodGC)

With PodGC we can configure when to delete the completed pods.

### Strategy

We must choose an strategy:

- "OnPodCompletion" deletes the pods when the pods ends (including failures)
- "OnPodSuccess"  deletes the pods when the pods ends successfully
- "OnWorkflowCompletion" deletes the pods when the workflow ends
- "OnWorkflowSuccess" deletes the pods when the workflow ends successfully
- No settings means no deletion will occur.

### deleteDelayDuration

spec.PodGC.deleteDelayDuration is an string field where we can specify the time to wait until the pods in the GC queue will be deleted.

> The default value is 5s. A zero (value) will delete the pods immediately

### labelSelector

With **labelSelector** we can se filter using labels what pods will be deleted

```yaml
apiVersion: argoproj.io/v1alpha1
kind: Workflow
metadata:
  generateName: pod-gc-strategy-
spec:
  entrypoint: pod-gc-strategy
  podGC:
    strategy: OnPodSuccess
    deleteDelayDuration: 30s
    labelSelector:
      matchLabels:
        should-be-deleted: "true"
```

## Workflow defaults at controller level

We can configure al these the default values at controller level in the workflow-controller-configmap configMap

```yaml
  workflowDefaults: |
    spec:
      activeDeadlineSeconds: 1200
      ttlStrategy:
        secondsAfterCompletion: 86400
        secondsAfterFailure: 86400
        secondsAfterSuccess: 28800
      podGC:
        strategy: OnPodCompletion
        deleteDelayDuration: 86400s
```

## CronWorkflow history limits

We can control the number of successful jobs to mantain with **spec.successfulJobsHistoryLimit**

> The default value is 3

And also the failed ones with **spec.failedJobsHistoryLimit**

> The default value is 1

## Template defaults

pending

## Links

- Cost optimization  
<https://argo-workflows.readthedocs.io/en/stable/cost-optimisation/#limit-the-total-number-of-workflows-and-pods>

- Timeouts  
<https://argo-workflows.readthedocs.io/en/stable/walk-through/timeouts/>

- Default workflow spec  
<https://argo-workflows.readthedocs.io/en/stable/default-workflow-specs/>

- Template defaults  
<https://argo-workflows.readthedocs.io/en/stable/template-defaults/>
