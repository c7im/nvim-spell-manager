
# nvim-spell-manager

Neovim Lua-плагін для керування словниками орфографії з підтримкою декількох мов (en_us та uk) та ignore-листом.

## Особливості

- Автовизначення мови слова та додавання у словник (`zg`).
- Видалення слова зі словників (`zd`).
- Ignore-лист (`ignore.utf-8.add`) з підтримкою LaTeX-команд.
- Живе автооновлення ignore-листа при редагуванні.
- Гаряча клавіша `gi` для швидкого додавання слова у ignore-лист.

## Встановлення

Використовуючи [lazy.nvim] або [packer.nvim]:

```lua
use {
  "c7im/nvim-spell-manager",
  config = function()
    require("spell_manager").setup()
  end
}
```
