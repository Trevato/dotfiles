# Claude Code — the user-level configuration that makes Claude work the way I
# do: instructions, output style, agents, hooks, statusline. Sources live in
# ../claude and are linked into ~/.claude file by file, so Claude Code keeps
# writing its own state (projects/, sessions, settings.local.json) alongside.
#
# The format hook shells out to the formatters in home.packages; the statusline
# reads kubectl. Both are portable because those are.
#
# Claude Code writes settings.json itself from /model, /output-style and
# /statusline. With the file managed here, make those changes in
# claude/settings.json and rebuild; edits made in place will not take.
{ ... }:
{
  home.file = {
    ".claude/CLAUDE.md".source = ../claude/CLAUDE.md;
    ".claude/settings.json".source = ../claude/settings.json;
    ".claude/output-styles" = {
      source = ../claude/output-styles;
      recursive = true;
    };
    ".claude/agents" = {
      source = ../claude/agents;
      recursive = true;
    };
    ".claude/scripts" = {
      source = ../claude/scripts;
      recursive = true;
    };
  };
}
