# Contributing to Agent-Scribe

## Adding Templates

Templates live in `templates/` and define the structure of governance documents.

To add a new template:

1. Create a `.md` file in `templates/` following existing template conventions
2. Create a matching prompt in `prompts/` that references the template
3. Add a command file in `.claude/commands/` and `adapters/claude-code/commands/`
4. Update other CLI adapters as needed
5. Update `install.sh` to include the new command in installation

### Template checklist:
- [ ] Pure markdown — no LLM-specific syntax, no model references
- [ ] Cites its methodology origin (e.g., US Army AAR, Google SRE PIR)
- [ ] Includes auto-population sections (from git history)
- [ ] Includes human judgment sections (observations, lessons)
- [ ] Reviewed against `TEMPLATE_CHECKLIST.md`

## Adding CLI Adapters

1. Create a directory in `adapters/<your-cli>/`
2. Wrap the prompts from `prompts/` in your CLI's native configuration format
3. Update `install.sh` to detect your CLI and install the adapter
4. Add an entry to the Platform Support table in `README.md`

### Adapter checklist:
- [ ] All 4 commands represented (logbook, draft-aar, draft-pir, draft-adr)
- [ ] Session-start hook included (load-context equivalent)
- [ ] References core prompts, not duplicated logic
- [ ] Detection logic added to `install.sh`

## Modifying Prompts

Prompts in `prompts/` are the single source of truth. To modify:

1. Edit the prompt in `prompts/`
2. Verify all adapters still work (they reference prompts, so usually no changes needed)
3. If the prompt references a template, verify the template still matches

**Important:** Adapters are thin wrappers. Never put logic in adapters — always edit `prompts/` first.

## Testing Changes

Since Agent-Scribe is a prompt-based plugin (no runtime code), testing is manual:

1. Install the plugin in a test project
2. Run each command (`/logbook`, `/draft-aar`, `/draft-pir`, `/draft-adr`)
3. Verify documents are produced with correct structure
4. Verify `load-context.sh` hook loads handoff notes on session start
5. Test with multiple CLI tools if modifying adapters or `install.sh`
