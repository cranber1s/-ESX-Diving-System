ESX = nil
local oxmysql = exports.oxmysql

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('diving:takeProp')
AddEventHandler('diving:takeProp', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    if xPlayer then
        for _, reward in ipairs(Config.RewardItems) do
            xPlayer.addInventoryItem(reward.item, reward.count)
        end
        TriggerClientEvent('esx:showNotification', source, 'You have collected the prop and received your reward.')
    end
end)