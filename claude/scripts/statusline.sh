#!/bin/bash
input=$(cat)

dir=$(echo "$input" | jq -r '.workspace.current_dir')
model=$(echo "$input" | jq -r '.model.display_name')
vim_mode=$(echo "$input" | jq -r '.vim.mode // empty')
pct=$(echo "$input" | jq -r '.context_window.used_percentage // 0' | cut -d. -f1)
cost=$(echo "$input" | jq -r '.cost.total_cost_usd // 0')

# Catppuccin Mocha (24-bit ANSI)
RST='\033[0m' BOLD='\033[1m'
BASE='\033[38;2;30;30;46m'
TEAL='\033[38;2;148;226;213m'
LAVENDER='\033[38;2;180;190;254m'
YELLOW='\033[38;2;249;226;175m'
MAUVE='\033[38;2;203;166;247m'
PEACH='\033[38;2;250;179;135m'
GREEN='\033[38;2;166;227;161m'
RED='\033[38;2;243;139;168m'
BLUE='\033[38;2;137;180;250m'
DIM='\033[38;2;108;112;134m'

# Vim mode badge
vim_badge=""
if [ -n "$vim_mode" ]; then
  case "$vim_mode" in
    NORMAL) vim_badge="\033[48;2;137;180;250m${BASE}${BOLD} NORMAL ${RST} " ;;
    INSERT) vim_badge="\033[48;2;166;227;161m${BASE}${BOLD} INSERT ${RST} " ;;
    VISUAL) vim_badge="\033[48;2;203;166;247m${BASE}${BOLD} VISUAL ${RST} " ;;
  esac
fi

# Git info
git_branch=$(cd "$dir" 2>/dev/null && git branch --show-current 2>/dev/null)
git_dirty=$(cd "$dir" 2>/dev/null && git status --porcelain 2>/dev/null | wc -l | tr -d ' ')
git_info=""
if [ -n "$git_branch" ]; then
  git_info=" ${LAVENDER}\uE0A0 ${git_branch}${RST}"
  [ "$git_dirty" -gt 0 ] && git_info="${git_info}${YELLOW}*${RST}"
fi

# Kube context (matches starship: ⎈ context(namespace))
kube_info=""
if command -v kubectl >/dev/null 2>&1; then
  kube_ctx=$(kubectl config current-context 2>/dev/null)
  if [ -n "$kube_ctx" ]; then
    kube_ns=$(kubectl config view --minify --output 'jsonpath={..namespace}' 2>/dev/null)
    if [ -n "$kube_ns" ]; then
      kube_info=" ${BLUE}⎈ ${kube_ctx}(${kube_ns})${RST}"
    else
      kube_info=" ${BLUE}⎈ ${kube_ctx}${RST}"
    fi
  fi
fi

# Context color (threshold-based)
if [ "$pct" -ge 90 ]; then ctx_color="$RED"
elif [ "$pct" -ge 70 ]; then ctx_color="$YELLOW"
else ctx_color="$GREEN"; fi

cost_fmt=$(printf '$%.2f' "$cost")

printf '%b' "${vim_badge}${TEAL}\uE5FF $(basename "$dir")${RST}${git_info}${kube_info} ${DIM}\uE0B1${RST} ${MAUVE}${model}${RST} ${DIM}\uE0B1${RST} ${ctx_color}${pct}%${RST} ${DIM}\uE0B1${RST} ${PEACH}${cost_fmt}${RST}"
