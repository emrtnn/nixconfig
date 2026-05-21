return {
  {
    'nvim-treesitter/nvim-treesitter',
    version = false,
    build = ':TSUpdate',
    event = { 'BufReadPost', 'BufNewFile'},
    opts = function()
      return {
        indent = { enable = true },
        highlight = { enable = true },
        folds = { enable = true },
        auto_install = true,
        ensure_installed = {
          'bash',
          'c',
          'diff',
          'html',
          'javascript',
          'jsdoc',
          'json',
          'lua',
          'luadoc',
          'luap',
          'markdown',
          'markdown_inline',
          'python',
          'query',
          'regex',
          'toml',
          'typesciprt',
          'tsx',
          'vim',
          'vimdoc',
          'xml',
          'yaml'
        },
      }
    end,
  }
}
