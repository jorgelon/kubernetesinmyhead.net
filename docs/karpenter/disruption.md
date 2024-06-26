# Disruption y borrado de nodos automaticos

Cuando Karpenter despliega un nodo le agrega un kubernetes finalizer **karpenter.sh/termination**

```shell
kubectl get node -o yaml | grep -A 1 finalizer
```

> Un nodo puede ser borrado de forma manual por un usuario o sistema externo borrando el nodo, el nodeclaim o el nodepool, pero aqui veremos los borrados automaticos hechos por Karpenter y el disruption controller

## Metodos de disruption

Los metodos de disruption de Karpenter son los siguientes

### Expiration

Es posible indicar la caducidad de los nodos de un nodepool, es decir, el tiempo maximo de vida mediante.

Se define a nivel de spec del nodepool mediante **spec.disruption.expireAfter** y el valor por defecto es de 720 horas (30 dias)
Un nodo que ha llegado a ese valor es candidato a ser interrumpido.  
Puede ser util por cuestiones de seguridad, parcheo o simple saneamiento del cluster.

### Drift (desvio)

Aqui Karpenter comprueba si hay nodos que no estan compliendo con el spec deseado y tratara de corregirlo.

> Drift es una feature habilitada por defecto desde la version v0.33.x de Karpenter

Para comprobar esta desviacion comparara diversos campos del NodePool y EC2NodeClass asociados al node claim.
Karpenter agrega una anotacion **karpenter.k8s.aws/ec2nodeclass-hash** con el hash del nodeclaim para descubrir posibles cambios en este.

| Component    | Field                           |
|--------------|---------------------------------|
| NodePool     | spec.template.spec.requirements |
| NodePool     | spec.weight                     |
| NodePool     | spec.limits                     |
| NodePool     | spec.disruption.*               |
| EC2NodeClass | spec.subnetSelectorTerms        |
| EC2NodeClass | spec.securityGroupSelectorTerms |
| EC2NodeClass | spec.amiSelectorTerms           |

Aclaraciones

- Si un nodeclaim tiene el requerimiento node.kubernetes.io/instance-type como [m5.large ]y pasa a [m5.large, m5.2xlarge] no forzara un drift ya que se sigue cumpliendo el mismo
- Si en la nodeclass se ha usado spec.amiSelectorTerms y se publica una ami mas reciente, karpenter considera el nodeclaim como drifted.
- Tambien Karpenter considerara un nodeclaim como drifter si se desvia de su propio nodepool
- Karpenter quitara el estado de drifted la feature drift no esta habilitada o si tiene ese estado de drift pero no hay desvio

### Consolidation

Es el metodo mediante el cual Karpenter trata de ahorrar costes mediante consolidacion. Para ello trata de buscar estas situaciones en las que se puede borrar un nodo:

- Porque esta vacio
- Deletion:  
Porque sus pods caben en otros nodos
- Replace:
Porque sus pods caben en otros nodos junto con el despliegue de otro mas barato

#### Politica

Se pueden elegir entre dos politicas en la definicion del nodepool **spec.disruption.consolidationPolicy**

- WhenEmpty:  
Solo considerara como consolidables nodos vacios
- WhenUnderutilized:  
Se consideran como consolidables si se pueden reducir costes

> Politicas de anti afinidad y topology spread por ejemplo reducen la efectividad de las consolidaciones

#### Consolidacion spot to spot

Para nodos spot, la consolidacion habilitada es deletion, no esta habilitada replace.
Para habilitarla hay que hacerlo mediante la feature flag|gate **SpotToSpotConsolidation**, ya que esta en version beta desde la version v0.34.x de Karpenter.

En caso de spot, el calculo del nodo nuevo se hace mediante la estrategia price-capacity-optimized. En ella se tiene en cuenta no solo el precio, sino tambien la posiblidad de ser interrumpida y requiere un minimo de 15 tipos de instancias candidatas. Mas informacion en los siguiente enlaces

- Disruption spot to spot:  
<https://karpenter.sh/docs/concepts/disruption/#spot-consolidation>

- Applying Spot-to-Spot consolidation best practices with Karpenter  
<https://aws.amazon.com/blogs/compute/applying-spot-to-spot-consolidation-best-practices-with-karpenter/>

- Introducing the price-capacity-optimized allocation strategy for EC2 Spot Instances
<https://aws.amazon.com/blogs/compute/introducing-price-capacity-optimized-allocation-strategy-for-ec2-spot-instances/>

### Interruption

El cuarto metodo de disruption sucede cuando Karpenter detecta estos eventos en los nodos:  

- avisos de que un nodo spot va a ser borrado por aws
- eventos de mantenimiento
- eventos de borrado de instancia
- eventos de apagado de instancia

En cuanto detecta uno de estos events, karpenter le hace un drain, taint y borrado del nodo.

Como el tiempo puede ser reducido, en el caso de spot interruption warnings es de 2 minutos, toma mas valor el valor **terminationGracePeriod** de los pods, que por defecto es de 30 segundos.  
> Para que Karpenter reciba estos eventos sera necesario usar una cola SQS y 4 reglas EventBridge, asi como configurar dicha cola en karpenter.

## Proceso de disruption

## Disruption Budgets

Sirve para controlar cuando se pueden hacer disrupciones automaticas y con cuantos nodos en paralelo.
Nos referimos a disruption budgets de nodepools y se definen en "spec.disruption.budgets".  
El numero de nodos puede ser un porcentaje maximo (por defecto es 10%) de nodos interrumpibles a la vez o un numero de nodos exactos.
La planificacion es un schedule en formato cron.

> Se pueden indicar varios budgets, los cuales deberan cumplirse siempre. Una opcion es indicar 0 nodos en determinados horarios donde no queremos que haya interrupciones.

<https://karpenter.sh/docs/concepts/disruption/#disruption-budgets>

### Para ver los eventos de los nodos

```shell
kubectl get events --all-namespaces --field-selector involvedObject.kind=Node
```

## Links

- Disruption  
<https://karpenter.sh/docs/concepts/disruption/>

- Graceful node shutdown  
<https://kubernetes.io/docs/concepts/architecture/nodes/#graceful-node-shutdown>

- Api Eviction  
<https://kubernetes.io/docs/concepts/scheduling-eviction/api-eviction/>

- Interruption Handling  
<https://karpenter.sh/docs/reference/cloudformation/#interruption-handling>
