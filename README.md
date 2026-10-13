# SkillScape

Every profession skill-up deserves a RuneScape level-up.

When a profession goes up, SkillScape plays a RuneScape-style jingle for the matching skill (Cooking → Cooking, Blacksmithing → Smithing, Alchemy → Herblore…). It shows the familiar box with "Congratulations, you just advanced a Cooking level." and *Click here to continue*, and prints the message in chat. Reaching 99 in anything gets the obvious advice.

## Features

- Jingle per profession, with a fallback sound for anything unmapped
- RuneScape-style level-up box (click to dismiss, fades on its own)
- Character level-ups count as Combat level-ups
- Optional weapon/Defense skill-ups (off by default; on classic-era rules they'd never stop)
- Crafting a stack plays one jingle, not twenty
- Works in any client language: skill-ups are detected from Blizzard's own message format. Skill-to-jingle mapping is English for now; other languages use the fallback sound.

## Commands

| Command | Does |
| --- | --- |
| `/skillscape` or `/ss` | Help and current settings |
| `/ss on` / `/ss off` | Enable / disable |
| `/ss test [skill]` | Preview, e.g. `/ss test Fishing` |
| `/ss professions` | Toggle profession skill-ups |
| `/ss combat` | Toggle weapon/Defense skill-ups |
| `/ss level` | Toggle character level-ups |
| `/ss popup` | Toggle the level-up box |
| `/ss chat` | Toggle chat messages |

## Sounds

See [`SkillScape/Sounds/README.md`](SkillScape/Sounds/README.md) for file names. RuneScape and its music are © Jagex; this is a non-commercial fan project and isn't affiliated with or endorsed by Jagex or Blizzard.

## Development

The `SkillScape/` folder is the add-on. Link or copy it into `World of Warcraft\<client>\Interface\AddOns\`. Releases are packaged with the [BigWigs packager](https://github.com/BigWigsMods/packager) via `.pkgmeta`.

## License

Code: MIT (see `LICENSE`). Sound files are not covered by this license.
