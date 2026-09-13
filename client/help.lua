local function rankLine()
    local sold = Client.rankSold or 0
    local rank = Utils.GetRankForSold(sold)
    local nxt = Utils.GetNextRank(sold)
    if nxt then
        return ('%s  ·  %s sold  ·  %s more to %s'):format(
            rank.label,
            Utils.FormatNumber(sold),
            Utils.FormatNumber(nxt.sold - sold),
            nxt.label
        )
    end
    return ('%s  ·  %s sold  ·  max rank'):format(rank.label, Utils.FormatNumber(sold))
end

local function recipeLine(drug)
    local parts = {}
    for i = 1, #drug.ingredients do
        parts[#parts + 1] = ('%sx %s'):format(drug.ingredients[i].amount, drug.ingredients[i].item)
    end
    return table.concat(parts, ' + ')
end

local function openRecipes()
    local sold = Client.rankSold or 0
    local options = {}
    local ids = Utils.GetSellableDrugs()
    for i = 1, #ids do
        local id = ids[i]
        local drug = Utils.GetDrug(id)
        local unlocked = Utils.CanAccessDrug(sold, id)
        if unlocked then
            options[#options + 1] = {
                title = ('%s  ·  Rank %s'):format(drug.label, Utils.GetDrugMinLevel(drug)),
                description = ('%s  →  %sx  ·  %s–%s'):format(
                    recipeLine(drug),
                    drug.process.output.amount,
                    Utils.FormatMoney(drug.sell.minPrice),
                    Utils.FormatMoney(drug.sell.maxPrice)
                ),
                icon = 'flask',
            }
        else
            options[#options + 1] = {
                title = '????',
                description = ('Locked until rank %s'):format(Utils.GetDrugMinLevel(drug)),
                icon = 'lock',
                disabled = true,
            }
        end
    end
    lib.registerContext({
        id = 'djdrugsv2_help_recipes',
        title = 'Recipes you can see',
        menu = 'djdrugsv2_help',
        options = options,
    })
    lib.showContext('djdrugsv2_help_recipes')
end

local function openHelp()
    Client.SyncRank()
    lib.registerContext({
        id = 'djdrugsv2_help',
        title = 'Rebel Drug Desk',
        options = {
            {
                title = rankLine(),
                icon = 'user',
                description = 'Sell finished product to rank up. New drugs stay hidden until that rank.',
            },
            {
                title = 'How it works',
                icon = 'book',
                description = 'Weed plants are fields. Everything else is a sidewalk ped (E). Cook on a bench. Sell with /trap.',
                onSelect = function()
                    lib.registerContext({
                        id = 'djdrugsv2_help_how',
                        title = 'How it works',
                        menu = 'djdrugsv2_help',
                        options = {
                            { title = '1. Rank', description = 'Prospect starts weed + lean. Each rank unlocks hidden drugs.', icon = '1' },
                            { title = '2. Find marks', description = 'Pay the Street Intel ped for one GPS mark. 1 hour cooldown. After every mark, buy the full book.', icon = '2' },
                            { title = '3. Collect', description = 'E on weed plants (they die and grow back). E on ingredient peds for supplies.', icon = '3' },
                            { title = '4. Cook', description = 'Weed table, personal table, or coke table. Must have the recipe items and the rank.', icon = '4' },
                            { title = '5. Sell', description = '/trap 3rd-eyes a buyer. /drugbulksell for 100–200 unit drops. Street Lace +35%.', icon = '5' },
                            { title = '6. Boosts', description = 'Admins run /drugboost. City + Discord get a 15 minute warning, then LIVE.', icon = '6' },
                        },
                    })
                    lib.showContext('djdrugsv2_help_how')
                end,
            },
            {
                title = 'Recipes',
                icon = 'list',
                description = 'Unlocked recipes only. Locked drugs stay hidden.',
                onSelect = openRecipes,
            },
            {
                title = 'Commands',
                icon = 'terminal',
                description = '/trap  /drugbulksell  /drugboard  /drughelp  /drugboost (admin)',
            },
        },
    })
    lib.showContext('djdrugsv2_help')
end

CreateThread(function()
    Wait(600)
    local cmd = (Config.Help and Config.Help.command) or 'drughelp'
    RegisterCommand(cmd, openHelp, false)
    TriggerEvent('chat:addSuggestion', '/' .. cmd, (Config.Help and Config.Help.description) or 'Drug system help')
end)
