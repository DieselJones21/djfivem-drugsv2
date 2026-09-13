# djfivem-drugsv2 — Rebel Roleplay

Outlaw drug economy for FiveM (QBX + ox_inventory) branded for **Rebel Roleplay**. Weed plants still grow and die in the field. Every other ingredient is one sidewalk ped. Cooks happen on benches. Sell via `/trap`. `/drughelp` is the in-game book. Full coords and recipes: `install/LOCATIONS.md`. Operator runbook: `install/OPERATOR_GUIDE.md`.

This is a **branched version** of the Envy Roleplay set. Envy stays on `main` / Envy PRs. Rebel uses new item IDs, harvest fields, cook NPCs, and NUI so both can exist without overwriting each other.

## Features

- **10 Rebel county drugs** plus a Cayo Perico exclusive
- **Custom NUI** for leaderboard (`/drugboard`), boost admin (`/drugboost`), street deals, and bulk-drop HUD
- **Weed fields still grow** — pick a plant, it despawns, another grows in 45–90s
- **Every other ingredient is one sidewalk ped** (E / interact), snapped to the floor — no missing-prop dead spots
- **Process benches** — weed table, coke table, or personal table (`v_ret_ml_tableb`)
- **Hidden rank gates** — Prospect → Kingpin. Next rank unlocks more drugs; locked ones stay hidden
- **Street Intel ped** — $25k for one GPS mark, 1 hour cooldown, then $175k for the full book
- **Unique recipes** and rebalanced street pay
- **`/drughelp`** in-game operator book
- **Boost Discord** — 15 minute warning, LIVE announce, 15 minute ending warning
- **Street Lace** — La Puerta ped. 1 lace per unit sold on `/trap` or bulk for **+35%**
- **`/drugbulksell`** — 100–200 unit warehouse drops at ~55% of street min price, random location from a pool of 10
- **35% bad-sale snitch** on street traps (15% on bulk drops) that creates a Wasabi MDT / dispatch call (`10-66 Drug Sale`). Falls back to ps-dispatch if Wasabi is not started
- **Ground-snapped props** on harvest spots
- **Sell ranks & leaderboard** (Prospect → Outlaw → Road Captain → Shot Caller → Rebel Kingpin)
- **Admin boost events** (2x/3x/4x sell + harvest) with Discord + city warnings
- **Anti-exploit** server validation (proximity to the configured pool, cooldowns, token-based sales)
- **Crazier use effects** — sprint capped at 1.49, heavier armor, screen FX on the full set

## Drugs

| Drug | Rank | Pay | Effects |
|------|------|-----|---------|
| Longhorn Kush | Prospect | cash $80–140 | Run + drunk haze |
| Dirt Road Haze | Prospect | cash $95–160 | 1.40x sprint |
| Swamp Lean | Prospect | dirty $120–200 | Drunk wreck / stress dump |
| Gravel Dust | Outlaw | dirty $160–260 | 1.49x run |
| Chrome Snow | Outlaw | dirty $220–370 | 45% armor + run |
| Sandlot Ice | Outlaw | dirty $200–330 | 1.49x run |
| Outlaw Brick | Road Captain | dirty $280–450 | 55% armor + drunk |
| Honkytonk Rolls | Road Captain | dirty $400–680 | 1.49x sprint |
| Honda Pills | Road Captain | dirty $350–580 | 1.49x run + armor |
| Truck Juice | Shot Caller | dirty $480–780 | 45% armor + 1.49x |
| Stab Juice | Shot Caller | dirty $450–720 | 45% armor + 50 HP |
| Black Lotus | Shot Caller | dirty $500–820 | 50% armor + screen |
| Diesels Pack | Kingpin | dirty $850–1400 | 60% armor + 1.49x |
| Cayo Crown | Kingpin | dirty $1600–2500 | 65% armor + run |

Weed strains pay clean cash. Everything else pays dirty money. Rank and boost multipliers apply on top of each drug's min/max price.

Personal drugs cook on `v_ret_ml_tableb`. Weed bags cook on `bkr_prop_weed_table_01a`. Everything else cooks on `bkr_prop_coke_table01a`. Zip bags is the shared bagman.

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [qbx_core](https://github.com/Qbox-Project/qbx_core)
- [interact](https://github.com/darktrovx/interact) — E on weed plants, benches, ingredient peds, informant, bulk crates
- [ox_target](https://github.com/overextended/ox_target) — 3rd eye on street buyers only
- [wasabi_mdt](https://docs.wasabiscripts.com/advanced-series/wasabi-mdt/) — preferred snitch alerts (server `CreateDispatch` into MDT + dispatch). Folder must be named `wasabi_mdt`
- [ps-dispatch](https://github.com/Project-Sloth/ps-dispatch) — fallback if Wasabi is not started

## Installation

1. Place `djfivem-drugsv2` in your `resources` folder
2. Merge `install/ox_inventory_items.lua` into `ox_inventory/data/items.lua`
3. Copy `install/images/*.png` into `ox_inventory/web/images/` (photorealistic product stills)

Coords, recipes, and ranks: `install/LOCATIONS.md`. How to run the city: `install/OPERATOR_GUIDE.md`.
4. Add to `server.cfg`:

```cfg
add_ace group.admin djdrugsv2.boost allow
setr djdrugsv2_boost_webhook "https://discord.com/api/webhooks/...."
ensure ox_target
ensure interact
ensure wasabi_mdt
ensure ps-dispatch
ensure djfivem-drugsv2
```

`wasabi_mdt` is optional but preferred. Snitch alerts use the **server** `CreateDispatch` export so a civilian dealer can still generate the call. The client export will not work here — Wasabi only accepts that from players who can open the MDT. If Wasabi is not started, the client falls back to `ps-dispatch`. Do not fire both; Wasabi can also mirror the same call into ps-dispatch from its own config.

If you already run the Envy version, do **not** overwrite Envy items or images. Rebel IDs (`longhorn_kush`, `truck_juice`, `cayo_crown`, …) are separate from Envy IDs (`lone_star_kush`, `rig_juice`, `perico_gold`, …).

## Commands

| Command | Description |
|---------|-------------|
| `/trap` | Start/stop street selling (use **3rd eye** on the buyer) |
| `/drugbulksell` | Take a 100–200 unit drop at a random warehouse (pays less than `/trap`) |
| `/drugbulkcancel` | Cancel the current bulk drop (starts a shorter cooldown) |
| `/drughelp` | In-game book: ranks, how it works, unlocked recipes |
| `/drugboard` | Open the sell leaderboard |
| `/drugboost` | Admin boost event panel (15 min Discord + city warning, then LIVE) |

## Crafting

| Drug | Recipe | Output | Rank |
|------|--------|--------|------|
| Longhorn Kush | 3 horn nugs + 1 zip | **6** | Prospect |
| Dirt Road Haze | 4 road nugs + 1 zip | 5 | Prospect |
| Swamp Lean | 1+1+1+1+1 mixers | **8** | Prospect |
| Gravel Dust | 4 dust + 1 soda | 5 | Outlaw |
| Chrome Snow | 2 bush + 3 solvent + 1 zip | 6 | Outlaw |
| Sandlot Ice | 4 lithium + 1 fuel | 5 | Outlaw |
| Outlaw Brick | 2 tar + 3 tape + 1 zip | 6 | Road Captain |
| Honkytonk Rolls | 3 crystals + 1 capsule + 2 dies | **7** | Road Captain |
| Honda Pills | 1 bolt + 3 powder + 2 keycaps | 6 | Road Captain |
| Truck Juice | 2 sludge + 3 caps + 1 fuel | 6 | Shot Caller |
| Stab Juice | 3 needles + 1 swab + 2 tonic | 6 | Shot Caller |
| Black Lotus | 4 petals + 1 ash + 1 resin | 6 | Shot Caller |
| Diesels Pack | 2 nugs + 3 wrap + 2 filters | **8** | Kingpin |
| Cayo Crown | 2 palm + 3 coral + 1 resin + 2 gold | **8** | Kingpin |

Every recipe is unique and returns **at least as much product as it eats**. Street Lace +35% if you have 1 lace per unit sold.

Flow: `/drughelp` → pay Street Intel for a mark → E a weed plant or supply ped → E the bench → `/trap` or `/drugbulksell`.

## Tests

```bash
lua tests/run_tests.lua
```

## License

Private — DieselJones21
