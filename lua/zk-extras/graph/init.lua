local config = require('zk-extras.config')

local M = {}

function M.show_graph()
    print("Imma show that graph")
end

function M.setup()
    print("Graph setup called - enabled:", config.options.graph.enabled)

    if config.options.graph.enabled then
        print("Registering ZkExtrasGraph command")
        vim.api.nvim_create_user_command('ZkExtrasGraph', function()
            M.show_graph()
        end, {
            desc = "Show a graph of your zk notes (zk-extras)"
        })
    else
        print("Graph is disabled, not registering command")
    end
end

return M
