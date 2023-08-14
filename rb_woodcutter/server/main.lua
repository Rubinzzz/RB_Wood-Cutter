ESX = nil
local PlayersTransforming, PlayersSelling, PlayersHarvesting = {}, {}, {}
local vine, jus = 1, 1

ESX = exports["es_extended"]:getSharedObject()

if Config.MaxInService ~= -1 then
	TriggerEvent('esx_service:activateService', 'woodcutter', Config.MaxInService)
end

TriggerEvent('esx_society:registerSociety', 'woodcutter', 'woodcutterron', 'society_woodcutter', 'society_woodcutter', 'society_woodcutter', {type = 'private'})
local function Harvest(source, zone)
	if PlayersHarvesting[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "Wood" then
			local itemQuantity = xPlayer.getInventoryItem('wood').count
			if itemQuantity >= 100 then
				exports['okokNotify']:Alert("Woodcut", "Nedostatek místa v inventáři", 2000, 'error')
				return
			else
				SetTimeout(2500, function()
					xPlayer.addInventoryItem('wood', 1)
					Harvest(source, zone)
				end)
			end
		end
	end
end

RegisterServerEvent('esx_woodcutterronjob:startHarvest')
AddEventHandler('esx_woodcutterronjob:startHarvest', function(zone)
	local _source = source
  	
	if PlayersHarvesting[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersHarvesting[_source]=false
	else
		PlayersHarvesting[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('raisin_taken'))  
		Harvest(_source,zone)
	end
end)

RegisterServerEvent('esx_woodcutterronjob:stopHarvest')
AddEventHandler('esx_woodcutterronjob:stopHarvest', function()
	local _source = source
	
	if PlayersHarvesting[_source] == true then
		PlayersHarvesting[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Opustil si ~r~zonu')
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~récolter')
		PlayersHarvesting[_source]=true
	end
end)

local function Transform(source, zone)

	if PlayersTransforming[source] == true then

		local xPlayer  = ESX.GetPlayerFromId(source)
		if zone == "Machining" then
			local itemQuantity = xPlayer.getInventoryItem('wood').count

			if itemQuantity <= 0 then
				exports['okokNotify']:Alert("Woodcut", "Nedostatek vína k přeprecování", 2000, 'error')
				return
			else
				local rand = math.random(0,100)
				if (rand >= 98) then
					SetTimeout(2800, function()
						xPlayer.removeInventoryItem('wood', 1)
						xPlayer.addInventoryItem('water', 1)
						xPlayer.showNotification(_U('add_watter'))
						Transform(source, zone)
					end)
				else
					SetTimeout(2800, function()
						xPlayer.removeInventoryItem('raisin', 1)
						xPlayer.addInventoryItem('vine', 1)
				
						Transform(source, zone)
					end)
				end
			end
		elseif zone == "Remodeler" then
			local itemQuantity = xPlayer.getInventoryItem('water').count
			if itemQuantity <= 0 then
				exports['okokNotify']:Alert("Woodcut", "Nedostatek vína k přeprecování", 2000, 'error')
				return
			else
				SetTimeout(2800, function()
					xPlayer.removeInventoryItem('wood', 1)
					xPlayer.addInventoryItem('water', 1)
		  
					Transform(source, zone)	  
				end)
			end
		end
	end	
end

RegisterServerEvent('esx_woodcutterronjob:startTransform')
AddEventHandler('esx_woodcutterronjob:startTransform', function(zone)
	local _source = source
  	
	if PlayersTransforming[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersTransforming[_source]=false
	else
		PlayersTransforming[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('transforming_in_progress')) 
		Transform(_source,zone)
	end
end)

RegisterServerEvent('esx_woodcutterronjob:stopTransform')
AddEventHandler('esx_woodcutterronjob:stopTransform', function()
	local _source = source
	
	if PlayersTransforming[_source] == true then
		PlayersTransforming[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~transformer votre raisin')
		PlayersTransforming[_source]=true
	end
end)

local function Sell(source, zone)

	if PlayersSelling[source] == true then
		local xPlayer  = ESX.GetPlayerFromId(source)
		
		if zone == 'SellFarm' then
			if xPlayer.getInventoryItem('wood').count <= 0 then
				wood = 0
			else
				wood = 1
			end
			
			if xPlayer.getInventoryItem('wood').count <= 0 then
				wood = 0
			else
				wood = 1
			end
		
			if vine == 0 and jus == 0 then
				exports['okokNotify']:Alert("Woodcut", "Nemáš žádný víno k prodeji", 2000, 'error')
				return
			elseif xPlayer.getInventoryItem('vine').count <= 0 and jus == 0 then
				exports['okokNotify']:Alert("Woodcut", "Nemáš žádný víno k prodeji", 2000, 'error')
				vine = 0
				return
			elseif xPlayer.getInventoryItem('jus_raisin').count <= 0 and vine == 0then
			exports['okokNotify']:Alert("Woodcut", "Nemáš žádný víno k prodeji", 2000, 'error')
				jus = 0
				return
			else
				if (jus == 1) then
					SetTimeout(1650, function()
						local money = math.random(500,1000)
						xPlayer.removeInventoryItem('wood', 1)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_woodcutter', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(money)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
						end
						Sell(source,zone)
					end)
				elseif (vine == 1) then
					SetTimeout(1650, function()
						local money = math.random(500,1000)
						xPlayer.removeInventoryItem('wood', 1)
						local societyAccount = nil

						TriggerEvent('esx_addonaccount:getSharedAccount', 'society_woodcutter', function(account)
							societyAccount = account
						end)
						if societyAccount ~= nil then
							societyAccount.addMoney(money)
							TriggerClientEvent('esx:showNotification', xPlayer.source, _U('comp_earned') .. money)
						end
						Sell(source,zone)
					end)
				end
			end
		end
	end
end

RegisterServerEvent('esx_woodcutterronjob:startSell')
AddEventHandler('esx_woodcutterronjob:startSell', function(zone)
	local _source = source

	if PlayersSelling[_source] == false then
		TriggerClientEvent('esx:showNotification', _source, '~r~C\'est pas bien de glitch ~w~')
		PlayersSelling[_source]=false
	else
		PlayersSelling[_source]=true
		TriggerClientEvent('esx:showNotification', _source, _U('sale_in_prog'))
		Sell(_source, zone)
	end
end)

RegisterServerEvent('esx_woodcutterronjob:stopSell')
AddEventHandler('esx_woodcutterronjob:stopSell', function()
	local _source = source
	
	if PlayersSelling[_source] == true then
		PlayersSelling[_source]=false
		TriggerClientEvent('esx:showNotification', _source, 'Vous sortez de la ~r~zone')
		
	else
		TriggerClientEvent('esx:showNotification', _source, 'Vous pouvez ~g~vendre')
		PlayersSelling[_source]=true
	end
end)

RegisterServerEvent('esx_woodcutterronjob:getStockItem')
AddEventHandler('esx_woodcutterronjob:getStockItem', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_woodcutter', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= count then
			inventory.removeItem(itemName, count)
			xPlayer.addInventoryItem(itemName, count)
		else
			exports['okokNotify']:Alert("Woodcut", "Neplatné množství", 2000, 'error')
		end

		xPlayer.showNotification(_U('have_withdrawn') .. count .. ' ' .. item.label)
	end)
end)

ESX.RegisterServerCallback('esx_woodcutterronjob:getStockItems', function(source, cb)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_woodcutter', function(inventory)
		cb(inventory.items)
	end)
end)

RegisterServerEvent('esx_woodcutterronjob:putStockItems')
AddEventHandler('esx_woodcutterronjob:putStockItems', function(itemName, count)
	local xPlayer = ESX.GetPlayerFromId(source)

	TriggerEvent('esx_addoninventory:getSharedInventory', 'society_woodcutter', function(inventory)
		local item = inventory.getItem(itemName)

		if item.count >= 0 then
			xPlayer.removeInventoryItem(itemName, count)
			inventory.addItem(itemName, count)
		else
			exports['okokNotify']:Alert("Woodcut", "Neplatné množství", 2000, 'error')
		end

		xPlayer.showNotification(_U('added') .. count .. ' ' .. item.label)
	end)
end)

ESX.RegisterServerCallback('esx_woodcutterronjob:getPlayerInventory', function(source, cb)
	local xPlayer    = ESX.GetPlayerFromId(source)
	local items      = xPlayer.inventory

	cb({
		items      = items
	})
end)