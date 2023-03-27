# Bonemeal

**Name**: `bonemeal`

This mod adds four new items into the game, bones which can be dug from normal
dirt which can be made into bonemeal, mulch which is is crafted using a tree
and 8x leaves, and fertiliser which is a mixture of them both.

Each item can be used on saplings and crops for a chance to grow them quicker
as well as dirt which will generate random grass, flowers or whichever
decoration is registered.

Mulch has a strength of 1, Bonemeal 2 and Fertiliser 3. This means the stronger
the item, the more chance of growing saplings in low light, making crops sprout
quicker or simply decorate a larger area with grass and flowers.

The [`api.txt`](https://notabug.org/TenPlus1/bonemeal/src/master/api.txt)
document shows how to add your own saplings, crops and grasses to the list by
using one of the 3 commands included and the mod.lua file gives you many
examples by using some of the popular mods available.

https://forum.minetest.net/viewtopic.php?f=9&t=16446

**Lucky Blocks**: 6

## Changelog

### Version 0.1

* Initial release

### Version 0.2

* Added global `on_use` function for bonemeal growth

### Version 0.3

* Added strength to `on_use` global for new items (mulch and fertiliser)

### Version 0.4

* Added `Intllib` support and `fr.txt` file for French translation.

### Version 0.5

* Added support for default bush and acacia bush saplings

### Version 0.6

* Using newer functions. This means Minetest 0.4.16 and above needed to run

### Version 0.7

* Can be used on papyrus and cactus now
* Added coral recipe
* API addition

### Version 0.8

* Added support for farming redo's new garlic
* Added pepper and onion crops

### Version 0.9

* Added support for farming redo's pea and beetroot crops
* Checks for `place_param`

### Version 1.0

* `add_deco()` now adds to existing item list while `set_deco()` replaces item
  list (thanks `h-v-smacker`)

### Version 1.1

* Added `{can_bonemeal=1}` group for special nodes

### Version 1.2

* Added support for Minetest 5.0 cactus seedling, blueberry bush sapling and
  emergent jungle tree saplings, additional flowers and pine bush sapling

### Version 1.3

* Added ability to craft dye from mulch, bonemeal and fertiliser (thanks
  `orbea`)

### Version 1.4

* Added support for fern saplings from `plantlife` mod (thanks `nixnoxus`)

### Version 1.5

* Added support for farming redo's asparagus, eggplant, spinach

### Version 1.6

* Added helper function for position and protection check
* Added ginger support
