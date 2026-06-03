--=========================
-- GG CHECK
--=========================
if gg.PACKAGE ~= "com.Script4FunGG.Dev" then
    return
end

if gg.isVisible() then
  gg.setVisible(false)
end
--=========================
-- VERSION CONTROL SYSTEM
--=========================
local VERSION_FILE = gg.EXT_FILES_DIR .. "/com.gameinsight.gobandroid.dat"

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
    end
end

--=========================
-- VERSION CHECK LOGIC
--=========================
local savedVersion = loadSavedVersion()
local needUpdate = false

if savedVersion ~= currentVersion then
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

    saveCurrentVersion(currentVersion)
end

--=========================
-- GET TARGET APP INFO
--=========================
local info = gg.getTargetInfo()
local pkg = info.packageName
local arch = info.x64 and "ARM64" or "ARM32"
local APK = info.label or "Unknown"

--=========================
-- PACKAGE VALIDATION
--=========================
local requiredPackage = "com.gameinsight.gobandroid"

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

    "\n\n🎮 APK Name: "..APK..
    "\n📦 Package: "..pkg..
    "\n🖥️ Architecture: "..arch..

    "\n\n✅ Compatible environment detected."..
    "\n⚙️ Script initialization completed."..

    "\n\n📢 SYSTEM STATUS:"..
    "\n🔍 Preparing memory scanner..."..
    "\n🛠️ Preparing feature database..."..
    "\n📡 Waiting for memory synchronization..."..
    "\n📂 Loading required resources..."..
    "\n🔐 Verifying execution environment..."..
    "\n☑️ System ready for scan process."..

    "\n\n⏳ Please wait while the scan process completes.",

    "⭕ START"
)

giantReady = false

-- lib function made by CmP
function metaDataOffsets()
  startAddressDat = 0
  endAddressDat = 0
  local rangesDat = gg.getRangesList("metadata.dat")
  for i, v in ipairs(rangesDat) do
    if v.state == "O" then
      startAddressDat = v.start
      endAddressDat   = rangesDat[i]["end"]
      break
    end
  end
end

metaDataOffsets()

-- string names
function stringNames()
  Class_AssemblyCSharp      = "h00417373656d626c792d4353686172702e646c6c00"
  Class_ControllerSettings  = "h00436f6e74726f6c6c657253657474696e677300"
  Class_Skills              = "h00536b696c6c7300"
  Class_vp_FPCCameraPreset  = "h0076705f465043616d65726150726573657400"
  Class_Weapons             = "h00576561706f6e7300"
  Class_ChatDataVO          = "h004368617444617461564f00"
end
stringNames()

function searchString(className)
  gg.clearResults()
  gg.searchNumber(className, gg.TYPE_BYTE, nil, nil, startAddressDat, endAddressDat)

  local t = gg.getResults(2)

  if t == nil or #t < 2 then
      gg.alert(
          "❌ Metadata Search Failed" ..
          "\n\nClass:\n" .. tostring(className) ..
          "\n\nPossible causes:" ..
          "\n• Game updated" ..
          "\n• Metadata changed" ..
          "\n• Wrong APK version"
      )
      os.exit()
  end

  tableMetadataOffsets = t[2].address
  gg.clearResults()
  return tableMetadataOffsets
end

	 
-- instruction set architecture
-- credits CmP
function isProcess64Bit()
  local regions = gg.getRangesList()
  local lastAddress = regions[#regions]["end"]
  return (lastAddress >> 32) ~= 0
end
-- end credits

function validISA()
  instructionSetArchitecture = 0
	if isProcess64Bit() == true then
		instructionSetArchitecture = 64
	elseif isProcess64Bit() == false then
		instructionSetArchitecture = 32
	end
  return instructionSetArchitecture
end
validISA()
-- offsets
function instructionsOffset()
  if instructionSetArchitecture == 32 then -- if true then 32 bit else 64 bit
    hexConvert = 0xFFFFFFFF
    dataType = 4
    classOffset = 0x8
    cdOffsetBig =  0xB58
  elseif instructionSetArchitecture == 64 then
    dataType = 32
    classOffset = 0x10
    cdOffsetBig = 0x16B0
  end
end
instructionsOffset()

function controllerSettingOffsets()
  if instructionSetArchitecture == 32 then -- if true then 32 bit else 64 bit
    headHitOffset = 0x78
    cameraLockOffset = 0x28
  elseif instructionSetArchitecture == 64 then
    headHitOffset = 0x80
    cameraLockOffset = 0x30
  end
end
controllerSettingOffsets()

function weaponSettingsOffsets()
  if instructionSetArchitecture == 32 then
    weaponPointerToIdOffset = 0x8
    weaponPointerToAmmoOffset = 0x48
    weaponPointerToRecoilOffset = 0x78
    weaponPointerToReloadOffset = 0x88
    weaponPointerToAccumulationFullOffset = 0xD0
    weaponPointerToAccumulationResetOffset = 0xE0
    weaponPointerToRecoilAimOffset = 0xB0
  elseif instructionSetArchitecture == 64 then
    weaponPointerToIdOffset = 0x10
    weaponPointerToAmmoOffset = 0x60
    weaponPointerToRecoilOffset = 0x90
    weaponPointerToReloadOffset = 0xA0
    weaponPointerToRecoilAimOffset = 0xC8
    weaponPointerToAccumulationFullOffset = 0xE8
    weaponPointerToAccumulationResetOffset = 0xF8
  end
end
weaponSettingsOffsets()

function skillsOffsets()
  if instructionSetArchitecture == 32 then
    skillIdOffset = 0x8
    skillIdExtraOffset = 0x10
  elseif instructionSetArchitecture == 64 then
    skillIdOffset = 0x10
    skillIdExtraOffset = 0x18
  end
end
skillsOffsets()

function zoomScopeOffsets()
  if instructionSetArchitecture == 32 then
    zoomOffset = 0xC
  elseif instructionSetArchitecture == 64 then
    zoomOffset = 0x18
  end
end
zoomScopeOffsets()

function libraryOffsets()
  if instructionSetArchitecture == 32 then
    userIdOffset = 0xC
    controllerOffset = 0x28
    nicknameOffset = 0x14
    pointerToStringStart = 0xA
    pointerToEmptyBool = 0xA
    stringLengthAddress = 0x8
  elseif instructionSetArchitecture == 64 then
    userIdOffset = 0x14
    controllerOffset = 0x3C
    nicknameOffset = 0x20
    pointerToStringStart = 0x12
    pointerToEmptyBool = 0x12
    stringLengthAddress = 0x10
  end
end
libraryOffsets()
-- check 
if gg.isVisible() then
  gg.setVisible(false)
end

function assemblyAddressCheck()
  gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)
  searchString(Class_AssemblyCSharp)
  gg.searchNumber(tableMetadataOffsets, dataType) -- dataType: 32bit = 4(dword) | 64bit = 32(qword)
  if gg.getResultsCount() == 0 then
    gg.alert('game has been updated, so script needs an update. Reach out to the creator "Nok1a" by responding in the forum at the same post where you downloaded the script')
    os.exit()
  end
  assembly = gg.getResults(1)

if assembly == nil or #assembly == 0 then
    gg.alert(
    "❌ Feature Activation Failed\n\n" ..
    "Unable to locate the required assembly address.\n\n" ..
    "Requirements:\n" ..
    "✓ Correct game process selected\n" ..
    "✓ Player is in the game lobby\n" ..
    "✓ Game resources fully loaded\n\n" ..
    "Please verify the requirements above and try again.\n\n" ..
    "If the problem continues, an update to the script may be required."
)
os.exit()
end

gg.clearResults()
return assembly
end
assemblyAddressCheck()

local old = gg.getRanges();

-- main feature settings

loopControllerSettings = 0
function controllerSettings()
  -- START: this code only runs once
  loopControllerSettings = loopControllerSettings + 1
  if loopControllerSettings <= 1 then
    gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)
    searchString(Class_ControllerSettings)
    gg.searchNumber(tableMetadataOffsets, dataType)
    a = gg.getResults(5)
    for i, v in ipairs(a) do
      v.address = v.address - classOffset -- classOffset: 32bit = 0x8 | 64bit = 0x10
    end
    a = gg.getValues(a)
    gg.clearResults()
    b = {}
    for i,v in ipairs(a) do
      if instructionSetArchitecture == 32 then
        v.value = v.value & hexConvert -- hexConvert: 32bit = 0xFFFFFFFF
      end
      if v.value == assembly[1].address then
        b[#b + 1] = v
      end
    end

    gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)
    gg.searchNumber(b[1].address, dataType)
    a = gg.getResults(500)
    gg.clearResults()
    headHitBox = {}
    cameraLock = {}
    for i, v in ipairs(a) do
      headHitBox[i] = {address = v.address + headHitOffset, flags = gg.TYPE_DOUBLE} -- headHitOffset: 32bit = 0x78 | 64bit = 0x80
      cameraLock[i] = {address = v.address + cameraLockOffset, flags = gg.TYPE_DOUBLE}
    end
    headHitBox = gg.getValues(headHitBox)
    cameraLock = gg.getValues(cameraLock)
    gg.toast('♻️ Processing… Please wait')
    gg.sleep(500)
    return headHitBox, cameraLock
  end
end
controllerSettings()

loopSkills = 0
function skillsGroup()
  loopSkills = loopSkills + 1
  if loopSkills <= 1 then
    searchString(Class_Skills)
    gg.searchNumber(tableMetadataOffsets, dataType, gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER))
    a = gg.getResults(15)
    for i, v in ipairs(a) do
      v.address = v.address - classOffset -- 32bit = 0x8, 64bit = 0x10
    end
    a = gg.getValues(a)
    teser = {}
    for i, v in ipairs(a) do
      if instructionSetArchitecture == 32 then
      v.value = v.value & hexConvert -- hexConvert: 32bit = 0xFFFFFFFF
      end
      if (v.value == assembly[1].address) then
        teser[#teser + 1] = v
      end
    end
    gg.clearResults()
    gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)
    gg.searchNumber(teser[1].address, dataType) -- dataType: 32bit = 4(dword) | 64bit = 32(qword)
    if gg.getResultsCount() <= 50 then 
      gg.clearResults()
      gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)
      gg.searchNumber(teser[2].address, dataType)
    end
    a = gg.getResults(10000)
    for i, v in ipairs(a) do
      v.address = v.address + skillIdOffset -- skillIdOffset: 32bit = 0x8 | 64bit = 0x10
      v.flags = gg.TYPE_DWORD
    end
    gg.clearResults()
    end
    skills = gg.getValues(a)
  return skills
end
skillsGroup()


-- weaponsSettingsTables
function weaponsSettingsTableOn()
  recoilTableOn = {}
  recoilAimTableOn = {}
  reloadTimeTableOn = {}
  maxAmmoCapacityTableOn = {}
  accumulationFullTableOn = {}
  accumulationResetTableOn = {}
end
weaponsSettingsTableOn()
function weaponsSettingsTableOff()
  recoilTableOff = {}
  recoilAimTableOff = {}
  reloadTimeTableOff = {}
  maxAmmoCapacityTableOff = {}
  accumulationFullTableOff = {}
  accumulationResetTableOff = {}
end
weaponsSettingsTableOff()


function weaponsSettings()
  gg.clearResults()
  gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_C_ALLOC | gg.REGION_OTHER)
  searchString(Class_Weapons)
  gg.searchNumber(tableMetadataOffsets, dataType)
  a = gg.getResults(5)
  for i, v in ipairs(a) do
    v.address = v.address - classOffset -- classOffset: 32bit = 0x8 | 64bit = 0x10
  end
  a = gg.getValues(a)
  gg.clearResults()
  compareWeaponsToAssembly = {}
  for i,v in ipairs(a) do
    if instructionSetArchitecture == 32 then
      v.value = v.value & hexConvert -- hexConvert: 32bit = 0xFFFFFFFF
    end
    if v.value == assembly[1].address then
      compareWeaponsToAssembly[#compareWeaponsToAssembly + 1] = v
    end
  end
  gg.searchNumber(compareWeaponsToAssembly[1].address, dataType)
  weaponPointers = gg.getResults(1141)
  gg.clearResults()
  weaponId = {}
  for i, v in ipairs(weaponPointers) do
    v.address = v.address + weaponPointerToIdOffset
    v.flags = gg.TYPE_DWORD
  end
  weaponPointers = gg.getValues(weaponPointers)
  for i, v in ipairs(weaponPointers) do
    if v.value >= 253 and v.value <= 99644 then
      weaponId[#weaponId + 1] = {address = v.address - weaponPointerToIdOffset, flags = dataType}
    end
  end

  for i, v in ipairs(weaponId) do
    recoilTableOn[i] = {address = v.address + weaponPointerToRecoilOffset, flags = gg.TYPE_DOUBLE, value = '0'}
    recoilAimTableOn[i] = {address = v.address + weaponPointerToRecoilAimOffset, flags = gg.TYPE_DOUBLE, value = '0'}
    reloadTimeTableOn[i] = {address = v.address + weaponPointerToReloadOffset, flags = gg.TYPE_DOUBLE, value = '0'}
    maxAmmoCapacityTableOn[i] = {address = v.address + weaponPointerToAmmoOffset, flags = gg.TYPE_DWORD, value = '5000'}
    accumulationFullTableOn[i] = {address = v.address + weaponPointerToAccumulationFullOffset, flags = gg.TYPE_BYTE, value = '0'}
    accumulationResetTableOn[i] = {address = v.address + weaponPointerToAccumulationResetOffset, flags = gg.TYPE_BYTE, value = '0'}
  end
  recoilTableOff = gg.getValues(recoilTableOn)
  recoilAimTableOff = gg.getValues(recoilAimTableOn)
  reloadTimeTableOff = gg.getValues(reloadTimeTableOn)
  maxAmmoCapacityTableOff = gg.getValues(maxAmmoCapacityTableOn)
  accumulationFullTableOff = gg.getValues(accumulationFullTableOn)
  accumulationResetTableOff = gg.getValues(accumulationResetTableOn)
end
weaponsSettings()


-- controll setting features
loopHeadHitbox = 0
function headHitBoxSize()
  loopHeadHitbox = loopHeadHitbox + 1
  if loopHeadHitbox <= 1 then
    box = {}
    for i, v in ipairs(headHitBox) do
      if v.value == '1.25'
      or v.value == '3.25'
      or v.value == '7.25'
      or v.value == '15.25' then
        box[#box + 1] = v
      end
    end
  else
    
    gg.clearResults()
    if hitboxs == 1 then
      hitt = off
      box[1].value = "1.25"
      toast = gg.toast('Normal ENABLED 🔵')
    elseif hitboxs == 2 then
      hitt = on
      box[1].value = "3.25"
      toast = gg.toast('Balanced ENABLED 🔵')
    elseif hitboxs == 3 then
      hitt = on
      box[1].value = "7.25"
      toast = gg.toast('Aggressive ENABLED 🔵')
    elseif hitboxs == 4 then
      hitt = on
      box[1].value = "15.25"
      toast = gg.toast('Extreme ENABLED 🔵')
    end
    gg.clearResults()
    gg.setValues(box)
  end
  return box[1].value, toast
end   
headHitBoxSize()

loopCameraLock = 0
function cameraLockF()
  loopCameraLock = loopCameraLock + 1
  if loopCameraLock <= 1 then
    cameraLockTable = {}
    for i, v in ipairs(cameraLock) do
      if v.value == 200 then
        cameraLockTable[#cameraLockTable + 1] = v
      end
    end
  else
    if aimlock == on then
      cameraLockTable[1].value = '400'
      toast = gg.toast('High Aim Assist ENABLED 🔵')
    else
      cameraLockTable[1].value = '200'
      toast = gg.toast('High Aim Assist DISABLED 🔴')
    end
    gg.setValues(cameraLockTable)
  end
  return
end
cameraLockF()


-- standalone features
loopAdmin = 0
function adminPanel()
  if instructionSetArchitecture == 64 then
    gg.alert(
    "🔒 FEATURE NOT SUPPORTED" ..
    "\n\n⚙️ Admin Panel Compatibility Check Failed." ..
    "\n\n📋 Requirement:" ..
    "\n• 32-bit Game Version" ..
    "\n\n📊 Detected Environment:" ..
    "\n• 64-bit Architecture" ..
    "\n\n❌ For stability and compatibility reasons, this feature has been disabled on 64-bit builds." ..
    "\n\n💡 Switch to the 32-bit APK to enable Admin Panel functionality.",
    "UNDERSTOOD"
)
    pane = off
  else 
    -- START: this code only runs once
    loopAdmin = loopAdmin + 1
    if loopAdmin <= 1 then
      gg.setRanges(gg.REGION_CODE_APP)
      gg.searchNumber('h 01 00 00 1A 00 00 A0 E3 70 8C BD E8 18 10 9F E5 01 10 9F E7', gg.TYPE_BYTE)
      pan = gg.getResults(1)
      gg.clearResults()
    else
      if pane == on then
        pan[1].value = '0'
        toast = gg.toast('Admin Panel ENABLED 🔵')
      else
        pan[1].value = '1'
        toast = gg.toast('Admin Panel DISABLED 🔴')
      end
      gg.setValues(pan)
    end
    return pan[1].value, toast
  end
end
adminPanel()


function theGiant()
  if not giantReady then
    gg.toast("⏳ Player Height Initializing...")
    return
  end

  if giants ~= on then
    return
  end

  local heightValuesCheck = {}

  for i, v in ipairs(results) do
    heightValuesCheck[(i - 1) * 3 + 1] = {address = v.address - 0x104, flags = gg.TYPE_FLOAT}
    heightValuesCheck[(i - 1) * 3 + 2] = {address = v.address - 0x100, flags = gg.TYPE_FLOAT}
    heightValuesCheck[(i - 1) * 3 + 3] = {address = v.address - 0xFC, flags = gg.TYPE_FLOAT}
  end

  heightValuesCheck = gg.getValues(heightValuesCheck)

  heightValues = {}
  for i, v in ipairs(heightValuesCheck) do
    if v.value == 1 then
      heightValues[#heightValues + 1] = v
    end
  end

  for i, v in ipairs(heightValues) do
    v.value = '2.125478'
  end

  gg.setValues(heightValues)
end

-- skills features
loopAutoFire = 0
function autoF()
  loopAutoFire = loopAutoFire + 1
  if loopAutoFire <= 1 then
    auto = {}
    for i, v in ipairs(skills) do
      if v.value == 217 then
        auto[#auto + 1] = v
      end
    end
    
    for i, v in ipairs(auto) do
      v.address = v.address + skillIdExtraOffset -- skillIdExtraOffset: 32bit = 0x10 | 64bit = 0x18
      v.flags = gg.TYPE_DOUBLE
    end
    
    auto = gg.getValues(auto)
    gg.clearResults()
  else
    if autoFi == on then
      auto[1].value = '500'
      toast = gg.toast('Auto Fire ENABLED 🔵')
    else
      auto[1].value = '0'
      toast = gg.toast('Auto Fire DISABLED 🔴')
    end
    gg.setValues(auto)
    gg.clearResults()
  end
  return auto[1].value, toast
end
autoF()

loopBulletFraction = 0
function bulletFractionInc()
    -- START: this code only runs once
  loopBulletFraction = loopBulletFraction + 1
  if loopBulletFraction <= 1 then
    damg = {}
    for i, v in ipairs(skills) do
      if v.value == 224 then
        damg[#damg + 1] = v
      end
    end
    
    for i, v in ipairs(damg) do
      v.address = v.address + skillIdExtraOffset -- skillIdExtraOffset: 32bit = 0x10 | 64bit = 0x18
      v.flags = gg.TYPE_DOUBLE
    end
    
    damg = gg.getValues(damg)
    gg.clearResults()
  else
    if damge == on then
      damg[1].value = '2'
      toast = gg.toast('Double Damage ENABLED 🔵')
    else
      damg[1].value = '1'
      toast = gg.toast('Double Damage DISABLED 🔴')
    end
    gg.setValues(damg)
    gg.clearResults()
  end
  return damg[1].value, toast
end
bulletFractionInc()

loopAmmo = 0
function ammoHolderInc()
    -- START: this code only runs once
  loopAmmo = loopAmmo + 1
  if loopAmmo <= 1 then
    ammoClip = {}
    for i, v in ipairs(skills) do
      if v.value == 2998 then
        ammoClip[#ammoClip + 1] = v
      end
    end
    for i, v in ipairs(ammoClip) do
      v.address = v.address + skillIdExtraOffset -- skillIdExtraOffset: 32bit = 0x10 | 64bit = 0x18
      v.flags = gg.TYPE_DOUBLE
    end
    gg.clearResults()
    gg.toast('♻️ Processing… Ready')
    gg.sleep(500)
  else
  if magz == on then
    ammoClip[1].value = '1000'
    toast = gg.toast('5K Ammo ENABLED 🔵')
  else
    ammoClip[1].value = '0'
    toast = gg.toast('5K Ammo DISABLED 🔴')
  end
  gg.setValues(ammoClip)
  end
  return ammoClip[1].value, toast
end
ammoHolderInc()

-- weapons features
function weaponSettingsRecoil()
  if recoil == on then
    gg.setValues(recoilTableOn)
    gg.setValues(recoilAimTableOn)
    gg.toast('Recoil Control ENABLED 🔵')
  elseif recoil == off then
    gg.setValues(recoilTableOff)
    gg.setValues(recoilAimTableOff)
    gg.toast('Recoil Control DISABLED 🔴')
  end
end

function weaponSettingsReload()
  if reload == on then
    gg.setValues(reloadTimeTableOn)
    gg.toast('Quick Reload ENABLED 🔵')
  elseif reload == off then
    gg.setValues(reloadTimeTableOff)
    gg.toast('Quick Reload DISABLED 🔴')
  end
end

function weaponSettingsMaxAmmo()
  if maxAmmo == on then
    gg.setValues(maxAmmoCapacityTableOn)
    gg.toast('Extented Magz ENABLED 🔵')
  elseif maxAmmo == off then
    gg.setValues(maxAmmoCapacityTableOff)
    gg.toast('Extented Magz DISABLED 🔴')
  end  
end
function weaponSettingsAccumulation()
  if accum == on then
    gg.setValues(accumulationFullTableOn)
    gg.setValues(accumulationResetTableOn)
    gg.toast('No Accumulation ENABLED 🔵')
  elseif accum == off then
    gg.setValues(accumulationFullTableOff)
    gg.setValues(accumulationResetTableOff)
    gg.toast('No Accumulation DISABLED 🔴')
  end
end


function boolsOff()
  on = "🔹Active"
  off = "🔸Inactive"

  aimlock = off
  damge = off
  pane = off
  hitt = off
  magz = off
  giants = off
  autoFi = off
  recoil = off
  reload = off
  maxAmmo = off
  accum = off
end

boolsOff()

giants = off
giantReady = false

function setupGiant()
    gg.toast("🔍 Processing… Please wait")

    giantReady = false
    giantData = nil

gg.setRanges(gg.REGION_ANONYMOUS | gg.REGION_OTHER)
gg.clearResults()

gg.searchNumber('h 85 EB 91 3F 6F 12 03 3C', gg.TYPE_BYTE) -- corrected the type here
gg.refineNumber('h 85', gg.TYPE_BYTE)
gg.sleep(300)

local results = gg.getResults(100)
gg.clearResults()

if results == nil or #results < 5 then
    gg.alert("🔧 Player Height Not Totally Active\n\nPossible reasons:\n• Not inside a match\n• Match is still loading\n• Values not initialized yet\n\nPlease enter a match and activate again.")
    giantReady = false
    return
end

    giantData = {}

    for i, v in ipairs(results) do
        giantData[#giantData + 1] = {address = v.address - 0x104, flags = gg.TYPE_FLOAT}
        giantData[#giantData + 1] = {address = v.address - 0x100, flags = gg.TYPE_FLOAT}
        giantData[#giantData + 1] = {address = v.address - 0xFC, flags = gg.TYPE_FLOAT}
    end

    giantData = gg.getValues(giantData)

local filtered = {}

for i, v in ipairs(giantData) do
    if v.value == 1 then
        filtered[#filtered + 1] = v
    end
end

giantData = filtered

if #giantData == 0 then
    gg.toast("❌ No Height Values Found")
    giantReady = false
    return
end

giantReady = true

function applyGiant()
    if not giantReady or giantData == nil then
        gg.toast("❌ Player Height Not Ready")
        return
    end

    local value = (giants == on) and 2.125478 or 1

    for i, v in ipairs(giantData) do
        v.value = value
    end

    gg.setValues(giantData)
end
end
-- menus
function START()

    local hitboxStatus = "🔹Normal"

    if hitboxs == 2 then
        hitboxStatus = "🔹Balanced"
    elseif hitboxs == 3 then
        hitboxStatus = "🔹Aggressive"
    elseif hitboxs == 4 then
        hitboxStatus = "🔹Extreme"
    end

    local menu = gg.prompt(
    {
        "AIM HITBOX " .. hitboxStatus .. "",
        "PLAYER HEIGHT " .. giants,
        "ADMIN PANEL " .. pane,
        "WEAPON MENU",
        "EXIT"
    },
    {
        false,
        giants == on,
        pane == on,
        false,
        false
    },
    {
        "checkbox",
        "checkbox",
        "checkbox",
        "checkbox",
        "checkbox"
    })

    if menu == nil then
        return
    end

if menu[5] then
    print(
        "👤 • Owner: Script4Fun\n" ..
        "📢 • Telegram Channel: https://t.me/ScriptForFun\n" ..
        "📺 • YouTube: https://www.youtube.com/@Script4FunGG"
    )
    os.exit()
end

    if menu[1] then
        headHitBoxMenu()
    end

if giants ~= (menu[2] and on or off) then
    giants = menu[2] and on or off

    if giants == on then
        if not giantReady then
            setupGiant()
        end

        if giantReady then
            applyGiant()
            gg.toast("🔵 Player Height ACTIVE")
        end
    else
        applyGiant()
        gg.toast("🔴 Player Height INACTIVE")
    end
end

if pane ~= (menu[3] and on or off) then
    pane = menu[3] and on or off
    adminPanel()
end 

    if menu[4] then
        weaponTableMenu()
    end

  if menu[5] then weaponTableMenu() end
end

function weaponTableMenu()

local weaponMenu = gg.multiChoice(
{
'Double Damage',
'5K Ammo',
'Auto Fire',
'High Aim Assist',
'Recoil Control',
'Quick Reload',
'Extended Magz',
'No Accumulation',
'BACK'
},
{
    damge == on,
    magz == on,
    autoFi == on,
    aimlock == on,
    recoil == on,
    reload == on,
    maxAmmo == on,
    accum == on,
    false
},
'⚠️ RECOMMENDED: ENABLED IN LOBBY FOR BEST RESULTS\n\n' ..
'ℹ️ Use At Your Own Risk\n' ..
'Use features responsibly. Avoid obvious gameplay and follow the recommended instructions for a safer experience.'
)

    if weaponMenu == nil then
        noselect()
        return
    end

    if weaponMenu[9] then
        START()
        return
    end

local newDamage = weaponMenu[1] and on or off
if newDamage ~= damge then
    damge = newDamage
    bulletFractionInc()
end

local newAmmo = weaponMenu[2] and on or off
if newAmmo ~= magz then
    magz = newAmmo
    ammoHolderInc()
end

local newAuto = weaponMenu[3] and on or off
if newAuto ~= autoFi then
    autoFi = newAuto
    autoF()
end

local newAim = weaponMenu[4] and on or off
if newAim ~= aimlock then
    aimlock = newAim
    cameraLockF()
end

local newRecoil = weaponMenu[5] and on or off
if newRecoil ~= recoil then
    recoil = newRecoil
    weaponSettingsRecoil()
end

local newReload = weaponMenu[6] and on or off
if newReload ~= reload then
    reload = newReload
    weaponSettingsReload()
end

local newMaxAmmo = weaponMenu[7] and on or off
if newMaxAmmo ~= maxAmmo then
    maxAmmo = newMaxAmmo
    weaponSettingsMaxAmmo()
end

local newAccum = weaponMenu[8] and on or off
if newAccum ~= accum then
    accum = newAccum
    weaponSettingsAccumulation()
end
end

function headHitBoxMenu()
  hitboxs = gg.choice
  (
{
  '🔸Normal Hitbox',
  '🔸Balanced Hitbox',
  '🔸Aggressive Hitbox',
  '🔸Extreme Hitbox'
}
    ,nil,
'⚠️ RECOMMENDED: ENABLED IN LOBBY FOR BEST RESULTS\n\n' ..
'🎯 Weapon Guide:\n' ..
'• Assault / Shotgun → Balanced\n' ..
'• Sniper → Aggressive & Extreme\n\n' ..
'💡 IMPORTANT:\n' ..
'If ENABLED during a live match, changes may not apply instantly.\n' ..
'☑️ Full effect will apply on next game / next match reload.'
  )
  if hitboxs == nil then 
    noselect() 
  else
    headHitBoxSize(box, toast)
  end
end


function wiping()
  gg.clearList()
end

function noselect()
end

local running = false

function safeStart()
  if running then return end
  running = true
  START()
  running = false
end

local MENU = gg.choice(
{
    "📝 GUNS OF BOOM MENU",
    "❌ EXIT"
},
nil,
"👤 • Owner: @Script4Fun\n👁️‍🗨️ • GameScripts: Free"
)

if MENU == nil or MENU == 2 then
    os.exit()
end

START()

-- Reopen menu using GG icon
while true do
    if gg.isVisible(true) then
        gg.setVisible(false)
        safeStart()
    end

    gg.sleep(200)
end
