# THE 305 — Drug Locations Reference

All props use ground snapping (`PlaceObjectOnGroundProperly` + `GetGroundZFor_3dCoord`).
Harvest fields use **multiple props** — walk around the area to collect each ingredient.

## 305 Heat (Little Havana / Downtown)

| Ingredient | Field ID | Center Coords | Props |
|---|---|---|---|
| Neon Crystals | `neon_crystal_field` | 1287, -1710, 55 | 8 scattered |
| Miami Solvent | `miami_solvent_yard` | 955, -195, 78 | 6 scattered |
| Vice Jars | `vice_jars_warehouse` | 1123, -653, 56 | 6 scattered |
| Espresso Powder | `espresso_powder_dock` | 756, -673, 28 | 6 scattered |
| **Process** | — | 857, -944, 25 | `bkr_prop_meth_table01a` |

## South Beach Kush (Vespucci Beach)

| Ingredient | Field ID | Center Coords | Props |
|---|---|---|---|
| Beach Buds | `beach_bud_field` | -1172, -1571, 4 | 10 scattered (blip on) |
| Zip Bags | `zip_bags_supply` | 285, -1773, 27 | 5 scattered |
| **Process** | — | -1178, -1575, 4 | `bkr_prop_weed_table_01a` |

## Brickell Snow (Downtown)

| Ingredient | Field ID | Center Coords | Props |
|---|---|---|---|
| Tropical Leaves | `tropical_leaf_garden` | 251, -800, 29 | 8 scattered |
| Lab Solvent | `lab_solvent` | -2950, 637, 23 | 5 scattered |
| Zip Bags | `zip_bags_supply` | 285, -1773, 27 | 5 scattered |
| **Process** | — | -2950, 637, 23 | `bkr_prop_coke_table01a` |

## Vice Purple (Davis / Grove)

| Ingredient | Field ID | Center Coords | Props |
|---|---|---|---|
| Purple Syrup | `purple_syrup_stash` | 100, -1978, 20 | 6 scattered |
| Crushed Ice | `crushed_ice_cooler` | -48, -1759, 29 | 4 scattered |
| Foam Cups | `foam_cups_stack` | -620, 323, 81 | 5 scattered |
| Spark Soda | `spark_soda_crates` | -1784, -401, 45 | 5 scattered |
| Hard Candy | `hard_candy_bin` | -1487, -909, 9 | 5 scattered |
| **Process** | — | 1093, -155, 55 | `prop_tool_bench02` |

## Ocean Drive Rolls (Del Perro)

| Ingredient | Field ID | Center Coords | Props |
|---|---|---|---|
| Drive Crystals | `drive_crystals` | -1500, -400, 36 | 8 scattered |
| Neon Powder | `neon_powder_barrels` | -1344, -1155, 4 | 6 scattered |
| Press Capsules | `press_capsules` | -1606, -1050, 6 | 5 scattered |
| Vice Stamps | `vice_stamps` | -1279, -839, 16 | 5 scattered |
| **Process** | — | 385, 3555, 32 | `prop_tool_bench02` |

## Neon Rush (Port / Elysian Island)

| Ingredient | Field ID | Center Coords | Props |
|---|---|---|---|
| Rush Powder | `rush_powder` | 1200, -3101, 6 | 8 scattered |
| Neon Candy | `neon_candy` | 1244, -3250, 6 | 6 scattered |
| Tropical Concentrate | `tropical_concentrate` | 1080, -3103, 6 | 5 scattered |
| **Process** | — | -1487, -909, 9 | `prop_tool_bench02` |

## Perico Gold (Cayo Perico — exclusive)

| Ingredient | Field ID | Center Coords | Props |
|---|---|---|---|
| Cayo Palm Leaves | `cayo_palm_leaf` | 5365, -5439, 48 | 8 scattered |
| Reef Coral | `reef_coral` | 5610, -5653, 9 | 6 scattered |
| Perico Resin | `perico_resin` | 4924, -5272, 4 | 5 scattered |
| Gold Capsules | `gold_capsules` | 4517, -4532, 3 | 5 scattered |
| **Process** | — | 5071, -4640, 2 | `prop_tool_bench02` |

## Commands

| Command | Description |
|---|---|
| `/trap` | Start/stop street selling (mini NUI deal panel) |
| `/drugboard` | Open Miami-themed leaderboard |
| `/drugboost` | Admin boost event panel (requires `djdrugsv2.boost` ACE) |

## Server Config

```cfg
add_ace group.admin djdrugsv2.boost allow
ensure djfivem-drugsv2
```
