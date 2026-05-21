return {
  {
    'nvim-lualine/lualine.nvim',
    event = {'BufReadPre', 'BufNewFile'},
    opts = {
      theme = 'gruvbox-material',
      globalstatus = true,
    },
    dependencies = { 'nvim-tree/nvim-web-devicons' },
  }
}
