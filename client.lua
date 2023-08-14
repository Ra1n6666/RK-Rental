local QBCore = exports['qb-core']:GetCoreObject()
local rentedEntities = {}

function VehicleRespawn(name, data)
    Citizen.CreateThread(function()
        Wait(data.cooldown)
        local ped = PlayerPedId()
        local vehicle = CreateVehicle(GetHashKey(name), data.coords, true, true)
        SetEntityNoCollisionEntity(vehicle, ped, false)
        SetEntityAlpha(vehicle, 127, false)
        SetVehicleDoorsLocked(vehicle, 2)
        SetEntityInvincible(vehicle, true)
        exports['qb-target']:AddTargetEntity(vehicle, {
            options = {
                {
                    icon = "fas fa-car",
                    label = "Rent " .. name:gsub("^%l", string.upper) .. " for " .. data.price .. "$",
                    action = function()
                        QBCore.Functions.TriggerCallback("rk-rental:Rent", function(data)
                            if data then
                                SetEntityAlpha(vehicle, 255, false)
                                SetEntityInvincible(vehicle, false)
                                SetEntityNoCollisionEntity(vehicle, ped, true)
                                SetVehicleDoorsLocked(vehicle, 1)
                                TaskWarpPedIntoVehicle(ped, vehicle, -1)
                                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
                                table.insert(rentedEntities, vehicle)
                                VehicleRespawn(name, data)
                            else
                                QBCore.Functions.Notify("You don't have enough money.", "error")
                            end
                        end, data.price)
                    end,
                    canInteract = function()
                        for k,v in pairs(rentedEntities) do
                            if v == vehicle then
                                return false
                            end
                        end
                        return true
                    end
                }
            },
            distance = 1.2
        })
    end)
end

Citizen.CreateThread(function()
    local ped = PlayerPedId()
    for k,v in pairs(Vehicles) do
        local modelHash = GetHashKey(k)
        while not HasModelLoaded(modelHash) do
            RequestModel(modelHash)
            Wait(0)
        end
        local vehicle = CreateVehicle(modelHash, v.coords, true, true)
        SetEntityNoCollisionEntity(vehicle, ped, false)
        SetEntityAlpha(vehicle, 127, false)
        SetVehicleDoorsLocked(vehicle, 2)
        SetEntityInvincible(vehicle, true)
        exports['qb-target']:AddTargetEntity(vehicle, {
            options = {
                {
                    icon = "fas fa-car",
                    label = "Rent " .. k:gsub("^%l", string.upper) .. " for " .. v.price .. "$",
                    action = function()
                        QBCore.Functions.TriggerCallback("rk-rental:Rent", function(data)
                            if data then
                                SetEntityAlpha(vehicle, 255, false)
                                SetEntityInvincible(vehicle, false)
                                SetEntityNoCollisionEntity(vehicle, ped, true)
                                SetVehicleDoorsLocked(vehicle, 1)
                                TaskWarpPedIntoVehicle(ped, vehicle, -1)
                                TriggerEvent("vehiclekeys:client:SetOwner", GetVehicleNumberPlateText(vehicle))
                                table.insert(rentedEntities, vehicle)
                                VehicleRespawn(k, v)
                            else
                                QBCore.Functions.Notify("You don't have enough money.", "error")
                            end
                        end, v.price)
                    end,
                    canInteract = function()
                        for k,v in pairs(rentedEntities) do
                            if v == vehicle then
                                return false
                            end
                        end
                        return true
                    end
                }
            },
            distance = 1.2
        })
    end
end)