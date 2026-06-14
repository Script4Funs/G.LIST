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
