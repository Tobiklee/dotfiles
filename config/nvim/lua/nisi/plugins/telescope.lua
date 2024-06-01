return {
  {
    "nvim-telescope/telescope.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim", -- Power telescope with FZF
      "nvim-telescope/telescope-rg.nvim",
      "nvim-telescope/telescope-node-modules.nvim",
    },
    keys = function()
      local keys = {
        { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find Files" },
        { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Find MRU files" },
        { "<leader>fn", "<cmd>Telescope node_modules list<cr>", desc = "List node_modules" },
        { "<leader>fg", "<cmd>Telescope live_grep<cr>", desc = "Find using live grep" },
        {
          "<leader>fr",
          "<cmd>lua require('telescope').extensions.live_grep_args.live_grep_args()<cr>",
          desc = "Find sing live raw grep",
        },
        { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Find in buffers" },
        { "<leader>r", "<cmd>Telescope buffers<cr>", desc = "Find in buffers" },
        { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Find in help" },
      }
      local utils = require("nisi.utils")

      if utils.is_in_git_repo() then
        utils.table_append(keys, {
          { "<leader>fs", "<cmd>Telescope git_files<cr>", desc = "Find Git files" },
          { "<leader>t", "<cmd>Telescope git_files<cr>", desc = "Find in Git files" },
          { "<D-p>", "<cmd>Telescope git_files<cr>", desc = "Find in Git files" },
          { "<leader>gc", "<cmd>Telescope git_commits<cr>", desc = "Commits" },
          { "<leader>gs", "<cmd>Telescope git_status<cr>", desc = "Status" },
        })
      else
        utils.table_append(keys, {
          { "<leader>t", "<cmd>Telescope find_files<cr>", desc = "Find in files" },
          { "<D-p>", "<cmd>Telescope find_files<cr>", desc = "Find in files" },
        })
      end

      return keys
    end,
    opts = function()
      local actions = require("telescope.actions")
      local sorters = require("telescope.sorters")
      local previewers = require("telescope.previewers")

      return {
        defaults = {
          mappings = {
            i = {
              ["<Esc>"] = actions.close, -- don't go into normal mode, just close
              ["<C-j>"] = actions.move_selection_next, -- scroll the list with <c-j>
              ["<C-k>"] = actions.move_selection_previous, -- scroll the list with <c-k>
              -- ["<C-\\->"] = actions.select_horizontal, -- open selection in new horizantal split
              -- ["<C-\\|>"] = actions.select_vertical, -- open selection in new vertical split
              ["<C-t>"] = actions.select_tab, -- open selection in new tab
              ["<C-y>"] = actions.preview_scrolling_up,
              ["<C-e>"] = actions.preview_scrolling_down,
            },
          },
          vimgrep_arguments = {
            "rg",
            "--color=never",
            "--no-heading",
            "--with-filename",
            "--line-number",
            "--column",
            "--smart-case",
            "--trim",
          },
          prompt_prefix = "   ",
          selection_caret = "  ",
          entry_prefix = "  ",
          initial_mode = "insert",
          selection_strategy = "reset",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = { prompt_position = "top", preview_width = 0.55, results_width = 0.8 },
            vertical = { mirror = false },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_sorter = sorters.get_fuzzy_file,
          file_ignore_patterns = { "node_modules" },
          generic_sorter = sorters.get_generic_fuzzy_sorter,
          path_display = { "truncate" },
          winblend = 0,
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          color_devicons = true,
          use_less = true,
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          file_previewer = previewers.vim_buffer_cat.new,
          grep_previewer = previewers.vim_buffer_vimgrep.new,
          qflist_previewer = previewers.vim_buffer_qflist.new,
          -- Developer configurations: Not meant for general override
          buffer_previewer_maker = previewers.buffer_previewer_maker,
        },
        pickers = { find_files = { find_command = { "fd", "--type", "f", "--hidden", "--strip-cwd-prefix" } } },
      }
    end,
  },
}