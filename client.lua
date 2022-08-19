local Locale = {
    ["PayNSpray"] = "Car repair",
    ["FixVehicle"] = "Repair for $",
    ["NoMoney"] = "No ~y~money~w~!",
    ["Fixed"] = "Fixed"
}
local paynspray = {
    {pos = vector3(731.93811, -1088.66113, 21.74439), blip = true, moneyMultiplier = 1.0},
    {pos = vector3(-369.711, -107.6735, 38.2568), blip = true, moneyMultiplier = 1.0},
}
local basicPrice = 10 --per one vehicle HP. Final price = basicPrice * moneyMultiplier * missing HP
-- For example:
-- Vehicle HP is 900/1000
-- moneyMultiplier = 1.5
-- basicPrice = $10
-- final price = $1500



----------------------------------------------------------------------------------------------------------------------------------------
ESX = nil

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end

    while ESX.GetPlayerData().job == nil do
        Citizen.Wait(0)
    end
end)

Citizen.CreateThread(function()
    Citizen.Wait(0)
    for i=1,#paynspray do
        if paynspray[i].blip == true then
            blip = AddBlipForCoord(paynspray[i].pos.x, paynspray[i].pos.y, paynspray[i].pos.z)
            SetBlipSprite(blip, 402)
            SetBlipScale(blip, 1.0)
            SetBlipColour(blip, 51)
            SetBlipAsShortRange(blip, true)
            BeginTextCommandSetBlipName("STRING")
            AddTextComponentString(Locale.PayNSpray)
            EndTextCommandSetBlipName(blip)
        end
    end
end)

CreateThread(function()
    while true do
        PlayerData = ESX.GetPlayerData()
        coords = GetEntityCoords(PlayerPedId())
        onFoot = IsPedOnFoot(PlayerPedId())
        Citizen.Wait(0)
    end
end)

CreateThread(function()
    while true do   
        Citizen.Wait(0)
        for i=1,#paynspray do
            local distance = #(coords-paynspray[i].pos)
            if distance <= 5 and not onFoot then
                local VehicleHP = GetVehicleBodyHealth(GetVehiclePedIsIn(PlayerPedId()))
                local needFix = 1000-VehicleHP
                local money = needFix*paynspray[i].moneyMultiplier*basicPrice
                money = split(money, ".")
                if VehicleHP ~= 1000.0 then
                    ESX.ShowHelpNotification("~INPUT_CONTEXT~ "..Locale.FixVehicle..money[1])
                    if IsControlJustReleased(0, 38) then
                        ESX.TriggerServerCallback("paynspray:fix", function(result)
                            if result == true then
                                DoScreenFadeOut(500)
                                Citizen.Wait(2000)
                                ESX.ShowNotification(Locale.Fixed)
                                SetVehicleFixed(GetVehiclePedIsIn(PlayerPedId()))
                                DoScreenFadeIn(500)
                            elseif result == false then
                                ESX.ShowNotification(Locale.NoMoney)
                            else
                                ESX.ShowNotification("Error")
                            end
                        end, tonumber(money[1]))
                    end
                end
            end
        end
    end
end)

function split(inputstr, sep)
        if sep == nil then
                sep = "%s"
        end
        local t={}
        for str in string.gmatch(inputstr, "([^"..sep.."]+)") do
                table.insert(t, str)
        end
        return t
end
