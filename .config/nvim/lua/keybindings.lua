vim.api.nvim_set_keymap("!", "<C-v>", "<Esc>\"+p", {noremap = true})
vim.api.nvim_set_keymap("!", "<C-c>", "<Esc>\"+y", {noremap = true})
vim.api.nvim_set_keymap("!", "<C-x>", "<Esc>\"+m", {noremap = true})

local builtin = require('telescope.builtin')
vim.keymap.set('n', 'ff', function() builtin.find_files({hidden = true}) end, {})
vim.keymap.set('n', 'fg', builtin.live_grep, {})
vim.keymap.set('n', 'fb', builtin.buffers, {})
vim.keymap.set('n', 'fh', builtin.help_tags, {})
vim.keymap.set('n', 'ft', builtin.treesitter, {})

vim.g.rnvimr_ex_enable = 1
vim.api.nvim_set_keymap("n", "<Leader>r", ":RnvimrToggle<CR>", {noremap = true})

vim.api.nvim_set_keymap("n", "<Leader>tt", ":NERDTreeToggle<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<Leader>tf", ":NERDTreeFind<CR>", {noremap = true})

vim.api.nvim_set_keymap("!", "<C-j>", "<Cmd>BufferPrevious<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<C-j>", "<Cmd>BufferPrevious<CR>", {noremap = true})
vim.api.nvim_set_keymap("!", "<C-k>", "<Cmd>BufferNext<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<C-k>", "<Cmd>BufferNext<CR>", {noremap = true})
vim.api.nvim_set_keymap("!", "<C-q>", "<Cmd>BufferClose<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<C-q>", "<Cmd>BufferClose<CR>", {noremap = true})

vim.api.nvim_set_keymap("!", "<C-h>", "<Cmd>wincmd p<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<C-h>", "<Cmd>wincmd p<CR>", {noremap = true})
vim.api.nvim_set_keymap("!", "<C-l>", "<Cmd>wincmd p<CR>", {noremap = true})
vim.api.nvim_set_keymap("n", "<C-l>", "<Cmd>wincmd p<CR>", {noremap = true})

local keymap_opts = { buffer = buffer }
-- Code navigation and shortcuts
vim.keymap.set("n", "<c-]>", vim.lsp.buf.definition, keymap_opts)
vim.keymap.set("n", "K", vim.lsp.buf.hover, keymap_opts)
vim.keymap.set("n", "gD", vim.lsp.buf.implementation, keymap_opts)
vim.keymap.set("n", "<c-k>", vim.lsp.buf.signature_help, keymap_opts)
vim.keymap.set("n", "1gD", vim.lsp.buf.type_definition, keymap_opts)
vim.keymap.set("n", "gr", vim.lsp.buf.references, keymap_opts)
vim.keymap.set("n", "g0", vim.lsp.buf.document_symbol, keymap_opts)
vim.keymap.set("n", "gW", vim.lsp.buf.workspace_symbol, keymap_opts)
vim.keymap.set("n", "gd", vim.lsp.buf.definition, keymap_opts)
