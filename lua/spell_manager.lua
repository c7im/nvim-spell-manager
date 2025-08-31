local M = {}

local default_modes = {
  { "en_us", "ru" },
  {}, -- OFF
  { "en_us", "uk" },
}

local current = 0
local modes = default_modes
local DEBUG = false

local function expand_path(p)
  if not p or p == "" then return nil end
  return vim.fn.fnamemodify(vim.fn.expand(p), ":p")
end

local function unique(tbl)
  local seen = {}
  local out = {}
  for _, v in ipairs(tbl) do
    if v and v ~= "" and not seen[v] then
      seen[v] = true
      table.insert(out, v)
    end
  end
  return out
end

function M.delete_word()
  local word = vim.fn.expand("<cWORD>")
  if not word or word == "" then
    print("Немає слова під курсором")
    return
  end

  local candidates = {}
  local spellfile_opt = vim.o.spellfile or ""
  if spellfile_opt ~= "" then
    for _, f in ipairs(vim.fn.split(spellfile_opt, ",")) do
      local p = expand_path(f)
      if p then table.insert(candidates, p) end
    end
  end

  local langs = vim.opt.spelllang:get() or {}
  for _, lang in ipairs(langs) do
    if lang and lang ~= "" then
      local l = tostring(lang):lower():gsub("%s+", "")
      l = l:gsub("-", "_")
      table.insert(candidates, vim.fn.stdpath("config") .. "/spell/" .. l .. ".utf-8.add")
      local short = l:match("^([a-z][a-z])")
      if short then
        table.insert(candidates, vim.fn.stdpath("config") .. "/spell/" .. short .. ".utf-8.add")
      end
      table.insert(candidates, vim.fn.stdpath("config") .. "/spell/" .. l:gsub("_", "-") .. ".utf-8.add")
    end
  end

  table.insert(candidates, vim.fn.stdpath("config") .. "/spell/en.utf-8.add")
  table.insert(candidates, vim.fn.stdpath("config") .. "/spell/uk.utf-8.add")
  table.insert(candidates, vim.fn.stdpath("config") .. "/spell/ru.utf-8.add")

  candidates = unique(candidates)

  if DEBUG then
    print("spell_manager: перевіряю кандидати файлів для видалення слова '" .. word .. "':")
    for _, c in ipairs(candidates) do print("  -> " .. c) end
  end

  local removed_any = false
  local tried_any = false

  for _, addfile in ipairs(candidates) do
    if vim.fn.filereadable(addfile) == 1 then
      tried_any = true
      local lines = vim.fn.readfile(addfile)
      local new_lines = {}
      local removed_here = false
      for _, l in ipairs(lines) do
        local trimmed = l:gsub("%s+$", "")
        if trimmed:lower() ~= word:lower() then
          table.insert(new_lines, l)
        else
          removed_here = true
        end
      end

      if removed_here then
        removed_any = true
        vim.fn.writefile(new_lines, addfile)
        vim.cmd("silent! mkspell! " .. vim.fn.fnameescape(addfile))
        if DEBUG then
          print("spell_manager: видалено з " .. addfile)
        end
      else
        if DEBUG then
          print("spell_manager: не знайдено у " .. addfile)
        end
      end
    end
  end

  if not tried_any and not removed_any then
    print('spell_manager: не знайдено жодного add-файлу для перевірки (перевірте &spellfile та ~/.config/nvim/spell/ )')
    return
  end

  if removed_any then
    vim.o.spell = true
    print('Слово "' .. word .. '" видалено зі словника(ів)')
  else
    print('Слово "' .. word .. '" не знайдено у активних словниках')
  end
end

function M.cycle_spell()
  current = current % #modes + 1
  local langs = modes[current] or {}

  if #langs == 0 then
    vim.opt.spell = false
    print("Spell OFF")
  else
    vim.opt.spell = true
    vim.opt.spelllang = langs
    print("Spell: " .. table.concat(langs, ", "))
  end
end

function M.setup(opts)
  opts = opts or {}
  modes = opts.modes or default_modes

  local key_cycle = opts.key_cycle or "<F7>"
  local key_delete = opts.key_delete or "zd"
  DEBUG = opts.debug or false

  vim.keymap.set("n", key_cycle, M.cycle_spell, { desc = "Cycle spellcheck languages" })
  vim.keymap.set("n", key_delete, M.delete_word, { noremap = true, silent = true, desc = "Delete word from spellfile(s)" })
end

return M
