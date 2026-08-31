# djfivem-drugsv2

Drug economy for FiveM (QBX + ox_inventory) themed for **Envy Roleplay**. Harvest ingredients from scattered props across the map, process at benches, and sell via `/trap` street dealing.

**Envy Roleplay** aesthetic — dark glass UI with electric cyan and chrome accents matching the server wordmark.

## Features

- **7 Miami-themed drugs** spread across Los Santos + Cayo Perico
- **Custom NUI** for leaderboard (`/drugboard`), boost admin (`/drugboost`), and mini sell deal panel
- **Multi-prop harvest fields** — walk around areas to collect ingredients (not single spots)
- **Ground-snapped props** — all harvest props and processing benches level on the ground
- **32 ox_inventory items** with custom cyan/chrome icons
- **Sell ranks & leaderboard** with KVP persistence
- **Admin boost events** (2x/3x/4x sell + harvest)
- **Anti-exploit** server validation (proximity, cooldowns, token-based sales)

## Drugs

| Drug | Theme | Location | Payout |
|------|-------|----------|--------|
| 305 Heat | Neon stim drink | Little Havana | black_money |
| South Beach Kush | Premium weed | Vespucci Beach | cash |
| Brickell Snow | Downtown coke | Maze Bank area | black_money |
| Vice Purple | Lean cup | Davis / Grove | black_money |
| Ocean Drive Rolls | Ecstasy pills | Del Perro | black_money |
| Neon Rush | Port stim juice | Elysian Island | black_money |
| Perico Gold | Premium pills | Cayo Perico | black_money |

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [qbx_core](https://github.com/Qbox-project/qbx_core)

## Installation

1. Place `djfivem-drugsv2` in your `resources` folder
2. Merge `install/ox_inventory_items.lua` into `ox_inventory/data/items.lua`
3. Copy `install/images/*.png` into `ox_inventory/web/images/`
4. Add to `server.cfg`:

```cfg
add_ace group.admin djdrugsv2.boost allow
ensure djfivem-drugsv2
```

## Commands

| Command | Description |
|---------|-------------|
| `/trap` | Start/stop street selling (opens mini deal NUI) |
| `/drugboard` | Open Envy-themed sell leaderboard |
| `/drugboost` | Admin boost event panel |

## Crafting

Default rule: **5 of each ingredient → 7 finished product**

Flow: Harvest scattered props → Process at bench → `/trap` to sell

## UI

The custom NUI matches the Envy Roleplay cyan/chrome wordmark:
- Dark glassmorphism panels with electric cyan glow and chrome highlights
- Official **Envy Roleplay** logo on leaderboard, boost, sell, and HUD
- Podium styling (gold / silver / bronze) and a highlighted “you” row
- Leaderboard with rank progress bar and player avatar
- Boost admin panel with multiplier cards, live status, and a HUD countdown
- Compact street deal panel (mouse focus for Accept / Haggle / Walk Away)

## Tests

```bash
lua tests/run_tests.lua
```

## License

Private — DieselJones21
