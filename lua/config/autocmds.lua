-- Autocmds are automatically loaded on the VeryLazy event
-- Default autocmds that are always set: https://github.com/LazyVim/LazyVim/blob/main/lua/lazyvim/config/autocmds.lua
-- Add any additional autocmds here

-- Define la función para insertar el console.log
local function insertConsoleLog()
  -- Verifica si estamos en modo visual
  if vim.fn.mode() == "v" or vim.fn.mode() == "V" or vim.fn.mode() == string.char(22) then
    -- Obtiene el texto seleccionado en el modo visual
    local selected_text = vim.fn.getreg('"')

    -- Inserta la nueva línea debajo de la posición actual
    vim.api.nvim_command("normal! o")

    -- Construye el contenido del console.log
    local file_name = vim.fn.expand("%:p")
    local line_number = vim.fn.line(".")
    local console_log = 'console.log("' .. file_name .. ":" .. line_number .. '", ' .. selected_text .. ")"

    -- Inserta el console.log en la nueva línea
    vim.api.nvim_put({ console_log }, "l", true, true)
  else
    -- Obtiene la palabra bajo el cursor en modo normal
    local word = vim.fn.expand("<cword>")

    -- Pasa a modo visual y selecciona la palabra
    vim.api.nvim_command("normal! gv")

    -- Obtiene el texto seleccionado en el modo visual
    local selected_text = vim.fn.getreg('"')

    -- Inserta la nueva línea debajo de la posición actual
    vim.api.nvim_command("normal! o")

    -- Construye el contenido del console.log
    local file_name = vim.fn.expand("%")
    local line_number = vim.fn.line(".")
    local console_log = 'console.log("'
      .. file_name
      .. " ~ "
      .. line_number
      .. " > "
      .. word
      .. ' => ", '
      .. word
      .. ")"

    -- Inserta el console.log en la nueva línea
    vim.api.nvim_put({ console_log }, "l", true, true)

    -- Regresa al modo normal
    vim.api.nvim_command("startinsert")
  end
end
--
-- -- Crea el comando
-- vim.api.nvim_command("command! -nargs=0 InsertConsoleLog lua insertConsoleLog()")
--
-- -- Mapea las teclas Ctrl+Alt+L para ejecutar el comando
-- -- vim.api.nvim_set_keymap("n", "<C-M-l>", ":InsertConsoleLog<CR>", { noremap = true })
-- vim.api.nvim_set_keymap("v", "<C-M-l>", ":InsertConsoleLog<CR>", { noremap = true })
--
-- vim.keymap.set("n", "<C-M-l>", function()
--   insertConsoleLog()
-- end, { noremap = true })
--
-- vim.keymap.set("v", "<C-M-l>", function()
--   insertConsoleLog()
-- end, { noremap = true })
-- -- local map = vim.keymap.set
--
-- -- map("n", "gd", function() vim.lsp.buf.definition() end, opts)
--
--

vim.api.nvim_create_augroup("LogSitter", { clear = true })
vim.api.nvim_create_autocmd("FileType", {
  group = "LogSitter",
  pattern = "javascript,go,lua",
  callback = function()
    vim.keymap.set("n", "<C-M-l>", function()
      require("logsitter").log()
    end)
  end,
})
