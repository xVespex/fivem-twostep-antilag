local isTwoStepActive = false
local lastThrottleTime = 0
local currentVehicle = nil
local scriptEnabled = true

-- Send message to NUI to play a sound
local function playSound(soundName)
    SendNUIMessage({
        action = "playSound",
        sound = soundName
    })
end

local function getVehicleClassRPM(vehicle)
    local class = GetVehicleClass(vehicle)
    return Config.TwoStepRPMByClass[class] or 3500
end

local function getAntilagDuration(vehicle)
    local class = GetVehicleClass(vehicle)
    return Config.AntilagDurationByClass[class] or 2000
end

local function spawnExhaustFlames(vehicle)
    if not DoesEntityExist(vehicle) then return end
    RequestNamedPtfxAsset(Config.FxAssets.ParticleAsset)
    while not HasNamedPtfxAssetLoaded(Config.FxAssets.ParticleAsset) do
        Wait(0)
    end

    local exhaustBones = {
        "exhaust",
        "exhaust_1",
        "exhaust_2",
        "exhaust_3",
        "exhaust_4",
        "exhaust_5"
    }

    for _, boneName in pairs(exhaustBones) do
        local boneIndex = GetEntityBoneIndexByName(vehicle, boneName)
        if boneIndex ~= -1 then
            local boneCoords = GetWorldPositionOfEntityBone(vehicle, boneIndex)
            UseParticleFxAssetNextCall(Config.FxAssets.ParticleAsset)
            StartParticleFxNonLoopedAtCoord(Config.FxAssets.ParticleName, boneCoords.x, boneCoords.y, boneCoords.z, 0.0, 0.0, 0.0, 1.0, false, false, false)
        end
    end
end

-- Toggle script on/off
CreateThread(function()
    while true do
        Wait(0)
        if IsControlJustReleased(0, Config.ToggleKey) then
            scriptEnabled = not scriptEnabled
            local msg = scriptEnabled and "~g~2-Step & Antilag ENABLED" or "~r~2-Step & Antilag DISABLED"
            -- Notify player
            BeginTextCommandThefeedPost("STRING")
            AddTextComponentSubstringPlayerName(msg)
            EndTextCommandThefeedPostTicker(false, false)
        end
    end
end)

-- Main loop
CreateThread(function()
    while true do
        Wait(0)
        if not scriptEnabled then
            Wait(500)
            goto continue
        end

        local ped = PlayerPedId()
        if IsPedInAnyVehicle(ped, false) then
            local vehicle = GetVehiclePedIsIn(ped, false)
            if GetPedInVehicleSeat(vehicle, -1) == ped then
                currentVehicle = vehicle
                local rpm = GetVehicleCurrentRpm(vehicle)
                local throttle = GetControlNormal(0, Config.ThrottleControl)
                local brake = IsControlPressed(0, Config.BrakeControl)
                local twoStepRPM = getVehicleClassRPM(vehicle)

                -- 2-Step Logic
                if IsControlPressed(0, Config.TwoStepKey) and throttle > 0.1 and brake then
                    if rpm > (twoStepRPM / 10000.0) then
                        SetVehicleCurrentRpm(vehicle, twoStepRPM / 10000.0)
                        if not isTwoStepActive then
                            isTwoStepActive = true
                            playSound(Config.Sounds.TwoStep)
                        end
                    end
                else
                    if isTwoStepActive then
                        isTwoStepActive = false
                    end
                end

                -- Antilag Logic
                if throttle > 0.1 then
                    lastThrottleTime = GetGameTimer()
                elseif (GetGameTimer() - lastThrottleTime) < getAntilagDuration(vehicle) then
                    if math.random(100) <= Config.BackfireChance then
                        playSound(Config.Sounds.Backfire)
                        spawnExhaustFlames(vehicle)
                    end
                end
            else
                currentVehicle = nil
            end
        else
            currentVehicle = nil
            Wait(500)
        end

        ::continue::
    end
end)
