require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "gopls", "templ" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      completeUnimported = true,
      usePlaceholders = true,
      gofumpt = true,
      analyses = {
        unusedparams = true,
      },
    },
  },
})

vim.lsp.config("html", {
  filetypes = { "html", "templ" },
})
