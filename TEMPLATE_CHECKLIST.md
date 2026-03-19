# Template Quality Checklist

Reference table for validating AAR, PIR, and Logbook entries.

## Completeness Matrix

| Criteria | AAR | PIR | Logbook | Notes |
|----------|-----|-----|---------|-------|
| **Metadata** | | | | |
| Date + identifier | Required | Required | Required | Sequential (AAR-NNN, PIR-NNN) |
| Phase / milestone | Required | Required | Required | Tracks roadmap position |
| Duration | Required | Required | Required | Wall-clock or time range |
| Agents + tokens | Required | In token cost section | Required | Computational investment |
| Health (RAG) | Required | N/A (has severity) | Required | GREEN / AMBER / RED |
| Severity (P0-P3) | N/A | Required | N/A | Define per-project |
| **Content** | | | | |
| Objective / summary | Required | Required (write last) | Required (write first) | |
| Chronological trace | Required | Required (timeline) | Required (work done) | Facts before analysis |
| Variance / root cause | Required (planned vs actual) | Required (Five Whys) | N/A | AAR = variance, PIR = root cause |
| WIP tracking | N/A | N/A | Required | ✅/❌/⏸️ status |
| **Safety** | | | | |
| Blast radius | N/A | Required | N/A | Direct → adjacent → downstream → potential |
| Prompt forensics | N/A | Required (if agent-involved) | N/A | Was the prompt ambiguous? |
| **Continuity** | | | | |
| Action items (owned, dated) | Required | Required | N/A (use handoff) | |
| Handoff notes | N/A | N/A | Required | For zero-context agent |
| Read order | N/A | N/A | Required | "Start here" pointers |
| Lessons learned | Required (Sustain/Improve/Stop) | Required | N/A | |
| Token economics | Required (investment) | Required (waste) | Optional | |

## Triggers

| Template | When to Write |
|----------|--------------|
| **Logbook** | Every session (non-negotiable) |
| **AAR** | After milestone, significant session, plan divergence |
| **PIR** | Trust-breaking event, deployed wrong, bug surviving >1 session |
| **ADR** | Decision meeting ≥2 of: irreversible, cross-cutting, non-obvious trade-off, incident-driven |

## RAG Definitions

| Status | Meaning | Action |
|--------|---------|--------|
| 🟢 GREEN | On track | Continue |
| 🟡 AMBER | Minor concerns | Monitor |
| 🔴 RED | Blocked or trust-eroding | Stop and address |
