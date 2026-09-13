# Operator guide — Rebel drug system

This is how to run the live economy. Player-facing help is `/drughelp`. Coordinates and recipes are in `install/LOCATIONS.md`.

## What players do

1. Sell product with `/trap` to rank up. Locked drugs stay hidden.
2. Civ weed fields, the zip-bag ped, and both weed benches are already blipped. Pay **Street Intel** (`455.18, -1530.55, 29.28`) **$75k cash per other mark**. 1 hour cooldown.
3. After they buy every hidden mark their rank can use, they can buy the rest of the book at $75k each.
4. Collect: **E** on weed plants (they die, another grows in 45–90s). **E** on sidewalk peds for every other ingredient.
5. Cook: **E** on the bench. Weed table / coke table / personal table.
6. Sell: `/trap` or `/drugbulksell`. Street Lace +35%. 35% chance a buyer snitches (Wasabi MDT, ps-dispatch fallback).

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
4. Do not overwrite Envy items if both resources run

## Discord boosts

`/drugboost` queues a city event:

1. **15 minute warning** in-game and in the Discord channel
2. **LIVE** announce when it starts
3. **15 minute warning** before it ends (if the duration is longer than 15 minutes)
4. Ended announce

Paste the webhook in `Config.Boost.discordWebhook` or use the convar above. Empty webhook = in-game only.

Leave `Config.Boost.warningSeconds = 0` if you want an instant start with no lead-in.

## Rank gates

Edit `minLevel` on each drug in `config/drugs.lua`. Harvest peds and benches for a locked drug do not spawn. `/drughelp` shows `????` for locked recipes.

## Tuning

| Knob | File | Notes |
|------|------|-------|
| Street prices | `config/drugs.lua` `sell.minPrice` / `maxPrice` | Bulk pays 55% of min |
| Recipes | `config/drugs.lua` `ingredients` + `process.output` | Output must stay ≥ ingredient total |
| Ped / field coords | `config/config.lua` `Config.Harvest` | One ped per non-weed item |
| Bench coords | `config/drugs.lua` `process.coords` | Client snaps to floor |
| Informant price / cooldown | `Config.Informant` | $75k per mark / 3600s |
| Weed grow-back | `Config.WeedRespawn` | 45–90 seconds |
| Snitch chance | `Config.Dispatch.chance` | 35% street, 15% bulk |
| Boost lead-in | `Config.Boost.warningSeconds` | 15 minutes |

## Why peds instead of props

Non-weed harvest used scattered props. Missing stream or collision meant the loop died. Each ingredient is now one local ped on interact, snapped to ground. Weed stays as `prop_weed_01` fields so plants still get picked and grow back.

## Support checks

- `lua tests/run_tests.lua` — config, recipes, ranks, benches, informant
- If a ped is in the air, the client ground-snap failed for that coord; move the vec3 down to sidewalk height
- If interact does nothing, `ensure interact` before this resource
- Street buyers still need `ox_target` (3rd eye)
