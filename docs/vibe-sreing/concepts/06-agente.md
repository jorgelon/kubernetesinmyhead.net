# Agente

El bucle que junta [LLM](01-llm.md), [tools](04-tools.md) y contexto para perseguir
un objetivo en varios pasos.

```txt
llamada al LLM > pide tools? > se ejecutan > el resultado se añade al contexto > vuelta a empezar
                     |
                     no > respuesta final
```

Lo que convierte un LLM en agente:

- Bucle: itera hasta cumplir el objetivo, no da una sola respuesta
- Tools: puede consultar y actuar sobre el mundo real
- Gestion del contexto: compacta o resume cuando la ventana se llena
- Autonomia acotada: el modelo decide que paso dar, los permisos deciden si puede

El modelo sigue siendo el mismo LLM inmutable y sin estado. El agente es el
programa que lo llama en bucle y le va construyendo el contexto.
