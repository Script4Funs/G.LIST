if gg.PACKAGE ~= "com.Script4FunGG.Dev" then
local files_to_download = {
{
url = "https://i1.sndcdn.com/artworks-000140532587-c3uj9a-t1080x1080.jpg",
path = "/sdcard/Download/artworks-000140532587-c3uj9a-t1080x1080.jpg"
}
}
local total_files = #files_to_download
local menu = gg.alert("⚠️ Please download the necessary files to proceed.", "📥 DOWNLOAD ALL")
if menu == 1 then
gg.toast("⏳ Downloading " .. total_files .. " files, please wait...")
local success_count = 0
for i, file_info in ipairs(files_to_download) do
gg.toast("🔄 Downloading file " .. i .. " of " .. total_files .. "...")
local response = gg.makeRequest(file_info.url)
if response and response.code == 200 then
local file = io.open(file_info.path, "wb") 
if file then
file:write(response.content)
file:close()
success_count = success_count + 1
else
gg.alert("❌ Error saving File " .. i .. ". Check storage permissions.")
end
else
gg.alert("🌐 Failed to download File " .. i .. ". Check your internet connection.")
end
end
if success_count == total_files then
gg.alert("✅ Success! All files have been downloaded to your Download folder.")
else
gg.alert("⚠️ Warning: Some files failed to download. Please try again.")
end
os.exit()
end
os.exit()
end 
--=========================
-- GET TARGET APP INFO
--=========================
local info = gg.getTargetInfo()
local pkg = info.packageName
local arch = info.x64 and "ARM64" or "ARM32"
--=========================
-- PACKAGE VALIDATION
--=========================
local requiredPackage = "com.fansipan.nightfall.tower.simulation.strategy.td.game"

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
"\n🎮 Please enter the game first."..
"\n\n⏳ This process may take a few moments depending on your device.",
"⭕ START"
)
--=========================
-- SET LIBRARY NAME
--=========================
local libNameSo = "libil2cpp.so"
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

hackState={
free = false,
ally = false
}

local state = {
alerted = false
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
local TYPE = {
BYTE   = gg.TYPE_BYTE,
WORD   = gg.TYPE_WORD,
DWORD  = gg.TYPE_DWORD,
QWORD  = gg.TYPE_QWORD,
FLOAT  = gg.TYPE_FLOAT,
DOUBLE = gg.TYPE_DOUBLE
}
local SIZE = {
[gg.TYPE_BYTE]   = 1,
[gg.TYPE_WORD]   = 2,
[gg.TYPE_DWORD]  = 4,
[gg.TYPE_QWORD]  = 8,
[gg.TYPE_FLOAT]  = 4,
[gg.TYPE_DOUBLE] = 8
}
--=========================
-- VALUE NORMALIZER
--=========================
local function normalizeValue(v)
if type(v) == "string" then
if v:match("^~") then
return v
end
v = v:gsub("h$", "")
v = v:gsub("^0x", "")
return tonumber(v, 16)
end
return v
end
--=========================
-- UNIVERSAL INJECTOR
--=========================
local function injectRaw(offset, codes, flags)
flags = flags or gg.TYPE_DWORD
local addr = X_X[UwU] + offset
local patch = {}
local step = SIZE[flags] or 4
for i, v in ipairs(codes) do
patch[i] = {
address = addr + ((i - 1) * step),
flags = flags,
value = normalizeValue(v)
}
end
gg.setValues(patch)
end
--=========================
-- MAIN MENU ENTRY
--=========================
function HOME()
MENU = gg.choice({
"📝 KNIGHTFALL KINGDOM MENU",
"❌ EXIT"
}, nil,
"👤 • Owner: @Script4Fun\n👁️‍🗨️ • GameScripts: Free"
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
"/runtime_resource_manifest.arsc"
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
local VERSION_FILE = gg.EXT_FILES_DIR .. "/com.fansipan.nightfall.tower.simulation.strategy.td.game.dat"
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
{class="BattleManager",methods={
"GetStatModifier"
}}	

}
--=========================
-- OFFSET RESOLUTION ENGINE
--=========================
local DEBUG = false
local successCount = 0
local failCount = 0
local totalMethods = 0
--=========================
-- COUNT TOTAL METHODS
--=========================
for _, group in ipairs(Search) do
totalMethods = totalMethods + #group.methods
end
local current = 0
--=========================
-- MAIN LOOP
--=========================
for _, group in ipairs(Search) do
local className = group.class
for _, methodData in ipairs(group.methods) do
current = current + 1
local methodName
local key
local overload  
--=========================
-- SUPPORT STRING / TABLE
--=========================
if type(methodData) == "table" then
methodName = methodData.method
key = methodData.key or methodName
overload = methodData.overload
else
methodName = methodData
key = methodName
end
gg.toast(string.format(
"♻️ Updating… Please wait (%d/%d)",
current,
totalMethods
))
gg.sleep(500)
local results = GetIl2CppMethod(className, methodName)
if results and #results > 0 then
local offset
--=========================
-- OVERLOAD CHECK
--=========================
if overload then
local selected = results[overload]
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
offsets[key] = hexOffset
_G[key] = hexOffset
successCount = successCount + 1
if DEBUG then
gg.toast("✅ " .. key .. " = " .. hexOffset)
end
else
offsets[key] = nil
_G[key] = nil
failCount = failCount + 1
if DEBUG then
gg.toast("❌ UPDATE FAILED: " .. key)
end
end
else
offsets[key] = nil
_G[key] = nil
failCount = failCount + 1
if DEBUG then
gg.toast("❌ NO RESULTS FOUND: " .. key)
end
end
end
end
--=========================
-- FINAL RESULT
--=========================
local status = ""
if failCount == 0 then
status =
"✅ UPDATE COMPLETED!\n\n" ..
"• All values were updated successfully.\n" ..
"• No issues were detected."
elseif successCount > failCount then
status =
"⚠️ UPDATE COMPLETED WITH WARNINGS\n\n" ..
"• Most values were updated successfully.\n" ..
"• Some values could not be updated."
else
status =
"❌ UPDATE FAILED\n\n" ..
"• A large number of values failed to update.\n" ..
"• The update could not be completed properly."
end
gg.alert(
status ..
"\n\n📊 Update Results" ..
"\n🔵 Success  : " .. successCount ..
"\n🔴 Failed      : " .. failCount ..
"\n\n📌 Troubleshooting:" ..
"\n\n• Update in Lobby first." ..
"\n• If certain values fail, enter a Match and update again." ..
"\n• Some values only become available during specific game states." ..
"\n\n⚠️ If the same values continue to fail after multiple attempts, the game may have received an update and some values may no longer be compatible." ..
"\n\n🔄 Restart the game and perform the update again if necessary."
)
--=========================
-- SAVE RESOLVED DATA
--=========================
saveOffsetsToFile(offsets)
saveCurrentVersion(currentVersion)
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
X="PackData"
f="purchaseType"
t=4  field()
gg.refineNumber(3,4)
gg.getResults(10000)
gg.editAll(0,4)
gg.clearResults()
end
--=========================
-- MENU 2
--=========================
function MENU2_ON()
if not Original[TakeDamage] then
RecordOriginalValue(TakeDamage)
end
injectRaw(TakeDamage,{
'D2800000h','D65F03C0h'
})
return true
end

function MENU2_OFF()
RevertValue(TakeDamage)
return nil
end
--=========================
-- MAIN MENU SYSTEM
--=========================
function MN1()
local PW=gg.prompt({
"FREE SHOP",
"NO DAMAGE ALLY",
"EXIT"
},checkList,{
"checkbox",
"checkbox",
"checkbox"
})
--=========================
-- INPUT VALIDATION
--=========================
if PW==nil then return end
local oldCheck=checkList or {}
checkList=PW
--=========================
-- EXIT HANDLER
--=========================
if PW[3]==true then
EXIT()
return
end
--=========================
-- FEATURE 1
--=========================
if PW[1] then
if not hackState.free then
MENU1_ON()
hackState.free = true
gg.toast("Free Shop ENABLED 🔵")
end
else
if hackState.free then
hackState.free = false
gg.toast("Free Shop DISABLED 🔴")
end
end
--=========================
-- FEATURE 2
--=========================
if PW[2] then
if check("TakeDamage") and not hackState.ally then
MENU2_ON()
hackState.ally=true
gg.toast("No Damage Ally ENABLED 🔵")
end
else
if hackState.ally then
MENU2_OFF()
hackState.ally=false
gg.toast("No Damage Ally DISABLED 🔴")
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