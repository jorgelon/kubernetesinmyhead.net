# Diferencias entre reiniciar deployment y un rollout

## Reiniciar un deployment

La forma de reiniciar un deployment via kubectl es mediante este comando

```shell
kubectl rollout restart -n nombre_del_namespace nombre_del_deployment
```

Esto agrega una anotacion en la specificacion del pod template del deployment

```txt
kubectl.kubernetes.io/restartedAt: "fecha y hora"
```

Esta anotacion dispara un nuevo rollout, el cual crea un replicaset nuevo y una nueva version de la aplicacion que se puede observar como anotacion del mismo replicaset

```txt
deployment.kubernetes.io/revision
```

Y asi poco a poco y, por defecto mediante un rolling update, se reemplazan de forma gradual todas las instancias de los pods que lo componen.

## Reiniciar un rollout (Argo rollouts)

Suponiendo que el binario se llama kubectl-argo-rollouts, el comando para reiniciar argo rollouts seria:

```shell
kubectl-argo-rollouts rollout restart -n nombre_del_namespace nombre_del_deployment
```

Sin embargo un reinicio de un rollout borra los pods del mismo replicaset y sera el deployment controller el que los reemplace, siempre dentro del mismo replicaset.

Esto implica que por ejemplo si el rollout solo tiene una replica, habra perdida de servicio
Tambien es potencialmente un proceso mas lento ya que no se tiene en cuenta maxSurge, aunque si maxUnavailable. Si su valor es 0, el restart sera de uno en uno.

## Restart con Stakater Reloader?

Con reloader sin embargo el comportamiento es diferente.
En Argo Rollouts es posible crear un rollout que incluya la logica del rollout ademas del deployment en si.
Tambien es posible separarlos y crear un rollout por un lado  con su logica y que referencie a un deploy ya existente.

En el caso de que el reload de Reloader se aplique a un rollout de Argo Rollouts, hay que habilitar en su configuracion que los soporte, fuerza una nueva version del rollout

En el caso de aplicarlo al deployment referenciado por el rollout

## Links

- Deployments  
<https://kubernetes.io/docs/concepts/workloads/controllers/deployment/>

- Rolling updates  
<https://kubernetes.io/docs/tutorials/kubernetes-basics/update/update-intro/>

- Replicasets  
<https://kubernetes.io/docs/concepts/workloads/controllers/replicaset/>

- Restart a deployment  
<https://kubernetes.io/docs/reference/kubectl/generated/kubectl_rollout/kubectl_rollout_restart/>

- Restart a rollout  
<https://argo-rollouts.readthedocs.io/en/stable/features/restart/>

- Stakater Reloader  
<https://github.com/stakater/Reloader>
