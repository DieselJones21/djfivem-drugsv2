# Operator guide — The 305 drug system

This is how to run the live economy. Player-facing help is `/drughelp`. Coordinates and recipes are in `install/LOCATIONS.md`.

## What players do

1. Sell product with `/trap` to rank up. Locked drugs stay hidden.
2. Civ weed fields, the zip-bag ped, and both weed benches are already blipped. Pay **Street Intel** (`-1234.80, -1476.40, 4.32`) **$75k cash per other mark**. 1 hour cooldown.
3. After they buy every hidden mark their rank can use, they can buy the rest of the book at $75k each.
4. Collect: **E** on weed plants (they die, another grows in 45–90s). **E** on sidewalk peds for every other ingredient.
5. Cook: **E** on the bench. Weed table or coke table. No personal tables.
6. Sell: `/trap` or `/drugbulksell`. Vice Lace +35%. 35% chance a buyer snitches (Wasabi MDT, ps-dispatch fallback).

## Install

```cfg
add_ace group.admin djdrugsv2.boost allow
setr djdrugsv2_boost_webhook "https://discord.com/api/webhooks/...."
ensure ox_target
ensure interact
ensure wasabi_mdt
ensure ps-dispatch
ensure djfivem-drugsv2
```

1. Merge `install/ox_inventory_items.lua` into `ox_inventory/data/items.lua`
2. Copy `install/images/*.png` into `ox_inventory/web/images/`
3. Resource folder for Wasabi **must** be named `wasabi_mdt`
4. Live server folder can be named `djfivem-drugs`

## Discord boosts

`/drugboost` queues a city event:

1. **15 minute warning** in-game and in the Discord channel
2. **LIVE** announce when it starts
3. **15 minute warning** before it ends (if the duration is longer than 15 minutes)
4. Ended announce

Boost Discord is already set in `Config.Boost.discordWebhook`. A non-empty `djdrugsv2_boost_webhook` convar still overrides it.

## Ranks

Beach Runner (0) → Vice Hustler (250) → Ocean Plug (800) → Port Boss (2000) → 305 Kingpin (4500)

Personal drugs were removed. Every recipe sits on that ladder.

## Inventory icons

`install/images/*.png` are photoreal product stills with transparent backgrounds. Copy them over any old outline or Rebel stills.
