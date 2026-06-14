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
