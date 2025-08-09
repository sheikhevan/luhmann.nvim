local M = {}

function M.setup(opts)
    local config = require("zk-extras.config")

    local user_config = vim.tbl_deep_extend('force', config.default_config, opts or {})
    M.config = user_config

    if user_config.graph.enabled then
        local graph = require('zk-extras.graph')
        vim.api.nvim_create_user_command("ZkExtrasGraphOpen", function()
            graph.open_graph()
        end, {
            desc = "Open zk-extras graph view"
        })
    end
end

return M
