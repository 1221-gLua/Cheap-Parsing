local timer_Create = timer.Create
local timer_Remove = timer.Remove
local table_Empty = table.Empty
local table_insert = table.insert
local next = next
local queue = {}
local cache = {}
local cachedKeys = {}
local currentQueue = 0
local currentRaw = 1
local istable = istable
local isfunction = isfunction

local function RunQueue()
    currentQueue = next(queue, currentQueue)

    if currentQueue then
        table_Empty(cache)
        table_Empty(cachedKeys)

        local current_parse_data = queue[currentQueue]
        local parse_tbl = current_parse_data[1]
        local cback = current_parse_data[2]

        for k, v in next, parse_tbl do
            table_insert(cachedKeys, k)
            table_insert(cache, v)
        end

        timer_Create('cheapParsing.Queue', .075, 0, function()
            if cachedKeys[currentRaw] and cache[currentRaw] then
                cback(cachedKeys[currentRaw], cache[currentRaw])
                currentRaw = currentRaw + 1
            else
                currentRaw = 1
                queue[currentQueue] = nil
                timer_Remove('cheapParsing.Queue')
                RunQueue()
            end
        end)
    else
        currentQueue = 0
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

CheapParsing = CheapParsing or {
    ParseTable = ParseTable
}
