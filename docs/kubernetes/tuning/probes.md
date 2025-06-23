# Kubernetes probes and self healing

If the container has not probes defined, they will be considered as success

## startupProbe

This was included after readinessProbe and livenessProbe. It is commonly used to setup a delay in pods with slow startup process. The readinessProbe and livenessProbe are not checked until the startupProbe is considered "Success".

If your container usually starts in more than initialDelaySeconds + failureThreshold × periodSeconds, you should specify a startup probe that checks the same endpoint as the liveness probe. The default for periodSeconds is 10s. You should then set its failureThreshold high enough to allow the container to start, without changing the default values of the liveness probe. This helps to protect against deadlocks.

> If the probe is not ok, kubelet will kill the container and it will apply the pod restart policy:

- Always (default)

The container is restarted

- OnFailure  
  
The container is restart if the container had an exit status different than 0

- Never

Never restart the container

## readinessProbe

This probe is related with considering the container is ready to accept petitions. It is useful when what to define when to start sending traffic to the container.

- If the probe fails, the container is pulled of from the services to stop receiving traffic
- The default result is "Failure". It must be accomplished to be considered as "Success"

## livenessProbe

This probe is related with considering the container is alive and running.

It is useful like a way to tell kubelet the pod crashed, it encounters an issue or becomes unhealthy. The kubelet will automatically perform the correct action in accordance with the Pod's restartPolicy.

## Recommendations

- Use startupProbe for slow starting apps
- The probes must be simple and lightweight
- Ensure the probe target is independent of the main application
- They can fail in heavy loaded environments
- In general, it is a best practice to define a livenessProbe and a readinessProbe. And they must be different.
- If using the same endpoint, set a higher failureThreshold value for the livenessProbe, that is, disconnect traffic and customers earlier, and if things are really bad, then restart.
