# Model Context Protocol (MCP)

Es un protocolo abierto liberado por Anthropic en 2024

<https://github.com/modelcontextprotocol>

Sirve para exponer [tools](04-tools.md) de forma estandar, y que sean reutilizables
entre clientes y modelos distintos. Resuelve que cada cliente tuviera que programar
sus propias integraciones: de N clientes x M integraciones se pasa a N + M.

Es cliente-servidor:

- Cliente: quien usa el modelo (Claude Code, un IDE, una aplicacion)
- Servidor: un proceso que expone capacidades

```txt
cliente MCP > (stdio o http) > servidor MCP > tools, resources, prompts
```

Un servidor expone tres cosas:

- Tools: acciones ejecutables. Las pide el modelo
- Resources: datos de solo lectura. Los elige la aplicacion o el usuario
- Prompts: plantillas reutilizables. Las elige el usuario

MCP es solo el transporte y el contrato. Detras puede haber un [RAG](03-rag.md),
una API o un comando local.
