#!/usr/bin/env python3
"""Resize and compress photorealistic inventory stills in install/images/.

Icons are studio product photos (not generated outlines). This script only
recompresses existing PNGs — it will not invent placeholder cards.
"""

import os
import sys

from PIL import Image

OUT_DIR = os.path.join(os.path.dirname(__file__), 'images')
SIZE = 512

REQUIRED = [
    'ranch_bud', 'haze_bud', 'zip_bags', 'coca_leaves', 'lab_solvent',
    'lithium_rocks', 'camp_fuel', 'raw_tar', 'wrap_tape', 'street_crystals',
    'press_capsules', 'stamp_dies', 'purple_syrup', 'crushed_ice', 'foam_cups',
    'spark_soda', 'hard_candy', 'oil_sludge', 'spark_caps', 'desert_dust',
    'baking_soda', 'cayo_palm_leaf', 'reef_coral', 'perico_resin', 'gold_capsules',
    'lone_star_kush', 'hill_country_haze', 'houston_snow', 'west_texas_ice',
    'border_brick', 'sixth_street_rolls', 'purple_drank', 'rig_juice',
    'panhandle_dust', 'perico_gold', 'black_money',
]


def compress(path):
    img = Image.open(path).convert('RGB')
    img = img.resize((SIZE, SIZE), Image.Resampling.LANCZOS)
    img.save(path, 'PNG', optimize=True)


def main():
    missing = []
    for name in REQUIRED:
        path = os.path.join(OUT_DIR, f'{name}.png')
        if not os.path.exists(path):
            missing.append(name)
            continue
        if '--check' in sys.argv:
            continue
        compress(path)
        print(f'  {name}.png ({os.path.getsize(path) // 1024} kb)')
    if missing:
        print('Missing icons:', ', '.join(missing))
        sys.exit(1)
    print(f'\n{len(REQUIRED)} inventory icons ready in {OUT_DIR}')


if __name__ == '__main__':
    main()
