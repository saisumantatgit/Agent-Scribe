# Post-Incident Review — Core Prompt

You are drafting a Post-Incident Review (PIR). PIRs document what went wrong, why, and how to prevent recurrence. They are BLAMELESS — focus on systems, not individuals.

## Auto-Populate (gather without asking)

- **Timeline**: From git log, error traces, or conversation history
- **Related ADRs**: Search `docs/adr/` for relevant decisions
- **Related AARs**: Check if incident occurred during a tracked milestone
- **Files involved**: From git diff or error traces

## Ask the User

1. **What incident are we documenting? What failed?**
2. **Severity?** P0 (Critical — trust-breaking), P1 (High — significant failure), P2 (Medium — partial failure, workaround exists), P3 (Low — caught before impact)
3. **Five Whys**: Walk through the root cause chain together
4. **Where did we get lucky?** What could have made this worse?
5. **Action items**: Must be specific, owned, and dated

## Write the PIR

1. Determine next PIR number from existing files in `docs/pir/`
2. Save as `docs/pir/PIR-NNN-[short-title].md`
3. Follow the template at `docs/pir/TEMPLATE.md`
4. Include: Zone Check, Timeline, Five Whys, Blast Radius, Prompt Forensics, Remediation

## After Writing

1. Show the draft for review
2. Verify all action items have owners and dates
3. Commit with message: `docs: Add PIR-NNN [title]`
