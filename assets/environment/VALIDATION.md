# Step 36C asset validation

Integration is blocked by unsuitable furniture artwork. No scenes, gameplay scripts,
collisions, or project settings were changed during this extraction. Both source ZIPs
remain in the project root. Godot was not launched and no tests were run.

## Extracted organization

- Step 36B is the preferred source: `tiles/floors/`, `tiles/walls/`,
  `tiles/atlas_32.png`, `furniture/`, `references/`, `asset_manifest.json`, and `README.txt`.
- Step 36A's distinct reference and README are in `references/prototypes/`.
- Step 36A's 14 floor samples and two atlases already exist byte-for-byte in
  `res://assets/tiles/`; its source sheet already exists at
  `res://assets/reference/source_asset_sheet.png`. These were reused without copies.
- Step 36B `wall_corner_inner.png` is byte-identical to `wall_left_cap.png`;
  `wall_right_cap.png` is byte-identical to `wall_corner_outer.png`. Only one file per
  identical pair was extracted. The original manifest is preserved unchanged; these
  aliases must be considered before using its original archive paths.

## Tile findings

- Individual floor/wall PNGs are 32 by 32 pixels. The combined atlas is 256 by 32
  pixels, an aligned eight-column grid.
- Wood samples repeat with aligned plank lines, but the small grain marks form an
  obvious repeating pattern. Some pixels have alpha 190 rather than full opacity;
  the floor appearance therefore depends on the backing color. Request opaque
  production exports before replacing the existing floor.
- Wall strips can serve as prototypes, but the duplicated cap/corner art does not
  provide a complete distinct set of directional corners and end pieces.
- Approved concept images are references, not tile atlases or furniture sheets.

## Furniture blockers

The manifest itself calls these draft crops and warns about retained surrounding
art. Partial transparency does not make them clean isolated sprites.

- Desk: adjacent props and background remain in the crop.
- Chair: desk underside, neighboring leg, and background remain.
- Plant: includes a visible PLANTS label and neighboring illustration fragments.
- Rug: multiple sample rectangles and baked diagonal lighting, not a single rug.
- Sink, fridge, and bookshelf: surrounding illustration/background is retained.
- Bed and coffee table also require clean isolated exports with consistent edges,
  lighting, and perspective before integration.
- Furniture dimensions vary from 99 by 97 to 255 by 139 pixels (bed: 127 by 187).
  Manifest bottom-center origin suggestions are available, but they cannot establish
  a reliable ground contact point for contaminated crops.
- No matching clean/messy state variants are supplied.

## Needed before integration

Provide isolated transparent sprites for bed, desk, chair, sink, fridge, bookshelf,
plant, and rug, with consistent top-down perspective and pixel density. Remove
labels, adjacent objects, background residue, and directional baked floor lighting.
Supply reliable ground-contact origins and either compatible messy-state artwork or
clear space for the existing procedural mess overlays. Supply opaque seamless wood
tiles and distinct wall caps/corners. Existing functional furniture and state visuals
remain available unchanged until those assets pass validation.
