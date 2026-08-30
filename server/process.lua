lib.callback.register('djdrugsv2:server:canProcess', function(source, drugId)
    local drug = Utils.GetDrug(drugId)
    if not drug then return false end

    for i = 1, #drug.ingredients do
        local ing = drug.ingredients[i]
        if Server.ItemCount(source, ing.item) < ing.amount then
            return false
        end
    end
    return true
end)

RegisterNetEvent('djdrugsv2:server:process', function(drugId)
    local src = source
    local drug = Utils.GetDrug(drugId)
    if not drug or not drug.process then return end

    local p = drug.process
    if not Server.IsNearCoords(src, p.coords, 4.0) then
        Server.Notify(src, 'Too far from the bench', 'error')
        return
    end

    local cooling, left = Server.OnCooldown(Server.processCooldown, src, drugId, 3)
    if cooling then
        Server.Notify(src, ('Slow down (%ss)'):format(left), 'error')
        return
    end

    for i = 1, #drug.ingredients do
        local ing = drug.ingredients[i]
        if Server.ItemCount(src, ing.item) < ing.amount then
            Server.Notify(src, 'Missing ingredients', 'error')
            return
        end
    end

    local outItem = p.output.item or drug.item
    local outAmount = p.output.amount or 1
    if not Server.CanCarry(src, outItem, outAmount) then
        Server.Notify(src, 'You cannot carry the product', 'error')
        return
    end

    for i = 1, #drug.ingredients do
        local ing = drug.ingredients[i]
        if not Server.RemoveItem(src, ing.item, ing.amount) then
            Server.Notify(src, 'Failed to remove ingredients', 'error')
            return
        end
    end

    if Server.AddItem(src, outItem, outAmount) then
        Server.Notify(src, ('Processed %sx %s'):format(outAmount, drug.label), 'success')
    else
        for i = 1, #drug.ingredients do
            local ing = drug.ingredients[i]
            Server.AddItem(src, ing.item, ing.amount)
        end
        Server.Notify(src, 'Processing failed', 'error')
    end
end)
