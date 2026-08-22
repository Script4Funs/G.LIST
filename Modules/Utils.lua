function loading()
gg.toast("⚙️ Preparing...")
gg.sleep(5000)
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
loading()
gg.toast("⬇️ Fetching " .. name .. "...")
local res = gg.makeRequest(url)

if not res or not res.content then
gg.alert(
"⚠️ SCRIPT DOWNLOAD FAILED\n\n" ..
"S4FUNGG was unable to retrieve the requested script.\n\n" ..
"• 🎮 Game: " .. name .. "\n" ..
"• 📡 Status: Download failed\n" ..
"• 🔐 License: Not affected\n\n" ..
"Please check your internet connection and try again.",
"O K A Y"
)
return
end

local func, err = load(res.content)
if not func then
gg.alert(
"⚠️ SCRIPT PROCESSING FAILED\n\n" ..
"The downloaded script could not be processed correctly.\n\n" ..
"• 🎮 Game: " .. name .. "\n" ..
"• 📄 Status: Processing failed\n" ..
"• 🔐 License: Not affected\n\n" ..
"Please try again later. If the issue persists, contact support.",
"O K A Y"
)
return
end

gg.toast("✅ " .. name .. " Loaded Success")
pcall(func)
end

function openGameMenu(gameList)
local list = {}
for _, v in ipairs(gameList) do
local icon = "🎫 • "
for _, p in ipairs(PREMIUM_GAMES) do
if p.id == v.id then
icon = "🎟️ • "
break
end
end
table.insert(list, icon .. " " .. v.name)
end
table.insert(list, "B A C K")
local c = gg.choice(list, nil, header())
if not c or c == #list then
mainMenu()
return
end
local game = gameList[c]
local gameType = "Free"
local typeIcon = "🎫"
for _, v in ipairs(PREMIUM_GAMES) do
if v.name == game.name then
gameType = "Premium"
typeIcon = "🎟️"
break
end
end
while true do

local sub = gg.choice({
"📢 Information",
"⭕ Run Script",
"B A C K"
}, nil,
"• 🎮 Game: " .. game.name .. "\n" ..
"• ♻️ Version: " .. game.version .. "\n" ..
"• " .. typeIcon .. " Access: " .. gameType
)

if sub == 1 then
local updateInfo
if game.updateMode == "Automatic" then
updateInfo =
"♻️ SCRIPT UPDATE\n" ..
"• Update Mode: Automatic\n" ..
"• Version Status: Latest Supported\n" ..
"• S4FUNGG will retrieve the latest supported script when available."
else
updateInfo =
"♻️ SCRIPT UPDATE\n" ..
"• Update Mode: Manual\n" ..
"• Supported Game Version: " .. game.version .. "\n" ..
"• A new script update may be required when the game version changes."
end

gg.alert(
"ℹ️ GAME INFORMATION\n\n" ..
"• 🎮 Game: " .. game.name .. "\n" ..
"• ♻️ Version: " .. game.version .. "\n" ..
"• " .. typeIcon .. " Access: " .. gameType .. "\n\n" ..
updateInfo .. "\n\n" ..
"📦 SCRIPT INFORMATION\n" ..
"• 📚 Library: S4FUNGG Script Library\n" ..
"• 🔐 Delivery: Secure Script Link\n" ..
"• ⚡ Loading: Optimized",
"B A C K"
)

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
if secureUrl then
loadScript(secureUrl, game.name)
else
gg.alert(
"⚠️ SCRIPT LINK UNAVAILABLE\n\n" ..
"The script link for this game could not be retrieved from the server.\n\n" ..
"• 🎮 Game: " .. game.name .. "\n" ..
"• ⚠️ Status: Link Unavailable\n" ..
"• 🌐 Server: No Valid Link Found\n\n" ..
"Please try again later. If the issue persists, please contact support.",
"O K A Y"
)
end
end
else

local secureUrl = getSecureLink(game.id)

if secureUrl then
loadScript(secureUrl, game.name)
else
gg.alert(
"⚠️ SCRIPT LINK UNAVAILABLE\n\n" ..
"The script link for this game could not be retrieved from the server.\n\n" ..
"• 🎮 Game: " .. game.name .. "\n" ..
"• ⚠️ Status: Link Unavailable\n" ..
"• 🌐 Server: No Valid Link Found\n\n" ..
"Please try again later. If the issue persists, please contact support.",
"O K A Y"
)
end
end

elseif sub == 3 then
openGameMenu(gameList)
return
end
end
end

function searchGame()
local p = gg.prompt({"🔎 Search Game Name:"}, {""}, {"text"})
if not p then return mainMenu() end
local key = string.lower(p[1])
local list = {}
local map = {}
for i, v in ipairs(ALL_GAMES) do
if string.find(string.lower(v.name), key) then
local icon = "🎫 • "
for _, p in ipairs(PREMIUM_GAMES) do
if p.id == v.id then
icon = "🎟️ • "
break
end
end

table.insert(list, icon .. " " .. v.name)
table.insert(map, i)
end
end

if #list == 0 then
gg.alert(
"🔎 SEARCH COMPLETED\n\n" ..
"No matching game was found for your search.\n\n" ..
"• 📊 Status: No Results\n" ..
"• 🗄️ Database: Game May Not Be Available\n" ..
"• 🔎 Search: Keyword May Be Incorrect\n\n" ..
"Please try again using a different game name or keyword.",
"O K A Y"
)
return mainMenu()
end

table.insert(list, "B A C K")
local c = gg.choice(list, nil, "🗨️ Search Result:")
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
if secureUrl then
loadScript(secureUrl, game.name)
else
gg.alert(
"⚠️ SCRIPT LINK UNAVAILABLE\n\n" ..
"The script link for this game could not be retrieved from the server.\n\n" ..
"• 🎮 Game: " .. game.name .. "\n" ..
"• 🔗 Status: Link Unavailable\n" ..
"• 🌐 Server: No Valid Link Found\n\n" ..
"Please try again later. If the issue persists, please contact support.",
"O K A Y"
)
end
end
else

local secureUrl = getSecureLink(game.id)
if secureUrl then
loadScript(secureUrl, game.name)
else
gg.alert(
"⚠️ SCRIPT LINK UNAVAILABLE\n\n" ..
"The script link for this game could not be retrieved from the server.\n\n" ..
"• 🎮 Game: " .. game.name .. "\n" ..
"• 🔗 Status: Link Unavailable\n" ..
"• 🌐 Server: No Valid Link Found\n\n" ..
"Please try again later. If the issue persists, please contact support.",
"O K A Y"
)
end
end
end

function premiumInfo()
gg.alert(
"🔔 PREMIUM MEMBERSHIP\n\n" ..
"• Get access to premium S4FUNGG scripts with reliable performance, supported updates, and dedicated support.\n" ..
"• Choose the Premium Access plan that best suits your needs. Please check the price list below for available plans and pricing.\n\n" ..
"⭐ 3 Days Access\n" ..
"   🇺🇸 USD: $5.99\n" ..
"   🇵🇭 PHP: ₱310\n\n" ..
"⭐ 7 Days Access\n" ..
"   🇺🇸 USD: $10.99\n" ..
"   🇵🇭 PHP: ₱620\n\n" ..
"⭐ 1 Month Access\n" ..
"   🇺🇸 USD: $15.99\n" ..
"   🇵🇭 PHP: ₱925\n\n" ..
"⭐ Lifetime ━ 1 Premium Game\n" ..
"   🇺🇸 USD: $25.99\n" ..
"   🇵🇭 PHP: ₱1,540\n\n" ..
"⭐ Lifetime ━ All Premium Games\n" ..
"   🇺🇸 USD: $50.99\n" ..
"   🇵🇭 PHP: ₱3,085\n\n" ..
"💳 PAYMENT METHODS\n" ..
"🔹GCash\n" ..
"🔹Binance\n" ..
"🔹Crypto Currency\n" ..
"🔹Binance Gift Cards\n\n" ..
"💬 SUPPORT & COMMUNITY\n" ..
"• 👤 Developer: " .. APP.DEVELOPER .. "\n" ..
"• 📨 Telegram: @Script4Fun\n" ..
"• 📢 Telegram Channel: https://t.me/ScriptForFun\n" ..
"• ▶️ YouTube: https://www.youtube.com/@S4FUNGG\n" ..
"• 📨 Purchases, inquiries, and technical support are handled through Telegram.\n\n" ..
"📌 TERMS & INFORMATION\n" ..
"• Purchased scripts receive updates when updates are available and supported.\n" ..
"• Supported games may receive automatic script updates through S4FUNGG.\n" ..
"• Non-Unity games may require manual updates after a game update.\n" ..
"• Premium access includes continued support for the purchased access period.\n" ..
"• All Premium Access includes newly released Premium scripts while the access remains valid.",
"B A C K"
)
mainMenu()
end

function helpInfo()
gg.alert(
"❓ FAQ & HELP\n\n" ..
"🔐 LICENSE & ACCESS\n" ..
"Q: What does 'Device Mismatch' mean?\n" ..
"A: Your license is already registered to another device or virtual environment. The license must be used with its registered device.\n\n" ..
"Q: Can I transfer my license to another device?\n" ..
"A: An eligible device reset may be requested through support. Contact the developer on Telegram for assistance.\n\n" ..
"Q: What happens when my license expires?\n" ..
"A: Premium access becomes unavailable after the license validity period ends. Renew your license to restore access.\n\n" ..
"Q: Can I use one license on multiple devices?\n" ..
"A: No. Each license key is limited to one registered physical or virtual device.\n\n" ..
"💳 PURCHASE & PAYMENT\n" ..
"Q: Which payment methods are accepted?\n" ..
"A: GCash, Binance, Crypto Currency, and Binance Gift Cards are currently supported.\n\n" ..
"Q: Where can I purchase Premium access?\n" ..
"A: Premium purchases and inquiries are handled directly through Telegram: @Script4Fun.\n\n" ..
"⚙️ SCRIPT & SERVER ISSUES\n" ..
"Q: Why is my script not loading?\n" ..
"A: Check your internet connection and make sure you are using the required game version. If the issue continues, restart S4FUNGG and try again.\n\n" ..
"Q: What does 'SCRIPT LINK UNAVAILABLE' mean?\n" ..
"A: S4FUNGG was unable to retrieve the script link from the server. This may be temporary. Please try again later.\n\n" ..
"Q: What does 'SERVICE TEMPORARILY UNAVAILABLE' mean?\n" ..
"A: The script server could not be reached. This may be caused by a temporary server or network issue. Your license and account are not affected.\n\n" ..
"Q: What does 'SYSTEM MAINTENANCE' mean?\n" ..
"A: The S4FUNGG service is temporarily unavailable because maintenance is being performed. Please wait until the service is restored.\n\n" ..
"Q: Do Premium Scripts receive updates?\n" ..
"A: Yes. Supported Premium Scripts receive updates when new versions are available. Update availability may depend on the game and its technical limitations.\n\n" ..
"🛠️ ERROR & SUPPORT\n" ..
"Q: What should I do if I receive a connection error?\n" ..
"A: Check your internet connection and try again after a few minutes. If the issue persists, contact support.\n\n" ..
"Q: What should I do if my license is rejected?\n" ..
"A: Make sure the license key is correct and active. If you believe the key was rejected incorrectly, contact support for verification.\n\n" ..
"Q: How can I request technical support?\n" ..
"A: Contact the developer directly through Telegram: @Script4Fun. Please provide the game name and a screenshot of the error when possible.\n\n" ..
"📢 SUPPORT CHANNEL\n" ..
"• 👤 Developer: " .. APP.DEVELOPER .. "\n" ..
"• 📨 Telegram: @Script4Fun\n" ..
"• 📢 Telegram Channel: https://t.me/ScriptForFun\n" ..
"• ▶️ YouTube: https://www.youtube.com/@S4FUNGG\n\n" ..
"ℹ️ If your question is not listed above, please contact support for further assistance.",
"B A C K"
)
mainMenu()
end

function userGuide()
gg.alert(
"📖 S4FUNGG USER GUIDE\n\n" ..
"🚀 GETTING STARTED\n" ..
"• Make sure S4FUNGG is installed and running.\n" ..
"• Make sure the selected game is installed on your device.\n" ..
"• Launch the game and allow S4FUNGG to attach to it.\n" ..
"• Open S4FUNGG and select the game you want to use.\n\n" ..
"🎮 SELECTING A GAME\n" ..
"• Open Search Game, All Games, Free Games, or Premium Games.\n" ..
"• Select the game you want to use.\n" ..
"• Choose 'Information' to view the game details.\n" ..
"• Choose 'Run Script' to start the selected script.\n\n" ..
"🎫 FREE GAME SCRIPTS\n" ..
"• 1. Open 'Free Games'.\n" ..
"• 2. Select your desired game.\n" ..
"• 3. Select 'Run Script'.\n" ..
"• 4. Wait while the script is downloaded and loaded.\n" ..
"• 5. Follow the instructions provided by the script.\n\n" ..
"🎟️ PREMIUM GAME SCRIPTS\n" ..
"• 1. Open 'Premium Games'.\n" ..
"• 2. Select your desired game.\n" ..
"• 3. Select 'Run Script'.\n" ..
"• 4. Enter your Premium License Key when requested.\n" ..
"• 5. Wait for the license verification to complete.\n" ..
"• 6. Once authorization is successful, the script will load automatically.\n\n" ..
"🔐 FIRST-TIME ACTIVATION\n" ..
"• Your license is automatically linked to the device used during the first successful activation.\n" ..
"• A physical device or virtual environment is treated as a separate device.\n" ..
"• After successful registration, the same license should be used with the registered device.\n\n" ..
"♻️ SCRIPT UPDATES\n" ..
"• S4FUNGG retrieves supported scripts directly from the script server.\n" ..
"• Supported games may receive automatic script updates.\n" ..
"• Some non-Unity games may require manual updates after a game update.\n" ..
"• Always use the required game version when specified.\n\n" ..
"⚠️ BASIC TROUBLESHOOTING\n" ..
"• Make sure your internet connection is stable.\n" ..
"• Make sure S4FUNGG is running correctly.\n" ..
"• Make sure the selected game is installed and running.\n" ..
"• Restart S4FUNGG if a temporary loading problem occurs.\n" ..
"• If the problem continues, check the FAQ & Help section or contact support.\n\n" ..
"💬 SUPPORT\n" ..
"• 👤 Developer: " .. APP.DEVELOPER .. "\n" ..
"• 📨 Telegram: @Script4Fun\n" ..
"• 📢 Telegram Channel: https://t.me/ScriptForFun\n" ..
"• ▶️ YouTube: https://www.youtube.com/@S4FUNGG\n\n" ..
"✅ Thank you for using S4FUNGG.",
"B A C K"
)
mainMenu()
end
