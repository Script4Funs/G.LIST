function mainMenu()
local m = gg.choice({
"🔎 Search Game",
"📑 All Scripts",
"🎫 Free Scripts",
"🎟️ Premium Scripts",
"⭐ Membership Plans",
"🔐 License Management",
"📖 User Guide",
"❓ FAQ & Help",
"E X I T"
}, nil, header())

if m == 1 then
searchGame()
elseif m == 2 then
openGameMenu(ALL_GAMES)
elseif m == 3 then
openGameMenu(FREE_GAMES)
elseif m == 4 then
openGameMenu(PREMIUM_GAMES)
elseif m == 5 then
premiumInfo()
elseif m == 6 then
showLicenseInformation()
elseif m == 7 then
userGuide()
elseif m == 8 then
helpInfo()
elseif m == 9 then
os.exit()
end
end

local function checkAnnouncement()
local url = DB .. "/announcement.json"
local res = gg.makeRequest(url)
if not res or res.code ~= 200 then
return
end
if not res.content or res.content == "" or res.content == "null" then
return
end
local data = res.content
local enabled = data:match('"enabled"%s*:%s*(%a+)')
if enabled ~= "true" then
return
end
local month = data:match('"month"%s*:%s*"([^"]*)"')
local gamesBlock = data:match('"games"%s*:%s*%[(.-)%]')
if not gamesBlock then
return
end
local announcement = ""
for gameData in gamesBlock:gmatch("{(.-)}") do
local game = gameData:match('"name"%s*:%s*"([^"]*)"')
local releaseType = gameData:match('"type"%s*:%s*"([^"]*)"')
local date = gameData:match('"date"%s*:%s*"([^"]*)"')
local message = gameData:match('"message"%s*:%s*"([^"]*)"')
if game then
local icon = "🎟️"
if releaseType == "Free" then
icon = "🎫"
end
announcement = announcement ..
"• 🎮 Game: " .. game .. "\n" ..
"• " .. icon .. " Type: " .. (releaseType or "N/A") .. "\n" ..
"• 📌 Status: " .. (message or "N/A") .. "\n" ..
"• 📅 Release Date: " .. (date or "N/A") .. "\n\n"
end
end
if announcement == "" then
return
end
gg.alert(
"📢 " .. string.upper(month or "RELEASE") .. " RELEASE\n\n" ..
announcement,
"CONTINUE"
)
end
