
local M = {}

M.ignore_file = vim.fn.stdpath("config") .. "/spell/ignore.utf-8.add"

function M.load_ignore_list()
    if vim.fn.filereadable(M.ignore_file) == 1 then
        local lines = vim.fn.readfile(M.ignore_file)
        for _, word in ipairs(lines) do
            vim.cmd("spellgood " .. word)
        end
    end
end

function M.setup()
    vim.api.nvim_create_autocmd("BufReadPost", {
        pattern = "*",
        callback = function()
            vim.opt.spell = true
            vim.opt.spelllang = { "en_us", "uk" }
        end,
    })

    vim.api.nvim_create_autocmd({"TextChanged", "TextChangedI"}, {
        pattern = M.ignore_file,
        callback = function()
            M.load_ignore_list()
        end,
    })

    M.load_ignore_list()

    vim.keymap.set("n", "zd", M.delete_word_from_spell, { noremap = true, silent = true })
    vim.keymap.set("n", "zg", M.add_word_auto, { noremap = true, silent = true })
    vim.keymap.set("n", "zi", M.add_word_to_ignore, { noremap = true, silent = true })
end

function M.delete_word_from_spell()
    local word = vim.fn.expand("<cword>")
    for _, lang in ipairs(vim.opt.spelllang:get()) do
        local addfile = vim.fn.stdpath("config") .. "/spell/" .. lang .. ".utf-8.add"
        if vim.fn.filereadable(addfile) == 1 then
            local lines = vim.fn.readfile(addfile)
            local new_lines = {}
            for _, l in ipairs(lines) do
                if l ~= word then
                    table.insert(new_lines, l)
                end
            end
            vim.fn.writefile(new_lines, addfile)
            vim.cmd("mkspell! " .. addfile)
        end
    end
    vim.o.spell = true
    print('Слово "' .. word .. '" видалено зі словників')
end

local function detect_language(word)
    if word:match("^[a-zA-Z]+$") then
        return "en_us"
    else
        return "uk"
    end
end

function M.add_word_auto()
    local word = vim.fn.expand("<cword>")
    local ignore_words = {}
    if vim.fn.filereadable(M.ignore_file) == 1 then
        ignore_words = vim.fn.readfile(M.ignore_file)
    end
    for _, w in ipairs(ignore_words) do
        if word == w then
            print("Слово у ignore-листі, не додаємо: " .. word)
            return
        end
    end
    local lang = detect_language(word)
    local addfile = vim.fn.stdpath("config") .. "/spell/" .. lang .. ".utf-8.add"
    vim.cmd("spellgood " .. word)
    vim.cmd("mkspell! " .. addfile)
    vim.o.spell = true
    print('Слово "' .. word .. '" додано у словник ' .. lang)
end

function M.add_word_to_ignore()
    local word = vim.fn.expand("<cword>")
    local lines = {}
    if vim.fn.filereadable(M.ignore_file) == 1 then
        lines = vim.fn.readfile(M.ignore_file)
    end
    for _, w in ipairs(lines) do
        if w == word then
            print("Слово вже у ignore-листі: " .. word)
            return
        end
    end
    table.insert(lines, word)
    vim.fn.writefile(lines, M.ignore_file)
    M.load_ignore_list()
    print("Слово додано у ignore-лист та підвантажено у всі буфери: " .. word)
end

return M
