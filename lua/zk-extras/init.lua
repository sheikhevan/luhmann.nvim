local M = {}

function M.setup(opts)
    local config = require("zk-extras.config")

    local user_config = vim.tbl_deep_extend('force', config.default_config, opts or {})
    M.config = user_config

    if user_config.graph.enabled then
        require('zk-extras.graph')
    end
end

return M
