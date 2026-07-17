{
  inputs,
  pkgs,
  lib,
  ...
}:
let
  banner = import ../lib/ascii-banner.nix { inherit lib; };
  dashboardName = "trevato";
  dashboardSubtitle = "trevato.dev  ·  github.com/trevato";
in
{
  imports = [ inputs.nixvim.homeModules.nixvim ];

  programs.nixvim = {
    enable = true;
    version.enableNixpkgsReleaseCheck = false; # tracking unstable; silence version-skew warning
    globals = {
      mapleader = " ";
      # dadbod-ui: drawer sized like neo-tree, icons, auto-run table helpers on open
      db_ui_use_nerd_fonts = 1;
      db_ui_winwidth = 35;
      db_ui_auto_execute_table_helpers = 1;
      db_ui_show_help = 0; # `?` still toggles the cheatsheet
      # stable prefix so scratch query buffers are identifiable even unloaded
      db_ui_tmp_query_location = "~/.local/state/nvim/dbui-queries";
      db_ui_use_nvim_notify = 1; # route messages through snacks notifier
      db_ui_disable_info_notifications = 1; # errors/warnings only, no chatter
      # tables first — browsing a schema is the primary gesture
      db_ui_drawer_sections = [
        "schemas"
        "new_query"
        "buffers"
        "saved_queries"
      ];
      # chevrons match neo-tree's expanders (oct-chevron down/right)
      db_ui_icons.__raw = ''
        {
          expanded = "\u{f47c}",
          collapsed = "\u{f460}",
        }
      '';
    };
    defaultEditor = true;

    colorschemes.catppuccin = {
      enable = true;
      settings = {
        flavour = "auto";
        background = {
          light = "latte";
          dark = "mocha";
        };
        transparent_background = true;
        show_end_of_buffer = false;
        term_colors = true;
        no_italic = false;
        no_bold = false;
        styles = {
          comments = [ "italic" ];
          conditionals = [ "italic" ];
          keywords = [ "italic" ];
          functions = [ ];
          types = [ ];
          operators = [ ];
          strings = [ ];
          variables = [ ];
          numbers = [ ];
          booleans = [ ];
          properties = [ ];
          loops = [ ];
        };
        integrations = {
          blink_cmp = true;
          gitsigns = true;
          neotree = true;
          treesitter = true;
          treesitter_context = true;
          telescope.enabled = true;
          which_key = true;
          notify = true;
          noice = true;
          mini.enabled = true;
          render_markdown = true;
          indent_blankline.enabled = true;
          markdown = true;
          mason = true;
          dap = true;
          dap_ui = true;
          fidget = true;
          flash = true;
          harpoon = true;
          illuminate.enabled = true;
          native_lsp = {
            enabled = true;
            virtual_text = {
              errors = [ "italic" ];
              hints = [ "italic" ];
              warnings = [ "italic" ];
              information = [ "italic" ];
            };
            underlines = {
              errors = [ "undercurl" ];
              hints = [ "undercurl" ];
              warnings = [ "undercurl" ];
              information = [ "undercurl" ];
            };
            inlay_hints = {
              background = false;
            };
          };
          snacks = {
            enabled = true;
          };
        };
        custom_highlights.__raw = ''
          function(colors)
            return {
              -- Line numbers: dim inactive, gentle active
              LineNr = { fg = colors.surface2 },
              CursorLineNr = { fg = colors.lavender, bold = true },
              -- Cursor line: near-invisible tint, no harsh bar
              CursorLine = { bg = colors.mantle },
              ColorColumn = { bg = colors.mantle },
              -- Floats: unified, quiet surface with soft border
              NormalFloat = { bg = colors.mantle },
              FloatBorder = { fg = colors.surface1, bg = colors.mantle },
              FloatTitle = { fg = colors.lavender, bg = colors.mantle, bold = true },
              -- Window separators: almost-invisible hairline
              WinSeparator = { fg = colors.surface0 },
              VertSplit = { fg = colors.surface0 },
              -- Completion menu: soft, layered
              Pmenu = { bg = colors.mantle, fg = colors.text },
              PmenuSel = { bg = colors.surface1, bold = true },
              PmenuSbar = { bg = colors.mantle },
              PmenuThumb = { bg = colors.surface1 },
              -- Telescope: matching float look
              TelescopeNormal = { bg = colors.mantle },
              TelescopeBorder = { fg = colors.surface1, bg = colors.mantle },
              TelescopePromptNormal = { bg = colors.crust },
              TelescopePromptBorder = { fg = colors.crust, bg = colors.crust },
              TelescopePromptTitle = { fg = colors.crust, bg = colors.lavender, bold = true },
              TelescopePreviewTitle = { fg = colors.crust, bg = colors.green, bold = true },
              TelescopeResultsTitle = { fg = colors.mantle, bg = colors.mantle },
              -- Inlay hints: whisper, no block bg
              LspInlayHint = { fg = colors.overlay0, bg = "NONE", italic = true },
              -- Diagnostics: muted virtual text so it never shouts
              DiagnosticVirtualTextError = { fg = colors.red, bg = "NONE" },
              DiagnosticVirtualTextWarn  = { fg = colors.yellow, bg = "NONE" },
              DiagnosticVirtualTextInfo  = { fg = colors.sky, bg = "NONE" },
              DiagnosticVirtualTextHint  = { fg = colors.teal, bg = "NONE" },
              DiagnosticUnnecessary = { fg = colors.overlay0 },
              -- Indent guides: whisper-quiet
              IndentBlanklineChar = { fg = colors.surface0 },
              IndentBlanklineContextChar = { fg = colors.surface2 },
              -- Visual: softer than default
              Visual = { bg = colors.surface1 },
              -- Folded: neutral
              Folded = { bg = colors.mantle, fg = colors.overlay1 },
              -- Search: less aggressive
              Search = { bg = colors.surface2, fg = colors.text },
              IncSearch = { bg = colors.peach, fg = colors.base },
              CurSearch = { bg = colors.peach, fg = colors.base },
              -- Markdown code blocks: slightly raised surface
              RenderMarkdownCode = { bg = colors.mantle },
              RenderMarkdownCodeInline = { bg = colors.mantle, fg = colors.green },
              RenderMarkdownH1Bg = { bg = colors.mantle, fg = colors.red };
              RenderMarkdownH2Bg = { bg = colors.mantle, fg = colors.peach };
              RenderMarkdownH3Bg = { bg = colors.mantle, fg = colors.yellow };
              RenderMarkdownH4Bg = { bg = colors.mantle, fg = colors.green };
              RenderMarkdownH5Bg = { bg = colors.mantle, fg = colors.sapphire };
              RenderMarkdownH6Bg = { bg = colors.mantle, fg = colors.lavender };
              -- DBUI drawer: palette colors instead of the plugin's hardcoded greens
              dbui_connection_source = { fg = colors.overlay0, italic = true },
              dbui_connection_ok = { fg = colors.green },
              dbui_connection_error = { fg = colors.red },
              dbui_help = { fg = colors.overlay0, italic = true },
              dbui_help_key = { fg = colors.green },
              dbui_saved_query = { fg = colors.teal },
              dbui_new_query = { fg = colors.mauve },
              dbui_buffers = { fg = colors.peach },
              dbui_tables = { fg = colors.sapphire },
              -- Dashboard
              SnacksDashboardHeader = { fg = colors.mauve },
              SnacksDashboardIcon = { fg = colors.blue },
              SnacksDashboardKey = { fg = colors.green },
              SnacksDashboardDesc = { fg = colors.text },
              SnacksDashboardTitle = { fg = colors.yellow, bold = true },
              SnacksDashboardFooter = { fg = colors.overlay0 },
            }
          end
        '';
      };
    };

    plugins = {
      # Core UI
      lualine = {
        enable = true;
        settings = {
          options = {
            theme = "catppuccin";
            globalstatus = true;
            section_separators = {
              left = "";
              right = "";
            };
            component_separators = {
              left = "";
              right = "";
            };
            disabled_filetypes = {
              statusline = [
                "dashboard"
                "snacks_dashboard"
              ];
            };
          };
          sections = {
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
      nvim-ufo = {
        enable = true;
        settings = {
          open_fold_hl_timeout = 150;
          close_fold_kinds_for_ft = {
            default = [
              "imports"
              "comment"
            ];
          };
          preview = {
            win_config = {
              border = [
                ""
                "─"
                ""
                ""
                ""
                "─"
                ""
                ""
              ];
              winblend = 0;
            };
            mappings = {
              scrollU = "<C-u>";
              scrollD = "<C-d>";
              jumpTop = "[";
              jumpBot = "]";
            };
          };
          provider_selector.__raw = ''
            function(bufnr, filetype, buftype)
              return {'treesitter', 'indent'}
            end
          '';
          fold_virt_text_handler.__raw = ''
            function(virtText, lnum, endLnum, width, truncate)
              local newVirtText = {}
              local suffix = ('  %d '):format(endLnum - lnum)
              local sufWidth = vim.fn.strdisplaywidth(suffix)
              local targetWidth = width - sufWidth
              local curWidth = 0
              for _, chunk in ipairs(virtText) do
                local chunkText = chunk[1]
                local chunkWidth = vim.fn.strdisplaywidth(chunkText)
                if targetWidth > curWidth + chunkWidth then
                  table.insert(newVirtText, chunk)
                else
                  chunkText = truncate(chunkText, targetWidth - curWidth)
                  local hlGroup = chunk[2]
                  table.insert(newVirtText, {chunkText, hlGroup})
                  chunkWidth = vim.fn.strdisplaywidth(chunkText)
                  if curWidth + chunkWidth < targetWidth then
                    suffix = suffix .. (' '):rep(targetWidth - curWidth - chunkWidth)
                  end
                  break
                end
                curWidth = curWidth + chunkWidth
              end
              table.insert(newVirtText, {suffix, 'Folded'})
              return newVirtText
            end
          '';
        };
      };
      statuscol = {
        enable = true;
        settings = {
          relculright = true;
          segments = [
            {
              text = [ "%s" ];
              click = "v:lua.ScSa";
            }
            {
              text = [
                { __raw = ''require("statuscol.builtin").lnumfunc''; }
                " "
              ];
              click = "v:lua.ScLa";
            }
            {
              text = [
                { __raw = ''require("statuscol.builtin").foldfunc''; }
                " "
              ];
              click = "v:lua.ScFa";
            }
          ];
        };
      };
      ts-autotag.enable = true;
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
              "<leader>sa" = "@parameter.inner";
            };
            swap_previous = {
              "<leader>sA" = "@parameter.inner";
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

      # Auto-completion (blink.cmp — modern replacement for nvim-cmp)
      blink-cmp = {
        enable = true;
        setupLspCapabilities = true;
        settings = {
          keymap = {
            preset = "default";
            "<Tab>" = [
              "select_next"
              "snippet_forward"
              "fallback"
            ];
            "<S-Tab>" = [
              "select_prev"
              "snippet_backward"
              "fallback"
            ];
            "<CR>" = [
              "accept"
              "fallback"
            ];
            "<C-Space>" = [
              "show"
              "show_documentation"
              "hide_documentation"
            ];
          };
          appearance = {
            use_nvim_cmp_as_default = false;
            nerd_font_variant = "mono";
          };
          completion = {
            accept.auto_brackets.enabled = true;
            list.selection = {
              preselect = true;
              auto_insert = false;
            };
            menu = {
              border = "rounded";
              draw = {
                treesitter = [ "lsp" ];
                columns = [
                  {
                    __unkeyed-1 = "label";
                    __unkeyed-2 = "label_description";
                    gap = 1;
                  }
                  {
                    __unkeyed-1 = "kind_icon";
                    __unkeyed-2 = "kind";
                    gap = 1;
                  }
                ];
              };
            };
            documentation = {
              auto_show = true;
              auto_show_delay_ms = 200;
              window.border = "rounded";
            };
            ghost_text.enabled = true;
          };
          signature = {
            enabled = true;
            window.border = "rounded";
          };
          sources = {
            default = [
              "lsp"
              "path"
              "snippets"
              "buffer"
            ];
            per_filetype = {
              sql = [
                "dadbod"
                "buffer"
              ];
            };
            providers.dadbod = {
              name = "Dadbod";
              module = "vim_dadbod_completion.blink";
            };
          };
        };
      };

      # Snippets
      luasnip.enable = true;

      # Git
      gitsigns = {
        enable = true;
        settings.current_line_blame = true;
      };
      lazygit.enable = true;
      diffview.enable = true;

      # Database (dadbod) — SQLite files open as a browsable DB, see the
      # BufReadCmd autocmd below
      vim-dadbod.enable = true;
      vim-dadbod-ui.enable = true;
      vim-dadbod-completion.enable = true;

      # Quality of life
      which-key = {
        enable = true;
        settings.preset = "helix";
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
          {
            __unkeyed-1 = "<leader>d";
            group = "debug";
          }
          {
            __unkeyed-1 = "<leader>s";
            group = "swap";
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

      # Dashboard
      snacks = {
        enable = true;
        settings = {
          quickfile.enabled = true;
          notifier.enabled = true;
          dashboard = {
            enabled = true;
            width = 72;
            pane_gap = 4;
            preset = {
              header.__raw =
                "[[\n"
                + banner.renderBanner {
                  name = dashboardName;
                  subtitle = dashboardSubtitle;
                }
                + "]]";
              keys = [
                {
                  icon = " ";
                  key = "f";
                  desc = "Find file";
                  action = ":Telescope find_files";
                }
                {
                  icon = " ";
                  key = "g";
                  desc = "Live grep";
                  action = ":Telescope live_grep";
                }
                {
                  icon = " ";
                  key = "r";
                  desc = "Recent files";
                  action = ":Telescope oldfiles";
                }
                {
                  icon = " ";
                  key = "s";
                  desc = "Restore session";
                  action.__raw = "function() require('persistence').load() end";
                }
                {
                  icon = " ";
                  key = "e";
                  desc = "Explorer";
                  action = ":Neotree toggle";
                }
                {
                  icon = " ";
                  key = "n";
                  desc = "New file";
                  action = ":ene | startinsert";
                }
                {
                  icon = " ";
                  key = "q";
                  desc = "Quit";
                  action = ":qa";
                }
              ];
            };
            sections = [
              # ── Left pane ──
              {
                section = "header";
                pane = 1;
              }
              {
                section = "keys";
                title = "Quick Actions";
                icon = " ";
                pane = 1;
                gap = 1;
                padding = 1;
              }
              # TUI launchers
              {
                title = "Launchers";
                icon = " ";
                pane = 1;
                padding = 1;
              }
              {
                icon = "󰒲 ";
                key = "l";
                desc = "lazygit";
                action.__raw = "function() _G.dash_launch('lazygit') end";
                pane = 1;
                indent = 2;
              }
              {
                icon = " ";
                key = "d";
                desc = "lazydocker";
                action.__raw = "function() _G.dash_launch('lazydocker') end";
                pane = 1;
                indent = 2;
              }
              {
                icon = "⎈ ";
                key = "k";
                desc = "k9s";
                action.__raw = "function() _G.dash_launch('k9s') end";
                pane = 1;
                indent = 2;
              }
              {
                icon = " ";
                key = "b";
                desc = "btop";
                action.__raw = "function() _G.dash_launch('btop') end";
                pane = 1;
                indent = 2;
              }
              {
                section = "recent_files";
                title = "Recent Files";
                icon = " ";
                pane = 1;
                limit = 5;
                cwd = true;
                indent = 2;
                padding = 1;
              }
              # ── Right pane: Git (3 views) ──
              {
                section = "terminal";
                cmd = "git log --oneline --decorate -8 2>/dev/null";
                title = "Recent Commits";
                icon = " ";
                height = 10;
                pane = 2;
                indent = 2;
                padding = 1;
                ttl = 300;
                key = "L";
                action.__raw = "function() _G.dash_launch('lazygit') end";
                enabled.__raw = "function() return _G.dash.git == 1 and Snacks.git.get_root() ~= nil end";
              }
              {
                section = "terminal";
                cmd = "git branch -a --sort=-committerdate 2>/dev/null | head -10";
                title = "Branches";
                icon = " ";
                height = 10;
                pane = 2;
                indent = 2;
                padding = 1;
                ttl = 300;
                enabled.__raw = "function() return _G.dash.git == 2 and Snacks.git.get_root() ~= nil end";
              }
              {
                section = "terminal";
                cmd = "git diff --stat 2>/dev/null; echo ''; git status --short 2>/dev/null | head -8";
                title = "Changes";
                icon = " ";
                height = 10;
                pane = 2;
                indent = 2;
                padding = 1;
                ttl = 300;
                enabled.__raw = "function() return _G.dash.git == 3 and Snacks.git.get_root() ~= nil end";
              }
              # ── Right pane: Docker (2 views) ──
              {
                section = "terminal";
                cmd = "docker ps --format 'table {{.Names}}\\t{{.Status}}' 2>/dev/null | head -8";
                title = "Containers";
                icon = " ";
                height = 8;
                pane = 2;
                indent = 2;
                padding = 1;
                ttl = 120;
                key = "D";
                action.__raw = "function() _G.dash_launch('lazydocker') end";
                enabled.__raw = "function() return _G.dash.docker == 1 and vim.fn.executable('docker') == 1 end";
              }
              {
                section = "terminal";
                cmd = "docker images --format 'table {{.Repository}}\\t{{.Tag}}\\t{{.Size}}' 2>/dev/null | head -8";
                title = "Images";
                icon = " ";
                height = 8;
                pane = 2;
                indent = 2;
                padding = 1;
                ttl = 120;
                enabled.__raw = "function() return _G.dash.docker == 2 and vim.fn.executable('docker') == 1 end";
              }
              # ── Right pane: Kubernetes (2 views) ──
              {
                section = "terminal";
                cmd = "ctx=$(kubectl config current-context 2>/dev/null || echo 'none'); ns=$(kubectl config view --minify -o jsonpath='{.contexts[0].context.namespace}' 2>/dev/null || echo 'default'); echo \"$ctx · $ns\"";
                title = "Kubernetes";
                icon = "⎈ ";
                height = 3;
                pane = 2;
                indent = 2;
                padding = 1;
                ttl = 120;
                key = "K";
                action.__raw = "function() _G.dash_launch('k9s') end";
                enabled.__raw = "function() return _G.dash.kube == 1 and vim.fn.executable('kubectl') == 1 end";
              }
              {
                section = "terminal";
                cmd = "kubectl get pods --no-headers --request-timeout=3s 2>/dev/null | head -8";
                title = "Pods";
                icon = "⎈ ";
                height = 8;
                pane = 2;
                indent = 2;
                padding = 1;
                ttl = 120;
                enabled.__raw = "function() return _G.dash.kube == 2 and vim.fn.executable('kubectl') == 1 end";
              }
            ];
          };
        };
      };

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

      # Experimental
      dap.enable = true;
      dap-ui.enable = true;
      dap-virtual-text.enable = true;
      zen-mode = {
        enable = true;
        settings = {
          window = {
            backdrop = 0.95;
            width = 88;
            height = 1;
            options = {
              signcolumn = "no";
              number = false;
              relativenumber = false;
              cursorline = false;
              cursorcolumn = false;
              foldcolumn = "0";
              list = false;
              spell = true;
              linebreak = true;
            };
          };
          plugins = {
            twilight.enabled = true;
            gitsigns.enabled = false;
            options = {
              enabled = true;
              laststatus = 0;
            };
          };
          on_open.__raw = ''
            function(win)
              vim.opt_local.conceallevel = 2
            end
          '';
        };
      };
      twilight.enable = true;
      markdown-preview = {
        enable = true;
        settings.auto_close = 1;
      };
      noice = {
        enable = true;
        settings = {
          cmdline = {
            view = "cmdline";
          };
          lsp = {
            override = {
              "vim.lsp.util.convert_input_to_markdown_lines" = true;
              "vim.lsp.util.stylize_markdown" = true;
              "cmp.entry.get_documentation" = true;
            };
          };
          presets = {
            bottom_search = true;
            command_palette = false;
            long_message_to_split = true;
            inc_rename = true;
            lsp_doc_border = true;
          };
          routes = [
            {
              filter = {
                event = "msg_show";
                kind = "";
                find = "written";
              };
              opts.skip = true;
            }
          ];
        };
      };
      render-markdown = {
        enable = true;
        settings = {
          file_types = [ "markdown" ];
          completions.lsp.enabled = true;
          code.width = "block";
          heading.width = "block";
        };
      };

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

    extraPlugins = [
      pkgs.vimPlugins.incline-nvim
      pkgs.vimPlugins.satellite-nvim
    ];

    extraPackages = [
      pkgs.sqlite # dadbod shells out to sqlite3
    ];

    extraConfigLua = ''
      -- Floating per-window filenames (shows which split is which)
      require('incline').setup({
        hide = { cursorline = true },
        window = {
          padding = 0,
          margin = { horizontal = 1, vertical = 1 },
          placement = { horizontal = "right", vertical = "top" },
        },
        render = function(props)
          local filename = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(props.buf), ":t")
          if filename == "" then filename = "[No Name]" end
          local modified = vim.bo[props.buf].modified
          local ok, devicons = pcall(require, "nvim-web-devicons")
          local icon, icon_color
          if ok then
            icon, icon_color = devicons.get_icon_color(filename)
          end
          return {
            icon and { icon, guifg = icon_color } or "",
            icon and " " or "",
            { filename, gui = modified and "bold,italic" or "bold" },
            guibg = "#181825",
          }
        end,
      })

      -- Scrollbar with diagnostic, search, and git hunk markers
      require('satellite').setup({
        current_only = false,
        winblend = 50,
        zindex = 40,
        excluded_filetypes = {
          "neo-tree",
          "dashboard",
          "snacks_dashboard",
          "TelescopePrompt",
          "lazy",
          "mason",
          "help",
          "dbui",
        },
        handlers = {
          cursor = { enable = true, symbols = { "▶" } },
          search = { enable = true },
          diagnostic = { enable = true, signs = { "-", "=", "≡" } },
          gitsigns = {
            enable = true,
            signs = { add = "│", change = "│", delete = "-" },
          },
          marks = { enable = false },
        },
      })

      -- Calm diagnostics: icon-only signs, dimmed virtual text with soft prefix
      vim.diagnostic.config({
        severity_sort = true,
        update_in_insert = false,
        virtual_text = {
          prefix = "▎",
          spacing = 2,
        },
        float = {
          border = "rounded",
          source = "if_many",
        },
        signs = {
          text = {
            [vim.diagnostic.severity.ERROR] = "",
            [vim.diagnostic.severity.WARN]  = "",
            [vim.diagnostic.severity.INFO]  = "",
            [vim.diagnostic.severity.HINT]  = "",
          },
        },
      })

      -- The file tree and database drawer share the left slot; opening one
      -- evicts the other so the editor never gets squeezed by two sidebars
      local function win_with_ft(ft)
        for _, w in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
          if vim.bo[vim.api.nvim_win_get_buf(w)].filetype == ft then
            return w
          end
        end
      end
      function _G.toggle_tree(cmd)
        if win_with_ft("dbui") then
          pcall(vim.cmd, "DBUIClose")
        end
        vim.cmd(cmd)
      end
      function _G.toggle_db_drawer()
        if not win_with_ft("dbui") and win_with_ft("neo-tree") then
          pcall(vim.cmd, "Neotree close")
        end
        vim.cmd("DBUIToggle")
      end

      -- Dashboard state for cycling views
      _G.dash = {
        git = 1, git_max = 3,
        docker = 1, docker_max = 2,
        kube = 1, kube_max = 2,
      }

      function _G.dash_cycle(section, dir)
        local max_val = _G.dash[section .. "_max"]
        _G.dash[section] = ((_G.dash[section] - 1 + dir) % max_val) + 1
      end

      function _G.dash_cycle_all(dir)
        _G.dash_cycle("git", dir)
        _G.dash_cycle("docker", dir)
        _G.dash_cycle("kube", dir)
        Snacks.dashboard()
      end

      function _G.dash_launch(cmd)
        Snacks.terminal(cmd, {
          win = { position = "float", width = 0.9, height = 0.9 },
        })
      end
    '';

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
      # Folding (UFO)
      {
        mode = "n";
        key = "zR";
        action.__raw = ''function() require("ufo").openAllFolds() end'';
        options.desc = "Open all folds";
      }
      {
        mode = "n";
        key = "zM";
        action.__raw = ''function() require("ufo").closeAllFolds() end'';
        options.desc = "Close all folds";
      }
      {
        mode = "n";
        key = "zK";
        action.__raw = ''
          function()
            local winid = require("ufo").peekFoldedLinesUnderCursor()
            if not winid then vim.lsp.buf.hover() end
          end
        '';
        options.desc = "Peek fold / hover";
      }
      # Diagnostics
      {
        mode = "n";
        key = "[d";
        action = "<cmd>lua vim.diagnostic.jump({ count = -1, float = true })<cr>";
        options.desc = "Previous diagnostic";
      }
      {
        mode = "n";
        key = "]d";
        action = "<cmd>lua vim.diagnostic.jump({ count = 1, float = true })<cr>";
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
      # Debug
      {
        mode = "n";
        key = "<leader>db";
        action.__raw = "function() require('dap').toggle_breakpoint() end";
        options.desc = "Toggle breakpoint";
      }
      {
        mode = "n";
        key = "<leader>dc";
        action.__raw = "function() require('dap').continue() end";
        options.desc = "Continue";
      }
      {
        mode = "n";
        key = "<leader>di";
        action.__raw = "function() require('dap').step_into() end";
        options.desc = "Step into";
      }
      {
        mode = "n";
        key = "<leader>do";
        action.__raw = "function() require('dap').step_over() end";
        options.desc = "Step over";
      }
      {
        mode = "n";
        key = "<leader>dO";
        action.__raw = "function() require('dap').step_out() end";
        options.desc = "Step out";
      }
      {
        mode = "n";
        key = "<leader>du";
        action.__raw = "function() require('dapui').toggle() end";
        options.desc = "Toggle DAP UI";
      }
      # Zen
      {
        mode = "n";
        key = "<leader>z";
        action = "<cmd>ZenMode<cr>";
        options.desc = "Zen mode";
      }
      # Markdown preview
      {
        mode = "n";
        key = "<leader>mp";
        action = "<cmd>MarkdownPreviewToggle<cr>";
        options.desc = "Markdown preview";
      }
      # Format — lives under the code group; a bare <leader>f would shadow
      # the find group (<leader>ff, <leader>fg, …) behind a timeoutlen wait
      {
        mode = "n";
        key = "<leader>cf";
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
        action.__raw = ''function() _G.toggle_tree("Neotree toggle") end'';
        options.desc = "Toggle file tree";
      }
      {
        mode = "n";
        key = "<leader>ge";
        action.__raw = ''function() _G.toggle_tree("Neotree git_status toggle") end'';
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
      # Dashboard
      {
        mode = "n";
        key = "<leader>;";
        action.__raw = "function() Snacks.dashboard() end";
        options.desc = "Dashboard";
      }
      # Database
      {
        mode = "n";
        key = "<leader>D";
        action.__raw = "function() _G.toggle_db_drawer() end";
        options.desc = "Database UI";
      }
    ];

    autoCmd = [
      {
        event = "TextYankPost";
        callback.__raw = "function() vim.highlight.on_yank({ higroup = 'IncSearch', timeout = 200 }) end";
      }
      {
        event = "FileType";
        pattern = "markdown";
        callback.__raw = ''
          function()
            vim.opt_local.conceallevel = 2
            vim.opt_local.concealcursor = "nc"
            vim.opt_local.spell = true
          end
        '';
      }
      {
        # SQLite files open as a browsable database (DBUI), not a binary dump.
        # Non-SQLite .db files (checked via magic header) fall back to a plain read.
        event = "BufReadCmd";
        pattern = [
          "*.db"
          "*.sqlite"
          "*.sqlite3"
        ];
        callback.__raw = ''
          function(ev)
            local path = vim.fn.fnamemodify(ev.file, ":p")
            local f = io.open(path, "rb")
            local header = f and f:read(16) or nil
            if f then f:close() end
            if header ~= "SQLite format 3\0" then
              vim.cmd("silent keepalt read ++edit " .. vim.fn.fnameescape(path))
              vim.api.nvim_buf_set_lines(ev.buf, 0, 1, false, {})
              vim.bo[ev.buf].modified = false
              return
            end
            local url = "sqlite:" .. path
            -- one gesture can fire BufReadCmd twice (a picker window reopening
            -- the file in a target window); a second toggle would re-collapse
            local opening = vim.g._dbui_opening or {}
            local now = vim.uv.now()
            local debounced = opening[url] ~= nil and (now - opening[url]) < 2000
            opening[url] = now
            vim.g._dbui_opening = opening
            -- last-opened db owns the drawer; an in-flight expand for an
            -- earlier open aborts when it sees the focus moved on
            vim.g._dbui_focus = url
            local dbs = vim.g.dbs or {}
            local known = false
            for _, db in ipairs(dbs) do
              if db.url == url then
                known = true
                break
              end
            end
            if not known then
              table.insert(dbs, { name = vim.fn.fnamemodify(path, ":t"), url = url })
              vim.g.dbs = dbs
            end
            vim.schedule(function()
              if vim.api.nvim_buf_is_valid(ev.buf) then
                pcall(vim.api.nvim_buf_delete, ev.buf, { force = true })
              end
            end)
            if debounced then
              return
            end
            -- let picker/tree window-shuffling autocmds settle before touching
            -- the layout, or their recovery logic tears the drawer back down
            vim.defer_fn(function()
              if vim.g._dbui_focus ~= url then
                return
              end
              -- the drawer takes the file tree's slot; <leader>e brings the tree back
              pcall(vim.cmd, "Neotree close")
              pcall(vim.cmd, "DBUI")
              -- focus the drawer explicitly; DBUI's focus isn't guaranteed here
              for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                if vim.bo[vim.api.nvim_win_get_buf(win)].filetype == "dbui" then
                  vim.api.nvim_set_current_win(win)
                  break
                end
              end
              if vim.bo.filetype ~= "dbui" then
                return
              end
              -- Opening a database means focusing it: retire the previous
              -- one's results windows and scratch query buffers (buffers with
              -- unsaved edits survive). This must run with the drawer OPEN —
              -- dadbod's own BufDelete handlers re-render the drawer and
              -- misbehave against a closed one. Identify scratch buffers by
              -- their tmp-location path — window shuffles can unload them,
              -- which strips filetype and buffer-local marks.
              local tmploc = vim.fn.fnamemodify(vim.fn.expand(vim.g.db_ui_tmp_query_location), ":p"):gsub("/$", "")
              local function dadbod_scratch_kind(b)
                local bufname = vim.api.nvim_buf_get_name(b)
                if bufname:sub(-6) == ".dbout" then
                  return "dbout"
                end
                if bufname:sub(1, #tmploc) == tmploc then
                  return "query"
                end
                local loaded = vim.api.nvim_buf_is_loaded(b)
                if loaded and vim.bo[b].filetype == "dbout" then
                  return "dbout"
                end
                if loaded and vim.bo[b].filetype == "sql" and vim.b[b].dbui_db_key_name ~= nil then
                  return "query"
                end
                return nil
              end
              local drawer_win = vim.api.nvim_get_current_win()
              for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                local b = vim.api.nvim_win_get_buf(win)
                local kind = dadbod_scratch_kind(b)
                if kind == "dbout" or (kind == "query" and not vim.bo[b].modified) then
                  pcall(vim.api.nvim_win_close, win, false)
                end
              end
              for _, b in ipairs(vim.api.nvim_list_bufs()) do
                local kind = dadbod_scratch_kind(b)
                if kind == "dbout" then
                  pcall(vim.api.nvim_buf_delete, b, { force = true })
                elseif kind == "query" and not vim.bo[b].modified then
                  pcall(vim.api.nvim_buf_delete, b, {})
                end
              end
              -- window closes above may have moved focus; return to the drawer
              if vim.api.nvim_win_is_valid(drawer_win) then
                vim.api.nvim_set_current_win(drawer_win)
              end
              if vim.bo.filetype ~= "dbui" then
                return
              end
              -- a closed neighbor can leave the drawer as the only normal
              -- window (stretched full-width); restore a main area beside it
              local normal_wins = 0
              for _, win in ipairs(vim.api.nvim_tabpage_list_wins(0)) do
                if vim.api.nvim_win_get_config(win).relative == "" then
                  normal_wins = normal_wins + 1
                end
              end
              if normal_wins == 1 then
                vim.cmd("botright vnew")
                vim.cmd("wincmd h")
              end
              vim.api.nvim_win_set_width(0, vim.g.db_ui_winwidth)
              -- :normal <Plug>(...) drops keys in timer-callback context, so
              -- resolve the buffer-local mapping and call its function directly
              local function dbui_invoke(plug)
                local m = vim.fn.maparg("<Plug>(" .. plug .. ")", "n", false, true)
                if type(m) ~= "table" or not m.rhs or m.rhs == "" then
                  return
                end
                local call = m.rhs
                  :gsub("^:call%s+", "")
                  :gsub("<CR>$", "")
                  :gsub("<[sS][iI][dD]>", "<SNR>" .. m.sid .. "_")
                pcall(vim.cmd, "call " .. call)
              end
              -- pick up connections registered after the drawer first rendered;
              -- redraw only re-reads g:dbs when the cursor is on a level-0
              -- line, so park it on line 1 first
              vim.fn.cursor(1, 1)
              dbui_invoke("DBUI_Redraw")
              local name = vim.fn.fnamemodify(path, ":t")
              local function line_names_db(line)
                local s = line:find(" " .. name, 1, true)
                if s == nil then
                  return false
                end
                local nxt = line:sub(s + #name + 1, s + #name + 1)
                return nxt == "" or nxt == " "
              end
              -- collapse other expanded connections: one schema in view at a time
              -- (they stay connected, one line each — Enter re-expands)
              for _ = 1, 20 do
                vim.fn.cursor(1, 1)
                local found = vim.fn.search("^\\V\u{f47c}", "cW")
                local toggled = false
                while found > 0 do
                  if not line_names_db(vim.api.nvim_get_current_line()) then
                    dbui_invoke("DBUI_SelectLine")
                    toggled = true
                    break
                  end
                  found = vim.fn.search("^\\V\u{f47c}", "W")
                end
                if not toggled then
                  break
                end
              end
              -- Expand this database, then its tables node, so the schema is in
              -- view. The connection populates asynchronously, so this is a
              -- chevron-observing retry loop, not a blind toggle.
              -- \u{f460}/\u{f47c} = collapsed/expanded chevron; \u{f04f1} = tables node
              local pat = "\\V " .. vim.fn.escape(name, "\\") .. "\\( \\|\\$\\)"
              local toggled_db = false
              local function expand(tries)
                if vim.g._dbui_focus ~= url or vim.bo.filetype ~= "dbui" then
                  return
                end
                vim.fn.cursor(1, 1)
                if vim.fn.search(pat, "cW") == 0 then
                  return
                end
                local db_line = vim.api.nvim_get_current_line()
                if db_line:find("\u{f47c}", 1, true) then
                  -- connected and expanded: open the tables node, park on the db
                  if
                    vim.fn.search("\\V\u{f04f1}", "W") > 0
                    and vim.api.nvim_get_current_line():find("\u{f460}", 1, true)
                  then
                    dbui_invoke("DBUI_SelectLine")
                  end
                  vim.fn.cursor(1, 1)
                  vim.fn.search(pat, "cW")
                  return
                end
                -- toggle exactly once; the chevron only flips after the
                -- connect finishes, so re-toggling would undo a pending expand
                if not toggled_db and db_line:find("\u{f460}", 1, true) then
                  toggled_db = true
                  dbui_invoke("DBUI_SelectLine")
                end
                if tries > 1 then
                  vim.defer_fn(function()
                    expand(tries - 1)
                  end, 150)
                end
              end
              expand(12)
            end, 120)
          end
        '';
      }
      {
        # DBUI windows: quiet gutters (global foldcolumn/statuscol bleed in
        # otherwise) and a full-line cursor like neo-tree
        event = "FileType";
        pattern = [
          "dbui"
          "dbout"
        ];
        callback.__raw = ''
          function()
            vim.opt_local.foldcolumn = "0"
            vim.opt_local.statuscolumn = ""
            vim.opt_local.signcolumn = "no"
            vim.opt_local.number = false
            vim.opt_local.relativenumber = false
            vim.opt_local.cursorline = true
            vim.opt_local.cursorlineopt = "line"
          end
        '';
      }
      {
        event = "FileType";
        pattern = "snacks_dashboard";
        callback.__raw = ''
          function()
            local buf = vim.api.nvim_get_current_buf()
            local map = function(key, fn, desc)
              vim.keymap.set('n', key, fn, { buffer = buf, desc = desc })
            end
            map('<Tab>', function() _G.dash_cycle_all(1) end, 'Cycle views')
            map('<S-Tab>', function() _G.dash_cycle_all(-1) end, 'Cycle views back')
          end
        '';
      }
    ];

    opts = {
      title = true;
      titlestring = "%{expand('%:~:.')} — %{fnamemodify(getcwd(), ':~')}";
      number = true;
      relativenumber = true;
      shiftwidth = 2;
      clipboard = "unnamedplus";
      undofile = true;
      wrap = true;
      linebreak = true;
      breakindent = true;
      tabstop = 2;
      expandtab = true;
      ignorecase = true;
      smartcase = true;
      scrolloff = 8;
      sidescrolloff = 8;
      signcolumn = "yes";
      cursorline = true;
      cursorlineopt = "number";
      foldenable = true;
      foldlevel = 99;
      foldlevelstart = 99;
      foldcolumn = "1";
      splitbelow = true;
      splitright = true;
      # no "blank": sidebars (neo-tree, DBUI, results) are nofile buffers and
      # would otherwise restore as hollow empty windows in saved sessions
      sessionoptions = "buffers,curdir,folds,help,tabpages,winsize,terminal";
      showmode = false;
      cmdheight = 0;
      laststatus = 3;
      pumblend = 10;
      pumheight = 12;
      winblend = 0;
      winborder = "rounded";
      fillchars = "eob: ,vert:│,horiz:─,horizup:┴,horizdown:┬,vertleft:┤,vertright:├,verthoriz:┼,fold: ,foldopen:▾,foldclose:▸,diff:╱";
      list = true;
      listchars = "tab:  ,trail:·,nbsp:␣";
      termguicolors = true;
    };

  };
}
