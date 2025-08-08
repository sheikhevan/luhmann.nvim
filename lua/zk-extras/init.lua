local config = require("zk-extras.config")

local M = {}

function M.setup(opts)
    print("zk-extras setup called with:")
    print(vim.inspect(opts or {}))

    config.options = vim.tbl_deep_extend('force', config.defaults, opts or {})

    print("Final config:")
    print(vim.inspect(config.options))

    local graph = require("zk-extras.graph")
    graph.setup()
end

return M
