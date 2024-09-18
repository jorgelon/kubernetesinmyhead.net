# Graceful terminations in pods

Pods are ephemeral and there a lot of reasons why they can be deleted so it is critical to make our application to shutdown gracefully.
In order to delete the pod, kubernetes **sends the SIGTERM** (terminate) signal to the application and it waits for a response that tells it is safe to delete it. If there is no response, the application is deleted inmediately with a SIGKILL.
So **the application needs to manage that SIGTERM signal**.

> The process starts because the kubernetes api server changes the state of the pod to "Terminating"

## preStop hook

The preStop hook is a **command or http request** you can use to execute it **before the SIGTERM signal** so you can add that graceful shutdown both ways.

- Inside the application's code, handling the sigterm
- With a pre stop hook without modifying the application itself

> In addition to a command or http requests, there is a beta feature called "sleep" that pauses the container for a time.

## terminationGracePeriodSeconds

This setting is the time kubernetes waits for that graceful shutdown. The default value is 30 seconds and it can be modified. If the graceful shutdown needs more time, this needs to be adjusted.

> If you give to it the value zero, kubernetes uses inmediatly the SIGKILL signal. There is no wait.

## Race condition with the endpoint

There are 2 actions that are done in parallel, and this is a potential problem.

- Remove the pod as an endpoint in a service (stop receiving traffic)
- The SIGTERM sent to the application

With this you can have a race condition where the pod does not exists but the endpoint resource exists. And the system tries to send traffic to a pod that does not exists.

This can suggest **the preStop hook is a safer way** it that cases because it is executed before the SIGTERM and endpoint removal.

## Schema

preStop Hook > SIGTERM > terminationGracePeriodSeconds > SIGKILL
                       > SIGKILL (if SIGTERM is not managed by the application)
             > endpoint removal

## Links

- Pod Lifecycle  
<https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/>

- Pod Lifecycle spec  
<https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#lifecycle>

- Container Lifecycle Hooks  
<https://kubernetes.io/docs/concepts/containers/container-lifecycle-hooks/>

- Stop Losing Requests! Learn Graceful Shutdown Techniques  
<https://www.youtube.com/watch?v=eQPYsGrZW_E>

- Kubernetes best practices: terminating with grace  
<https://cloud.google.com/blog/products/containers-kubernetes/kubernetes-best-practices-terminating-with-grace>
