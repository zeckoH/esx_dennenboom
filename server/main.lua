local rob = false
local robbers = {}
ESX = nil

TriggerEvent('esx:getSharedObject', function(obj) ESX = obj end)

RegisterServerEvent('esx_holdup:tooFar')
AddEventHandler('esx_holdup:tooFar', function(currentStore)
	local _source = source
	local xPlayers = ESX.GetPlayers()
	rob = false

	for i=1, #xPlayers, 1 do
		local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
		
		if xPlayer.job.name == 'police' then
			TriggerClientEvent('okokNotify:Alert', xPlayers[i], 'Winkel Overval', 'De overval is gestopt!', 10000, 'error')
			TriggerClientEvent('esx_holdup:killBlip', xPlayers[i])
		end
	end

	if robbers[_source] then
		TriggerClientEvent('esx_holdup:tooFar', _source)
		robbers[_source] = nil
		TriggerClientEvent('okokNotify:Alert', _source, 'Winkel Overval', 'Je bent te ver weg, overval geannuleerd!', 10000, 'error')
	end
end)

RegisterServerEvent('esx_holdup:robberyStarted')
AddEventHandler('esx_holdup:robberyStarted', function(currentStore)
	local _source  = source
	local xPlayer  = ESX.GetPlayerFromId(_source)
	local xPlayers = ESX.GetPlayers()

	if Stores[currentStore] then
		local store = Stores[currentStore]

		if (os.time() - store.lastRobbed) < Config.TimerBeforeNewRob and store.lastRobbed ~= 0 then
			TriggerClientEvent('okokNotify:Alert', _source, 'Winkel Overval', 'De kassa is leeg, kom later terug.', 10000, 'info')
			return
		end

		local cops = 0
		for i=1, #xPlayers, 1 do
			local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
			if xPlayer.job.name == 'police' then
				cops = cops + 1
			end
		end

		if not rob then
			if cops >= Config.PoliceNumberRequired then
				rob = true

				for i=1, #xPlayers, 1 do
					local xPlayer = ESX.GetPlayerFromId(xPlayers[i])
					if xPlayer.job.name == 'police' then
						TriggerClientEvent('okokNotify:Alert', xPlayers[i], 'Winkel Overval - Mirrorpark', 'De winkel wordt overvallen!<br><br>Druk op <b>Z</b> om je navigatie in te stellen.', 20000, 'error')
						TriggerClientEvent('esx_holdup:setBlip', xPlayers[i], Stores[currentStore].position)
					end
				end

				TriggerClientEvent('esx:showNotification', _source, _U('started_to_rob', store.nameOfStore))
				TriggerClientEvent('okokNotify:Alert', _source, 'Winkel Overval',  'Het alarm is afgegaan.', 10000, 'warning')
				
				TriggerClientEvent('esx_holdup:currentlyRobbing', _source, currentStore)
				TriggerClientEvent('esx_holdup:startTimer', _source)
				
				Stores[currentStore].lastRobbed = os.time()
				robbers[_source] = currentStore

				SetTimeout(store.secondsRemaining * 1000, function()
					if robbers[_source] then
						rob = false
						if xPlayer then
							TriggerClientEvent('esx_holdup:robberyComplete', _source, store.reward)
							TriggerClientEvent('okokNotify:Alert', _source, 'Winkel Overval', 'De kassa & kluis zijn leeg, boek em snel!', 10000, 'success')

							if Config.GiveBlackMoney then
								xPlayer.addAccountMoney('black_money', store.reward)
								xPlayer.addInventoryItem('bread', 5)
								xPlayer.addInventoryItem('water', 5)
								if math.random(1,5) == 1 then 
									xPlayer.addInventoryItem('repairkit', 2)
								end
							else
								xPlayer.addMoney(store.reward)
							end
							
							local xPlayers, xPlayer = ESX.GetPlayers(), nil
							for i=1, #xPlayers, 1 do
								xPlayer = ESX.GetPlayerFromId(xPlayers[i])

								if xPlayer.job.name == 'police' then
									TriggerClientEvent('okokNotify:Alert', xPlayers[i], 'Winkel Overval', 'De overval is gesladag.', 10000, 'success')
									TriggerClientEvent('esx_holdup:killBlip', xPlayers[i])
								end
							end
						end
					end
				end)
			else
				TriggerClientEvent('okokNotify:Alert', _source, 'Winkel Overval', 'Er is niet genoeg politie in de stad!', 10000, 'error')
			end
		else
			TriggerClientEvent('esx:showNotification', _source, _U('robbery_already'))
		end
	end
end)
