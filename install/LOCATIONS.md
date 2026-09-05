# Envy Roleplay — Texas Drug Locations

Harvest fields are **client-sided**. Each player sees a subset of the position pool; after a successful harvest that prop despawns and another grows in a free slot. Props snap to the ground at each pool point.

## Harvest fields

| Item | Coords | Prop |
|------|--------|------|
| Ranch Buds | -278.47, -1632.34, 31.84 | `prop_weed_01` |
| Zip Bags | 1202.43, -1332.69, 35.21 | `prop_cs_cardbox_01` |
| Haze Buds | -2554.04, 2708.44, 2.83 | `prop_weed_01` |
| Coca Leaves | 1482.40, -1902.10, 71.10 | `prop_plant_01a` |
| Lab Solvent | -2950.20, 637.03, 23.18 | `prop_barrel_exp_01a` |
| Lithium Rocks | 820.64, 1315.07, 363.18 | `prop_rock_4_c` |
| Camp Fuel | -1042.40, -3522.67, 14.13 | `prop_jerrycan_01a` |
| Raw Tar | 969.45, -2621.24, 5.52 | `prop_barrel_02b` |
| Wrap Tape | 1216.83, -2198.77, 41.43 | `prop_box_wood05a` |
| Street Crystals | 327.82, -1221.27, 30.70 | `prop_box_wood05a` |
| Press Capsules | 876.73, -2189.13, 30.51 | `prop_box_wood05a` |
| Stamp Dies | 712.38, -1377.32, 26.25 | `prop_box_wood05a` |
| Purple Syrup | 99.71, -1978.33, 19.76 | `prop_drug_bottle` |
| Crushed Ice | -47.52, -1758.87, 29.42 | `prop_coolbox_01` |
| Foam Cups | -620.23, 323.26, 81.26 | `prop_food_bs_cups01` |
| Spark Soda | -1784.34, -401.11, 45.47 | `prop_crate_11e` |
| Hard Candy | -1486.62, -909.08, 9.02 | `prop_candy_pqs` |
| Oil Sludge | 592.40, 2926.20, 40.90 | `prop_barrel_01a` |
| Spark Caps | 467.20, 2974.10, 41.50 | `prop_battery_01` |
| Desert Dust | 2638.18, 3499.78, 54.20 | `prop_rock_4_c` |
| Baking Soda | 1620.73, 3292.14, 39.39 | `prop_feed_sack_01` |
| Cayo Palm Leaf | 4250.03, -4496.83, 4.16 | `prop_plant_01a` |
| Reef Coral | 4819.21, -5038.63, 31.40 | `prop_rock_4_c` |
| Perico Resin | 4821.73, -5777.58, 35.90 | `prop_barrel_01a` |
| Gold Capsules | 5099.88, -4845.09, 13.42 | `prop_box_wood05a` |

## Process benches

Benches snap to the ground. Heading is the fourth `vector4` value.

| Product | Coords (x, y, z) | Heading | Prop |
|---------|------------------|---------|------|
| Lone Star Kush | 310.38, 263.08, 104.85 | 272.13 | `bkr_prop_weed_table_01a` |
| Hill Country Haze | -3164.28, 1113.06, 20.77 | 155.91 | `bkr_prop_weed_table_01a` |
| Houston Snow | -2246.64, 198.47, 174.59 | 116.22 | `bkr_prop_coke_table01a` |
| West Texas Ice | -1102.04, 2727.97, 18.80 | 218.27 | `bkr_prop_meth_table01a` |
| Border Brick | 1467.80, 6554.91, 14.00 | 93.54 | `prop_tool_bench02` |
| Sixth Street Rolls | 120.45, -717.69, 42.02 | 68.03 | `prop_tool_bench02` |
| Purple Drank | 220.35, -1992.47, 19.66 | 48.19 | `prop_tool_bench02` |
| Rig Juice | 1732.27, -1536.24, 112.70 | 68.03 | `bkr_prop_meth_table01a` |
| Panhandle Dust | 1142.20, -299.64, 68.79 | 269.29 | `prop_tool_bench02` |
| Perico Gold | 5211.84, -5128.51, 6.20 | 280.63 | `prop_tool_bench02` |

Copy `install/images/*.png` into `ox_inventory/web/images/` after updating.

## Commands

| Command | Description |
|---------|-------------|
| `/trap` | Street selling |
| `/drugboard` | County leaderboard |
| `/drugboost` | Admin boost panel |
