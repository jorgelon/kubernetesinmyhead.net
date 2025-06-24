# retryStrategy

retryStrategy permits to control retries and it ca be defined at 2 levels

- at workflow level (spec.retryStrategy) affects all templates in the workflow
- in every template describes how to retry a template when it fails

In the retryStrategy we have some options

## retryPolicy and expression

Both are re-evaluated after each attempt. For example, if you set retryPolicy: OnFailure and your first attempt produces a failure then a retry will be attempted. If the second attempt produces an error, then another attempt will not be made.
The expression result will be logical and with the retryPolicy. Both must be true to retry.

### expression

Expression is a condition expression for when a node will be retried. If it evaluates to false, the node will not be retried and the retry strategy will be ignored.
If expression evaluates to false, the step will not be retried.

This variables are available:

- lastRetry.exitCode: The exit code of the last retry, or "-1" if not available
- lastRetry.status: The phase of the last retry: Error, Failed
- lastRetry.duration: The duration of the last retry, in seconds
- lastRetry.message: The message output from the last retry (available from version 3.5)

### retryPolicy

RetryPolicy is a policy of NodePhase statuses that will be retried. Here we choose what failures type to retry.

- Always

Retry all failed steps

- OnFailure

Retry steps whose main container is marked as failed in Kubernetes

- OnError
  
Retry steps that encounter Argo controller errors, or whose init or wait containers fail

- OnTransientError

Retry steps that encounter errors defined as transient, or errors matching the TRANSIENT_ERROR_PATTERN environment variable. Available in version 3.0 and later.

> The retryPolicy applies even if you also specify an expression, but in version 3.5 or later the default policy means the expression makes the decision unless you explicitly specify a policy.

About the default retryPolicy

> The default retryPolicy is OnFailure, except in version 3.5 or later when an expression is also supplied, when it is Always

![alt text](image-1.png)

## limit

Limit is the maximum number of retry attempts when retrying a container. It does not include the original container; the maximum number of total attempts will be `limit + 1`.

## affinity

Affinity prevents running workflow's step on the same host

nodeAntiAffinity

## backoff

Backoff is a backoff strategy. You can configure the delay between retries with backoff. See example for usage.

- duration

- maxDuration

- cap

- factor (int)

> duration, maxDuration and cap are strings taken as unit members (by default seconds). Example: "4". Could also be a Duration, e.g.: "2m", "6h"

## Links

- Retries

<https://argo-workflows.readthedocs.io/en/latest/retries/>
