-- Packer
require "plugins"
require "keybindings"

-- Update when plugins.lua changes
vim.cmd([[
  augroup packer_user_config
    autocmd!
    autocmd BufWritePost ./lua/plugins.lua source <afile> | PackerCompile
  augroup end
]])


-- If another buffer tries to replace NERDTree, put it in the other window, and bring back NERDTree.
vim.cmd([[
  autocmd BufEnter * if bufname('#') =~ 'NERD_tree_\d\+' && bufname('%') !~ 'NERD_tree_\d\+' && winnr('$') > 1 |
      \ let buf=bufnr() | buffer# | execute "normal! \<C-W>w" | execute 'buffer'.buf | endif
]])
-- Options
vim.opt.mouse = "a"
vim.opt.spell = true
vim.opt.number = true
vim.opt.shiftwidth = 2
vim.opt.autoindent = true
vim.opt.smartindent = true
vim.opt.cc = '80'
vim.opt.clipboard = 'unnamedplus'
vim.opt.linebreak = true

vim.cmd [[
autocmd vimenter * ++nested colorscheme gruvbox
]]

vim.g.airline_theme = "base16_gruvbox_dark_medium"

vim.g.vimtex_view_method = 'zathura'
vim.opt.conceallevel = 1
vim.g.tex_conceal = 'abdmg'
vim.g.vimtex_quickfix_mode=0

vim.g.rustfmt_autosave = 1

local cmp = require("cmp")
cmp.setup({
  preselect = cmp.PreselectMode.None,
  snippet = {
    expand = function(args)
      vim.fn["vsnip#anonymous"](args.body)
    end,
  },
  mapping = {
    ["<C-p>"] = cmp.mapping.select_prev_item(),
    ["<C-n>"] = cmp.mapping.select_next_item(),
    -- Add tab support
    ["<S-Tab>"] = cmp.mapping.select_prev_item(),
    ["<Tab>"] = cmp.mapping.select_next_item(),
    ["<C-d>"] = cmp.mapping.scroll_docs(-4),
    ["<C-f>"] = cmp.mapping.scroll_docs(4),
    ["<C-Space>"] = cmp.mapping.complete(),
    ["<C-e>"] = cmp.mapping.close(),
    --["<C-CR>"] = cmp.mapping.confirm({
      --behavior = cmp.ConfirmBehavior.Insert,
      --select = true,
    --}),
  },

  -- Installed sources
  sources = {
    { name = "nvim_lsp" },
    { name = "vsnip" },
    { name = "path" },
    { name = "buffer" },
  },
})


-- Format on Write
vim.api.nvim_create_autocmd("BufWritePre", {
  pattern = "*.rs",
  callback = function()
   vim.lsp.buf.formatting_sync(nil, 200)
  end,
  group = format_sync_grp,
})
