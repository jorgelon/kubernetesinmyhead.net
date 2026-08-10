# Intro to vibe sreing

Los conceptos basicos (LLM, inferencia, RAG, tools, MCP, agente) estan en
[concepts](concepts/index.md).

## Ai Agents / Assistants

Agentes de terminal:

| Agent                 | Company   | Licencia    | URL                                              |
|-----------------------|-----------|-------------|--------------------------------------------------|
| Claude Code           | Anthropic | Propietaria | <https://www.anthropic.com/claude-code>          |
| Codex CLI             | OpenAI    | Open source | <https://openai.com/codex/>                      |
| Gemini CLI            | Google    | Apache 2.0  | <https://github.com/google-gemini/gemini-cli>    |
| Github Copilot CLI    | Microsoft | Propietaria | <https://github.com/features/copilot/cli>        |
| OpenCode              | Comunidad | MIT         | <https://github.com/sst/opencode>                |
| Aider                 | Comunidad | Apache 2.0  | <https://aider.chat/>                            |
| Goose                 | Block     | Apache 2.0  | <https://block.github.io/goose/>                 |
| Amazon Q Developer    | AWS       | Propietaria | <https://aws.amazon.com/q/developer/>            |
| Warp                  | Warp      | Propietaria | <https://www.warp.dev/>                          |
| MiniMax Code          | MiniMax   | Propietaria | <https://www.minimax.io/>                        |

Basados en IDE:

| Agent                              | Company   | URL                                                               |
|------------------------------------|-----------|-------------------------------------------------------------------|
| Cursor                             | Anysphere | <https://cursor.com/>                                             |
| Windsurf (formerly codeium)        | Cognition | <https://windsurf.com/>                                           |
| Vscode + Github copilot agent mode | Microsoft | <https://code.visualstudio.com/docs/copilot/chat/chat-agent-mode> |
| Antigravity                        | Google    | <https://antigravity.google/>                                     |
| Vscodium                           | N/A       | <https://vscodium.com/>                                           |

Notas:

- Casi todos soportan [MCP](concepts/05-mcp.md), asi que un servidor MCP funciona
  en cualquiera de ellos con la misma configuracion
- El acceso gratuito de Gemini CLI para particulares acabo el 18 de junio de 2026,
  con la transicion hacia Antigravity CLI
- OpenCode es el de mas adopcion en Github y soporta multiples proveedores de
  modelo

## Web interfaces

| Interface | Company   | URL                            |
|-----------|-----------|--------------------------------|
| Claude    | Anthropic | <https://claude.ai>            |
| ChatGPT   | OpenAI    | <https://chatgpt.com/>         |
| Gemini    | Google    | <https://gemini.google.com>    |
| Grok      | xAI       | <https://grok.com>             |
| DeepSeek  | DeepSeek  | <https://chat.deepseek.com>    |
| Qwen      | Alibaba   | <https://chat.qwen.ai>         |
| MiniMax   | MiniMax   | <https://www.minimax.io/>      |

## Large language models

Estado a agosto de 2026. La columna open weights indica si se pueden descargar los
pesos y servir el modelo uno mismo.

| Family Name | Latest Release | Company       | Open weights | Website                     |
|-------------|----------------|---------------|--------------|-----------------------------|
| Opus        | 5              | Anthropic     | No           | <https://www.anthropic.com> |
| Sonnet      | 5              | Anthropic     | No           | <https://www.anthropic.com> |
| Haiku       | 4.5            | Anthropic     | No           | <https://www.anthropic.com> |
| Fable       | 5              | Anthropic     | No           | <https://www.anthropic.com> |
| GPT         | 5.6            | OpenAI        | No           | <https://openai.com>        |
| Gemini      | 3.6            | Google        | No           | <https://ai.google.dev>     |
| Grok        | 4.5            | xAI           | No           | <https://x.ai>              |
| Llama       | 4              | Meta          | Si           | <https://ai.meta.com>       |
| Magistral   | Medium         | Mistral AI    | Si           | <https://mistral.ai>        |
| Medium      | 3              | Mistral AI    | Si           | <https://mistral.ai>        |
| Small       | 3.1            | Mistral AI    | Si           | <https://mistral.ai>        |
| Qwen        | 3.8 Max        | Alibaba Cloud | Parcial      | <https://qwenlm.github.io>  |
| V-series    | V4             | DeepSeek      | Si           | <https://www.deepseek.com>  |
| Kimi        | K3             | Moonshot AI   | Si           | <https://www.moonshot.ai>   |
| GLM         | 5.2            | Zhipu AI      | Si           | <https://z.ai>              |
| M-series    | M3             | MiniMax       | Si           | <https://www.minimax.io/>   |

Notas:

- Los modelos open weight chinos (DeepSeek V4, GLM 5.2, Kimi K3, MiniMax M3)
  compiten en precio y apertura contra los cerrados
- Kimi K3 es el modelo open weight mas grande publicado hasta la fecha
- Qwen aparece como parcial porque la gama Max es solo via API, mientras otras
  variantes si publican pesos
- Los nombres de version varian entre fuentes. Conviene confirmar el ID exacto
  del modelo en la documentacion del proveedor antes de usarlo
