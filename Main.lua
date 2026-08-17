

local target_url = "https://raw.githubusercontent.com/Script4Funs/G.LIST/refs/heads/main/Loader.lua"
local requestSuccess, response = pcall(function()
return gg.makeRequest(target_url)
end)

if not requestSuccess then
gg.alert(
"⚠️ SERVICE TEMPORARILY UNAVAILABLE\n\n" ..
"We are currently unable to connect to the script server.\n\n" ..
"This may be caused by a temporary server or network issue.\n\n" ..
"Please wait a few minutes and try again. If the issue continues, " ..
"please wait a few hours before trying again.\n\n" ..
"Your account and key are not affected."
)
os.exit()
end

if not response or response.code ~= 200 then
gg.alert(
"⚠️ SERVICE TEMPORARILY UNAVAILABLE\n\n" ..
"The script server is currently unable to provide a valid response.\n\n" ..
"Please wait a few minutes and try again. If the issue persists, " ..
"please try again after a few hours.\n\n" ..
"Your account and key remain unaffected."
)
os.exit()
end

if not response.content or response.content == "" then
gg.alert(
"⚠️ DATA RETRIEVAL FAILED\n\n" ..
"The latest script data could not be retrieved from the server.\n\n" ..
"This is most likely a temporary server issue.\n\n" ..
"Please wait a few minutes and try again. If the issue continues, " ..
"please try again after a few hours.\n\n" ..
"Your account and key remain unaffected."
)
os.exit()
end

local T = response.content

local func, compileError = load(T)

if not func then
gg.alert(
"⚠️ SCRIPT UPDATE ERROR\n\n" ..
"The latest script data was retrieved, but it could not be processed correctly.\n\n" ..
"Please wait a few minutes and try again.\n\n" ..
"If the issue persists after a few hours, please contact support."
)
os.exit()
end

local executionSuccess, executionError = pcall(func)

if not executionSuccess then
gg.alert(
"⚠️ SCRIPT EXECUTION ERROR\n\n" ..
"The latest script data could not be executed correctly.\n\n" ..
"Please wait a few minutes and try again.\n\n" ..
"If the issue continues after a few hours, please contact support."
)
os.exit()
end
local DB = "https://system-keys-default-rtdb.asia-southeast1.firebasedatabase.app"
local ANIMALS_ICON = "/sdcard/Download/Icons/animals_coins.png"

local iconFile = io.open(ANIMALS_ICON, "rb")

if iconFile then
    iconFile:close()
    gg.alert(
        "✅ IMAGE FOUND\n\n" ..
        "Animals & Coins logo was detected successfully.\n\n" ..
        "Path:\n" .. ANIMALS_ICON,
        "CONTINUE"
    )
else
    gg.alert(
        "❌ IMAGE NOT FOUND\n\n" ..
        "The Animals & Coins logo could not be found.\n\n" ..
        "Expected path:\n" .. ANIMALS_ICON,
        "OK"
    )
end
local SAVE_FILE = gg.EXT_FILES_DIR .. "/NeuralInvocationAdaptationProcessingFramework.arsc"
local DEVICE_FILE = gg.EXT_FILES_DIR .. "/TemporalOverrideSynchronizationCommandInterface.arsc"
local savedKey = ""
local f = io.open(SAVE_FILE, "r")
if f then
savedKey = f:read("*a")
f:close()
end
local function generateSessionId(deviceId)
local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
local rand = ""
for i = 1, 4 do
local r = math.random(#chars)
rand = rand .. chars:sub(r, r)
end
return deviceId:sub(1, 6) .. "-" .. os.time() .. "-" .. rand
end
local function alertInvalid()
gg.alert(
"⛔ AUTHENTICATION FAILED\n\n" ..
"The provided license key is invalid or unrecognized.\n" ..
"Access has been denied by the security system.\n\n" ..
"Please verify your credentials and try again.",
"OKAY"
)
end
local function alertWrongGame(gameName)
gg.alert(
"🚫 ACCESS DENIED\n\n" ..
"This license key is not authorized for the selected application.\n" ..
"Application: " .. gameName .. "\n\n" ..
"Please use a valid key assigned to this product.",
"OKAY"
)
end
local function alertDisabled()
gg.alert(
"⛔ LICENSE REVOKED\n\n" ..
"This license key has been disabled by the developer.\n" ..
"All access privileges have been terminated.\n\n" ..
"Please contact support if you believe this is an error.",
"OKAY"
)
end
local function alertExpired(expire)
gg.alert(
"⌛ LICENSE EXPIRED\n\n" ..
"This license has expired and is no longer valid.\n" ..
"Expiration Date: " .. expire .. "\n\n" ..
"Please renew your subscription to restore access.",
"OKAY"
)
end
local function alertError()
gg.alert(
"🌐 NETWORK ERROR\n\n" ..
"Unable to connect to the authentication server.\n" ..
"Please check your internet connection and try again.",
"OKAY"
)
end
local function alertSuccess(gameName, deviceId, plan)
local sessionId = generateSessionId(deviceId)
gg.alert(
"🔐 AUTHORIZATION SUCCESSFUL\n\n" ..
"🎮 Game: " .. gameName .. "\n" ..
"🎟️ Premium: " .. plan .. "\n\n" ..
"🆔 Session ID: " .. sessionId .. "\n" ..
"📱 Device: " .. deviceId:sub(1, 6) .. "****\n" ..
"⏱️ Verified: " .. os.date("%Y-%m-%d %H:%M:%S"),
"CONTINUE")
end
function getDeviceId()
local f = io.open(DEVICE_FILE, "r")
if f then
local id = f:read("*a")
f:close()
if id and id ~= "" then
return id
end
end
local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
local id = ""
for i = 1, 16 do
local r = math.random(#chars)
id = id .. chars:sub(r, r)
end
local fw = io.open(DEVICE_FILE, "w")
if fw then
fw:write(id)
fw:close()
end
return id
end
local function extractField(data, field)
return data:match('"' .. field .. '"%s*:%s*"([^"]*)"')
end
local function extractBool(data, field)
local v = data:match('"' .. field .. '"%s*:%s*(%a+)')
return v == "true"
end
local function extractDate(data, field)
return data:match('"' .. field .. '"%s*:%s*"([^"]+)"')
end
local function extractAccess(data)
return extractField(data, "access")
end
local function checkMaintenance()
local res = gg.makeRequest(DB .. "/maintenance.json")
if not res or not res.content or res.content == "null" then
return
end
local data = res.content
local status = extractBool(data, "status")
local message = extractField(data, "message")
if status then
gg.alert(
"📢 SYSTEM MAINTENANCE\n\n" ..
(message or "Please try again later."),
"UNDERSTOOD"
)
os.exit()
end
end
local function parseServerDate(dateStr)
local pattern = "(%a+), (%d+) (%a+) (%d+) (%d+):(%d+):(%d+) GMT"
local _, day, monthStr, year, hour, min, sec = dateStr:match(pattern)
if not day then
return nil
end
local months = {
Jan=1, Feb=2, Mar=3, Apr=4, May=5, Jun=6,
Jul=7, Aug=8, Sep=9, Oct=10, Nov=11, Dec=12
}
return os.time({
year = tonumber(year),
month = months[monthStr],
day = tonumber(day),
hour = tonumber(hour),
min = tonumber(min),
sec = tonumber(sec)
})
end
local function getServerDate()
local urls = {
"http://www.google.com",
"http://www.cloudflare.com",
"http://www.bing.com"
}
for _, url in ipairs(urls) do
local res = gg.makeRequest(url)
if res and res.headers and res.headers["Date"] then
local dateHeader = res.headers["Date"]
if type(dateHeader) == "table" then
dateHeader = dateHeader[1]
end
local t = parseServerDate(dateHeader)
if t then
return os.date("%Y-%m-%d", t)
end
end
end
return nil
end
local function bindDeviceToKey(key, deviceId)
local url = DB .. "/keys/" .. key .. "/device.json"
local headers = {
["Content-Type"] = "application/json",
["X-HTTP-Method-Override"] = "PUT"
}
local result = gg.makeRequest(url, headers, '"' .. deviceId .. '"')
return result and result.code == 200
end
function askKey(gameName)
local key
if savedKey ~= "" then
key = savedKey
else
local p = gg.prompt(
{"🔑 Enter Premium Key", "💾 Save"},
{"", true},
{"text", "checkbox"})
if not p then return false end
key = p[1]
if key ~= "" then
local f = io.open(SAVE_FILE, "w")
if f then
f:write(key)
f:close()
end
savedKey = key
end
end
gg.toast("🔄 Verifying Key...")
local res = gg.makeRequest(DB .. "/keys/" .. key .. ".json")
if not res or not res.content then
alertError()
return false
end
if res.content == "null" then
savedKey = ""
os.remove(SAVE_FILE)
alertInvalid()
return false
end
local data = res.content 
local deviceId = getDeviceId()
local serverDevice = extractField(data, "device")
local status = extractBool(data, "status")
local expire = extractDate(data, "expire")
local function extractPlan(data)
return extractField(data, "plan")
end

local plan = extractPlan(data)
local access = extractAccess(data)
local game = extractField(data, "game")
if not serverDevice or serverDevice == "" then
gg.toast("🔄 Binding device...")
local ok = bindDeviceToKey(key, deviceId)
if not ok then
gg.alert(
"❌ DEVICE BIND FAILED\n\n" ..
"Unable to update license information.",
"OK"
)
return false
end
serverDevice = deviceId
gg.alert(
"📱 DEVICE REGISTERED\n\n" ..
"🆔 Device ID: " .. deviceId .. "\n\n" ..
"✅ License successfully linked.",
"CONTINUE"
)
end
if serverDevice and serverDevice ~= "" and serverDevice ~= deviceId then
savedKey = ""
os.remove(SAVE_FILE)
gg.alert(
"🔒 DEVICE MISMATCH\n\n" ..
"This license is linked to another Device or Virtual\n\n" ..
"Access denied.",
"OK"
)
return false
end
if access ~= "all" and game ~= gameName then
savedKey = ""
os.remove(SAVE_FILE)
alertWrongGame(gameName)
return false
end
if status == false then
alertDisabled()
savedKey = ""
os.remove(SAVE_FILE)
return false
end
local serverDate = getServerDate()
if not serverDate then
gg.alert(
"🌐 SERVER TIME ERROR\n\n" ..
"Unable to verify server time.\n" ..
"Please check your internet connection."
)
return false
end
if plan ~= "Lifetime Access" and expire and expire ~= "" and serverDate > expire then
savedKey = ""
os.remove(SAVE_FILE)
alertExpired(expire)
return false
end

alertSuccess(gameName, deviceId, plan)
return true
end 
local APP = { NAME = "GameHub X", VERSION = "909.2", DEVELOPER = "@Script4Fun" }
local GAME_ICON = "🔸"
local FREE_GAMES = { 
{ name = "Soccer Battle: PvP Football", version = "Auto Update", id = "soccer_battle" }, --1
{ name = "Let's Go! Rain: Cute Idle RPG", version = "Auto Update", id = "lets_go_rain" }, --2
{ name = "MaskGun: FPS Shooting Gun Game", version = "Auto Update", id = "mask_gun" }, --3
{ name = "Idle Hunter: Eternal Soul", version = "Auto Update", id = "idle_hunter_ethernal_soul" }, --4
{ name = "Guns of Boom: Online PvP Action", version = "Auto Update", id = "guns_of_boom" }, --5
{ name = "Loot Heroes: Fantasy RPG Games", version = "Auto Update", id = "loot_heroes" }, --6
{ name = "Kuboom 3D: FPS Shooting Games", version = "Auto Update", id = "kuboom" }, --7
{ name = "Counter Attack: Multiplayer FPS", version = "Auto Update", id = "counter_attack" }, --8
{ name = "Guild of Heroes: Adventure RPG", version = "Auto Update", id = "guild_of_heroes" }, --9
{ name = "Valkyrie Idle", version = "Auto Update", id = "valkyrie_idle" }, --10
{ name = "OTR 2", version = "1.1.2", id = "otr_2" }, --11
{ name = "Knightfall: Kingdom Frontier TD", version = "Auto Update", id = "knightfall_kingdom_frontier_td" }, --12
{ name = "Monster Slayer: Idle RPG", version = "Auto Update", id = "monster_slayer_idle_rpg" }, --13
{ name = "Blockfield: PvP Pixel Shooter", version = "Auto Update", id = "block_field" }, --14
{ name = "Pocket Pet", version = "Auto Update", id = "pocket_pet" }, --15
{ name = "Mech Arena: Shooting Game", version = "Auto Update", id = "mech_arena" }, --16
{ name = "AFK Dragon: Gacha RPG", version = "Auto Update", id = "afk_dragon" }, --17
{ name = "FRAG Pro Shooter", version = "Auto Update", id = "frag_pro_shooter" }, --18
{ name = "RPG Aero Tales Online: MMORPG", version = "Auto Update", id = "aero_tales" }, --19
{ name = "Dead God Land: Survival Games", version = "Auto Update", id = "dead_god_land" }, --20
{ name = "Boom Karts: Multiplayer Racing", version = "Auto Update", id = "boom_karts" } --21
}
local PREMIUM_GAMES = { 
{ name = "Animals & Coins: Animal Run", version = "Auto Update", id = "animals_coins", icon = "Icons/animals_coins.png" }, --22
{ name = "Polywar 3D: FPS Online Shooter", version = "Auto Update", id = "polywar" }, --23
{ name = "Battle Guys: Royale", version = "Auto Update", id = "battle_guys" }, --24
{ name = "LunaM: PH", version = "Auto Update", id = "luna_m_ph" }, --25
{ name = "Forward Assault", version = "Auto Update", id = "forward_assault" }, --26
{ name = "Grim Soul: Dark Survival RPG", version = "Auto Update", id = "grim_soul" }, --27
{ name = "Castle Defense Online", version = "Auto Update", id = "castle_defense_online" }, --28
{ name = "Urban Heat", version = "Auto Update", id = "urban_heat" }, --29
{ name = "Travel Town: Merge Adventure", version = "Auto Update", id = "travel_town" }, --30
{ name = "Time Master", version = "Auto Update", id = "time_master" }, --31
{ name = "Dead Impact: Survival Online", version = "Auto Update", id = "dead_impact" }, --32
{ name = "DomiNations", version = "Auto Update", id = "dominations" }, --33
{ name = "Gods Of Olympus", version = "6.5.35138", id = "gods_of_olympus" }, --34
{ name = "Mutiny: Pirate Survival RPG", version = "Auto Update", id = "mutiny" }, --35
{ name = "Left To Survive: Zombie Games", version = "Auto Update", id = "left_to_survive" }, --36
{ name = "OneState RP: Role Play Life", version = "1.2.0", id = "onestate" }, --37
{ name = "League Of War: Mercenaries", version = "Auto Update", id = "league_of_war" }, --38
{ name = "Mob Rush", version = "Auto Update", id = "mob_rush" } --39
}
table.sort(FREE_GAMES, function(a, b) return string.lower(a.name) < string.lower(b.name) end)
table.sort(PREMIUM_GAMES, function(a, b) return string.lower(a.name) < string.lower(b.name) end)
local ALL_GAMES = {}
for _, v in ipairs(FREE_GAMES) do table.insert(ALL_GAMES, v) end
for _, v in ipairs(PREMIUM_GAMES) do table.insert(ALL_GAMES, v) end
table.sort(ALL_GAMES, function(a, b) return string.lower(a.name) < string.lower(b.name) end)
local function toast(msg) gg.toast(msg) end
local function header() 
return "Ⓜ️ • Application: " .. APP.NAME .. "\n" ..
"✳️ • Version: " .. APP.VERSION .. "\n" ..
"👤 • Owner: " .. APP.DEVELOPER 
end
function loading()
for i = 1, 10 do
local percent = i * 10
gg.toast("⚙️ Preparing... " .. percent .. "%")
gg.sleep(300)
end
end
function getSecureLink(gameId)
local res = gg.makeRequest(DB .. "/links/" .. gameId .. ".json")
if not res or not res.content or res.content == "null" then
return nil
end
local cleanUrl = res.content:match('^"(.*)"$') or res.content
return cleanUrl
end
function loadScript(url, name)
loading(name)
gg.toast("⬇️ Fetching " .. name)
local res = gg.makeRequest(url)
if not res or not res.content then
gg.alert("❌ Failed to load \"" .. name .. "\"\n\n⚠️ Please try again later.")
return
end
gg.toast("⚙️ Compiling " .. name)
local func, err = load(res.content)
if not func then
gg.alert("❌ Script Load Failed\n\n" .. tostring(err))
return
end
gg.toast("✅ " .. name .. " Loaded Successfully")
pcall(func)
end
local function toTitleCase(str)
return (str:gsub("(%a)([%w_']*)", function(first, rest)
return first:upper() .. rest:lower()
end))
end
function openGameMenu(gameList)
local list = {}

for _, v in ipairs(gameList) do
    if v.icon then
        local iconPath = "/sdcard/Download/" .. v.icon

        table.insert(
            list,
            "<img src='" .. iconPath .. "'>" .. v.name .. "</img>"
        )
    else
        table.insert(list, GAME_ICON .. " " .. v.name)
    end
end

table.insert(list, "B A C K")

local c = gg.choice(list, nil, header())
if not c or c == #list then
mainMenu()
return
end
local game = gameList[c]
local gameType = "Free"
for _, v in ipairs(PREMIUM_GAMES) do
if v.name == game.name then
gameType = "Premium"
break
end
end
local icon = "🎮 • "
local sub = gg.choice({
"📢 Information",
"⭕ Run Script",
"B A C K"
}, nil,
icon .. "Name: " .. toTitleCase(game.name) .. "\n" ..
"🔄 • Version: " .. game.version .. "\n" ..
"👾 • Type: " .. gameType
)
if sub == 1 then
gg.alert("ℹ️ GAME INFORMATION\n\n" ..
"🎮 Game: " .. game.name .. "\n" ..
"🔄 Version: " .. game.version .. "\n\n" ..
"🚀 GAMEHUB X LOADER\n" ..
"GameHub X is the official all-in-one loader for S4FUNGG scripts. Every script is built directly into the loader and is automatically kept up to date, ensuring a seamless, secure, and reliable experience.\n\n" ..
"⭐ HIGHLIGHTS\n" ..
"• Built-in Script Library\n" ..
"• Automatic Script Updates\n" ..
"• Secure Script Management\n" ..
"• Fast & Optimized Loading\n" ..
"• Stable Performance\n\n" ..
"📖 QUICK START\n" ..
"1. Select 'Run Script'.\n" ..
"2. Wait for the loading process to complete.\n" ..
"3. Follow the on-screen instructions.\n\n" ..
"⚠️ IMPORTANT\n" ..
"• Use this script responsibly.\n" ..
"• Features may vary depending on the game version.\n" ..
"• No manual script updates are required—GameHub X automatically keeps everything up to date.\n\n" ..
"💬 SUPPORT & COMMUNITY\n" ..
"👤 Developer: " .. APP.DEVELOPER .. "\n" ..
"📨 Telegram: @Script4Fun\n" ..
"📢 Telegram Channel: https://t.me/ScriptForFun\n" ..
"▶️ YouTube: https://www.youtube.com/@S4FUNGG",
"B A C K")

openGameMenu(gameList)
elseif sub == 2 then
local isPremium = false
for _, v in ipairs(PREMIUM_GAMES) do
if v.name == game.name then
isPremium = true
break
end
end
if isPremium then
if askKey(game.name) then
local secureUrl = getSecureLink(game.id)
if secureUrl then loadScript(secureUrl, game.name) else gg.alert("❌ Error: Path not found.") end
end
else
local secureUrl = getSecureLink(game.id)
if secureUrl then loadScript(secureUrl, game.name) else gg.alert("❌ Error: Path not found.") end
end
elseif sub == 3 then
openGameMenu(gameList)
end
end
function searchGame()
local p = gg.prompt({"🔎 • Search Game Name:"}, {""}, {"text"})
if not p then return mainMenu() end
local key = string.lower(p[1])
local list = {}
local map = {}
for i, v in ipairs(ALL_GAMES) do
if string.find(string.lower(v.name), key) then
table.insert(list, GAME_ICON .. " " .. v.name)
table.insert(map, i)
end
end
if #list == 0 then
gg.alert("🔎 SEARCH COMPLETED\n\n❌ No matching game was found.\n\nThis game may not have been added to the database yet, or the search keyword is incorrect.\n\nPlease try again using a different keyword.")
return mainMenu()
end
table.insert(list, "B A C K")
local c = gg.choice(list, nil, "🗨️ • Search Result:")
if not c or c == #list then return mainMenu() end
local game = ALL_GAMES[map[c]]

local isPremium = false
for _, v in ipairs(PREMIUM_GAMES) do
if v.name == game.name then
isPremium = true
break
end
end

if isPremium then
if askKey(game.name) then
local secureUrl = getSecureLink(game.id)
if secureUrl then loadScript(secureUrl, game.name) else gg.alert("❌ Error: Path not found.") end
end
else
local secureUrl = getSecureLink(game.id)
if secureUrl then loadScript(secureUrl, game.name) else gg.alert("❌ Error: Path not found.") end
end
end

function premiumInfo()
gg.alert(
"🔔 Get access to premium-quality S4FUNGG scripts with automatic updates, reliable performance, and dedicated support.\n\n" ..
"🔖PRICE LIST\n" ..
"🔸$5.99   ━ 3 Days Access\n" ..
"🔸$10.99 ━ 7 Days Access\n" ..
"🔸$15.99 ━ 1 Month Access\n" ..
"🔸$25.99 ━ Lifetime Access to one Premium Game Script.\n" ..
"🔸$50.99 ━ Lifetime Access to all Premium Game Scripts.\n\n" ..
"💳 PAYMENT METHODS\n" ..
"🔹 GCash\n" ..
"🔹 Binance\n" ..
"🔹 Gift Cards\n" ..
"🔹 Crypto Currency\n\n" ..
"💬 SUPPORT & PURCHASES\n" ..
"For purchases, inquiries, or technical assistance,\n" ..
"please contact the developer via Telegram.\n" ..
"👤 Telegram: @Script4Fun\n\n" ..
"📌 TERMS & INFORMATION\n" ..
"• All purchased scripts receive automatic updates at no additional cost.\n" ..
"• Newly released Premium scripts are automatically added to your library when you own All Premium Access.\n" ..
"• Enjoy a one-time payment with lifetime support, continuous improvements, and future content updates.",
"B A C K")

mainMenu()
end

function helpInfo()
gg.alert(
"❓ FREQUENTLY ASKED QUESTIONS\n\n" ..
"Q: How do I activate my Premium Key?\n" ..
"A: Open any Premium Script and enter your license key when prompted. Your key will be verified automatically.\n\n" ..
"Q: Do Premium Scripts receive updates?\n" ..
"A: Yes. All purchased Premium Scripts receive free automatic updates whenever a new version is released.\n\n" ..
"Q: How many devices can I use with one license?\n" ..
"A: Each license key can only be activated on one physical device or one virtual device.\n\n" ..
"Q: Can I transfer my license to another device?\n" ..
"A: If eligible, you may request a device reset by contacting the developer on Telegram.\n\n" ..
"Q: Which payment methods are accepted?\n" ..
"A: Binance, Crypto, Gift Cards, and GCash.\n\n" ..
"Q: What does 'Device Mismatch' mean?\n" ..
"A: Your license key is already registered to a different device or virtual environment.\n\n" ..
"Q: Why is my script not loading?\n" ..
"A: Make sure you have a stable internet connection and are using the latest versions of both the game and GameHub X Loader.\n\n" ..
"Q: How can I contact support?\n" ..
"A: For purchases, technical support, or account assistance, contact the developer on Telegram: @Script4Fun",
"B A C K"
)

mainMenu()
end

function mainMenu()
local m = gg.choice({
"🔎 Search Game",
"📑 All Games",
"🎫 Free Games",
"🎟️ Premium Games",
"⭐ Membership Plans",
"❓ FAQ & Help",
"E X I T"
}, nil, header())
if m == 1 then searchGame()
elseif m == 2 then openGameMenu(ALL_GAMES)
elseif m == 3 then openGameMenu(FREE_GAMES)
elseif m == 4 then openGameMenu(PREMIUM_GAMES)
elseif m == 5 then premiumInfo()
elseif m == 6 then helpInfo()    
elseif m == 7 then
os.exit()
end
end
checkMaintenance()
local function checkArchitecture()
local info = gg.getTargetInfo()
if not info.x64 then
gg.alert(
"⚠️ UNSUPPORTED GAME ARCHITECTURE\n\n" ..
"• Detected: 32-bit\n" ..
"• Required: 64-bit (ARM64)\n\n" ..
"• Please install or launch the 64-bit version of the game before using this script.",
"OKAY")
os.exit()
end
end
checkArchitecture()
toast(APP.NAME)
gg.sleep(800)
mainMenu()
while true do 
if gg.isVisible(true) then 
gg.setVisible(false) 
mainMenu() 
end 
gg.sleep(100) 
end



