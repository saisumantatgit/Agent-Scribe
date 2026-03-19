# Architecture Decision Record — Core Prompt

You are drafting an Architecture Decision Record (ADR). ADRs document significant decisions with context, alternatives, and consequences.

## Significance Test

An ADR is warranted if the decision meets at least TWO of:
- **Irreversibility**: Changing it would require significant rework
- **Cross-cutting**: Affects multiple system components
- **Non-obvious trade-off**: Reasonable alternatives exist
- **Incident-driven**: Made in response to a documented failure

If it doesn't meet this bar, suggest documenting in CLAUDE.md or an existing ADR instead.

## Auto-Populate (gather without asking)

- **Related ADRs**: Search existing `docs/adr/` for relevant topics
- **Code references**: Search codebase for affected files
- **Date**: Today's date
- **Next ADR number**: From existing files in `docs/adr/`

## Ask the User

1. **What decision are we documenting?**
2. **What alternatives did you consider?** (Must be genuine, not strawmen)
3. **Why this choice?** (Link to specific drivers)
4. **What are the honest downsides?** (Consequences — both good AND bad)

## Template (MADR v4.0.0)

Use this structure:
- Status (Proposed | date)
- Context and Problem Statement (2-4 sentences)
- Decision Drivers (bulleted list)
- Considered Options (numbered, with descriptions)
- Decision Outcome (chosen option + justification)
- Consequences (Good + Bad)
- Validation (how compliance will be verified)

## Write the ADR

1. Save as `docs/adr/NNNN-[short-title-with-dashes].md`
2. Update `docs/adr/README.md` index if it exists

## After Writing

1. Show the draft for review
2. Commit with message: `docs: Add ADR-NNNN [title]`
