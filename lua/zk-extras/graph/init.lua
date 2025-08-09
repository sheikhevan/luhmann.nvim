local M = {}

local function get_graph_json()
    local result = vim.system({ 'zk', 'graph', '--format=json' }, { text = true }):wait()

    if result.code == 0 then
        local success, data = pcall(vim.json.decode, result.stdout)
        if success then
            return data
        else
            vim.notify("Failed to parse graph JSON: " .. tostring(data), vim.log.levels.ERROR)
        end
    else
        vim.notify("Getting graph JSON from zk failed: " .. result.stderr, vim.log.levels.ERROR)
    end

    return nil
end

function M.open_graph()
    local graph_json = get_graph_json()
    if graph_json then
        for _, node in ipairs(graph_json.nodes or {}) do
            print("Node: ", node.id, node.title)
        end

        for _, link in ipairs(graph_json.links or {}) do
            print("Link: ", link.source, "->", link.target)
        end
    end
end

return M
