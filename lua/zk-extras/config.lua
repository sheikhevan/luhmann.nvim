local M = {}

local default_config = {
    graph = {
        enabled = true,
        show_orphans = true,
        show_tags = false,
    }
}

local user_config = {}

function M.setup(opts)
    user_config = vim.tbl_deep_extend('force', default_config, opts or {})
end

function M.get()
    return vim.tbl_deep_extend('force', default_config, user_config)
end

return M
