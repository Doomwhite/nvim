local mark = require("harpoon.mark")
local ui = require("harpoon.ui")

local wk = require("which-key")
wk.setup()

local n_opts = {
    mode = "n", -- NORMAL mode
    prefix = "",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
}
wk.register({
    ["<leader>"] = {
        name = "Leader layer",
        ["<leader>"] = {
            name = "Leader second layer",
            ["p"] = {
                name = "Packer",
                ["s"] = { ":PackerSync<CR>", "Sync" },
            },
            g = { vim.cmd.Git, "Git fugitive" },
            e = { ":NvimTreeToggle<CR>", "Toggle tree" },
        },
        q = { ":q<CR>", "Quit" },
        ["Q"] = { ":q!<CR>", "Force quit" },
        t = { ":ToggleTerm<CR>", "Toggle terminal" },
        f = {
            name = "Find",
            f = { ":Telescope find_files<CR>", "Find files" },
            t = { ":Telescope live_grep<CR>", "Find text" },
        },
        w = {
            name = "Window/Buffer",
            a = { ":wa<CR>", "Save all" },
            s = { ":split<CR>", "Split window horizontally" },
            v = { ":vsplit<CR>", "Split window vertically" },
            e = { ":NvimTreeFocus<CR>", "Focus tree" },
            h = { "<C-w>h", "Move to window on the left" },
            j = { "<C-w>j", "Move to window below" },
            k = { "<C-w>k", "Move to window above" },
            l = { "<C-w>l", "Move to window on the right" },
            [";"] = { ":BufferLineCycleNext<CR>", "Next" },
            [","] = { ":BufferLineCyclePrev<CR>", "Previous" },
            p = { ":BufferLineTogglePin<CR>", "Pin" },
            c = { ":BufferLineClose<CR>", "Close right" },
            cl = { ":BufferLineCloseRight<CR>", "Close right" },
            ch = { ":BufferLineCloseLeft<CR>", "Close left" },
            w = { ":BufferLinePick<CR>", "Pick" },
            ["="] = { ":BufferLineSortByTabs<CR>", "Sort by tabs" },
            ["1"] = { ":BufferLineGoToBuffer 1<CR>", "Go to buffer 1" },
            ["2"] = { ":BufferLineGoToBuffer 2<CR>", "Go to buffer 2" },
            ["3"] = { ":BufferLineGoToBuffer 3<CR>", "Go to buffer 3" },
            ["4"] = { ":BufferLineGoToBuffer 4<CR>", "Go to buffer 4" },
            ["5"] = { ":BufferLineGoToBuffer 5<CR>", "Go to buffer 5" },
            ["6"] = { ":BufferLineGoToBuffer 6<CR>", "Go to buffer 6" },
            ["7"] = { ":BufferLineGoToBuffer 7<CR>", "Go to buffer 7" },
            ["8"] = { ":BufferLineGoToBuffer 8<CR>", "Go to buffer 8" },
            ["9"] = { ":BufferLineGoToBuffer 9<CR>", "Go to buffer 9" },
        },
        h = {
            name = "Harpoon",
            a = { mark.add_file, "Adds files" },
            e = { mark.add_file, "Toggles menu" },
            a = { function() ui.nav_file(1) end, "Go to file 1" },
            s = { function() ui.nav_file(2) end, "Go to file 2" },
            d = { function() ui.nav_file(3) end, "Go to file 3" },
            f = { function() ui.nav_file(4) end, "Go to file 4" }
        },
    },
    g = {
        ["e"] = {
            name = "Trouble.nvim",
            l = { ":TroubleToggle<CR>", "Toggle quickfix list" }
        },
    },
    ["H"] = { "^", "Move to beginning of line" },
    ["L"] = { "$", "Move to end of line" },
    ["<C-Up>"] = { ":resize +2<CR>", "Increase window height" },
    ["<C-Down>"] = { ":resize -2<CR>", "Decrease window height" },
    ["<C-Left>"] = { ":vertical resize -2<CR>", "Decrease window width" },
    ["<C-Right>"] = { ":vertical resize +2<CR>", "Increase window width" },
}, n_opts)

local i_opts = {
    mode = "i", -- INSERT mode
    prefix = "",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
}

wk.register({
    ["jk"] = { "<ESC>", "Exit insert mode (jk)" }
}, i_opts)

local v_opts = {
    mode = "v", -- VISUAL mode
    prefix = "",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
}

wk.register({
    ["H"] = { "^", "Move to beginning of line" },
    ["L"] = { "$", "Move to end of line" }
}, v_opts)

local x_opts = {
    mode = "x", -- VISUAL LINE  mode
    prefix = "",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
}

wk.register({
    -- ["J"] = { ":m '>+1<CR>gv-gv", "Move selected text down" },
    -- ["K"] = { ":m '<-2<CR>gv-gv", "Move selected text up" },
    -- ["<A-j>"] = { ":m '>+1<CR>gv-gv", "Move selected text down" },
    -- ["<A-k>"] = { ":m '<-2<CR>gv-gv", "Move selected text up" }
}, x_opts)

local t_opts = {
    mode = "t", -- TERMINAL mode
    prefix = "",
    buffer = nil, -- Global mappings. Specify a buffer number for buffer local mappings
    silent = true, -- use `silent` when creating keymaps
    noremap = true, -- use `noremap` when creating keymaps
    nowait = false, -- use `nowait` when creating keymaps
}

wk.register({
    ["<C-h>"] = { "<C-\\><C-N><C-w>h", "Move left in terminal mode" },
    ["<C-j>"] = { "<C-\\><C-N><C-w>j", "Move down in terminal mode" },
    ["<C-k>"] = { "<C-\\><C-N><C-w>k", "Move up in terminal mode" },
    ["<C-l>"] = { "<C-\\><C-N><C-w>l", "Move right in terminal mode" },
    ["<Esc>"] = { "<C-\\><C-n>", "Exit terminal mode" },
    ["<leader>t"] = { "<C-\\><C-n>:ToggleTerm<CR>", "Toggle terminal" }
}, t_opts)
