# Retrieval-Augmented Generation (RAG)

Es una tecnica que permite enriquecer el contexto en base a fuentes externas, que
el modelo desconoce.

```txt
pregunta > busqueda > fragmentos relevantes > contexto > modelo
```

Tiene dos fases:

- Indexado, previo: los documentos se parten en fragmentos, se convierten a
  vectores (embeddings) y se guardan en una base de datos vectorial
- Consulta, en cada pregunta: la pregunta se convierte a vector, se buscan los
  fragmentos mas parecidos y se añaden al contexto

RAG no entrena ni modifica el modelo. Solo le pone delante el texto que necesita.

- Cuando ocurre la busqueda:

Hay dos formas:

- RAG clasico: la aplicacion busca siempre, antes de llamar al modelo. El modelo
  no decide nada
- Busqueda como [tool](04-tools.md): el modelo pide la busqueda cuando la
  necesita, ya dentro del bucle. Ocurre entre llamadas al LLM, no antes de la
  primera
