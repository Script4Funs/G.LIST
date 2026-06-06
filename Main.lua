--=========================
-- GG CHECK
--=========================
if gg.PACKAGE ~= "com.Script4FunGG.Dev" then
return
end
--=========================
-- URL LINK
--=========================
local urls = {'https://pastebin.com/raw/VgeqawmL'}
for _, url in ipairs(urls) do 
local T = gg.makeRequest(url).content 
if T then 
local success, err = pcall(load(T)) 
if not success then break end 
else 
gg.alert('⚠️ Unable to load. Please check internet connection.') 
break 
end 
end
--=========================
-- FIREBASE
--=========================
local DB = "https://system-keys-default-rtdb.asia-southeast1.firebasedatabase.app"
local SAVE_FILE = gg.EXT_FILES_DIR .. "/NeuralInvocationAdaptationProcessingFramework.arsc"
--=========================
-- LOAD SAVED KEY
--=========================
local savedKey = ""
local f = io.open(SAVE_FILE, "r")
if f then
savedKey = f:read("*a")
f:close()
end
--=========================
-- SESSION ID SYSTEM
--=========================
local function generateSessionId(deviceId)
local chars = "ABCDEFGHIJKLMNOPQRSTUVWXYZ0123456789"
local rand = ""
for i = 1, 4 do
local r = math.random(#chars)
rand = rand .. chars:sub(r, r)
end
return deviceId:sub(1, 6) .. "-" .. os.time() .. "-" .. rand
end
--=========================
-- ALERTS
--=========================
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
"This license key has been disabled by the administrator.\n" ..
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
local function alertSuccess(gameName, deviceId)
local sessionId = generateSessionId(deviceId)
gg.alert(
"🔐 AUTHORIZATION COMPLETE\n\n" ..
"🔑 Premium Key Verified\n" ..
"🎮 Game: " .. gameName .. "\n\n" ..
"🆔 Session ID: " .. sessionId .. "\n" ..
"📱 Device: " .. deviceId:sub(1, 6) .. "****\n" ..
"⏱️ Timestamp: " .. os.date("%Y-%m-%d %H:%M:%S") .. "\n\n" ..
"🔒 Secure session established.",
"CONTINUE")
end
--=========================
-- DEVICE SYSTEM
--=========================
local DEVICE_FILE = gg.EXT_FILES_DIR .. "/TemporalOverrideSynchronizationCommandInterface.arsc"
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
--=========================
-- JSON HELPERS
--=========================
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
--=========================
-- SERVER TIME
--=========================
local function parseServerDate(dateStr)
local pattern = "(%a+), (%d+) (%a+) (%d+) (%d+):(%d+):(%d+) GMT"
local _, day, monthStr, year, hour, min, sec =
dateStr:match(pattern)
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
--=========================
-- AUTO BIND DEVICE
--=========================
local function bindDeviceToKey(key, deviceId)
local url = DB .. "/keys/" .. key .. "/device.json"
local headers = {
["Content-Type"] = "application/json",
["X-HTTP-Method-Override"] = "PUT"
}
local result = gg.makeRequest(
url,
headers,
'"' .. deviceId .. '"'
)
return result and result.code == 200
end
--=========================
-- MAIN LOGIN FUNCTION
--=========================
function askKey(gameName)
local p = gg.prompt(
{"🔑 Enter Premium Key", "💾 Save"},
{savedKey, savedKey ~= ""},
{"text", "checkbox"}
)
if not p then return false end
local key = p[1]
local saveKey = p[2]
if saveKey and key ~= "" then
local f = io.open(SAVE_FILE, "w")
if f then
f:write(key)
f:close()
end
end
gg.toast("🔄 Verifying Key...")
local res = gg.makeRequest(DB .. "/keys/" .. key .. ".json")
if not res or not res.content then
alertError()
return false
end
if res.content == "null" then
os.remove(SAVE_FILE)
alertInvalid()
return false
end
local data = res.content   
local deviceId = getDeviceId()
local serverDevice = extractField(data, "device")
local status = extractBool(data, "status")
local expire = extractDate(data, "expire")
--=========================
-- AUTO REGISTER + BIND DEVICE
--=========================
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
--=========================
-- DEVICE MISMATCH CHECK
--=========================
if serverDevice and serverDevice ~= "" and serverDevice ~= deviceId then
os.remove(SAVE_FILE)
gg.alert(
"🔒 DEVICE MISMATCH\n\n" ..
"This license is linked to another device.\n\n" ..
"Access denied.",
"OK"
)
return false
end
--=========================
-- GAME CHECK
--=========================
if not data:find('"' .. gameName .. '"') then
os.remove(SAVE_FILE)
alertWrongGame(gameName)
return false
end
--=========================
-- DISABLED CHECK
--=========================
if status == false then
alertDisabled()
os.remove(SAVE_FILE)
return false
end
--=========================
-- EXPIRY CHECK
--=========================
local serverDate = getServerDate()

if not serverDate then
gg.alert(
"🌐 SERVER TIME ERROR\n\n" ..
"Unable to verify server time.\n" ..
"Please check your internet connection."
)
return false
end

if expire and serverDate > expire then
os.remove(SAVE_FILE)
alertExpired(expire)
return false
end
--=========================
-- SUCCESS LOGIN
--=========================
alertSuccess(gameName, deviceId)
return true
end
--=========================
-- MAIN MENU
--=========================
local APP = { NAME = "GameHub X", VERSION = "909.2", DEVELOPER = "@Script4Fun" }
local GAME_ICON = "🔸"
--=========================
-- GAME LINK DATABASE
--=========================
local FREE_GAMES = { 
{ name = "Soccer Battle", version = "Auto Update", script = "https://raw.githubusercontent.com/Script4Funs/G.LIST/refs/heads/main/com.Soccer%20Battle.lua" }, 
{ name = "Let's Go Rain", version = "Auto Update", script = "https://raw.githubusercontent.com/Script4Funs/G.LIST/refs/heads/main/com.Let's%20Go%20Rain.lua" }, 
{ name = "Mask Gun", version = "Auto Update", script = "https://raw.githubusercontent.com/Script4Funs/G.LIST/refs/heads/main/com.Mask%20Gun.lua" },
{ name = "Idle Hunter: Eternal Soul", version = "Auto Update", script = "https://raw.githubusercontent.com/Script4Funs/G.LIST/refs/heads/main/com.Idle%20Hunter_%20Eternal%20Soul.lua" },
{ name = "Guns Of Boom", version = "Auto Update", script = "https://arquivosadminscript.mmmods.com/UpLoadScriptUser/com.Guns%20Of%20Boom104093.html" },
{ name = "Coming Soon", version = "Auto Update", script = "https://raw.githubusercontent.com/USERNAME/REPO/main/codm.lua" },
{ name = "Coming Soon", version = "Auto Update", script = "https://raw.githubusercontent.com/USERNAME/REPO/main/codm.lua" },
{ name = "Coming Soon", version = "Auto Update", script = "https://raw.githubusercontent.com/USERNAME/REPO/main/codm.lua" },
{ name = "Coming Soon", version = "Auto Update", script = "https://raw.githubusercontent.com/USERNAME/REPO/main/codm.lua" }    
}

local PREMIUM_GAMES = { 
{ name = "Animals & Coins", version = "Auto Update", script = "https://raw.githubusercontent.com/Script4Funs/G.LIST/refs/heads/main/com.Animals%20and%20Coins.lua" }, 
{ name = "Polywar", version = "Auto Update", script = "https://raw.githubusercontent.com/Script4Funs/G.LIST/refs/heads/main/com.Polywar.lua" }, 
{ name = "Valkyrie Idle", version = "Auto Update", script = "https://raw.githubusercontent.com/Script4Funs/G.LIST/refs/heads/main/com.Valkyrie%20Idle.lua" }, 
{ name = "Battle Guys", version = "Auto Update", script = "https://raw.githubusercontent.com/Script4Funs/G.LIST/refs/heads/main/com.Battle%20Guys.lua" }, 
{ name = "Luna M Ph", version = "Auto Update", script = "https://raw.githubusercontent.com/Script4Funs/G.LIST/refs/heads/main/com.LunaM%20Ph.lua" }, 
{ name = "Forward Assault", version = "Auto Update", script = "https://raw.githubusercontent.com/Script4Funs/G.LIST/refs/heads/main/com.Forward%20Assault.lua" },     
{ name = "Grim Soul", version = "Auto Update", script = "https://raw.githubusercontent.com/Script4Funs/G.LIST/refs/heads/main/com.Grim%20Soul.lua" },
{ name = "Castle Defense Online", version = "Auto Update", script = "https://raw.githubusercontent.com/Script4Funs/G.LIST/refs/heads/main/com.Castle%20Defense%20Online.lua" },       
{ name = "Mob Rush", version = "Auto Update", script = "https://raw.githubusercontent.com/Script4Funs/G.LIST/refs/heads/main/com.Mob%20Rush.lua" } 
}
--=========================
-- SORT A-Z
--=========================
table.sort(FREE_GAMES, function(a, b) return string.lower(a.name) < string.lower(b.name) end)
table.sort(PREMIUM_GAMES, function(a, b) return string.lower(a.name) < string.lower(b.name) end)
--=========================
-- ALL GAMES
--=========================
local ALL_GAMES = {}
for _, v in ipairs(FREE_GAMES) do table.insert(ALL_GAMES, v) end
for _, v in ipairs(PREMIUM_GAMES) do table.insert(ALL_GAMES, v) end
table.sort(ALL_GAMES, function(a, b) return string.lower(a.name) < string.lower(b.name) end)
--=========================
-- UTILITIES
--=========================
local function toast(msg) gg.toast(msg) end
local function header() 
return "Ⓜ️ • Application: " .. APP.NAME .. "\n" ..
"✳️ • Version: " .. APP.VERSION .. "\n" ..
"👤 • Owner: " .. APP.DEVELOPER 
end
--=========================
-- LOAD SCRIPT
--=========================
function loadScript(url, name)
gg.toast("⚙️ Preparing " .. name .. "...")
local res = gg.makeRequest(url)
if not res or not res.content then
gg.alert("❌ Script Load Failed\n\n⚠️ Unable to load the selected script.\nPlease check your connection or try again later.")
return
end
local func, err = load(res.content)
if not func then
gg.alert("Error:\n"..err)
return
end
pcall(func)
end
--=========================
-- GAME MENU
--=========================
local function toTitleCase(str)
return (str:gsub("(%a)([%w_']*)", function(first, rest)
return first:upper() .. rest:lower()
end))
end
function openGameMenu(gameList)
local list = {}
for _, v in ipairs(gameList) do
table.insert(list, GAME_ICON .. " " .. v.name)
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
"📢: Information",
"⭕: Run Script",
"B A C K"
}, nil,
icon .. "Name: " .. toTitleCase(game.name) .. "\n" ..
"🔄 • Version: " .. game.version .. "\n" ..
"👾 • Type: " .. gameType
)
if sub == 1 then
gg.alert("📌 ABOUT THIS GAME:\n\n" ..
"🎮 Name: " .. game.name .. "\n" ..
"🔄 Version: " .. game.version .. "\n\n" ..
"🛠️ GameHub X Loader System\n" ..
"- This tool provides optimized access to game scripts with automatic updates and organized categories.\n" ..
"- Lightweight, fast, and designed for smooth execution.\n\n" ..
"✨ FEATURES:\n" ..
"- Auto Script Loader\n" ..
"- Category-based Menu System\n" ..
"- Fast Injection & Execution\n" ..
"- Regular Updates\n\n" ..
"⚙️ HOW TO USE:\n" ..
"- Open the loader\n" ..
"- Select your desired script\n" ..
"- Wait for prepairing process\n" ..
"- Enjoy the features\n\n" ..
"⚠️ DISCLAIMER:\n" ..
"- Use responsibly at your own risk.\n" ..
"- All scripts are loaded externally.\n" ..
"- We are not responsible for any game restrictions or bans.\n\n" ..
"🔄 UPDATES:\n" ..
"- Always keep the loader updated to avoid errors\n" ..
"- New scripts are added regularly\n\n" ..
"👤 OWNER: " .. APP.DEVELOPER .. "\n" ..
"📩 SUPPORT: Contact developer for issues or bugs"
)
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
loadScript(game.script, game.name)
end
else
loadScript(game.script, game.name)
end
elseif sub == 3 then
openGameMenu(gameList)
end
end
--=========================
-- SYSTEM SEARCH
--=========================
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
gg.alert("🔎 SEARCH COMPLETED\n\n❌ GAME NOT FOUND IN LIST\n\n⚠️ The game you are searching for is not yet available in the GameHub database.\n\n📌 You can:\n- Select another supported game\n- Wait for future updates\n- Contact developer to request it\n\n🚀 New games are added regularly.")
return mainMenu()
end
table.insert(list, "B A C K")
local c = gg.choice(list, nil, "🗨️ • Search Result:")
if not c or c == #list then
return mainMenu()
end
local game = ALL_GAMES[map[c]]
local gameType = "Free"
for _, v in ipairs(PREMIUM_GAMES) do
if v.name == game.name then
gameType = "Premium"
break
end
end
local icon = "🎮 • "
local sub = gg.choice({
"📢: Information",
"⭕: Run Script",
"B A C K"
}, nil,
icon .. "Name: " .. toTitleCase(game.name) .. "\n" ..
"🔄 • Version: " .. game.version .. "\n" ..
"👾 • Type: " .. gameType
)
if sub == 1 then
gg.alert("📌 ABOUT THIS GAME:\n\n" ..
"🎮 Name: " .. game.name .. "\n" ..
"🔄 Version: " .. game.version .. "\n\n" ..
"🛠️ GameHub X Loader System\n" ..
"- This tool provides optimized access to game scripts with automatic updates and organized categories.\n" ..
"- Lightweight, fast, and designed for smooth execution.\n\n" ..
"✨ FEATURES:\n" ..
"- Auto Script Loader\n" ..
"- Category-based Menu System\n" ..
"- Fast Injection & Execution\n" ..
"- Regular Updates\n\n" ..
"⚙️ HOW TO USE:\n" ..
"- Open the loader\n" ..
"- Select your desired script\n" ..
"- Wait for injection process\n" ..
"- Enjoy the features\n\n" ..
"⚠️ DISCLAIMER:\n" ..
"- Use responsibly at your own risk.\n" ..
"- All scripts are loaded externally.\n" ..
"- We are not responsible for any game restrictions or bans.\n\n" ..
"🔄 UPDATES:\n" ..
"- Always keep the loader updated to avoid errors\n" ..
"- New scripts are added regularly\n\n" ..
"👤 OWNER: " .. APP.DEVELOPER .. "\n" ..
"📩 SUPPORT: Contact owner @Script4Fun for issues or bugs"
)
return mainMenu()
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
loadScript(game.script, game.name)
end
else
loadScript(game.script, game.name)
end
elseif sub == 3 then
return mainMenu()
end
end
--=========================
-- MAIN MENU
--=========================
function mainMenu()
local m = gg.choice({
"🔎: Search Game",
"📑: All Games",
"🎫: Free Games",
"🎟️: Premium Games",
"E X I T"
}, nil, header())
if m == 1 then searchGame()
elseif m == 2 then openGameMenu(ALL_GAMES)
elseif m == 3 then openGameMenu(FREE_GAMES)
elseif m == 4 then openGameMenu(PREMIUM_GAMES)
elseif m == 5 then os.exit()
end
end
--=========================
-- START
--=========================
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
