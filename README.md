# Agent-Scribe

> **Nothing is lost.**
> Governance toolkit for AI agent workflows — compound learning across sessions instead of starting from zero.

[![License: MIT](https://img.shields.io/badge/License-MIT-blue.svg)](LICENSE)
[![Commands](https://img.shields.io/badge/Commands-4-orange.svg)](#commands)
[![CLIs](https://img.shields.io/badge/CLI_Support-5-purple.svg)](#supported-clis)

---

## The Problem

AI agents forget everything between sessions. Every new conversation starts from scratch — no memory of what worked, what failed, what was decided, or where you left off. You end up re-explaining context, re-discovering decisions, and re-making the same mistakes.

**Agent-Scribe fixes this.** Four documentation commands and a session-start hook that close the learning loop:

```
Session N: /logbook → captures what happened, writes handoff notes
                ↓
Session N+1: load-context.sh → loads those notes automatically
                ↓
Agent starts with full context, not a blank slate
```

---

## Commands

| Command | When | What It Does |
|---------|------|-------------|
| **`/logbook`** | Every session (non-negotiable) | Captures work done, observations, blockers, and handoff notes. Auto-populates from git history. |
| **`/draft-aar`** | After milestones | After Action Review — planned vs. actual, variance analysis, lessons learned (Sustain/Improve/Stop). |
| **`/draft-pir`** | After incidents | Blameless Post-Incident Review — timeline, Five Whys, blast radius, prompt forensics, remediation. |
| **`/draft-adr`** | For decisions | Architecture Decision Record — context, alternatives, trade-offs, consequences. MADR v4.0.0 format. |
| **`load-context`** | Session start (automatic) | Shell hook that loads the last session's handoff notes into context. ~100ms. |

Every command auto-populates from git history, prompts for the sections that need human judgment, and produces structured documents that any agent (or human) can read to continue where you left off.

---

## Quick Install

```bash
# Clone
git clone https://github.com/saisumantatgit/Agent-Scribe.git

# Install into your project (auto-detects your CLI)
cd your-project/
bash /path/to/Agent-Scribe/install.sh
```

The installer detects your CLI tool and copies the right files:

| CLI Tool | What Gets Installed |
|----------|-------------------|
| **Claude Code** | `.claude/commands/*.md` + hook script |
| **Codex** | Appends to `AGENTS.md` |
| **Cursor** | `.cursor/rules/governance.md` |
| **Aider** | Appends to `.aider.conf.yml` |
| **Generic** | Raw prompt files you can paste into any LLM |

---

## How It Works

### Architecture

```
prompts/          ← LLM-agnostic core (single source of truth)
templates/        ← Pure markdown document structures
hooks/            ← Shell scripts (requires Python 3 for JSON output formatting)
adapters/         ← CLI-specific thin wrappers
install.sh        ← Auto-detect and install
```

**`prompts/` is the single source of truth.** Adapters are thin wrappers that load the core prompt in each CLI's native format. Templates are pure markdown — no LLM-specific syntax, no model references.

### The Learning Loop

```
/logbook (session end)
    ↓ writes handoff notes
load-context.sh (next session start)
    ↓ loads handoff notes + blockers
Agent has context
    ↓ works with full awareness
/logbook (session end)
    ↓ writes updated handoff notes
... repeat
```

AARs capture milestone learning. PIRs capture incident learning. ADRs capture decision context. The logbook + hook captures session continuity. Together, they compound knowledge instead of losing it.

---

## Templates

Every command produces a structured document. Templates include:

### Logbook
- Zone Check (Momentum/Quality/Scope — start and end of session)
- WIP tracking with live status (✅/❌/⏸️)
- Handoff Notes with read order for next session

### After Action Review (AAR)
- RAG health indicator (Delivery/Quality/Scope)
- Agent Delegation Map (who/what did what)
- Variance Analysis (agent errors, human errors, environmental factors)
- Token Economics (computational investment tracking)
- Lessons Learned (Sustain/Improve/Stop)

### Post-Incident Review (PIR)
- Severity classification (P0 Critical → P3 Low)
- Blast Radius assessment (direct → adjacent → downstream → potential)
- Five Whys root cause analysis
- Prompt Forensics (was the prompt ambiguous?)
- Remediation (immediate fix, permanent fix, detection improvement)

### Architecture Decision Record (ADR)
- Significance test (is this worth an ADR?)
- MADR v4.0.0 format (industry standard)
- Genuine alternatives (not strawmen)
- Honest consequences (good AND bad)

---

## Methodology

Not invented here — adapted from battle-tested sources:

| Practice | Origin | Reference |
|----------|--------|-----------|
| After Action Review | US Army, 1993 | TC 25-20 "A Leader's Guide to After-Action Reviews" |
| Blameless Post-Mortem | Google SRE, 2016 | *Site Reliability Engineering*, Chapter 15 |
| Correction of Errors | Amazon, 2023 | AWS COE process |
| Engineering Logbook | Scientific tradition | Rice University, NIH, Benchling guidelines |
| ADR (MADR v4.0.0) | Michael Nygard, 2011 | "Documenting Architecture Decisions" |
| Five Whys | Toyota, 1988 | Taiichi Ohno, *Toyota Production System* |
| Session Handoff | Aviation CRM | Crew Resource Management briefing protocols |
| RAG Status | Project Management | PMBOK risk assessment |

---

## Part of the Agent Suite

| Tool | What It Does |
|------|-------------|
| [Agent-PROVE](https://github.com/saisumantatgit/Agent-PROVE) | Thinking validation |
| [Agent-Trace](https://github.com/saisumantatgit/Agent-Trace) | Blast-radius mapping |
| [Agent-Scribe](https://github.com/saisumantatgit/Agent-Scribe) | Governance documentation |
| [Agent-Cite](https://github.com/saisumantatgit/Agent-Cite) | Evidence enforcement |
| [Agent-Drift](https://github.com/saisumantatgit/Agent-Drift) | Drift detection |
| [Agent-Litmus](https://github.com/saisumantatgit/Agent-Litmus) | Test quality validation |

---

## Contributing

Add your own templates or CLI adapters:

1. **Templates**: Drop a `.md` file in `templates/`
2. **CLI adapter**: Add a directory in `adapters/[your-cli]/`
3. **Core prompts**: Modify `prompts/*.md` — adapters inherit changes automatically

---

## License

[MIT](LICENSE)
