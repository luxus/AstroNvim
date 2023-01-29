return {
  {
    --TODO: not tested yet
    "pwntester/octo.nvim",
    enabled = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    config = function() require("octo").setup() end,
  },

  {
    "tjdevries/sg.nvim",
    build = "cargo build --workspace",
    dependencies = { "nvim-lua/plenary.nvim" },
    event = "VeryLazy",
  },
  {
    "Wansmer/treesj",
    keys = { "<leader>J", "<leader>j" },
    cmd = {
      "TSJToggle",
      "TSJSplit",
      "TSJJoin",
    },
    init = function()
      vim.keymap.set("n", "<leader>J", function() vim.cmd [[TSJToggle]] end, { desc = "Spread: Expand" })
      vim.keymap.set("n", "<leader>j", function() vim.cmd [[TSJJoin]] end, { desc = "Spread: Combine" })
    end,
    config = true,
  },

  --Jumping between the idents
  {
    "arsham/indent-tools.nvim",
    dependencies = { "arsham/arshlib.nvim" },
    init = function() table.insert(astronvim.file_plugins, "indent-tools.nvim") end,
    config = function() require("indent-tools").config {} end,
  },
  -- remember the last place
  {
    "ethanholz/nvim-lastplace",
    event = "BufRead",
    opts = {
      lastplace_ignore_buftype = { "quickfix", "nofile", "help" },
      lastplace_ignore_filetype = { "gitcommit", "gitrebase", "svn", "hgcommit" },
      lastplace_open_folds = true,
    },
  },
  {
    "smjonas/inc-rename.nvim",
    cmd = "IncRename",
    config = true,
    keys = {
      {
        "<leader>R",
        function() return ":IncRename " .. vim.fn.expand "<cword>" end,
        { expr = true, desc = "Rename" },
      },
    },
  },
  -- better increase/descrease
  {
    "monaqa/dial.nvim",
    keys = {
      { "<C-a>", function() return require("dial.map").inc_normal() end, expr = true, desc = "Increment" },
      { "<C-x>", function() return require("dial.map").dec_normal() end, expr = true, desc = "Decrement" },
    },
    config = function()
      local augend = require "dial.augend"
      require("dial.config").augends:register_group {
        default = {
          augend.integer.alias.decimal,
          augend.integer.alias.hex,
          augend.date.alias["%Y/%m/%d"],
          augend.constant.alias.bool,
          augend.semver.alias.semver,
        },
      }
    end,
  },
  {
    --TODO: let use Internal register for some mappings
    "gbprod/cutlass.nvim",
    keys = {
      "x",
      "d",
      "c",
      "X",
      "D",
      "C",
    },
    config = function()
      require("cutlass").setup {
        exclude = { "ns", "nS" },
      }
    end,
  },
  {
    "ggandor/leap.nvim",
    init = function() table.insert(astronvim.file_plugins, "leap.nvim") end,
    dependencies = { { "tpope/vim-repeat" }, { "ggandor/flit.nvim", opts = { labeled_modes = "nv" } } },
    config = function(_, opts)
      local leap = require "leap"
      for k, v in pairs(opts) do
        leap.opts[k] = v
      end
      leap.add_default_mappings(true)
    end,
  },

  -- yanky
  {
    "gbprod/yanky.nvim",
    config = true,
    keys = {
      { "p", mode = { "n", "x" }, "<Plug>(YankyPutAfter)", desc = "Put after" },
      { "P", mode = { "n", "x" }, "<Plug>(YankyPutBefore)", desc = "Put before" },
      { "gp", mode = { "n", "x" }, "<Plug>(YankyGPutAfter)", desc = "GPut after" },
      { "gP", mode = { "n", "x" }, "<Plug>(YankyGPutBefore)", desc = "GPut before" },
    },
    --FIXME: this is not working
    -- dependencies = { "kkharji/sqlite.lua" },
    -- opts = {
    --   ring = {
    --     storage = "sqlite",
    --   },
    -- },
  },
  {
    "kevinhwang91/nvim-ufo",
    dependencies = { "kevinhwang91/promise-async" },
    init = function() table.insert(astronvim.file_plugins, "nvim-ufo") end,
    lazy = true,
    opts = {
      provider_selector = function(_, filetype, buftype)
        if filetype == "" or buftype == "nofile" then
          return "indent"
        else
          return { "treesitter", "indent" }
        end
      end,
    },
    config = function(_, opts)
      require("ufo").setup(opts)
      vim.keymap.set("n", "zR", require("ufo").openAllFolds)
      vim.keymap.set("n", "zM", require("ufo").closeAllFolds)
      vim.keymap.set("n", "zr", require("ufo").openFoldsExceptKinds)
      vim.keymap.set("n", "zm", require("ufo").closeFoldsWith)
      vim.keymap.set("n", "zp", require("ufo").peekFoldedLinesUnderCursor, { desc = "Peek Fold" })
    end,
  },
  { "wakatime/vim-wakatime", init = function() table.insert(astronvim.file_plugins, "vim-wakatime") end },
  -- surround text
  {
    "echasnovski/mini.surround",
    -- keys = { "gz" },
    init = function() table.insert(astronvim.file_plugins, "mini.surround") end,
    opts = {
      mappings = {
        add = "gza", -- Add surrounding in Normal and Visual modes
        delete = "gzd", -- Delete surrounding
        find = "gzf", -- Find surrounding (to the right)
        find_left = "gzF", -- Find surrounding (to the left)
        highlight = "gzh", -- Highlight surrounding
        replace = "gzr", -- Replace surrounding
        update_n_lines = "gzn", -- Update `n_lines`
      },
    },
    config = function(_, opts)
      -- use gz mappings instead of s to prevent conflict with leap
      require("mini.surround").setup(opts)
    end,
  },
  -- framework for interactive tests
  {
    "nvim-neotest/neotest",
    -- config = true,
    event = "BufRead",
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-treesitter/nvim-treesitter",
      "antoinemadec/FixCursorHold.nvim",
    },
  },
  -- Neogen is a better annotation generator.
  {
    "danymat/neogen",
    cmd = "Neogen",
    opts = {
      snippet_engine = "luasnip",
      languages = {
        lua = { template = { annotation_convention = "ldoc" } },
        typescript = { template = { annotation_convention = "tsdoc" } },
        typescriptreact = { template = { annotation_convention = "tsdoc" } },
      },
    },

    keys = {
      {
        "<leader>a<cr>",
        function() require("neogen").generate { type = "current" } end,
        desc = "Current",
      },
      { "<leader>ac", function() require("neogen").generate { type = "class" } end, desc = "Class" },
      { "<leader>af", function() require("neogen").generate { type = "func" } end, desc = "Function" },
      { "<leader>at", function() require("neogen").generate { type = "type" } end, desc = "Type" },
      { "<leader>aF", function() require("neogen").generate { type = "file" } end, desc = "File" },
    },
  },
  -- Looks like oil does support ssh without netman
  -- { "miversen33/netman.nvim" },

  {
    "junegunn/vim-easy-align",
    init = function() table.insert(astronvim.file_plugins, "vim-easy-align") end,
    keys = {
      { "ga", mode = { "x" }, "<Plug>(EasyAlign)", desc = "Easy Align" },
    },
  },

  {
    "m-demare/hlargs.nvim",
    config = true,
    init = function() table.insert(astronvim.file_plugins, "hlargs.nvim") end,
    enabled = true,
  },
  { "stevearc/oil.nvim", config = true, enabled = true, cmd = "Oil" },
  {
    "folke/todo-comments.nvim",
    config = true,
    init = function() table.insert(astronvim.file_plugins, "todo-comments.nvim") end,
  },

  -- better text-objects
  {
    "echasnovski/mini.ai",
    keys = {
      { "a", mode = { "x", "o" } },
      { "i", mode = { "x", "o" } },
    },
    dependencies = {
      {
        "nvim-treesitter/nvim-treesitter-textobjects",
        init = function()
          -- no need to load the plugin, since we only need its queries
          require("lazy.core.loader").disable_rtp_plugin "nvim-treesitter-textobjects"
        end,
      },
    },
    opts = function()
      local ai = require "mini.ai"
      return {
        n_lines = 500,
        custom_textobjects = {
          o = ai.gen_spec.treesitter({
            a = { "@block.outer", "@conditional.outer", "@loop.outer" },
            i = { "@block.inner", "@conditional.inner", "@loop.inner" },
          }, {}),
          f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
          c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
        },
      }
    end,
    config = function(_, opts)
      local ai = require "mini.ai"
      ai.setup(opts)
    end,
  },

  -- still not using quickfix 😆
  -- https://github.com/kevinhwang91/nvim-bqf
  {
    "kevinhwang91/nvim-bqf",
    init = function() table.insert(astronvim.file_plugins, "nvim-bqf") end,
    enabled = false,
    config = true,
  },
  -- don't use it yet
  -- https://github.com/ThePrimeagen/refactoring.nvim
  {
    "ThePrimeagen/refactoring.nvim",
    ft = { "typescript", "javascript", "lua", "c", "cpp", "go", "python", "java", "php" },
    config = true,
    enabled = false,
  },
  -- https://github.com/AckslD/nvim-neoclip.lua
  -- yank history
  -- { "AckslD/nvim-neoclip.lua", event = "BufRead", config = true },
  {
    "echasnovski/mini.move",
    -- init = function() table.insert(astronvim.file_plugins, "mini.move") end,
    enabled = true,
    keys = {
      "<A-j>",
      "<A-k>",
    },
    config = function(_, opts) require("mini.move").setup(opts) end,
  },
}
