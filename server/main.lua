RegisterServerEvent('Zeta_bank:RegistraMovimento')
AddEventHandler('Zeta_bank:RegistraMovimento', function(identifier, type, amount)
    MySQL.Async.execute(
        'INSERT INTO zeta_bank (identifier, type, amount) VALUES (@identifier, @type, @amount)',
        {
            ['@identifier'] = identifier,
            ['@type'] = type,
            ['@amount'] = amount
        },
        function(mov)
        end
    )
end)

RegisterServerEvent('Zeta_bank:GetMovimenti')
AddEventHandler('Zeta_bank:GetMovimenti', function(source)
    local xPlayer = ESX.GetPlayerFromId(source)
    local identifier = xPlayer.identifier

    MySQL.Async.fetchAll(
        'SELECT * FROM Zeta_bank WHERE identifier = @identifier ORDER BY timestamp DESC LIMIT 10',
        {
            ['@identifier'] = identifier
        },
        function(result)
            -- print('Received data from server:', json.encode(result))
            TriggerClientEvent('Zeta_bank:RiceviMovimenti', source, result)
        end
    )
end)    

RegisterServerEvent('Zeta_bank:richiedi_carta')
AddEventHandler('Zeta_bank:richiedi_carta',function() 
    local xPlayer = ESX.GetPlayerFromId(source)
    local get_carta = xPlayer.getInventoryItem('cartadicredito').count
    if get_carta == 0 then 
        xPlayer.addInventoryItem('cartadicredito', 1)
        TriggerClientEvent("pNotify:SendNotification", -1, {
            text = "You have received credit card",
            type = "success",
            queue = "lmao",
            timeout = 3000,
            layout = "bottomRight"
        })
    else
        TriggerClientEvent("pNotify:SendNotification", -1, {
            text = "You already have a credit card",
            type = "success",
            queue = "lmao",
            timeout = 3000,
            layout = "bottomRight"
        })
    end
end)

RegisterServerEvent('Zeta_bank:Preleva')
AddEventHandler('Zeta_bank:Preleva', function(amount)
	local xPlayer = ESX.GetPlayerFromId(source)
    local timestamp = os.time()
    local SoldiBanca = xPlayer.getAccount('bank').money
    local amount = tonumber(amount)
    if amount == nil or amount <= 0 or amount > SoldiBanca then
        TriggerClientEvent("pNotify:SendNotification", -1, {
            text = "You do not have enough money!",
            type = "success",
            queue = "lmao",
            timeout = 3000,
            layout = "bottomRight"
        })
    else
        xPlayer.removeAccountMoney("bank", amount) 
        xPlayer.addAccountMoney('money', amount)    
        TriggerEvent('Zeta_bank:RegistraMovimento', xPlayer.identifier, 'withdraw', amount, timestamp)
        TriggerClientEvent("pNotify:SendNotification", -1, {
            text = "You Withdraw " .. amount .. '$',
            type = "success",
            queue = "lmao",
            timeout = 3000,
            layout = "bottomRight"
        })
    end
end)

RegisterServerEvent('Zeta_bank:Deposita')
AddEventHandler('Zeta_bank:Deposita', function(amount)
	local xPlayer = ESX.GetPlayerFromId(source)
    print(amount)
    local SoldiContanti = xPlayer.getAccount('money').money
    local amount = tonumber(amount)
    local timestamp = os.time()
    if amount == nil or amount <= 0 or amount > SoldiContanti then
        TriggerClientEvent("pNotify:SendNotification", -1, {
            text = "You do not have enough money!",
            type = "success",
            queue = "lmao",
            timeout = 3000,
            layout = "bottomRight"
        })
    else
        xPlayer.removeAccountMoney("money", amount) 
        xPlayer.addAccountMoney('bank', amount)    
        TriggerEvent('Zeta_bank:RegistraMovimento', xPlayer.identifier, 'deposited', amount, timestamp)
        TriggerClientEvent("pNotify:SendNotification", -1, {
            text = "You Deposited " .. amount .. '$',
            type = "success",
            queue = "lmao",
            timeout = 3000,
            layout = "bottomRight"
        })
    end
end)

RegisterServerEvent('Zeta_bank:Bonifico')
AddEventHandler('Zeta_bank:Bonifico', function(quantita, id)
    local xPlayer = ESX.GetPlayerFromId(source)
    local targetid = ESX.GetPlayerFromId(id)
    
    print(targetid, quantita)
    
    local SoldiBanca = xPlayer.getAccount('bank').money
    local quantita = tonumber(quantita)
    local timestamp = os.time()
    if id == nil or id == '' then
        TriggerClientEvent("pNotify:SendNotification", source, {
            text = "Enter the target player ID!",
            type = "success",
            queue = "lmao",
            timeout = 3000,
            layout = "bottomRight"
        })
    elseif not targetid then
        TriggerClientEvent("pNotify:SendNotification", source, {
            text = "The target player does not exist",
            type = "success",
            queue = "lmao",
            timeout = 3000,
            layout = "bottomRight"
        })
    else
        if quantita == nil or quantita <= 0 or quantita > SoldiBanca then
            TriggerClientEvent("pNotify:SendNotification", source, {
                text = "You do not have enough money! or you didn't enter the quantity",
                type = "success",
                queue = "lmao",
                timeout = 3000,
                layout = "bottomRight"
            })
        else
            xPlayer.removeAccountMoney("bank", quantita) 
            targetid.addAccountMoney('bank', quantita)    
            TriggerEvent('Zeta_bank:RegistraMovimento', xPlayer.identifier, 'transfer', quantita, timestamp)
            TriggerClientEvent("pNotify:SendNotification", -1, {
                text = "You made a transfer to the player with ID: " .. id .. ' di $ ' .. quantita,
                type = "success",
                queue = "lmao",
                timeout = 3000,
                layout = "bottomRight"
            })
        end
    end
end)

lib.callback.register('Zeta_bank:saldobanca', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local bankMoney = xPlayer.getAccount('bank').money
    return bankMoney or 0
end)

lib.callback.register('Zeta_bank:carta', function()
    local xPlayer = ESX.GetPlayerFromId(source)
    local valore_carta = xPlayer.getInventoryItem('cartadicredito').count
    return valore_carta
end)


