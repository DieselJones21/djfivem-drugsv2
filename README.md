# djfivem-drugsv2

Texas-themed drug economy for FiveM (QBX + ox_inventory) branded for **Envy Roleplay**. Harvest ingredients from client-side props, process at benches, and sell via `/trap`.

## Features

- **10 Texas-themed drugs** plus a Cayo Perico exclusive
- **Custom NUI** for leaderboard (`/drugboard`), boost admin (`/drugboost`), and street deals
- **Client-sided harvest fields** — each player sees their own plants/props; harvest despawns that one and respawns it elsewhere in the same field
- **Ground-snapped props** on harvest spots and process benches
- **Sell ranks & leaderboard** with KVP persistence
- **Admin boost events** (2x/3x/4x sell + harvest)
- **Anti-exploit** server validation (proximity to the configured pool, cooldowns, token-based sales)

## Drugs

| Drug | Pay | Effects |
|------|-----|---------|
| Lone Star Kush | cash | Calm / no screen FX |
| Hill Country Haze | cash | Light sprint / no screen FX |
| Houston Snow | black_money | Armor + run / light screen |
| West Texas Ice | black_money | Fast run / screen FX |
| Border Brick | black_money | Armor / screen FX |
| Sixth Street Rolls | black_money | Fast run / screen FX |
| Purple Drank | black_money | Stress relief / no screen FX |
| Rig Juice | black_money | Armor + fast run / no screen FX |
| Panhandle Dust | black_money | Fast run / screen FX |
| Perico Gold | black_money | Heavy armor / no screen FX |

Weed strains pay clean cash. Everything else pays dirty money. Rank and boost multipliers apply on top of each drug's min/max price.

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_target](https://github.com/overextended/ox_target)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [qbx_core](https://github.com/Qbox-project/qbx_core)

## Installation

1. Place `djfivem-drugsv2` in your `resources` folder
2. Merge `install/ox_inventory_items.lua` into `ox_inventory/data/items.lua`
3. Copy `install/images/*.png` into `ox_inventory/web/images/` (photorealistic product stills)

Process bench coordinates are listed in `install/LOCATIONS.md`.
4. Add to `server.cfg`:

```cfg
add_ace group.admin djdrugsv2.boost allow
ensure djfivem-drugsv2
```

## Commands

| Command | Description |
|---------|-------------|
| `/trap` | Start/stop street selling |
| `/drugboard` | Open the sell leaderboard |
| `/drugboost` | Admin boost event panel |

## Crafting

Default rule: **5 of each ingredient → 7 finished product**

Flow: Harvest scattered props → Process at bench → `/trap` to sell

## Tests

```bash
lua tests/run_tests.lua
```

## License

Private — DieselJones21
