# Large Language Models (LLM)

Un LLM es un sistema que ha sido entrenado con grandes cantidades de informacion.
Dicho LLM es capaz de recibir un contexto y predecir una salida.

Todo gira en torno al texto:

- El entrenamiento del LLM se hace mediante texto
- El contexto recibido y la salida tambien son texto

```txt
contexto > modelo > salida (prediccion)
```

## Pesos

Los numeros internos del modelo. Se generan durante el entrenamiento y a partir
de ahi son fijos: usar el modelo no los altera.

En la formula `y = 3x + 5`, el `3` y el `5` son numeros fijos que definen como se
comporta. Esos son los pesos. Un LLM es la misma idea con miles de millones de
numeros en lugar de dos.

Su cantidad da nombre al modelo (7B, 70B) y determina cuanta memoria ocupa y lo
que cuesta cada prediccion.

- No son respuestas guardadas:

Los pesos no contienen respuestas, sino la maquinaria que las calcula. No hay una
tabla dentro que se consulte, y por eso el modelo puede generar texto que nunca ha
visto.

Tambien por eso alucina: una maquina de calcular siempre calcula algo, aunque no
tenga la informacion.

- Comparacion:

Una mesa de mezclas con miles de millones de mandos. Los pesos son la posicion de
cada mando, ajustada hasta que suena bien. No hay un mando llamado "voz nitida":
el resultado sale de todos a la vez.

- Knowledge cutoff:

La fecha en la que se congelo el conocimiento del modelo, que es cuando se
entreno. No conoce nada posterior.

## Tokens

> Realmente no se usa texto como tal, sino tokens. Un token es la unidad minima
> de texto que maneja el modelo: un trozo que puede ser una palabra completa,
> parte de una palabra o un signo de puntuacion. El modelo trabaja con
> identificadores de esos tokens.

```txt
texto > token > identificadores de token <<< esto es lo que ve el modelo
```

- Tokenizador:

La conversion de texto a token la hace un tokenizador, que se entrena antes que el
modelo y por separado. En la practica cada familia de modelos tiene su propio
tokenizador, asi que el mismo texto no cuesta los mismos tokens en Claude que en
GPT o en Gemini. Los contadores de tokens son especificos del modelo.

- Inmutable y sin estado:

Un LLM es inmutable. Usar dicho LLM no lo modifica ni almacena nada de la peticion
anterior. No recuerda la conversacion, no tiene memoria. La memoria se situa fuera
del LLM.

## Contexto

Los tokens que el modelo recibe como entrada, y sobre los que predice. Tiene dos
partes:

- Lo que se le manda: instrucciones, historial de la conversacion y documentos
- Lo que el mismo ha generado hasta ese momento en la respuesta en curso

- Ventana de contexto:

El limite de tokens que caben en el contexto, contando entrada y salida.

Como el LLM no tiene memoria, el historial completo se reenvia en cada peticion.
Por eso el contexto se llena, y al llenarse hay que resumirlo o recortarlo
(compactacion).

## Prediccion

El modelo predice un token cada vez. Cada token generado se añade al contexto y
la prediccion siguiente ya lo incluye. Esto se llama autoregresivo.

```txt
contexto > predice token > se añade al contexto > predice el siguiente > ...
```

La salida del modelo vuelve a entrar como entrada. Por eso lo que ya ha escrito
condiciona lo que escribira despues.

El caso mas visible es el razonamiento (thinking): el modelo genera texto para si
mismo antes de responder. Ese texto ocupa contexto y guia la respuesta final,
aunque no sea la respuesta.

- Cuando para:

El modelo predice un token especial de fin, que aprendio en el entrenamiento a
colocar donde el texto termina. El cliente tambien puede cortar antes:

- `max_tokens`: limite de tokens de salida
- Stop sequences: cadenas que, si aparecen, detienen la generacion

- Sampling:

El modelo no predice un unico token, sino la probabilidad de cada token posible.
Elegir uno de ellos es el sampling, y se controla con la temperatura:

- Temperatura baja: coge casi siempre el mas probable. Determinista
- Temperatura alta: permite tokens menos probables. Mas creativo

Por eso la misma pregunta puede dar respuestas distintas.

- Alucinacion:

El modelo no tiene el concepto de "no lo se". Su trabajo es dar la continuacion
mas plausible, asi que ante algo que no sabe genera algo verosimil en lugar de
admitir que lo ignora.

## Fine-tuning

Reentrenar un modelo ya entrenado con datos propios, para producir un modelo
nuevo.

```txt
modelo base + datos propios > entrenamiento > modelo nuevo
```

Se usa para fijar formato, tono o comportamiento. No para meter conocimiento
nuevo: para eso es mejor [RAG](03-rag.md), porque los datos se actualizan sin
reentrenar.

El fine-tuning no modifica el modelo en uso, crea otro. El modelo resultante
sigue siendo inmutable y sin estado.
