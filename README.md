# djfivem-drugsv2 — Rebel Roleplay

Outlaw drug economy for FiveM (QBX + ox_inventory) branded for **Rebel Roleplay**. Harvest ingredients from client-side props, process at benches, and sell via `/trap`.

This is a **branched version** of the Envy Roleplay set. Envy stays on `main` / Envy PRs. Rebel uses new item IDs, harvest fields, process benches, and NUI so both can exist without overwriting each other.

## Features

- **10 Rebel county drugs** plus a Cayo Perico exclusive
- **Custom NUI** for leaderboard (`/drugboard`), boost admin (`/drugboost`), street deals, and bulk-drop HUD
- **Client-sided harvest fields** — each player sees their own plants/props; harvest deletes that one immediately and another grows 10–15 seconds later in a different spot in the same field
- **[darktrovx/interact](https://github.com/darktrovx/interact)** on harvest props, process benches, and bulk crates (E prompt). Street buyers stay on **ox_target** (3rd eye) so networked peds do not fight the E prompt
- **`/drugbulksell`** — 100–200 unit warehouse drops at ~55% of street min price, random location from a pool of 10
- **35% bad-sale snitch** on street traps (15% on bulk drops) that pings Project Sloth dispatch (`DrugSale`)
- **Ground-snapped props** on harvest spots and process benches
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

The four **player-owned** recipes (Honda Pills, Stab Juice, Black Lotus, Diesels Pack) each use **3 ingredients**. Harvest spots sit in places people rarely check (dirt track, dam, cemetery, cult camp, lighthouse, observatory, wind farm).

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [qbx_core](https://github.com/Qbox-Project/qbx_core)
- [interact](https://github.com/darktrovx/interact) — E prompt on harvest/process/bulk crates
- [ox_target](https://github.com/overextended/ox_target) — 3rd eye on street buyers (`/trap`)
- [ps-dispatch](https://github.com/Project-Sloth/ps-dispatch) — snitch chance on `/trap` and bulk drops pings LEO

## Installation

1. Place `djfivem-drugsv2` in your `resources` folder
2. Merge `install/ox_inventory_items.lua` into `ox_inventory/data/items.lua`
3. Copy `install/images/*.png` into `ox_inventory/web/images/` (photorealistic product stills)

Process bench coordinates are listed in `install/LOCATIONS.md`.
4. Add to `server.cfg`:

```cfg
add_ace group.admin djdrugsv2.boost allow
ensure ox_target
ensure interact
ensure ps-dispatch
ensure djfivem-drugsv2
```

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

Default rule: **5 of each ingredient → 7 finished product**

Flow: Harvest scattered props → Process at bench → `/trap` for street prices, or stockpile 100–200 and `/drugbulksell` for a cheaper warehouse drop.

## Tests

```bash
lua tests/run_tests.lua
```

## License

Private — DieselJones21
