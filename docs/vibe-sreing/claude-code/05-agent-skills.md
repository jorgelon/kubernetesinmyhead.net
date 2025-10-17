# Agent Skills

Agent Skills are modular capabilities that extend Claude's functionality for domain-specific tasks. They operate through a progressive, filesystem-based loading mechanism that optimizes token usage and performance.

**Architecture - Three Content Levels:**

1. **Metadata** (Always Loaded ~100 tokens)
   - Lightweight system prompt inclusion
   - Describes the skill's purpose and when to use it
   - Minimal token consumption

2. **Instructions** (Loaded When Triggered <5,000 tokens)
   - Procedural knowledge and workflows
   - Loaded dynamically when relevant
   - Step-by-step task guidance

3. **Resources and Code** (Loaded as Needed)
   - Optional executable scripts
   - Reference materials
   - Executed via bash without consuming context window

**Key Benefits:**

- Specialize Claude for domain-specific tasks
- Reduce repetitive instructions
- Enable complex workflow composition
- Efficient token usage through progressive loading

**Structure:**

- Requires a `SKILL.md` file
- Must include name (64 character max)
- Must include description (1024 character max)

**Availability:**

- Claude API
- Claude Code
- Claude.ai (with limitations)

**Pre-built Skills:**

- PowerPoint processing
- Excel data manipulation
- Word document editing
- PDF document handling

**Security:**

- No network access by default
- Pre-configured dependencies
- Sandboxed execution environment

## LInks

- Agent Skills

<https://docs.claude.com/en/docs/agents-and-tools/agent-skills/overview>

Equipping agents for the real world with Agent Skills

<https://www.anthropic.com/engineering/equipping-agents-for-the-real-world-with-agent-skills>
