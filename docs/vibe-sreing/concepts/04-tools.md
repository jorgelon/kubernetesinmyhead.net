# Tool

Una funcion que se define y que el modelo puede pedir que se ejecute. Resuelve
que el LLM solo genera texto: sin tools no puede consultar ni cambiar nada del
mundo real.

```txt
contexto + catalogo de tools > el modelo pide una tool > el codigo la ejecuta > el resultado vuelve al contexto
```

El modelo no ejecuta nada. Solo escribe que quiere ejecutar algo, y con que
parametros. Quien ejecuta es el programa que lo envuelve, y ahi viven los
permisos.

- Que se entiende por funcion:

Cualquier trozo de codigo ejecutable, con entradas y una salida. Puede ser un
comando, una llamada a una API REST, una consulta a base de datos o leer un
fichero.

Lo que la convierte en tool es declararla para el modelo: nombre, descripcion y
parametros que acepta. Con eso el modelo sabe que existe y cuando pedirla.

El protocolo estandar para exponer tools es [MCP](05-mcp.md).
