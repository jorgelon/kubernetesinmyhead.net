# Inferencia

Usar el modelo, frente a entrenarlo. Es lo que ocurre en cada peticion.

## Estructura de la peticion

El contexto no se manda como un texto plano, sino como una lista de mensajes con
rol:

- `system`: instrucciones fijas de como debe comportarse
- `user`: lo que dice el usuario
- `assistant`: lo que respondio el modelo en turnos anteriores

```txt
[system, user, assistant, user, ...] > modelo > nuevo mensaje assistant
```

Esa lista es la forma concreta que tiene el [contexto](01-llm.md#contexto). Se
manda entera en cada peticion, porque el modelo no tiene memoria.

Junto a los mensajes van los parametros (`temperature`, `max_tokens`) y las
[tools](04-tools.md) declaradas.

- Streaming:

La respuesta se puede recibir token a token, en lugar de esperar a que termine. No
cambia el resultado, solo cuando se ve.

## Servidor de inferencia

El software que carga los pesos y los sirve por API. Hace falta si se usa un
modelo open weights, es decir, con los pesos publicados y descargables.

|          | vLLM                              | Ollama                   |
|----------|-----------------------------------|--------------------------|
| Para que | Produccion, alto rendimiento      | Local, en el portatil    |
| Hardware | GPU, varias                       | CPU o GPU pequeña        |
| Modelos  | Precision completa                | Cuantizados por defecto  |
| Uso      | Servir a muchos usuarios a la vez | Probar cosas, desarrollo |

Los dos exponen una API compatible con la de OpenAI, asi que un agente que hable
con OpenAI puede apuntar a ellos cambiando la URL. De ahi que los agentes sean
portables entre proveedores.

La alternativa a servirlo uno mismo es un proveedor gestionado, como Bedrock o
Vertex, o directamente la API del fabricante.

- Cuantizacion:

Reducir la precision de los pesos para que ocupen menos memoria, a cambio de algo
de calidad. Es lo que permite servir un modelo grande en una GPU pequeña.

## Coste

Se factura por tokens, con precio distinto para los de entrada y los de salida.
Los de salida suelen ser bastante mas caros.

Como el historial completo se reenvia en cada peticion, el coste por turno crece
con la longitud de la conversacion.

- Prompt caching:

El servidor guarda el computo del principio del contexto, que no cambia entre
peticiones, y lo reutiliza. Abarata y acelera las conversaciones largas.

No es memoria del modelo: hay que seguir enviando el contexto completo. Solo evita
recalcularlo.

## Latencia

Dos medidas distintas:

- Tiempo hasta el primer token: cuanto tarda en empezar a responder
- Tokens por segundo: a que velocidad genera el resto
