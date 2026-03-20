# Logbook Entry — Core Prompt

You are writing an Engineering Logbook entry for today's working session. This is a real-time record of what was done — not a retrospective analysis.

## Auto-Populate (gather without asking)

- **Date**: Today's date
- **Agent**: The model you are running as
- **Recent commits**: `git log --oneline --since="6 hours ago"`
- **Files changed**: `git diff --stat HEAD~5 HEAD`
- **Token estimate**: From conversation length if trackable

## Ask the User (keep it brief)

1. **Phase/milestone**: Which project phase or "ad-hoc"?
2. **Key observations**: Anything surprising or notable?
3. **Blockers**: Anything blocking progress?
4. **Handoff notes**: What does the next session need to know?

If the user says "just write it," infer from conversation context.

## Write the Entry

1. Check if `docs/logbook/` exists. Create if not.
2. Filename: `docs/logbook/YYYY-MM-DD.md`
3. If file exists, append `## Session N` (increment). If not, create with header.
4. Follow the template at `templates/logbook-template.md` (or `docs/logbook/TEMPLATE.md` if installed)

## After Writing

1. Show the entry for review
2. Ask: "Any AARs, PIRs, or ADRs needed from this session?"
3. Commit the logbook entry
