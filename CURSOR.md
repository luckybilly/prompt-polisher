# Using Prompt Polisher with Cursor

This project includes a **Cursor project rule** so the prompt polishing framework applies automatically when you work in Cursor.

## In this repository

1. Open the folder in Cursor.
2. The rule [`.cursor/rules/prompt-polisher.mdc`](.cursor/rules/prompt-polisher.mdc) is committed with `alwaysApply: true`, so you do not need extra installation steps.
3. In Cursor, confirm it under **Settings → Rules**, where `prompt-polisher` should appear.

## Use the same framework in another project

**Cursor (recommended):** Copy `.cursor/rules/prompt-polisher.mdc` into that project's `.cursor/rules/` directory (create the folders if needed). Adjust or merge with existing rules as you like.

**Other tools:** If a stack only supports a root instruction file, copy [`CLAUDE.md`](CLAUDE.md) into that project instead (or merge its contents into your existing instructions).

## Claude Code vs Cursor

- **Claude Code:** Install via the plugin marketplace and [`README.md`](README.md) instructions; the plugin exposes the skill from this repo. Per-project use can also rely on `CLAUDE.md`.
- **Cursor:** Use the committed `.cursor/rules/` file as described above. Cursor does not read `.claude-plugin/` or `CLAUDE.md` by default.

## For contributors

When you change the framework, keep these files in sync:

- [`CLAUDE.md`](CLAUDE.md) — core framework
- [`.cursor/rules/prompt-polisher.mdc`](.cursor/rules/prompt-polisher.mdc) — Cursor rule
- [`skills/prompt-polisher/SKILL.md`](skills/prompt-polisher/SKILL.md) — Skill definition
