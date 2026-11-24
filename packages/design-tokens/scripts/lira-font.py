"""Cuts the Turkish lira sign (U+20BA) out of Noto Sans into «Fox Lira».

CoFo has no ₺ (brand expression §7), so the money component falls back to
this font for that one glyph (owner, 2026-11-24, D.9 sheet question 1). It
writes three static weights, 400, 500 and 700, to ui-web and core_ui:

    python -I packages/design-tokens/scripts/lira-font.py <NotoSans[wdth,wght].ttf>

The source is the variable Noto Sans of github.com/google/fonts
(ofl/notosans), under the SIL Open Font License 1.1, whose text sits beside
each output as OFL.txt. Needs fontTools (`pip install fonttools`).
"""

import hashlib
import io
import pathlib
import sys

from fontTools import subset
from fontTools.ttLib import TTFont
from fontTools.varLib import instancer

ROOT = pathlib.Path(__file__).resolve().parents[3]
OUTPUTS = [
    ROOT / "packages/ui-web/fonts/fox-lira",
    ROOT / "packages/core_ui/assets/fonts/fox-lira",
]
FAMILY = "Fox Lira"
WEIGHTS = {400: "Regular", 500: "Medium", 700: "Bold"}
# 2026-11-24 00:00 UTC in the OpenType epoch (seconds since 1904-01-01).
FIXED_DATE = 3_878_323_200


def build(source: pathlib.Path, weight: int) -> TTFont:
    font = instancer.instantiateVariableFont(
        TTFont(source), {"wght": weight, "wdth": 100}, updateFontNames=False
    )
    options = subset.Options()
    options.layout_features = []
    options.name_IDs = [0, 1, 2, 3, 4, 5, 6, 13, 14]
    options.notdef_outline = True
    subsetter = subset.Subsetter(options)
    subsetter.populate(unicodes=[0x20BA])
    subsetter.subset(font)
    style = WEIGHTS[weight]
    names = font["name"]
    for record in list(names.names):
        if record.nameID in (16, 17, 21, 22, 25):
            names.removeNames(nameID=record.nameID)
    names.setName(FAMILY, 1, 3, 1, 0x409)
    names.setName(style, 2, 3, 1, 0x409)
    names.setName(f"{FAMILY} {style}", 4, 3, 1, 0x409)
    names.setName(f"FoxLira-{style}", 6, 3, 1, 0x409)
    names.setName(f"{FAMILY} {style}; derived from Noto Sans", 3, 3, 1, 0x409)
    font["OS/2"].usWeightClass = weight
    # A fixed date, so a rerun writes the same bytes the font guard pins
    # (scripts/fonts.mjs, ALLOWED_FONTS).
    font["head"].created = font["head"].modified = FIXED_DATE
    return font


def main() -> None:
    source = pathlib.Path(sys.argv[1])
    licence = source.with_name("OFL.txt").read_text(encoding="utf-8")
    fonts = {}
    for weight, style in WEIGHTS.items():
        buffer = io.BytesIO()
        font = build(source, weight)
        font.recalcTimestamp = False
        font.save(buffer)
        fonts[f"FoxLira-{style}.ttf"] = buffer.getvalue()
    for out in OUTPUTS:
        out.mkdir(parents=True, exist_ok=True)
        for name, data in fonts.items():
            (out / name).write_bytes(data)
        (out / "OFL.txt").write_text(licence, encoding="utf-8", newline="\n")
        print(f"wrote {out}")
    for name, data in fonts.items():
        print(f"{name} sha256 {hashlib.sha256(data).hexdigest()}")


if __name__ == "__main__":
    main()
