# Hogwarts Floating Candles

Standalone Asuna / Luanti mod. Two ivory candles with animated flames,
maximum node light, no holder, no support requirement and no fuel consumption.
The existing Hogwarts Beams mod does not need to be replaced or changed.

## Install

1. Quit your world.
2. Unzip `hogwarts_candles.zip`.
3. Put the folder `hogwarts_candles` inside your Luanti user data `mods` folder.
   The final path must end in `mods/hogwarts_candles/mod.conf`.
4. Select your Asuna world and open **Select mods / Configure**.
5. Enable `hogwarts_candles`, then start the world.
6. In Creative inventory, search **Hogwarts Floating Candle**.

Use the same mods directory where you installed `hogwarts_beams`. On many Mac
installations it is `~/Library/Application Support/minetest/mods/`; if your
installation uses another data directory, keep using its existing mods folder.
This is a regular world/server mod, not a client-side mod.

## Place candles

### In empty air (quickest)

Hold a candle, fly to the desired area and **right-click while aiming at empty
air**. It places a candle at the nearest grid cell approximately **four blocks
in front of your eyes**. Aim where you want the candle, rather than at an
existing block. If you aim at a block within reach, ordinary node placement
applies instead. Move/aim differently to scatter them at different heights.

The target must be loaded, empty air and unprotected. The mod does not replace
blocks, water, plants, existing candles or beams when placing directly in air.
The player must have the `interact` privilege. Coordinates snap to the block
grid, so the exact distance varies slightly with rounding.

### With temporary blocks

Place a temporary block, place the candle on top, and remove the block.
It stays suspended. Candles always stand upright, even when placed against
a side or ceiling. They can also be used as table candles.

## Brightness and appearance

- Both Tall and Short versions emit **light level 14** (`minetest.LIGHT_MAX`),
  the maximum normal node light supported by Luanti.
- They remain lit permanently, with an eight-frame animated flame.
- The light level is steady. Only the flame texture flickers.
- They have no falling or attached-to-support behavior.
- Players can move through them. Point at the wax/flame area and dig to remove.
- The flame is decorative and deals no damage; these candles do not register
  fire-spreading behavior.
- A candle stack holds up to 99 items. Creative placement does not consume it;
  survival placement consumes one.

Maximum light is not unlimited range. Light fades with distance and walls/roof
blocks occlude it. For a large hall, distribute candles over the tables and
between the trusses at several heights. A candle near the ceiling alone will
not floodlight a floor far below it. Ordinary node lighting does not add
colored orange light just because the flame texture is orange.

## Get a full stack

With the `give` privilege, enter these chat commands:

```
/giveme hogwarts_candles:candle_tall 99
/giveme hogwarts_candles:candle_short 99
```

The two sizes can be converted into each other one-for-one in a crafting grid.
There is no base survival crafting recipe: this mod is intended for your
Creative castle build and does not depend on Asuna-specific wax or torch IDs.

## Compatibility and validation

Targets Luanti / Minetest 5.4+ with no required mods. All textures and meshes
are original; see LICENSE.txt. The mod uses ordinary persistent world nodes,
so candles do not rely on temporary entities or recurring timers.

Lua syntax and mocked-API behavior checks passed for both candle types:
maximum light, absence of support/falling groups, direct-air placement,
negative coordinates, survival and Creative consumption, protection, interact
privilege, blocked/unloaded targets and size-conversion recipes. Mesh extents,
UVs and animation image dimensions were also checked.

A live Asuna rendering test was not available here. Place one candle in a dark
area, remove any scaffolding, and reload the world to check appearance and
persistence before filling the entire hall. Keep the mod enabled after using
its candles, or the world will show unknown nodes where they were placed.

## Included source

- init.lua — node definitions and safe air-placement control.
- models/ — upright candle geometry.
- textures/ — wax, flame strip and combined animation atlas.
- source/generate_assets.py — reproducible assets, requires Python + Pillow.
- source/test_mod.lua — mocked behavior checks, run from the mod folder with
  `texlua source/test_mod.lua .` (Lua 5.3) or another compatible Lua interpreter.

References:
https://api.luanti.org/definition-tables/
https://api.luanti.org/groups/
