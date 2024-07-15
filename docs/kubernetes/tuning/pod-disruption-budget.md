# Pod disruption budget

Pod disruption budget, estable desde kubernetes 1.21, existe para ofrecer un mayor control sobre operaciones que suponen desalojos (disruptions) voluntarios sobre deployments o statefulsets principalmente.

> Podemos definir disruption como "interrupcion" y eviction como "desalojo"

El ejemplo mas tipico es al hacer un drain de un nodo, ya sea de forma manual o mediante herramientas como Cluster Autoescaler o Karpenter. PDB permite establecer un maximo de replicas que pueden no estar disponibles durante el proceso o bien un minimo de replicas que deben estar disponibles durante la operacion. De esta forma se "pausa" el drain hasta que no se hayan levantado las suficiente replicas en otros nodos.

> Esto es debido a que "drain" para funcionar utiliza la Eviction API, la cual respeta estos PDB. Borrar un pod no lo hace.

## Creacion de un PDB

La creacion de un pdb tiene las siguientes configuraciones:  

- Selector  
Primeramente debemos elegir a que pods aplica el pdb mediante un clasico label selector (matchLabels o matchExpressions)

- Definir el comportamiento  
Aqui podemos elegir si queremos un minimo de replicas levantadas (minAvailable) o un maximo de replicas no disponibles (maxUnavailable). Son configuraciones excluyentes.

Podemos especificar este valor mediante un numero

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: integer
spec:
  minAvailable: 5
  selector:
    matchLabels:
      app: myapp
```

o bien un porcentaje

```yaml
apiVersion: policy/v1
kind: PodDisruptionBudget
metadata:
  name: percentage
spec:
  maxUnavailable: 30%
  selector:
    matchLabels:
      app: myapp
```

- unhealthyPodEvictionPolicy
Por defecto, pdb cuenta un pod como "healthy" cuando su status es type="Ready" y status="True".

Con unhealthyPodEvictionPolicy, feature en beta desde kubernetes 1.27, se puede cambiar el criterio sobre como actuar sobre "unhealthy" pods.

Con el valor **IfHealthyBudget**, que es por defecto, permite que pods que esten levantados pero no healthy puedan ser desalojados solo cuando se este respetando los criterios del PDB.
Este valor puede afectar negativamente a acciones voluntarias cuando tenemos aplicaciones con un mal funcionamiento (estado CrashLoopBackOff) o que reportan de forma incorrecta su estado Ready y cuentan con una proteccion via pdb.

El valor **AlwaysAllow** permite permite que pods que esten levantados pero no healthy puedan ser desalojados independientemente si se cumplen o no los criterios del PDB. Esta opcion es mas agresiva y se comporta mejor en los supuestos antes descritos.

## Estado de un pdb

El estado (.status) de un recurso pdb tiene varios campos

- **currentHealthy** es el numero de pods considerados actualmente como healthy
- **desiredHealthy** es el numero minimo de pods healthy que debe haber
- **disruptionsAllowed** es el numero de disruptions (interrupciones) permitidas

> Un pdb protege una aplicacion haciendo que su .status.currentHealthy no sea inferior a .status.desiredHealthy poniendo el disruptionsAllowed a 0

- **expectedPods** es el numero de pods que se esperan que esten healthy
- **conditions** nos muestra si nay mas pods que los requeridos por el pdb y se permiten interrupciones (SufficientPods) o no (InsufficientPods)
- **disruptedPods** muestra los pods marcados para ser desalojados pero que aun no han sido matados. Es basicamente un listado de los pods que van a ser desalojados. Este listado deberia estar vacio normalemente. Si se mantiene con varias entradas puede haber problemas de borrado de pods

## Algunas recomendaciones

- Tener un numero alto de replicas para una aplicacion stateless puede sugerir el uso de minAvailable con un porcentaje
- En aplicaciones stateless con pocas replicas se puede recurrir al uso de enteros
- En aplicaciones stateful hay que alinear la configuracion con la naturaleza de la misma. Por ejemplo en 5 replicas poner minAvailable a 3 o maxUnavailable a 2.
- Aplicaciones con una sola replica puede ser recomendable o no usar pdb y asumir la perdida de servicio en las interrupciones voluntarias, o bien poner un pdb con maxUnavailable=0 para, de entrada, bloquear la interrupcion y hacer una intervencion manual, como borrar el pdb.
- Valores muy restrictivos perjudican las interrupciones voluntarias y valores muy agresivos pueden no proteger lo suficiente la aplicacion.
- Utilizar unhealthyPodEvictionPolicy AlwaysAllow en aplicaciones con frecuentes CrashLoopBackOff y que queramos proteger mediante pdb

## Links

- Disruptions  
<https://kubernetes.io/docs/concepts/workloads/pods/disruptions/>

- Specifying a Disruption Budget for your Application  
<https://kubernetes.io/docs/tasks/run-application/configure-pdb/>

- PodDisruptionBudget Spec  
<https://kubernetes.io/docs/reference/kubernetes-api/policy-resources/pod-disruption-budget-v1/>

- Safely Drain a Node  
<https://kubernetes.io/docs/tasks/administer-cluster/safely-drain-node/>

- API-initiated Eviction  
<https://kubernetes.io/docs/concepts/scheduling-eviction/api-eviction/>
