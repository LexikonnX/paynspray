ESX = nil
TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

ESX.RegisterServerCallback("paynspray:fix", function(source, cb, money)
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer.getMoney() >= money then
        xPlayer.removeMoney(money)
        cb(true)
    else
        cb(false)
    end
end)