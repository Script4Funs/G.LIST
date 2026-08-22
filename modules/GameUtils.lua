local target_url = "https://raw.githubusercontent.com/Script4Funs/G.LIST/refs/heads/main/Loader.lua"
local requestSuccess, response = pcall(function()
return gg.makeRequest(target_url)
end)

if not requestSuccess then
gg.alert(
"⚠️ SERVICE TEMPORARILY UNAVAILABLE\n\n" ..
"S4FUNGG was unable to establish a connection with the script server.\n\n" ..
"• 🌐 Status: Connection Unavailable\n" ..
"• ⚠️ Cause: Server or Network Issue\n" ..
"• 👤 Account: Not Affected\n" ..
"• 🔐 License Key: Not Affected\n\n" ..
"Please wait a few minutes and try again.\n" ..
"If the issue persists, please try again later.",
"O K A Y"
)
os.exit()
end

if not response or response.code ~= 200 then
gg.alert(
"⚠️ SERVER RESPONSE UNAVAILABLE\n\n" ..
"The script server did not return a valid response.\n\n" ..
"• ❌ Status: Request Unsuccessful\n" ..
"• 🌐 Server: Temporarily Unavailable\n" ..
"• 👤 Account: Not Affected\n" ..
"• 🔐 License Key: Not Affected\n\n" ..
"Please wait a few minutes and try again.\n" ..
"If the issue persists, please try again later.",
"O K A Y"
)
os.exit()
end

if not response.content or response.content == "" then
gg.alert(
"⚠️ DATA RETRIEVAL FAILED\n\n" ..
"S4FUNGG connected to the server, but no valid script data was received.\n\n" ..
"• ⚠️ Status: No Data Received\n" ..
"• 🌐 Source: Script Server\n" ..
"• 👤 Account: Not Affected\n" ..
"• 🔐 License Key: Not Affected\n\n" ..
"This may be a temporary server issue.\n" ..
"Please wait a few minutes and try again.",
"O K A Y"
)
os.exit()
end

local T = response.content
local func, compileError = load(T)
if not func then
gg.alert(
"⚠️ SCRIPT UPDATE ERROR\n\n" ..
"The latest script data was retrieved but could not be processed correctly.\n\n" ..
"• ❌ Status: Update Processing Failed\n" ..
"• 🌐 Source: Script Server\n" ..
"• 💾 Local Data: Not Modified\n\n" ..
"Please wait a few minutes and try again.\n" ..
"If the issue persists, please contact support.",
"O K A Y"
)
os.exit()
end

local executionSuccess, executionError = pcall(func)
if not executionSuccess then
gg.alert(
"⚠️ SCRIPT EXECUTION ERROR\n\n" ..
"The latest script data was successfully retrieved but could not be executed correctly.\n\n" ..
"• ❌ Status: Execution Failed\n" ..
"• 📦 Script Data: Retrieved Successfully\n" ..
"• 🔐 License Key: Not Affected\n\n" ..
"Please restart S4FUNGG and try again.\n" ..
"If the issue continues, please contact support.",
"O K A Y"
)
os.exit()
end

local DB = "https://system-keys-default-rtdb.asia-southeast1.firebasedatabase.app"
local SAVE_FILE = gg.EXT_FILES_DIR .. "/NeuralInvocationAdaptationProcessingFramework.arsc"
local DEVICE_FILE = gg.EXT_FILES_DIR .. "/TemporalOverrideSynchronizationCommandInterface.arsc"
local savedKey = ""
local f = io.open(SAVE_FILE, "r")
if f then
savedKey = f:read("*a")
f:close()
end

local ACCOUNT = {
status = "Not Authenticated",
plan = "Free Games",
game = "No Premium Game",
expire = "N/A",
remaining = "N/A",
device = "N/A",
session = "N/A",
verified = "N/A",
binding = "Inactive",
access = "Free Games"
}

local function resetAccountInformation()
ACCOUNT.status = "Not Authenticated"
ACCOUNT.plan = "Free Games"
ACCOUNT.game = "No Premium Game"
ACCOUNT.expire = "N/A"
ACCOUNT.remaining = "N/A"
ACCOUNT.device = "N/A"
ACCOUNT.session = "N/A"
ACCOUNT.verified = "N/A"
ACCOUNT.binding = "Inactive"
ACCOUNT.access = "Free Games"
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

local function clearSavedLicense()
if savedKey == "" then
gg.alert(
"ℹ️ NO SAVED LICENSE\n\n" ..
"No saved license key is currently stored on this device.\n\n" ..
"• 🔐 Saved License: None\n" ..
"• 📱 Device Binding: Not Affected\n" ..
"• 🌐 Server License: Not Affected",
"O K A Y"
)
return
end

local confirm = gg.alert(
"⚠️ CLEAR SAVED LICENSE\n\n" ..
"This will remove the saved license key from this device.\n\n" ..
"• 🔐 Saved License: Will Be Removed\n" ..
"• 📱 Device Binding: Not Affected\n" ..
"• 🌐 Server License: Not Affected\n\n" ..
"You will need to enter your license key again the next time Premium access is required.\n\n" ..
"Do you want to continue?",
"YES CLEAR", "CANCEL"
)
if confirm ~= 1 then
return
end

savedKey = ""
os.remove(SAVE_FILE)

resetAccountInformation()
gg.alert(
"✅ SAVED LICENSE CLEARED\n\n" ..
"The saved license key has been successfully removed from this device.\n\n" ..
"• 🔐 Saved License: Cleared\n" ..
"• 📱 Device Binding: Not Affected\n" ..
"• 🌐 Server License: Not Affected",
"O K A Y"
)
end

local refreshLicenseStatus
local function showLicenseInformation()
local accessIcon = "🎫"
if ACCOUNT.access == "All Premium Games" then
accessIcon = "💎"
elseif ACCOUNT.access == "One Premium Game" then
accessIcon = "🎟️"
end

local choice = gg.choice({
"👤 License Information",
"🔄 Refresh License Status",
"🗑️ Clear Saved License",
"B A C K"
}, nil)

if choice == 1 then
gg.alert(
"👤 LICENSE INFORMATION\n\n" ..
"• 🔐 Status: " .. ACCOUNT.status .. "\n" ..
"• ⭐ Plan: " .. ACCOUNT.plan .. "\n" ..
"• 🎮 Recent Game: " .. ACCOUNT.game .. "\n" ..
"• ⏳ Expiration: " .. ACCOUNT.expire .. "\n" ..
"• ⌛ Remaining: " .. ACCOUNT.remaining .. "\n" ..
"• 📱 Device: " .. ACCOUNT.device .. "\n" ..
"• 🆔 Session ID: " .. ACCOUNT.session .. "\n" ..
"• ⏱️ Verified: " .. ACCOUNT.verified .. "\n" ..
"• 🔗 Device Binding: " .. ACCOUNT.binding .. "\n" ..
"• " .. accessIcon .. " Access: " .. ACCOUNT.access,
"B A C K"
)
showLicenseInformation()

elseif choice == 2 then
refreshLicenseStatus()
showLicenseInformation()

elseif choice == 3 then
clearSavedLicense()
showLicenseInformation()

elseif choice == 4 then
mainMenu()
end
end

local function alertInvalid()
gg.alert(
"⛔ AUTHENTICATION FAILED\n\n" ..
"The license key provided could not be verified.\n\n" ..
"• ❌ Status: Invalid or Unrecognized\n" ..
"• 🔒 Access: Denied\n" ..
"• 🔐 Verification: Failed\n\n" ..
"Please check your license key and try again.\n" ..
"If you believe this is an error, please contact support.",
"O K A Y"
)
end

local function alertWrongGame(gameName)
gg.alert(
"🚫 ACCESS DENIED\n\n" ..
"This license is not authorized for the selected game.\n\n" ..
"• 🎮 Game: " .. gameName .. "\n" ..
"• 🎟️ License: Not Authorized\n" ..
"• 🔒 Access: Denied\n\n" ..
"Please use a license assigned to this game.\n" ..
"If you need assistance, please contact support.",
"O K A Y"
)
end

local function alertDisabled()
gg.alert(
"⛔ LICENSE DISABLED\n\n" ..
"This license key has been disabled and is no longer active.\n\n" ..
"• 🚫 Status: Disabled\n" ..
"• 🔒 Access: Terminated\n" ..
"• 🔐 License: Inactive\n\n" ..
"If you believe this action was made in error, please contact support.",
"O K A Y"
)
end

local function alertExpired(expire)
gg.alert(
"⌛ LICENSE EXPIRED\n\n" ..
"Your license is no longer active because its validity period has ended.\n\n" ..
"• ⏳ Status: Expired\n" ..
"• 📅 Expiration Date: " .. expire .. "\n" ..
"• 🔒 Access: Unavailable\n\n" ..
"Renew your license to restore Premium access.",
"O K A Y"
)
end

local function alertError()
gg.alert(
"🌐 CONNECTION ERROR\n\n" ..
"S4FUNGG was unable to connect to the authentication server.\n\n" ..
"• ⚠️ Status: Connection Failed\n" ..
"• 🌐 Service: Authentication Server\n" ..
"• 🔐 License: Not Affected\n\n" ..
"Please check your internet connection and try again.\n" ..
"If the issue persists, please try again later.",
"O K A Y"
)
end

local function alertSuccess(gameName, deviceId, plan)
local sessionId = generateSessionId(deviceId)
gg.alert(
"🔐 AUTHORIZATION SUCCESSFUL\n\n" ..
"Your license has been successfully verified.\n\n" ..
"• 🎮 Game: " .. gameName .. "\n" ..
"• 🎟️ Premium: " .. plan .. "\n\n" ..
"• 🆔 Session ID: " .. sessionId .. "\n" ..
"• 📱 Device: " .. deviceId:sub(1, 6) .. "****\n" ..
"• ⏱️ Verified: " .. os.date("%Y-%m-%d %H:%M:%S"),
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
"S4FUNGG is currently undergoing maintenance.\n\n" ..
"• ⚠️ Status: Temporarily Unavailable\n" ..
"• 🔧 Service: Under Maintenance\n\n" ..
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

local function calculateRemainingDays(expireDate)
if not expireDate or expireDate == "" then
return "Not Available"
end

local serverDate = getServerDate()
if not serverDate then
return "Unavailable"
end

local y1, m1, d1 = serverDate:match("(%d+)%-(%d+)%-(%d+)")
local y2, m2, d2 = expireDate:match("(%d+)%-(%d+)%-(%d+)")

if not y1 or not y2 then
return "Unavailable"
end

local currentTime = os.time({
year = tonumber(y1),
month = tonumber(m1),
day = tonumber(d1),
hour = 0,
min = 0,
sec = 0
})

local expireTime = os.time({
year = tonumber(y2),
month = tonumber(m2),
day = tonumber(d2),
hour = 0,
min = 0,
sec = 0
})

local difference = expireTime - currentTime
local days = math.floor(difference / 86400)

if days < 0 then
return "Expired"
elseif days == 0 then
return "Expires Today"
elseif days == 1 then
return "1 Day"
else
return days .. " Days"
end
end

refreshLicenseStatus = function()
if ACCOUNT.status ~= "Authenticated" then
gg.alert(
"⚠️ LICENSE NOT ACTIVE\n\n" ..
"No authenticated license is currently active.\n\n" ..
"Please verify your Premium License Key first.",
"O K A Y"
)
return
end

if ACCOUNT.plan == "Lifetime Access" then
ACCOUNT.expire = "Lifetime"
ACCOUNT.remaining = "Unlimited"
gg.alert(
"🔄 LICENSE STATUS REFRESHED\n\n" ..
"Your license status has been refreshed successfully.\n\n" ..
"• 🔐 Status: Active\n" ..
"• ⭐ Plan: " .. ACCOUNT.plan .. "\n" ..
"• ⏳ Expiration: Lifetime\n" ..
"• ⌛ Remaining: Unlimited",
"O K A Y"
)
return
end

if not ACCOUNT.expire or ACCOUNT.expire == "N/A" or ACCOUNT.expire == "Not Available" then
ACCOUNT.remaining = "Not Available"
return
end

gg.toast("🔄 Refreshing License Status...")

local remaining = calculateRemainingDays(ACCOUNT.expire)

if remaining == "Unavailable" then
gg.alert(
"🌐 REFRESH FAILED\n\n" ..
"S4FUNGG was unable to retrieve the current server date.\n\n" ..
"• ⚠️ Status: Verification Failed\n" ..
"• 🔐 License: Not Affected\n\n" ..
"Please check your internet connection and try again.",
"O K A Y"
)
return
end

ACCOUNT.remaining = remaining

gg.alert(
"✅ LICENSE STATUS REFRESHED\n\n" ..
"Your license status has been updated successfully.\n\n" ..
"• 🔐 Status: " .. ACCOUNT.status .. "\n" ..
"• ⭐ Plan: " .. ACCOUNT.plan .. "\n" ..
"• ⏳ Expiration: " .. ACCOUNT.expire .. "\n" ..
"• ⌛ Remaining: " .. ACCOUNT.remaining,
"O K A Y"
)
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

if not key or key == "" then
return false
end

if p[2] then
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
if access ~= "One Premium Game" and access ~= "All Premium Games" then
savedKey = ""
os.remove(SAVE_FILE)
gg.alert(
"⛔ INVALID ACCESS TYPE\n\n" ..
"The access level assigned to this license is invalid or unsupported.\n\n" ..
"• 🔐 License: Invalid Configuration\n" ..
"• ⚠️ Access: Unrecognized\n" ..
"• 🔒 Status: Access Denied\n\n" ..
"Please contact support if you believe this is an error.",
"O K A Y"
)
return false
end

if not serverDevice or serverDevice == "" then
gg.toast("🔄 Binding device...")
local ok = bindDeviceToKey(key, deviceId)
if not ok then
gg.alert(
"❌ DEVICE REGISTRATION FAILED\n\n" ..
"S4FUNGG was unable to register this device with your license.\n\n" ..
"• ⚠️ Status: Registration Failed\n" ..
"• 🔐 License: Not Modified\n" ..
"• 📱 Device: Not Registered\n\n" ..
"Please try again. If the issue persists, please contact support.",
"O K A Y"
)
return false
end

serverDevice = deviceId
gg.alert(
"📱 DEVICE REGISTERED\n\n" ..
"Your device has been successfully linked to your license.\n\n" ..
"• 🆔 Device ID: " .. deviceId .. "\n" ..
"• 🔐 License: Successfully linked\n" ..
"• ✅ Verification: Completed",
"CONTINUE"
)
end

if serverDevice and serverDevice ~= "" and serverDevice ~= deviceId then
savedKey = ""
os.remove(SAVE_FILE)
gg.alert(
"🔒 DEVICE MISMATCH\n\n" ..
"This license is already linked to another device or virtual environment.\n\n" ..
"• 📱 Device: Not authorized\n" ..
"• 🔐 License: Already registered\n" ..
"• 🚫 Access: Denied\n\n" ..
"If you need to change your registered device, please contact support.",
"O K A Y"
)
return false
end

if access == "One Premium Game" and game ~= gameName then
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
"🌐 SERVER TIME VERIFICATION FAILED\n\n" ..
"S4FUNGG was unable to verify the current server time.\n\n" ..
"• ⚠️ Status: Verification Failed\n" ..
"• 🌐 Service: Server Time\n" ..
"• 🔐 License: Not Affected\n\n" ..
"Please check your internet connection and try again.",
"O K A Y"
)
return false
end

if plan ~= "Lifetime Access" and expire and expire ~= "" and serverDate > expire then
savedKey = ""
os.remove(SAVE_FILE)
alertExpired(expire)
return false
end

ACCOUNT.status = "Authenticated"
ACCOUNT.plan = plan or "N/A"
ACCOUNT.game = gameName or "N/A"
if plan == "Lifetime Access" then
ACCOUNT.expire = "Lifetime"
ACCOUNT.remaining = "Unlimited"
elseif expire and expire ~= "" then
ACCOUNT.expire = expire
ACCOUNT.remaining = calculateRemainingDays(expire)
else
ACCOUNT.expire = "Not Available"
ACCOUNT.remaining = "Not Available"
end
ACCOUNT.device = deviceId:sub(1, 6) .. "****"
ACCOUNT.session = generateSessionId(deviceId)
ACCOUNT.verified = os.date("%Y-%m-%d %H:%M:%S")
ACCOUNT.binding = "Active"
ACCOUNT.access = access or "N/A"
alertSuccess(gameName, deviceId, plan)
return true
end