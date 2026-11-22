require("nvchad.configs.lspconfig").defaults()

local servers = { "html", "cssls", "gopls" }
vim.lsp.enable(servers)

-- read :h vim.lsp.config for changing options of lsp servers 
vim.lsp.config("gopls", {
  settings = {
    gopls = {
      completeUnimported = true, -- автодополнение еще не импортированных пакетов
      usePlaceholders = true,    -- подстановка имен параметров функций
      gofumpt = true,            -- использование gofumpt
      analyses = {
        unusedparams = true,     -- предупреждать о неиспользуемых параметрах
      },
    },
  },
})
