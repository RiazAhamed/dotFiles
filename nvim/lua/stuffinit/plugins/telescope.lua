return {
  "nvim-telescope/telescope.nvim",
  branch = "0.1.x",
  dependencies = {
    "nvim-lua/plenary.nvim",
    { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
    "nvim-tree/nvim-web-devicons",
    "folke/todo-comments.nvim",
    -- "nvim-telescope/telescope-file-browser.nvim",
  },
  keys = {
    {
      "<leader>fP",
      function()
        require("telescope.builtin").find_files({
          cwd = require("lazy.core.config").options.root,
        })
      end,
      desc = "Find Plugin File",
    },
    {
      ";f",
      function()
        local builtin = require("telescope.builtin")
        builtin.find_files({
          no_ignore = false,
          hidden = true,
        })
      end,
      desc = "Lists files in your current working directory, respects .gitignore",
    },
    {
      ";r",
      function()
        local builtin = require("telescope.builtin")
        builtin.live_grep({
          additional_args = { "--hidden" },
        })
      end,
      desc = "Search for a string in your current working directory and get results live as you type, respects .gitignore",
    },
    {
      "\\\\",
      function()
        local builtin = require("telescope.builtin")
        builtin.buffers()
      end,
      desc = "Lists open buffers",
    },
    {
      ";t",
      function()
        local builtin = require("telescope.builtin")
        builtin.help_tags()
      end,
      desc = "Lists available help tags and opens a new window with the relevant help info on <cr>",
    },
    {
      ";;",
      function()
        local builtin = require("telescope.builtin")
        builtin.resume()
      end,
      desc = "Resume the previous telescope picker",
    },
    {
      ";e",
      function()
        local builtin = require("telescope.builtin")
        builtin.diagnostics()
      end,
      desc = "Lists Diagnostics for all open buffers or a specific buffer",
    },
    {
      ";s",
      function()
        local builtin = require("telescope.builtin")
        builtin.treesitter()
      end,
      desc = "Lists Function names, variables, from Treesitter",
    },
    {
      "sf",
      function()
        local telescope = require("telescope")

        local function telescope_buffer_dir()
          return vim.fn.expand("%:p:h")
        end

        telescope.extensions.file_browser.file_browser({
          path = "%:p:h",
          cwd = telescope_buffer_dir(),
          respect_gitignore = false,
          hidden = true,
          grouped = true,
          previewer = false,
          initial_mode = "normal",
          layout_config = { height = 40 },
        })
      end,
      desc = "Open File Browser with the path of the current buffer",
    },
  },
  config = function()
    local telescope = require("telescope")
    local actions = require("telescope.actions")
    local transform_mod = require("telescope.actions.mt").transform_mod

    local trouble = require("trouble")
    local trouble_telescope = require("trouble.providers.telescope")

    -- or create your custom action
    local custom_actions = transform_mod({
      open_trouble_qflist = function()
        trouble.toggle("quickfix")
      end,
    })

    telescope.setup({
      defaults = {
        path_display = { "smart" },
        mappings = {
          i = {
            ["<C-k>"] = actions.move_selection_previous, -- move to prev result
            ["<C-j>"] = actions.move_selection_next, -- move to next result
            ["<C-q>"] = actions.send_selected_to_qflist + custom_actions.open_trouble_qflist,
            ["<C-t>"] = trouble_telescope.smart_open_with_trouble,
          },
        },
      },
    })

    telescope.load_extension("fzf")

    -- set keymaps
    local keymap = vim.keymap -- for conciseness

    keymap.set("n", "<leader>ff", "<cmd>Telescope find_files<cr>", { desc = "Fuzzy find files in cwd" })
    keymap.set("n", "<leader>fr", "<cmd>Telescope oldfiles<cr>", { desc = "Fuzzy find recent files" })
    keymap.set("n", "<leader>fs", "<cmd>Telescope live_grep<cr>", { desc = "Find string in cwd" })
    keymap.set("n", "<leader>fc", "<cmd>Telescope grep_string<cr>", { desc = "Find string under cursor in cwd" })
    keymap.set("n", "<leader>ft", "<cmd>TodoTelescope<cr>", { desc = "Find todos" })

    -- local fb_actions = require("telescope").extensions.file_browser.actions
    --
    -- opts.defaults = vim.tbl_deep_extend("force", opts.defaults, {
    --   wrap_results = true,
    --   layout_strategy = "horizontal",
    --   layout_config = { prompt_position = "top" },
    --   sorting_strategy = "ascending",
    --   winblend = 0,
    --   mappings = {
    --     n = {},
    --   },
    -- })
    -- opts.pickers = {
    --   diagnostics = {
    --     theme = "ivy",
    --     initial_mode = "normal",
    --     layout_config = {
    --       preview_cutoff = 9999,
    --     },
    --   },
    -- }
    -- opts.extensions = {
    --   file_browser = {
    --     theme = "dropdown",
    --     -- disables netrw and use telescope-file-browser in its place
    --     hijack_netrw = true,
    --     mappings = {
    --       -- your custom insert mode mappings
    --       ["n"] = {
    --         -- your custom normal mode mappings
    --         ["N"] = fb_actions.create,
    --         ["h"] = fb_actions.goto_parent_dir,
    --         ["/"] = function()
    --           vim.cmd("startinsert")
    --         end,
    --         ["<C-u>"] = function(prompt_bufnr)
    --           ---@diagnostic disable-next-line: unused-local
    --           for i = 1, 10 do
    --             actions.move_selection_previous(prompt_bufnr)
    --           end
    --         end,
    --         ["<C-d>"] = function(prompt_bufnr)
    --           ---@diagnostic disable-next-line: unused-local
    --           for i = 1, 10 do
    --             actions.move_selection_next(prompt_bufnr)
    --           end
    --         end,
    --         ["<PageUp>"] = actions.preview_scrolling_up,
    --         ["<PageDown>"] = actions.preview_scrolling_down,
    --       },
    --     },
    --   },
    -- }
    -- telescope.setup(opts)
    -- require("telescope").load_extension("fzf")
    -- require("telescope").load_extension("file_browser")
  end,
}
