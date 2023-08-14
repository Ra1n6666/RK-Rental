local QBCore = exports['qb-core']:GetCoreObject()

QBCore.Functions.CreateCallback("rk-rental:Rent", function(source, cb, args)
    local price = args
    local Player = QBCore.Functions.GetPlayer(source)
    if Player.Functions.GetMoney("bank") >= price then
        Player.Functions.RemoveMoney("bank", price, "Rented a vehicle.")
        cb(true)
        return
    elseif Player.Functions.GetMoney("cash") >= price then
        Player.Functions.RemoveMoney("cash", price, "Rented a vehicle.")
        cb(true)
        return
    end

    cb(false)
    return
end)