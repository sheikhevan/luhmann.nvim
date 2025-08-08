local config = require("zk-extras.config")

local M = {}

function M.setup(opts)
    config.options = vim.tbl_deep_extend('force', config.defaults, opts or {})
end

return M
