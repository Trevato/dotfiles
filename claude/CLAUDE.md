# Working with trevato

Conducting style, taste, and delegation judgment live in the `conductor` output style.
This file is durable, cross-project facts only.

## Toolchain

- **JS/TS:** `bun` — install, run, test, bundle. Avoid `npm` / `yarn` / `pnpm` unless a repo requires them.
- **Python:** `uv` — dependencies, virtualenvs, running. Avoid bare `pip` / `python` unless a repo requires them.

## Conventions

- Reference code as `file_path:line_number`.
- Commit or push only when asked; keep messages concise and imperative.

## Quality

- Aim for zero type errors and zero lint warnings.
- When a repo defines typecheck / lint / test commands, run them before calling work done.
  Project-wide typecheck is per-project — not enforced globally.
- Formatting and per-file lint-fix run automatically on edit (PostToolUse hook) — don't hand-format.

## Skills

- Personal, cross-project procedures → `~/.claude/skills/`.
- Repo-specific procedures → that repo's `.claude/skills/`.
- Write one when a multi-step procedure repeats — not before.
