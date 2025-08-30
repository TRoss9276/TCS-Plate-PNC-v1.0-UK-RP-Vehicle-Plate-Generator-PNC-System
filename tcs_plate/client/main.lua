-- Client-side for TCS Plate & PNC

-- Apply plate to player's vehicle
RegisterNetEvent('tcs_plate:client:setPlate', function(plate)
    local ped = PlayerPedId()
    local veh = GetVehiclePedIsIn(ped, false)

    if veh and veh ~= 0 then
        SetVehicleNumberPlateText(veh, plate)
        -- Optionally, update the plate index too
        SetVehicleNumberPlateTextIndex(veh, 0)
        TriggerEvent('chat:addMessage', { args = { '^2TCS:^7 Plate applied: ' .. plate } })
    else
        TriggerEvent('chat:addMessage', { args = { '^2TCS:^7 You are not in a vehicle.' } })
    end
end)

-- Display PNC results
RegisterNetEvent('tcs_plate:client:pncResult', function(record)
    if record then
        local msg = 'PNC Record for ' .. record.plate .. ': Owner=' .. (record.owner or 'Unknown') .. ', Model=' .. (record.model or 'Unknown')
        if record.flags and #record.flags > 0 then
            msg = msg .. ', Flags=' .. table.concat(record.flags, ', ')
        end
        TriggerEvent('chat:addMessage', { args = { '^2TCS:^7 ' .. msg } })
    else
        TriggerEvent('chat:addMessage', { args = { '^2TCS:^7 No PNC record found.' } })
    end
end)

-- Optional: command shortcuts for testing
RegisterCommand('genplate', function()
    TriggerServerEvent('tcs_plate:server:generatePlate')
end)

RegisterCommand('pnc', function(_, args)
    if args[1] then
        TriggerServerEvent('tcs_plate:server:pncLookup', args[1])
    else
        TriggerEvent('chat:addMessage', { args = { '^2TCS:^7 Usage: /pnc [plate]' } })
    end
end)