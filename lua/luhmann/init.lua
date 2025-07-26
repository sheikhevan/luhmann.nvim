local M = {}

M.config = {
    zk_dir = vim.fn.expand("~/documents/zk"),
    templates = {
        zettel = "# {{id}} {{title}}\n**created:** {{date}}\n**tags:** \n\n",
        literature =
        "# {{id}} {{title}}\n**created:** {{date}}\n\n\n\n## references\n\n"
    }
}

function M.setup(opts)
    M.config = vim.tbl_deep_extend("force", M.config, opts or {})
    vim.fn.mkdir(M.config.zk_dir, "p")

    vim.api.nvim_create_user_command("LuhmannNew", function(opts)
        M.create_zettel(opts.args, "zettel")
    end, { nargs = "?", desc = "create new zettel" })

    vim.api.nvim_create_user_command("LuhmannLit", function(opts)
        M.create_zettel(opts.args, "literature")
    end, { nargs = "?", desc = "create new literature note" })
end

function M.create_zettel(title, type)
    type = type or "zettel"
    if not title or title == "" then
        title = vim.fn.input("What is the zettel's title: ")
        if title == "" then return end
    end

    local timestamp_id = os.date("%Y%m%d%H%M%S")
    local prefix = type == "literature" and "LIT-" or ""
    local filename = timestamp_id .. " " .. prefix .. title .. ".md"
    local filepath = M.config.zk_dir .. "/" .. filename

    local content = M.config.templates[type]
        :gsub("{{title}}", title)
        :gsub("{{id}}", timestamp_id)
        :gsub("{{date}}", os.date("%Y-%m-%d"))

    vim.fn.writefile(vim.split(content, "\n"), filepath)
    vim.cmd("edit " .. filepath)
    vim.api.nvim_win_set_cursor(0, { vim.fn.line('$'), 0 })

    print("Successfully created zettel: " .. filename)
end

return M
