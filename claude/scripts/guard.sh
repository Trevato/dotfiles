#!/usr/bin/env bash
# PreToolUse(Bash) guard — denies a NARROW set of catastrophic commands.
# Receives JSON on stdin; emits a deny decision (exit 0 + JSON) or stays silent to allow.
# Staying silent does NOT auto-approve — normal permission flow still applies. This is a
# safety net, not the only line of defense, so keep the denylist tight: false positives
# block real work, while a miss just falls back to the usual prompt.

input=$(cat)
cmd=$(echo "$input" | jq -r '.tool_input.command // empty')
[ -z "$cmd" ] && exit 0

deny() {
  jq -n --arg r "$1" '{hookSpecificOutput:{hookEventName:"PreToolUse",permissionDecision:"deny",permissionDecisionReason:$r}}'
  exit 0
}

# Collapse whitespace for robust matching.
c=$(printf '%s' "$cmd" | tr -s '[:space:]' ' ')

# Recursive force-delete of a root or whole-home path (NOT subpaths like /tmp/x or ~/proj).
echo "$c" | grep -Eq 'rm +-[a-zA-Z]*r[a-zA-Z]* +(-[a-zA-Z]+ +)*(/|/\*|~|~/|\$HOME|/Users/[^/ ]+)( |$)' &&
  deny "Refusing recursive force-delete of a root or home path."
echo "$c" | grep -Eq ':\(\) *\{ *:\|: *& *\} *;:' && deny "Refusing fork bomb."
echo "$c" | grep -Eq '\bmkfs[.a-z]*\b' && deny "Refusing filesystem format (mkfs)."
echo "$c" | grep -Eq '\bdd\b.*of=/dev/' && deny "Refusing raw write to a device (dd of=/dev/*)."
{ echo "$c" | grep -Eq 'git +push\b' && echo "$c" | grep -Eq '(--force| -f( |$))' && echo "$c" | grep -Eq '\bmain\b'; } &&
  deny "Refusing force-push to main."
echo "$c" | grep -Eq 'chmod +-R +777 +/( |$)' && deny "Refusing chmod -R 777 on a root path."

exit 0
