# nvim-lammps-syntax (Spellcycle plugin)

Neovim plugin to **cycle spellcheck languages** and **remove words from spellfiles**.

## ✨ Features
- Cycle between predefined `spelllang` sets with `<F7>`
- Toggle spellcheck off
- Remove word under cursor from all active spellfiles with `zd`

## 📦 Installation

Using [lazy.nvim](https://github.com/folke/lazy.nvim):

```lua
{
  "c7im/nvim-lammps-syntax",
  config = function()
    require("spellcycle").setup()
  end
}
```

Using [packer.nvim](https://github.com/wbthomason/packer.nvim):

```lua
use {
  "c7im/nvim-lammps-syntax",
  config = function()
    require("spellcycle").setup()
  end
}
```

## ⚡ Usage
- `<F7>` → cycle through `{ "en_us", "ru" } → OFF → { "en_us", "uk" }`
- `zd` → delete word under cursor from all active spellfiles

## 📜 License
MIT
