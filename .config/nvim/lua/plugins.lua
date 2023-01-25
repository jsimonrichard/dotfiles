return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'

  -- Status line
  use 'vim-airline/vim-airline'
  use 'vim-airline/vim-airline-themes'

  -- Theme
  use 'ellisonleao/gruvbox.nvim'

  -- Commenter
  use 'preservim/nerdcommenter'

  use 'lervag/vimtex'

  use {
    'nvim-treesitter/nvim-treesitter',
    run = ":TSUpdate",
    event = { "BufRead", "BufNewFile" },
    cmd = {
      "TSInstall",
      "TSInstallInfo",
      "TSInstallSync",
      "TSUninstall",
      "TSUpdate",
      "TSUpdateSync",
      "TSDisableAll",
      "TSEnableAll",
    },
  }

  use 'kyazdani42/nvim-web-devicons'

  -- Tab line
  use {
    'romgrk/barbar.nvim',
    requires = {'kyazdani42/nvim-web-devicons'},
    cmd = {
      "BufferPrevious",
      "BufferNext",
      "BufferGoto",
      "BufferClose"
    }
  }

  -- Side bar
  use 'preservim/nerdtree'

  use 'nvim-lua/plenary.nvim' -- required for telescope
  use 'nvim-lua/popup.nvim'
  use 'stevearc/dressing.nvim'

  use {
    'nvim-telescope/telescope.nvim',
    requires = { {'nvim-lua/plenary.nvim'} },
    config = function()
      require("telescope").setup({
	defaults = {
	  file_ignore_patterns = {
	    "node_modules",
	    ".git"
	  }
	},
	extensions = {
	  fzf = {
	    fuzzy = true,
	    override_generic_sorter = true,
	    override_file_sorter = true,
	    case_mode = "smart_case",
	  }
	}
      })
      require('telescope').load_extension('fzf')
    end
  }
  use {
    'nvim-telescope/telescope-fzf-native.nvim',
    run = 'make'
  }

  use {
    'kevinhwang91/rnvimr',
    cmd = {
      "RnvimrToggle",
      "RnvimrSync"
    }
  }


  -- LSP
  use 'neovim/nvim-lspconfig'

  -- Install LSPs, DAPs, etc.
  use {
    'williamboman/mason.nvim',
    config = function()
      require("mason").setup()
    end
  }
  use 'williamboman/mason-lspconfig.nvim'
  use {
    'jose-elias-alvarez/null-ls.nvim',
    config = function()
      require("null-ls").setup {
        sources = {
          require("null-ls").builtins.formatting.stylua,
          require("null-ls").builtins.completion.spell,
	}
      }
    end
  }

  use {
    'j-hui/fidget.nvim',
    config = function()
      require("fidget").setup()
    end
  }

  use {
    'simrat39/rust-tools.nvim',
    config = function()
      require("rust-tools").setup {
	tools = {
	  runnables = {
	    use_telescope = true,
	  },
	  inlay_hints = {
	    auto = true,
	    show_parameter_hints = false,
	    parameter_hints_prefix = "",
	    other_hints_prefix = "",
	  },
	},

	-- all the opts to send to nvim-lspconfig
	-- these override the defaults set by rust-tools.nvim
	-- see https://github.com/neovim/nvim-lspconfig/blob/master/CONFIG.md#rust_analyzer
	server = {
	  settings = {
	    -- to enable rust-analyzer settings visit:
	    -- https://github.com/rust-analyzer/rust-analyzer/blob/master/docs/user/generated_config.adoc
	    ["rust-analyzer"] = {
	      -- enable clippy on save
	      checkOnSave = {
		command = "clippy",
	      },
	    },
	  },
	},
      }
    end
  }
  
  use 'hrsh7th/nvim-cmp'
  use {
    -- cmp LSP completion
    'hrsh7th/cmp-nvim-lsp',
    -- cmp Snippet completion
    'hrsh7th/cmp-vsnip',
    -- cmp Path completion
    'hrsh7th/cmp-path',
    'hrsh7th/cmp-buffer',
    after = { "hrsh7th/nvim-cmp" },
    requires = { "hrsh7th/nvim-cmp" },
  }
  -- See hrsh7th other plugins for more great completion sources!
  -- Snippet engine
  use 'hrsh7th/vim-vsnip'

  use {
    'weilbith/nvim-code-action-menu',
    cmd = 'CodeActionMenu',
  }

end)
