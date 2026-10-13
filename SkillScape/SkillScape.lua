local ADDON_NAME, ns = ...

local SOUND_DIR = "Interface\\AddOns\\" .. ADDON_NAME .. "\\Sounds\\"
local FALLBACK_SOUND = "levelup"
local THROTTLE_SECONDS = 2

local defaults = {
	enabled = true,
	professions = true, -- primary and secondary professions
	combatSkills = false, -- weapon skills and Defense: these level constantly on classic-era rules
	characterLevel = true,
	popup = true,
	chat = true,
	channel = "Master",
}

-- WoW skill → the RuneScape skill whose jingle plays (Sounds/<skill>.ogg).
-- Anything unmapped plays Sounds/levelup.ogg.
local PROFESSIONS = {
	["Alchemy"] = "herblore",
	["Herbalism"] = "farming",
	["Mining"] = "mining",
	["Blacksmithing"] = "smithing",
	["Engineering"] = "construction",
	["Tailoring"] = "crafting",
	["Leatherworking"] = "crafting",
	["Jewelcrafting"] = "crafting",
	["Enchanting"] = "runecraft",
	["Inscription"] = "magic",
	["Skinning"] = "hunter",
	["Cooking"] = "cooking",
	["Fishing"] = "fishing",
	["First Aid"] = "hitpoints",
	["Lockpicking"] = "thieving",
	["Archaeology"] = "slayer",
}

local COMBAT_SKILLS = {
	["Defense"] = "defence",
	["Bows"] = "ranged",
	["Guns"] = "ranged",
	["Crossbows"] = "ranged",
	["Thrown"] = "ranged",
	["Wands"] = "magic",
	["Unarmed"] = "strength",
}
local COMBAT_DEFAULT = "attack" -- swords, axes, maces, daggers, staves, …

-- Builds a Lua pattern from a Blizzard format string such as
-- "Your skill in %s has increased to %d." so it works in any client language.
local function FormatToPattern(format)
	local escaped = format:gsub("([%(%)%.%%%+%-%*%?%[%]%^%$])", "%%%1")
	escaped = escaped:gsub("%%%%s", "(.+)")
	escaped = escaped:gsub("%%%%d", "(%%d+)")
	return "^" .. escaped .. "$"
end

local SKILL_UP_PATTERN = FormatToPattern(ERR_SKILL_UP_SI or "Your skill in %s has increased to %d.")

local db
local lastPlayed = 0

local function IsSecret(value)
	return issecretvalue ~= nil and issecretvalue(value) or false
end

local function PlayJingle(sound)
	if not db.enabled then return end
	-- Several skill-ups in a row (crafting a stack) play one jingle, not twenty.
	local now = GetTime()
	if now - lastPlayed < THROTTLE_SECONDS then return end
	lastPlayed = now
	local willPlay = PlaySoundFile(SOUND_DIR .. sound .. ".ogg", db.channel)
	if not willPlay and sound ~= FALLBACK_SOUND then
		PlaySoundFile(SOUND_DIR .. FALLBACK_SOUND .. ".ogg", db.channel)
	end
end

function ns.Celebrate(skillName, level, sound)
	PlayJingle(sound)
	local article = skillName:match("^[AEIOUaeiou]") and "an" or "a"
	local title = ("Congratulations, you just advanced %s %s level."):format(article, skillName)
	local detail = ("Your %s level is now %d."):format(skillName, level)
	if level == 99 then
		detail = detail .. " Time to buy the cape."
	end
	if db.chat then
		print("|cff4040ffSkillScape|r: " .. title .. " " .. detail)
	end
	if db.popup then
		ns.ShowPopup(title, detail)
	end
end

local function OnSkillMessage(message)
	if IsSecret(message) then return end -- chat can be secret in combat on newer clients
	local skillName, level = message:match(SKILL_UP_PATTERN)
	if not skillName then return end
	level = tonumber(level)

	local sound = PROFESSIONS[skillName]
	if sound then
		if db.professions then ns.Celebrate(skillName, level, sound) end
	elseif db.combatSkills then
		ns.Celebrate(skillName, level, COMBAT_SKILLS[skillName] or COMBAT_DEFAULT)
	end
end

local function OnLevelUp(level)
	if db.characterLevel and not IsSecret(level) then
		ns.Celebrate("Combat", level, "combat")
	end
end

-- Slash commands -----------------------------------------------------------------

local TOGGLES = {
	professions = "profession skill-ups",
	combat = "weapon/Defense skill-ups",
	level = "character level-ups",
	popup = "the level-up box",
	chat = "chat messages",
}
local TOGGLE_KEYS = { professions = "professions", combat = "combatSkills", level = "characterLevel", popup = "popup", chat = "chat" }

local function PrintHelp()
	print("|cff4040ffSkillScape|r commands:")
	print("  /skillscape on | off")
	print("  /skillscape test [skill] - e.g. /skillscape test Cooking")
	for key, label in pairs(TOGGLES) do
		print(("  /skillscape %s - toggle %s (%s)"):format(key, label, db[TOGGLE_KEYS[key]] and "on" or "off"))
	end
end

SLASH_SKILLSCAPE1 = "/skillscape"
SLASH_SKILLSCAPE2 = "/ss"
SlashCmdList.SKILLSCAPE = function(msg)
	local command, arg = msg:match("^%s*(%S*)%s*(.-)%s*$")
	command = command:lower()
	if command == "on" or command == "off" then
		db.enabled = command == "on"
		print("|cff4040ffSkillScape|r " .. (db.enabled and "enabled" or "disabled") .. ".")
	elseif command == "test" then
		local skill = arg ~= "" and arg or "Cooking"
		lastPlayed = 0
		ns.Celebrate(skill, 99, PROFESSIONS[skill] or COMBAT_SKILLS[skill] or FALLBACK_SOUND)
	elseif TOGGLE_KEYS[command] then
		local key = TOGGLE_KEYS[command]
		db[key] = not db[key]
		print(("|cff4040ffSkillScape|r %s %s."):format(TOGGLES[command], db[key] and "on" or "off"))
	else
		PrintHelp()
	end
end

-- Events -------------------------------------------------------------------------

local frame = CreateFrame("Frame")
frame:RegisterEvent("ADDON_LOADED")
frame:RegisterEvent("CHAT_MSG_SKILL")
frame:RegisterEvent("PLAYER_LEVEL_UP")
frame:SetScript("OnEvent", function(_, event, arg1)
	if event == "ADDON_LOADED" then
		if arg1 == ADDON_NAME then
			SkillScapeDB = SkillScapeDB or {}
			for key, value in pairs(defaults) do
				if SkillScapeDB[key] == nil then
					SkillScapeDB[key] = value
				end
			end
			db = SkillScapeDB
		end
	elseif event == "CHAT_MSG_SKILL" then
		OnSkillMessage(arg1)
	elseif event == "PLAYER_LEVEL_UP" then
		OnLevelUp(arg1)
	end
end)
