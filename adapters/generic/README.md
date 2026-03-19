# Generic Installation

If your CLI tool isn't directly supported, use the core prompts directly:

1. Copy `prompts/` and `templates/` to your project
2. When you want to run a command, paste the content of the relevant prompt file into your LLM session
3. The prompts are LLM-agnostic — they work with any model that can read files and run git commands

## Prompt Files
- `prompts/logbook.md` — Session logging
- `prompts/draft-aar.md` — After Action Review
- `prompts/draft-pir.md` — Post-Incident Review
- `prompts/draft-adr.md` — Architecture Decision Record

## Template Files
- `templates/logbook-template.md` — Logbook entry structure
- `templates/aar-template.md` — AAR structure
- `templates/pir-template.md` — PIR structure
- `templates/adr-template-madr-v4.md` — ADR structure (MADR v4.0.0)
