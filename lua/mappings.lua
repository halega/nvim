require "nvchad.mappings"

-- add yours here

local map = vim.keymap.set

map("n", "<leader>fs", "<cmd>Telescope lsp_document_symbols<CR>", { desc = "Telescope LSP document symbols" })
map("n", "<leader>fS", "<cmd>Telescope lsp_dynamic_workspace_symbols<CR>", { desc = "Telescope LSP workspace symbols" })
map("n", "<leader>fd", function()
  require("telescope.builtin").live_grep {
    cwd = vim.fn.expand "%:p:h",
    prompt_title = "Live Grep in Current File's Folder",
  }
end, { desc = "Telescope live grep in current file dir" })

map("n", ";", ":", { desc = "CMD enter command mode" })
map("i", "jk", "<ESC>")
map("n", "<F5>", "<cmd>DapContinue<CR>", { desc = "DAP: Start / Continue" })
map("n", "<F12>", vim.lsp.buf.definition, { desc = "Перейти к определению" })
map("n", "<S-F12>", vim.lsp.buf.references, { desc = "Найти все использования" })
-- map({ "n", "i", "v" }, "<C-s>", "<cmd> w <cr>")

map("n", "<F22>", function()
  require("dap").continue()
end, { desc = "Start debuggin" })
map("n", "<S-F10>", function()
  require("dap").continue()
end, { desc = "Start debuggin" })
map("n", "<S-F5>", function()
  require("dap").terminate()
end, { desc = "Stop debugging" })
map("n", "<F17>", function()
  require("dap").terminate()
end, { desc = "Stop debugging" })
map("n", "<F9>", function()
  require("dap").toggle_breakpoint()
end, { desc = "Toggle breakpoint" })
map("n", "<F10>", function()
  require("dap").step_over()
end, { desc = "Step Over" })
map("n", "<F11>", function()
  require("dap").step_into()
end, { desc = "Step Into" })
map("n", "<leader>dt", function()
  require("dap-go").debug_test()
end, { desc = "Отладить текущий тест" })

-- Боковая кнопка мыши «Назад» -> Ctrl+o (вернуться назад по истории прыжков)
map("n", "<X1Mouse>", "<C-o>", { desc = "Назад (Мышь)" })
-- Боковая кнопка мыши «Вперёд» -> Ctrl+i (вперёд по истории прыжков)
map("n", "<X2Mouse>", "<C-i>", { desc = "Вперёд (Мышь)" })

-- Запуск Go-проекта (go run .) во всплывающем окне или нижнем сплите
map("n", "<leader>gr", function()
  vim.cmd "silent! wa"
  require("nvchad.term").runner {
    id = "vtoggleTerm",
    pos = "vsp", -- "sp" = нижний сплит, "float" = всплывающее окно, "vsp" = справа
    size = 0.3,
    cmd = "printf '\\033[2A\\033[J\\033[1;34m================ RUN (%s) ================\\033[0m\\n' \"$(date +%H:%M:%S)\" && go run .",
    clear_cmd = "",
  }
end, { desc = "Go: Run project" })

map("n", "<leader>gg", function()
  vim.cmd "silent! wa"

  local file = vim.fn.expand "%"
  local is_win = vim.fn.has "win32" == 1

  require("nvchad.term").runner {
    id = "floatTerm",
    pos = "float",
    cmd = "go run " .. file,
    clear_cmd = is_win and "cls && " or "clear && ",
  }
end, { desc = "Go: Run current file" })

map("n", "<F1>", function()
  local clients = vim.lsp.get_clients { bufnr = 0, name = "gopls" }
  if #clients == 0 then
    vim.notify("gopls не запущен для этого буфера", vim.log.levels.WARN)
    return
  end

  local row, col = unpack(vim.api.nvim_win_get_cursor(0))
  local pos = { line = row - 1, character = col }

  clients[1]:exec_cmd({
    title = "Open pkg.go.dev",
    command = "gopls.doc",
    arguments = {
      {
        Location = {
          uri = vim.uri_from_bufnr(0),
          range = { start = pos, ["end"] = pos },
        },
        Show = false,
      },
    },
  }, { bufnr = 0 }, function(err, url)
    if err then
      vim.notify(err.message, vim.log.levels.ERROR)
    elseif url and url ~= "" then
      vim.ui.open(url)
    end
  end)
end, { desc = "Go: Open pkg.go.dev docs" })
