local GUI      = {}
GUI.Time       = 0
local Player = {}
Player.dentro = false
local menuAperto = false

RegisterNUICallback('chiudiBanca', function(data, cb)
    menuAperto = false
    SendNUIMessage({ apri = false })
    SetNuiFocus(false)
end)

RegisterNUICallback('richiedicarta', function(data, cb)
    TriggerServerEvent('Zeta_bank:richiedi_carta')
end)

RegisterNUICallback('preleva', function(data, cb)
    cb('preleva')
    TriggerServerEvent('Zeta_bank:Preleva', data.quantita)
    -- print(data.quantita) debug
    aggiornamov() 
end)

RegisterNUICallback('deposita', function(data, cb)
    cb('deposita')
    TriggerServerEvent('Zeta_bank:Deposita', data.quantita)
    -- print(data.quantita) debug
    aggiornamov() 
end)

RegisterNUICallback('bonifico', function(data, cb)
    cb('bonifico')
    TriggerServerEvent('Zeta_bank:Bonifico', data.quantita, data.id_giocatore)
    -- print(data.quantita, data.id_giocatore) debug
    aggiornamov() 
end)

RegisterNetEvent('Zeta_bank:RiceviMovimenti')
AddEventHandler('Zeta_bank:RiceviMovimenti', function(data)
    -- print('', json.encode(data)) debug
    SendNUIMessage({ movimenti = true, data = data })
end)

aggiornamov = function()
    local source = GetPlayerServerId(PlayerId())
    local bankMoney = lib.callback.await('Zeta_bank:saldobanca')
    TriggerServerEvent('Zeta_bank:GetMovimenti', source)
    SendNUIMessage({ soldi = lib.math.groupdigits(bankMoney, ',') })
end

Citizen.CreateThread(function()

	for k,v in pairs(Config.Posizioni) do
		local blip = AddBlipForCoord(v.Pos.x, v.Pos.y, v.Pos.z)

		SetBlipSprite (blip, v.Sprite)
		SetBlipDisplay(blip, v.Display)
		SetBlipScale  (blip, v.Scale)
		SetBlipColour (blip, v.Colour)
		SetBlipAsShortRange(blip, true)

		BeginTextCommandSetBlipName("STRING")
		AddTextComponentString(v.Label)
		EndTextCommandSetBlipName(blip)
	end

end)

CreateThread(function()
    while true do
        local coordinate = GetEntityCoords(PlayerPedId())
        local waitTime = 1000 
            for k, v in pairs(Config.Posizioni) do
                if v and v.Pos and #(coordinate - v.Pos) < 1.0 then 
                    waitTime = 0
                    if not menuAperto then
                        waitTime = 50
                        testo('Press [E] to interact with bank')
                        if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 0 then
                            menuAperto = true
                            if lib.progressBar({
                                duration = 1000,
                                label = 'Opening account...',
                                useWhileDead = false,
                                canCancel = true,
                                anim = {
                                    dict = 'amb@prop_human_atm@male@idle_a',
                                    clip = 'idle_c'
                                },
                            }) then end
                            SendNUIMessage({ apri = true })
                            SetNuiFocus(true, true)
                            aggiornamov()
                            TriggerEvent('Zeta_bank:RiceviMovimenti')
                        end
                    end
                end
            end

            for k, v in pairs(Config.PosizioniAtm) do
                if v and v.Pos and #(coordinate - v.Pos) < 1.0 then 
                    local item_carta = lib.callback.await('Zeta_bank:carta')
                    waitTime = 0
                    if not menuAperto then
                        testo('Press [E] to interact with atm')
                        if IsControlPressed(0, 38) and (GetGameTimer() - GUI.Time) > 0 then
                            if item_carta > 0 then 
                            menuAperto = true
                            if lib.progressBar({
                                duration = 1000,
                                label = 'Opening account...',
                                useWhileDead = false,
                                canCancel = true,
                                anim = {
                                    dict = 'amb@prop_human_atm@male@idle_a',
                                    clip = 'idle_c'
                                },
                            }) then end
                            SendNUIMessage({ atm = true })
                            SetNuiFocus(true, true)
                        else
                            TriggerEvent("pNotify:SendNotification", {
                                text = "You don't have a credit card.",
                                type = "success",
                                timeout = math.random(5000, 10000),
                                layout = "bottomRight",
                                queue = "right"
                            })
                        end
                    end
                end
            end
        end

            
        Citizen.Wait(waitTime)
    end
end)


testo = function(testo)
	SetTextComponentFormat("STRING")
	AddTextComponentString(testo)
	DisplayHelpTextFromStringLabel(0, 0, 1, -1)
end
