# Graceful terminations in pods

Pods are ephemeral and there a lot of reasons why they can be deleted so it is critical to make our application to shutdown gracefully.
In order to do it the proper way, we must understand the pod deletion processes.

## Api call

The deletion starts with an request to the api server. Then the api server changes the status of the pod top to "Terminating". This triggers 2 parallel process.

## Endpoint deletion

The endpoint controller starts removing the pod from EndpointSlices and Endpoints.
The endpoints are not deleted immediately from the EndpointSlices. The EndpointSlices change the status from this:

```txt
conditions:
    **ready: true**
    serving: true
    **terminating: false**
```

to

```txt
conditions:
    **ready: false**
    serving: true
    **terminating: true**
```

The pod stops receiving new connections. At the end, the pod related entries are removed in kube-proxy, coredns,...

## Pod termination

At the same time the pod termination process starts with 2 phases: the preStop hook and the SIGTERM

### preStop hook

First of all, a preStop hook is executed if defined in the pod. The preStop hook is a **command or http request** you can use to execute in the pod. Here the application does not know it will be terminated.

> In addition to a command or http requests, there is a beta feature called "sleep" that pauses the container for a time.

It is not a good idea to use a typical sleep command because the time to do a proper shutdown will be different in every situation.
Another bad idea is to expose the http endpoint called in the http request. It should be internal.

### SIGTERM

After this, kubelet sends sends the **SIGTERM (terminate) signal** to the process with ID 1 to all the containers in the pod and it waits for a response that tells it is safe to delete it. If there is no response, the application is deleted inmediately with a **SIGKILL signal**.

Because of this, the application needs to be **prepared to manage that SIGTERM** signal and do a graceful shutdown.

> The default signal received by the container is the SIGTERM. In a Dockerfile you can change the signal sent to the main process with the STOPSIGNAL instruction. For example, the nginx official image changes it to SIGQUIT, but the correct interpretation of this change depends of the container runtime.

### terminationGracePeriodSeconds

This setting is the time kubernetes waits before using that SIGKILL signal. Lets see some explanation about this setting:

- The terminationGracePeriodSeconds includes the time dedicated to the preStop hook and the SIGTERM.
- The default value is 30 seconds and it can be modified. If the preStop hook and SIGTERM need more time, increase it.
- If the process reaches the time defined in terminationGracePeriodSeconds while the preStop hook is being executed, kubelet extends this time 2 more seconds
- If you give to it the value zero, kubernetes uses inmediatly the SIGKILL signal.

### Note about race condition

Because the deletion from the endpoints and the pod termination are executed at the same time, we can have a race condition where the pod has been deletes but the endpoint exists. The system tries to send traffic to a pod that does not exists.

This can suggest **the preStop hook is a safer way** in that cases because it is executed **before the SIGTERM and endpoint removal**. There are another solutions like wait some seconds in the application's code where the SIGTERM is received in order to give time to the endpoint deletion, but that needed time can vary in every situation and maybe it is not the best option.

## Best practices

- A good readiness probe is a must in every container, it tells kubelet when the container is ready to accept incoming connections
- Your application must manage the SIGTERM signal in order to get a gracefulshutdown and do proper tasks.
- A preStop hook prevents a race condition. Some people say you must always use it.
- It is a decision to take, what must be included in the preStop hook and what the SIGTERM must do in the application.
- Configure a proper terminationGracePeriodSeconds for every application

## More info

- Pod Lifecycle  
<https://kubernetes.io/docs/concepts/workloads/pods/pod-lifecycle/>

- Pod Lifecycle spec  
<https://kubernetes.io/docs/reference/kubernetes-api/workload-resources/pod-v1/#lifecycle>

- Dockerfile reference: STOPSIGNAL
<https://docs.docker.com/reference/dockerfile/#stopsignal>

- Graceful shutdown in Kubernetes  
<https://learnk8s.io/graceful-shutdown>

- How to Gracefully Shutdown Your Apps with a preStop Hook
<https://www.youtube.com/watch?v=ahCuWAsAPlc>
