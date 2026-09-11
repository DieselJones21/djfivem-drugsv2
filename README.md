# djfivem-drugsv2 — Rebel Roleplay

Outlaw drug economy for FiveM (QBX + ox_inventory) branded for **Rebel Roleplay**. Harvest ingredients from client-side props and one dealer ped per recipe, process with a cook NPC, and sell via `/trap`.

This is a **branched version** of the Envy Roleplay set. Envy stays on `main` / Envy PRs. Rebel uses new item IDs, harvest fields, cook NPCs, and NUI so both can exist without overwriting each other.

## Features

- **10 Rebel county drugs** plus a Cayo Perico exclusive
- **Custom NUI** for leaderboard (`/drugboard`), boost admin (`/drugboost`), street deals, and bulk-drop HUD
- **Client-sided harvest fields** — each player sees their own plants/props; harvest deletes that one immediately and another grows 3–6 seconds later in a different spot in the same field
- **[darktrovx/interact](https://github.com/darktrovx/interact)** on harvest props and bulk crates (E prompt). Process NPCs, ingredient dealers, and street buyers stay on **ox_target** (3rd eye)
- **Cook NPCs at every process location** — 3rd eye the ped, not a bench
- **One ingredient dealer per recipe** — 3rd eye; the other ingredients stay harvest fields
- **Varied recipes** — some cooks are efficient (Swamp Lean, Diesels Pack, Longhorn), some are expensive (Cayo Crown, Truck Juice, Black Lotus)
- **Street Lace** — one map-wide cut. Sweep it at La Puerta scrap and lace any finished drug on `/trap` or bulk for **+35%**
- **`/drugbulksell`** — 100–200 unit warehouse drops at ~55% of street min price, random location from a pool of 10
- **35% bad-sale snitch** on street traps (15% on bulk drops) that creates a Wasabi MDT / dispatch call (`10-66 Drug Sale`). Falls back to ps-dispatch if Wasabi is not started
- **Ground-snapped props** on harvest spots
- **Sell ranks & leaderboard** with KVP persistence (Prospect → Outlaw → Road Captain → Shot Caller → Rebel Kingpin)
- **Admin boost events** (2x/3x/4x sell + harvest)
- **Anti-exploit** server validation (proximity to the configured pool, cooldowns, token-based sales)
- **Crazier use effects** — sprint capped at 1.49, heavier armor, screen FX on the full set

## Drugs

| Drug | Pay | Effects |
|------|-----|---------|
| Longhorn Kush | cash | Run + drunk haze / screen FX |
| Dirt Road Haze | cash | 1.40x sprint / screen FX |
| Chrome Snow | black_money | 45% armor + 1.38x run / alien screen |
| Sandlot Ice | black_money | 1.49x run / clown screen |
| Outlaw Brick | black_money | 55% armor + health / drunk wreck |
| Honkytonk Rolls | black_money | 1.49x sprint / alien screen |
| Swamp Lean | black_money | Heavy drunk wreck / stress dump |
| Truck Juice | black_money | 45% armor + 1.49x run / screen FX |
| Gravel Dust | black_money | 1.49x run / clown screen |
| Cayo Crown | black_money | 65% armor + run / alien screen |
| Honda Pills | black_money | Player-owned — 1.49x run + armor |
| Stab Juice | black_money | Player-owned — 45% armor + 50 HP |
| Black Lotus | black_money | Player-owned — 50% armor + screen FX |
| Diesels Pack | black_money | Player-owned — 60% armor + 1.49x run |

Weed strains pay clean cash. Everything else pays dirty money. Rank and boost multipliers apply on top of each drug's min/max price.

The four **player-owned** recipes (Honda Pills, Stab Juice, Black Lotus, Diesels Pack) each use **3 ingredients**. One ingredient per recipe is a dealer ped (3rd eye); the rest stay harvest fields. Zip bags is the shared bagman for the cooks that use it.

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [qbx_core](https://github.com/Qbox-Project/qbx_core)
- [interact](https://github.com/darktrovx/interact) — E prompt on harvest props and bulk crates
- [ox_target](https://github.com/overextended/ox_target) — 3rd eye on process NPCs, ingredient dealers, and street buyers
- [wasabi_mdt](https://docs.wasabiscripts.com/advanced-series/wasabi-mdt/) — preferred snitch alerts (server `CreateDispatch` into MDT + dispatch). Folder must be named `wasabi_mdt`
- [ps-dispatch](https://github.com/Project-Sloth/ps-dispatch) — fallback if Wasabi is not started

## Installation

1. Place `djfivem-drugsv2` in your `resources` folder
2. Merge `install/ox_inventory_items.lua` into `ox_inventory/data/items.lua`
3. Copy `install/images/*.png` into `ox_inventory/web/images/` (photorealistic product stills)

Process NPC coordinates are listed in `install/LOCATIONS.md`.
4. Add to `server.cfg`:

```cfg
add_ace group.admin djdrugsv2.boost allow
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
| `/drugboard` | Open the sell leaderboard |
| `/drugboost` | Admin boost event panel |

## Crafting

| Drug | Recipe | Output | Notes |
|------|--------|--------|-------|
| Longhorn Kush | 2 horn nugs + 1 zip bag | **8** | Best weed yield |
| Dirt Road Haze | 3 road nugs + 2 zip bags | 6 | Solid cook |
| Chrome Snow | 3 bush + 2 solvent + 2 zip | 8 | City brick |
| Sandlot Ice | 3 lithium + 2 fuel + 2 solvent | 7 | Even cook |
| Outlaw Brick | 3 tar + 2 tape + 2 zip | 7 | Even cook |
| Honkytonk Rolls | 2 crystals + 2 capsules + 1 die | **8** | Efficient press |
| Swamp Lean | 2+2+1+1+1 mixers | **10** | Easy pour |
| Truck Juice | 3 sludge + 2 caps + 2 fuel | 7 | Even cook |
| Gravel Dust | 2 dust + 2 soda + 1 zip | 6 | Decent |
| Cayo Crown | 3 palm + 2 coral + 2 resin + 2 gold | **10** | Island fat cook |
| Honda Pills | 2 bolts + 2 powder + 1 keycap | 7 | Mid |
| Stab Juice | 2 needles + 2 swabs + 2 tonic | 6 | Combat tonic |
| Black Lotus | 2 petals + 2 ash + 2 resin | 6 | Ritual cook |
| Diesels Pack | 3 nugs + 2 wrap + 2 filters | **10** | Best player-owned yield |

Every recipe returns **at least as much product as it eats**. Sweep **Street Lace** and the buyer pays **+35%** if you have 1 lace per unit sold.

Flow: Harvest scattered props or talk to a dealer ped → 3rd eye a cook NPC → `/trap` for street prices, or stockpile 100–200 and `/drugbulksell` for a cheaper warehouse drop.

## Tests

```bash
lua tests/run_tests.lua
```

## License

Private — DieselJones21
