{ inputs, ... }:
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;
    globals.mapleader = " ";
    defaultEditor = true;

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "mocha";
        transparent_background = true;
      };
    };

    plugins = {
      # Core UI
      lualine = {
        enable = true;
        settings.sections = {
          lualine_b = [
            "branch"
            "diff"
            "diagnostics"
          ];
          lualine_c = [
            {
              __unkeyed-1 = "filename";
              path = 1;
            }
          ];
          lualine_x = [ "filetype" ];
        };
      };
      telescope = {
        enable = true;
        extensions.fzf-native.enable = true;
        extensions.ui-select.enable = true;
      };
      treesitter = {
        enable = true;
        settings.incremental_selection = {
          enable = true;
          keymaps = {
            init_selection = "<C-space>";
            node_incremental = "<C-space>";
            scope_incremental = false;
            node_decremental = "<bs>";
          };
        };
      };
      treesitter-context.enable = true;
      nvim-ts-autotag.enable = true;
      treesitter-textobjects = {
        enable = true;
        settings = {
          select = {
            enable = true;
            lookahead = true;
            keymaps = {
              "af" = "@function.outer";
              "if" = "@function.inner";
              "ac" = "@class.outer";
              "ic" = "@class.inner";
              "aa" = "@parameter.outer";
              "ia" = "@parameter.inner";
            };
          };
          move = {
            enable = true;
            set_jumps = true;
            goto_next_start = {
              "]m" = "@function.outer";
              "]]" = "@class.outer";
            };
            goto_next_end = {
              "]M" = "@function.outer";
              "][" = "@class.outer";
            };
            goto_previous_start = {
              "[m" = "@function.outer";
              "[[" = "@class.outer";
            };
            goto_previous_end = {
              "[M" = "@function.outer";
              "[]" = "@class.outer";
            };
          };
          swap = {
            enable = true;
            swap_next = {
              "<leader>a" = "@parameter.inner";
            };
            swap_previous = {
              "<leader>A" = "@parameter.inner";
            };
          };
        };
      };
      web-devicons.enable = true;
      bufferline.enable = true;
      colorizer.enable = true;

      # LSP
      lsp = {
        enable = true;
        servers = {
          ts_ls.enable = true;
          eslint.enable = true;
          nil_ls.enable = true;
          pyright.enable = true;
          ruff.enable = true;
          jsonls.enable = true;
          yamlls.enable = true;
          lua_ls.enable = true;
        };
      };
      fidget.enable = true;

      # Auto-completion
      cmp = {
        enable = true;
        settings = {
          sources = [
            { name = "nvim_lsp"; }
            { name = "luasnip"; }
            { name = "path"; }
            { name = "buffer"; }
          ];
          mapping = {
            "<Tab>" = "cmp.mapping.select_next_item()";
            "<S-Tab>" = "cmp.mapping.select_prev_item()";
            "<CR>" = "cmp.mapping.confirm({ select = true })";
            "<C-Space>" = "cmp.mapping.complete()";
          };
          window = {
            completion.__raw = "cmp.config.window.bordered()";
            documentation.__raw = "cmp.config.window.bordered()";
          };
        };
      };
      cmp-nvim-lsp.enable = true;
      cmp-path.enable = true;
      cmp-buffer.enable = true;

      # Snippets
      luasnip.enable = true;
      cmp_luasnip.enable = true;

      # Git
      gitsigns = {
        enable = true;
        settings.current_line_blame = true;
      };
      lazygit.enable = true;
      diffview.enable = true;

      # Quality of life
      which-key = {
        enable = true;
        settings.spec = [
          {
            __unkeyed-1 = "<leader>f";
            group = "find";
          }
          {
            __unkeyed-1 = "<leader>g";
            group = "git";
          }
          {
            __unkeyed-1 = "<leader>gh";
            group = "hunks";
          }
          {
            __unkeyed-1 = "<leader>x";
            group = "diagnostics";
          }
          {
            __unkeyed-1 = "<leader>q";
            group = "session";
          }
          {
            __unkeyed-1 = "<leader>c";
            group = "code";
          }
          {
            __unkeyed-1 = "<leader>h";
            group = "harpoon";
          }
          {
            __unkeyed-1 = "<leader>b";
            group = "buffer";
          }
          {
            __unkeyed-1 = "<leader>r";
            group = "refactor";
          }
        ];
      };
      indent-blankline.enable = true;
      nvim-autopairs.enable = true;
      nvim-surround.enable = true;
      ts-context-commentstring.enable = true;
      mini = {
        enable = true;
        modules.ai = { };
      };
      illuminate.enable = true;
      persistence.enable = true;
      undotree.enable = true;

      # Navigation
      neo-tree = {
        enable = true;
        settings = {
          filesystem = {
            follow_current_file.enabled = true;
            use_libuv_file_watcher = true;
            filtered_items = {
              visible = true;
              hide_dotfiles = false;
              hide_gitignored = false;
            };
          };
          window = {
            position = "left";
            width = 35;
            mappings = {
              "<space>" = "none";
            };
          };
          default_component_configs = {
            indent = {
              with_expanders = true;
            };
            git_status = {
              symbols = {
                added = "";
                modified = "";
                deleted = "";
                renamed = "➜";
                untracked = "★";
                ignored = "◌";
                unstaged = "✗";
                staged = "✓";
                conflict = "";
              };
            };
          };
        };
      };

      oil = {
        enable = true;
        settings.view_options.show_hidden = true;
      };

      harpoon.enable = true;

      flash = {
        enable = true;
        settings.modes.search.enabled = false;
      };

      # Diagnostics and todos
      trouble.enable = true;
      todo-comments.enable = true;

      # Formatting
      conform-nvim = {
        enable = true;
        settings = {
          format_on_save = {
            lsp_fallback = true;
            timeout_ms = 500;
          };
          formatters_by_ft = {
            nix = [ "nixfmt" ];
            typescript = [
              "prettierd"
              "prettier"
            ];
            javascript = [
              "prettierd"
              "prettier"
            ];
            typescriptreact = [
              "prettierd"
              "prettier"
            ];
            javascriptreact = [
              "prettierd"
              "prettier"
            ];
            python = [ "ruff_format" ];
            json = [
              "prettierd"
              "prettier"
            ];
            yaml = [
              "prettierd"
              "prettier"
            ];
            html = [
              "prettierd"
              "prettier"
            ];
            css = [
              "prettierd"
              "prettier"
            ];
            markdown = [
              "prettierd"
              "prettier"
            ];
            lua = [ "stylua" ];
          };
        };
      };
    };

    keymaps = [
      # Clear search highlights
      {
        mode = "n";
        key = "<Esc>";
        action = "<cmd>nohlsearch<cr>";
        options.desc = "Clear search highlights";
      }
      # Centered scrolling
      {
        mode = "n";
        key = "<C-d>";
        action = "<C-d>zz";
        options.desc = "Scroll down centered";
      }
      {
        mode = "n";
        key = "<C-u>";
        action = "<C-u>zz";
        options.desc = "Scroll up centered";
      }
      {
        mode = "n";
        key = "n";
        action = "nzzzv";
        options.desc = "Next search centered";
      }
      {
        mode = "n";
        key = "N";
        action = "Nzzzv";
        options.desc = "Prev search centered";
      }
      # Move lines in visual mode
      {
        mode = "v";
        key = "J";
        action = ":m '>+1<CR>gv=gv";
        options.desc = "Move selection down";
      }
      {
        mode = "v";
        key = "K";
        action = ":m '<-2<CR>gv=gv";
        options.desc = "Move selection up";
      }
      # Join lines (keep cursor)
      {
        mode = "n";
        key = "J";
        action = "mzJ`z";
        options.desc = "Join lines (keep cursor)";
      }
      # Visual paste without yanking
      {
        mode = "v";
        key = "p";
        action = ''"_dP'';
        options.desc = "Paste without yanking";
      }
      # Black hole x
      {
        mode = "n";
        key = "x";
        action = ''"_x'';
        options.desc = "Delete char without yank";
      }
      # Diagnostics
      {
        mode = "n";
        key = "[d";
        action = "<cmd>lua vim.diagnostic.goto_prev()<cr>";
        options.desc = "Previous diagnostic";
      }
      {
        mode = "n";
        key = "]d";
        action = "<cmd>lua vim.diagnostic.goto_next()<cr>";
        options.desc = "Next diagnostic";
      }
      # Buffer close
      {
        mode = "n";
        key = "<leader>bd";
        action = "<cmd>bdelete<cr>";
        options.desc = "Close buffer";
      }
      # Window resize
      {
        mode = "n";
        key = "<C-Up>";
        action = "<cmd>resize +2<cr>";
        options.desc = "Increase window height";
      }
      {
        mode = "n";
        key = "<C-Down>";
        action = "<cmd>resize -2<cr>";
        options.desc = "Decrease window height";
      }
      {
        mode = "n";
        key = "<C-Right>";
        action = "<cmd>vertical resize +2<cr>";
        options.desc = "Increase window width";
      }
      {
        mode = "n";
        key = "<C-Left>";
        action = "<cmd>vertical resize -2<cr>";
        options.desc = "Decrease window width";
      }
      # Undotree
      {
        mode = "n";
        key = "<leader>u";
        action = "<cmd>UndotreeToggle<cr>";
        options.desc = "Toggle undo tree";
      }
      # Session
      {
        mode = "n";
        key = "<leader>qs";
        action.__raw = "function() require('persistence').load() end";
        options.desc = "Restore session";
      }
      {
        mode = "n";
        key = "<leader>ql";
        action.__raw = "function() require('persistence').load({ last = true }) end";
        options.desc = "Restore last session";
      }
      # Format
      {
        mode = "n";
        key = "<leader>f";
        action = "<cmd>lua require('conform').format({ async = true, lsp_fallback = true })<cr>";
        options.desc = "Format buffer";
      }
      # LSP
      {
        mode = "n";
        key = "gd";
        action = "<cmd>lua vim.lsp.buf.definition()<cr>";
        options.desc = "Go to definition";
      }
      {
        mode = "n";
        key = "gr";
        action = "<cmd>lua vim.lsp.buf.references()<cr>";
        options.desc = "Find references";
      }
      {
        mode = "n";
        key = "K";
        action = "<cmd>lua vim.lsp.buf.hover()<cr>";
        options.desc = "Hover documentation";
      }
      {
        mode = "n";
        key = "<leader>ca";
        action = "<cmd>lua vim.lsp.buf.code_action()<cr>";
        options.desc = "Code actions";
      }
      {
        mode = "n";
        key = "<leader>rn";
        action = "<cmd>lua vim.lsp.buf.rename()<cr>";
        options.desc = "Rename symbol";
      }
      # Telescope
      {
        mode = "n";
        key = "<leader>ff";
        action = "<cmd>Telescope find_files<cr>";
        options.desc = "Find files";
      }
      {
        mode = "n";
        key = "<leader>fg";
        action = "<cmd>Telescope live_grep<cr>";
        options.desc = "Live grep";
      }
      {
        mode = "n";
        key = "<leader>fb";
        action = "<cmd>Telescope buffers<cr>";
        options.desc = "Buffers";
      }
      # Telescope extras
      {
        mode = "n";
        key = "<leader>fr";
        action = "<cmd>Telescope resume<cr>";
        options.desc = "Resume last search";
      }
      {
        mode = "n";
        key = "<leader>fh";
        action = "<cmd>Telescope help_tags<cr>";
        options.desc = "Help tags";
      }
      {
        mode = "n";
        key = "<leader>fk";
        action = "<cmd>Telescope keymaps<cr>";
        options.desc = "Search keymaps";
      }
      # Git
      {
        mode = "n";
        key = "<leader>gg";
        action = "<cmd>LazyGit<cr>";
        options.desc = "LazyGit";
      }
      # Gitsigns hunks
      {
        mode = "n";
        key = "]c";
        action.__raw = "function() if vim.wo.diff then vim.cmd.normal({']c', bang = true}) else require('gitsigns').nav_hunk('next') end end";
        options.desc = "Next git hunk";
      }
      {
        mode = "n";
        key = "[c";
        action.__raw = "function() if vim.wo.diff then vim.cmd.normal({'[c', bang = true}) else require('gitsigns').nav_hunk('prev') end end";
        options.desc = "Previous git hunk";
      }
      {
        mode = "n";
        key = "<leader>ghs";
        action = "<cmd>Gitsigns stage_hunk<cr>";
        options.desc = "Stage hunk";
      }
      {
        mode = "n";
        key = "<leader>ghr";
        action = "<cmd>Gitsigns reset_hunk<cr>";
        options.desc = "Reset hunk";
      }
      {
        mode = "n";
        key = "<leader>ghp";
        action = "<cmd>Gitsigns preview_hunk<cr>";
        options.desc = "Preview hunk";
      }
      # Neo-tree
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<cr>";
        options.desc = "Toggle file tree";
      }
      {
        mode = "n";
        key = "<leader>ge";
        action = "<cmd>Neotree git_status toggle<cr>";
        options.desc = "Git status tree";
      }
      # Oil
      {
        mode = "n";
        key = "-";
        action = "<cmd>Oil<cr>";
        options.desc = "Open Oil";
      }
      # Buffer navigation
      {
        mode = "n";
        key = "<S-h>";
        action = "<cmd>bprevious<cr>";
        options.desc = "Previous buffer";
      }
      {
        mode = "n";
        key = "<S-l>";
        action = "<cmd>bnext<cr>";
        options.desc = "Next buffer";
      }
      # Window navigation
      {
        mode = "n";
        key = "<C-h>";
        action = "<C-w>h";
        options.desc = "Window left";
      }
      {
        mode = "n";
        key = "<C-j>";
        action = "<C-w>j";
        options.desc = "Window down";
      }
      {
        mode = "n";
        key = "<C-k>";
        action = "<C-w>k";
        options.desc = "Window up";
      }
      {
        mode = "n";
        key = "<C-l>";
        action = "<C-w>l";
        options.desc = "Window right";
      }
      # Trouble
      {
        mode = "n";
        key = "<leader>xx";
        action = "<cmd>Trouble diagnostics toggle<cr>";
        options.desc = "Diagnostics (Trouble)";
      }
      {
        mode = "n";
        key = "<leader>xd";
        action = "<cmd>Trouble diagnostics toggle filter.buf=0<cr>";
        options.desc = "Buffer diagnostics";
      }
      # Todo-comments
      {
        mode = "n";
        key = "<leader>ft";
        action = "<cmd>TodoTelescope<cr>";
        options.desc = "Find todos";
      }
      # Flash
      {
        mode = [
          "n"
          "x"
          "o"
        ];
        key = "s";
        action.__raw = "function() require('flash').jump() end";
        options.desc = "Flash jump";
      }
      # Harpoon
      {
        mode = "n";
        key = "<leader>ha";
        action.__raw = "function() require'harpoon':list():add() end";
        options.desc = "Harpoon add file";
      }
      {
        mode = "n";
        key = "<leader>hm";
        action.__raw = "function() require'harpoon'.ui:toggle_quick_menu(require'harpoon':list()) end";
        options.desc = "Harpoon menu";
      }
      {
        mode = "n";
        key = "<leader>1";
        action.__raw = "function() require'harpoon':list():select(1) end";
        options.desc = "Harpoon file 1";
      }
      {
        mode = "n";
        key = "<leader>2";
        action.__raw = "function() require'harpoon':list():select(2) end";
        options.desc = "Harpoon file 2";
      }
      {
        mode = "n";
        key = "<leader>3";
        action.__raw = "function() require'harpoon':list():select(3) end";
        options.desc = "Harpoon file 3";
      }
      {
        mode = "n";
        key = "<leader>4";
        action.__raw = "function() require'harpoon':list():select(4) end";
        options.desc = "Harpoon file 4";
      }
    ];

    autoCmd = [
      {
        event = "TextYankPost";
        callback.__raw = "function() vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 }) end";
      }
    ];

    opts = {
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      clipboard = "unnamedplus";
      undofile = true;
      wrap = false;
      tabstop = 2;
      expandtab = true;
      ignorecase = true;
      smartcase = true;
      scrolloff = 8;
      signcolumn = "yes";
      cursorline = true;
      splitbelow = true;
      splitright = true;
    };

    highlightOverride = {
      LineNr = {
        fg = "#7f849c";
      }; # overlay1 - visible on transparent
      CursorLineNr = {
        fg = "#cdd6f4";
      }; # text - bright for current line
    };
  };
}
