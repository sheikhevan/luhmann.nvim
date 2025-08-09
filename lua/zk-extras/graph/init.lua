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

local function make_graph_buffer(notes, links)
    local buf = vim.api.nvim_create_buf(false, true)

    local nodes = function()
        for _, note in ipairs(notes or {}) do
            local note_id = note.metadata and note.metadata.id or "ID not found"
            return string.format("[%s] %s", note_id, note.title or "Title not found")
        end
    end

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, {
        nodes()
    })

    local win = vim.api.nvim_open_win(buf, true, {
        style = "minimal",
        border = "rounded"
    })

    return buf
end

function M.open_graph()
    local graph_json = get_graph_json()
    if not graph_json then
        return
    end

    local notes_by_id = {}
    for _, note in ipairs(graph_json.notes) do
        local note_id = note.metadata and note.metadata.id
        if note_id then
            notes_by_id[note_id] = note
        end
    end

    for i, note in ipairs(graph_json.notes or {}) do
        local note_id = note.metadata and note.metadata.id or "No ID"
        print(string.format("[%d] %s (%s)", i, note.title or "No Title", note_id))
    end

    for i, link in ipairs(graph_json.links or {}) do
        local source_note = notes_by_id[link.sourceId]
        local target_note = notes_by_id[link.targetId]
        local source_title = source_note and source_note.title or ("ID: " .. (link.sourceId or "Unknown"))
        local target_title = target_note and target_note.title or ("ID: " .. (link.targetId or "Unknown"))

        print(string.format("[%d] %s -> %s", i, source_title, target_title))
    end

    print(string.format("\nTotal: %d notes, %d links", #graph_json.notes, #graph_json.links))

    make_graph_buffer(graph_json.notes, graph_json.links)
end

return M
