local function GetArmor(vehicle)
    local armorMenu = { { header = 'Armor', isMenuHeader = true, icon = 'fas fa-shield' } }
    for i = -1, GetNumVehicleMods(vehicle, 16) - 1 do
        local header = Lang:t('menu.armor') .. ': ' .. (i >= 0 and i or Lang:t('menu.stock'))
        local disabled = GetVehicleMod(vehicle, 16) == i
        local armorItem = {
            header = header,
            disabled = disabled,
            params = {
                event = 'qb-mechanicjob:client:install',
                args = {
                    upgradeType = 'armor',
                    modType = 16,
                    upgradeIndex = i,
                    vehicle = vehicle
                }
            }
        }
        armorMenu[#armorMenu + 1] = armorItem
    end
    exports['qb-menu']:openMenu(armorMenu, true)
end

local function GetBrakes(vehicle)
    local brakesMenu = { { header = 'Brakes', isMenuHeader = true, icon = 'fas fa-car' } }
    for i = -1, GetNumVehicleMods(vehicle, 12) - 1 do
        local header = Lang:t('menu.brakes') .. ': ' .. (i >= 0 and i or Lang:t('menu.stock'))
        local disabled = GetVehicleMod(vehicle, 12) == i
        local brakesItem = {
            header = header,
            disabled = disabled,
            params = {
                event = 'qb-mechanicjob:client:install',
                args = {
                    upgradeType = 'brakes',
                    modType = 12,
                    upgradeIndex = i,
                    vehicle = vehicle
                }
            }
        }
        brakesMenu[#brakesMenu + 1] = brakesItem
    end
    exports['qb-menu']:openMenu(brakesMenu, true)
end

local function GetEngine(vehicle)
    local engineMenu = { { header = 'Engine', isMenuHeader = true, icon = 'fas fa-oil-can' } }
    for i = -1, GetNumVehicleMods(vehicle, 11) - 1 do
        local header = Lang:t('menu.engine') .. ': ' .. (i >= 0 and i or Lang:t('menu.stock'))
        local disabled = GetVehicleMod(vehicle, 11) == i
        local engineItem = {
            header = header,
            disabled = disabled,
            params = {
                event = 'qb-mechanicjob:client:install',
                args = {
                    upgradeType = 'engine',
                    modType = 11,
                    upgradeIndex = i,
                    vehicle = vehicle
                }
            }
        }
        engineMenu[#engineMenu + 1] = engineItem
    end
    exports['qb-menu']:openMenu(engineMenu, true)
end

local function GetSuspension(vehicle)
    local suspensionMenu = { { header = 'Suspension', isMenuHeader = true, icon = 'fas fa-car' } }
    for i = -1, GetNumVehicleMods(vehicle, 15) - 1 do
        local header = Lang:t('menu.suspension') .. ': ' .. (i >= 0 and i or Lang:t('menu.stock'))
        local disabled = GetVehicleMod(vehicle, 15) == i
        local suspensionItem = {
            header = header,
            disabled = disabled,
            params = {
                event = 'qb-mechanicjob:client:install',
                args = {
                    upgradeType = 'suspension',
                    modType = 15,
                    upgradeIndex = i,
                    vehicle = vehicle
                }
            }
        }
        suspensionMenu[#suspensionMenu + 1] = suspensionItem
    end
    exports['qb-menu']:openMenu(suspensionMenu, true)
end

local function GetTransmission(vehicle)
    local transmissionMenu = { { header = 'Transmission', isMenuHeader = true, icon = 'fas fa-oil-can' } }
    for i = -1, GetNumVehicleMods(vehicle, 13) - 1 do
        local header = Lang:t('menu.transmission') .. ': ' .. (i >= 0 and i or Lang:t('menu.stock'))
        local disabled = GetVehicleMod(vehicle, 13) == i
        local transmissionItem = {
            header = header,
            disabled = disabled,
            params = {
                event = 'qb-mechanicjob:client:install',
                args = {
                    upgradeType = 'transmission',
                    modType = 13,
                    upgradeIndex = i,
                    vehicle = vehicle
                }
            }
        }
        transmissionMenu[#transmissionMenu + 1] = transmissionItem
    end
    exports['qb-menu']:openMenu(transmissionMenu, true)
end

local function GetTurbo(vehicle)
    local turboMenu = { { header = Lang:t('menu.turbo'), isMenuHeader = true, icon = 'fas fa-bolt' } }
    local txt = Lang:t('menu.install_turbo')
    local turbo = IsToggleModOn(vehicle, 18)
    if turbo then txt = Lang:t('menu.uninstall_turbo') end
    local turboItem = {
        header = Lang:t('menu.turbo'),
        txt = txt,
        params = {
            event = 'qb-mechanicjob:client:install',
            args = {
                upgradeType = 'turbo',
                turbo = turbo,
                vehicle = vehicle
            }
        }
    }
    turboMenu[#turboMenu + 1] = turboItem
    exports['qb-menu']:openMenu(turboMenu, true)
end

-- Events
local allItems = exports.ox_inventory:Items()
RegisterNetEvent('qb-mechanicjob:client:install', function(data)
    local upgradeIndex = data.upgradeIndex
    local modType = data.modType
    local partName = data.upgradeType

    -- Allow different level of upgrades (e.g. veh_armor, veh_armor1)
    local itemName = 'veh_' .. partName .. (( upgradeIndex == 0 or upgradeIndex == -1 or upgradeIndex == nil) and '' or upgradeIndex)
    local item = exports.ox_inventory:Search('count', itemName)
    if item == 0 then
        QBCore.Functions.Notify('You don\'t have ' .. allItems[itemName].label .. ' to do this install.')
        return
    end

    local animDict = 'mini@repair'
    local anim = 'fixing_a_player'
    local shouldToggleHood = false
    if partName == 'engine' or partName == 'transmission' or partName == 'turbo' then
        shouldToggleHood = true
    elseif partName == 'armor' or partName == 'brakes' or partName == 'suspension' then
        animDict = 'anim@amb@clubhouse@tutorial@bkr_tut_ig3@'
        anim = 'machinic_loop_mechandplayer'
    end
    QBCore.Functions.Progressbar('mechanic_install', string.format(Lang:t('progress.installing'), partName), 5000, false, true, {
        disableMovement = true,
        disableCarMovement = true,
        disableMouse = false,
        disableCombat = true,
    }, {
        animDict = animDict,
        anim = anim,
        flags = 1,
    }, {
        model = 'imp_prop_impexp_span_03',
        bone = 28422,
        coords = vec3(0.06, 0.01, -0.02),
        rotation = vec3(0.0, 0.0, 0.0),
    }, {}, function()
        if partName == 'turbo' then
            ToggleVehicleMod(data.vehicle, 18, not data.turbo)
        else
            SetVehicleMod(data.vehicle, modType, upgradeIndex, false)
        end
        if shouldToggleHood then ToggleHood(data.vehicle) end
        TriggerServerEvent('qb-mechanicjob:server:removeItem', itemName)
        QBCore.Functions.Notify(string.format(Lang:t('success.installed'), allItems[itemName].label), 'success')
    end, function()
        if shouldToggleHood then ToggleHood(data.vehicle) end
    end)
end)

local function isVehArmor(item)
    return item == 'veh_armor' or item == 'veh_armor1' or item == 'veh_armor2' or
           item == 'veh_armor3' or item == 'veh_armor4'
end

local function isVehBrakes(item)
    return item == 'veh_brakes' or item == 'veh_brakes1' or
           item == 'veh_brakes2' or item == 'veh_brakes3'
end

local function isVehSuspension(item)
    return item == 'veh_suspension' or item == 'veh_suspension1' or item == 'veh_suspension2' or
           item == 'veh_suspension3' or item == 'veh_suspension4'
end

local function isVehEngine(item)
    return item == 'veh_engine' or item == 'veh_engine1' or item == 'veh_engine2' or
           item == 'veh_engine3' or item == 'veh_engine4'
end

local function isVehTransmission(item)
    return item == 'veh_transmission' or item == 'veh_transmission1' or
           item == 'veh_transmission2' or item == 'veh_transmission3'
end

RegisterNetEvent('qb-mechanicjob:client:installPart', function(item)
    local vehicle, distance = QBCore.Functions.GetClosestVehicle()
    if vehicle == 0 or distance > 5.0 then return end
    if GetVehicleModKit(vehicle) ~= 0 then SetVehicleModKit(vehicle, 0) end
    if isVehArmor(item) or isVehBrakes(item) or isVehSuspension(item) then
        if GetClosestWheel(vehicle) == -1 then return end
        if isVehArmor(item) then GetArmor(vehicle) end
        if isVehBrakes(item) then GetBrakes(vehicle) end
        if isVehSuspension(item) then GetSuspension(vehicle) end
    elseif isVehEngine(item) or isVehTransmission(item) or item == 'veh_turbo' then
        if IsPedInAnyVehicle(PlayerPedId(), false) then return end
        if not IsNearBone(vehicle, 'engine') then return end
        if GetVehicleDoorAngleRatio(vehicle, 4) <= 0.0 then SetVehicleDoorOpen(vehicle, 4, false, false) end
        if isVehEngine(item) then GetEngine(vehicle) end
        if isVehTransmission(item) then GetTransmission(vehicle) end
        if item == 'veh_turbo' then GetTurbo(vehicle) end
    end
end)
