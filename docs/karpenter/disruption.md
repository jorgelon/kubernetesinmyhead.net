# Disruption

Karpenter dispone de 3+1 metodos automaticos para interrumpir un nodo y, si es necesario, reemplazarlo. El orden de comprobacion es:

- Expiration
- Drift
- Consolidation

Adicionalmente tambien existe otro metodo llamado Interruption  

> Es posible borrar nodos de forma manual borrando el nodo, el nodeclaim o el nodepool

## Metodos automaticos

### Expiration

Se puede establecer el tiempo maximo de vida de un nodo, lo que puede ser util por cuestiones de seguridad o limpieza.
Esto se hace configurando el valor "spec.disruption.expireAfter" dentro de un nodepool.

> El valor por defecto es 720h (un mes)

Un nodo que ha llegado a ese valor es candidato a ser interrumpido

### Drift

Aqui Karpenter comprueba si hay nodos que no estan compliendo con el spec deseado y tratara de corregirlo

### Consolidation

Con este metodo Karpenter trata de reducir costos borrando nodos cuando se dan alguno de estos supuestos:  

- El nodo esta vacio  
- Los pods del nodo caben en otros nodos  
- El nodo puede ser reemplazado por uno mas barato  

> Mediante el valor spec.disruption.consolidationPolicy dentro de un nodepool se puede elegir si se quiere que solo se consideren nodos como candidatos a ser consolidables los vacios (WhenEmpty) o todos los que pueden reubicarse los pods en otros nodos (WhenUnderutilized), que es el valor por defecto

Para ello tiene 2 mecanismos:

- Deletion: si los pods del nodo caben en otros
- Replace: si los pods de nodo caben en otros nodos y agregando uno nuevo mas barato

Orden

- Primero se borran en paralelo los nodos vacios  
- Luego se intentan borrar varios nodos consolidables y levantando uno nuevo si es necesario  
- Lo mismo pero un nodo suelto  

> La forma de consolidar nodos spot por defecto es "Delete". Si se quiere usar "Replace" hay que habilitar la feature flag "SpotToSpotConsolidation" aunque puede no llegar a ejecutarse, por ejemplo, si karpenter cree que el cambio puede supone mayores posibilidades de interrupciones.

## Proceso automatico (disruption controller)

- Karpenter comprueba si hay nodos que pueden ser interrumpidos por el primer metodo. Si no hay ninguno o hay pods que no pueden ser desalojados del candidato o candidatos, se pasa al siguiente metodo.

> Los pod disruption budget son una de las causas habituales de que un pod no pueda ser desalojado de un nodo

- Seguidamente Karpenter comprueba si se esta respetando el disruption budget del nodepool (ver mas adelante)
- Tambien se hace una simulacion para saber si hacen falta nodos nuevos
- Agrega un taint al nodo elegido (karpenter.sh/disruption:NoSchedule)
- Si hace falta nodos nuevos los crea y espera a que esten listos
- Borra el nodo y espera a que el termination controller lo apague. Cuando lo haga , vuelve a empezar

## El termination controller

El termination controller actua cuando el nodo es borrado y hace uso del "Kubernetes Graceful Node Shutdown"

> Cada nodo tiene un karpenter finalizer que bloquea el borrado.

En el proceso, agrega un taint, desaloja los pods mediante la "Kubernetes Eviction API", borra el nodeclaim y borra el finalizer del nodo para permitir al api server borrar el nodo.

## Disruption Budgets

Nos referimos a disruption budgets de nodepools y se definen en "spec.disruption.budgets".  
Sirve para controlar la velocidad de interrupcion de nodos. Se puede hacer indicando un porcentaje maximo de nodos interrumpibles a la vez o un numero de nodos exactos.

Tambien es posible poner una programacion al definir un budget.

> Se pueden indicar varios budgets, los cuales deberan cumplirse siempre. Una opcion es indicar 0 nodos en determinados horarios donde no queremos que haya interrupciones.

## Interruption

Sucede cuando Karpenter detecta eventos como:  

- avisos de que un nodo spot va a ser borrado por aws (hay 2 minutos de aviso)
- eventos de mantenimiento
- eventos de borradod de instancia
- eventos de apagado de instancia

Para habilitarlo hay que habilitar la opcion "interruption-queue-name" que requiere crear una cola en Amazon SQS y 4 reglas en Amazon EventBridge

## Links

- Disruption  
<https://karpenter.sh/docs/concepts/disruption/>

- Graceful node shutdown  
<https://kubernetes.io/docs/concepts/architecture/nodes/#graceful-node-shutdown>

- Api Eviction  
<https://kubernetes.io/docs/concepts/scheduling-eviction/api-eviction/>

- Interruption Handling  
<https://karpenter.sh/docs/reference/cloudformation/#interruption-handling>
