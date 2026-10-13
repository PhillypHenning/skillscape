# Sounds

Put the jingles here as `.ogg` files. The add-on plays `<skill>.ogg`, and falls back to `levelup.ogg` when a file is missing.

| File | Plays for |
| --- | --- |
| `levelup.ogg` | **Fallback for everything.** Add at least this one. |
| `herblore.ogg` | Alchemy |
| `farming.ogg` | Herbalism |
| `mining.ogg` | Mining |
| `smithing.ogg` | Blacksmithing |
| `construction.ogg` | Engineering |
| `crafting.ogg` | Tailoring, Leatherworking, Jewelcrafting |
| `runecraft.ogg` | Enchanting |
| `magic.ogg` | Inscription, Wands |
| `hunter.ogg` | Skinning |
| `cooking.ogg` | Cooking |
| `fishing.ogg` | Fishing |
| `hitpoints.ogg` | First Aid |
| `thieving.ogg` | Lockpicking |
| `slayer.ogg` | Archaeology |
| `combat.ogg` | Character level-up |
| `attack.ogg` | Melee weapon skills (if enabled) |
| `defence.ogg` | Defense (if enabled) |
| `ranged.ogg` | Bows, Guns, Crossbows, Thrown (if enabled) |
| `strength.ogg` | Unarmed (if enabled) |

WoW only plays files that existed when the game started. After adding files, **restart the game**; `/reload` isn't enough.

Convert with e.g. `ffmpeg -i input.mp3 -c:a libvorbis -q:a 5 cooking.ogg`.
