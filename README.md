# nvim-spell-manager

Neovim plugin to **cycle spellcheck languages** and **remove words from spellfiles**.

## ✨ Features
- Cycle between predefined `spelllang` sets with `<F7>`
- Toggle spellcheck off
- Remove word under cursor from all active spellfiles with `zd`

## 📦 Installation

With [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
    "c7im/nvim-spell-manager",
    config = function()
        require("spell_manager").setup()
    end
}
```

## ⚡ Usage
- `<F7>` → cycle `{ "en_us", "ru" } → OFF → { "en_us", "uk" }`
- `zd` → delete word under cursor from all active spellfiles

## 📜 License
MIT
