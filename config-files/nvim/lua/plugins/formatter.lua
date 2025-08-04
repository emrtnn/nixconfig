return {
  'stevearc/conform.nvim',
  event = { "BufWritePre" },
  opts = {
    formatters_by_ft = {
      lua = { "stylua" },
      python = { "ruff_format" },
      go = { "gofmt" },
      rust = { "rustfmt" },
      nix = { "nixpkgs-fmt" },
      typescript = { "biome" },
      javascript = { "biome" },
      html = { "biome" },
      css = { "biome" },
      json = { "biome" },
      yaml = { "prettier" },
      markdown = { "prettier" },
    },

    format_on_save = {
      timeout_ms = 500,
      lsp_format = "fallback",
    },
  },
}
