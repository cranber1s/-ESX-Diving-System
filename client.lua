ESX = nil
local isWearingDivingSuit = false
local oxygenTimer = 0

Citizen.CreateThread(function()
    while ESX == nil do
        TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)
        Citizen.Wait(0)
    end
end)

RegisterNetEvent('diving:useDivingSuit')
AddEventHandler('diving:useDivingSuit', function()
    if not isWearingDivingSuit then
        isWearingDivingSuit = true
        oxygenTimer = Config.OxygenTankDuration
        ESX.ShowNotification('You have put on the diving suit. Oxygen tank activated.')
    else
        isWearingDivingSuit = false
        ESX.ShowNotification('You have taken off the diving suit.')
    end
end)

Citizen.CreateThread(function()
    while true do
        Citizen.Wait(1000)
        if isWearingDivingSuit and oxygenTimer > 0 then
            oxygenTimer = oxygenTimer - 1
            if oxygenTimer == 0 then
                ESX.ShowNotification('Your oxygen tank is empty!')
                -- Handle oxygen depletion (e.g., damage the player)
            end
        end
    end
end)

Citizen.CreateThread(function()
    for _, propData in ipairs(Config.Props) do
        local prop = CreateObject(GetHashKey(propData.prop), propData.coords.x, propData.coords.y, propData.coords.z, false, false, false)
        PlaceObjectOnGroundProperly(prop)
        SetEntityAsMissionEntity(prop, true, true)
    end
    
    exports.ox_target:addSphereZone({
        coords = Config.DivingLocation,
        radius = 5.0,
        debug = false,
        options = {
            {
                name = 'take_prop',
                label = 'Press ALT to take prop',
                icon = 'fa-solid fa-box',
                onSelect = function()
                    TriggerServerEvent('diving:takeProp')
                end
            }
        }
    })
end)