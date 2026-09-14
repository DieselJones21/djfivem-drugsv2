# djfivem-drugsv2 — The 305

Miami street economy for FiveM (QBX + ox_inventory) branded for **The 305**. Weed plants still grow and die in the field. Every other ingredient is one sidewalk ped. Cooks happen on benches. Sell via `/trap`. `/drughelp` is the in-game book. Full coords and recipes: `install/LOCATIONS.md`. Operator runbook: `install/OPERATOR_GUIDE.md`.

Magenta/chrome NUI matches the official 305 wordmark. Personal/player-owned recipes are gone.

## Features

- **10 Miami street drugs** plus a Cayo Perico exclusive
- **Custom NUI** for leaderboard (`/drugboard`), boost admin (`/drugboost`), and mini sell deal panel
- **Harvest** — two public weed fields (South Beach + Calle Ocho). Every other ingredient is one sidewalk ped
- **Process benches** — weed table or coke table
- **Hidden rank gates** — Beach Runner → 305 Kingpin. No personal recipes
- **Street Intel** — $75,000 cash per hidden GPS mark, 1 hour cooldown
- **Street buyers** stay **ox_target (3rd eye)** and talk
- **Wasabi MDT** snitch pings after a "bad" sale (`CreateDispatch` on the server)
- **Photoreal transparent inventory icons**
- **Sell ranks & leaderboard** (Beach Runner → Vice Hustler → Ocean Plug → Port Boss → 305 Kingpin)
- **Admin boost events** (2x/3x/4x sell + harvest) with Discord + 15-minute warnings
- **Anti-exploit** server validation (proximity, cooldowns, token-based sales)

## Drugs

| Drug | Rank | Payout | Effect |
|------|------|--------|--------|
| South Beach Kush | Beach Runner | cash $92–161 | Run + drunk haze |
| Calle Ocho Haze | Beach Runner | cash $109–184 | 1.40x sprint |
| Vice Purple | Beach Runner | dirty $138–230 | Drunk wreck / stress dump |
| 305 Heat | Vice Hustler | dirty $184–299 | 1.49x sprint |
| Brickell Snow | Vice Hustler | dirty $253–426 | 45% armor + run |
| Biscayne Ice | Vice Hustler | dirty $230–380 | 1.49x sprint |
| Port Brick | Ocean Plug | dirty $280–450 | 55% armor + drunk wreck |
| Ocean Drive Rolls | Ocean Plug | dirty $400–680 | 1.49x sprint |
| Neon Rush | Port Boss | dirty $480–780 | 45% armor + 1.49x run |
| Perico Gold | 305 Kingpin | dirty $1600–2500 | 65% armor + run |

## Dependencies

- [ox_lib](https://github.com/overextended/ox_lib)
- [ox_inventory](https://github.com/overextended/ox_inventory)
- [qbx_core](https://github.com/Qbox-project/qbx_core)
- [darktrovx/interact](https://github.com/darktrovx/interact) (E on plants, benches, peds)
- [ox_target](https://github.com/overextended/ox_target) (3rd eye on street buyers)

Optional: [wasabi_mdt](https://wasabiscripts.com/) for snitch sale alerts. [ps-dispatch](https://github.com/Project-Sloth/ps-dispatch) is the fallback only.

## Installation

1. Place `djfivem-drugsv2` in your `resources` folder (live folder can be `djfivem-drugs`)
2. Merge `install/ox_inventory_items.lua` into `ox_inventory/data/items.lua`
3. Copy `install/images/*.png` into `ox_inventory/web/images/`
4. Add to `server.cfg`:

```cfg
add_ace group.admin djdrugsv2.boost allow
ensure ox_target
ensure interact
ensure wasabi_mdt
ensure djfivem-drugsv2
```

## Commands

| Command | Description |
|---------|-------------|
| `/trap` | Start/stop street selling (opens mini deal NUI) |
| `/drugbulksell` | Take a 100–200 unit warehouse drop |
| `/drugboard` | Open the 305 sell leaderboard |
| `/drughelp` | How the loop works |
| `/drugboost` | Admin boost event panel |

## Crafting

Each recipe is unique and returns at least as much product as it eats.

| Drug | Recipe | Out | Rank |
|------|--------|-----|------|
| South Beach Kush | 3 beach bud + 1 zip | **6** | Beach Runner (blipped) |
| Calle Ocho Haze | 4 canal nugs + 1 zip | 5 | Beach Runner (blipped) |
| Vice Purple | 1+1+1+1+1 mixers | **8** | Beach Runner |
| 305 Heat | 4 neon dust + 1 soda | 5 | Vice Hustler |
| Brickell Snow | 2 leaves + 3 solvent + 1 zip | **6** | Vice Hustler |
| Biscayne Ice | 4 tide rocks + 1 fuel | 5 | Vice Hustler |
| Port Brick | 2 tar + 3 tape + 1 zip | **6** | Ocean Plug |
| Ocean Drive Rolls | 3 crystals + 1 cap + 2 stamps | **7** | Ocean Plug |
| Neon Rush | 2 sludge + 3 caps + 1 fuel | **6** | Port Boss |
| Perico Gold | 2 palm + 3 coral + 1 resin + 2 gold | **8** | 305 Kingpin |

Flow: Harvest → Process at bench → `/trap` to sell. **Vice Lace** +35% on any finished drug.

## UI

The custom NUI matches the 305 magenta/chrome wordmark:
- Dark glass panels with hot-pink glow and chrome highlights so the mark stands out in-game
- Official **The 305** logo on leaderboard, boost, sell, and HUD
- Transparent `html` / `body` / `#app` plate
- Podium styling and a highlighted “you” row
- Compact street deal panel (mouse focus for Accept / Haggle / Walk Away)

## Tests

```bash
lua tests/run_tests.lua
```

## License

Private — DieselJones21
