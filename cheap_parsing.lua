local timer_Create = timer.Create
local timer_Remove = timer.Remove
local table_Empty = table.Empty
local table_insert = table.insert
local next = next
local queue = {}
local parsingKey = 0
local istable = istable
local isfunction = isfunction

local function RunQueue()
    parsingKey = next(queue, parsingKey)

    if parsingKey then
        local current_parse_data = queue[parsingKey]
        local parse_tbl = current_parse_data[1]
        local cback = current_parse_data[2]
        local prevKey

        timer_Create('cheapParsing.Queue', .075, 0, function()
            local nextKey, val = next(parse_tbl, prevKey)
            if nextKey and val then
                cback(nextKey, val)
                prevKey = nextKey
            else
                queue[parsingKey] = nil
                timer_Remove('cheapParsing.Queue')
                RunQueue()
            end
        end)
    else
        parsingKey = 0
    end
end

local function ParseTable(tbl, cback)
    if not istable(tbl) or not next(tbl) then
        return
    end

    if not cback or not isfunction(cback) then
        return
    end
    
    local can_queue = false

    if not next(queue) then
        can_queue = true
    end

    table_insert(queue, {tbl, cback})

    if can_queue then
        RunQueue()
    end
end

CheapTables = CheapTables or {
    ParseTable = ParseTable
}
