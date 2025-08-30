# nvim-spell-manager

Плагін для Neovim, який дозволяє:
- Додавати слова в ignore-лист (`zi`)
- Видаляти слова з ignore-листа (`zd`)
- Автоматично підвантажувати словник при зміні файлу ignore.utf-8.add
- Автоматично вмикати spelllang=en_us,uk при старті

## Встановлення

```lua
use({
  "c7im/nvim-spell-manager",
  config = function()
    require("spell_manager")
  end,
})
```

## Гарячі клавіші

- `zi` — додати слово у ignore-лист
- `zd` — видалити слово з ignore-листа
