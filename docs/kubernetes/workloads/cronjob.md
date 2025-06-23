# Cronjob

## spec.startingDeadlineSeconds

This field defines the maximum time in seconds that a job can be delayed its initialization from the initial scheduled time.

For example, a problem in the kubernetes cluster can cause the cronjob cannot start the job in the scheduled time. spec.startingDeadlineSeconds is the delay we accept, the tolerance window.
If the delay is bigger than startingDeadlineSeconds, the job will not be executed and it will be considered failed.

## spec.concurrencyPolicy

This field controls if we permit or not the execution of multiple jobs from this cronjob at the same time.

- The default value is "Allow"

- The "Forbid" policy does not allow concurrent instances. The new one will be skipped.

> If the current job finishes and the second one is in the spec.startingDeadlineSeconds time, this will make the second instance start.

- The "Replace" policy replaces the currently running Job run with a new Job run

## Links

- CronJob

<https://kubernetes.io/docs/concepts/workloads/controllers/cron-jobs/>

- CronJob spec

<https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/cron-job-v1/>
