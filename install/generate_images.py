#!/usr/bin/env python3
"""Verify photoreal transparent inventory icons in install/images/.

Product stills are isolated studio photos with the backdrop knocked out.
This script does not invent placeholder cards.
"""

import os
import sys

from PIL import Image

OUT_DIR = os.path.join(os.path.dirname(__file__), 'images')

REQUIRED = [
    'beach_bud', 'canal_nugs', 'zip_bags', 'tropical_leaves', 'lab_solvent',
    'tide_rocks', 'boat_fuel', 'port_tar', 'wrap_tape', 'drive_crystals',
    'press_capsules', 'vice_stamps', 'purple_syrup', 'crushed_ice', 'foam_cups',
    'spark_soda', 'hard_candy', 'rush_sludge', 'neon_caps', 'neon_dust',
    'baking_soda', 'cayo_palm_leaf', 'reef_coral', 'perico_resin', 'gold_capsules',
    'south_beach_kush', 'calle_ocho_haze', 'vice_purple', 'heat_305',
    'brickell_snow', 'biscayne_ice', 'port_brick', 'ocean_drive_rolls',
    'neon_rush', 'perico_gold', 'black_money', 'street_lace',
]


def main():
    missing = []
    opaque = []
    for name in REQUIRED:
        path = os.path.join(OUT_DIR, f'{name}.png')
        if not os.path.exists(path):
            missing.append(name)
            continue
        img = Image.open(path)
        if img.mode != 'RGBA':
            opaque.append(name)
            continue
        extrema = img.getextrema()
        if extrema[3][0] >= 250:
            opaque.append(name)
    if missing:
        print('Missing icons:', ', '.join(missing))
        sys.exit(1)
    if opaque:
        print('Icons without transparency:', ', '.join(opaque))
        sys.exit(1)
    print(f'{len(REQUIRED)} transparent inventory icons ready in {OUT_DIR}')


if __name__ == '__main__':
    main()
