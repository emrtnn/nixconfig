local create_autocmd = vim.api.nvim_create_autocmd
local set_hl = vim.api.nvim_set_hl

-- Highlight line on yank
create_autocmd('TextYankPost', {
  callback = function()
    vim.highlight.on_yank({
      higroup = 'IncSearch',
      timeout = 300,
    })
  end,
})
