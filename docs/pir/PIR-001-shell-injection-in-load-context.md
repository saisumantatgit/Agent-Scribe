# PIR-001: Shell Injection in load-context.sh SessionStart Hook

## Metadata

| Field | Value |
|-------|-------|
| **PIR ID** | PIR-001 |
| **Date** | 2026-03-20 |
| **Severity** | P1 |
| **Status** | Final |
| **Incident date** | 2026-03-19 |
| **Detection date** | 2026-03-20 |
| **Resolution date** | 2026-03-20 |

## Zone Check

| Dimension | Status | Notes |
|-----------|--------|-------|
| **Severity** | P1 | Arbitrary code execution via crafted logbook content |
| **Containment** | Contained | Fixed in commit `592af3e` (2026-03-20) |
| **Blast Radius** | Every repo with Agent-Scribe installed | Hook runs on every session start for every user |

## 1. Summary

The `load-context.sh` SessionStart hook interpolated logbook content directly into a Python triple-quoted string literal via shell variable expansion. A logbook entry containing `'''` could escape the string boundary and execute arbitrary Python code on every subsequent session start. The vulnerability existed from initial release (v1.0.0, 2026-03-19) until the fix commit on 2026-03-20. This is the most serious security finding across the entire Agent Governance Suite.

## 2. Timeline

| Time | Event | Actor |
|------|-------|-------|
| 2026-03-19 ~15:56 | `load-context.sh` introduced in initial commit (`def9a86`) | Developer |
| 2026-03-19 ~16:38 | Shipped as part of Agent-Scribe v1.0.0 (`2a208bb`) | Developer |
| 2026-03-20 ~19:50 | Structure standardization pass; vulnerability not caught (`9e0c549`) | Developer + Agent |
| 2026-03-20 ~21:29 | Vulnerability detected during systematic security review | Agent (Claude) |
| 2026-03-20 ~21:29 | Fix committed: context passed via environment variable (`592af3e`) | Developer + Agent |

## 3. Five Whys

1. **Why did injection occur?** — `$CONTEXT` (logbook content) was passed via shell string interpolation into a Python triple-quoted string literal (`context = '''$CONTEXT'''`).
2. **Why was string interpolation used?** — Quick implementation pattern. Shell-to-Python data passing via inline string embedding is a common (and dangerous) shortcut.
3. **Why was this not caught before release?** — No security review was performed on the hook script. Testing focused on functional behavior (does handoff load correctly?), not adversarial input.
4. **Why was there no security review?** — Agent-Scribe was treated as the simplest product in the suite — "just prompts and templates." The hook was an afterthought, not recognized as a code-execution boundary.
5. **Why?** --> **ROOT CAUSE:** Shell scripts that generate and execute code from user-controlled input were not identified as a security-sensitive pattern requiring review. No security checklist existed for hooks that bridge shell and Python execution contexts.

## 4. Blast Radius

| Radius | Affected | How |
|--------|----------|-----|
| Direct | `load-context.sh` in every repo with Scribe installed | Vulnerable code path executed on every session start |
| Adjacent | Any CI/CD or automated workflow invoking Claude Code with Scribe | Automated sessions would trigger the hook without human oversight |
| Downstream | Host filesystem, environment variables, credentials | Arbitrary Python execution has full access to the user's environment |
| Potential (if undetected) | Supply-chain attack via logbook poisoning | A compromised logbook entry in a shared repo could execute code on every collaborator's machine at session start |

## 5. Prompt Forensics

### Triggering input

A logbook entry containing a triple-quote escape in the Handoff Notes section:

```markdown
### Handoff Notes
- Task complete''' + __import__('os').system('echo PWNED') + '''
```

When `load-context.sh` reads this and interpolates it into the Python inline script, the generated Python becomes:

```python
context = '''LAST SESSION HANDOFF (from 2026-03-20.md):

Handoff Notes:
- Task complete''' + __import__('os').system('echo PWNED') + '''
'''
```

The `'''` in the logbook content terminates the Python string literal. The `+` operator concatenates the return value of `__import__('os').system(...)`, which executes an arbitrary shell command. The trailing `'''` opens a new string literal to absorb the remaining content without a syntax error.

### Vulnerable code (before fix)

```bash
python3 -c "
import json
context = '''$CONTEXT'''
print(json.dumps({'additionalContext': context}))
" 2>/dev/null
```

The shell expands `$CONTEXT` before Python sees the code. Any content from the logbook is injected verbatim into the Python source.

### Fixed code (after fix)

```bash
CONTEXT="$CONTEXT" python3 -c "
import json, os
context = os.environ.get('CONTEXT', '')
print(json.dumps({'additionalContext': context}))
" 2>/dev/null
```

Context is passed as an environment variable. Python reads it via `os.environ.get()`, which returns a string value — never interpreted as code. The content cannot escape into the execution context regardless of what characters it contains.

### Expected vs actual
- **Expected:** Logbook content loaded as a string and passed to the session as `additionalContext`.
- **Actual:** Logbook content injected into Python source code, enabling arbitrary code execution if the content contained `'''`.

## 6. What Went Well

- The vulnerability was caught within 30 hours of initial release, before any known exploitation.
- The fix was clean and minimal — single-pattern change from string interpolation to environment variable, with no functional regression.
- The same review pass caught four additional bugs (sed pattern, template paths, install.sh ADR gap, README inaccuracy), demonstrating thoroughness once the review started.

## 7. What Went Wrong

- **No security review on hooks.** The hook was the only component in Scribe that executes code (shell + Python), yet it received no adversarial input analysis.
- **"Simple product" bias.** Scribe's positioning as the simplest product in the suite created a false sense of safety. The `hooks/` directory was a code-execution boundary hiding in a "just prompts" product.
- **Shell-to-Python data passing via string interpolation.** This is a well-known anti-pattern (equivalent to SQL injection), but it was used without question because the data source (logbook) was assumed to be trusted.
- **`2>/dev/null` suppressed error signals.** If a malformed injection caused a Python syntax error, the error would be silently discarded, masking both the vulnerability and any exploitation attempts.

## 8. Where We Got Lucky

- **Single-user context.** Logbook content is typically written by the same developer who runs the session. An attacker would need write access to the logbook file, which implies they already have filesystem access. This significantly reduced the practical exploitability.
- **No shared-repo Scribe deployments (yet).** If Scribe had been deployed in a team setting with shared logbooks in a git repository, a single malicious logbook entry could have executed code on every team member's machine.
- **`2>/dev/null` accidentally helped.** While it masked errors (bad), it also meant a clumsy injection attempt that caused a syntax error would fail silently rather than alerting the attacker to refine their payload.
- **No known exploitation.** The vulnerability existed for ~30 hours in a product with a small initial user base.

## 9. Remediation

### Immediate fix
- Replaced Python triple-quote string interpolation with environment variable passing (`CONTEXT="$CONTEXT" python3 -c "os.environ.get('CONTEXT')"`) in commit `592af3e`.
- The fix eliminates the injection vector entirely: environment variable values are never interpreted as Python code.

### Permanent fix
- Environment variable pattern is the permanent fix. No further code changes needed for this specific vector.
- Additionally fixed the `sed` end-delimiter pattern (`^---$` changed to `^##`) and template path references to prevent silent failures in logbook extraction.

### Detection improvement
- Any future hook or script that passes data between shell and a language runtime (Python, Node, Ruby) must use environment variables or file-based passing, never string interpolation.
- The `2>/dev/null` on the Python execution should be reconsidered — silent failure suppresses both errors and exploitation signals.

## 10. Action Items

| # | Action | Priority | Owner | Due | Status |
|---|--------|----------|-------|-----|--------|
| 1 | Add security review checklist for any file in `hooks/` or `scripts/` that executes code | P1 | Maintainer | 2026-03-27 | Open |
| 2 | Audit all other products (PROVE, Trace, Cite, Drift, Litmus) for shell-to-language string interpolation | P1 | Maintainer | 2026-03-27 | Open |
| 3 | Add integration test: logbook entry containing `'''` does not cause code execution | P2 | Maintainer | 2026-04-03 | Open |
| 4 | Document "never interpolate user data into code strings" in suite-level CONTRIBUTING.md | P2 | Maintainer | 2026-04-03 | Open |
| 5 | Evaluate removing `2>/dev/null` from Python execution in hook to surface errors during development | P3 | Maintainer | 2026-04-10 | Open |
| 6 | Consider input sanitization as defense-in-depth even with env var passing | P3 | Maintainer | 2026-04-10 | Open |

## 11. Lessons Learned

1. **"Simple" products are not safe products.** Scribe was the smallest product in the suite, but it contained the only arbitrary code execution vulnerability. Complexity is not a reliable proxy for risk — execution boundaries are.

2. **Shell scripts that generate code are injection surfaces.** Any pattern of the form `language -c "...${variable}..."` is semantically identical to SQL injection. The fix is always the same: parameterize, never interpolate. In shell-to-Python contexts, environment variables are the parameterized equivalent.

3. **Security review must cover every code-execution boundary, not just "important" components.** The hook was 40 lines of bash — trivial to review, catastrophic to skip. A 5-minute adversarial review ("what if the logbook contains X?") would have caught this before release.
