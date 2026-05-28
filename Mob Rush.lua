
--=========================
-- GET TARGET APP INFO
--=========================
local info = gg.getTargetInfo()
local pkg = info.packageName
local arch = info.x64 and "ARM64" or "ARM32"

--=========================
-- PACKAGE VALIDATION
--=========================
local requiredPackage = "com.moonton.xgame"

if pkg ~= requiredPackage then
    gg.alert(
        "❌ INVALID GAME PACKAGE:"..
        "\n\n📦 Required Package:"..
        "\n"..requiredPackage..
        "\n\n⚠️ Please launch the correct game before running the script.",
        "EXIT"
    )
    return
end

--=========================
-- ENVIRONMENT CHECK
--=========================
local start = gg.alert(
    "🛡️ SCRIPT ENVIRONMENT CHECK:"..
    "\n\n📦 Package: "..pkg..
    "\n🖥️ Architecture: "..arch..
    "\n\n✅ Compatible environment detected."..
    "\n⚙️ Script initialization completed."..
    "\n\n📢 IMPORTANT ADVISORY:"..
    "\n🔍 First-time initialization required."..
    "\n🎮 Please enter the game first"..
    "\n\n⏳ This process may take a few moments depending on your device.",
    "⭕ START"
)
--=========================
-- SET LIBRARY NAME
--=========================
local libNameSo = "liblogic.so"
--=========================
-- SIMPLE XOR ENCRYPT FUNCTION
--=========================
local SECRET_KEY = 0x5A

local function crypt(data, key)
    key = key or SECRET_KEY

    local out = {}

    for i = 1, #data do
        local k = (key + i * 13) % 256

        out[i] = string.char(
            bit32.bxor(data:byte(i), k)
        )
    end

    return table.concat(out)
end
--=========================
-- GET TARGET APP INFO
--=========================
local info = gg.getTargetInfo()
local APK = info.label
--=========================
-- INITIALIZE VARIABLES
--=========================
X_X = {}
UwU = 0
LibraryStatus = 0
MemoryRanges = gg.getRangesList()
hitboxBackup = nil

hackState = {
    autowin = false,
    kills = 0,
    maxlvl = false,
    onehit = false
}
--=========================
-- LOGGING FUNCTIONS
--=========================
local function logInfo(msg)
    print("[INFO] " .. msg)
end

local function logWarning(msg)
    print("[WARNING] " .. msg)
end

local function logError(msg)
    print("[ERROR] " .. msg)
end
--=========================
-- MEMORY VALIDATION CHECK
--=========================
if #MemoryRanges == 0 then
    logError("❌ Critical: Required library modules were not detected. Please verify the target process and environment integrity.")
    gg.setVisible(true)
    os.exit()
end
--=========================
-- SEARCH TARGET LIBRARY
--=========================
MemoryRanges = gg.getRangesList(libNameSo)

if #MemoryRanges == 0 then
    LibraryStatus = 2
    goto LIBRARY_SPLIT
end
--=========================
-- FIND XA MEMORY REGION
--=========================
for i, range in ipairs(MemoryRanges) do
    if range.state == "Xa" then
        UwU = UwU + 1
        X_X[UwU] = range.start
        LibrarySize = range["end"] - range.start
        LibraryStatus = 1
    end
end

if LibraryStatus == 0 then
    logError("❌ Library not found in Xa memory region: " .. libNameSo)
    gg.setVisible(true)
    os.exit()
end
--=========================
-- SPLIT APK HANDLING
--=========================
::LIBRARY_SPLIT::

if LibraryStatus == 2 then

    local SplitApkFound = false
    MemoryRanges = gg.getRangesList()

    for i, range in ipairs(MemoryRanges) do
        if range.state == "Xa" and string.match(range.name, "split_config") then
            SplitApkFound = true
        end
    end

    if SplitApkFound then

        local SplitSizes = {}
        local SplitCount = 0

        for i, range in ipairs(MemoryRanges) do
            if range.state == "Xa" then
                SplitCount = SplitCount + 1
                SplitSizes[SplitCount] = range["end"] - range.start
            end
        end

        if SplitCount > 0 then
            local MaxSplitSize = math.max(table.unpack(SplitSizes))

            for i, range in ipairs(MemoryRanges) do
                if range.state == "Xa" and (range["end"] - range.start) == MaxSplitSize then
                    UwU = UwU + 1
                    X_X[UwU] = range.start
                    LibrarySize = range["end"] - range.start
                    LibraryStatus = 1
                end
            end
        end

    else
        logWarning("⚠️ Split configuration library not found in current Xa memory region.")
        gg.setVisible(true)
        os.exit()
    end
end
--=========================
-- FINAL VALIDATION CHECK
--=========================
if LibraryStatus ~= 1 then
    logError("❌ Target library validation failed: required module not found.")
    gg.setVisible(true)
    os.exit()
end
--=========================
-- ARM PATCH ENGINE
--=========================
local Original = {}

local function RecordOriginalValue(offset)
    local REV = gg.getValues((function(R)
        for _, x in ipairs({offset}) do
            for i = 0, 16, 4 do
                R[#R + 1] = {address = X_X[UwU] + x + i, flags = 4}
            end
        end
        return R
    end)({}))

    Original[offset] = REV
end
--=========================
-- RESTORE ORIGINAL VALUES
--=========================
local function RevertValue(offset)
    local originalValues = Original[offset]
    if originalValues then
        gg.setValues(originalValues)
        gg.sleep(600)
    end
end
--=========================
-- ARM INJECTION FUNCTIONS
--=========================
local function injectAssembly(offset, value)
    local addr = X_X[UwU] + offset

    if type(value) == "number" then
        value = math.floor(value)
    end

    if value == true then
        gg.setValues({
            {address = addr, flags = 4, value = "h200080D2"},
            {address = addr + 0x4, flags = 4, value = "hC0035FD6"}
        })

    elseif value == false or value == 0 then
        gg.setValues({
            {address = addr, flags = 4, value = "h00008052"},
            {address = addr + 0x4, flags = 4, value = "hC0035FD6"}
        })

    elseif value <= 0xFFFF then
        gg.setValues({
            {address = addr, flags = 4, value = string.format("~A8 MOVZ W0, #%d", value)},
            {address = addr + 0x4, flags = 4, value = "~A8 RET"}
        })

    else
        gg.setValues({
            {address = addr, flags = 4, value = string.format("~A8 MOVZ W0, #%d", value & 0xFFFF)},
            {address = addr + 0x4, flags = 4, value = string.format("~A8 MOVK W0, #%d, LSL #16", (value >> 16) & 0xFFFF)},
            {address = addr + 0x8, flags = 4, value = "~A8 RET"}
        })
    end
end
--=========================
-- FLOAT PATCH FUNCTION
--=========================
local function injectFloat(offset)
    local addr = X_X[UwU] + offset

    gg.setValues({
        {address = addr, flags = 4, value = "~A8 FMOV S0, #0xBF800000"},
        {address = addr + 0x4, flags = 4, value = "~A8 RET"}
    })
end

local function injectRaw(offset, codes)

    local addr = X_X[UwU] + offset
    local patch = {}

    for i, v in ipairs(codes) do
        patch[i] = {
            address = addr + ((i - 1) * 4),
            flags = 4,
            value = v
        }
    end

    gg.setValues(patch)
end
--=========================
-- MAIN MENU ENTRY
--=========================
function HOME()

MENU = gg.choice({
    "📝 MOB RUSH MENU",
    "❌ EXIT"
}, nil,
"👤 • Owner: @Script4Fun\n👁️‍🗨️ • GameScripts: Premium"
)

if MENU == nil then
    return
end

if MENU == 2 then
    os.exit()
end
--=========================
-- MENU INITIALIZATION
--=========================
::GET_READY::

gg.setVisible(false)

for i = 20, 100, 20 do
    gg.sleep(300)
    gg.toast(i .. "%")
end
--=========================
-- TARGET INFO & ARCH SETUP
--=========================
local ti = gg.getTargetInfo()
local p_size = ti.x64 and 0x8 or 0x4
--=========================
-- UTILITY FUNCTIONS
--=========================
local function encode(str)
    return (str:gsub(".", function(c)
        return string.format("%02X", string.byte(c))
    end))
end

local function getvalue(address, ggType)
    return gg.getValues({{address = address, flags = ggType}})[1].value
end

local function ptr(address)
    return getvalue(address, ti.x64 and gg.TYPE_QWORD or gg.TYPE_DWORD)
end

local function CString(address, str)
    local bytes = gg.bytes(str)

    for i = 1, #bytes do
        if (getvalue(address + i - 1, gg.TYPE_BYTE) & 0xFF) ~= bytes[i] then
            return false
        end
    end

    return getvalue(address + #bytes, gg.TYPE_BYTE) == 0
end
--=========================
-- IL2CPP METHOD SCANNER
--=========================
local function GetIl2CppMethod(clazz, method)
    local result = {}

    gg.clearResults()

    gg.setRanges(
        gg.REGION_C_ALLOC |
        gg.REGION_ANONYMOUS |
        gg.REGION_OTHER |
        gg.REGION_CODE_APP |
        gg.REGION_C_BSS |
        gg.REGION_C_DATA
    )

    gg.searchNumber(
        string.format("Q 00 '%s' 00", method),
        gg.TYPE_BYTE
    )

    local count = gg.getResultsCount()

    if count > 0 then

        local t = gg.getResults(count)

        gg.searchPointer(0)

        t = gg.getResults(gg.getResultsCount())

        for _, v in ipairs(t) do
            pcall(function()

                local classPtr =
                    ptr(ptr(v.address + p_size) + p_size * 2)

                if CString(classPtr, clazz) then

                    table.insert(result, {
                        address = ptr(v.address - p_size * 2),
                        name = string.format(
                            "%s :: %s",
                            clazz,
                            method
                        ),
                        flags = v.flags
                    })

                end
            end)
        end

        gg.clearResults()
    end

    return result
end
--=========================
-- OFFSET STORAGE SYSTEM
--=========================
local offsetFilePath =
    gg.EXT_FILES_DIR ..
    "/org.blackbox.engine.impl.reflective.SilentOverrideVector.arsc"

local function saveOffsetsToFile(offsets)
    local file = io.open(offsetFilePath, "w")
    local raw = ""

    for method, offset in pairs(offsets) do
        raw = raw .. method .. "|" .. offset .. ";"
    end

    file:write(crypt(raw))
    file:close()
end

local function loadOffsetsFromFile()
    local offsets = {}
    local file = io.open(offsetFilePath, "r")

    if file then
        local data = file:read("*a")
        file:close()

        local decrypted = crypt(data)

        for pair in decrypted:gmatch("[^;]+") do
            local method, offset = pair:match("^(.-)|(.+)$")
            if method and offset then
                offsets[method] = offset
            end
        end
    end

    return offsets
end

local offsets = loadOffsetsFromFile() or {}
--=========================
-- VERSION CONTROL SYSTEM
--=========================
local VERSION_FILE = gg.EXT_FILES_DIR .. "/com.moonton.xgame.dat"

local targetInfo = gg.getTargetInfo()
local currentVersion = tostring(targetInfo.versionName):gsub("%s+", "")


local function loadSavedVersion()
    local f = io.open(VERSION_FILE, "r")

    if f then
        local ver = f:read("*a")
        f:close()
        return tostring(ver):gsub("%s+", "")
    end

    return nil
end


local function saveCurrentVersion(ver)
    local f = io.open(VERSION_FILE, "w")

    if f then
        f:write(ver)
        f:close()
    else
        logError("❌ [STORAGE] Failed to save version metadata file.")
    end
end
--=========================
-- VERSION CHECK LOGIC
--=========================
local savedVersion = loadSavedVersion()
local needUpdate = false

if not next(offsets) then
    needUpdate = true

elseif savedVersion ~= currentVersion then
    needUpdate = true

    gg.alert(
        "⚠️ VERSION CHANGE DETECTED:" ..
        "\n\n📌 Previous Version: " .. tostring(savedVersion) ..
        "\n📌 Current Version: " .. currentVersion ..
        "\n\n⚙️ New game changes have been detected." ..
        "\n🛠️ A compatibility update is required." ..
        "\n\n▶️ Press CONTINUE to proceed.",
        "⭕ CONTINUE"
    )
end
--=========================
-- UPDATE HANDLER START
--=========================
if needUpdate then
--=========================
-- IL2CPP METHOD SEARCH LIST
--=========================
local Search = {
[1]  = {
    class="BattleRank",
    method="GetPlayerRankSafe",
    key="GetPlayerRankSafe",
},
    [2] = {
        class="BattleRank",
        method="GetPlayerRankCount",
        overload=1,
        key="GetPlayerRankCount_ULONG"
    },
    [3] = {
        class="BattleRank",
        method="GetPlayerRankCount",
        overload=2,
        key="GetPlayerRankCount_INT"
},
[4]  = {
    class="BulletMod",
    method="GetAttrModResultOfSkill",
    key="GetAttrModResultOfSkill",
},
[5]  = {
    class="StageStatistic",
    method="GetPlayerKillPlayerCount",
    key="GetPlayerKillPlayerCount",
},
[6] = {
    class="StageStatistic",
    method="GetPlayerKillRobotCount",
    key="GetPlayerKillRobotCount",
},
}
--=========================
-- OFFSET RESOLUTION ENGINE
--=========================
local DEBUG = false

local successCount = 0
local failCount = 0

for i, v in ipairs(Search) do

    gg.toast(string.format("♻️ Updating… Please wait (%d/%d)", i, #Search))
    gg.sleep(1000)

    local results = GetIl2CppMethod(v.class, v.method)

    if results and #results > 0 then

        local offset

        --=========================
        -- OVERLOAD CHECK
        --=========================
        if v.overload then

            local selected = results[v.overload]

            if selected then
                offset = selected.address - X_X[UwU]
            end

        else
            offset = results[1].address - X_X[UwU]
        end

        --=========================
        -- STORE RESULT
        --=========================
        if offset then

            local hexOffset = string.format("0x%X", offset)

            offsets[v.key] = hexOffset
            _G[v.key] = hexOffset

            successCount = successCount + 1

            if DEBUG then
                gg.toast("✅ " .. v.key .. " = " .. hexOffset)
            else
                gg.toast("☑️ Updated (" .. i .. ")")
            end

        else

            offsets[v.key] = nil
            _G[v.key] = nil

            failCount = failCount + 1

            if DEBUG then
                gg.toast("❌ UPDATE FAILED: " .. v.key)
            else
                gg.toast("❌ FAILED (" .. i .. ")")
            end
        end

    else

        offsets[v.key] = nil
        _G[v.key] = nil

        failCount = failCount + 1

        if DEBUG then
            gg.toast("❌ NO RESULTS FOUND: " .. v.key)
        else
            gg.toast("❌ NO RESULTS (" .. i .. ")")
        end
    end
end

--=========================
-- FINAL RESULT
--=========================

local status = ""

if failCount == 0 then

    status =
        "☑️ UPDATE COMPLETE!\n\n" ..
        "• All values updated successfully."

elseif successCount > failCount then

    status =
        "ℹ️ UPDATE FINISHED:\n\n" ..
        "• Some values failed.\n" ..
        "• Try updating again."
        
else

    status =
        "❌ UPDATE FAILED!\n\n" ..
        "• Too many values failed.\n" ..
        "• Please retry."
end

gg.alert(
    status ..
    "\n\n✅ Success : " .. successCount ..
    "\n❌ Failed : " .. failCount
)
--=========================
-- SAVE RESOLVED DATA
--=========================
saveOffsetsToFile(offsets)
saveCurrentVersion(currentVersion)
--=========================
-- LOADED OFFSETS HANDLER
--=========================
else
--=========================
-- RESTORE SAVED OFFSETS
--=========================
    for method, offset in pairs(offsets) do
        _G[method] = (offset ~= "nil") and offset or nil
    end
--=========================
-- STATUS / MAIN PROMPT
--=========================
local xXx = gg.alert(
    "🎮 APK: " .. APK ..
    "\n\n☑️ Status: Updated to Latest Version" ..
    "\n☑️ Status: Ready for Secure Execution" ..
    "\n☑️ Protection: Memory Values Verified Successfully" ..

    "\n\n⚠️ IMPORTANT NOTICE:" ..
    "\n• Ensure script is updated every game update." ..
    "\n• Outdated script may cause feature failure." ..
    "\n• Some core features are locked and cannot be disabled." ..
    "\n• Optional features can be toggled, but system-critical functions will remain active." ..
    "\n• Disabling required modules may cause instability or unexpected behavior." ..
    "\n• Features like Anti-Crash and Memory Sync must always remain enabled for safe execution.",

    "⭕ START",
    nil,
    "♻️ UPDATE"
)

    if xXx == 3 then
        os.remove(offsetFilePath)
        goto GET_READY
    end
end
--=========================
-- CORE VALIDATION CHECK
--=========================
function check(method)
    if not _G[method] then
        gg.alert(
            "❌ [CORE ERROR]\n\n" ..
            "Unable to locate required memory signatures.\n\n" ..
            "• Feature may be outdated or incompatible with current game version.\n" ..
            "• Please update the script and restart the game.\n" ..
            "• If the issue persists, wait for the next update release."
        )
        return nil
    end
    return true
end
--=========================
-- MENU ROUTING HANDLER
--=========================
MN1()

Strike = -1

end
--=========================
-- GLOBAL STORAGE INIT
--=========================
checkList = checkList or {}
--=========================
-- MENU 1
--=========================
function MENU1_ON()
gg.alert(
    "⚠️ Feature Warning:\n" ..
    "• This function modifies game behavior and may affect match results.\n" ..
    "• The session may end immediately when the countdown timer finishes\n" ..
    "• Match outcome display may not reflect actual ranking behavior\n" ..
    "• History records may still show previous performance data\n" ..
    "• If using 'Max Hero Level' or 'One Hit Mobs', make sure to disable Push Rank feature to avoid conflicts or unintended behavior"
)
    RecordOriginalValue(GetPlayerRankSafe)
    injectAssembly(GetPlayerRankSafe, 1)

    RecordOriginalValue(GetPlayerRankCount_ULONG)
    injectAssembly(GetPlayerRankCount_ULONG, 1)

    RecordOriginalValue(GetPlayerRankCount_INT)
    injectAssembly(GetPlayerRankCount_INT, 1)

    RecordOriginalValue(GetAttrModResultOfSkill)
    injectRaw(GetAttrModResultOfSkill, {
        '12851EA0h',
        '72B78460h',
        '1E270000h',
        'D65F03C0h'
    })

    return true
end

function MENU1_OFF()
    RevertValue(GetPlayerRankSafe)
    
    RevertValue(GetPlayerRankCount_ULONG)
    
    RevertValue(GetPlayerRankCount_INT)
    
    RevertValue(GetAttrModResultOfSkill)
    return nil
end
--=========================
-- MENU 2
--=========================
function MENU2_ON(value)
    value = tonumber(value)
    if not value then return false end
    RecordOriginalValue(GetPlayerKillPlayerCount)
    
    injectAssembly(GetPlayerKillPlayerCount, value)
    
    RecordOriginalValue(GetPlayerKillRobotCount)
    
    injectAssembly(GetPlayerKillRobotCount, value)
    return true
end
--=========================
-- MENU 3
--=========================
function MENU3_ON()
X="CfgInGameLevelUp"
f="m_ExpToNextLevel"
t=4  field()
gg.getResults(1000)
gg.editAll(1,4)
gg.clearResults()
end
--=========================
-- MENU 4
--=========================
function MENU4_ON()
X="CfgMonster"
f="m_Base_HP"
t=4  field()
gg.getResults(1000)
gg.editAll(0,4)
gg.clearResults()
X="CfgMonster"
f="m_Attr0"
t=4  field()
gg.getResults(1000)
gg.editAll(21,4)
gg.clearResults()
end
--=========================
-- MAIN MENU SYSTEM
--=========================
function MN1()

    local PW = gg.prompt({
        "PUSH RANK",
        "〓 • KILL COUNT [0;16]",
        "MAX HERO LEVEL",
        "ONE HIT MOBS",
        "EXIT"
    }, checkList, {
        "checkbox",
        "number",
        "checkbox",
        "checkbox",
        "checkbox"
    })

    if not PW then return end
    checkList = PW

    --=========================
    -- EXIT
    --=========================
    if PW[5] then
        EXIT()
        return
    end

    --=========================
    -- FEATURE 1
    --=========================
    if PW[1] then
    if not hackState.autowin then
        if check("GetPlayerRankSafe")
        and check("GetPlayerRankCount_ULONG")
        and check("GetPlayerRankCount_INT")
        and check("GetAttrModResultOfSkill") then
            MENU1_ON()
            hackState.autowin = true
            gg.toast("Push Rank ENABLED 🔵")
        end
    end
else
    if hackState.autowin then
        MENU1_OFF()
        hackState.autowin = false
        gg.toast("Push Rank DISABLED 🔴")
    end
end
    --=========================
    -- FEATURE 2
    --=========================
local value = tonumber(PW[2])
if value then
    value = math.max(0, math.min(15, value))
    if check("GetPlayerKillPlayerCount")
    and check("GetPlayerKillRobotCount") then
        if hackState.kills ~= value then
            MENU2_ON(value)
            hackState.kills = value
            gg.toast("🔵 Kill Count Set: " .. value)
        end
    end
end
    --=========================
    -- FEATURE 3
    --=========================
    if PW[3] then
        if not hackState.maxlvl then
            MENU3_ON()
            hackState.maxlvl = true
            gg.toast("Max Level ENABLED 🔵")
        end
    else
        if hackState.maxlvl then
            hackState.maxlvl = false
            gg.toast("Max Level DISABLED 🔴")
        end
    end
    --=========================
    -- FEATURE 4
    --=========================
    if PW[4] then
        if not hackState.onehit then
            MENU4_ON()
            hackState.onehit = true
            gg.toast("One Hit Mobs ENABLED 🔵")
        end
    else
        if hackState.onehit then
            hackState.onehit = false
            gg.toast("One Hit Mobs DISABLED 🔴")
        end
    end
end
--=========================
-- ARM PATCH ENGINE
--=========================
function Arm()
    O = tonumber(O)
    if O == nil then return end
    for UwU = 1, #(X_X) do
        Inject = {}
--=========================
-- SINGLE VALUE PATCH
--=========================
        if type(X) ~= "table" then
            Inject[1] = {
                address = X_X[UwU] + O,
                flags = 4
            }
            if X == 0 then
                Inject[1].value = 'h000080D2'
            elseif X == 1 then
                Inject[1].value = 'h200080D2'
            else
                Inject[1].value = X
            end
            Inject[2] = {
                address = X_X[UwU] + (O + 4),
                flags = 4,
                value = 'D65F03C0h'
            }
--=========================
-- MULTI VALUE PATCH
--=========================
        else
            local offset = 0
            for Patch = 1, #(X) do
                Inject[Patch] = {
                    address = X_X[UwU] + O + offset,
                    flags = 4,
                    value = tostring(X[Patch])
                }
                offset = offset + 4
            end
        end
        gg.setValues(Inject)
    end
end
--=========================
-- EXIT HANDLER
--=========================
function EXIT()
    print(
        "👤 • Owner: Script4Fun\n" ..
        "📢 • Telegram Channel: https://t.me/ScriptForFun\n" ..
        "📺 • YouTube: https://www.youtube.com/@Script4FunGG"
    )
    os.exit()
end
--=========================
-- MAIN STATE VARIABLES
--=========================
local state = true
local firstHome = true
--=========================
-- MAIN EXECUTION LOOP
--=========================
while true do
    if gg.isVisible(true) then
        gg.setVisible(false)
--=========================
-- FIRST RUN ENTRY POINT
--=========================
        if firstHome then
            HOME()
            firstHome = false
        else
            MN1()
        end
    end
end