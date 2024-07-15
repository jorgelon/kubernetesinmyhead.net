# CPU requests y limits

## CPU request

Asignar un valor de cpu request a un contenedor tiene estas implicaciones principales:

- Kube scheduler asignara a ese pod un nodo del cluster que tenga al menos esa cantidad de recursos disponibles. Si ningun nodo la tiene, el pod se queda sin desplegarse, en espera a que la haya.

- Una vez en el nodo, el contenedor tendra garantizado ese valor de cpu en el nodo, que no podra ser asignado a otros.

- Ademas, el valor de cpu request se tiene en cuenta a la hora de que los contenedores se disputen el computo sobrante de un nodo. De esta forma, un contenedor con 500m de cpu requests tendra el doble de prioridad que uno con 250m intentando obtener el maximo de cpu que pueda. Es decir, cpu request es ademas un peso. Este maximo de cpu que puede lograr vendra dado por la capacidad del nodo o, si el container tiene cpu limit, por dicho limite.

- El valor de cpu request se tiene en cuenta para el horizontal pod autoescaler

## CPU limit

Definir en un contenedor un cpu limit supone la maxima cantidad de cpu time que un contenedor puede utilizar. CPU se considera en kubernetes un recurso comprimible (compressible) lo que significa que, si un contenedor con limite llega a esta cantidad, aparece el denominado **cpu throttling**.
No se libera cpu matando el contenedor, sino que la tarea tendra que **esperar a que haya cpu mas tarde**.

Con ello se ve **perjudicada la latencia y rendimiento** del mismo, y pueden aparecer **situaciones indeseadas e incontroladas**, como el fallo en las probes. Ademas supone que si hay mas recursos dentro del nodo, el contenedor con cpu limit no puede acceder a ellos (infrautilizacion).

Pero definir limits permite asegurar que un contenedor **no pueda usar demasiados recursos** y afectar al resto.
No definir cpu limits permite un **mejor aprovechamiento de los recursos** del nodo.

> El valor de un cpu request o limit se puede establecer a nivel de contenedor ya sea por numero de milicores o por una fraccion. Asi, 500m es lo mismo que 0,5 (media cpu).

## El valor en practica

El valor de cpu request y limit tiene que ver con cuanto tiempo de cpu dispone un pod cada 100 milisegundos, que es el valor por defecto de **cpu_period_us** del kernel de linux (100000us o 100ms). El valor del limite sera el valor de **cpu.cfs_quota_us** para el cgroup del container.

**Ejemplo**
Por ejemplo, un contenedor con 100m (o 0,1 de request) tendra garantizados 10 milisegundos (0.1 x 100).  
Supongamos tambien que para ejecutar una tarea necesitara 50 ms. Sin cpu limit podra acceder a esos 10ms y, si hay disponibles recursos en el nodo, a los otros 40 que necesita dentro del mismo ciclo.

Supongamos que ahora tiene un limite en 0.2. En este caso necesitara 3 ciclos de cpu time (20+20+10) para poder realizarla, independientemente del estado del nodo.

Y eso es en un ejemplo donde hay un cpu y es solo un hilo para esa tarea. En multihilo y varias cpu, ese limite se reparte entre los cores.
En 2 cpu, consumiria la cuota en 0.1ms sin poder hacer uso del 0.9 restante. A mas cores, mas rapido consume la cuota (limit).

> Cuando defines un cpu limit pero no un request, kubernetes entiende que el valor para request es tambien el del limit.

## Algunas conclusiones y directrices

- Es necesario obtener informacion para una correcta observacion y analisis, por lo que debemos servirnos de un sistema de monitorizacion y utilidades como Goldilocks (vpa) o Robusta KRR.

- Siempre hay que definir un valor de cpu request para cada container, teniendo en cuenta lo que implica. Con ello ademas se evita la qos class besteffort.

- Algunas voces recomiendan no utilizar cpu limits. Aqui se da prioridad al rendimiento y como medida el establecer valores de cpu requests apropiados para proteger a los contenedores. Incluso hay quien habla de deshabilitarlo en kubelet mediante cpuCFSQuota=0.

- En segun que entornos se puede reducir el cpu_period_us para que los ciclos sean mas cortos

- Establecer cpu limits da mas prioridad a la proteccion de los nodos y otros contenedores frente a cargas de trabajo excesivas, asi como a tener un entorno controlado en ese sentido.

- Estudiar la posibilidad de usar autoescalados como horizontal pod autoescaler o Keda

- Estudiar el uso de vertical pod autoescaling en aplicaciones sin replicas

Dependiendo del entorno o caso, puede tener mas sentido uno definir o no cpu limits.

## Links

- Resource Management for Pods and Containers  
<https://kubernetes.io/docs/concepts/configuration/manage-resources-containers/>

- Assign CPU Resources to Containers and Pods  
<https://kubernetes.io/docs/tasks/configure-pod-container/assign-cpu-resource/>

- Pod Overhead  
<https://kubernetes.io/docs/concepts/scheduling-eviction/pod-overhead/>

- For the Love of God, Stop Using CPU Limits on Kubernetes  
<https://home.robusta.dev/blog/stop-using-cpu-limits>

- For the love of god, learn when to use CPU limits on Kubernetes  
<https://medium.com/@eliran89c/for-the-love-of-god-learn-when-to-use-cpu-limits-on-kubernetes-2225341e9dbd>

- Why You Should Keep Using CPU Limits on Kubernetes  
<https://dnastacio.medium.com/why-you-should-keep-using-cpu-limits-on-kubernetes-60c4e50dfc61>

- Kubernetes resources under the hood – Part 1  
<https://directeam.io/blog/kubernetes-resources-under-the-hood-part-1/>

- Kubernetes resources under the hood – Part 2  
<https://directeam.io/blog/kubernetes-resources-under-the-hood-part-2/>

- Kubernetes resources under the hood – Part 3  
<https://directeam.io/blog/kubernetes-resources-under-the-hood-part-3/>

### Tools

- Kube capacity  
<https://github.com/robscott/kube-capacity>

- Robusta KRR  
<https://github.com/robusta-dev/krr>

- Goldilocks  
<https://github.com/FairwindsOps/goldilocks>
