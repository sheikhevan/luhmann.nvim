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

    local notes_by_id = {}
    for _, note in ipairs(notes or {}) do
        local note_id = note.metadata and note.metadata.id
        if note_id then
            notes_by_id[note_id] = note
        end
    end

    local lines = {}

    table.insert(lines, "=== Notes ===")
    for i, note in ipairs(notes or {}) do
        local note_id = note.metadata and note.metadata.id or "No ID"
        table.insert(lines, string.format("[%d] %s (%s)", i, note.title or "No Title", note_id))
    end

    table.insert(lines, "")
    table.insert(lines, "=== Links ===")

    for i, link in ipairs(links or {}) do
        local source_note = notes_by_id[link.sourceId]
        local target_note = notes_by_id[link.targetId]
        local source_title = source_note and source_note.title or ("ID: " .. (link.sourceId or "Unknown"))
        local target_title = target_note and target_note.title or ("ID: " .. (link.targetId or "Unknown"))

        table.insert(lines, string.format("[%d] %s -> %s", i, source_title, target_title))
    end

    table.insert(lines, "")
    table.insert(lines, string.format("Total: %d notes, %d links", #(notes or {}), #(links or {})))

    vim.api.nvim_buf_set_lines(buf, 0, -1, false, lines)

    local width = math.floor(vim.o.columns * 0.8)
    local height = math.floor(vim.o.lines * 0.8)

    local col = math.floor((vim.o.columns - width) / 2)
    local row = math.floor((vim.o.lines - height) / 2)

    local win = vim.api.nvim_open_win(buf, true, {
        style = "minimal",
        border = "rounded",
        width = width,
        height = height,
        row = row,
        col = col,
        relative = "editor"
    })

    return buf, win
end

function M.open_graph()
    local graph_json = get_graph_json()
    if not graph_json then
        return
    end

    local buf, win = make_graph_buffer(graph_json.notes, graph_json.links)

    return buf, win
end

return M
