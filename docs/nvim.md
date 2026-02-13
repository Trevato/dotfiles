# Neovim Manual

Leader key: `Space`

Press `Space` and wait to see organized groups (find, git, code, etc.)

## Navigation

| Key | Action |
|-----|--------|
| `Space ff` | Find files (telescope) |
| `Space fg` | Live grep (telescope) |
| `Space fb` | Open buffers (telescope) |
| `Space ft` | Find TODOs (telescope) |
| `Space fr` | Resume last telescope search |
| `Space fh` | Search help docs |
| `Space fk` | Search all keymaps |
| `Space e` | Toggle file tree |
| `Space ge` | Toggle git status tree |
| `-` | Open Oil (directory editor) |
| `s` | Flash jump (type 2 chars to jump anywhere) |
| `gd` | Go to definition |
| `gr` | Find references |
| `Ctrl+h/j/k/l` | Move between windows |
| `[d` / `]d` | Previous / next diagnostic |
| `[c` / `]c` | Previous / next git hunk |
| `[m` / `]m` | Previous / next function start |
| `[M` / `]M` | Previous / next function end |
| `[[` / `]]` | Previous / next class start |

## Buffers

| Key | Action |
|-----|--------|
| `Shift+l` | Next buffer tab |
| `Shift+h` | Previous buffer tab |
| `Space bd` | Close current buffer |

## Windows

| Key | Action |
|-----|--------|
| `Ctrl+h/j/k/l` | Move between windows |
| `Ctrl+Up/Down` | Increase / decrease window height |
| `Ctrl+Right/Left` | Increase / decrease window width |

## Harpoon

| Key | Action |
|-----|--------|
| `Space ha` | Add file to harpoon |
| `Space hm` | Open harpoon menu |
| `Space 1-4` | Jump to harpoon file 1-4 |

## Editing

| Key | Mode | Action |
|-----|------|--------|
| `J` | normal | Join lines (cursor stays in place) |
| `J` / `K` | visual | Move selected lines down / up |
| `p` | visual | Paste without yanking replaced text |
| `x` | normal | Delete char without yanking |
| `Space f` | normal | Format buffer |
| `Space ca` | normal | Code actions (opens in telescope) |
| `Space rn` | normal | Rename symbol |
| `gcc` | normal | Toggle line comment |
| `gc` | visual | Toggle comment on selection |
| `Tab` / `Shift+Tab` | insert (cmp) | Next / previous completion |
| `Enter` | insert (cmp) | Accept completion |
| `Ctrl+Space` | insert (cmp) | Trigger completion |
| `Ctrl+Space` | normal | Start treesitter selection, keep pressing to expand |
| `Backspace` | visual (treesitter) | Shrink selection |

Completion popup has rounded borders with documentation preview.

## Surround

| Key | Action |
|-----|--------|
| `cs"'` | Change surrounding `"` to `'` |
| `ds)` | Delete surrounding parens |
| `ysiw)` | Wrap word in parens |
| `ysa")` | Wrap around `"` with parens |
| `S)` | (visual) Wrap selection in parens |

Works with any pair: `()` `[]` `{}` `""` `''` `` ` `` `<tag>` etc.

## Text Objects

Treesitter-powered selections for use with `v`, `d`, `c`, `y`:

| Key | Action |
|-----|--------|
| `af` / `if` | Around / inside function |
| `ac` / `ic` | Around / inside class |
| `aa` / `ia` | Around / inside argument |

mini.ai additions:

| Key | Action |
|-----|--------|
| `aq` / `iq` | Around / inside any quote |
| `ab` / `ib` | Around / inside any bracket |

## Swap

| Key | Action |
|-----|--------|
| `Space a` | Swap parameter with next |
| `Space A` | Swap parameter with previous |

## Scrolling

| Key | Action |
|-----|--------|
| `Ctrl+d` | Half page down (centered) |
| `Ctrl+u` | Half page up (centered) |
| `n` / `N` | Next / previous search result (centered) |
| `Esc` | Clear search highlights |

## Git

| Key | Action |
|-----|--------|
| `Space gg` | Open LazyGit |
| `Space ge` | Git status tree (neo-tree) |
| `]c` / `[c` | Next / previous git hunk |
| `Space ghs` | Stage hunk |
| `Space ghr` | Reset hunk |
| `Space ghp` | Preview hunk |
| `:DiffviewOpen` | Side-by-side diff of all changes |
| `:DiffviewFileHistory %` | Current file git history |
| `:DiffviewClose` | Close diffview |

Gitsigns shows inline blame on every line automatically.

## Diagnostics

| Key | Action |
|-----|--------|
| `[d` / `]d` | Jump between diagnostics |
| `Space xx` | Toggle all diagnostics (Trouble) |
| `Space xd` | Toggle buffer diagnostics (Trouble) |
| `K` | Hover documentation / error detail |

## Undo

| Key | Action |
|-----|--------|
| `Space u` | Toggle undo tree (visual history browser) |
| `u` / `Ctrl+r` | Undo / redo (standard) |

Undo history persists across sessions via undofile.

## Sessions

| Key | Action |
|-----|--------|
| `Space qs` | Restore session for current directory |
| `Space ql` | Restore last session |

Sessions save automatically when you quit. Reopen nvim in the same directory and restore.

## Experimental

These are Tier 3 plugins. Try them, keep what sticks, remove what doesn't.

### Debug (DAP)

| Key | Action |
|-----|--------|
| `Space db` | Toggle breakpoint |
| `Space dc` | Continue |
| `Space di` | Step into |
| `Space do` | Step over |
| `Space dO` | Step out |
| `Space du` | Toggle DAP UI |

Note: DAP needs debug adapters configured per language. The framework is installed but you'll need to add adapters (e.g. js-debug-adapter, debugpy) for your specific languages.

### Zen Mode + Twilight

| Key | Action |
|-----|--------|
| `Space z` | Toggle zen mode (120-char centered, no UI chrome) |

Twilight automatically dims inactive code sections when zen mode is active.

### Markdown Preview

| Key | Action |
|-----|--------|
| `Space mp` | Toggle live markdown preview in browser |

---

## Passive Features

These work automatically with no keybinding:

- **autotag** -- auto-close and auto-rename HTML/JSX tags
- **treesitter-context** -- function/class header pinned at top when scrolled deep
- **illuminate** -- other occurrences of the word under cursor highlight
- **colorizer** -- hex/rgb colors render inline
- **fidget** -- LSP progress spinner in bottom-right
- **gitsigns** -- git blame on every line, diff markers in gutter
- **indent-blankline** -- visual indent guides
- **yank highlight** -- brief flash when text is yanked
- **format on save** -- conform runs on every save
- **autopairs** -- brackets/quotes auto-close
- **which-key** -- press Space and wait to see organized groups

## LSP Servers

| Language | Server |
|----------|--------|
| TypeScript/JavaScript | ts_ls |
| ESLint | eslint |
| Nix | nil_ls |
| Python | pyright |
| Python (lint/format) | ruff |
| JSON | jsonls (schema validation) |
| YAML | yamlls (schema validation) |
| Lua | lua_ls |

## Formatters (format on save)

| Language | Formatter |
|----------|-----------|
| Nix | nixfmt |
| TS/JS/TSX/JSX | prettierd, prettier |
| Python | ruff_format |
| JSON | prettierd, prettier |
| YAML | prettierd, prettier |
| HTML | prettierd, prettier |
| CSS | prettierd, prettier |
| Markdown | prettierd, prettier |
| Lua | stylua |

## Status Line (lualine)

Left: mode | branch, diff counts, diagnostic counts | relative file path

Right: filetype | progress | location

## Options

| Setting | Value |
|---------|-------|
| Line numbers | Relative |
| Indent | 2 spaces (expandtab) |
| Clipboard | System |
| Search | Case-insensitive (smart-case when uppercase used) |
| Scroll offset | 8 lines |
| Sign column | Always visible |
| Cursor line | Highlighted |
| Splits | Open below and right |
| Line wrap | Off |
| Undo | Persistent across sessions |
| Theme | Catppuccin Mocha (transparent) |
