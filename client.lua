local maxThrowStrength = 100
local forceMultiplier = 100

local carryingVehicle, attachedVehicle = false, nil
local isChargingThrow, throwStrength = false, 0
local animDict = "anim@mp_rollarcoaster"
local animName = "hands_up_idle_a_player_one"
local attachBone = 24816
local attachOffset = vector3(2.05, 0.0, 0.5)
local attachRot = vector3(90.0, 0.0, 0.0)

local function loadAnimDict(dict)
    if not HasAnimDictLoaded(dict) then
        RequestAnimDict(dict)
        while not HasAnimDictLoaded(dict) do Wait(0) end
    end
end

CreateThread(function()
    while true do
        if carryingVehicle then
            local player = PlayerPedId()
            if not IsEntityPlayingAnim(player, animDict, animName, 3) then
                loadAnimDict(animDict)
                TaskPlayAnim(player, animDict, animName, 8.0, -8.0, -1, 49, 0, false, false, false)
            end
            Wait(500)
        else
            Wait(1000)
        end
    end
end)

CreateThread(function()
    while true do
        if carryingVehicle then
            if IsControlPressed(0, 38) then
                if not isChargingThrow then
                    isChargingThrow = true
                    throwStrength = 0
                end
                if throwStrength < maxThrowStrength then
                    throwStrength = throwStrength + 1
                    Wait(10)
                else
                    Wait(0) 
                end
            elseif isChargingThrow then
                local player = PlayerPedId()
                local forward = GetEntityForwardVector(player)
                local pos = GetEntityCoords(player)
            
                DetachEntity(attachedVehicle, true, true)
                FreezeEntityPosition(attachedVehicle, false)
            
                Wait(10)
            
                local throwPos = vector3(
                    pos.x + forward.x * 2.0,
                    pos.y + forward.y * 2.0,
                    pos.z + 1.5
                )
                SetEntityCoordsNoOffset(attachedVehicle, throwPos.x, throwPos.y, throwPos.z, false, false, false)
            
                Wait(10) 
            
                local force = (throwStrength / maxThrowStrength) * forceMultiplier
                ApplyForceToEntity(attachedVehicle, 1, forward.x * force, forward.y * force, 5.0, 0.0, 0.0, 0.0, 0, false, true, true, false, true)
            
                ClearPedTasks(player)
                carryingVehicle, attachedVehicle = false, nil
                isChargingThrow, throwStrength = false, 0
            
            else
                Wait(0)
            end
        else
            Wait(500)
        end
    end
end)

CreateThread(function()
    while true do
        if isChargingThrow then
            local width, height = 0.2, 0.03
            local x, y = 0.5 - width / 2, 0.9
            local progress = throwStrength / maxThrowStrength
            DrawRect(x + width / 2, y + height / 2, width, height, 0, 0, 0, 150)
            DrawRect(x + (progress * width / 2), y + height / 2, width * progress, height, 255, 100, 100, 200)
        end
        Wait(0)
    end
end)

RegisterCommand("carrycar", function()
    local player = PlayerPedId()
    local coords = GetEntityCoords(player)
    local vehicle = GetClosestVehicle(coords, 5.0, 0, 70)

    if not carryingVehicle and DoesEntityExist(vehicle) then
        FreezeEntityPosition(vehicle, true)
        AttachEntityToEntity(vehicle, player, GetPedBoneIndex(player, attachBone), attachOffset.x, attachOffset.y, attachOffset.z, attachRot.x, attachRot.y, attachRot.z, true, true, false, false, 2, true)
        carryingVehicle, attachedVehicle = true, vehicle
        loadAnimDict(animDict)
        TaskPlayAnim(player, animDict, animName, 8.0, -8.0, -1, 49, 0, false, false, false)

    elseif carryingVehicle and DoesEntityExist(attachedVehicle) then
        DetachEntity(attachedVehicle, true, true)
        FreezeEntityPosition(attachedVehicle, false)
        carryingVehicle, attachedVehicle = false, nil
        ClearPedTasks(player)
    end
end)
