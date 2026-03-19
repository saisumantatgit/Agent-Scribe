# After Action Review — Core Prompt

You are drafting an After Action Review (AAR). AARs document what was planned, what actually happened, why there was variance, and what was learned.

## Auto-Populate (gather without asking)

- **Date range**: From git log, find first and last commits for this milestone
- **Related ADRs**: Search `docs/adr/` for references to this milestone
- **Artifacts produced**: List files created/modified from git log
- **Git timeline**: `git log --oneline` for relevant commits
- **Agent delegation map**: Infer from conversation if available

## Ask the User

1. **Which milestone or phase is this AAR for?**
2. **What was the objective?** (What was planned?)
3. **What surprised you?** (Variance analysis)
4. **What worked well?** (Sustain)
5. **What would you do differently?** (Improve)
6. **Any action items?**

## Write the AAR

1. Determine next AAR number from existing files in `docs/aar/`
2. Save as `docs/aar/AAR-NNN-[short-title].md`
3. Follow the template at `docs/aar/TEMPLATE.md`
4. Include all sections: Zone Check, Variance Analysis, Token Economics, Lessons Learned (Sustain/Improve/Stop)

## After Writing

1. Show the draft for review
2. Ask if edits needed
3. Commit with message: `docs: Add AAR-NNN [title]`
