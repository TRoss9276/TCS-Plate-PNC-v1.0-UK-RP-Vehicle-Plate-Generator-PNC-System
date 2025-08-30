local jsonPath = 'data/plates.json'
local data = { plates = {} }
local lastGen = {} -- cooldown per player

-- Load existing datastore
local function loadData()
    local raw = LoadResourceFile(GetCurrentResourceName(), jsonPath)
    if raw and raw ~= '' then
        local ok, decoded = pcall(json.decode, raw)
        if ok and type(decoded) == 'table' and decoded.plates then
            data = decoded
        end
    else
        SaveResourceFile(GetCurrentResourceName(), json.encode(data, { indent = true }), -1)
    end
end

-- Persist datastore
local function saveData()
    SaveResourceFile(GetCurrentResourceName(), jsonPath, json.encode(data, { indent = true }), -1)
end

-- Helpers
local function isSuffixBlacklisted(sfx)
    sfx = string.upper(sfx or '')
    for _, bad in ipairs(Config.BlacklistSuffixes) do
        if sfx == bad then return true end
    end
    return false
end

local function randomFrom(list)
    return list[math.random(1, #list)]
end

local function randomLetters(n)
    local s = ''
    for i = 1, n do s = s .. randomFrom(Config.AllowedLetters) end
    return s
end

local function randomDigits(n)
    local s = ''
    for i = 1, n do s = s .. tostring(math.random(0,9)) end
    return s
end

local function plateExists(p)
    p = (p or ''):upper()
    return data.plates[p] ~= nil
end

-- Generate UK (2001+) style plate: AA## AAA
local function generatePlate()
    local attempts = 0
    while attempts < Config.MaxGenerationAttempts do
        attempts = attempts + 1
        local area = randomFrom(Config.AreaCodes)
        local age = randomDigits(2)
        local suffix = randomLetters(3)
        if not isSuffixBlacklisted(suffix) then
            local plate = (area .. age .. ' ' .. suffix):upper()
            if not Config.EnforceUniqueness or not plateExists(plate) then
                return plate
            end
        end
    end
    return nil
end

-- Basic vehicle model placeholder
local function getPrettyModelName(src)
    return 'Unknown'
end

-- Event: Generate plate
RegisterNetEvent('tcs_plate:server:generatePlate', function()
    local src = source
    local now = os.time()

    if lastGen[src] and (now - lastGen[src]) < Config.GenerateCooldown then
        local wait = Config.GenerateCooldown - (now - lastGen[src])
        TriggerClientEvent('chat:addMessage', src, { args = { Config.Tag, '^1Please wait ^7'..wait..'^1s before generating again.' } })
        return
    end

    local plate = generatePlate()
    if not plate then
        TriggerClientEvent('chat:addMessage', src, { args = { Config.Tag, '^1Failed to generate a unique plate. Try again.' } })
        return
    end

    lastGen[src] = now

    if Config.EnforceUniqueness and not data.plates[plate] then
        data.plates[plate] = {
            plate = plate,
            owner = GetPlayerName(src),
            model = getPrettyModelName(src),
            colour = nil,
            flags = {},
            createdAt = os.date('!%Y-%m-%d %H:%M:%S UTC')
        }
        saveData()
    end

    TriggerClientEvent('tcs_plate:client:setPlate', src, plate)
    TriggerClientEvent('chat:addMessage', src, { args = { Config.Tag, ('^2Generated plate:^7 %s'):format(plate) } })
end)

-- Event: PNC lookup
RegisterNetEvent('tcs_plate:server:pncLookup', function(plate)
    local src = source
    plate = string.upper((plate or ''):gsub('%s+', ''))

    local record = data.plates[plate]
    if not record then
        local compact = plate:gsub('%s+', '')
        if #compact == 7 then
            local spaced = string.sub(compact,1,4)..' '..string.sub(compact,5)
            record = data.plates[spaced] or data.plates[compact]
        else
            record = data.plates[compact]
        end
    end

    TriggerClientEvent('tcs_plate:client:pncResult', src, record)
end)

-- Event: Register plate to player
RegisterNetEvent('tcs_plate:server:registerPlate', function(plate)
    local src = source
    plate = (plate or ''):upper()
    if plate == '' then return end

    if not data.plates[plate] then
        data.plates[plate] = { plate = plate, owner = nil, model = nil, colour = nil, flags = {}, createdAt = os.date('!%Y-%m-%d %H:%M:%S UTC') }
    end

    data.plates[plate].owner = GetPlayerName(src)
    saveData()

    TriggerClientEvent('chat:addMessage', src, { args = { Config.Tag, ('^2Registered plate to:^7 %s'):format(GetPlayerName(src)) } })
end)

-- Admin: Flag plate
RegisterCommand('flagplate', function(src, args)
    local plate = (args[1] or ''):upper()
    if plate == '' then return end
    local reason = table.concat(args, ' ', 2)

    if not data.plates[plate] then
        data.plates[plate] = { plate = plate, owner = nil, model = nil, colour = nil, flags = {}, createdAt = os.date('!%Y-%m-%d %H:%M:%S UTC') }
    end

    table.insert(data.plates[plate].flags, reason ~= '' and reason or 'Flagged')
    saveData()

    if src > 0 then
        TriggerClientEvent('chat:addMessage', src, { args = { Config.Tag, ('^3Flag added:^7 %s  ^5Reason:^7 %s'):format(plate, reason) } })
    end
end, true)

-- Admin: Unflag plate
RegisterCommand('unflagplate', function(src, args)
    local plate = (args[1] or ''):upper()
    if plate == '' or not data.plates[plate] then return end

    data.plates[plate].flags = {}
    saveData()

    if src > 0 then
        TriggerClientEvent('chat:addMessage', src, { args = { Config.Tag, ('^2Flags cleared for:^7 %s'):format(plate) } })
    end
end, true)

-- Initialize
CreateThread(function()
    math.randomseed(GetGameTimer() + os.time())
    loadData()
end)