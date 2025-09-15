
# -*- coding: utf-8 -*-
import argparse, json
from pathlib import Path
from PIL import Image, ImageDraw, ImageFilter

def circular_crop_fixed(im, center_x, center_y, size, feather=1):
    x0 = int(center_x - size//1.9); y0 = int(center_y - size//1.9)
    crop = im.crop((x0, y0, x0+size, y0+size))
    mask = Image.new("L", (size, size), 0)
    d = ImageDraw.Draw(mask)
    r = size//2
    d.ellipse((size//2-r, size//2-r, size//2+r, size//2+r), fill=255)
    if feather>0:
        mask = mask.filter(ImageFilter.GaussianBlur(feather))
    out = crop.convert("RGBA")
    out.putalpha(mask)
    return out

def pack_sprites(image_paths, cell_size=160, spacing=2, cols=32, out_png="spritesheet.png", out_json="spritesheet.json"):
    from math import ceil
    from PIL import Image
    n = len(image_paths)
    rows = int(ceil(n / cols)) if n else 1
    W = cols * cell_size + (cols-1) * spacing
    H = rows * cell_size + (rows-1) * spacing
    sheet = Image.new("RGBA", (W, H), (0,0,0,0))
    mapping = {}
    for i, p in enumerate(image_paths):
        im = Image.open(p).convert("RGBA")
        c = i % cols; r = i // cols
        x = c * (cell_size + spacing)
        y = r * (cell_size + spacing)
        ox = x + (cell_size - im.width)//2
        oy = y + (cell_size - im.height)//2
        sheet.paste(im, (ox, oy), im)
        mapping[Path(p).stem] = {"x":x,"y":y,"w":im.width,"h":im.height,"row":r,"col":c,"cell":cell_size}
    sheet.save(out_png)
    with open(out_json,"w",encoding="utf-8") as f:
        json.dump(mapping, f, ensure_ascii=False, indent=2)

def main():
    ap = argparse.ArgumentParser(description="Exact fixed-center circular cropper & spritesheet packer")
    ap.add_argument("--in", dest="in_dir", required=True)
    ap.add_argument("--out", dest="out_dir", required=True)
    ap.add_argument("--center-x", type=int, required=True, help="Fixed center X in source pixels")
    ap.add_argument("--center-y", type=int, required=True, help="Fixed center Y in source pixels")
    ap.add_argument("--size", type=int, default=150, help="Crop size (square)")
    ap.add_argument("--feather", type=int, default=1, help="Edge smoothing px")
    ap.add_argument("--pack", action="store_true", help="Also build spritesheet")
    ap.add_argument("--cell", type=int, default=160, help="Spritesheet cell size")
    ap.add_argument("--cols", type=int, default=32, help="Spritesheet columns")
    args = ap.parse_args()

    pIn = Path(args.in_dir); pOut = Path(args.out_dir)
    pOut.mkdir(parents=True, exist_ok=True)

    cropped = []
    for fn in sorted(pIn.glob("*.png")):
        im = Image.open(fn).convert("RGB")
        out = circular_crop_fixed(im, args.center_x, args.center_y, args.size, args.feather)
        dst = pOut / (fn.stem + f"_fixed{args.size}.png")
        out.save(dst)
        cropped.append(str(dst))

    if args.pack and cropped:
        pack_sprites(cropped, cell_size=args.cell, cols=args.cols, out_png=str(pOut/"spritesheet.png"), out_json=str(pOut/"spritesheet.json"))

if __name__ == "__main__":
    from PIL import Image
    main()
