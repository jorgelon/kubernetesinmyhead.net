# External Secret spec

## Elegir el secret store

Para elegir el secret store del cual traernos los secretos se usa spec.secretStoreRef, donde spec.secretStoreRef.name sera el nombre y spec.secretStoreRef.kind el tipo de secret store (SecretStore o ClusterSecretStore)

## Datos a traernos del proveedor

Para traernos los secrets podemos usar:

- spec.dataFrom para traernos todas las properties de la key
- spec.data para elegir cuales traernos

### Data (spec.data)

Data permite especificar la relacion entre las keys del secret a crear y el dato almacenado en el proveedor. Asi, dentro de cada una de las relaciones declaradas podemos especificar

**secretKey** es el nombre que le damos a esta relacion

**remoteRef** especifica que dato traernos del proveedor

- key: Es valor mas importante, porque es realmente la clave a traerse
- conversionStrategy: Default | Unicode
- decodingStrategy: Para elegir si la clave es codificada en el proveedor y debe ser descodificada o no. Opciones: None | Auto | Base64 | Base64URL

- metadataPolicy: Si queremos traernos tags o labels. Puede ser None (por defecto) o Fetch
- property: Si queremos traernos una property concreta (depende del proveedor)
- version: Si queremos traernos una version concreta (depende del proveedor)

**sourceRef** permite especificar un secret store diferente al de spec.secretStoreRef y es obligatorio si este ultimo no existe. Se declara mediante  storeRef.name y storeRef.kind

### Data (spec.dataFrom)

Pendiente

## Secret a crear (spec.target)

Se hace mediante spec.target elegimos que secret y como crearlo.

### Name

spec.target.name permite elegir el nombre del secret a crear. Si no se especifica, sera el nombre del externalsecret

### creationPolicy

spec.target.creationPolicy sirve para elegir de forma se crea el secret

- **Owner** es el valor por defecto. External secrets operator le pone al secret un ownerReference y lo hace susceptible del garbage colector de Kubernetes.

> Si al intentar crear el secret se encuentra uno ya existente con otro ownerReference, se genera un conflicto y falla.  
> Si al intentar crear el secret se encuentra uno ya existente sin ownerReference, le pone un ownerReference y lo actualiza

- **Orphan** lo crea sin ownerReference y queda fuera del garbage colector de Kubernetes

- **Merge** no crea ningun secret, sino que espera que ya exista y hacer un merge

- **None** no hace nada

### deletionPolicy

spec.target.deletionPolicy permite elegir que hacer con el secret **cuando se borra el secret en el proveedor de secretos**.

- Retain es el valor por defecto y mas cauteloso. Mantiene el secret creado y el externalsecret entra en estado SecretSyncedError

- Delete borra el secret y el externalsecret no se considera como fallido ni tendra el estado SecretSyncedError. Tambien ocurre al crear un nuevo external secret con esta opcion si falla al mapear con el secret del proveedor.

- Merge borra las entradas del secret, pero no el secret en si. Al igual que con delete, o se considera como fallido ni tendra el estado SecretSyncedError.

### immutable

spec.target.immutable permite hacer inmutable el secret

### Template

Pendiente

## Otras configuraciones

- spec.refreshInterval  
Permite especificar cada cuanto leer los valores del provider. Se puede expresar en varias unidades como "s", "m" o "h" y esta basado en time.ParseDuration de go

> El valor por defecto es una hora  
> Si se configura a 0, el valor se trae solo una vez al crearse

## Ejemplo

```yaml
apiVersion: external-secrets.io/v1beta1
kind: ExternalSecret
metadata:
  name: myexternalsecret
spec:
  data:
  - remoteRef:
      key: mipassword # key de secret store donde buscar el valor
    secretKey: mikey # key a escribir en el secret
  refreshInterval: 1h # cada cuanto leer el secret del proveedor
  secretStoreRef:  # especificar el secret store del cual obtener los datos
    kind: ClusterSecretStore
    name: nombredelsecretstore
  target:  # definicion del secret a crear
    name: secret # nombre del secret a crear. si o se especifica, sera el nombre del external secret
    creationPolicy:  # Owner (por defecto) Merge o None
    deletionPolicy:     # Delete, Merge, Retain
```

## Links

- ExternalSecret  
<https://external-secrets.io/latest/api/externalsecret/>

- Lifecycle  
<https://external-secrets.io/latest/guides/ownership-deletion-policy/>

- Decoding strategy  
<https://external-secrets.io/latest/guides/decoding-strategy/>
