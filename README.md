# nvim-spell-manager

Neovim plugin to **cycle spellcheck languages** and **remove words from spellfiles**.

## ✨ Features
- Cycle between predefined `spelllang` sets (default: `<F7>`)
- Toggle spellcheck off (empty set in the cycle)
- Remove word under cursor from all **active** spellfiles (default: `zd`)

## 📦 Installation (lazy.nvim)

```lua
{
    "c7im/nvim-spell-manager",
    config = function()
        require("spell_manager").setup()
    end
}
```

You can also customize keys and modes:

```lua
{
    "c7im/nvim-spell-manager",
    config = function()
        require("spell_manager").setup({
            modes = {
                { "en_us", "ru" },
                {}, -- OFF
                { "en_us", "uk" },
            },
            key_cycle = "<F7>",
            key_delete = "zd",
        })
    end
}
```

## ⚡ Usage
- `<F7>` → cycle `{ "en_us", "ru" } → OFF → { "en_us", "uk" }`
- `zd` → delete word under cursor from all active spellfiles and rebuild `.spl` via `:mkspell!`

## 📜 License
MIT
