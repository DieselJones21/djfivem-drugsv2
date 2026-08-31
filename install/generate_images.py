#!/usr/bin/env python3
"""Generate Miami-themed neon inventory icons for ox_inventory (128x128)."""

import os
from PIL import Image, ImageDraw, ImageFilter, ImageFont

OUT_DIR = os.path.join(os.path.dirname(__file__), 'images')
SIZE = 128

BG = (10, 10, 16)
PINK = (255, 0, 127)
PINK_LIGHT = (255, 102, 178)
GOLD = (255, 210, 70)
GREEN = (40, 210, 130)
PURPLE = (170, 80, 220)
CYAN = (0, 210, 230)
WHITE = (245, 245, 250)
ORANGE = (255, 140, 60)

ITEMS = {
    'neon_crystals': (PINK, 'CRY', 'crystal'),
    'miami_solvent': (CYAN, 'SOL', 'bottle'),
    'vice_jars': (PINK_LIGHT, 'JAR', 'jar'),
    'espresso_powder': (ORANGE, 'ESP', 'sack'),
    'beach_bud': (GREEN, 'BUD', 'leaf'),
    'zip_bags': (WHITE, 'ZIP', 'bag'),
    'tropical_leaves': (GREEN, 'LEAF', 'leaf'),
    'lab_solvent': (CYAN, 'LAB', 'bottle'),
    'purple_syrup': (PURPLE, 'SYR', 'bottle'),
    'crushed_ice': (CYAN, 'ICE', 'ice'),
    'foam_cups': (WHITE, 'CUP', 'cup'),
    'spark_soda': (CYAN, 'SODA', 'can'),
    'hard_candy': (PINK_LIGHT, 'CNDY', 'pill'),
    'drive_crystals': (PINK, 'DRV', 'crystal'),
    'neon_powder': (PINK, 'PWD', 'sack'),
    'press_capsules': (WHITE, 'CAP', 'pill'),
    'vice_stamps': (GOLD, 'STMP', 'stamp'),
    'rush_powder': (PINK, 'RUSH', 'sack'),
    'neon_candy': (PINK_LIGHT, 'CNDY', 'pill'),
    'tropical_concentrate': (CYAN, 'CON', 'bottle'),
    'cayo_palm_leaf': (GREEN, 'PALM', 'leaf'),
    'reef_coral': (PINK_LIGHT, 'COR', 'crystal'),
    'perico_resin': (GOLD, 'RES', 'jar'),
    'gold_capsules': (GOLD, 'CAP', 'pill'),
    'heat_305': (PINK, '305', 'product'),
    'south_beach_kush': (GREEN, 'SBK', 'product'),
    'brickell_snow': (WHITE, 'SNO', 'product'),
    'vice_purple': (PURPLE, 'VP', 'product'),
    'ocean_drive_rolls': (PINK, 'ODR', 'product'),
    'neon_rush': (CYAN, 'NR', 'product'),
    'perico_gold': (GOLD, 'PG', 'product'),
    'black_money': (GREEN, '$', 'money'),
}


def font(size):
    for path in (
        '/usr/share/fonts/truetype/dejavu/DejaVuSans-Bold.ttf',
        '/usr/share/fonts/truetype/dejavu/DejaVuSans.ttf',
    ):
        if os.path.exists(path):
            return ImageFont.truetype(path, size)
    return ImageFont.load_default()


def draw_text_centered(draw, text, cy, fnt, fill):
    bbox = draw.textbbox((0, 0), text, font=fnt)
    tw, th = bbox[2] - bbox[0], bbox[3] - bbox[1]
    draw.text(((SIZE - tw) / 2 - bbox[0], cy - th / 2 - bbox[1]), text, font=fnt, fill=fill)


def shape_layer(kind, accent):
    layer = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    d = ImageDraw.Draw(layer)
    cx, cy = SIZE // 2, SIZE // 2 - 4
    a = accent + (230,)

    if kind in ('crystal',):
        d.polygon([(cx, cy - 28), (cx + 22, cy), (cx, cy + 28), (cx - 22, cy)], outline=a, width=3)
        d.line([(cx, cy - 28), (cx, cy + 28)], fill=a, width=2)
    elif kind == 'bottle':
        d.rounded_rectangle([cx - 12, cy - 8, cx + 12, cy + 26], radius=4, outline=a, width=3)
        d.rectangle([cx - 6, cy - 22, cx + 6, cy - 8], outline=a, width=2)
    elif kind == 'jar':
        d.rounded_rectangle([cx - 16, cy - 10, cx + 16, cy + 24], radius=6, outline=a, width=3)
        d.rectangle([cx - 10, cy - 18, cx + 10, cy - 10], outline=a, width=2)
    elif kind == 'sack':
        d.ellipse([cx - 20, cy - 8, cx + 20, cy + 26], outline=a, width=3)
        d.arc([cx - 12, cy - 22, cx + 12, cy - 2], 200, 340, fill=a, width=3)
    elif kind == 'leaf':
        d.ellipse([cx - 10, cy - 26, cx + 18, cy + 22], outline=a, width=3)
        d.line([(cx, cy + 22), (cx, cy - 10)], fill=a, width=2)
    elif kind == 'bag':
        d.rounded_rectangle([cx - 16, cy - 6, cx + 16, cy + 24], radius=3, outline=a, width=3)
        d.line([(cx - 10, cy - 6), (cx - 6, cy - 18), (cx + 6, cy - 18), (cx + 10, cy - 6)], fill=a, width=2)
    elif kind == 'ice':
        d.polygon([(cx - 8, cy - 4), (cx + 6, cy - 18), (cx + 18, cy - 2), (cx + 4, cy + 10)], outline=a, width=2)
        d.polygon([(cx - 20, cy + 2), (cx - 4, cy - 10), (cx + 8, cy + 8), (cx - 8, cy + 20)], outline=a, width=2)
    elif kind == 'cup':
        d.polygon([(cx - 14, cy - 10), (cx + 14, cy - 10), (cx + 10, cy + 22), (cx - 10, cy + 22)], outline=a, width=3)
    elif kind == 'can':
        d.rounded_rectangle([cx - 12, cy - 22, cx + 12, cy + 24], radius=6, outline=a, width=3)
        d.ellipse([cx - 12, cy - 28, cx + 12, cy - 16], outline=a, width=2)
    elif kind == 'pill':
        d.rounded_rectangle([cx - 22, cy - 10, cx + 22, cy + 10], radius=10, outline=a, width=3)
        d.line([(cx, cy - 10), (cx, cy + 10)], fill=a, width=2)
    elif kind == 'stamp':
        d.ellipse([cx - 20, cy - 16, cx + 20, cy + 24], outline=a, width=3)
        d.ellipse([cx - 10, cy - 6, cx + 10, cy + 14], outline=a, width=2)
    elif kind == 'money':
        d.rounded_rectangle([cx - 26, cy - 16, cx + 26, cy + 16], radius=4, outline=a, width=3)
    else:
        d.ellipse([cx - 26, cy - 22, cx + 26, cy + 22], outline=a, width=3)

    return layer.filter(ImageFilter.GaussianBlur(0.4))


def generate_icon(accent, label, kind):
    img = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    draw = ImageDraw.Draw(img)
    m = 8
    draw.rounded_rectangle([m, m, SIZE - m, SIZE - m], radius=18, fill=BG + (255,))

    glow = Image.new('RGBA', (SIZE, SIZE), (0, 0, 0, 0))
    gd = ImageDraw.Draw(glow)
    gd.rounded_rectangle([m - 2, m - 2, SIZE - m + 2, SIZE - m + 2], radius=20, outline=accent + (90,), width=3)
    img = Image.alpha_composite(img, glow.filter(ImageFilter.GaussianBlur(3)))
    draw = ImageDraw.Draw(img)
    draw.rounded_rectangle([m, m, SIZE - m, SIZE - m], radius=18, outline=accent + (200,), width=2)
    draw.line([(m + 14, m + 6), (SIZE - m - 14, m + 6)], fill=accent + (200,), width=2)

    img = Image.alpha_composite(img, shape_layer(kind, accent))
    draw = ImageDraw.Draw(img)

    if kind == 'product':
        draw_text_centered(draw, label, 64, font(22), WHITE + (255,))
    elif kind == 'money':
        draw_text_centered(draw, label, 64, font(36), accent + (255,))
    else:
        draw_text_centered(draw, label, 98, font(11), accent + (230,))

    draw.rounded_rectangle([m + 16, SIZE - m - 8, SIZE - m - 16, SIZE - m - 5], radius=2, fill=accent + (180,))
    return img


def main():
    os.makedirs(OUT_DIR, exist_ok=True)
    for name, (accent, label, kind) in ITEMS.items():
        generate_icon(accent, label, kind).save(os.path.join(OUT_DIR, f'{name}.png'), 'PNG')
        print(f'  {name}.png')
    print(f'\nGenerated {len(ITEMS)} icons in {OUT_DIR}')


if __name__ == '__main__':
    main()
