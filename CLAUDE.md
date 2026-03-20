# Agent-Scribe

Agent-Scribe is a prompt-based governance documentation plugin for AI agent workflows. Four commands + a session-start hook that close the learning loop across sessions.

## Architecture

Simplest product in the suite — no agents, no skills, no scripts. Three layers:

```
prompts/     <- LLM-agnostic core logic (single source of truth)
templates/   <- Pure markdown document structures (AAR, PIR, ADR, Logbook)
adapters/    <- CLI-specific thin wrappers (Claude Code, Codex, Cursor, Aider, Generic)
hooks/       <- Shell scripts (load-context.sh for session continuity)
```

Data flow: Command -> loads prompt -> prompt references template -> produces document.

## Commands

| Command | Purpose |
|---------|---------|
| `/logbook` | Engineering logbook entry — captures work, observations, blockers, handoff notes |
| `/draft-aar` | After Action Review — planned vs. actual, variance analysis, lessons learned |
| `/draft-pir` | Post-Incident Review — blameless, Five Whys, blast radius, remediation |
| `/draft-adr` | Architecture Decision Record — MADR v4.0.0 format, alternatives, trade-offs |
| `load-context` | SessionStart hook — loads last session's handoff notes (~100ms) |

## Conventions

- **Prompts are canonical** — Adapter files wrap `prompts/`; never put logic in adapters. Edit prompts first, then update adapters.
- **Templates follow standards** — AAR from US Army TC 25-20, PIR from Google SRE Chapter 15, ADR from MADR v4.0.0, Logbook from scientific tradition.
- **No model references in templates** — Templates are pure markdown. No LLM-specific syntax.
- **Session continuity** — The logbook + load-context hook pair is the core value prop. Logbook writes handoff notes; hook loads them next session.
- **Auto-population** — All commands auto-populate from git history before asking for human judgment.

## Key Files

| Path | Purpose |
|------|---------|
| `prompts/*.md` | Core prompts (logbook, draft-aar, draft-pir, draft-adr) |
| `templates/*.md` | Document templates (logbook, AAR, PIR, ADR) |
| `hooks/load-context.sh` | Session-start hook that loads handoff notes |
| `install.sh` | Auto-detect CLI and install adapter |
| `adapters/` | CLI-specific wrappers (claude-code, codex, cursor, aider, generic) |
| `.claude/commands/*.md` | Claude Code slash commands |
| `.claude-plugin/` | Plugin metadata and hooks |
| `TEMPLATE_CHECKLIST.md` | Quality checklist for template authoring |

## Gotchas

- **No build step** — Prompt-based plugin. `package.json` is metadata only (no scripts block).
- **No agents or skills** — Unlike PROVE, Drift, Litmus, Scribe has no agent layer. Prompts drive everything directly.
- **install.sh is destructive** — Copies files into target repo's working directory. Will overwrite existing files in `prompts/`, `.claude/commands/`, etc.
- **Hook requires bash** — `load-context.sh` is a shell script. Works on macOS/Linux. Windows users need WSL or Git Bash.
- **Templates are methodology-specific** — Each template cites its origin methodology. Changing structure means understanding the source methodology first.
