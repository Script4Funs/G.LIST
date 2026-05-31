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

-- APP INFO

local APP = { NAME = "GameHub X", VERSION = "909.2", DEVELOPER = "@Script4Fun" }

local GAME_ICON = "🔸"

-- GAME DATABASE

local FREE_GAMES = { 
    { name = "Soccer Battle", version = "Auto Update", script = "https://raw.githubusercontent.com/Script4Funs/G.LIST/refs/heads/main/com.Soccer%20Battle.lua" }, 
    { name = "Let's Go Rain", version = "Auto Update", script = "https://raw.githubusercontent.com/Script4Funs/G.LIST/refs/heads/main/com.Let's%20Go%20Rain.lua" }, 
    { name = "Coming Soon", version = "Auto Update", script = "https://raw.githubusercontent.com/USERNAME/REPO/main/codm.lua" },
    { name = "Coming Soon", version = "Auto Update", script = "https://raw.githubusercontent.com/USERNAME/REPO/main/codm.lua" },
    { name = "Coming Soon", version = "Auto Update", script = "https://raw.githubusercontent.com/USERNAME/REPO/main/codm.lua" },
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
    { name = "Mob Rush", version = "Auto Update", script = "https://raw.githubusercontent.com/Script4Funs/G.LIST/refs/heads/main/com.Mob%20Rush.lua" } 
}

-- SORT A-Z

table.sort(FREE_GAMES, function(a, b) return string.lower(a.name) < string.lower(b.name) end)
table.sort(PREMIUM_GAMES, function(a, b) return string.lower(a.name) < string.lower(b.name) end)

-- ALL GAMES

local ALL_GAMES = {}

for _, v in ipairs(FREE_GAMES) do table.insert(ALL_GAMES, v) end
for _, v in ipairs(PREMIUM_GAMES) do table.insert(ALL_GAMES, v) end

table.sort(ALL_GAMES, function(a, b) return string.lower(a.name) < string.lower(b.name) end)

-- UTILITIES

local function toast(msg) gg.toast(msg) end

local function header() 
    return "Ⓜ️ • Application: " .. APP.NAME .. "\n" ..
           "✳️ • Version: " .. APP.VERSION .. "\n" ..
           "👤 • Owner: " .. APP.DEVELOPER 
end

-- LOAD SCRIPT

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

-- GAME MENU

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
        loadScript(game.script, game.name)

    elseif sub == 3 then
        openGameMenu(gameList)
    end
end

-- SEARCH SYSTEM

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
        "📩 SUPPORT: Contact developer for issues or bugs"
        )

        return mainMenu()

    elseif sub == 2 then
        loadScript(game.script, game.name)

    elseif sub == 3 then
        return mainMenu()
    end
end

-- MAIN MENU

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

-- START

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
