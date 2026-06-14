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
