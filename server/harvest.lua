RegisterNetEvent('djdrugsv2:server:harvest', function(spotId, entityKey, propCoords)
    local src = source
    local spot = Server.FindHarvest(spotId)
    if not spot then return end

    if not Server.IsNearHarvestSpot(src, spot, entityKey, propCoords) then
        Server.Notify(src, 'Too far away', 'error')
        return
    end

    local cdKey = entityKey or spot.id
    local cooling, left = Server.OnCooldown(Server.harvestCooldown, src, cdKey, spot.cooldown or Config.IngredientCooldown or 10)
    if cooling then
        Server.Notify(src, ('Wait %s seconds'):format(left), 'error')
        return
    end

    local amount = Server.AmountFromConfig(spot.amount)
    local mult = Boost.GetHarvestMultiplier()
    if mult > 1 then
        amount = math.max(1, math.floor(amount * mult + 0.5))
    end
    if not Server.CanCarry(src, spot.item, amount) then
        Server.ClearCooldown(Server.harvestCooldown, src, cdKey)
        Server.Notify(src, 'You cannot carry that', 'error')
        return
    end

    if Server.AddItem(src, spot.item, amount) then
        local boostNote = mult > 1 and (' [%sx harvest boost]'):format(mult) or ''
        Server.Notify(src, ('Collected %sx %s%s'):format(amount, spot.item, boostNote), 'success')
    else
        Server.ClearCooldown(Server.harvestCooldown, src, cdKey)
        Server.Notify(src, 'Could not add item', 'error')
    end
end)
