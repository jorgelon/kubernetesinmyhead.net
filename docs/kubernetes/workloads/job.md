# Jobs

## Configuring the job

- restartPolicy

OnFailure

- Retries

With spec.backoffLimit we can define the number of retries before considering a Job as failed. The default value is 6.

By default, a Job will run uninterrupted unless a Pod fails (restartPolicy=Never) or a Container exits in error (restartPolicy=OnFailure), at which point the Job defers to the .spec.backoffLimit described above. Once .spec.backoffLimit has been reached the Job will be marked as failed and any running Pods will be terminated.

- activeDeadlineSeconds

When a jobs reaches the number of seconds defined in spec.activeDeadlineSeconds, the pods will be terminated and the pod will have the status "Failed with DeadlineExceeded as reason". It is a good way to define a time we think the job is not going well.

## Clean finished jobs

### Via Cronjob

pending

### Via ttlSecondsAfterFinished

The spec.ttlSecondsAfterFinished keys permits to define an integer that represents the number of seconds to wait until the TTL Controller deletes the job.
If we set this value to 0, the job will be deleted inmediately after it finishes, this is, when it has the "Complete" or "Failed" status.

> It is a best practice to define ttlSecondsAfterFinished in jobs that they are not controlled by a cronJob.

## Jobs in argocd

## Links

- Jobs

<https://kubernetes.io/docs/concepts/workloads/controllers/job/>

- Automatic Cleanup for Finished Jobs

<https://kubernetes.io/docs/concepts/workloads/controllers/ttlafterfinished/>
