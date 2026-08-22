local APP = { NAME = "S4FUNGG", VERSION = "909.2", DEVELOPER = "@Script4Fun" }
local FREE_GAMES = { 
{ name = "Soccer Battle: PvP Football", version = "Latest Supported", updateMode = "Automatic", id = "soccer_battle" }, --1
{ name = "Let's Go! Rain: Cute Idle RPG", version = "Latest Supported", updateMode = "Automatic", id = "lets_go_rain" }, --2
{ name = "MaskGun: FPS Shooting Gun Game", version = "Latest Supported", updateMode = "Automatic", id = "mask_gun" }, --3
{ name = "Idle Hunter: Eternal Soul", version = "Latest Supported", updateMode = "Automatic", id = "idle_hunter_ethernal_soul" }, --4
{ name = "Guns of Boom: Online PvP Action", version = "Latest Supported", updateMode = "Automatic", id = "guns_of_boom" }, --5
{ name = "Loot Heroes: Fantasy RPG Games", version = "Latest Supported", updateMode = "Automatic", id = "loot_heroes" }, --6
{ name = "Kuboom 3D: FPS Shooting Games", version = "Latest Supported", updateMode = "Automatic", id = "kuboom" }, --7
{ name = "Counter Attack: Multiplayer FPS", version = "Latest Supported", updateMode = "Automatic", id = "counter_attack" }, --8
{ name = "Guild of Heroes: Adventure RPG", version = "Latest Supported", updateMode = "Automatic", id = "guild_of_heroes" }, --9
{ name = "Valkyrie Idle", version = "Latest Supported", updateMode = "Automatic", id = "valkyrie_idle" }, --10
{ name = "Off the Road 2", version = "1.1.2", updateMode = "Manual", id = "otr_2" }, --11
{ name = "Knightfall: Kingdom Frontier TD", version = "Latest Supported", updateMode = "Automatic", id = "knightfall_kingdom_frontier_td" }, --12
{ name = "Monster Slayer: Idle RPG", version = "Latest Supported", updateMode = "Automatic", id = "monster_slayer_idle_rpg" }, --13
{ name = "Blockfield: PvP Pixel Shooter", version = "Latest Supported", updateMode = "Automatic", id = "block_field" }, --14
{ name = "Pocket Pet", version = "Latest Supported", updateMode = "Automatic", id = "pocket_pet" }, --15
{ name = "Mech Arena: Shooting Game", version = "Latest Supported", updateMode = "Automatic", id = "mech_arena" }, --16
{ name = "AFK Dragon: Gacha RPG", version = "Latest Supported", updateMode = "Automatic", id = "afk_dragon" }, --17
{ name = "FRAG Pro Shooter", version = "Latest Supported", updateMode = "Automatic", id = "frag_pro_shooter" }, --18
{ name = "RPG Aero Tales Online: MMORPG", version = "Latest Supported", updateMode = "Automatic", id = "aero_tales" }, --19
{ name = "Dead God Land: Survival Games", version = "Latest Supported", updateMode = "Automatic", id = "dead_god_land" }, --20
{ name = "Monster: Hunter Legend", version = "Latest Supported", updateMode = "Automatic", id = "monster_hunter_legend" }, --21
{ name = "Boom Karts: Multiplayer Racing", version = "Latest Supported", updateMode = "Automatic", id = "boom_karts" } --22
}
local PREMIUM_GAMES = { 
{ name = "Animals & Coins: Animal Run", version = "Latest Supported", updateMode = "Automatic", id = "animals_coins" }, --23
{ name = "Polywar 3D: FPS Online Shooter", version = "Latest Supported", updateMode = "Automatic", id = "polywar" }, --24
{ name = "Battle Guys: Royale", version = "Latest Supported", updateMode = "Automatic", id = "battle_guys" }, --25
{ name = "LunaM: PH", version = "Latest Supported", updateMode = "Automatic", id = "luna_m_ph" }, --26
{ name = "Forward Assault", version = "Latest Supported", updateMode = "Automatic", id = "forward_assault" }, --27
{ name = "Grim Soul: Dark Survival RPG", version = "Latest Supported", updateMode = "Automatic", id = "grim_soul" }, --28
{ name = "Castle Defense Online", version = "Latest Supported", updateMode = "Automatic", id = "castle_defense_online" }, --29
{ name = "Urban Heat", version = "Latest Supported", updateMode = "Automatic", id = "urban_heat" }, --30
{ name = "Travel Town: Merge Adventure", version = "Latest Supported", updateMode = "Automatic", id = "travel_town" }, --31
{ name = "Time Master", version = "Latest Supported", updateMode = "Automatic", id = "time_master" }, --32
{ name = "Dead Impact: Survival Online", version = "Latest Supported", updateMode = "Automatic", id = "dead_impact" }, --33
{ name = "DomiNations", version = "Latest Supported", updateMode = "Automatic", id = "dominations" }, --34
{ name = "Gods of Olympus", version = "6.5.35138", updateMode = "Manual", id = "gods_of_olympus" }, --35
{ name = "Mutiny: Pirate Survival RPG", version = "Latest Supported", updateMode = "Automatic", id = "mutiny" }, --36
{ name = "Left to Survive: Zombie Games", version = "Latest Supported", updateMode = "Automatic", id = "left_to_survive" }, --37
{ name = "OneState RP: Role Play Life", version = "1.2.0", updateMode = "Manual", id = "onestate" }, --38
{ name = "League of War: Mercenaries", version = "Latest Supported", updateMode = "Automatic", id = "league_of_war" }, --39
{ name = "Mob Rush", version = "Latest Supported", updateMode = "Automatic", id = "mob_rush" } --40
}

table.sort(FREE_GAMES, function(a, b) return string.lower(a.name) < string.lower(b.name) end)
table.sort(PREMIUM_GAMES, function(a, b) return string.lower(a.name) < string.lower(b.name) end)
local ALL_GAMES = {}
for _, v in ipairs(FREE_GAMES) do table.insert(ALL_GAMES, v) end
for _, v in ipairs(PREMIUM_GAMES) do table.insert(ALL_GAMES, v) end
table.sort(ALL_GAMES, function(a, b) return string.lower(a.name) < string.lower(b.name) end)
local function toast(msg) gg.toast(msg) end
local function header()
return "• Ⓜ️ Application: " .. APP.NAME .. "\n" ..
"• ♻️ Version: " .. APP.VERSION .. "\n" ..
"• 📚 Total Scripts: " .. #ALL_GAMES .. "\n" ..
"• 👤 Developer: " .. APP.DEVELOPER
end