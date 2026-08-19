#!/usr/bin/env bash
# Auto-format and lint-fix files edited by Claude Code.
# Called by the PostToolUse hook — receives JSON on stdin.
# File-scoped and fail-open: every branch no-ops if a tool is absent and always exits 0,
# so it never blocks Claude and never touches more than the single edited file.
# Project-wide checks (typecheck, full lint) are intentionally NOT here — they belong per-project.

input=$(cat)
file=$(echo "$input" | jq -r '.tool_input.file_path // empty')
[ -z "$file" ] || [ ! -f "$file" ] && exit 0

case "${file##*.}" in
  js | jsx | ts | tsx)
    prettierd "$file" <"$file" >"${file}.fmt" 2>/dev/null && mv "${file}.fmt" "$file" || rm -f "${file}.fmt"
    command -v eslint_d >/dev/null 2>&1 && eslint_d --fix "$file" 2>/dev/null || true
    ;;
  json | css | scss | html | md | yaml | yml | graphql)
    prettierd "$file" <"$file" >"${file}.fmt" 2>/dev/null && mv "${file}.fmt" "$file" || rm -f "${file}.fmt"
    ;;
  py)
    ruff check --fix "$file" 2>/dev/null || true
    ruff format "$file" 2>/dev/null || true
    ;;
  nix)
    nixfmt "$file" 2>/dev/null || true
    ;;
  lua)
    stylua "$file" 2>/dev/null || true
    ;;
esac

exit 0
