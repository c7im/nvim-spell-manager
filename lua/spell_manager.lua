local M = {}

-- За замовчуванням список конфігів spelllang
local default_modes = {
  { "en_us", "ru" },
  {}, -- OFF
  { "en_us", "uk" },
}

local current = 0
local modes = default_modes

--- Перемикання режимів перевірки орфографії
function M.cycle_spell()
  current = current % #modes + 1
  local langs = modes[current]

  if #langs == 0 then
    vim.opt.spell = false
    print("Spell OFF")
  else
    vim.opt.spell = true
    vim.opt.spelllang = langs
    print("Spell: " .. table.concat(langs, ", "))
  end
end

--- Видалити слово під курсором з усіх активних spell-файлів і оновити словники
function M.delete_word()
  local word = vim.fn.expand("<cword>")
  if word == nil or word == "" then
    print("Немає слова під курсором")
    return
  end

  local langs = vim.opt.spelllang:get()
  if #langs == 0 then
    print("spelllang порожній — нічого видаляти")
    return
  end

  local removed_any = false
  for _, lang in ipairs(langs) do
    local addfile = vim.fn.stdpath("config") .. "/spell/" .. lang .. ".utf-8.add"
    if vim.fn.filereadable(addfile) == 1 then
      local lines = vim.fn.readfile(addfile)
      local new_lines = {}
      local removed_here = false
      for _, l in ipairs(lines) do
        if l ~= word then
          table.insert(new_lines, l)
        else
          removed_here = true
        end
      end
      if removed_here then
        removed_any = true
        vim.fn.writefile(new_lines, addfile)
        vim.cmd("mkspell! " .. addfile)
      end
    end
  end

  if removed_any then
    vim.o.spell = true
    print('Слово "' .. word .. '" видалено зі словника(ів)')
  else
    print('Слово "' .. word .. '" не знайдено у активних словниках')
  end
end

--- Налаштування плагіна
--- @param opts table|nil { modes = {{"en_us","ru"}, {}, {"en_us","uk"}}, key_cycle = "<F7>", key_delete = "zd" }
function M.setup(opts)
  opts = opts or {}
  modes = opts.modes or default_modes

  local key_cycle = opts.key_cycle or "<F7>"
  local key_delete = opts.key_delete or "zd"

  vim.keymap.set("n", key_cycle, M.cycle_spell, { desc = "Cycle spellcheck languages" })
  vim.keymap.set("n", key_delete, M.delete_word, { noremap = true, silent = true, desc = "Delete word from spellfile(s)" })
end

return M
