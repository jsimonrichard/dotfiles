return require('packer').startup(function(use)
  -- Packer can manage itself
  use 'wbthomason/packer.nvim'
  use 'nvim-lua/plenary.nvim'
  use 'nvim-lua/popup.nvim'
  use 'stevearc/dressing.nvim'

  use 'morhetz/gruvbox'

  use 'jremmen/vim-ripgrep'

  use 'preservim/nerdcommenter'

  use 'SirVer/ultisnips'
  use 'honza/vim-snippets'
  use 'zooxyt/Ultisnips-rust'
  
  use 'lervag/vimtex'
  use 'matze/vim-tex-fold'
  
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
  
  use 'nvim-telescope/telescope.nvim'

  use 'williamboman/mason.nvim'
  use 'nvim-lua/completion-nvim'
end)
