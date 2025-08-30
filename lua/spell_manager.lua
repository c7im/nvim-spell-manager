local M = {}

M.ignore_file = vim.fn.stdpath("config") .. "/spell/ignore.utf-8.add"

-- Забезпечуємо наявність директорії spell
vim.fn.mkdir(vim.fn.stdpath("config") .. "/spell", "p")

-- ==========================
-- Завантаження ignore-листа
-- ==========================
function M.load_ignore_list()
    if vim.fn.filereadable(M.ignore_file) == 1 then
        vim.opt.spellfile = M.ignore_file
        local lines = vim.fn.readfile(M.ignore_file)
        for _, word in ipairs(lines) do
            if word ~= "" then
                vim.cmd("silent! spellgood " .. word)
            end
        end
    end
end

-- ==========================
-- Додавання слова в ignore-лист
-- ==========================
function M.add_word_to_ignore()
    local word = vim.fn.expand("<cword>")
    if word == "" then return end
    local f = io.open(M.ignore_file, "a+")
    if f then
        f:write(word .. "\\n")
        f:close()
    end
    vim.opt.spellfile = M.ignore_file
    vim.cmd("silent! spellgood " .. word)
    print("Ignored word: " .. word)
end

-- ==========================
-- Автоматичне підвантаження при зміні ignore.utf-8.add
-- ==========================
vim.api.nvim_create_autocmd({"BufWritePost"}, {
    pattern = "ignore.utf-8.add",
    callback = function()
        M.load_ignore_list()
    end,
})

-- ==========================
-- Клавіатурні скорочення
-- ==========================
vim.keymap.set("n", "zi", function() M.add_word_to_ignore() end,
    { desc = "Add word to ignore list" })

vim.keymap.set("n", "zd", function()
    local word = vim.fn.expand("<cword>")
    if word == "" then return end
    -- Видаляємо слово з файлу
    if vim.fn.filereadable(M.ignore_file) == 1 then
        local lines = vim.fn.readfile(M.ignore_file)
        local new_lines = {}
        for _, w in ipairs(lines) do
            if w ~= word then
                table.insert(new_lines, w)
            end
        end
        vim.fn.writefile(new_lines, M.ignore_file)
    end
    print("Removed word from ignore list: " .. word)
    M.load_ignore_list()
end, { desc = "Remove word from ignore list" })

-- ==========================
-- Автоматичне завантаження при старті
-- ==========================
vim.api.nvim_create_autocmd("VimEnter", {
    callback = function()
        vim.opt.spell = true
        vim.opt.spelllang = { "en_us", "uk" }
        M.load_ignore_list()
    end,
})

return M
