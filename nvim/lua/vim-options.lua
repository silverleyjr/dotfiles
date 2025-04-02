vim.g.mapleader = " "
vim.wo.number = true
vim.wo.relativenumber = true

vim.keymap.set("n", "<c-k>", ":wincmd k<CR>")
vim.keymap.set("n", "<c-j>", ":wincmd j<CR>")
vim.keymap.set("n", "<c-h>", ":wincmd h<CR>")
vim.keymap.set("n", "<c-l>", ":wincmd l<CR>")
vim.api.nvim_set_keymap("t", "<Esc>", "<C-\\><C-n>", { noremap = true, silent = true })

vim.api.nvim_create_user_command("Tt", function(opts)
    local height = math.floor(vim.o.lines * 0.3)
    vim.cmd("belowright split")
    vim.cmd("resize" .. height)
    vim.cmd("terminal")
    vim.cmd("startinsert")
    if opts.args ~= "" then
        vim.api.nvim_chan_send(vim.b.terminal_job_id, opts.args .. "\n")
    end
end, {
    nargs = "*",
    desc = "Open terminal and execute command",
})
