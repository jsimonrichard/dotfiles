-- Packer
require "plugins"

local status_ok, mason = pcall(require, "mason")
if not status_ok then return end
mason.setup()

-- Update when plugins.lua changes
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost ./lua/plugins.lua source <afile> | PackerCompile
  augroup end
]])

-- Options
vim.opt.mouse = "a"
vim.opt.spell = true
vim.opt.number = true
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cc = '80'

vim.api.nvim_set_keymap("!", "<C-v>", "<Esc>\"+p", {noremap = true})
vim.api.nvim_set_keymap("!", "<C-c>", "<Esc>\"+y", {noremap = true})
vim.api.nvim_set_keymap("!", "<C-x>", "<Esc>\"+m", {noremap = true})

vim.g.gruvbox_italic = 1
vim.g.gruvbox_bold = 1
vim.cmd [[
autocmd vimenter * ++nested colorscheme gruvbox
]]

vim.g.UltiSnipsJumpForwardTrigger = '<tab>'

vim.g.vimtex_view_method = 'zathura'
vim.opt.conceallevel = 1
vim.g.tex_conceal = 'abdmg'
vim.g.vimtex_quickfix_mode=0

local builtin = require('telescope.builtin')
vim.keymap.set('n', 'ff', function() builtin.find_files({hidden = true}) end, {})
vim.keymap.set('n', 'fg', builtin.live_grep, {})
vim.keymap.set('n', 'fb', builtin.buffers, {})
vim.keymap.set('n', 'fh', builtin.help_tags, {})
vim.keymap.set('n', 'ft', builtin.treesitter, {})

vim.api.nvim_set_keymap("n", "<C-h>", "<Cmd>BufferPrevious<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<C-l>", "<Cmd>BufferNext<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<C-q>", "<Cmd>BufferClose<CR>", {noremap = true})
