#!/usr/bin/env python3
"""Generate Miami-themed neon pink inventory icons for ox_inventory."""

import os
import math
from PIL import Image, ImageDraw, ImageFont

OUT_DIR = os.path.join(os.path.dirname(__file__), 'images')
SIZE = 128

# Miami Vice palette
BG = (12, 12, 20)
PINK = (255, 0, 127)
PINK_LIGHT = (255, 102, 178)
PINK_DARK = (180, 0, 90)
WHITE = (240, 240, 245)
GOLD = (255, 215, 0)
GREEN = (0, 200, 120)
PURPLE = (140, 60, 200)
CYAN = (0, 200, 220)

ITEMS = {
    # Ingredients
    'neon_crystals': (PINK, '◆', 'crystal'),
    'miami_solvent': (CYAN, '⚗', 'liquid'),
    'vice_jars': (PINK_LIGHT, '▣', 'jar'),
    'espresso_powder': (GOLD, '☕', 'powder'),
    'beach_bud': (GREEN, '♣', 'plant'),
    'zip_bags': (WHITE, '▢', 'bag'),
    'tropical_leaves': (GREEN, '♣', 'leaf'),
    'lab_solvent': (CYAN, '⚗', 'solvent'),
    'purple_syrup': (PURPLE, '◉', 'syrup'),
    'crushed_ice': (CYAN, '❄', 'ice'),
    'foam_cups': (WHITE, '▣', 'cup'),
    'spark_soda': (CYAN, '◎', 'soda'),
    'hard_candy': (PINK_LIGHT, '◆', 'candy'),
    'drive_crystals': (PINK, '◆', 'crystal'),
    'neon_powder': (PINK, '●', 'powder'),
    'press_capsules': (WHITE, '○', 'capsule'),
    'vice_stamps': (GOLD, '✦', 'stamp'),
    'rush_powder': (PINK, '●', 'powder'),
    'neon_candy': (PINK_LIGHT, '◆', 'candy'),
    'tropical_concentrate': (CYAN, '⚗', 'juice'),
    'cayo_palm_leaf': (GREEN, '♣', 'palm'),
    'reef_coral': (PINK_LIGHT, '◆', 'coral'),
    'perico_resin': (GOLD, '◉', 'resin'),
    'gold_capsules': (GOLD, '○', 'gold'),
    # Finished products
    'heat_305': (PINK, '305', 'product'),
    'south_beach_kush': (GREEN, 'SB', 'product'),
    'brickell_snow': (WHITE, 'BS', 'product'),
    'vice_purple': (PURPLE, 'VP', 'product'),
    'ocean_drive_rolls': (PINK, 'OD', 'product'),
    'neon_rush': (CYAN, 'NR', 'product'),
    'perico_gold': (GOLD, 'PG', 'product'),
    'black_money': (GREEN, '$', 'money'),
}


def draw_glow_circle(draw, cx, cy, r, color, alpha=60):
    for i in range(3):
        ri = r + i * 4
        c = (*color[:3], max(10, alpha - i * 20))
        draw.ellipse([cx - ri, cy - ri, cx + ri, cy + ri], fill=c)


def generate_icon(name, accent, symbol, kind):
    img = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)

    # Dark rounded background
    margin = 8
    draw.rounded_rectangle(
        [margin, margin, SIZE - margin, SIZE - margin],
        radius=16,
        fill=BG + (255,),
    )

    # Neon border glow
    for i in range(3, 0, -1):
        alpha = 30 + (3 - i) * 25
        draw.rounded_rectangle(
            [margin - i, margin - i, SIZE - margin + i, SIZE - margin + i],
            radius=16 + i,
            outline=accent + (alpha,),
            width=1,
        )

    # Inner accent line at top
    draw.line([(margin + 10, margin + 4), (SIZE - margin - 10, margin + 4)], fill=accent + (180,), width=2)

    cx, cy = SIZE // 2, SIZE // 2 + 4

    if kind == 'product':
        # Product icons: larger text label
        draw_glow_circle(draw, cx, cy, 28, accent, 40)
        draw.ellipse([cx - 28, cy - 28, cx + 28, cy + 28], outline=accent + (200,), width=2)
        try:
            font = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf', 22)
        except OSError:
            font = ImageFont.load_default()
        bbox = draw.textbbox((0, 0), symbol, font=font)
        tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
        draw.text((cx - tw // 2, cy - th // 2 - 2), symbol, fill=WHITE + (255,), font=font)
    elif kind == 'money':
        try:
            font = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf', 40)
        except OSError:
            font = ImageFont.load_default()
        draw.text((cx - 12, cy - 22), symbol, fill=accent + (255,), font=font)
    else:
        # Ingredient icons: symbol with glow
        draw_glow_circle(draw, cx, cy, 22, accent, 50)
        try:
            font = ImageFont.truetype('/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf', 30)
        except OSError:
            font = ImageFont.load_default()
        bbox = draw.textbbox((0, 0), symbol, font=font)
        tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
        draw.text((cx - tw // 2, cy - th // 2 - 2), symbol, fill=accent + (255,), font=font)

    # Bottom accent bar
    bar_y = SIZE - margin - 6
    draw.rounded_rectangle(
        [margin + 12, bar_y, SIZE - margin - 12, bar_y + 3],
        radius=2,
        fill=accent + (160,),
    )

    return img


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    count = 0
    for name, (accent, symbol, kind) in ITEMS.items():
        img = generate_icon(name, accent, symbol, kind)
        path = os.path.join(OUT_DIR, f'{name}.png')
        img.save(path, 'PNG')
        count += 1
        print(f'  {name}.png')
    print(f'\nGenerated {count} icons in {OUT_DIR}')


if __name__ == '__main__':
    main()
