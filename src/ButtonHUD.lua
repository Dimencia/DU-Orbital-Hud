require 'src.slots'
-- Script is laid out variables, functions, control, control (the Hud proper) starts around line 4000
Nav = Navigator.new(system, core, unit)

script = {}  -- wrappable container for all the code. Different than normal DU Lua in that things are not seperated out.

-- Edit LUA Variable user settings.  Must be global to work with databank system as set up due to using _G assignment
useTheseSettings = false -- export: (Default: false) Toggle on to use the below preferences.  Toggle off to use saved preferences.  Preferences will save regardless when exiting seat. 
freeLookToggle = true -- export: (Default: true) Set to false for vanilla DU free look behavior.
BrakeToggleDefault = true -- export: (Default: true) Whether your brake toggle is on/off by default. Can be adjusted in the button menu.  Of is vanilla DU brakes.
RemoteFreeze = false -- export: (Default: false) Whether or not to freeze you when using a remote controller.  Breaks some things, only freeze on surfboards
RemoteHud = false -- export: (Default: false) Whether you want full HUD while in remote mode, experimental, might not look right.
brightHud = false -- export: (Default: false) Enable to prevent hud dimming when in freelook.
VanillaRockets = false -- export: (Default: false) If on, rockets behave like vanilla
InvertMouse = false -- export: (Default: false) If true, then when controlling flight mouse Y axis is inverted (pushing up noses plane down)  Does not affect selecting buttons or camera.
userControlScheme = "virtual joystick" -- export: (Default: "virtual joystick") Set to "virtual joystick", "mouse", or "keyboard"
ResolutionX = 1920 -- export: (Default: 1920) Does not need to be set to same as game resolution.  You can set 1920 on a 2560 to get larger resolution
ResolutionY = 1080 -- export: (Default: 1080) Does not need to be set to same as game resolution.  You can set 1080 on a 1440 to get larger resolution
PrimaryR = 130 -- export: (Default: 130) Primary HUD color
PrimaryG = 224 -- export: (Default: 224) Primary HUD color
PrimaryB = 255 -- export: (Default: 255) Primary HUD color
centerX = 960 -- export: (Default: 960) X postion of Artifical Horizon (KSP Navball), Default 960. Use centerX=700 and centerY=880 for lower left placement.
centerY = 540 -- export: (Default: 540) Y postion of Artifical Horizon (KSP Navball), Default 540. Use centerX=700 and centerY=880 for lower left placement. 
throtPosX = 1300 -- export: (Default: 1300) X position of Throttle Indicator, default 1300 to put it to right of default AH centerX parameter.
throtPosY = 540 -- export: (Default: 540) Y position of Throttle indicator, default is 540 to place it centered on default AH centerY parameter.
vSpdMeterX = 1525  -- export: (Default: 1525) X postion of Vertical Speed Meter.  Default 1525 (use 1920x1080, it will scale)
vSpdMeterY = 250 -- export: (Default: 250) Y postion of Vertical Speed Meter.  Default 250 (use 1920x1080, it will scale)
altMeterX = 550  -- export: (Default: 550) X postion of Altimeter.  Default 550 (use 1920x1080, it will scale)
altMeterY = 540 -- export: (Default: 540) Y postion of Altimeter.  Default 500 (use 1920x1080, it will scale)
fuelX = 100 -- export: (Default: 100) X position of fuel tanks, default is 100 for left side, set both fuelX and fuelY to 0 to hide fuel
fuelY = 350 -- export: (Default: 350) Y position of fuel tanks, default 350 for left side, set both fuelX and fuelY to 0 to hide fuel
circleRad = 400 -- export: (Default: 400) The size of the artifical horizon circle, recommended minimum 100, maximum 400.  Looks different > 200. Set to 0 to remove.
DeadZone = 50 -- export: (Default: 50) Number of pixels of deadzone at the center of the screen
DisplayOrbit = true -- export: (Default: true) Show Orbit display when valid or not.  May be toggled with shift Buttons
OrbitMapSize = 250 -- export: (Default: 250) Size of the orbit map, make sure it is divisible by 4
OrbitMapX = 75 -- export: (Default: 75) X postion of Orbit Display Disabled
OrbitMapY = 0 -- export: (Default: 0)  Y position of Orbit Display
showHud = true -- export: (Default: true) Uncheck to hide the HUD and only use autopilot features via ALT+# keys.
ShowOdometer = true -- export: (Default: true) Uncheck to hide the odometer panel up top.
hideHudOnToggleWidgets = true -- export: (Default: true) Uncheck to keep showing HUD when you toggle on the widgets via ALT+3.
ShiftShowsRemoteButtons = true -- export: (Default: true) Whether or not pressing Shift in remote controller mode shows you the buttons (otherwise no access to them)
StallAngle = 35 --export: (Default: 35) Determines how much Autopilot is allowed to make you yaw/pitch in atmosphere.  Also gives a stall warning when not autopilot.  (default 35, higher = more tolerance for yaw/pitch/roll)
speedChangeLarge = 5 -- export: (Default: 5) The speed change that occurs when you tap speed up/down, default is 5 (25% throttle change). 
speedChangeSmall = 1 -- export: (Default: 1) the speed change that occurs while you hold speed up/down, default is 1 (5% throttle change).
brakeLandingRate = 30 -- export: (Default: 30) Max loss of altitude speed in m/s when doing a brake landing, default 30.  This is to prevent "bouncing" as hover/boosters catch you.  Do not use negative number.
MaxPitch = 30 -- export: (Default: 30) Maximum allowed pitch during takeoff and altitude changes while in altitude hold.  Default is 20 deg.  You can set higher or lower depending on your ships capabilities.
ReentrySpeed = 1050 -- export: (Default: 1050) Target re-entry speed once in atmosphere in km/h. 
AtmoSpeedLimit = 1050 -- export: (Default: 1050) Speed limit in Atmosphere in km/h.  If you exceed this limit the ship will attempt to break till below this limit.
SpaceSpeedLimit = 30000 -- export: (Default: 30000) Space speed limit in KM/H.  If you hit this speed but are not in active autopilot, engines will turn off.
ReentryAltitude = 2500 -- export: (Default: 2500) Target alititude when using re-entry.
AutoTakeoffAltitude = 1000 -- export: (Default: 1000) How high above your ground starting position AutoTakeoff tries to put you
TargetHoverHeight = 50 -- export: (Default: 50) Hover height when retracting landing gear
LandingGearGroundHeight = 0 --export: (Default: 0) Set to AGL-1 when on ground (or 0)
MaxGameVelocity = 8333.00 -- export: (Default: 8333.00) Max speed for your autopilot in m/s, do not go above 8333.055 (30000 km/hr), can be reduced to safe fuel, use 6944.4444 for 25000km/hr
TargetOrbitRadius = 1.4 -- export: (Default: 1.4) How tight you want to orbit the planet at end of autopilot.  The smaller the value the tighter the orbit.  1.4 sets an Alioth orbit of 56699m.
AutopilotInterplanetaryThrottle = 1.0 -- export: (Default: 1.0) How much throttle, 0.0 to 1.0, you want it to use when in autopilot to another planet to reach MaxGameVelocity
warmup = 32 -- export: (Default: 32) How long it takes your engines to warmup.  Basic Space Engines, from XS to XL: 0.25,1,4,16,32
MouseYSensitivity = 0.003 --export: (Default: 0.003) For virtual joystick only
MouseXSensitivity = 0.003 -- export: (Default: 0.003) For virtual joystick only
autoRollPreference = false -- export: (Default: false) [Only in atmosphere]<br>When the pilot stops rolling,  flight model will try to get back to horizontal (no roll)
autoRollFactor = 2 -- export: (Default: 2) [Only in atmosphere]<br>When autoRoll is engaged, this factor will increase to strength of the roll back to 0<br>Valid values: Superior or equal to 0.01
rollSpeedFactor = 1.5 -- export: (Default: 1.5) This factor will increase/decrease the player input along the roll axis<br>(higher value may be unstable)<br>Valid values: Superior or equal to 0.01
turnAssist = true -- export: (Default: true) [Only in atmosphere]<br>When the pilot is rolling, the flight model will try to add yaw and pitch to make the construct turn better<br>The flight model will start by adding more yaw the more horizontal the construct is and more pitch the more vertical it is
turnAssistFactor = 2 -- export: (Default: 2) [Only in atmosphere]<br>This factor will increase/decrease the turnAssist effect<br>(higher value may be unstable)<br>Valid values: Superior or equal to 0.01
TrajectoryAlignmentStrength = 0.002 -- export: (Default: 0.002) How strongly AP tries to align your velocity vector to the target when not in orbit, recommend 0.002
torqueFactor = 2 -- export: (Default: 2) Force factor applied to reach rotationSpeed<br>(higher value may be unstable)<br>Valid values: Superior or equal to 0.01
pitchSpeedFactor = 0.8 -- export: (Default: 0.8) For keyboard control
yawSpeedFactor = 1 -- export: (Default: 1) For keyboard control
brakeSpeedFactor = 3 -- export: (Default: 3) When braking, this factor will increase the brake force by brakeSpeedFactor * velocity<br>Valid values: Superior or equal to 0.01
brakeFlatFactor = 1 -- export: (Default: 1) When braking, this factor will increase the brake force by a flat brakeFlatFactor * velocity direction><br>(higher value may be unstable)<br>Valid values: Superior or equal to 0.01
DampingMultiplier = 40 -- export: (Default: 40) How strongly autopilot dampens when nearing the correct orientation
fuelTankHandlingAtmo = 0 -- export: (Default: 0) For accurate estimates, set this to the fuel tank handling level of the person who placed the element. Ignored for slotted tanks.
fuelTankHandlingSpace = 0 -- export: (Default: 0) For accurate estimates, set this to the fuel tank handling level of the person who placed the element. Ignored for slotted tanks.
fuelTankHandlingRocket = 0 -- export: (Default: 0) For accurate estimates, set this to the fuel tank handling level of the person who placed the element. Ignored for slotted tanks.
ContainerOptimization = 0 -- export: (Default: 0) For accurate estimates, set this to the Container Optimization level of the person who placed the tanks.  Ignored for slotted tanks.
FuelTankOptimization = 0 -- export: (Default: 0) For accurate unslotted fuel tank calculation, set this to the fuel tank optimization skill level of the person who placed the tank.  Ignored for slotted tanks.
ExtraLongitudeTags = "none" -- export: (Default: "none") Enter any extra longitudinal tags you use inside '' seperated by space, i.e. "forward faster major"  These will be added to the engines that are control by longitude.
ExtraLateralTags = "none" -- export: (Default: "none") Enter any extra lateral tags you use inside '' seperated by space, i.e. "left right"  These will be added to the engines that are control by lateral.
ExtraVerticalTags = "none" -- export: (Default: "none") Enter any extra longitudinal tags you use inside '' seperated by space, i.e. "up down"  These will be added to the engines that are control by vertical.
ExternalAGG = false -- export: (Default: false) Toggle On if using an external AGG system.  If on will prevent this HUD from doing anything with AGG.
UseSatNav = false -- export: (Default: false) Toggle on if using Trog SatNav script.  This will provide SatNav support.
apTickRate = 0.0166667 -- export: (Default: 0.0166667) Set the Tick Rate for your autopilot features.  0.016667 is effectively 60 fps and the default value. 0.03333333 is 30 fps.  
hudTickRate = 0.0666667 -- export: (Default: 0.0666667) Set the tick rate for your HUD. Default is 4 times slower than apTickRate
ShouldCheckDamage = true --export: (Default: true) Whether or not damage checks are performed.  Disabled for performance on very large ships
CalculateBrakeLandingSpeed = false --export: (Default: false) Whether BrakeLanding speed at non-waypoints should be calculated or use the brakeLandingRate user setting.  Only set to true for ships with low mass to lift capability.
autoRollRollThreshold = 1.0 --export: (Default: 1.0) The minimum amount of roll before autoRoll kicks in and stabilizes (if active)

-- Auto Variable declarations that store status of ship. Must be global because they get saved/read to Databank due to using _G assignment
BrakeToggleStatus = BrakeToggleDefault
BrakeIsOn = false
RetrogradeIsOn = false
ProgradeIsOn = false
Autopilot = false
TurnBurn = false
AltitudeHold = false
BrakeLanding = false
AutoTakeoff = false
Reentry = false
HoldAltitude = 1000 -- In case something goes wrong, give this a decent start value
AutopilotAccelerating = false
AutopilotRealigned = false
AutopilotBraking = false
AutopilotCruising = false
AutopilotEndSpeed = 0
AutopilotStatus = "Aligning"
AutopilotPlanetGravity = 0
PrevViewLock = 1
AutopilotTargetName = "None"
AutopilotTargetCoords = nil
AutopilotTargetIndex = 0
GearExtended = nil
TotalDistanceTravelled = 0.0
TotalFlightTime = 0
SavedLocations = {}
VectorToTarget = false    
LocationIndex = 0
LastMaxBrake = 0
LockPitch = nil
LastMaxBrakeInAtmo = 0
AntigravTargetAltitude = core.getAltitude()
LastStartTime = 0
SpaceTarget = false

-- VARIABLES TO BE SAVED GO HERE, SAVEABLE are Edit LUA Parameter settable, AUTO are ship status saves that occur over get up and sit down.
local saveableVariables = {"userControlScheme", "TargetOrbitRadius", "apTickRate", "freeLookToggle", "turnAssist",
                        "PrimaryR", "PrimaryG", "PrimaryB", "warmup", "DeadZone", "circleRad", "MouseXSensitivity",
                        "MouseYSensitivity", "MaxGameVelocity", "showHud", "autoRollPreference", "InvertMouse",
                        "pitchSpeedFactor", "yawSpeedFactor", "rollSpeedFactor", "brakeSpeedFactor",
                        "brakeFlatFactor", "autoRollFactor", "turnAssistFactor", "torqueFactor",
                        "AutoTakeoffAltitude", "TargetHoverHeight", "AutopilotInterplanetaryThrottle",
                        "hideHudOnToggleWidgets", "DampingMultiplier", "fuelTankHandlingAtmo", "ExternalAGG", "ShouldCheckDamage",
                        "fuelTankHandlingSpace", "fuelTankHandlingRocket", "RemoteFreeze", "hudTickRate",
                        "speedChangeLarge", "speedChangeSmall", "brightHud", "brakeLandingRate", "MaxPitch",
                        "ReentrySpeed", "AtmoSpeedLimit", "ReentryAltitude", "centerX", "centerY", "SpaceSpeedLimit",
                        "vSpdMeterX", "vSpdMeterY", "altMeterX", "altMeterY", "fuelX","fuelY", "LandingGearGroundHeight", "TrajectoryAlignmentStrength",
                        "RemoteHud", "StallAngle", "ResolutionX", "ResolutionY", "UseSatNav", "FuelTankOptimization", "ContainerOptimization",
                        "ExtraLongitudeTags", "ExtraLateralTags", "ExtraVerticalTags", "OrbitMapSize", "OrbitMapX", "OrbitMapY", "DisplayOrbit", "CalculateBrakeLandingSpeed"}

local autoVariables = {"SpaceTarget","BrakeToggleStatus", "BrakeIsOn", "RetrogradeIsOn", "ProgradeIsOn",
                    "Autopilot", "TurnBurn", "AltitudeHold", "BrakeLanding",
                    "Reentry", "AutoTakeoff", "HoldAltitude", "AutopilotAccelerating", "AutopilotBraking",
                    "AutopilotCruising", "AutopilotRealigned", "AutopilotEndSpeed", "AutopilotStatus",
                    "AutopilotPlanetGravity", "PrevViewLock", "AutopilotTargetName", "AutopilotTargetCoords",
                    "AutopilotTargetIndex", "TotalDistanceTravelled",
                    "TotalFlightTime", "SavedLocations", "VectorToTarget", "LocationIndex", "LastMaxBrake", 
                    "LockPitch", "LastMaxBrakeInAtmo", "AntigravTargetAltitude", "LastStartTime"}


-- function localizations for improved performance when used frequently or in loops.
local sprint = system.print
local mfloor = math.floor
local stringf = string.format
local jdecode = json.decode
local jencode = json.encode
local eleMaxHp = core.getElementMaxHitPointsById
local atmosphere = unit.getAtmosphereDensity
local eleHp = core.getElementHitPointsById
local eleType = core.getElementTypeById
local eleMass = core.getElementMassById
local constructMass = core.getConstructMass
local isRemote = Nav.control.isRemoteControlled

function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return mfloor(num * mult + 0.5) / mult
end

-- Variables that we declare local outside script because they will be treated as global but get local effectiveness

local halfResolutionX = round(ResolutionX / 2,0)
local halfResolutionY = round(ResolutionY / 2,0)
local apThrottleSet = false -- Do not save this, because when they re-enter, throttle won't be set anymore
local toggleView = true
local minAutopilotSpeed = 55 -- Minimum speed for autopilot to maneuver in m/s.  Keep above 25m/s to prevent nosedives when boosters kick in
local reentryMode = false
local MousePitchFactor = 1 -- Mouse control only
local MouseYawFactor = 1 -- Mouse control only
local hasGear = false
local pitchInput = 0
local pitchInput2 = 0
local yawInput2 = 0
local rollInput = 0
local yawInput = 0
local brakeInput = 0
local rollInput2 = 0
local followMode = false
local holdingCtrl = false
local msgText = "empty"
local lastEccentricity = 1
local holdAltitudeButtonModifier = 5
local antiGravButtonModifier = 5
local isBoosting = false -- Dodgin's Don't Die Rocket Govenor
local brakeDistance, brakeTime = 0
local maxBrakeDistance, maxBrakeTime = 0
local hasSpaceRadar = false
local hasAtmoRadar = false
local autopilotTargetPlanet = nil
local totalDistanceTrip = 0
local flightTime = 0
local wipedDatabank = false
local upAmount = 0
local simulatedX = 0
local simulatedY = 0        
local msgTimer = 3
local distance = 0
local radarMessage = ""
local lastOdometerOutput = ""
local peris = 0
local spaceLand = false
local spaceLaunch = false
local finalLand = false
local hovGndDet = -1
local clearAllCheck = false
local myAutopilotTarget=""
local inAtmo = (atmosphere() > 0)
local coreAltitude = core.getAltitude()
local elementsID = core.getElementIdList()
local lastTravelTime = system.getTime()
local gyroIsOn = nil
local speedLimitBreaking = false
local rgb = [[rgb(]] .. mfloor(PrimaryR + 0.5) .. "," .. mfloor(PrimaryG + 0.5) .. "," .. mfloor(PrimaryB + 0.5) .. [[)]]
local rgbdim = [[rgb(]] .. mfloor(PrimaryR * 0.9 + 0.5) .. "," .. mfloor(PrimaryG * 0.9 + 0.5) .. "," ..   mfloor(PrimaryB * 0.9 + 0.5) .. [[)]]

local markers = {}
local previousYawAmount = 0
local previousPitchAmount = 0
local damageMessage = ""
local UnitHidden = true
local Buttons = {}
local autopilotStrength = 1 -- How strongly autopilot tries to point at a target
local alignmentTolerance = 0.001 -- How closely it must align to a planet before accelerating to it
local resolutionWidth = ResolutionX
local resolutionHeight = ResolutionY
local minAtlasX = nil
local maxAtlasX = nil
local minAtlasY = nil
local maxAtlasY = nil
local valuesAreSet = false
local doubleCheck = false
local totalMass = 0
local lastMaxBrakeAtG = nil
local atmoTanks = {}
local spaceTanks = {}
local rocketTanks = {}
local eleTotalMaxHp = 0
local repairArrows = false
local fuelTimeLeftR = {}
local fuelPercentR = {}
local fuelUpdateDelay = mfloor(1 / apTickRate) * 2
local fuelTimeLeftS = {}
local fuelPercentS = {}
local fuelTimeLeft = {}
local fuelPercent = {}
local updateTanks = false
local coreOffset = 16
local updateCount = 0
local atlas = nil
local GalaxyMapHTML = ""
local MapXRatio = nil
local MapYRatio = nil
local YouAreHere = nil
local PlanetaryReference = nil
local galaxyReference = nil
local Kinematic = nil
local maxKinematicUp = nil
local Kep = nil
local Animating = false
local Animated = false
local autoRoll = autoRollPreference
local rateOfChange = vec3(core.getConstructWorldOrientationForward()):dot(vec3(core.getWorldVelocity()):normalize())
local velocity = vec3(core.getWorldVelocity())
local velMag = vec3(velocity):len()
local minimumRateOfChange = math.cos(StallAngle*constants.deg2rad)
local targetGroundAltitude = LandingGearGroundHeight -- So it can tell if one loaded or not
local deltaX = system.getMouseDeltaX()
local deltaY = system.getMouseDeltaY()
local stalling = false
local lastApTickTime = system.getTime()
local targetRoll = 0
local ahDoubleClick = 0

-- BEGIN FUNCTION DEFINITIONS

function LoadVariables()
    if dbHud_1 then
        local hasKey = dbHud_1.hasKey
        if not useTheseSettings then
            for k, v in pairs(saveableVariables) do
                if hasKey(v) then
                    local result = jdecode(dbHud_1.getStringValue(v))
                    if result ~= nil then
                        sprint(v .. " " .. dbHud_1.getStringValue(v))
                        _G[v] = result
                        valuesAreSet = true
                    end
                end
            end
        end
        coroutine.yield()
        for k, v in pairs(autoVariables) do
            if hasKey(v) then
                local result = jdecode(dbHud_1.getStringValue(v))
                if result ~= nil then
                    sprint(v .. " " .. dbHud_1.getStringValue(v))
                    _G[v] = result
                    valuesAreSet = true
                end
            end
        end
        if useTheseSettings then
            msgText = "Updated user preferences used.  Will be saved when you exit seat.\nToggle off useTheseSettings to use saved values"
            msgTimer = 5
        elseif valuesAreSet then
            msgText = "Loaded Saved Variables (see Lua Chat Tab for list)"
        else
            msgText = "No Saved Variables Found - Stand up / leave remote to save settings"
        end
    else
        msgText = "No databank found, install one anywhere and rerun the autoconfigure to save variables"
    end
    local time = system.getTime()
    if (LastStartTime + 180) < time then -- Variables to reset if out of seat (and not on hud) for more than 3 min
        LastMaxBrakeInAtmo = 0
    end
    if valuesAreSet then
        halfResolutionX = round(ResolutionX / 2,0)
        halfResolutionY = round(ResolutionY / 2,0)
        resolutionWidth = ResolutionX
        resolutionHeight = ResolutionY
        BrakeToggleStatus = BrakeToggleDefault
        userControlScheme = string.lower(userControlScheme)
        autoRoll = autoRollPreference
    end
    LastStartTime = time
    if string.find("keyboard virtual joystick mouse", userControlScheme) == nil then 
        msgText = "Invalid User Control Scheme selected.  Change userControlScheme in Lua Parameters to keyboard, mouse, or virtual joystick\nOr use shift and button in screen"
        msgTimer = 5
    end
    minimumRateOfChange = math.cos(StallAngle*constants.deg2rad)

    if antigrav and not ExternalAGG then
        if AntigravTargetAltitude == nil then 
            AntigravTargetAltitude = coreAltitude
        end
        antigrav.setBaseAltitude(AntigravTargetAltitude)
    end
    rgb = [[rgb(]] .. mfloor(PrimaryR + 0.5) .. "," .. mfloor(PrimaryG + 0.5) .. "," .. mfloor(PrimaryB + 0.5) ..
              [[)]]
    rgbdim = [[rgb(]] .. mfloor(PrimaryR * 0.9 + 0.5) .. "," .. mfloor(PrimaryG * 0.9 + 0.5) .. "," ..
                 mfloor(PrimaryB * 0.9 + 0.5) .. [[)]]    
end

function CalculateFuelVolume(curMass, vanillaMaxVolume)
    if curMass > vanillaMaxVolume then
        vanillaMaxVolume = curMass
    end
    if ContainerOptimization > 0 then 
        vanillaMaxVolume = vanillaMaxVolume - (vanillaMaxVolume * ContainerOptimization * 0.05)
    end
    if FuelTankOptimization > 0 then 
        vanillaMaxVolume = vanillaMaxVolume - (vanillaMaxVolume * FuelTankOptimization * 0.05)
    end
    return vanillaMaxVolume            
end

function ProcessElements()
    local checkTanks = (fuelX ~= 0 and fuelY ~= 0)
    for k in pairs(elementsID) do
        local type = eleType(elementsID[k])
        sprint(type)
        if (type == "Landing Gear") then
            sprint("HERE1")
            hasGear = true
        end
        if (type == "Dynamic Core Unit") then
            local hp = eleMaxHp(elementsID[k])
            if hp > 10000 then
                coreOffset = 128
            elseif hp > 1000 then
                coreOffset = 64
            elseif hp > 150 then
                coreOffset = 32
            end
        end
        eleTotalMaxHp = eleTotalMaxHp + eleMaxHp(elementsID[k])
        if checkTanks and (type == "Atmospheric Fuel Tank" or type == "Space Fuel Tank" or type == "Rocket Fuel Tank") then
            local hp = eleMaxHp(elementsID[k])
            local mass = eleMass(elementsID[k])
            local curMass = 0
            local curTime = system.getTime()
            if (type == "Atmospheric Fuel Tank") then
                local vanillaMaxVolume = 400
                local massEmpty = 35.03
                if hp > 10000 then
                    vanillaMaxVolume = 51200 -- volume in kg of L tank
                    massEmpty = 5480
                elseif hp > 1300 then
                    vanillaMaxVolume = 6400 -- volume in kg of M
                    massEmpty = 988.67
                elseif hp > 150 then
                    vanillaMaxVolume = 1600 --- volume in kg small
                    massEmpty = 182.67
                end
                curMass = mass - massEmpty
                if fuelTankHandlingAtmo > 0 then
                    vanillaMaxVolume = vanillaMaxVolume + (vanillaMaxVolume * (fuelTankHandlingAtmo * 0.2))
                end
                vanillaMaxVolume =  CalculateFuelVolume(curMass, vanillaMaxVolume)
                atmoTanks[#atmoTanks + 1] = {elementsID[k], core.getElementNameById(elementsID[k]),
                                            vanillaMaxVolume, massEmpty, curMass, curTime}
            end
            if (type == "Rocket Fuel Tank") then
                local vanillaMaxVolume = 320
                local massEmpty = 173.42
                if hp > 65000 then
                    vanillaMaxVolume = 40000 -- volume in kg of L tank
                    massEmpty = 25740
                elseif hp > 6000 then
                    vanillaMaxVolume = 5120 -- volume in kg of M
                    massEmpty = 4720
                elseif hp > 700 then
                    vanillaMaxVolume = 640 --- volume in kg small
                    massEmpty = 886.72
                end
                curMass = mass - massEmpty
                if fuelTankHandlingRocket > 0 then
                    vanillaMaxVolume = vanillaMaxVolume + (vanillaMaxVolume * (fuelTankHandlingRocket * 0.1))
                end
                vanillaMaxVolume =  CalculateFuelVolume(curMass, vanillaMaxVolume)
                rocketTanks[#rocketTanks + 1] = {elementsID[k], core.getElementNameById(elementsID[k]),
                                                vanillaMaxVolume, massEmpty, curMass, curTime}
            end
            if (type == "Space Fuel Tank") then
                local vanillaMaxVolume = 2400
                local massEmpty = 182.67
                if hp > 10000 then
                    vanillaMaxVolume = 76800 -- volume in kg of L tank
                    massEmpty = 5480
                elseif hp > 1300 then
                    vanillaMaxVolume = 9600 -- volume in kg of M
                    massEmpty = 988.67
                end
                curMass = mass - massEmpty
                if fuelTankHandlingSpace > 0 then
                    vanillaMaxVolume = vanillaMaxVolume + (vanillaMaxVolume * (fuelTankHandlingSpace * 0.2))
                end
                vanillaMaxVolume =  CalculateFuelVolume(curMass, vanillaMaxVolume)
                spaceTanks[#spaceTanks + 1] = {elementsID[k], core.getElementNameById(elementsID[k]),
                                            vanillaMaxVolume, massEmpty, curMass, curTime}
            end
        end
    end
end

function SetupChecks()
    if gyro ~= nil then
        gyroIsOn = gyro.getState() == 1
    end
    if userControlScheme ~= "keyboard" then
        system.lockView(1)
    else
        system.lockView(0)
    end
    if radar_1 then
        if eleType(radar_1.getId()) == "Space Radar" then
            hasSpaceRadar = true
        else
            hasAtmoRadar = true
        end
    end
    -- Close door and retract ramp if available
    local atmo = atmosphere()
    if door and (atmo > 0 or (atmo == 0 and coreAltitude < 10000)) then
        for _, v in pairs(door) do
            v.toggle()
        end
    end
    if switch then
        for _, v in pairs(switch) do
            v.toggle()
        end
    end
    if forcefield and (atmo > 0 or (atmo == 0 and coreAltitude < 10000)) then
        for _, v in pairs(forcefield) do
            v.toggle()
        end
    end
    if antigrav ~= nil and not ExternalAGG then
        if(antigrav.getState() == 1) then
            antigrav.show()
        end
    end
    -- unfreeze the player if he is remote controlling the construct
    if isRemote() == 1 and RemoteFreeze then
        system.freeze(1)
    else
        system.freeze(0)
    end
    if hasGear then
        sprint("HERE2")
        GearExtended = (Nav.control.isAnyLandingGearExtended() == 1)
        if GearExtended then
            Nav.control.extendLandingGears()
        else
            Nav.control.retractLandingGears()
        end
    end
    
    local aboveGroundLevel = AboveGroundLevel()

    -- Engage brake and extend Gear if either a hover detects something, or they're in space and moving very slowly
    if aboveGroundLevel ~= -1 or (not inAtmo and vec3(core.getVelocity()):len() < 50) then
        BrakeIsOn = true
        if not hasGear then
            GearExtended = true
        end
    else
        BrakeIsOn = false
    end

    if targetGroundAltitude ~= nil then
        Nav.axisCommandManager:setTargetGroundAltitude(targetGroundAltitude)
        if targetGroundAltitude == 0 and not hasGear then 
            GearExtended = true
            BrakeIsOn = true -- If they were hovering at 0 and have no gear, consider them landed 
        end
    else
        targetGroundAltitude = Nav:getTargetGroundAltitude() 
        if GearExtended then -- or not hasGear then -- And we already tagged GearExtended if they don't have gear, we can just use this
            Nav.axisCommandManager:setTargetGroundAltitude(LandingGearGroundHeight)
            --GearExtended = true -- We don't need to extend gear just because they have a databank, that would have been done earlier if necessary
        else
            Nav.axisCommandManager:setTargetGroundAltitude(TargetHoverHeight)
        end
    end

    -- Store their max kinematic parameters in ship-up direction for use in brake-landing
    if inAtmo and aboveGroundLevel ~= -1 then 
        maxKinematicUp = core.getMaxKinematicsParametersAlongAxis("ground", core.getConstructOrientationUp())[1]
    end
    -- For now, for simplicity, we only do this once at startup and store it.  If it's nonzero, later we use it. 
    userControlScheme = string.lower(userControlScheme)
    WasInAtmo = inAtmo
end

function ConvertResolutionX (v)
    if ResolutionX == 1920 then 
        return v
    else
        return round(ResolutionX * v / 1920, 0)
    end
end

function ConvertResolutionY (v)
    if ResolutionY == 1080 then 
        return v
    else
        return round(ResolutionY * v / 1080, 0)
    end
end

function RefreshLastMaxBrake(gravity, force)
    if gravity == nil then
        gravity = core.g()
    end
    gravity = round(gravity, 5) -- round to avoid insignificant updates
    local atmoden = atmosphere()
    if (force ~= nil and force) or (lastMaxBrakeAtG == nil or lastMaxBrakeAtG ~= gravity) then
        local velocity = core.getVelocity()
        local speed = vec3(velocity):len()
        local maxBrake = jdecode(unit.getData()).maxBrake 
        if maxBrake ~= nil and maxBrake > 0 and inAtmo then 
            maxBrake = maxBrake / utils.clamp(speed/100, 0.1, 1)
            maxBrake = maxBrake / atmoden
            --if maxBrake > LastMaxBrakeInAtmo and atmoden > 0.10 then LastMaxBrakeInAtmo = maxBrake end
            if atmoden > 0.10 then 
                if LastMaxBrakeInAtmo then
                    LastMaxBrakeInAtmo = (LastMaxBrakeInAtmo + maxBrake) / 2
                else
                    LastMaxBrakeInAtmo = maxBrake 
                end
            end -- Now that we're calculating actual brake values, we want this updated
                -- We were ignoring real brake calculations and overriding them with previous wrong, but higher, brake calculations
                -- Also, ideally this would always give us the same value, but because it's DU they don't.  Sometimes it's a bit off.  
                -- We should keep a rolling average to smooth any offness.
        end
        if maxBrake ~= nil and maxBrake > 0 then
            LastMaxBrake = maxBrake
        end
        lastMaxBrakeAtG = gravity
    end
end

function MakeButton(enableName, disableName, width, height, x, y, toggleVar, toggleFunction, drawCondition)
    local newButton = {
        enableName = enableName,
        disableName = disableName,
        width = width,
        height = height,
        x = x,
        y = y,
        toggleVar = toggleVar,
        toggleFunction = toggleFunction,
        drawCondition = drawCondition,
        hovered = false
    }
    table.insert(Buttons, newButton)
    return newButton -- readonly, I don't think it will be saved if we change these?  Maybe.
    
end

function UpdateAtlasLocationsList()
    AtlasOrdered = {}
    for k, v in pairs(atlas[0]) do
        table.insert(AtlasOrdered, { name = v.name, index = k} )
    end
    local function atlasCmp (left, right)
        return left.name < right.name
    end

    table.sort(AtlasOrdered, atlasCmp)
end

function AddLocationsToAtlas() -- Just called once during init really
    for k, v in pairs(SavedLocations) do
        table.insert(atlas[0], v)
    end
    UpdateAtlasLocationsList()
end

function float_eq(a, b)
    if a == 0 then
        return math.abs(b) < 1e-09
    end
    if b == 0 then
        return math.abs(a) < 1e-09
    end
    return math.abs(a - b) < math.max(math.abs(a), math.abs(b)) * epsilon
end

function zeroConvertToMapPosition(targetplanet, worldCoordinates)
    local worldVec = vec3(worldCoordinates)
    if targetplanet.bodyId == 0 then
        return setmetatable({
            latitude = worldVec.x,
            longitude = worldVec.y,
            altitude = worldVec.z,
            bodyId = 0,
            systemId = targetplanet.planetarySystemId
        }, MapPosition)
    end
    local coords = worldVec - targetplanet.center
    local distance = coords:len()
    local altitude = distance - targetplanet.radius
    local latitude = 0
    local longitude = 0
    if not float_eq(distance, 0) then
        local phi = math.atan(coords.y, coords.x)
        longitude = phi >= 0 and phi or (2 * math.pi + phi)
        latitude = math.pi / 2 - math.acos(coords.z / distance)
    end
    return setmetatable({
        latitude = math.deg(latitude),
        longitude = math.deg(longitude),
        altitude = altitude,
        bodyId = targetplanet.bodyId,
        systemId = targetplanet.planetarySystemId
    }, MapPosition)
end

function zeroConvertToWorldCoordinates(pos) -- Many thanks to SilverZero for this.
    local num  = ' *([+-]?%d+%.?%d*e?[+-]?%d*)'
    local posPattern = '::pos{' .. num .. ',' .. num .. ',' ..  num .. ',' .. num ..  ',' .. num .. '}'    
    local systemId, bodyId, latitude, longitude, altitude = string.match(pos, posPattern)
    if (systemId == "0" and bodyId == "0") then
        return vec3(tonumber(latitude),
                    tonumber(longitude),
                    tonumber(altitude))
    end
    longitude = math.rad(longitude)
    latitude = math.rad(latitude)
    local planet = atlas[tonumber(systemId)][tonumber(bodyId)]  
    local xproj = math.cos(latitude);   
    local planetxyz = vec3(xproj*math.cos(longitude),
                          xproj*math.sin(longitude),
                             math.sin(latitude));
    return planet.center + (planet.radius + altitude) * planetxyz
end

function AddNewLocationByWaypoint(savename, planet, pos)
    if dbHud_1 then
        local newLocation = {}
        local position = zeroConvertToWorldCoordinates(pos)
        if planet.name == "Space" then
            newLocation = {
                position = position,
                name = savename,
                atmosphere = false,
                planetname = planet.name,
                gravity = planet.gravity
            }
        else
            local atmo = false
            if planet.hasAtmosphere then
                atmo = true 
            else 
                atmo = false 
            end
            newLocation = {
                position = position,
                name = savename,
                atmosphere = atmo,
                planetname = planet.name,
                gravity = planet.gravity
            }
        end
        SavedLocations[#SavedLocations + 1] = newLocation
        table.insert(atlas[0], newLocation)
        UpdateAtlasLocationsList()
    else
        msgText = "Databank must be installed to save locations"
    end
end

function AddNewLocation() -- Don't call this unless they have a databank or it's kinda pointless
    -- Add a new location to SavedLocations
    if dbHud_1 then
        local position = vec3(core.getConstructWorldPos())
        local name = planet.name .. ". " .. #SavedLocations
        if radar_1 then -- Just match the first one
            local id,_ = radar_1.getData():match('"constructId":"([0-9]*)","distance":([%d%.]*)')
            if id ~= nil and id ~= "" then
                name = name .. " " .. radar_1.getConstructName(id)
            end
        end
        local newLocation = {}
        local atmo = false
        if planet.hasAtmosphere then
            atmo = true 
        end
        newLocation = {
            position = position,
            name = name,
            atmosphere = atmo,
            planetname = planet.name,
            gravity = planet.gravity
        }
        SavedLocations[#SavedLocations + 1] = newLocation
        -- Nearest planet, gravity also important - if it's 0, we don't autopilot to the target planet, the target isn't near a planet.                      
        table.insert(atlas[0], newLocation)
        UpdateAtlasLocationsList()
        -- Store atmosphere so we know whether the location is in space or not
        msgText = "Location saved as " .. name
    else
        msgText = "Databank must be installed to save locations"
    end
end

function UpdatePosition(newName)
    local index = -1
    local newLocation
    for k, v in pairs(SavedLocations) do
        if v.name and v.name == CustomTarget.name then
            index = k
            break
        end
    end
    if index ~= -1 then
        local updatedName
        if newName ~= nil then
            newLocation = {
                position = SavedLocations[index].position,
                name = newName,
                atmosphere = SavedLocations[index].atmosphere,
                planetname = SavedLocations[index].planetname,
                gravity = SavedLocations[index].gravity
            } 
        else
            newLocation = {
                position = vec3(core.getConstructWorldPos()),
                name = SavedLocations[index].name,
                atmosphere = atmosphere(),
                planetname = planet.name,
                gravity = unit.getClosestPlanetInfluence()
            }   
        end
        SavedLocations[index] = newLocation
        index = -1
        for k, v in pairs(atlas[0]) do
            if v.name and v.name == CustomTarget.name then
                index = k
            end
        end
        if index > -1 then
            atlas[0][index] = newLocation
        end
        UpdateAtlasLocationsList()
        msgText = CustomTarget.name .. " position updated"
        AutopilotTargetIndex = 0
        UpdateAutopilotTarget()
    else
        msgText = "Name Not Found"
    end
end

function ClearCurrentPosition()
    -- So AutopilotTargetIndex is special and not a real index.  We have to do this by hand.
    local index = -1
    for k, v in pairs(atlas[0]) do
        if v.name and v.name == CustomTarget.name then
            index = k
        end
    end
    if index > -1 then
        table.remove(atlas[0], index)
    end
    -- And SavedLocations
    index = -1
    for k, v in pairs(SavedLocations) do
        if v.name and v.name == CustomTarget.name then
            msgText = v.name .. " saved location cleared"
            index = k
            break
        end
    end
    if index ~= -1 then
        table.remove(SavedLocations, index)
    end
    DecrementAutopilotTargetIndex()
    UpdateAtlasLocationsList()
end

function DrawDeadZone(newContent)
    newContent[#newContent + 1] = stringf(
                                      [[<circle class="dim line" style="fill:none" cx="50%%" cy="50%%" r="%d"/>]],
                                      DeadZone)
end

function ToggleRadarPanel()
    if radarPanelID ~= nil and peris == 0 then
        system.destroyWidgetPanel(radarPanelID)
        radarPanelID = nil
        if perisPanelID ~= nil then
            system.destroyWidgetPanel(perisPanelID)
            perisPanelID = nil
        end
    else
        -- If radar is installed but no weapon, don't show periscope
        if peris == 1 then
            system.destroyWidgetPanel(radarPanelID)
            radarPanelID = nil
            _autoconf.displayCategoryPanel(radar, radar_size, L_TEXT("ui_lua_widget_periscope", "Periscope"),
                "periscope")
            perisPanelID = _autoconf.panels[_autoconf.panels_size]
        end
        placeRadar = true
        if radarPanelID == nil and placeRadar then
            _autoconf.displayCategoryPanel(radar, radar_size, L_TEXT("ui_lua_widget_radar", "Radar"), "radar")
            radarPanelID = _autoconf.panels[_autoconf.panels_size]
            placeRadar = false
        end
        peris = 0
    end
end

function ToggleWidgets()
    if UnitHidden then
        unit.show()
        core.show()
        if atmofueltank_size > 0 then
            _autoconf.displayCategoryPanel(atmofueltank, atmofueltank_size,
                L_TEXT("ui_lua_widget_atmofuel", "Atmo Fuel"), "fuel_container")
            fuelPanelID = _autoconf.panels[_autoconf.panels_size]
        end
        if spacefueltank_size > 0 then
            _autoconf.displayCategoryPanel(spacefueltank, spacefueltank_size,
                L_TEXT("ui_lua_widget_spacefuel", "Space Fuel"), "fuel_container")
            spacefuelPanelID = _autoconf.panels[_autoconf.panels_size]
        end
        if rocketfueltank_size > 0 then
            _autoconf.displayCategoryPanel(rocketfueltank, rocketfueltank_size,
                L_TEXT("ui_lua_widget_rocketfuel", "Rocket Fuel"), "fuel_container")
            rocketfuelPanelID = _autoconf.panels[_autoconf.panels_size]
        end
        UnitHidden = false
    else
        unit.hide()
        core.hide()
        if fuelPanelID ~= nil then
            system.destroyWidgetPanel(fuelPanelID)
            fuelPanelID = nil
        end
        if spacefuelPanelID ~= nil then
            system.destroyWidgetPanel(spacefuelPanelID)
            spacefuelPanelID = nil
        end
        if rocketfuelPanelID ~= nil then
            system.destroyWidgetPanel(rocketfuelPanelID)
            rocketfuelPanelID = nil
        end
        UnitHidden = true
    end
end

function SetupInterplanetaryPanel() -- Interplanetary helper
    panelInterplanetary = system.createWidgetPanel("Interplanetary Helper")
    interplanetaryHeader = system.createWidget(panelInterplanetary, "value")
    interplanetaryHeaderText = system.createData('{"label": "Target Planet", "value": "N/A", "unit":""}')
    system.addDataToWidget(interplanetaryHeaderText, interplanetaryHeader)
    widgetDistance = system.createWidget(panelInterplanetary, "value")
    widgetDistanceText = system.createData('{"label": "distance", "value": "N/A", "unit":""}')
    system.addDataToWidget(widgetDistanceText, widgetDistance)
    widgetTravelTime = system.createWidget(panelInterplanetary, "value")
    widgetTravelTimeText = system.createData('{"label": "Travel Time", "value": "N/A", "unit":""}')
    system.addDataToWidget(widgetTravelTimeText, widgetTravelTime)
    widgetMaxMass = system.createWidget(panelInterplanetary, "value")
    widgetMaxMassText = system.createData('{"label": "Maximum Mass", "value": "N/A", "unit":""}')
    system.addDataToWidget(widgetMaxMassText, widgetMaxMass)
    widgetCurBrakeDistance = system.createWidget(panelInterplanetary, "value")
    widgetCurBrakeDistanceText = system.createData('{"label": "Cur Brake distance", "value": "N/A", "unit":""}')
    if not inAtmo then
        system.addDataToWidget(widgetCurBrakeDistanceText, widgetCurBrakeDistance)
    end
    widgetCurBrakeTime = system.createWidget(panelInterplanetary, "value")
    widgetCurBrakeTimeText = system.createData('{"label": "Cur Brake Time", "value": "N/A", "unit":""}')
    if not inAtmo then
        system.addDataToWidget(widgetCurBrakeTimeText, widgetCurBrakeTime)
    end
    widgetMaxBrakeDistance = system.createWidget(panelInterplanetary, "value")
    widgetMaxBrakeDistanceText = system.createData('{"label": "Max Brake distance", "value": "N/A", "unit":""}')
    if not inAtmo then
        system.addDataToWidget(widgetMaxBrakeDistanceText, widgetMaxBrakeDistance)
    end
    widgetMaxBrakeTime = system.createWidget(panelInterplanetary, "value")
    widgetMaxBrakeTimeText = system.createData('{"label": "Max Brake Time", "value": "N/A", "unit":""}')
    if not inAtmo then
        system.addDataToWidget(widgetMaxBrakeTimeText, widgetMaxBrakeTime)
    end
    widgetTrajectoryAltitude = system.createWidget(panelInterplanetary, "value")
    widgetTrajectoryAltitudeText = system.createData(
                                       '{"label": "Projected Altitude", "value": "N/A", "unit":""}')
    if not inAtmo then
        system.addDataToWidget(widgetTrajectoryAltitudeText, widgetTrajectoryAltitude)
    end


    widgetTargetOrbit = system.createWidget(panelInterplanetary, "value")
    widgetTargetOrbitText = system.createData('{"label": "Target Altitude", "value": "N/A", "unit":""}')
    if not inAtmo then
        system.addDataToWidget(widgetTargetOrbitText, widgetTargetOrbit)
    end
end

function Contains(mousex, mousey, x, y, width, height)
    if mousex > x and mousex < (x + width) and mousey > y and mousey < (y + height) then
        return true
    else
        return false
    end
end

function ToggleTurnBurn()
    TurnBurn = not TurnBurn
end

function ToggleVectorToTarget(SpaceTarget)
    -- This is a feature to vector toward the target destination in atmo or otherwise on-planet
    -- Uses altitude hold.  
    VectorToTarget = not VectorToTarget
    if VectorToTarget then
        TurnBurn = false
        if not AltitudeHold and not SpaceTarget then
            ToggleAltitudeHold()
        end
    end
    VectorStatus = "Proceeding to Waypoint"
end

function ToggleAutoLanding()
    if BrakeLanding then
        BrakeLanding = false
        -- Don't disable alt hold for auto land
    else
        StrongBrakes = ((planet.gravity * 9.80665 * constructMass()) < LastMaxBrake)
        if not StrongBrakes and velMag > minAutopilotSpeed then
            msgText = "WARNING: Insufficient Brakes - Attempting coast landing, beware obstacles"
        end
        AltitudeHold = false
        AutoTakeoff = false
        LockPitch = nil
        BrakeLanding = true
        Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0)
    end
end

function ToggleAutoTakeoff()
    if AutoTakeoff then
        -- Turn it off, and also AltitudeHold cuz it's weird if you cancel and that's still going 
        AutoTakeoff = false
        if AltitudeHold then
            ToggleAltitudeHold()
        end
    else
        if not AltitudeHold then
            ToggleAltitudeHold()
        end
        AutoTakeoff = true
        HoldAltitude = coreAltitude + AutoTakeoffAltitude
        GearExtended = false
        Nav.control.retractLandingGears()
        Nav.axisCommandManager:setTargetGroundAltitude(500) -- Hard set this for takeoff, you wouldn't use takeoff from a hangar
        BrakeIsOn = true
    end
end

function ToggleLockPitch()
    if LockPitch == nil then
        local constrF = vec3(core.getConstructWorldOrientationForward())
        local constrR = vec3(core.getConstructWorldOrientationRight())
        local worldV = vec3(core.getWorldVertical())
        local pitch = getPitch(worldV, constrF, constrR)
        LockPitch = pitch
        AutoTakeoff = false
        AltitudeHold = false
        BrakeLanding = false
    else
        LockPitch = nil
    end
end

function ToggleAltitudeHold()
    local time = system.getTime()
    if (time - ahDoubleClick) < 1.5 then
        if planet.hasAtmosphere then
            HoldAltitude = planet.spaceEngineMinAltitude - 50
            ahDoubleClick = -1
            if AltitudeHold then 
                return 
            end
        end
    else
        ahDoubleClick = time
    end
    AltitudeHold = not AltitudeHold
    if AltitudeHold then
        Autopilot = false
        ProgradeIsOn = false
        RetrogradeIsOn = false
        followMode = false
        BrakeLanding = false
        Reentry = false
        autoRoll = true
        LockPitch = nil
        if (not GearExtended and not BrakeIsOn) or not inAtmo or (antigrav and antigrav.getState() == 1) then -- Never autotakeoff in space
            AutoTakeoff = false
            if ahDoubleClick > -1 then HoldAltitude = coreAltitude end
            if not spaceLaunch and Nav.axisCommandManager:getAxisCommandType(0) == 0 then
                Nav.control.cancelCurrentControlMasterMode()
            end
        else
            AutoTakeoff = true
            if ahDoubleClick > -1 then HoldAltitude = coreAltitude + AutoTakeoffAltitude end
            GearExtended = false
            Nav.control.retractLandingGears()
            BrakeIsOn = true
            Nav.axisCommandManager:setTargetGroundAltitude(TargetHoverHeight)
        end
        if spaceLaunch then HoldAltitude = 100000 end
    else
        autoRoll = autoRollPreference
        AutoTakeoff = false
        BrakeLanding = false
        Reentry = false
        AutoTakeoff = false
        VectorToTarget = false
    end
end

function ToggleFollowMode()
    if isRemote() == 1 then
        followMode = not followMode
        if followMode then
            Autopilot = false
            RetrogradeIsOn = false
            ProgradeIsOn = false
            AltitudeHold = false
            Reentry = false
            BrakeLanding = false
            AutoTakeoff = false
            OldGearExtended = GearExtended
            GearExtended = false
            Nav.control.retractLandingGears()
            Nav.axisCommandManager:setTargetGroundAltitude(TargetHoverHeight)
        else
            BrakeIsOn = true
            autoRoll = autoRollPreference
            GearExtended = OldGearExtended
            if GearExtended then
                Nav.control.extendLandingGears()
                Nav.axisCommandManager:setTargetGroundAltitude(LandingGearGroundHeight)
            end
        end
    else
        msgText = "Follow Mode only works with Remote controller"
        followMode = false
    end
end

function ToggleAutopilot()
    -- Toggle Autopilot, as long as the target isn't None
    if AutopilotTargetIndex > 0 and not Autopilot and not VectorToTarget and not spaceLaunch then
        -- If it's a custom location... 
        -- Behavior is probably 
        -- a. If not at the same nearest planet and in space and the target has gravity, autopilot to that planet
        -- a1. 
        -- b. If at nearest planet but not in atmo (and the destination is in atmo), and destination is less than (radius) away or our orbit is not stable, auto-reentry
        -- (IE if in an orbit, like from AP, it should wait until destination is on the correct side of the planet before engaging reentry)
        -- c.  If at correct planet and in atmo and alt hold isn't on and they aren't landed, engage altitude hold at that alt and speed
        -- d. If alt hold is on and we're within tolerance of our target altitude, slowly yaw toward the target position
        -- e. If our velocity vector is lined up to go over the target position, calculate our brake distance at current speed in atmo
        -- f. If our distance to the target (ignoring altitude) is within our current brakeDistance, engage brake-landing
        -- f2. Should we even try to let this happen on ships with bad brakes.  Eventually, try that.  For now just don't let them use this
        local waypoint = zeroConvertToMapPosition(autopilotTargetPlanet, AutopilotTargetCoords)
        waypoint = "::pos{"..waypoint.systemId..","..waypoint.bodyId..","..waypoint.latitude..","..waypoint.longitude..","..waypoint.altitude.."}"
        system.setWaypoint(waypoint)
        if CustomTarget ~= nil then
            LockPitch = nil
            SpaceTarget = (CustomTarget.planetname == "Space")
            if SpaceTarget then
                if atmosphere() ~= 0 then 
                    spaceLaunch = true
                    ToggleAltitudeHold()
                else
                    Autopilot = true
                end
            elseif planet.name  == CustomTarget.planetname then
                StrongBrakes = ((planet.gravity * 9.80665 * constructMass()) < LastMaxBrakeInAtmo)
                if not StrongBrakes and velMag > minAutopilotSpeed then
                    msgText = "Insufficient Brake Force\nCoast landing will be inaccurate"
                end
                -- Going to need to add all those conditions here.  Let's start with the easiest.
                if atmosphere() > 0 then
                    if not AltitudeHold then
                        -- Autotakeoff gets engaged inside the toggle if conditions are met
                        if not VectorToTarget then
                            ToggleVectorToTarget(SpaceTarget)
                        end
                    else
                        -- Vector to target
                        if not VectorToTarget then
                            ToggleVectorToTarget(SpaceTarget)
                        end
                    end -- TBH... this is the only thing we need to do, make sure Alt Hold is on.  
                else
                    if coreAltitude > 100000 or coreAltitude == 0 then
                        --spaceLaunch = true
                        Autopilot = true
                    else
                        spaceLand = true
                    end
                end
            else
                RetrogradeIsOn = false
                ProgradeIsOn = false
                if atmosphere() ~= 0 then 
                    spaceLaunch = true
                    ToggleAltitudeHold() 
                else
                    Autopilot = true
                end
            end
        elseif atmosphere() == 0 then -- Planetary autopilot
            Autopilot = true
            RetrogradeIsOn = false
            ProgradeIsOn = false
            AutopilotRealigned = false
            followMode = false
            AltitudeHold = false
            BrakeLanding = false
            Reentry = false
            AutoTakeoff = false
            apThrottleSet = false
            LockPitch = nil
        else
            spaceLaunch = true
            ToggleAltitudeHold()
        end
    else
        spaceLaunch = false
        Autopilot = false
        AutopilotRealigned = false
        VectorToTarget = false
        apThrottleSet = false
        AutoTakeoff = false
        AltitudeHold = false
        VectorToTarget = false
        HoldAltitude = coreAltitude
    end
end

function ProgradeToggle()
    -- Toggle Progrades
    ProgradeIsOn = not ProgradeIsOn
    RetrogradeIsOn = false -- Don't let both be on
    Autopilot = false
    AltitudeHold = false
    followMode = false
    BrakeLanding = false
    LockPitch = nil
    Reentry = false
    AutoTakeoff = false
end

function RetrogradeToggle()
    -- Toggle Retrogrades
    RetrogradeIsOn = not RetrogradeIsOn
    ProgradeIsOn = false -- Don't let both be on
    Autopilot = false
    AltitudeHold = false
    followMode = false
    BrakeLanding = false
    LockPitch = nil
    Reentry = false
    AutoTakeoff = false
end

function BrakeToggle()
    -- Toggle brakes
    BrakeIsOn = not BrakeIsOn
    if BrakeLanding then
        BrakeLanding = false
        autoRoll = autoRollPreference
    end
    if BrakeIsOn then
        -- If they turn on brakes, disable a few things
        AltitudeHold = false
        VectorToTarget = false
        AutoTakeoff = false
        Reentry = false
        -- We won't abort interplanetary because that would fuck everyone.
        ProgradeIsOn = false -- No reason to brake while facing prograde, but retrograde yes.
        BrakeLanding = false
        AutoLanding = false
        AltitudeHold = false -- And stop alt hold
        LockPitch = nil
        autoRoll = autoRollPreference
    end
end

function CheckDamage(newContent)
    local percentDam = 0
    damageMessage = ""
    local maxShipHP = eleTotalMaxHp
    local curShipHP = 0
    local damagedElements = 0
    local disabledElements = 0
    local colorMod = 0
    local color = ""
    for k in pairs(elementsID) do
        local hp = 0
        local mhp = 0
        mhp = eleMaxHp(elementsID[k])
        hp = eleHp(elementsID[k])
        curShipHP = curShipHP + hp
        if (hp < mhp) then
            if (hp == 0) then
                disabledElements = disabledElements + 1
            else
                damagedElements = damagedElements + 1
            end
            -- Thanks to Jerico for the help and code starter for arrow markers!
            if repairArrows and #markers == 0 then
                position = vec3(core.getElementPositionById(elementsID[k]))
                local x = position.x - coreOffset
                local y = position.y - coreOffset
                local z = position.z - coreOffset
                table.insert(markers, core.spawnArrowSticker(x, y, z + 1, "down"))
                table.insert(markers, core.spawnArrowSticker(x, y, z + 1, "down"))
                core.rotateSticker(markers[2], 0, 0, 90)
                table.insert(markers, core.spawnArrowSticker(x + 1, y, z, "north"))
                table.insert(markers, core.spawnArrowSticker(x + 1, y, z, "north"))
                core.rotateSticker(markers[4], 90, 90, 0)
                table.insert(markers, core.spawnArrowSticker(x - 1, y, z, "south"))
                table.insert(markers, core.spawnArrowSticker(x - 1, y, z, "south"))
                core.rotateSticker(markers[6], 90, -90, 0)
                table.insert(markers, core.spawnArrowSticker(x, y - 1, z, "east"))
                table.insert(markers, core.spawnArrowSticker(x, y - 1, z, "east"))
                core.rotateSticker(markers[8], 90, 0, 90)
                table.insert(markers, core.spawnArrowSticker(x, y + 1, z, "west"))
                table.insert(markers, core.spawnArrowSticker(x, y + 1, z, "west"))
                core.rotateSticker(markers[10], -90, 0, 90)
                table.insert(markers, elementsID[k])
            end
        elseif repairArrows and #markers > 0 and markers[11] == elementsID[k] then
            for j in pairs(markers) do
                core.deleteSticker(markers[j])
            end
            markers = {}
        end
    end
    percentDam = mfloor((curShipHP / maxShipHP)*100)
    if percentDam < 100 then
        newContent[#newContent + 1] = [[<g class="pbright txt">]]
        colorMod = mfloor(percentDam * 2.55)
        color = stringf("rgb(%d,%d,%d)", 255 - colorMod, colorMod, 0)
        if percentDam < 100 then
            newContent[#newContent + 1] = stringf(
                                              [[<text class="txtbig txtmid" x=50%% y="1035" style="fill:%s">Elemental Integrity: %i %%</text>]],
                                              color, percentDam)
            if (disabledElements > 0) then
                newContent[#newContent + 1] = stringf(
                                                  [[<text class="txtbig txtmid" x=50%% y="1055" style="fill:%s">Disabled Modules: %i Damaged Modules: %i</text>]],
                                                  color, disabledElements, damagedElements)
            elseif damagedElements > 0 then
                newContent[#newContent + 1] = stringf(
                                                  [[<text class="txtbig txtmid" x=50%% y="1055"style="fill:%s">Damaged Modules: %i</text>]],
                                                  color, damagedElements)
            end
        end
        newContent[#newContent + 1] = [[<\g>]]
    end
end

function DrawCursorLine(newContent)
    local strokeColor = mfloor(utils.clamp((distance / (resolutionWidth / 4)) * 255, 0, 255))
    newContent[#newContent + 1] = stringf(
                                      "<line x1='0' y1='0' x2='%fpx' y2='%fpx' style='stroke:rgb(%d,%d,%d);stroke-width:2;transform:translate(50%%, 50%%)' />",
                                      simulatedX, simulatedY, mfloor(PrimaryR + 0.5) + strokeColor,
                                      mfloor(PrimaryG + 0.5) - strokeColor, mfloor(PrimaryB + 0.5) - strokeColor)
end

function getPitch(gravityDirection, forward, right)
    local horizontalForward = gravityDirection:cross(right):normalize_inplace() -- Cross forward?
    local pitch = math.acos(utils.clamp(horizontalForward:dot(-forward), -1, 1)) * constants.rad2deg -- acos?
    
    if horizontalForward:cross(-forward):dot(right) < 0 then
        pitch = -pitch
    end -- Cross right dot forward?
    return pitch
end

local atan = math.atan
local function signedRotationAngle(normal, vecA, vecB)
  return atan(vecA:cross(vecB):dot(normal), vecA:dot(vecB))
end

function clearAll()
    if clearAllCheck then
        clearAllCheck = false
        AutopilotAccelerating = false
        AutopilotBraking = false
        AutopilotCruising = false
        Autopilot = false
        AutopilotRealigned = false
        AutopilotStatus = "Aligning"                
        RetrogradeIsOn = false
        ProgradeIsOn = false
        AltitudeHold = false
        Reentry = false
        BrakeLanding = false
        BrakeIsOn = false
        AutoTakeoff = false
        followMode = false
        apThrottleSet = false
        spaceLand = false
        spaceLaunch = false
        reentryMode = false
        autoRoll = autoRollPreference
        VectorToTarget = false
        TurnBurn = false
        gyroIsOn = false
        LockPitch = nil
    else
        clearAllCheck = true
    end
end

function wipeSaveVariables()
    if not dbHud_1 then
        msgText =
            "No Databank Found, unable to wipe. \nYou must have a Databank attached to ship prior to running the HUD autoconfigure"
        msgTimer = 5
    else--if valuesAreSet then
        if doubleCheck then
            -- If any values are set, wipe them all
            for k, v in pairs(saveableVariables) do
                dbHud_1.setStringValue(v, jencode(nil))
            end
            for k, v in pairs(autoVariables) do
                if v ~= "SavedLocations" then dbHud_1.setStringValue(v, jencode(nil)) end
            end
            --dbHud_1.clear()
            msgText =
                "Databank wiped. New variables will save after re-enter seat and exit"
            msgTimer = 5
            doubleCheck = false
            valuesAreSet = false
            wipedDatabank = true
        else
            msgText = "Press ALT-7 again to confirm wipe of ALL data"
            doubleCheck = true
        end
    end
end

function CheckButtons()
    for _, v in pairs(Buttons) do
        if v.hovered then
            if not v.drawCondition or v.drawCondition() then
                v.toggleFunction()
            end
            v.hovered = false
        end
    end
end

function SetButtonContains()
    local x = simulatedX + resolutionWidth / 2
    local y = simulatedY + resolutionHeight / 2
    for _, v in pairs(Buttons) do
        -- enableName, disableName, width, height, x, y, toggleVar, toggleFunction, drawCondition
        v.hovered = Contains(x, y, v.x, v.y, v.width, v.height)
    end
end

function DrawButton(newContent, toggle, hover, x, y, w, h, activeColor, inactiveColor, activeText, inactiveText)
    if type(activeText) == "function" then
        activeText = activeText()
    end
    if type(inactiveText) == "function" then
        inactiveText = inactiveText()
    end
    newContent[#newContent + 1] = stringf("<rect x='%f' y='%f' width='%f' height='%f' fill='", x, y, w, h)
    if toggle then
        newContent[#newContent + 1] = stringf("%s'", activeColor)
    else
        newContent[#newContent + 1] = inactiveColor
    end
    if hover then
        newContent[#newContent + 1] = " style='stroke:white; stroke-width:2'"
    else
        newContent[#newContent + 1] = " style='stroke:black; stroke-width:1'"
    end
    newContent[#newContent + 1] = "></rect>"
    newContent[#newContent + 1] = stringf("<text x='%f' y='%f' font-size='24' fill='", x + w / 2,
                                      y + (h / 2) + 5)
    if toggle then
        newContent[#newContent + 1] = "black"
    else
        newContent[#newContent + 1] = "white"
    end
    newContent[#newContent + 1] = "' text-anchor='middle' font-family='Montserrat'>"
    if toggle then
        newContent[#newContent + 1] = stringf("%s</text>", activeText)
    else
        newContent[#newContent + 1] = stringf("%s</text>", inactiveText)
    end
end

function DrawButtons(newContent)
    local defaultColor = "rgb(50,50,50)'"
    local onColor = "rgb(210,200,200)"
    local draw = DrawButton
    for _, v in pairs(Buttons) do
        -- enableName, disableName, width, height, x, y, toggleVar, toggleFunction, drawCondition
        local disableName = v.disableName
        local enableName = v.enableName
        if type(disableName) == "function" then
            disableName = disableName()
        end
        if type(enableName) == "function" then
            enableName = enableName()
        end
        if not v.drawCondition or v.drawCondition() then -- If they gave us a nil condition
            draw(newContent, v.toggleVar(), v.hovered, v.x, v.y, v.width, v.height, onColor, defaultColor,
                disableName, enableName)
        end
    end
end

function DrawTank(newContent, updateTanks, x, nameSearchPrefix, nameReplacePrefix, tankTable, fuelTimeLeftTable,
    fuelPercentTable)
    local tankID = 1
    local tankName = 2
    local tankMaxVol = 3
    local tankMassEmpty = 4
    local tankLastMass = 5
    local tankLastTime = 6
    local slottedTankType = ""
    local slottedTanks = 0

    local y1 = fuelY
    local y2 = fuelY+10
    if isRemote() == 1 and not RemoteHud then
        y1 = y1 - 50
        y2 = y2 - 50
    end

    newContent[#newContent + 1] = [[<g class="pdim txtfuel">]]

    if nameReplacePrefix == "ATMO" then
        slottedTankType = "atmofueltank"
    elseif nameReplacePrefix == "SPACE" then
        slottedTankType = "spacefueltank"
    else
        slottedTankType = "rocketfueltank"
    end
    slottedTanks = _G[slottedTankType .. "_size"]
    if (#tankTable > 0) then
        for i = 1, #tankTable do
            local name = string.sub(tankTable[i][tankName], 1, 12)
            local slottedIndex = 0
            for j = 1, slottedTanks do
                if tankTable[i][tankName] == jdecode(unit[slottedTankType .. "_" .. j].getData()).name then
                    slottedIndex = j
                    break
                end
            end
            if updateTanks or fuelTimeLeftTable[i] == nil or fuelPercentTable[i] == nil then
                local fuelMassMax = 0
                local fuelMassLast = 0
                local fuelMass = 0
                local fuelLastTime = 0
                local curTime = system.getTime()
                if slottedIndex ~= 0 then
                    fuelPercentTable[i] = jdecode(unit[slottedTankType .. "_" .. slottedIndex].getData())
                                              .percentage
                    fuelTimeLeftTable[i] = jdecode(unit[slottedTankType .. "_" .. slottedIndex].getData())
                                               .timeLeft
                    if fuelTimeLeftTable[i] == "n/a" then
                        fuelTimeLeftTable[i] = 0
                    end
                else
                    fuelMass = (eleMass(tankTable[i][tankID]) - tankTable[i][tankMassEmpty])
                    fuelMassMax = tankTable[i][tankMaxVol]
                    fuelPercentTable[i] = mfloor(0.5 + fuelMass * 100 / fuelMassMax)
                    fuelMassLast = tankTable[i][tankLastMass]
                    fuelLastTime = tankTable[i][tankLastTime]
                    if fuelMassLast <= fuelMass then
                        fuelTimeLeftTable[i] = 0
                    else
                        fuelTimeLeftTable[i] = mfloor(
                                                   0.5 + fuelMass /
                                                       ((fuelMassLast - fuelMass) / (curTime - fuelLastTime)))
                    end
                    tankTable[i][tankLastMass] = fuelMass
                    tankTable[i][tankLastTime] = curTime
                end
            end
            if name == nameSearchPrefix then
                name = stringf("%s %d", nameReplacePrefix, i)
            end
            if slottedIndex == 0 then
                name = name .. " *"
            end
            local fuelTimeDisplay
            if fuelTimeLeftTable[i] == 0 then
                fuelTimeDisplay = "n/a"
            else
                fuelTimeDisplay = FormatTimeString(fuelTimeLeftTable[i])
            end
            if fuelPercentTable[i] ~= nil then
                local colorMod = mfloor(fuelPercentTable[i] * 2.55)
                local color = stringf("rgb(%d,%d,%d)", 255 - colorMod, colorMod, 0)
                local class = ""
                if ((fuelTimeDisplay ~= "n/a" and fuelTimeLeftTable[i] < 120) or fuelPercentTable[i] < 5) then
                    if updateTanks then
                        class = [[class="red"]]
                    end
                end
                newContent[#newContent + 1] = stringf(
                                                  [[
                    <text x=%d y="%d" %s>%s</text>
                    <text x=%d y="%d" style="fill:%s">%d%% %s</text>
                ]], x, y1, class, name, x, y2, color, fuelPercentTable[i], fuelTimeDisplay)
                y1 = y1 + 30
                y2 = y2 + 30
            end
        end
    end
    newContent[#newContent + 1] = "</g>"
end

function HideInterplanetaryPanel()
    system.destroyWidgetPanel(panelInterplanetary)
    panelInterplanetary = nil
end

function getRelativePitch(velocity)
    velocity = vec3(velocity)
    local pitch = -math.deg(math.atan(velocity.y, velocity.z)) + 180
    -- This is 0-360 where 0 is straight up
    pitch = pitch - 90
    -- So now 0 is straight, but we can now get angles up to 420
    if pitch < 0 then
        pitch = 360 + pitch
    end
    -- Now, if it's greater than 180, say 190, make it go to like -170
    if pitch > 180 then
        pitch = -180 + (pitch - 180)
    end
    -- And it's backwards.  
    return -pitch
end

function getRelativeYaw(velocity)
    velocity = vec3(velocity)
    local yaw = math.deg(math.atan(velocity.y, velocity.x)) - 90
    if yaw < -180 then
        yaw = 360 + yaw
    end
    return yaw
end

function AlignToWorldVector(vector, tolerance, damping)
    -- Sets inputs to attempt to point at the autopilot target
    -- Meant to be called from Update or Tick repeatedly
    if not inAtmo or not stalling or hovGndDet ~= -1 or velMag < minAutopilotSpeed then
        local dampingMult = damping
        if dampingMult == nil then
            dampingMult = DampingMultiplier
        end

        if tolerance == nil then
            tolerance = alignmentTolerance
        end
        vector = vec3(vector):normalize()
        local targetVec = (vec3(core.getConstructWorldOrientationForward()) - vector)
        local yawAmount = -getMagnitudeInDirection(targetVec, core.getConstructWorldOrientationRight()) * autopilotStrength
        local pitchAmount = -getMagnitudeInDirection(targetVec, core.getConstructWorldOrientationUp()) * autopilotStrength
        if previousYawAmount == 0 then previousYawAmount = yawAmount / 2 end
        if previousPitchAmount == 0 then previousPitchAmount = pitchAmount / 2 end
        -- Skip dampening at very low values, and force it to effectively overshoot so it can more accurately align back
        -- Instead of taking literal forever to converge
        if math.abs(yawAmount) < 0.1 then
            yawInput2 = yawInput2 - yawAmount*2
        else
            yawInput2 = yawInput2 - (yawAmount + (yawAmount - previousYawAmount) * dampingMult)
        end
        if math.abs(pitchAmount) < 0.1 then
            pitchInput2 = pitchInput2 + pitchAmount*2
        else
            pitchInput2 = pitchInput2 + (pitchAmount + (pitchAmount - previousPitchAmount) * dampingMult)
        end


        previousYawAmount = yawAmount
        previousPitchAmount = pitchAmount
        -- Return true or false depending on whether or not we're aligned
        if math.abs(yawAmount) < tolerance and math.abs(pitchAmount) < tolerance then
            return true
        end
        return false
    elseif stalling and hovGndDet == -1 then
        -- If stalling, align to velocity to fix the stall
        -- IDK I'm just copy pasting all this
        vector = vec3(core.getWorldVelocity())
        local dampingMult = damping
        if dampingMult == nil then
            dampingMult = DampingMultiplier
        end

        if tolerance == nil then
            tolerance = alignmentTolerance
        end
        vector = vec3(vector):normalize()
        local targetVec = (vec3(core.getConstructWorldOrientationForward()) - vector)
        local yawAmount = -getMagnitudeInDirection(targetVec, core.getConstructWorldOrientationRight()) * autopilotStrength
        local pitchAmount = -getMagnitudeInDirection(targetVec, core.getConstructWorldOrientationUp()) * autopilotStrength
        if previousYawAmount == 0 then previousYawAmount = yawAmount / 2 end
        if previousPitchAmount == 0 then previousPitchAmount = pitchAmount / 2 end
        -- Skip dampening at very low values, and force it to effectively overshoot so it can more accurately align back
        -- Instead of taking literal forever to converge
        if math.abs(yawAmount) < 0.1 then
            yawInput2 = yawInput2 - yawAmount*5
        else
            yawInput2 = yawInput2 - (yawAmount + (yawAmount - previousYawAmount) * dampingMult)
        end
        if math.abs(pitchAmount) < 0.1 then
            pitchInput2 = pitchInput2 + pitchAmount*5
        else
            pitchInput2 = pitchInput2 + (pitchAmount + (pitchAmount - previousPitchAmount) * dampingMult)
        end
        previousYawAmount = yawAmount
        previousPitchAmount = pitchAmount
        -- Return true or false depending on whether or not we're aligned
        if math.abs(yawAmount) < tolerance and math.abs(pitchAmount) < tolerance then
            return true
        end
        return false
    end
end

function getAPEnableName()
    local name = AutopilotTargetName
    if name == nil then
        local displayText, displayUnit = getDistanceDisplayString((vec3(core.getConstructWorldPos()) - CustomTarget.position):len())
        name = CustomTarget.name .. " " .. displayText .. displayUnit
                   
    end
    if name == nil then
        name = "None"
    end
    return "Engage Autopilot: " .. name
end

function getAPDisableName()
    local name = AutopilotTargetName
    if name == nil then
        name = CustomTarget.name
    end
    if name == nil then
        name = "None"
    end
    return "Disable Autopilot: " .. name
end

function ToggleAntigrav()
    if antigrav and not ExternalAGG then
        if antigrav.getState() == 1 then
            antigrav.deactivate()
            antigrav.hide()
        else
            if AntigravTargetAltitude == nil then AntigravTargetAltitude = coreAltitude end
            if AntigravTargetAltitude < 1000 then
                AntigravTargetAltitude = 1000
            end
            antigrav.activate()
            antigrav.show()
        end
    end
end

function BeginReentry()
    if Reentry then
        msgText = "Re-Entry cancelled"
        Reentry = false
        autoRoll = autoRollPreference
        AltitudeHold = false
    elseif atmosphere() ~= 0 or unit.getClosestPlanetInfluence() <= 0 or Reentry or not planet.hasAtmosphere then
        msgText = "Re-Entry requirements not met: you must start out of atmosphere\n and within a planets gravity well over a planet with atmosphere"
        msgTimer = 5
    elseif not reentryMode then-- Parachute ReEntry
        StrongBrakes = ((planet.gravity * 9.80665 * constructMass()) < LastMaxBrakeInAtmo)
        if not StrongBrakes  then
            msgText = "WARNING: Insufficient Brakes for Parachute Re-Entry"
        else
            Reentry = true
            if Nav.axisCommandManager:getAxisCommandType(0) ~= controlMasterModeId.cruise then
                Nav.control.cancelCurrentControlMasterMode()
            end                
            autoRoll = true
            BrakeIsOn = false
            msgText = "Beginning Parachute Re-Entry - Strap In.  Target speed: " .. ReentrySpeed
        end
    else --Glide Reentry
        Reentry = true
        if Nav.axisCommandManager:getAxisCommandType(0) ~= controlMasterModeId.cruise then
            Nav.control.cancelCurrentControlMasterMode()
        end
        AltitudeHold = true
        autoRoll = true
        BrakeIsOn = false
        HoldAltitude = ReentryAltitude
        msgText = "Beginning Re-entry.  Target speed: " .. ReentrySpeed .. " Target Altitude: " ..
                    ReentryAltitude
    end
end

function SetupButtons()
    -- BEGIN BUTTON DEFINITIONS

    -- enableName, disableName, width, height, x, y, toggleVar, toggleFunction, drawCondition
    local buttonHeight = 50
    local buttonWidth = 260 -- Defaults
    local brake = MakeButton("Enable Brake Toggle", "Disable Brake Toggle", buttonWidth, buttonHeight,
                        resolutionWidth / 2 - buttonWidth / 2, resolutionHeight / 2 + 350, function()
            return BrakeToggleStatus
        end, function()
            BrakeToggleStatus = not BrakeToggleStatus
            if (BrakeToggleStatus) then
                msgText = "Brakes in Toggle Mode"
            else
                msgText = "Brakes in Default Mode"
            end
        end)
    MakeButton("Align Prograde", "Disable Prograde", buttonWidth, buttonHeight,
        resolutionWidth / 2 - buttonWidth / 2 - 50 - brake.width, resolutionHeight / 2 - buttonHeight + 380,
        function()
            return ProgradeIsOn
        end, ProgradeToggle)
    MakeButton("Align Retrograde", "Disable Retrograde", buttonWidth, buttonHeight,
        resolutionWidth / 2 - buttonWidth / 2 + brake.width + 50, resolutionHeight / 2 - buttonHeight + 380,
        function()
            return RetrogradeIsOn
        end, RetrogradeToggle, function()
            return atmosphere() == 0
        end) -- Hope this works
    local apbutton = MakeButton(getAPEnableName, getAPDisableName, 600, 60, resolutionWidth / 2 - 600 / 2,
                            resolutionHeight / 2 - 60 / 2 - 400, function()
            return Autopilot
        end, ToggleAutopilot)
    MakeButton("Save Position", "Save Position", 200, apbutton.height, apbutton.x + apbutton.width + 30, apbutton.y,
        function()
            return false
        end, AddNewLocation, function()
            return AutopilotTargetIndex == 0 or CustomTarget == nil
        end)
    MakeButton("Update Position", "Update Position", 200, apbutton.height, apbutton.x + apbutton.width + 30, apbutton.y,
        function()
            return false
        end, UpdatePosition, function()
            return AutopilotTargetIndex > 0 and CustomTarget ~= nil
        end)
    MakeButton("Clear Position", "Clear Position", 200, apbutton.height, apbutton.x - 200 - 30, apbutton.y,
        function()
            return true
        end, ClearCurrentPosition, function()
            return AutopilotTargetIndex > 0 and CustomTarget ~= nil
        end)
    -- The rest are sort of standardized
    buttonHeight = 60
    buttonWidth = 300
    local x = 10
    local y = resolutionHeight / 2 - 300
    MakeButton("Enable Turn and Burn", "Disable Turn and Burn", buttonWidth, buttonHeight, x, y, function()
        return TurnBurn
    end, ToggleTurnBurn)
    MakeButton("Engage Altitude Hold", "Disable Altitude Hold", buttonWidth, buttonHeight, x + buttonWidth + 20, y,
        function()
            return AltitudeHold
        end, ToggleAltitudeHold)
    y = y + buttonHeight + 20
    MakeButton("Engage Autoland", "Disable Autoland", buttonWidth, buttonHeight, x, y, function()
        return AutoLanding
    end, ToggleAutoLanding)
    MakeButton("Engage Auto Takeoff", "Disable Auto Takeoff", buttonWidth, buttonHeight, x + buttonWidth + 20, y,
        function()
            return AutoTakeoff
        end, ToggleAutoTakeoff)
    y = y + buttonHeight + 20
    MakeButton("Show Orbit Display", "Hide Orbit Display", buttonWidth, buttonHeight, x, y,
        function()
            return DisplayOrbit
        end, function()
            DisplayOrbit = not DisplayOrbit
            if (DisplayOrbit) then
                msgText = "Orbit Display Enabled"
            else
                msgText = "Orbit Display Disabled"
            end
        end)
    y = y + buttonHeight + 20
    MakeButton("Glide Re-Entry", "Cancel Glide Re-Entry", buttonWidth, buttonHeight, x, y,
        function() return Reentry end, function() reentryMode = true BeginReentry() end, function() return (coreAltitude > ReentryAltitude) end )
    MakeButton("Parachute Re-Entry", "Cancel Parachute Re-Entry", buttonWidth, buttonHeight, x + buttonWidth + 20, y,
        function() return Reentry end, BeginReentry, function() return (coreAltitude > ReentryAltitude) end )
    y = y + buttonHeight + 20
    MakeButton("Engage Follow Mode", "Disable Follow Mode", buttonWidth, buttonHeight, x, y, function()
        return followMode
    end, ToggleFollowMode, function()
        return isRemote() == 1
    end)
    MakeButton("Enable Repair Arrows", "Disable Repair Arrows", buttonWidth, buttonHeight, x + buttonWidth + 20, y, function()
        return repairArrows
    end, function()
        repairArrows = not repairArrows
        if (repairArrows) then
            msgText = "Repair Arrows Enabled"
        else
            msgText = "Repair Arrows Diabled"
        end
    end, function()
        return isRemote() == 1
    end)
    y = y + buttonHeight + 20
    if not ExternalAGG then
        MakeButton("Enable AGG", "Disable AGG", buttonWidth, buttonHeight, x, y, function()
        return antigrav.getState() == 1 end, ToggleAntigrav, function()
        return antigrav ~= nil end)
    end   
    y = y + buttonHeight + 20
    MakeButton(function()
        return stringf("Toggle Control Scheme - Current: %s", userControlScheme)
    end, function()
        return stringf("Control Scheme: %s", userControlScheme)
    end, buttonWidth * 2, buttonHeight, x, y, function()
        return false
    end, function()
        if userControlScheme == "keyboard" then
            userControlScheme = "mouse"
        elseif userControlScheme == "mouse" then
            userControlScheme = "virtual joystick"
        else
            userControlScheme = "keyboard"
        end
    end)
end

function GetFlightStyle()
    local flightType = Nav.axisCommandManager:getAxisCommandType(0)
    local flightStyle = "TRAVEL"
    if (flightType == 1) then
        flightStyle = "CRUISE"
    end
    if Autopilot then
        flightStyle = "AUTOPILOT"
    end
    return flightStyle
end

function UpdateHud(newContent)

    local altitude = coreAltitude
    local velocity = core.getVelocity()
    local speed = vec3(velocity):len()
    local worldV = vec3(core.getWorldVertical())
    local constrF = vec3(core.getConstructWorldOrientationForward())
    local constrR = vec3(core.getConstructWorldOrientationRight())
    local constrU = vec3(core.getConstructWorldOrientationUp())
    local roll = getRoll(worldV, constrF, constrR) 
    local radianRoll = (roll / 180) * math.pi
    local corrX = math.cos(radianRoll)
    local corrY = math.sin(radianRoll)
    local pitch = getPitch(worldV, constrF, (constrR * corrX) + (constrU * corrY)) -- 180 - getRoll(worldV, constrR, constrF)            
    local originalRoll = roll
    local originalPitch = pitch
    local atmos = atmosphere()
    local throt = mfloor(unit.getThrottle())
    local spd = speed * 3.6
    local flightValue = unit.getAxisCommandValue(0)
    local flightStyle = GetFlightStyle()
    local bottomText = "ROLL"
    local nearPlanet = unit.getClosestPlanetInfluence() > 0
    if throt == nil then throt = 0 end

    if (not nearPlanet) then
        if (speed > 5) then
            pitch = getRelativePitch(velocity)
            roll = getRelativeYaw(velocity)
        else
            pitch = 0
            roll = 0
        end
        bottomText = "YAW"
    end

    -- CRUISE/ODOMETER

    newContent[#newContent + 1] = lastOdometerOutput

    -- DAMAGE

    newContent[#newContent + 1] = damageMessage

    -- RADAR

    newContent[#newContent + 1] = radarMessage

    -- FUEL TANKS

    if (updateCount % fuelUpdateDelay == 0) then
        updateTanks = true
    end
    if (fuelX ~= 0 and fuelY ~= 0) then
        DrawTank(newContent, updateTanks, fuelX, "Atmospheric ", "ATMO", atmoTanks, fuelTimeLeft, fuelPercent)
        DrawTank(newContent, updateTanks, fuelX+100, "Space fuel t", "SPACE", spaceTanks, fuelTimeLeftS, fuelPercentS)
        DrawTank(newContent, updateTanks, fuelX+200, "Rocket fuel ", "ROCKET", rocketTanks, fuelTimeLeftR, fuelPercentR)
    end

    if updateTanks then
        updateTanks = false
        updateCount = 0
    end
    updateCount = updateCount + 1

    -- PRIMARY FLIGHT INSTRUMENTS

    DrawVerticalSpeed(newContent, altitude) -- Weird this is draw during remote control...?


    if isRemote() == 0 or RemoteHud then
        -- Don't even draw this in freelook
       if not IsInFreeLook() or brightHud then
            if nearPlanet then -- use real pitch, roll, and heading
                DrawRollLines (newContent, centerX, centerY, originalRoll, bottomText, nearPlanet)
                DrawArtificialHorizon(newContent, originalPitch, originalRoll, centerX, centerY, nearPlanet, mfloor(getRelativeYaw(velocity)), speed)
            else -- use Relative Pitch and Relative Yaw
                DrawRollLines (newContent, centerX, centerY, roll, bottomText, nearPlanet)
                DrawArtificialHorizon(newContent, pitch, roll, centerX, centerY, nearPlanet, mfloor(roll), speed)
            end
            DrawAltitudeDisplay(newContent, altitude, nearPlanet)
            DrawPrograde(newContent, velocity, speed, centerX, centerY)
        end
    end
    DrawThrottle(newContent, flightStyle, throt, flightValue)

    -- PRIMARY DATA DISPLAYS

    DrawSpeed(newContent, spd)

    DrawWarnings(newContent)
    DisplayOrbitScreen(newContent)
    if screen_2 then
        local pos = vec3(core.getConstructWorldPos())
        local x = 960 + pos.x / MapXRatio
        local y = 450 + pos.y / MapYRatio
        screen_2.moveContent(YouAreHere, (x - 80) / 19.2, (y - 80) / 10.8)
    end
end

function IsInFreeLook()
    return system.isViewLocked() == 0 and userControlScheme ~= "keyboard" and isRemote() == 0
end

function HUDPrologue(newContent)
    local bright = rgb
    local dim = rgbdim
    local brightOrig = rgb
    local dimOrig = rgbdim
    if IsInFreeLook() and not brightHud then
        bright = [[rgb(]] .. mfloor(PrimaryR * 0.4 + 0.5) .. "," .. mfloor(PrimaryG * 0.4 + 0.5) .. "," ..
                     mfloor(PrimaryB * 0.3 + 0.5) .. [[)]]
        dim = [[rgb(]] .. mfloor(PrimaryR * 0.3 + 0.5) .. "," .. mfloor(PrimaryG * 0.3 + 0.5) .. "," ..
                  mfloor(PrimaryB * 0.2 + 0.5) .. [[)]]
    end

    -- When applying styles, apply color first, then type (e.g. "bright line")
    -- so that "fill:none" gets applied

    newContent[#newContent + 1] = stringf([[
        <head>
            <style>
                body {margin: 0}
                svg {position:absolute;top:0;left:0;font-family:Montserrat;} 
                .txt {font-size:10px;font-weight:bold;}
                .txttick {font-size:12px;font-weight:bold;}
                .txtbig {font-size:14px;font-weight:bold;}
                .altsm {font-size:16px;font-weight:normal;}
                .altbig {font-size:21px;font-weight:normal;}
                .line {stroke-width:2px;fill:none}
                .linethick {stroke-width:3px;fill:none}
                .warnings {font-size:26px;fill:red;text-anchor:middle;font-family:Bank}
                .warn {fill:orange;font-size:24px}
                .crit {fill:darkred;font-size:28px}
                .bright {fill:%s;stroke:%s}
                .pbright {fill:%s;stroke:%s}
                .dim {fill:%s;stroke:%s}
                .pdim {fill:%s;stroke:%s}
                .red {fill:red;stroke:red}
                .redout {fill:none;stroke:red}
                .op30 {opacity:0.3}
                .op10 {opacity:0.1}
                .txtstart {text-anchor:start}
                .txtend {text-anchor:end}
                .txtmid {text-anchor:middle}
                .txtvspd {font-family:sans-serif;font-weight:normal}
                .txtvspdval {font-size:20px}
                .txtfuel {font-size:11px;font-weight:bold}
                .txtorb {font-size:12px}
                .txtorbbig {font-size:18px}
                .hudver {font-size:10px;font-weight:bold;fill:red;text-anchor:end;font-family:Bank}
                .msg {font-size:40px;fill:red;text-anchor:middle;font-weight:normal}
                .cursor {stroke:white}
            </style>
        </head>
        <body>
            <svg height="100%%" width="100%%" viewBox="0 0 %d %d">
            ]], bright, bright, brightOrig, brightOrig, dim, dim, dimOrig, dimOrig, ResolutionX, ResolutionY)
end

function HUDEpilogue(newContent)
    newContent[#newContent + 1] = "</svg>"
end

function DrawSpeed(newContent, spd)
    local ys = throtPosY-10 
    local x1 = throtPosX + 10
    newContent[#newContent + 1] = [[<g class="pdim txt txtend">]]
    if isRemote() == 1 and not RemoteHud then
        ys = 75
    end
    newContent[#newContent + 1] = stringf([[
        <g class="pbright txtstart">
            <text class="txtbig" x="%d" y="%d">%d km/h</text>
        </g>
    </g>]], x1, ys, mfloor(spd))
end

function DrawOdometer(newContent, totalDistanceTrip, TotalDistanceTravelled, flightStyle, flightTime, atmos)
    local xg = ConvertResolutionX(1240)
    local yg1 = ConvertResolutionY(55)
    local yg2 = yg1+10
    local atmos = atmosphere()
    local gravity = core.g()
    local maxMass = 0
    local reqThrust = 0
    local brakeValue = 0
    RefreshLastMaxBrake(gravity)
    if inAtmo then brakeValue = LastMaxBrakeInAtmo else brakeValue = LastMaxBrake end
    maxThrust = Nav:maxForceForward()
    totalMass = constructMass()
    if not ShowOdometer then return end
    local accel = (vec3(core.getWorldAcceleration()):len() / 9.80665)
    if gravity > 0.1 then
        reqThrust = totalMass * gravity
        maxMass = maxThrust / gravity
    end
    newContent[#newContent + 1] = [[<g class="pdim txt txtend">]]
    if isRemote() == 1 and not RemoteHud then
        xg = ConvertResolutionX(1120)
        yg1 = ConvertResolutionY(55)
        yg2 = yg1+10
    elseif inAtmo then -- We only show atmo when not remote
        local atX = ConvertResolutionX(770)
        newContent[#newContent + 1] = stringf([[
            <text x="%d" y="%d">ATMOSPHERE</text>
            <text x="%d" y="%d">%.2f</text>
        ]], atX, yg1, atX, yg2, atmos)
    end
    newContent[#newContent + 1] = stringf([[
        <g class="pbright txtend">
        </g>
        <text x="%d" y="%d">GRAVITY</text>
        <text x="%d" y="%d">%.2f g</text>
        <text x="%d" y="%d">ACCEL</text>
        <text x="%d" y="%d">%.2f g</text>
        ]], xg, yg1, xg, yg2, (gravity / 9.80665), xg, yg1 + 20, xg, yg2 + 20, accel)
    newContent[#newContent + 1] = stringf([[
        <g class="pbright txt">
        <path class="linethick" d="M %d 0 L %d %d Q %d %d %d %d L %d 0"/>]],
        ConvertResolutionX(660), ConvertResolutionX(700), ConvertResolutionY(35), ConvertResolutionX(960), ConvertResolutionY(55),
        ConvertResolutionX(1240), ConvertResolutionY(35), ConvertResolutionX(1280))
    if isRemote() == 0 or RemoteHud then
        newContent[#newContent + 1] = stringf([[
            <text class="txtstart" x="%d" y="%d" >Trip: %.2f km</text>
            <text class="txtstart" x="%d" y="%d">Lifetime: %.2f Mm</text>
            <text class="txtstart" x="%d" y="%d">Trip Time: %s</text>
            <text class="txtstart" x="%d" y="%d">Total Time: %s</text>
            <text class="txtstart" x="%d" y="%d">Mass: %.2f Tons</text>
            <text class="txtend" x="%d" y="%d">Max Brake: %.2f kN</text>
            <text class="txtend" x="%d" y="%d">Max Thrust: %.2f kN</text>
            <text class="txtbig txtmid" x="%d" y="%d">%s</text>]],
            ConvertResolutionX(700), ConvertResolutionY(20), totalDistanceTrip, ConvertResolutionX(700), ConvertResolutionY(30), (TotalDistanceTravelled / 1000),
            ConvertResolutionX(830), ConvertResolutionY(20), FormatTimeString(flightTime), ConvertResolutionX(830), ConvertResolutionY(30), FormatTimeString(TotalFlightTime),
            ConvertResolutionX(970), ConvertResolutionY(20), (totalMass / 1000), ConvertResolutionX(1240), ConvertResolutionY(10), (brakeValue / 1000),
            ConvertResolutionX(1240), ConvertResolutionY(30), (maxThrust / 1000), ConvertResolutionX(960), ConvertResolutionY(180), flightStyle)
        if gravity > 0.1 then
            newContent[#newContent + 1] = stringf([[
                    <text class="txtstart" x="%d" y="%d">Max Mass: %.2f Tons</text>
                    <text class="txtend" x="%d" y="%d">Req Thrust: %.2f kN</text>
            ]], ConvertResolutionX(970), ConvertResolutionY(30), (maxMass / 1000), ConvertResolutionX(1240), ConvertResolutionY(20), (reqThrust / 1000))
        else
            newContent[#newContent + 1] = stringf([[
                <text class="txtstart" x="%d" y="%d" text-anchor="start">Max Mass: n/a</text>
                <text class="txtend" x="%d" y="%d" text-anchor="end">Req Thrust: n/a</text>
            ]], ConvertResolutionX(970), ConvertResolutionY(30), ConvertResolutionX(1240), ConvertResolutionY(20))
        end
    else -- If remote controlled, draw stuff near the top so it's out of the way
        newContent[#newContent + 1] = stringf([[<text class="txtbig txtmid" x="960" y="33">%s</text>]],
                                        ConvertResolutionX(960), ConvertResolutionY(33), flightStyle)
    end
    newContent[#newContent + 1] = "</g>"
end

function DrawThrottle(newContent, flightStyle, throt, flightValue)

    local y1 = throtPosY+10
    local y2 = throtPosY+20
    if isRemote() == 1 and not RemoteHud then
        y1 = 55
        y2 = 65
    end

    local label = "CRUISE"
    local unit = "km/h"
    local value = flightValue
    if (flightStyle == "TRAVEL" or flightStyle == "AUTOPILOT") then
        label = "THROT"
        unit = "%"
        value = throt
        local throtclass = "dim"
        if throt < 0 then
            throtclass = "red"
        end
        newContent[#newContent + 1] = stringf([[<g class="%s">
            <path class="linethick" d="M %d %d L %d %d L %d %d L %d %d"/>
            <g transform="translate(0 %d)">
                <polygon points="%d,%d %d,%d %d,%d"/>
            </g>]], throtclass, throtPosX-7, throtPosY-50, throtPosX, throtPosY-50, throtPosX, throtPosY+50, throtPosX-7, throtPosY+50, (1 - math.abs(throt)), 
            throtPosX-10, throtPosY+50, throtPosX-15, throtPosY+53, throtPosX-15, throtPosY+47)
    end
    newContent[#newContent + 1] = stringf([[
        <g class="pbright txtstart">
                <text x="%d" y="%d">%s</text>
                <text x="%d" y="%d">%d %s</text>
        </g>
    </g>]], throtPosX+10, y1, label, throtPosX+10, y2, value, unit)
end

 
function DrawVerticalSpeed(newContent, altitude) -- Draw vertical speed indicator - Code by lisa-lionheart
    if (altitude < 200000 and not inAtmo) or (altitude and inAtmo) then
        local vSpd = -vec3(core.getWorldVertical()):dot(vec3(core.getWorldVelocity()))
        local angle = 0
        if math.abs(vSpd) > 1 then
            angle = 45 * math.log(math.abs(vSpd), 10)
            if vSpd < 0 then
                angle = -angle
            end
        end
        newContent[#newContent + 1] = stringf([[
            <g class="pbright txt txtvspd" transform="translate(%d %d) scale(0.6)">
                    <text x="31" y="-41">1000</text>
                    <text x="-10" y="-65">100</text>
                    <text x="-54" y="-45">10</text>
                    <text x="-73" y="3">O</text>
                    <text x="-56" y="52">-10</text>
                    <text x="-14" y="72">-100</text>
                    <text x="29" y="50">-1000</text>
                    <text x="85" y="0" class="txtvspdval txtend">%d m/s</text>
                <g class="linethick">
                    <path d="m-41 75 2.5-4.4m17 12 1.2-4.9m20 7.5v-10m-75-34 4.4-2.5m-12-17 4.9-1.2m17 40 7-7m-32-53h10m34-75 2.5 4.4m17-12 1.2 4.9m20-7.5v10m-75 34 4.4 2.5m-12 17 4.9 1.2m17-40 7 7m-32 53h10m116 75-2.5-4.4m-17 12-1.2-4.9m40-17-7-7m-12-128-2.5 4.4m-17-12-1.2 4.9m40 17-7 7"/>
                    <circle r="90" />
                </g>
                <path transform="rotate(%d)" d="m-0.094-7c-22 2.2-45 4.8-67 7 23 1.7 45 5.6 67 7 4.4-0.068 7.8-4.9 6.3-9.1-0.86-2.9-3.7-5-6.8-4.9z" />
            </g>
        ]], vSpdMeterX, vSpdMeterY, mfloor(vSpd), mfloor(angle))
    end
end

function getHeading(forward) -- code provided by tomisunlucky   
    local up = -vec3(core.getWorldVertical())
    forward = forward - forward:project_on(up)
    local north = vec3(0, 0, 1)
    north = north - north:project_on(up)
    local east = north:cross(up)
    local angle = north:angle_between(forward) * constants.rad2deg
    if forward:dot(east) < 0 then
        angle = 360-angle
    end
    return angle
end

function DrawRollLines (newContent, centerX, centerY, originalRoll, bottomText, nearPlanet)
    local horizonRadius = circleRad -- Aliased global
    local OFFSET = 20
    OFFSET = mfloor(OFFSET )
    local rollC = mfloor(originalRoll)
    if nearPlanet then 
        for i = -45, 45, 5 do
            local rot = i
            newContent[#newContent + 1] = stringf([[<g transform="rotate(%f,%d,%d)">]], rot, centerX, centerY)
            len = 5
            if (i % 15 == 0) then
                len = 15
            elseif (i % 10 == 0) then
                len = 10
            end
            newContent[#newContent + 1] = stringf([[<line x1=%d y1=%d x2=%d y2="%d"/></g>]], centerX, centerY + horizonRadius + OFFSET - len, centerX, centerY + horizonRadius + OFFSET)
        end 
        newContent[#newContent + 1] = stringf([["
            <g class="pdim txt txtmid">
                <text x="%d" y="%d">%s</text>
                <text x="%d" y="%d">%d deg</text>
            </g>
            ]], centerX, centerY+horizonRadius+OFFSET-35, bottomText, centerX, centerY+horizonRadius+OFFSET-25, rollC)
        newContent[#newContent + 1] = stringf([[<g transform="rotate(%f,%d,%d)">]], -originalRoll, centerX, centerY)
        newContent[#newContent + 1] = stringf([[<<polygon points="%d,%d %d,%d %d,%d"/>]],
            centerX-5, centerY+horizonRadius+OFFSET-20, centerX+5, centerY+horizonRadius+OFFSET-20, centerX, centerY+horizonRadius+OFFSET-15)
        newContent[#newContent +1] = "</g>"
    end
    local yaw = rollC
    if nearPlanet then yaw = getHeading(vec3(core.getConstructWorldOrientationForward())) end
    local range = 20
    local yawC = mfloor(yaw) 
    local yawlen = 0
    local yawy = (centerY + horizonRadius + OFFSET + 20)
    local yawx = centerX
    if bottomText ~= "YAW" then 
        yawy = ConvertResolutionY(130)
        yawx = ConvertResolutionX(960)
    end
    local tickerPath = [[<path class="txttick line" d="]]
    for i = mfloor(yawC - (range+10) - yawC % 5 + 0.5), mfloor(yawC + (range+10) + yawC % 5 + 0.5), 5 do
        local x = yawx + (-i * 5 + yaw * 5)
        if (i % 10 == 0) then
            yawlen = 10
            local num = i
            if num == 360 then 
                num = 0
            elseif num  > 360 then  
                num = num - 360 
            elseif num < 0 then
                num = num + 360
            end
            newContent[#newContent + 1] = stringf([[
                    <text x="%f" y="%f">%d</text>]],x+5,yawy-12, num)
        elseif (i % 5 == 0) then
            yawlen = 5
        end
        if yawlen == 10 then
            tickerPath = stringf([[%s M %f %f v %d]], tickerPath, x, yawy-5, yawlen)
        else
            tickerPath = stringf([[%s M %f %f v %d]], tickerPath, x, yawy-2.5, yawlen)
        end
    end
    newContent[#newContent + 1] = tickerPath .. [["/>]]
    newContent[#newContent + 1] = stringf([[<<polygon points="%d,%d %d,%d %d,%d"/>]],
        yawx-5, yawy+10, yawx+5, yawy+10, yawx, yawy+5)
    if nearPlanet then bottomText = "HDG" end
    newContent[#newContent + 1] = stringf([["
        <g class="pdim txt txtmid">
        <text x="%d" y="%d">%d deg</text>
        <text x="%d" y="%d">%s</text>
        </g>
        ]], yawx, yawy+25, yawC, yawx, yawy+35, bottomText)
end

function DrawArtificialHorizon(newContent, originalPitch, originalRoll, centerX, centerY, nearPlanet, atmoYaw, speed)
    -- ** CIRCLE ALTIMETER  - Base Code from Discord @Rainsome = Youtube CaptainKilmar** 
    local horizonRadius = circleRad -- Aliased global
    local pitchX = mfloor(horizonRadius * 3 / 5)
    if horizonRadius > 0 then
        local pitchC = mfloor(originalPitch)
        local len = 0
        local tickerPath = stringf([[<path transform="rotate(%f,%d,%d)" class="dim line" d="]], (-1 * originalRoll), centerX, centerY)
        if not inAtmo then
            tickerPath = stringf([[<path transform="rotate(0,%d,%d)" class="dim line" d="]], centerX, centerY)
        end
        newContent[#newContent + 1] = stringf([[<clipPath id="cut"><circle r="%f" cx="%d" cy="%d"/></clipPath>]],(horizonRadius - 1), centerX, centerY)
        newContent[#newContent + 1] = [[<g class="dim txttick" clip-path="url(#cut)">]]
        for i = mfloor(pitchC - 30 - pitchC % 5 + 0.5), mfloor(pitchC + 30 + pitchC % 5 + 0.5), 5 do
            if (i % 10 == 0) then
                len = 30
            elseif (i % 5 == 0) then
                len = 20
            end
            local y = centerY + (-i * 5 + originalPitch * 5)
            if len == 30 then
                tickerPath = stringf([[%s M %d %f h %d]], tickerPath, centerX-pitchX-len, y, len)
                if inAtmo then
                    newContent[#newContent + 1] = stringf([[<g path transform="rotate(%f,%d,%d)" class="pdim txt txtmid"><text x="%d" y="%f">%d</text></g>]],(-1 * originalRoll), centerX, centerY, centerX-pitchX+10, y, i)
                    newContent[#newContent + 1] = stringf([[<g path transform="rotate(%f,%d,%d)" class="pdim txt txtmid"><text x="%d" y="%f">%d</text></g>]],(-1 * originalRoll), centerX, centerY, centerX+pitchX-10, y, i)
                    if i == 0 or i == 180 or i == -180 then 
                        newContent[#newContent + 1] = stringf([[<path transform="rotate(%f,%d,%d)" d="m %d,%f %d,0" stroke-width="1" style="fill:none;stroke:#F5B800;" />]],
                            (-1 * originalRoll), centerX, centerY, centerX-pitchX+20, y, pitchX*2-40)
                    end
                else
                    newContent[#newContent + 1] = stringf([[<g class="pdim txt txtmid"><text x="%d" y="%f">%d</text></g>]], centerX-pitchX+10, y, i)
                    newContent[#newContent + 1] = stringf([[<g class="pdim txt txtmid"><text x="%d" y="%f">%d</text></g>]], centerX+pitchX-10, y, i)
                end                            
                tickerPath = stringf([[%s M %d %f h %d]], tickerPath, centerX+pitchX, y, len)
            else
                tickerPath = stringf([[%s M %d %f h %d]], tickerPath, centerX-pitchX-len, y, len)
                tickerPath = stringf([[%s M %d %f h %d]], tickerPath, centerX+pitchX, y, len)
            end
        end
        newContent[#newContent + 1] = tickerPath .. [["/>]]
        local pitchstring = "PITCH"                
        if not nearPlanet then 
            pitchstring = "REL PITCH"
        end
        if originalPitch > 90 and not inAtmo then
            originalPitch = 90 - (originalPitch - 90)
        elseif originalPitch < -90 and not inAtmo then
            originalPitch = -90 - (originalPitch + 90)
        end
        if horizonRadius > 200 then
            if inAtmo then
                if speed > minAutopilotSpeed then
                    newContent[#newContent + 1] = stringf([["
                    <g class="pdim txt txtmid">
                    <text x="%d" y="%d">%s</text>
                    <text x="%d" y="%d">%d deg</text>
                    </g>
                    ]],  centerX, centerY-15, "Yaw", centerX, centerY+20, atmoYaw)                            
                end
                newContent[#newContent + 1] = stringf([[<g transform="rotate(%f,%d,%d)">]], -originalRoll, centerX, centerY)
            else
                newContent[#newContent + 1] = stringf([[<g transform="rotate(0,%d,%d)">]], centerX, centerY)
            end
            newContent[#newContent + 1] = stringf([[<<polygon points="%d,%d %d,%d %d,%d"/> class="pdim txtend"><text x="%d" y="%f">%d</text>]],
            centerX-pitchX+25, centerY-5, centerX-pitchX+20, centerY, centerX-pitchX+25, centerY+5, centerX-pitchX+50, centerY+4, pitchC)
            newContent[#newContent + 1] = stringf([[<<polygon points="%d,%d %d,%d %d,%d"/> class="pdim txtend"><text x="%d" y="%f">%d</text>]],
            centerX+pitchX-25, centerY-5, centerX+pitchX-20, centerY, centerX+pitchX-25, centerY+5, centerX+pitchX-30, centerY+4, pitchC)
            newContent[#newContent +1] = "</g>"
        end
        local thirdHorizontal = mfloor(horizonRadius/3)
        newContent[#newContent + 1] = stringf([[<path d="m %d,%d %d,0" stroke-width="2" style="fill:none;stroke:#F5B800;" />]],
            centerX-thirdHorizontal, centerY, horizonRadius-thirdHorizontal)
        if not inAtmo and nearPlanet then 
            newContent[#newContent + 1] = stringf([[<path transform="rotate(%f,%d,%d)" d="m %d,%f %d,0" stroke-width="1" style="fill:none;stroke:#F5B800;" />]],
                (-1 * originalRoll), centerX, centerY, centerX-pitchX+10, centerY, pitchX*2-20)
        end
        newContent[#newContent + 1] = "</g>"
        if horizonRadius < 200 then
            if inAtmo and speed > minAutopilotSpeed then 
                newContent[#newContent + 1] = stringf([["
                <g class="pdim txt txtmid">
                <text x="%d" y="%d">%s</text>
                <text x="%d" y="%d">%d deg</text>
                <text x="%d" y="%d">%s</text>
                <text x="%d" y="%d">%d deg</text>
                </g>
                ]], centerX, centerY-horizonRadius, pitchstring, centerX, centerY-horizonRadius+10, pitchC, centerX, centerY-15, "Yaw", centerX, centerY+20, atmoYaw)
            else
                newContent[#newContent + 1] = stringf([["
                <g class="pdim txt txtmid">
                <text x="%d" y="%d">%s</text>
                <text x="%d" y="%d">%d deg</text>
                </g>
                ]], centerX, centerY-horizonRadius, pitchstring, centerX, centerY-horizonRadius+15, pitchC )                       
            end
        end
    end
end

function DrawAltitudeDisplay(newContent, altitude, nearPlanet)
    local rectX = altMeterX
    local rectY = altMeterY
    local rectW = 78
    local rectH = 19

    local gndHeight = AboveGroundLevel()

    if gndHeight ~= -1 then
        table.insert(newContent, stringf([[
        <g class="pdim altsm txtend">
        <text x="%d" y="%d">AGL: %.1fm</text>
        </g>
        ]], rectX+rectW, rectY+rectH+20, gndHeight))
    end

    if nearPlanet and ((altitude < 200000 and not inAtmo) or (altitude and inAtmo)) then
        table.insert(newContent, stringf([[
            <g class="pdim">                        
                <rect class="line" x="%d" y="%d" width="%d" height="%d"/> 
                <clipPath id="alt"><rect class="line" x="%d" y="%d" width="%d" height="%d"/></clipPath>
                <g clip-path="url(#alt)">]], 
                rectX - 1, rectY - 4, rectW + 2, rectH + 6,
                rectX + 1, rectY - 1, rectW - 4, rectH))

        local index = 0
        local divisor = 1
        local forwardFract = 0
        local isNegative = altitude < 0
        local rolloverDigit = 9
        if isNegative then
            rolloverDigit = 0
        end
        local altitude = math.abs(altitude)
        while index < 6 do
            local glyphW = 11
            local glyphH = 16
            local glyphXOffset = 9
            local glyphYOffset = 14
            local class = "altsm"

            if index > 2 then
                glyphH = glyphH + 3
                glyphW = glyphW + 2
                glyphYOffset = glyphYOffset + 2
                glyphXOffset = glyphXOffset - 6
                class = "altbig"
            end

            if isNegative then  
                class = class .. " red"
            end

            local digit = (altitude / divisor) % 10
            local intDigit = mfloor(digit)
            local fracDigit = mfloor((intDigit + 1) % 10)

            local fract = forwardFract
            if index == 0 then
                fract = digit - intDigit
                if isNegative then
                    fract = 1 - fract
                end
            end

            if isNegative and (index == 0 or forwardFract ~= 0) then
                local temp = fracDigit
                fracDigit = intDigit
                intDigit = temp
            end

            local topGlyphOffset = glyphH * (fract - 1) 
            local botGlyphOffset = topGlyphOffset + glyphH

            local x = rectX + glyphXOffset + (6 - index) * glyphW
            local y = rectY + glyphYOffset
            
            -- <g class="%s" clip-path="url(#%s)">
            table.insert(newContent, stringf([[
                <g class="%s">
                <text x="%d" y="%f">%d</text>
                <text x="%d" y="%f">%d</text>
                </g>
            ]], class, x, y + topGlyphOffset, fracDigit, x, y + botGlyphOffset, intDigit))
            
            index = index + 1
            divisor = divisor * 10
            if intDigit == rolloverDigit then
                forwardFract = fract
            else
                forwardFract = 0
            end
        end
        table.insert(newContent, [[</g></g>]])
    end
end

function DrawPrograde (newContent, velocity, speed, centerX, centerY)
    if (speed > 5 and not inAtmo) or (speed > minAutopilotSpeed) then
        local horizonRadius = circleRad -- Aliased global
        local pitchRange = 20
        local yawRange = 20
        local velo = vec3(velocity)
        local relativePitch = getRelativePitch(velo)
        local relativeYaw = getRelativeYaw(velo)

        local dotSize = 14
        local dotRadius = dotSize/2
        
        local dx = (-relativeYaw/yawRange)*horizonRadius -- Values from -1 to 1 indicating offset from the center
        local dy = (relativePitch/pitchRange)*horizonRadius
        local x = centerX + dx
        local y = centerY + dy

        local distance = math.sqrt((dx)^2 + (dy)^2)

        local progradeDot = [[<circle
        cx="]] .. x .. [["
        cy="]] .. y .. [["
        r="]] .. dotRadius/dotSize .. [["
        style="fill:#d7fe00;stroke:none;fill-opacity:1"/>
     <circle
        cx="]] .. x .. [["
        cy="]] .. y .. [["
        r="]] .. dotRadius .. [["
        style="stroke:#d7fe00;stroke-opacity:1;fill:none" />
     <path
        d="M ]] .. x-dotSize .. [[,]] .. y .. [[ h ]] .. dotRadius .. [["
        style="stroke:#d7fe00;stroke-opacity:1" />
     <path
        d="M ]] .. x+dotRadius .. [[,]] .. y .. [[ h ]] .. dotRadius .. [["
        style="stroke:#d7fe00;stroke-opacity:1" />
     <path
        d="M ]] .. x .. [[,]] .. y-dotSize .. [[ v ]] .. dotRadius .. [["
        style="stroke:#d7fe00;stroke-opacity:1" />]]
            
        if distance < horizonRadius then
            newContent[#newContent + 1] = progradeDot
            -- Draw a dot or whatever at x,y, it's inside the AH
        else
            -- x,y is outside the AH.  Figure out how to draw an arrow on the edge of the circle pointing to it.
            -- First get the angle
            -- tan(ang) = o/a, tan(ang) = x/y
            -- atan(x/y) = ang (in radians)
            -- This is a special overload for doing this on a circle and setting up the signs correctly for the quadrants
            local angle = math.atan(dy,dx)
             -- Project this onto the circle
            -- These are backwards from what they're supposed to be.  Don't know why, that's just what makes it work apparently
            local arrowSize = 4
            local projectedX = centerX + (horizonRadius)*math.cos(angle) -- Needs to be converted to deg?  Probably not
            local projectedY = centerY + (horizonRadius)*math.sin(angle)
            -- Draw an arrow that we will rotate by angle
            -- Convert angle to degrees
            newContent[#newContent + 1] = stringf('<g transform="rotate(%f %f %f)"><rect x="%f" y="%f" width="%f" height="%f" stroke="#d7fe00" fill="#d7fe00" /><path d="M %f %f l %f %f l %f %f z" fill="#d7fe00" stroke="#d7fe00"></g>', angle*(180/math.pi), projectedX, projectedY, projectedX-arrowSize, projectedY-arrowSize/2, arrowSize*2, arrowSize,
                                                                                                                                                projectedX+arrowSize, projectedY - arrowSize, arrowSize, arrowSize, -arrowSize, arrowSize)

            --newContent[#newContent + 1] = stringf('<circle cx="%f" cy="%f" r="2" stroke="white" stroke-width="2" fill="white" />', projectedX, projectedY)
        end

        if(not inAtmo) then
            relativePitch = getRelativePitch(-velo)
            relativeYaw = getRelativeYaw(-velo)
            
            dx = (-relativeYaw/yawRange)*horizonRadius -- Values from -1 to 1 indicating offset from the center
            dy = (relativePitch/pitchRange)*horizonRadius
            x = centerX + dx
            y = centerY + dy

            distance = math.sqrt((dx)^2 + (dy)^2)
            -- Retrograde Dot
            
            if distance < horizonRadius then
                local retrogradeDot = [[<circle
                cx="]] .. x .. [["
                cy="]] .. y .. [["
                r="]] .. dotRadius .. [["
                style="stroke:#d7fe00;stroke-opacity:1;fill:none" />
             <path
                d="M ]] .. x .. [[,]] .. y-dotSize .. [[ v ]] .. dotRadius .. [["
                style="stroke:#d7fe00;stroke-opacity:1" id="l"/>
             <use
                xlink:href="#l"
                transform="rotate(120,]] .. x .. [[,]] .. y .. [[)" />
             <use
                xlink:href="#l"
                transform="rotate(-120,]] .. x .. [[,]] .. y .. [[)" />
             <path
                d="M ]] .. x-dotRadius .. [[,]] .. y .. [[ h ]] .. dotSize .. [["
                style="stroke-width:0.5;stroke:#d7fe00;stroke-opacity:1"
                transform="rotate(-45,]] .. x .. [[,]] .. y .. [[)" id="c"/>
            <use
                xlink:href="#c"
                transform="rotate(-90,]] .. x .. [[,]] .. y .. [[)"/>]]
                newContent[#newContent + 1] = retrogradeDot
                -- Draw a dot or whatever at x,y, it's inside the AH
            end -- Don't draw an arrow for this one, only prograde is that important

        end
    end
end

function DrawWarnings(newContent)
    newContent[#newContent + 1] = stringf(
                                      [[<text class="hudver" x="%d" y="%d">DU Hud Version: %.3f</text>]], 
                                      ConvertResolutionX(1900), ConvertResolutionY(1070), VERSION_NUMBER)
    newContent[#newContent + 1] = [[<g class="warnings">]]
    if unit.isMouseControlActivated() == 1 then
        newContent[#newContent + 1] = stringf([[
            <text x="%d" y="%d">Warning: Invalid Control Scheme Detected</text>]],
            ConvertResolutionX(960), ConvertResolutionY(550))
        newContent[#newContent + 1] = stringf([[
            <text x="%d" y="%d">Keyboard Scheme must be selected</text>]],
            ConvertResolutionX(960), ConvertResolutionY(600))
        newContent[#newContent + 1] = stringf([[
            <text x="%d" y="%d">Set your preferred scheme in Lua Parameters instead</text>]],
            ConvertResolutionX(960), ConvertResolutionY(650))
    end
    local warningX = ConvertResolutionX(960)
    local brakeY = ConvertResolutionY(860)
    local gearY = ConvertResolutionY(880)
    local hoverY = ConvertResolutionY(900)
    local ewarpY = ConvertResolutionY(960)
    local apY = ConvertResolutionY(200)
    local turnBurnY = ConvertResolutionY(150)
    local gyroY = ConvertResolutionY(960)
    if isRemote() == 1 and not RemoteHud then
        brakeY = ConvertResolutionY(135)
        gearY = ConvertResolutionY(155)
        hoverY = ConvertResolutionY(175)
        apY = ConvertResolutionY(115)
        turnBurnY = ConvertResolutionY(95)
    end
    if BrakeIsOn then
        newContent[#newContent + 1] = stringf([[<text x="%d" y="%d">Brake Engaged</text>]], warningX, brakeY)
    end
    if inAtmo and stalling and hoverDetectGround() == -1 then
        newContent[#newContent + 1] = stringf([[<text x="%d" y="%d">** STALL WARNING **</text>]], warningX, apY+50)
    end
    if gyroIsOn then
        newContent[#newContent + 1] = stringf([[<text x="%d" y="%d">Gyro Enabled</text>]], warningX, gyroY)
    end
    if GearExtended then
        if hasGear then
            newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Gear Extended</text>]],
                                              warningX, gearY)
        else
            newContent[#newContent + 1] = stringf([[<text x="%d" y="%d">Landed (G: Takeoff)</text>]], warningX,
                                              gearY)
        end
        local displayText, displayUnit = getDistanceDisplayString(Nav:getTargetGroundAltitude())
        newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Hover Height: %s</text>]],
                                          warningX, hoverY,
                                          displayText.. displayUnit)
    end
    if isBoosting then
        newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">ROCKET BOOST ENABLED</text>]],
                                          warningX, ewarpY+20)
    end                  
    if antigrav and not ExternalAGG and antigrav.getState() == 1 and AntigravTargetAltitude ~= nil then
        if math.abs(coreAltitude - antigrav.getBaseAltitude()) < 501 then
            newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">AGG On - Target Altitude: %d Singluarity Altitude: %d</text>]],
                warningX, apY+20, mfloor(AntigravTargetAltitude), mfloor(antigrav.getBaseAltitude()))
        else
            newContent[#newContent + 1] = stringf([[<text x="%d" y="%d">AGG On - Target Altitude: %d Singluarity Altitude: %d</text>]],
                warningX, apY+20, mfloor(AntigravTargetAltitude), mfloor(antigrav.getBaseAltitude()))
        end
    elseif Autopilot and AutopilotTargetName ~= "None" then
        newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Autopilot %s</text>]],
                                          warningX, apY+20, AutopilotStatus)
    elseif LockPitch ~= nil then
        newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">LockedPitch: %d</text>]],
                                            warningX, apY+20, mfloor(LockPitch))
    elseif followMode then
        newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Follow Mode Engaged</text>]],
                                          warningX, apY+20)
    elseif Reentry then
        newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Parachute Re-entry in Progress</text>]],
                                              warningX, apY+20)
    end
    if AltitudeHold then
        if AutoTakeoff then
            local displayText, displayUnit = getDistanceDisplayString(HoldAltitude)
            newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Ascent to %s</text>]],
                                              warningX, apY, displayText.. displayUnit)
            if BrakeIsOn then
                newContent[#newContent + 1] = stringf(
                                                  [[<text class="crit" x="%d" y="%d">Throttle Up and Disengage Brake For Takeoff</text>]],
                                                  warningX, apY + 50)
            end
        else
            local displayText, displayUnit = getDistanceDisplayString2(HoldAltitude)
            newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Altitude Hold: %s</text>]],
                                              warningX, apY, displayText.. displayUnit)
        end
    end
    if BrakeLanding then
        if StrongBrakes then
            newContent[#newContent + 1] = stringf([[<text x="%d" y="%d">Brake-Landing</text>]], warningX, apY)
        else
            newContent[#newContent + 1] = stringf([[<text x="%d" y="%d">Coast-Landing</text>]], warningX, apY)
        end
    end
    if ProgradeIsOn then
        newContent[#newContent + 1] = stringf([[<text class="crit" x="%d" y="%d">Prograde Alignment</text>]],
                                          warningX, apY)
    end
    if RetrogradeIsOn then
        newContent[#newContent + 1] = stringf([[<text class="crit" x="%d" y="%d">Retrograde Alignment</text>]],
                                          warningX, apY)
    end
    if TurnBurn then
        newContent[#newContent + 1] = stringf([[<text class="crit" x="%d" y="%d">Turn & Burn Braking</text>]],
                                          warningX, turnBurnY)
    end
    if VectorToTarget then
        newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">%s</text>]], warningX,
                                          apY+30, VectorStatus)
    end

    newContent[#newContent + 1] = "</g>"
end

function DisplayOrbitScreen(newContent)
    if orbit ~= nil and atmosphere() < 0.2 and planet ~= nil and orbit.apoapsis ~= nil and
        orbit.periapsis ~= nil and orbit.period ~= nil and orbit.apoapsis.speed > 5 and DisplayOrbit then
        -- If orbits are up, let's try drawing a mockup
        local orbitMapX = OrbitMapX
        local orbitMapY = OrbitMapY
        local orbitMapSize = OrbitMapSize -- Always square
        local pad = 4
        orbitMapY = orbitMapY + pad
        local orbitInfoYOffset = 15
        local x = orbitMapX + orbitMapSize + orbitMapX / 2 + pad
        local y = orbitMapY + orbitMapSize / 2 + 5 + pad

        local rx, ry, scale, xOffset
        rx = orbitMapSize / 4
        xOffset = 0

        newContent[#newContent + 1] = [[<g class="pbright txtorb txtmid">]]
        -- Draw a darkened box around it to keep it visible
        newContent[#newContent + 1] = stringf(
                                          '<rect width="%f" height="%d" rx="10" ry="10" x="%d" y="%d" style="fill:rgb(0,0,100);stroke-width:4;stroke:white;fill-opacity:0.3;" />',
                                          orbitMapSize + orbitMapX * 2, orbitMapSize + orbitMapY, pad, pad)

        if orbit.periapsis ~= nil and orbit.apoapsis ~= nil then
            scale = (orbit.apoapsis.altitude + orbit.periapsis.altitude + planet.radius * 2) / (rx * 2)
            ry = (planet.radius + orbit.periapsis.altitude +
                     (orbit.apoapsis.altitude - orbit.periapsis.altitude) / 2) / scale *
                     (1 - orbit.eccentricity)
            xOffset = rx - orbit.periapsis.altitude / scale - planet.radius / scale

            local ellipseColor = ""
            if orbit.periapsis.altitude <= 0 then
                ellipseColor = 'redout'
            end
            newContent[#newContent + 1] = stringf(
                                              [[<ellipse class="%s line" cx="%f" cy="%f" rx="%f" ry="%f"/>]],
                                              ellipseColor, orbitMapX + orbitMapSize / 2 + xOffset + pad,
                                              orbitMapY + orbitMapSize / 2 + pad, rx, ry)
            newContent[#newContent + 1] = stringf(
                                              '<circle cx="%f" cy="%f" r="%f" stroke="white" stroke-width="3" fill="blue" />',
                                              orbitMapX + orbitMapSize / 2 + pad,
                                              orbitMapY + orbitMapSize / 2 + pad, planet.radius / scale)
        end

        if orbit.apoapsis ~= nil and orbit.apoapsis.speed < MaxGameVelocity and orbit.apoapsis.speed > 1 then
            newContent[#newContent + 1] = stringf(
                                              [[<line class="pdim op30 linethick" x1="%f" y1="%f" x2="%f" y2="%f"/>]],
                                              x - 35, y - 5, orbitMapX + orbitMapSize / 2 + rx + xOffset, y - 5)
            newContent[#newContent + 1] = stringf([[<text x="%f" y="%f">Apoapsis</text>]], x, y)
            y = y + orbitInfoYOffset
            local displayText, displayUnit = getDistanceDisplayString(orbit.apoapsis.altitude)
            newContent[#newContent + 1] = stringf([[<text x="%f" y="%f">%s</text>]], x, y,
                                              displayText.. displayUnit)
            y = y + orbitInfoYOffset
            newContent[#newContent + 1] = stringf([[<text x="%f" y="%f">%s</text>]], x, y,
                                              FormatTimeString(orbit.timeToApoapsis))
            y = y + orbitInfoYOffset
            newContent[#newContent + 1] = stringf([[<text x="%f" y="%f">%s</text>]], x, y,
                                              getSpeedDisplayString(orbit.apoapsis.speed))
        end

        y = orbitMapY + orbitMapSize / 2 + 5 + pad
        x = orbitMapX - orbitMapX / 2 + 10 + pad

        if orbit.periapsis ~= nil and orbit.periapsis.speed < MaxGameVelocity and orbit.periapsis.speed > 1 then
            newContent[#newContent + 1] = stringf(
                                              [[<line class="pdim op30 linethick" x1="%f" y1="%f" x2="%f" y2="%f"/>]],
                                              x + 35, y - 5, orbitMapX + orbitMapSize / 2 - rx + xOffset, y - 5)
            newContent[#newContent + 1] = stringf([[<text x="%f" y="%f">Periapsis</text>]], x, y)
            y = y + orbitInfoYOffset
            local displayText, displayUnit = getDistanceDisplayString(orbit.periapsis.altitude)
            newContent[#newContent + 1] = stringf([[<text x="%f" y="%f">%s</text>]], x, y,
                                              displayText.. displayUnit)
            y = y + orbitInfoYOffset
            newContent[#newContent + 1] = stringf([[<text x="%f" y="%f">%s</text>]], x, y,
                                              FormatTimeString(orbit.timeToPeriapsis))
            y = y + orbitInfoYOffset
            newContent[#newContent + 1] = stringf([[<text x="%f" y="%f">%s</text>]], x, y,
                                              getSpeedDisplayString(orbit.periapsis.speed))
        end

        -- Add a label for the planet
        newContent[#newContent + 1] = stringf([[<text class="txtorbbig" x="%f" y="%d">%s</text>]],
                                          orbitMapX + orbitMapSize / 2 + pad, 20 + pad, planet.name)

        if orbit.period ~= nil and orbit.periapsis ~= nil and orbit.apoapsis ~= nil and orbit.apoapsis.speed > 1 then
            local apsisRatio = (orbit.timeToApoapsis / orbit.period) * 2 * math.pi
            -- x = xr * cos(t)
            -- y = yr * sin(t)
            local shipX = rx * math.cos(apsisRatio)
            local shipY = ry * math.sin(apsisRatio)

            newContent[#newContent + 1] = stringf(
                                              '<circle cx="%f" cy="%f" r="5" stroke="white" stroke-width="3" fill="white" />',
                                              orbitMapX + orbitMapSize / 2 + shipX + xOffset + pad,
                                              orbitMapY + orbitMapSize / 2 + shipY + pad)
        end

        newContent[#newContent + 1] = [[</g>]]
        -- Once we have all that, we should probably rotate the entire thing so that the ship is always at the bottom so you can see AP and PE move?

    end
end

function getDistanceDisplayString(distance)
    local su = distance > 100000
    local result, displayUnit = ""
    if su then
        -- Convert to SU
        result, displayUnit = round(distance / 1000 / 200, 1),"SU"
    elseif distance < 1000 then
        result, displayUnit = round(distance, 1),"m"
    else
        -- Convert to KM
        result, displayUnit = round(distance / 1000, 1),"Km"
    end

    return result, displayUnit
end

function getDistanceDisplayString2(distance)
    local su = distance > 100000
    local result, displayUnit = ""
    if su then
        -- Convert to SU
        result, displayUnit = round(distance / 1000 / 200, 2)," SU"
    elseif distance < 1000 then
        result, displayUnit = round(distance, 2)," M"
    else
        -- Convert to KM
        result, displayUnit = round(distance / 1000, 2)," KM"
    end

    return result, displayUnit
end

function getSpeedDisplayString(speed) -- TODO: Allow options, for now just do kph
    return mfloor(round(speed * 3.6, 0) + 0.5) .. " km/h" -- And generally it's not accurate enough to not twitch unless we round 0
end

function FormatTimeString(seconds)
    local minutes = 0
    local hours = 0
    local days = 0
    if seconds < 60 then
        seconds = mfloor(seconds)
    elseif seconds < 3600 then
        minutes = mfloor(seconds / 60)
        seconds = mfloor(seconds % 60) 
    elseif seconds < 86400 then
        hours = mfloor(seconds / 3600)
        minutes = mfloor( (seconds % 3600) / 60)
    else
        days = mfloor ( seconds / 86400)
        hours = mfloor ( (seconds % 86400) / 3600)
    end
    if days > 0 then 
        return days .. "d " .. hours .."h "
    elseif hours > 0 then
        return hours .. "h " .. minutes .. "m "
    elseif minutes > 0 then
        return minutes .. "m " .. seconds .. "s"
    elseif seconds > 0 then 
        return seconds .. "s"
    else
        return "0s"
    end
end

function getMagnitudeInDirection(vector, direction)
    -- return vec3(vector):project_on(vec3(direction)):len()
    vector = vec3(vector)
    direction = vec3(direction):normalize()
    local result = vector * direction -- To preserve sign, just add them I guess
    
    return result.x + result.y + result.z
end

function UpdateAutopilotTarget()
    -- So the indices are weird.  I think we need to do a pairs
    if AutopilotTargetIndex == 0 then
        AutopilotTargetName = "None"
        autopilotTargetPlanet = nil
        return true
    end

    local atlasIndex = AtlasOrdered[AutopilotTargetIndex].index
    local autopilotEntry = atlas[0][atlasIndex]
    if autopilotEntry.center then -- Is a real atlas entry
        AutopilotTargetName = autopilotEntry.name
        autopilotTargetPlanet = galaxyReference[0][atlasIndex]
        if CustomTarget ~= nil then
            if atmosphere() == 0 then
                if system.updateData(widgetMaxBrakeTimeText, widgetMaxBrakeTime) ~= 1 then
                    system.addDataToWidget(widgetMaxBrakeTimeText, widgetMaxBrakeTime) end
                if system.updateData(widgetMaxBrakeDistanceText, widgetMaxBrakeDistance) ~= 1 then
                    system.addDataToWidget(widgetMaxBrakeDistanceText, widgetMaxBrakeDistance) end
                if system.updateData(widgetCurBrakeTimeText, widgetCurBrakeTime) ~= 1 then
                    system.addDataToWidget(widgetCurBrakeTimeText, widgetCurBrakeTime) end
                if system.updateData(widgetCurBrakeDistanceText, widgetCurBrakeDistance) ~= 1 then
                    system.addDataToWidget(widgetCurBrakeDistanceText, widgetCurBrakeDistance) end
                if system.updateData(widgetTrajectoryAltitudeText, widgetTrajectoryAltitude) ~= 1 then
                    system.addDataToWidget(widgetTrajectoryAltitudeText, widgetTrajectoryAltitude) end
                if system.updateData(widgetTargetOrbitText, widgetTargetOrbit) ~= 1 then
                    system.addDataToWidget(widgetTargetOrbitText, widgetTargetOrbit) end
            end
            if system.updateData(widgetMaxMassText, widgetMaxMass) ~= 1 then
                system.addDataToWidget(widgetMaxMassText, widgetMaxMass) end
            if system.updateData(widgetTravelTimeText, widgetTravelTime) ~= 1 then
                system.addDataToWidget(widgetTravelTimeText, widgetTravelTime) end
        end
        CustomTarget = nil
    else
        CustomTarget = autopilotEntry
        for _, v in pairs(galaxyReference[0]) do
            if v.name == CustomTarget.planetname then
                autopilotTargetPlanet = v
                AutopilotTargetName = CustomTarget.name
                break
            end
        end
        if system.updateData(widgetMaxMassText, widgetMaxMass) ~= 1 then
            system.addDataToWidget(widgetMaxMassText, widgetMaxMass) end
        if system.updateData(widgetTravelTimeText, widgetTravelTime) ~= 1 then
            system.addDataToWidget(widgetTravelTimeText, widgetTravelTime) end
    end
    if CustomTarget == nil then
        AutopilotTargetCoords = vec3(autopilotTargetPlanet.center) -- Aim center until we align
    else
        AutopilotTargetCoords = CustomTarget.position
    end
    -- Determine the end speed
    if autopilotTargetPlanet.name ~= "Space" then
        if autopilotTargetPlanet.hasAtmosphere then 
            AutopilotTargetOrbit = math.floor(autopilotTargetPlanet.radius*(TargetOrbitRadius-1) + autopilotTargetPlanet.noAtmosphericDensityAltitude)
        else
            AutopilotTargetOrbit = math.floor(autopilotTargetPlanet.radius*(TargetOrbitRadius-1) + autopilotTargetPlanet.surfaceMaxAltitude)
        end
    else
        AutopilotTargetOrbit = 1000
    end
    if CustomTarget ~= nil and CustomTarget.planetname == "Space" then 
        AutopilotEndSpeed = 0
    else
        _, AutopilotEndSpeed = Kep(autopilotTargetPlanet):escapeAndOrbitalSpeed(AutopilotTargetOrbit)
    end
    AutopilotPlanetGravity = 0 -- This is inaccurate unless we integrate and we're not doing that.  
    AutopilotAccelerating = false
    AutopilotBraking = false
    AutopilotCruising = false
    Autopilot = false
    AutopilotRealigned = false
    AutopilotStatus = "Aligning"
    return true
end

function IncrementAutopilotTargetIndex()
    AutopilotTargetIndex = AutopilotTargetIndex + 1
    -- if AutopilotTargetIndex > tablelength(atlas[0]) then
    if AutopilotTargetIndex > #AtlasOrdered then
        AutopilotTargetIndex = 0
    end
    UpdateAutopilotTarget()
end

function DecrementAutopilotTargetIndex()
    AutopilotTargetIndex = AutopilotTargetIndex - 1
        
    if AutopilotTargetIndex < 0 then
    --    AutopilotTargetIndex = tablelength(atlas[0])
        AutopilotTargetIndex = #AtlasOrdered
    end        
    UpdateAutopilotTarget()
end

function GetAutopilotMaxMass()
    local apmaxmass = LastMaxBrakeInAtmo /
                          (autopilotTargetPlanet:getGravity(
                              autopilotTargetPlanet.center + (vec3(0, 0, 1) * autopilotTargetPlanet.radius))
                              :len())
    return apmaxmass
end

function GetAutopilotTravelTime()
    if not Autopilot then
        if CustomTarget == nil or CustomTarget.planetname ~= planet.name then
            AutopilotDistance = (autopilotTargetPlanet.center - vec3(core.getConstructWorldPos())):len() -- This updates elsewhere if we're already piloting
        else
            AutopilotDistance = (CustomTarget.position - vec3(core.getConstructWorldPos())):len()
        end
    end
    local velocity = core.getWorldVelocity()
    local speed = vec3(velocity):len()
    local accelDistance, accelTime =
        Kinematic.computeDistanceAndTime(vec3(velocity):len(), MaxGameVelocity, -- From currently velocity to max
            constructMass(), Nav:maxForceForward(), warmup, -- T50?  Assume none, negligible for this
            0) -- Brake thrust, none for this
    -- accelDistance now has the amount of distance for which we will be accelerating
    -- Then we need the distance we'd brake from full speed
    -- Note that for some nearby moons etc, it may never reach full speed though.
    local brakeDistance, brakeTime
    if not TurnBurn then
        brakeDistance, brakeTime = GetAutopilotBrakeDistanceAndTime(MaxGameVelocity)
    else
        brakeDistance, brakeTime = GetAutopilotTBBrakeDistanceAndTime(MaxGameVelocity)
    end
    local _, curBrakeTime
    if not TurnBurn then
        _, curBrakeTime = GetAutopilotBrakeDistanceAndTime(speed)
    else
        _, curBrakeTime = GetAutopilotTBBrakeDistanceAndTime(speed)
    end
    local cruiseDistance = 0
    local cruiseTime = 0
    -- So, time is in seconds
    -- If cruising or braking, use real cruise/brake values
    if AutopilotCruising or (not Autopilot and speed > 5) then -- If already cruising, use current speed
        cruiseTime = Kinematic.computeTravelTime(speed, 0, AutopilotDistance)
    elseif brakeDistance + accelDistance < AutopilotDistance then
        -- Add any remaining distance
        cruiseDistance = AutopilotDistance - (brakeDistance + accelDistance)
        cruiseTime = Kinematic.computeTravelTime(8333.0556, 0, cruiseDistance)
    else
        local accelRatio = (AutopilotDistance - brakeDistance) / accelDistance
        accelDistance = AutopilotDistance - brakeDistance -- Accel until we brake
        
        accelTime = accelTime * accelRatio
    end
    if CustomTarget ~= nil and CustomTarget.planetname == planet.name and not Autopilot then
        return cruiseTime
    elseif AutopilotBraking then
        return curBrakeTime
    elseif AutopilotCruising then
        return cruiseTime + curBrakeTime
    else -- If not cruising or braking, assume we'll get to max speed
        return accelTime + brakeTime + cruiseTime
    end
end

function GetAutopilotBrakeDistanceAndTime(speed)
    -- If we're in atmo, just return some 0's or LastMaxBrake, whatever's bigger
    -- So we don't do unnecessary API calls when atmo brakes don't tell us what we want
    if not inAtmo then
        RefreshLastMaxBrake()
        return Kinematic.computeDistanceAndTime(speed, AutopilotEndSpeed, constructMass(), 0, 0,
                   LastMaxBrake - (AutopilotPlanetGravity * constructMass()))
    else
        if LastMaxBrakeInAtmo and LastMaxBrakeInAtmo > 0 then
            return Kinematic.computeDistanceAndTime(speed, AutopilotEndSpeed, constructMass(), 0, 0,
                       LastMaxBrakeInAtmo - (AutopilotPlanetGravity * constructMass()))
        else
            return 0, 0
        end
    end
end

function GetAutopilotTBBrakeDistanceAndTime(speed) -- Uses thrust and a configured T50
    RefreshLastMaxBrake()
    return Kinematic.computeDistanceAndTime(speed, AutopilotEndSpeed, constructMass(), Nav:maxForceForward(),
               warmup, LastMaxBrake - (AutopilotPlanetGravity * constructMass()))
end

function hoverDetectGround()
    local vgroundDistance = -1
    local hgroundDistance = -1
    if vBooster then
        vgroundDistance = vBooster.distance()
    end
    if hover then
        hgroundDistance = hover.distance()
    end
    if vgroundDistance ~= -1 and hgroundDistance ~= -1 then
        if vgroundDistance < hgroundDistance then
            return vgroundDistance
        else
            return hgroundDistance
        end
    elseif vgroundDistance ~= -1 then
        return vgroundDistance
    elseif hgroundDistance ~= -1 then
        return hgroundDistance
    else
        return -1
    end
end            

function AboveGroundLevel()
    local groundDistance = -1
    local hgroundDet = hoverDetectGround()
    if telemeter_1 then 
        groundDistance = telemeter_1.getDistance()
    end
    if hgroundDet ~= -1 and groundDistance ~= -1 then
        if hgroundDet < groundDistance then 
            return hgroundDet 
        else
            return groundDistance
        end
    elseif hgroundDet ~= -1 then
        return hgroundDet
    else
        return groundDistance
    end
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

function BeginProfile(profileName)
    ProfileTimeStart = system.getTime()
end

function EndProfile(profileName)
    local profileTime = system.getTime() - ProfileTimeStart
    ProfileTimeSum = ProfileTimeSum + profileTime
    ProfileCount = ProfileCount + 1
    if profileTime > ProfileTimeMax then
        ProfileTimeMax = profileTime
    end

    if profileTime < ProfileTimeMin then
        ProfileTimeMin = profileTime
    end
end

function ResetProfiles()
    ProfileTimeMin = 9999
    ProfileTimeMax = 0
    ProfileCount = 0
    ProfileTimeSum = 0
end

function ReportProfiling()
    local totalTime = ProfileTimeSum
    local averageTime = ProfileTimeSum / ProfileCount
    local min = ProfileTimeMin
    local max = ProfileTimeMax
    local samples = ProfileCount
    sprint(stringf("SUM: %.4f AVG: %.4f MIN: %.4f MAX: %.4f CNT: %d", totalTime, averageTime, min,
                     max, samples))
end

function updateWeapons()
    if weapon then
        if  WeaponPanelID==nil and (radarPanelID ~= nil or GearExtended)  then
            _autoconf.displayCategoryPanel(weapon, weapon_size, L_TEXT("ui_lua_widget_weapon", "Weapons"), "weapon", true)
            WeaponPanelID = _autoconf.panels[_autoconf.panels_size]
        elseif WeaponPanelID ~= nil and radarPanelID == nil and not GearExtended then
            system.destroyWidgetPanel(WeaponPanelID)
            WeaponPanelID = nil
        end
    end
end

function updateRadar()
    if (radar_1) then
        local radarContacts = radar_1.getEntries()
        local radarData = radar_1.getData()
        local radarX = ConvertResolutionX(1770)
        local radarY = ConvertResolutionY(330)
        if #radarContacts > 0 then
            local target = radarData:find('identifiedConstructs":%[%]')
            if target == nil and perisPanelID == nil then
                peris = 1
                ToggleRadarPanel()
            end
            if target ~= nil and perisPanelID ~= nil then
                ToggleRadarPanel()
            end
            if radarPanelID == nil then
                ToggleRadarPanel()
            end
            radarMessage = stringf(
                            [[<text class="pbright txtbig txtmid" x="%d" y="%d">Radar: %i contacts</text>]],
                            radarX, radarY, #radarContacts)
            local friendlies = {}
            for k, v in pairs(radarContacts) do
                if radar_1.hasMatchingTransponder(v) == 1 then
                    table.insert(friendlies,v)
                end
            end
            if #friendlies > 0 then
                local y = ConvertResolutionY(15)
                local x = ConvertResolutionX(1370)
                radarMessage = stringf(
                                [[%s<text class="pbright txtbig txtmid" x="%d" y="%d">Friendlies In Range</text>]],
                                radarMessage, x, y)
                for k, v in pairs(friendlies) do
                    y = y + 20
                    radarMessage = stringf([[%s<text class="pdim txtmid" x="%d" y="%d">%s</text>]],
                                    radarMessage, x, y, radar_1.getConstructName(v))
                end
            end
        else
            local data
            data = radarData:find('worksInEnvironment":false')
            if data then
                radarMessage = stringf([[
                    <text class="pbright txtbig txtmid" x="%d" y="%d">Radar: Jammed</text>]],
                    radarX, radarY)
            else
                radarMessage = stringf([[
                    <text class="pbright txtbig txtmid" x="%d" y="%d">Radar: No Contacts</text>]],
                    radarX, radarY)
            end
            if radarPanelID ~= nil then
                peris = 0
                ToggleRadarPanel()
            end
        end
    end
end

function DisplayMessage(newContent, displayText)
    if displayText ~= "empty" then
        newContent[#newContent + 1] = [[<text class="msg" x="50%%" y="310" >]]
        for str in string.gmatch(displayText, "([^\n]+)") do
            newContent[#newContent + 1] = stringf([[<tspan x="50%%" dy="35">%s</tspan>]], str)
        end
        newContent[#newContent + 1] = [[</text>]]
    end
    if msgTimer ~= 0 then
        unit.setTimer("msgTick", msgTimer)
        msgTimer = 0
    end
end

function updateDistance()
    local curTime = system.getTime()
    local velocity = vec3(core.getWorldVelocity())
    local spd = vec3(velocity):len()
    local elapsedTime = curTime - lastTravelTime
    if (spd > 1.38889) then
        spd = spd / 1000
        local newDistance = spd * (curTime - lastTravelTime)
        TotalDistanceTravelled = TotalDistanceTravelled + newDistance
        totalDistanceTrip = totalDistanceTrip + newDistance
    end
    flightTime = flightTime + elapsedTime
    TotalFlightTime = TotalFlightTime + elapsedTime
    lastTravelTime = curTime
end

-- Planet Info - https://gitlab.com/JayleBreak/dualuniverse/-/tree/master/DUflightfiles/autoconf/custom with minor modifications
function Atlas()
    return {
        [0] = {
            [0] = {
                GM = 0,
                bodyId = 0,
                center = {
                    x = 0,
                    y = 0,
                    z = 0
                },
                name = 'Space',
                planetarySystemId = 0,
                radius = 0,
                hasAtmosphere = false,
                gravity = 0
            },
            [2] = {
                name = "Alioth",
                description = "Alioth is the planet selected by the arkship for landfall; it is a typical goldilocks planet where humanity may rebuild in the coming decades. The arkship geological survey reports mountainous regions alongside deep seas and lush forests. This is where it all starts.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.9401,
                atmosphericEngineMaxAltitude = 5580,
                biosphere = "Forest",
                classification = "Mesoplanet",
                bodyId = 2,
                GM = 157470826617,
                gravity = 1.0082568597356114,
                fullAtmosphericDensityMaxAltitude = -10,
                habitability = "High",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 6272,
                numSatellites = 2,
                positionFromSun = 2,
                center = {
                    x = -8,
                    y = -8,
                    z = -126303
                },
                radius = 126067.8984375,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 3410,
                surfaceArea = 199718780928,
                surfaceAverageAltitude = 200,
                surfaceMaxAltitude = 1100,
                surfaceMinAltitude = -330,
                systemZone = "High",
                territories = 259472,
                type = "Planet",
                waterLevel = 0,
                planetarySystemId = 0
            },
            [21] = {
                name = "Alioth Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 21,
                GM = 2118960000,
                gravity = 0.24006116402380084,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 457933,
                    y = -1509011,
                    z = 115524
                },
                radius = 30000,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 0,
                surfaceArea = 11309733888,
                surfaceAverageAltitude = 140,
                surfaceMaxAltitude = 200,
                surfaceMinAltitude = 10,
                systemZone = nil,
                territories = 14522,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [22] = {
                name = "Alioth Moon 4",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 22,
                GM = 2165833514,
                gravity = 0.2427018259886451,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = -1692694,
                    y = 729681,
                    z = -411464
                },
                radius = 30330,
                safeAreaEdgeAltitude = 500000,
                size = "L",
                spaceEngineMinAltitude = 0,
                surfaceArea = 11559916544,
                surfaceAverageAltitude = -15,
                surfaceMaxAltitude = -5,
                surfaceMinAltitude = -50,
                systemZone = nil,
                territories = 14522,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [5] = {
                name = "Feli",
                description = "Feli is easily identified by its massive and deep crater. Outside of the crater, the arkship geological survey reports a fairly bland and uniform planet, it also cannot explain the existence of the crater. Feli is particular for having an extremely small atmosphere, allowing life to develop in the deeper areas of its crater but limiting it drastically on the actual surface.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.5488,
                atmosphericEngineMaxAltitude = 66725,
                biosphere = "Barren",
                classification = "Mesoplanet",
                bodyId = 5,
                GM = 16951680000,
                gravity = 0.4801223280476017,
                fullAtmosphericDensityMaxAltitude = 30,
                habitability = "Low",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 78500,
                numSatellites = 1,
                positionFromSun = 5,
                center = {
                    x = -43534464,
                    y = 22565536,
                    z = -48934464
                },
                radius = 41800,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 42800,
                surfaceArea = 21956466688,
                surfaceAverageAltitude = 18300,
                surfaceMaxAltitude = 18500,
                surfaceMinAltitude = 46,
                systemZone = "Low",
                territories = 27002,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [50] = {
                name = "Feli Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 50,
                GM = 499917600,
                gravity = 0.11202853997062348,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = -43902841.78,
                    y = 22261034.7,
                    z = -48862386
                },
                radius = 14000,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2463008768,
                surfaceAverageAltitude = 800,
                surfaceMaxAltitude = 900,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 3002,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [120] = {
                name = "Ion",
                description = "Ion is nothing more than an oversized ice cube frozen through and through. It is a largely inhospitable planet due to its extremely low temperatures. The arkship geological survey reports extremely rough mountainous terrain with little habitable land.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.9522,
                atmosphericEngineMaxAltitude = 10480,
                biosphere = "Ice",
                classification = "Hypopsychroplanet",
                bodyId = 120,
                GM = 7135606629,
                gravity = 0.36009174603570127,
                fullAtmosphericDensityMaxAltitude = -30,
                habitability = "Average",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 17700,
                numSatellites = 2,
                positionFromSun = 12,
                center = {
                    x = 2865536.7,
                    y = -99034464,
                    z = -934462.02
                },
                radius = 44950,
                safeAreaEdgeAltitude = 500000,
                size = "XS",
                spaceEngineMinAltitude = 6410,
                surfaceArea = 25390383104,
                surfaceAverageAltitude = 500,
                surfaceMaxAltitude = 1300,
                surfaceMinAltitude = 250,
                systemZone = "Average",
                territories = 32672,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [121] = {
                name = "Ion Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 121,
                GM = 106830900,
                gravity = 0.08802242599860607,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 2472916.8,
                    y = -99133747,
                    z = -1133582.8
                },
                radius = 11000,
                safeAreaEdgeAltitude = 500000,
                size = "XS",
                spaceEngineMinAltitude = 0,
                surfaceArea = 1520530944,
                surfaceAverageAltitude = 100,
                surfaceMaxAltitude = 200,
                surfaceMinAltitude = 3,
                systemZone = nil,
                territories = 1922,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [122] = {
                name = "Ion Moon 2",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 122,
                GM = 176580000,
                gravity = 0.12003058201190042,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 2995424.5,
                    y = -99275010,
                    z = -1378480.7
                },
                radius = 15000,
                safeAreaEdgeAltitude = 500000,
                size = "XS",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2827433472,
                surfaceAverageAltitude = -1900,
                surfaceMaxAltitude = -1400,
                surfaceMinAltitude = -2100,
                systemZone = nil,
                territories = 3632,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [9] = {
                name = "Jago",
                description = "Jago is a water planet. The large majority of the planet&apos;s surface is covered by large oceans dotted by small areas of landmass across the planet. The arkship geological survey reports deep seas across the majority of the planet with sub 15 percent coverage of solid ground.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.9835,
                atmosphericEngineMaxAltitude = 9695,
                biosphere = "Water",
                classification = "Mesoplanet",
                bodyId = 9,
                GM = 18606274330,
                gravity = 0.5041284298678057,
                fullAtmosphericDensityMaxAltitude = -90,
                habitability = "Very High",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 10900,
                numSatellites = 0,
                positionFromSun = 9,
                center = {
                    x = -94134462,
                    y = 12765534,
                    z = -3634464
                },
                radius = 61590,
                safeAreaEdgeAltitude = 500000,
                size = "XL",
                spaceEngineMinAltitude = 5900,
                surfaceArea = 47668367360,
                surfaceAverageAltitude = 0,
                surfaceMaxAltitude = 1200,
                surfaceMinAltitude = -500,
                systemZone = "Very High",
                territories = 60752,
                type = "Planet",
                waterLevel = 0,
                planetarySystemId = 0
            },
            [100] = {
                name = "Lacobus",
                description = "Lacobus is an ice planet that also features large bodies of water. The arkship geological survey reports deep oceans alongside a frozen and rough mountainous environment. Lacobus seems to feature regional geothermal activity allowing for the presence of water on the surface.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.7571,
                atmosphericEngineMaxAltitude = 11120,
                biosphere = "Ice",
                classification = "Psychroplanet",
                bodyId = 100,
                GM = 13975172474,
                gravity = 0.45611622622739767,
                fullAtmosphericDensityMaxAltitude = -20,
                habitability = "Average",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 12510,
                numSatellites = 3,
                positionFromSun = 10,
                center = {
                    x = 98865536,
                    y = -13534464,
                    z = -934461.99
                },
                radius = 55650,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 6790,
                surfaceArea = 38917074944,
                surfaceAverageAltitude = 800,
                surfaceMaxAltitude = 1660,
                surfaceMinAltitude = 250,
                systemZone = "Average",
                territories = 50432,
                type = "Planet",
                waterLevel = 0,
                planetarySystemId = 0
            },
            [102] = {
                name = "Lacobus Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 102,
                GM = 444981600,
                gravity = 0.14403669598391783,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 99180968,
                    y = -13783862,
                    z = -926156.4
                },
                radius = 18000,
                safeAreaEdgeAltitude = 500000,
                size = "XL",
                spaceEngineMinAltitude = 0,
                surfaceArea = 4071504128,
                surfaceAverageAltitude = 150,
                surfaceMaxAltitude = 300,
                surfaceMinAltitude = 10,
                systemZone = nil,
                territories = 5072,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [103] = {
                name = "Lacobus Moon 2",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 103,
                GM = 211503600,
                gravity = 0.11202853997062348,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 99250052,
                    y = -13629215,
                    z = -1059341.4
                },
                radius = 14000,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2463008768,
                surfaceAverageAltitude = -1380,
                surfaceMaxAltitude = -1280,
                surfaceMinAltitude = -1880,
                systemZone = nil,
                territories = 3002,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [101] = {
                name = "Lacobus Moon 3",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 101,
                GM = 264870000,
                gravity = 0.12003058201190042,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 98905288.17,
                    y = -13950921.1,
                    z = -647589.53
                },
                radius = 15000,
                safeAreaEdgeAltitude = 500000,
                size = "L",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2827433472,
                surfaceAverageAltitude = 500,
                surfaceMaxAltitude = 820,
                surfaceMinAltitude = 3,
                systemZone = nil,
                territories = 3632,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [1] = {
                name = "Madis",
                description = "Madis is a barren wasteland of a rock; it sits closest to the sun and temperatures reach extreme highs during the day. The arkship geological survey reports long rocky valleys intermittently separated by small ravines.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.8629,
                atmosphericEngineMaxAltitude = 7165,
                biosphere = "Barren",
                classification = "hyperthermoplanet",
                bodyId = 1,
                GM = 6930729684,
                gravity = 0.36009174603570127,
                fullAtmosphericDensityMaxAltitude = 220,
                habitability = "Low",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 8050,
                numSatellites = 3,
                positionFromSun = 1,
                center = {
                    x = 17465536,
                    y = 22665536,
                    z = -34464
                },
                radius = 44300,
                safeAreaEdgeAltitude = 500000,
                size = "XS",
                spaceEngineMinAltitude = 4480,
                surfaceArea = 24661377024,
                surfaceAverageAltitude = 750,
                surfaceMaxAltitude = 850,
                surfaceMinAltitude = 670,
                systemZone = "Low",
                territories = 30722,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [10] = {
                name = "Madis Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 10,
                GM = 78480000,
                gravity = 0.08002039003323584,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 17448118.224,
                    y = 22966846.286,
                    z = 143078.82
                },
                radius = 10000,
                safeAreaEdgeAltitude = 500000,
                size = "XL",
                spaceEngineMinAltitude = 0,
                surfaceArea = 1256637056,
                surfaceAverageAltitude = 210,
                surfaceMaxAltitude = 420,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 1472,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [11] = {
                name = "Madis Moon 2",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 11,
                GM = 237402000,
                gravity = 0.09602446196397631,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 17194626,
                    y = 22243633.88,
                    z = -214962.81
                },
                radius = 12000,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 0,
                surfaceArea = 1809557376,
                surfaceAverageAltitude = -700,
                surfaceMaxAltitude = 300,
                surfaceMinAltitude = -2900,
                systemZone = nil,
                territories = 1922,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [12] = {
                name = "Madis Moon 3",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 12,
                GM = 265046609,
                gravity = 0.12003058201190042,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 17520614,
                    y = 22184730,
                    z = -309989.99
                },
                radius = 15000,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2827433472,
                surfaceAverageAltitude = 700,
                surfaceMaxAltitude = 1100,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 3632,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [26] = {
                name = "Sanctuary",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.9666,
                atmosphericEngineMaxAltitude = 6935,
                biosphere = "",
                classification = "",
                bodyId = 26,
                GM = 68234043600,
                gravity = 1.0000000427743831,
                fullAtmosphericDensityMaxAltitude = -30,
                habitability = "",
                hasAtmosphere = true,
                isSanctuary = true,
                noAtmosphericDensityAltitude = 7800,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = -1404835,
                    y = 562655,
                    z = -285074
                },
                radius = 83400,
                safeAreaEdgeAltitude = 0,
                size = "L",
                spaceEngineMinAltitude = 4230,
                surfaceArea = 87406149632,
                surfaceAverageAltitude = 80,
                surfaceMaxAltitude = 500,
                surfaceMinAltitude = -60,
                systemZone = nil,
                territories = 111632,
                type = "",
                waterLevel = 0,
                planetarySystemId = 0
            },
            [6] = {
                name = "Sicari",
                description = "Sicari is a typical desert planet; it has survived for millenniums and will continue to endure. While not the most habitable of environments it remains a relatively untouched and livable planet of the Alioth sector. The arkship geological survey reports large flatlands alongside steep plateaus.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.897,
                atmosphericEngineMaxAltitude = 7725,
                biosphere = "Desert",
                classification = "Mesoplanet",
                bodyId = 6,
                GM = 10502547741,
                gravity = 0.4081039739797361,
                fullAtmosphericDensityMaxAltitude = -625,
                habitability = "Average",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 8770,
                numSatellites = 0,
                positionFromSun = 6,
                center = {
                    x = 52765536,
                    y = 27165538,
                    z = 52065535
                },
                radius = 51100,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 4480,
                surfaceArea = 32813432832,
                surfaceAverageAltitude = 130,
                surfaceMaxAltitude = 220,
                surfaceMinAltitude = 50,
                systemZone = "Average",
                territories = 41072,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [7] = {
                name = "Sinnen",
                description = "Sinnen is a an empty and rocky hell. With no atmosphere to speak of it is one of the least hospitable planets in the sector. The arkship geological survey reports mostly flatlands alongside deep ravines which look to have once been riverbeds. This planet simply looks to have dried up and died, likely from solar winds.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.9226,
                atmosphericEngineMaxAltitude = 10335,
                biosphere = "Desert",
                classification = "Mesoplanet",
                bodyId = 7,
                GM = 13033380591,
                gravity = 0.4401121421448438,
                fullAtmosphericDensityMaxAltitude = -120,
                habitability = "Average",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 11620,
                numSatellites = 1,
                positionFromSun = 7,
                center = {
                    x = 58665538,
                    y = 29665535,
                    z = 58165535
                },
                radius = 54950,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 6270,
                surfaceArea = 37944188928,
                surfaceAverageAltitude = 317,
                surfaceMaxAltitude = 360,
                surfaceMinAltitude = 23,
                systemZone = "Average",
                territories = 48002,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [70] = {
                name = "Sinnen Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 70,
                GM = 396912600,
                gravity = 0.1360346539426409,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 58969616,
                    y = 29797945,
                    z = 57969449
                },
                radius = 17000,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 0,
                surfaceArea = 3631681280,
                surfaceAverageAltitude = -2050,
                surfaceMaxAltitude = -1950,
                surfaceMinAltitude = -2150,
                systemZone = nil,
                territories = 4322,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [110] = {
                name = "Symeon",
                description = "Symeon is an ice planet mysteriously split at the equator by a band of solid desert. Exactly how this phenomenon is possible is unclear but some sort of weather anomaly may be responsible. The arkship geological survey reports a fairly diverse mix of flat-lands alongside mountainous formations.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.9559,
                atmosphericEngineMaxAltitude = 6920,
                biosphere = "Ice, Desert",
                classification = "Hybrid",
                bodyId = 110,
                GM = 9204742375,
                gravity = 0.3920998898971822,
                fullAtmosphericDensityMaxAltitude = -30,
                habitability = "High",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 7800,
                numSatellites = 0,
                positionFromSun = 11,
                center = {
                    x = 14165536,
                    y = -85634465,
                    z = -934464.3
                },
                radius = 49050,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 4230,
                surfaceArea = 30233462784,
                surfaceAverageAltitude = 39,
                surfaceMaxAltitude = 450,
                surfaceMinAltitude = 126,
                systemZone = "High",
                territories = 38882,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [4] = {
                name = "Talemai",
                description = "Talemai is a planet in the final stages of an Ice Age. It seems likely that the planet was thrown into tumult by a cataclysmic volcanic event which resulted in its current state. The arkship geological survey reports large mountainous regions across the entire planet.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.8776,
                atmosphericEngineMaxAltitude = 9685,
                biosphere = "Barren",
                classification = "Psychroplanet",
                bodyId = 4,
                GM = 14893847582,
                gravity = 0.4641182439650478,
                fullAtmosphericDensityMaxAltitude = -78,
                habitability = "Average",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 10890,
                numSatellites = 3,
                positionFromSun = 4,
                center = {
                    x = -13234464,
                    y = 55765536,
                    z = 465536
                },
                radius = 57500,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 5890,
                surfaceArea = 41547563008,
                surfaceAverageAltitude = 580,
                surfaceMaxAltitude = 610,
                surfaceMinAltitude = 520,
                systemZone = "Average",
                territories = 52922,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [42] = {
                name = "Talemai Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 42,
                GM = 264870000,
                gravity = 0.12003058201190042,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = -13058408,
                    y = 55781856,
                    z = 740177.76
                },
                radius = 15000,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2827433472,
                surfaceAverageAltitude = 720,
                surfaceMaxAltitude = 850,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 3632,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [40] = {
                name = "Talemai Moon 2",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 40,
                GM = 141264000,
                gravity = 0.09602446196397631,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = -13503090,
                    y = 55594325,
                    z = 769838.64
                },
                radius = 12000,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 0,
                surfaceArea = 1809557376,
                surfaceAverageAltitude = 250,
                surfaceMaxAltitude = 450,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 1922,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [41] = {
                name = "Talemai Moon 3",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 41,
                GM = 106830900,
                gravity = 0.08802242599860607,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = -12800515,
                    y = 55700259,
                    z = 325207.84
                },
                radius = 11000,
                safeAreaEdgeAltitude = 500000,
                size = "XS",
                spaceEngineMinAltitude = 0,
                surfaceArea = 1520530944,
                surfaceAverageAltitude = 190,
                surfaceMaxAltitude = 400,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 1922,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [8] = {
                name = "Teoma",
                description = "[REDACTED] The arkship geological survey [REDACTED]. This planet should not be here.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.7834,
                atmosphericEngineMaxAltitude = 5580,
                biosphere = "Forest",
                classification = "Mesoplanet",
                bodyId = 8,
                GM = 18477723600,
                gravity = 0.48812434578525177,
                fullAtmosphericDensityMaxAltitude = 15,
                habitability = "High",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 6280,
                numSatellites = 0,
                positionFromSun = 8,
                center = {
                    x = 80865538,
                    y = 54665536,
                    z = -934463.94
                },
                radius = 62000,
                safeAreaEdgeAltitude = 500000,
                size = "L",
                spaceEngineMinAltitude = 3420,
                surfaceArea = 48305131520,
                surfaceAverageAltitude = 700,
                surfaceMaxAltitude = 1100,
                surfaceMinAltitude = -200,
                systemZone = "High",
                territories = 60752,
                type = "Planet",
                waterLevel = 0,
                planetarySystemId = 0
            },
            [3] = {
                name = "Thades",
                description = "Thades is a scorched desert planet. Perhaps it was once teaming with life but now all that remains is ash and dust. The arkship geological survey reports a rocky mountainous planet bisected by a massive unnatural ravine; something happened to this planet.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.03552,
                atmosphericEngineMaxAltitude = 32180,
                biosphere = "Desert",
                classification = "Thermoplanet",
                bodyId = 3,
                GM = 11776905000,
                gravity = 0.49612641213015557,
                fullAtmosphericDensityMaxAltitude = 150,
                habitability = "Low",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 32800,
                numSatellites = 2,
                positionFromSun = 3,
                center = {
                    x = 29165536,
                    y = 10865536,
                    z = 65536
                },
                radius = 49000,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 21400,
                surfaceArea = 30171856896,
                surfaceAverageAltitude = 13640,
                surfaceMaxAltitude = 13690,
                surfaceMinAltitude = 370,
                systemZone = "Low",
                territories = 38882,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [30] = {
                name = "Thades Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 30,
                GM = 211564034,
                gravity = 0.11202853997062348,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 29214402,
                    y = 10907080.695,
                    z = 433858.2
                },
                radius = 14000,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2463008768,
                surfaceAverageAltitude = 60,
                surfaceMaxAltitude = 300,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 3002,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [31] = {
                name = "Thades Moon 2",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 31,
                GM = 264870000,
                gravity = 0.12003058201190042,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 29404193,
                    y = 10432768,
                    z = 19554.131
                },
                radius = 15000,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2827433472,
                surfaceAverageAltitude = 70,
                surfaceMaxAltitude = 350,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 3632,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            }
        }
    }
end

function SetupAtlas()
    atlas = Atlas()
    for k, v in pairs(atlas[0]) do
        if minAtlasX == nil or v.center.x < minAtlasX then
            minAtlasX = v.center.x
        end
        if maxAtlasX == nil or v.center.x > maxAtlasX then
            maxAtlasX = v.center.x
        end
        if minAtlasY == nil or v.center.y < minAtlasY then
            minAtlasY = v.center.y
        end
        if maxAtlasY == nil or v.center.y > maxAtlasY then
            maxAtlasY = v.center.y
        end
    end
    GalaxyMapHTML = "" -- No starting SVG tag so we can add it where we want it
    -- Figure out our scale here... 
    local xRatio = 1.1 * (maxAtlasX - minAtlasX) / 1920 -- Add 10% for padding
    local yRatio = 1.4 * (maxAtlasY - minAtlasY) / 1080 -- Extra so we can get ion back in
    for k, v in pairs(atlas[0]) do
        -- Draw a circle at the scaled coordinates
        local x = 960 + (v.center.x / xRatio)
        local y = 540 + (v.center.y / yRatio)
        GalaxyMapHTML =
            GalaxyMapHTML .. '<circle cx="' .. x .. '" cy="' .. y .. '" r="' .. (v.radius / xRatio) * 30 ..
                '" stroke="white" stroke-width="3" fill="blue" />'
        if not string.match(v.name, "Moon") and not string.match(v.name, "Sanctuary") and not string.match (v.name, "Space") then
            GalaxyMapHTML = GalaxyMapHTML .. "<text x='" .. x .. "' y='" .. y + (v.radius / xRatio) * 30 + 20 ..
                                "' font-size='28' fill=" .. rgb .. " text-anchor='middle' font-family='Montserrat'>" ..
                                v.name .. "</text>"
        end
    end
    -- Draw a 'You Are Here' - face edition
    local pos = vec3(core.getConstructWorldPos())
    local x = 960 + pos.x / xRatio
    local y = 540 + pos.y / yRatio
    GalaxyMapHTML = GalaxyMapHTML .. '<circle cx="' .. x .. '" cy="' .. y ..
                        '" r="5" stroke="white" stroke-width="3" fill="red"/>'
    GalaxyMapHTML = GalaxyMapHTML .. "<text x='" .. x .. "' y='" .. y - 50 ..
                        "' font-size='36' fill='darkred' text-anchor='middle' font-family='Bank' font-weight='bold'>You Are Here</text>"
    GalaxyMapHTML = GalaxyMapHTML .. [[</svg>]]
    MapXRatio = xRatio
    MapYRatio = yRatio
    if screen_2 then
        screen_2.setHTML('<svg width="100%" height="100%" viewBox="0 0 1920 1080">' .. GalaxyMapHTML) -- This is permanent and doesn't change
        -- Draw a 'You Are Here' - screen edition
        local pos = vec3(core.getConstructWorldPos())
        local x = 960 + pos.x / xRatio
        local y = 540 + pos.y / yRatio
        GalaxyMapHTML = '<svg><circle cx="80" cy="80" r="5" stroke="white" stroke-width="3" fill="red"/>'
        GalaxyMapHTML = GalaxyMapHTML .. "<text x='80' y='105' font-size='18' fill=" .. rgb ..
                            " text-anchor='middle' font-family='Montserrat''>You Are Here</text></svg>"
        YouAreHere = screen_2.addContent((x - 80) / 19.20, (y - 80) / 10.80, GalaxyMapHTML)
    end
end

function PlanetRef()
    --[[                    START OF LOCAL IMPLEMENTATION DETAILS             ]]--
    -- Type checks
    local function isNumber(n)
        return type(n) == 'number'
    end
    local function isSNumber(n)
        return type(tonumber(n)) == 'number'
    end
    local function isTable(t)
        return type(t) == 'table'
    end
    local function isString(s)
        return type(s) == 'string'
    end
    local function isVector(v)
        return isTable(v) and isNumber(v.x and v.y and v.z)
    end
    local function isMapPosition(m)
        return isTable(m) and isNumber(m.latitude and m.longitude and m.altitude and m.bodyId and m.systemId)
    end
    -- Constants
    local deg2rad = math.pi / 180
    local rad2deg = 180 / math.pi
    local epsilon = 1e-10
    local num = ' *([+-]?%d+%.?%d*e?[+-]?%d*)'
    local posPattern = '::pos{' .. num .. ',' .. num .. ',' .. num .. ',' .. num .. ',' .. num .. '}'
    -- Utilities
    local utils = require('cpml.utils')
    local vec3 = require('cpml.vec3')
    local clamp = utils.clamp
    local function float_eq(a, b)
        if a == 0 then
            return math.abs(b) < 1e-09
        end
        if b == 0 then
            return math.abs(a) < 1e-09
        end
        return math.abs(a - b) < math.max(math.abs(a), math.abs(b)) * epsilon
    end
    local function formatNumber(n)
        local result = string.gsub(string.reverse(stringf('%.4f', n)), '^0*%.?', '')
        return result == '' and '0' or string.reverse(result)
    end
    local function formatValue(obj)
        if isVector(obj) then
            return stringf('{x=%.3f,y=%.3f,z=%.3f}', obj.x, obj.y, obj.z)
        end
        if isTable(obj) and not getmetatable(obj) then
            local list = {}
            local nxt = next(obj)
            if type(nxt) == 'nil' or nxt == 1 then -- assume this is an array
                list = obj
            else
                for k, v in pairs(obj) do
                    local value = formatValue(v)
                    if type(k) == 'number' then
                        table.insert(list, stringf('[%s]=%s', k, value))
                    else
                        table.insert(list, stringf('%s=%s', k, value))
                    end
                end
            end
            return stringf('{%s}', table.concat(list, ','))
        end
        if isString(obj) then
            return stringf("'%s'", obj:gsub("'", [[\']]))
        end
        return tostring(obj)
    end
    -- CLASSES
    -- BodyParameters: Attributes of planetary bodies (planets and moons)
    local BodyParameters = {}
    BodyParameters.__index = BodyParameters
    BodyParameters.__tostring = function(obj, indent)
        local keys = {}
        for k in pairs(obj) do
            table.insert(keys, k)
        end
        table.sort(keys)
        local list = {}
        for _, k in ipairs(keys) do
            local value = formatValue(obj[k])
            if type(k) == 'number' then
                table.insert(list, stringf('[%s]=%s', k, value))
            else
                table.insert(list, stringf('%s=%s', k, value))
            end
        end
        if indent then
            return stringf('%s%s', indent, table.concat(list, ',\n' .. indent))
        end
        return stringf('{%s}', table.concat(list, ','))
    end
    BodyParameters.__eq = function(lhs, rhs)
        return lhs.planetarySystemId == rhs.planetarySystemId and lhs.bodyId == rhs.bodyId and
                   float_eq(lhs.radius, rhs.radius) and float_eq(lhs.center.x, rhs.center.x) and
                   float_eq(lhs.center.y, rhs.center.y) and float_eq(lhs.center.z, rhs.center.z) and
                   float_eq(lhs.GM, rhs.GM)
    end
    local function mkBodyParameters(systemId, bodyId, radius, worldCoordinates, GM)
        -- 'worldCoordinates' can be either table or vec3
        assert(isSNumber(systemId), 'Argument 1 (planetarySystemId) must be a number:' .. type(systemId))
        assert(isSNumber(bodyId), 'Argument 2 (bodyId) must be a number:' .. type(bodyId))
        assert(isSNumber(radius), 'Argument 3 (radius) must be a number:' .. type(radius))
        assert(isTable(worldCoordinates),
            'Argument 4 (worldCoordinates) must be a array or vec3.' .. type(worldCoordinates))
        assert(isSNumber(GM), 'Argument 5 (GM) must be a number:' .. type(GM))
        return setmetatable({
            planetarySystemId = tonumber(systemId),
            bodyId = tonumber(bodyId),
            radius = tonumber(radius),
            center = vec3(worldCoordinates),
            GM = tonumber(GM)
        }, BodyParameters)
    end
    -- MapPosition: Geographical coordinates of a point on a planetary body.
    local MapPosition = {}
    MapPosition.__index = MapPosition
    MapPosition.__tostring = function(p)
        return stringf('::pos{%d,%d,%s,%s,%s}', p.systemId, p.bodyId, formatNumber(p.latitude * rad2deg),
                   formatNumber(p.longitude * rad2deg), formatNumber(p.altitude))
    end
    MapPosition.__eq = function(lhs, rhs)
        return lhs.bodyId == rhs.bodyId and lhs.systemId == rhs.systemId and
                   float_eq(lhs.latitude, rhs.latitude) and float_eq(lhs.altitude, rhs.altitude) and
                   (float_eq(lhs.longitude, rhs.longitude) or float_eq(lhs.latitude, math.pi / 2) or
                       float_eq(lhs.latitude, -math.pi / 2))
    end
    -- latitude and longitude are in degrees while altitude is in meters
    local function mkMapPosition(overload, bodyId, latitude, longitude, altitude)
        local systemId = overload -- Id or '::pos{...}' string
        
        if isString(overload) and not longitude and not altitude and not bodyId and not latitude then
            systemId, bodyId, latitude, longitude, altitude = string.match(overload, posPattern)
            assert(systemId, 'Argument 1 (position string) is malformed.')
        else
            assert(isSNumber(systemId), 'Argument 1 (systemId) must be a number:' .. type(systemId))
            assert(isSNumber(bodyId), 'Argument 2 (bodyId) must be a number:' .. type(bodyId))
            assert(isSNumber(latitude), 'Argument 3 (latitude) must be in degrees:' .. type(latitude))
            assert(isSNumber(longitude), 'Argument 4 (longitude) must be in degrees:' .. type(longitude))
            assert(isSNumber(altitude), 'Argument 5 (altitude) must be in meters:' .. type(altitude))
        end
        systemId = tonumber(systemId)
        bodyId = tonumber(bodyId)
        latitude = tonumber(latitude)
        longitude = tonumber(longitude)
        altitude = tonumber(altitude)
        if bodyId == 0 then -- this is a hack to represent points in space
            return setmetatable({
                latitude = latitude,
                longitude = longitude,
                altitude = altitude,
                bodyId = bodyId,
                systemId = systemId
            }, MapPosition)
        end
        return setmetatable({
            latitude = deg2rad * clamp(latitude, -90, 90),
            longitude = deg2rad * (longitude % 360),
            altitude = altitude,
            bodyId = bodyId,
            systemId = systemId
        }, MapPosition)
    end
    -- PlanetarySystem - map body IDs to BodyParameters
    local PlanetarySystem = {}
    PlanetarySystem.__index = PlanetarySystem
    PlanetarySystem.__tostring = function(obj, indent)
        local sep = indent and (indent .. '  ')
        local bdylist = {}
        local keys = {}
        for k in pairs(obj) do
            table.insert(keys, k)
        end
        table.sort(keys)
        for _, bi in ipairs(keys) do
            bdy = obj[bi]
            local bdys = BodyParameters.__tostring(bdy, sep)
            if indent then
                table.insert(bdylist, stringf('[%s]={\n%s\n%s}', bi, bdys, indent))
            else
                table.insert(bdylist, stringf('  [%s]=%s', bi, bdys))
            end
        end
        if indent then
            return stringf('\n%s%s%s', indent, table.concat(bdylist, ',\n' .. indent), indent)
        end
        return stringf('{\n%s\n}', table.concat(bdylist, ',\n'))
    end
    local function mkPlanetarySystem(referenceTable)
        local atlas = {}
        local pid
        for _, v in pairs(referenceTable) do
            local id = v.planetarySystemId
            if type(id) ~= 'number' then
                error('Invalid planetary system ID: ' .. tostring(id))
            elseif pid and id ~= pid then
                error('Mismatch planetary system IDs: ' .. id .. ' and ' .. pid)
            end
            local bid = v.bodyId
            if type(bid) ~= 'number' then
                error('Invalid body ID: ' .. tostring(bid))
            elseif atlas[bid] then
                error('Duplicate body ID: ' .. tostring(bid))
            end
            setmetatable(v.center, getmetatable(vec3.unit_x))
            atlas[bid] = setmetatable(v, BodyParameters)
            pid = id
        end
        return setmetatable(atlas, PlanetarySystem)
    end
    -- PlanetaryReference - map planetary system ID to PlanetarySystem
    PlanetaryReference = {}
    local function mkPlanetaryReference(referenceTable)
        return setmetatable({
            galaxyAtlas = referenceTable or {}
        }, PlanetaryReference)
    end
    PlanetaryReference.__index = function(t, i)
        if type(i) == 'number' then
            local system = t.galaxyAtlas[i]
            return mkPlanetarySystem(system)
        end
        return rawget(PlanetaryReference, i)
    end
    PlanetaryReference.__pairs = function(obj)
        return function(t, k)
            local nk, nv = next(t, k)
            return nk, nv and mkPlanetarySystem(nv)
        end, obj.galaxyAtlas, nil
    end
    PlanetaryReference.__tostring = function(obj)
        local pslist = {}
        for _, ps in pairs(obj or {}) do
            local psi = ps:getPlanetarySystemId()
            local pss = PlanetarySystem.__tostring(ps, '    ')
            table.insert(pslist, stringf('  [%s]={%s\n  }', psi, pss))
        end
        return stringf('{\n%s\n}\n', table.concat(pslist, ',\n'))
    end
    PlanetaryReference.BodyParameters = mkBodyParameters
    PlanetaryReference.MapPosition = mkMapPosition
    PlanetaryReference.PlanetarySystem = mkPlanetarySystem
    function PlanetaryReference.createBodyParameters(planetarySystemId, bodyId, surfaceArea, aPosition,
        verticalAtPosition, altitudeAtPosition, gravityAtPosition)
        assert(isSNumber(planetarySystemId),
            'Argument 1 (planetarySystemId) must be a number:' .. type(planetarySystemId))
        assert(isSNumber(bodyId), 'Argument 2 (bodyId) must be a number:' .. type(bodyId))
        assert(isSNumber(surfaceArea), 'Argument 3 (surfaceArea) must be a number:' .. type(surfaceArea))
        assert(isTable(aPosition), 'Argument 4 (aPosition) must be an array or vec3:' .. type(aPosition))
        assert(isTable(verticalAtPosition),
            'Argument 5 (verticalAtPosition) must be an array or vec3:' .. type(verticalAtPosition))
        assert(isSNumber(altitudeAtPosition),
            'Argument 6 (altitude) must be in meters:' .. type(altitudeAtPosition))
        assert(isSNumber(gravityAtPosition),
            'Argument 7 (gravityAtPosition) must be number:' .. type(gravityAtPosition))
        local radius = math.sqrt(surfaceArea / 4 / math.pi)
        local distance = radius + altitudeAtPosition
        local center = vec3(aPosition) + distance * vec3(verticalAtPosition)
        local GM = gravityAtPosition * distance * distance
        return mkBodyParameters(planetarySystemId, bodyId, radius, center, GM)
    end

    PlanetaryReference.isMapPosition = isMapPosition
    function PlanetaryReference:getPlanetarySystem(overload)
        -- if galaxyAtlas then
        if i == nil then i = 0 end
        if nv == nil then nv = 0 end
        local planetarySystemId = overload
        if isMapPosition(overload) then
            planetarySystemId = overload.systemId
        end
        if type(planetarySystemId) == 'number' then
            local system = self.galaxyAtlas[i]
            if system then
                if getmetatable(nv) ~= PlanetarySystem then
                    system = mkPlanetarySystem(system)
                end
                return system
            end
        end
        -- end
        -- return nil
    end

    function PlanetarySystem:castIntersections(origin, direction, sizeCalculator, bodyIds)
        local sizeCalculator = sizeCalculator or function(body)
            return 1.05 * body.radius
        end
        local candidates = {}
        if bodyIds then
            for _, i in ipairs(bodyIds) do
                candidates[i] = self[i]
            end
        else
            bodyIds = {}
            for k, body in pairs(self) do
                table.insert(bodyIds, k)
                candidates[k] = body
            end
        end
        local function compare(b1, b2)
            local v1 = candidates[b1].center - origin
            local v2 = candidates[b2].center - origin
            return v1:len() < v2:len()
        end
        table.sort(bodyIds, compare)
        local dir = direction:normalize()
        for i, id in ipairs(bodyIds) do
            local body = candidates[id]
            local c_oV3 = body.center - origin
            local radius = sizeCalculator(body)
            local dot = c_oV3:dot(dir)
            local desc = dot ^ 2 - (c_oV3:len2() - radius ^ 2)
            if desc >= 0 then
                local root = math.sqrt(desc)
                local farSide = dot + root
                local nearSide = dot - root
                if nearSide > 0 then
                    return body, farSide, nearSide
                elseif farSide > 0 then
                    return body, farSide, nil
                end
            end
        end
        return nil, nil, nil
    end

    function PlanetarySystem:closestBody(coordinates)
        assert(type(coordinates) == 'table', 'Invalid coordinates.')
        local minDistance2, body
        local coord = vec3(coordinates)
        for _, params in pairs(self) do
            local distance2 = (params.center - coord):len2()
            if (not body or distance2 < minDistance2) and params.name ~= "Space" then -- Never return space.  
                body = params
                minDistance2 = distance2
            end
        end
        return body
    end

    function PlanetarySystem:convertToBodyIdAndWorldCoordinates(overload)
        local mapPosition = overload
        if isString(overload) then
            mapPosition = mkMapPosition(overload)
        end
        if mapPosition.bodyId == 0 then
            return 0, vec3(mapPosition.latitude, mapPosition.longitude, mapPosition.altitude)
        end
        local params = self:getBodyParameters(mapPosition)
        if params then
            return mapPosition.bodyId, params:convertToWorldCoordinates(mapPosition)
        end
    end

    function PlanetarySystem:getBodyParameters(overload)
        local bodyId = overload
        if isMapPosition(overload) then
            bodyId = overload.bodyId
        end
        assert(isSNumber(bodyId), 'Argument 1 (bodyId) must be a number:' .. type(bodyId))
        return self[bodyId]
    end

    function PlanetarySystem:getPlanetarySystemId()
        local _, v = next(self)
        return v and v.planetarySystemId
    end

    function BodyParameters:convertToMapPosition(worldCoordinates)
        assert(isTable(worldCoordinates),
            'Argument 1 (worldCoordinates) must be an array or vec3:' .. type(worldCoordinates))
        local worldVec = vec3(worldCoordinates)
        if self.bodyId == 0 then
            return setmetatable({
                latitude = worldVec.x,
                longitude = worldVec.y,
                altitude = worldVec.z,
                bodyId = 0,
                systemId = self.planetarySystemId
            }, MapPosition)
        end
        local coords = worldVec - self.center
        local distance = coords:len()
        local altitude = distance - self.radius
        local latitude = 0
        local longitude = 0
        if not float_eq(distance, 0) then
            local phi = math.atan(coords.y, coords.x)
            longitude = phi >= 0 and phi or (2 * math.pi + phi)
            latitude = math.pi / 2 - math.acos(coords.z / distance)
        end
        return setmetatable({
            latitude = latitude,
            longitude = longitude,
            altitude = altitude,
            bodyId = self.bodyId,
            systemId = self.planetarySystemId
        }, MapPosition)
    end

    function BodyParameters:convertToWorldCoordinates(overload)
        local mapPosition = isString(overload) and mkMapPosition(overload) or overload
        if mapPosition.bodyId == 0 then -- support deep space map position
            return vec3(mapPosition.latitude, mapPosition.longitude, mapPosition.altitude)
        end
        assert(isMapPosition(mapPosition), 'Argument 1 (mapPosition) is not an instance of "MapPosition".')
        assert(mapPosition.systemId == self.planetarySystemId,
            'Argument 1 (mapPosition) has a different planetary system ID.')
        assert(mapPosition.bodyId == self.bodyId, 'Argument 1 (mapPosition) has a different planetary body ID.')
        local xproj = math.cos(mapPosition.latitude)
        return self.center + (self.radius + mapPosition.altitude) *
                   vec3(xproj * math.cos(mapPosition.longitude), xproj * math.sin(mapPosition.longitude),
                       math.sin(mapPosition.latitude))
    end

    function BodyParameters:getAltitude(worldCoordinates)
        return (vec3(worldCoordinates) - self.center):len() - self.radius
    end

    function BodyParameters:getDistance(worldCoordinates)
        return (vec3(worldCoordinates) - self.center):len()
    end

    function BodyParameters:getGravity(worldCoordinates)
        local radial = self.center - vec3(worldCoordinates) -- directed towards body
        local len2 = radial:len2()
        return (self.GM / len2) * radial / math.sqrt(len2)
    end
    -- end of module
    return setmetatable(PlanetaryReference, {
        __call = function(_, ...)
            return mkPlanetaryReference(...)
        end
    })
end

function Keplers()
    local vec3 = require('cpml.vec3')
    local PlanetRef = PlanetRef()
    local function isString(s)
        return type(s) == 'string'
    end
    local function isTable(t)
        return type(t) == 'table'
    end
    local function float_eq(a, b)
        if a == 0 then
            return math.abs(b) < 1e-09
        end
        if b == 0 then
            return math.abs(a) < 1e-09
        end
        return math.abs(a - b) < math.max(math.abs(a), math.abs(b)) * constants.epsilon
    end
    Kepler = {}
    Kepler.__index = Kepler

    function Kepler:escapeAndOrbitalSpeed(altitude)
        assert(self.body)
        -- P = -GMm/r and KE = mv^2/2 (no lorentz factor used)
        -- mv^2/2 = GMm/r
        -- v^2 = 2GM/r
        -- v = sqrt(2GM/r1)
        local distance = altitude + self.body.radius
        if not float_eq(distance, 0) then
            local orbit = math.sqrt(self.body.GM / distance)
            return math.sqrt(2) * orbit, orbit
        end
        return nil, nil
    end

    function Kepler:orbitalParameters(overload, velocity)
        assert(self.body)
        assert(isTable(overload) or isString(overload))
        assert(isTable(velocity))
        local pos = (isString(overload) or PlanetRef.isMapPosition(overload)) and
                        self.body:convertToWorldCoordinates(overload) or vec3(overload)
        local v = vec3(velocity)
        local r = pos - self.body.center
        local v2 = v:len2()
        local d = r:len()
        local mu = self.body.GM
        local e = ((v2 - mu / d) * r - r:dot(v) * v) / mu
        local a = mu / (2 * mu / d - v2)
        local ecc = e:len()
        local dir = e:normalize()
        local pd = a * (1 - ecc)
        local ad = a * (1 + ecc)
        local per = pd * dir + self.body.center
        local apo = ecc <= 1 and -ad * dir + self.body.center or nil
        local trm = math.sqrt(a * mu * (1 - ecc * ecc))
        local Period = apo and 2 * math.pi * math.sqrt(a ^ 3 / mu)
        -- These are great and all, but, I need more.
        local trueAnomaly = math.acos((e:dot(r)) / (ecc * d))
        if r:dot(v) < 0 then
            trueAnomaly = -(trueAnomaly - 2 * math.pi)
        end
        -- Apparently... cos(EccentricAnomaly) = (cos(trueAnomaly) + eccentricity)/(1 + eccentricity * cos(trueAnomaly))
        local EccentricAnomaly = math.acos((math.cos(trueAnomaly) + ecc) / (1 + ecc * math.cos(trueAnomaly)))
        -- Then.... apparently if this is below 0, we should add 2pi to it
        -- I think also if it's below 0, we're past the apoapsis?
        local timeTau = EccentricAnomaly
        if timeTau < 0 then
            timeTau = timeTau + 2 * math.pi
        end
        -- So... time since periapsis...
        -- Is apparently easy if you get mean anomly.  t = M/n where n is mean motion, = 2*pi/Period
        local MeanAnomaly = timeTau - ecc * math.sin(timeTau)
        local TimeSincePeriapsis = 0
        local TimeToPeriapsis = 0
        local TimeToApoapsis = 0
        if Period ~= nil then
            TimeSincePeriapsis = MeanAnomaly / (2 * math.pi / Period)
            -- Mean anom is 0 at periapsis, positive before it... and positive after it.
            -- I guess this is why I needed to use timeTau and not EccentricAnomaly here

            TimeToPeriapsis = Period - TimeSincePeriapsis
            TimeToApoapsis = TimeToPeriapsis + Period / 2
            if trueAnomaly - math.pi > 0 then -- TBH I think something's wrong in my formulas because I needed this.
                TimeToPeriapsis = TimeSincePeriapsis
                TimeToApoapsis = TimeToPeriapsis + Period / 2
            end
            if TimeToApoapsis > Period then
                TimeToApoapsis = TimeToApoapsis - Period
            end
        end
        return {
            periapsis = {
                position = per,
                speed = trm / pd,
                circularOrbitSpeed = math.sqrt(mu / pd),
                altitude = pd - self.body.radius
            },
            apoapsis = apo and {
                position = apo,
                speed = trm / ad,
                circularOrbitSpeed = math.sqrt(mu / ad),
                altitude = ad - self.body.radius
            },
            currentVelocity = v,
            currentPosition = pos,
            eccentricity = ecc,
            period = Period,
            eccentricAnomaly = EccentricAnomaly,
            meanAnomaly = MeanAnomaly,
            timeToPeriapsis = TimeToPeriapsis,
            timeToApoapsis = TimeToApoapsis
        }
    end
    local function new(bodyParameters)
        local params = PlanetRef.BodyParameters(bodyParameters.planetarySystemId, bodyParameters.bodyId,
                           bodyParameters.radius, bodyParameters.center, bodyParameters.GM)
        return setmetatable({
            body = params
        }, Kepler)
    end
    return setmetatable(Kepler, {
        __call = function(_, ...)
            return new(...)
        end
    })
end

function Kinematics()

    local Kinematic = {} -- just a namespace
    local C = 30000000 / 3600
    local C2 = C * C
    local ITERATIONS = 100 -- iterations over engine "warm-up" period
    local function lorentz(v)
        return 1 / math.sqrt(1 - v * v / C2)
    end

    function Kinematic.computeAccelerationTime(initial, acceleration, final)
        -- The low speed limit of following is: t=(vf-vi)/a (from: vf=vi+at)
        local k1 = C * math.asin(initial / C)
        return (C * math.asin(final / C) - k1) / acceleration
    end

    function Kinematic.computeDistanceAndTime(initial, final, restMass, thrust, t50, brakeThrust)

        t50 = t50 or 0
        brakeThrust = brakeThrust or 0 -- usually zero when accelerating
        local speedUp = initial <= final
        local a0 = thrust * (speedUp and 1 or -1) / restMass
        local b0 = -brakeThrust / restMass
        local totA = a0 + b0
        if speedUp and totA <= 0 or not speedUp and totA >= 0 then
            return -1, -1 -- no solution
        end
        local distanceToMax, timeToMax = 0, 0

        if a0 ~= 0 and t50 > 0 then

            local k1 = math.asin(initial / C)
            local c1 = math.pi * (a0 / 2 + b0)
            local c2 = a0 * t50
            local c3 = C * math.pi
            local v = function(t)
                local w = (c1 * t - c2 * math.sin(math.pi * t / 2 / t50) + c3 * k1) / c3
                local tan = math.tan(w)
                return C * tan / math.sqrt(tan * tan + 1)
            end
            local speedchk = speedUp and function(s)
                return s >= final
            end or function(s)
                return s <= final
            end
            timeToMax = 2 * t50
            if speedchk(v(timeToMax)) then
                local lasttime = 0
                while math.abs(timeToMax - lasttime) > 0.5 do
                    local t = (timeToMax + lasttime) / 2
                    if speedchk(v(t)) then
                        timeToMax = t
                    else
                        lasttime = t
                    end
                end
            end
            -- There is no closed form solution for distance in this case.
            -- Numerically integrate for time t=0 to t=2*T50 (or less)
            local lastv = initial
            local tinc = timeToMax / ITERATIONS
            for step = 1, ITERATIONS do
                local speed = v(step * tinc)
                distanceToMax = distanceToMax + (speed + lastv) * tinc / 2
                lastv = speed
            end
            if timeToMax < 2 * t50 then
                return distanceToMax, timeToMax
            end
            initial = lastv
        end

        local k1 = C * math.asin(initial / C)
        local time = (C * math.asin(final / C) - k1) / totA
        local k2 = C2 * math.cos(k1 / C) / totA
        local distance = k2 - C2 * math.cos((totA * time + k1) / C) / totA
        return distance + distanceToMax, time + timeToMax
    end

    function Kinematic.computeTravelTime(initial, acceleration, distance)
        -- The low speed limit of following is: t=(sqrt(2ad+v^2)-v)/a
        -- (from: d=vt+at^2/2)
        if distance == 0 then
            return 0
        end
        -- So then what's with all the weird ass sines and cosines?
        if acceleration > 0 then
            local k1 = C * math.asin(initial / C)
            local k2 = C2 * math.cos(k1 / C) / acceleration
            return (C * math.acos(acceleration * (k2 - distance) / C2) - k1) / acceleration
        end
        assert(initial > 0, 'Acceleration and initial speed are both zero.')
        return distance / initial
    end

    function Kinematic.lorentz(v)
        return lorentz(v)
    end
    return Kinematic
end

-- Start of actual HUD Script. Written by Dimencia and Archaegeo. Optimization and Automation of scripting by ChronosWS  Linked sources where appropriate, most have been modified.
function script.onStart()
    VERSION_NUMBER = 5.11
    SetupComplete = false
    beginSetup = coroutine.create(function()
        Nav.axisCommandManager:setupCustomTargetSpeedRanges(axisCommandId.longitudinal,
            {1000, 5000, 10000, 20000, 30000})

        -- Load Saved Variables
        LoadVariables()
        coroutine.yield() -- Give it some time to breathe before we do the rest

        -- Find elements we care about
        ProcessElements()
        coroutine.yield() -- Give it some time to breathe before we do the rest

        SetupChecks() -- All the if-thens to set up for particular ship.  Specifically override these with the saved variables if available
        SetupButtons() -- Set up all the pushable buttons.
        coroutine.yield() -- Just to make sure

        -- Set up Jaylebreak and atlas
        SetupAtlas()
        PlanetaryReference = PlanetRef()
        galaxyReference = PlanetaryReference(Atlas())
        Kinematic = Kinematics()
        Kep = Keplers()
        AddLocationsToAtlas()
        UpdateAtlasLocationsList()
        UpdateAutopilotTarget()
        coroutine.yield()

        unit.hide()
        system.showScreen(1)
        -- That was a lot of work with dirty strings and json.  Clean up
        collectgarbage("collect")
        -- Start timers
        coroutine.yield()

        unit.setTimer("apTick", apTickRate)
        unit.setTimer("hudTick", hudTickRate)
        unit.setTimer("oneSecond", 1)
        unit.setTimer("tenthSecond", 1/10)

        if UseSatNav then 
            unit.setTimer("fiveSecond", 5) 
        end

    end)

end

function SaveDataBank(copy)
    if dbHud_1 then
        if not wipedDatabank then
            for k, v in pairs(autoVariables) do
                dbHud_1.setStringValue(v, jencode(_G[v]))
                if copy and dbHud_2 then
                    dbHud_2.setStringValue(v, jencode(_G[v]))
                end
            end
            for k, v in pairs(saveableVariables) do
                dbHud_1.setStringValue(v, jencode(_G[v]))
                if copy and dbHud_2 then
                    dbHud_2.setStringValue(v, jencode(_G[v]))
                end
            end
            sprint("Saved Variables to Datacore")
            if copy and dbHud_2 then
                msgText = "Databank copied.  Remove copy when ready."
            end
        end
    end
end

function script.onStop()
    _autoconf.hideCategoryPanels()
    if antigrav ~= nil  and not ExternalAGG then
        antigrav.hide()
    end
    if warpdrive ~= nil then
        warpdrive.hide()
    end
    core.hide()
    Nav.control.switchOffHeadlights()
    -- Open door and extend ramp if available
    local atmo = atmosphere()
    if door and (atmo > 0 or (atmo == 0 and coreAltitude < 10000)) then
        for _, v in pairs(door) do
            v.toggle()
        end
    end
    if switch then
        for _, v in pairs(switch) do
            v.toggle()
        end
    end
    if forcefield and (atmo > 0 or (atmo == 0 and coreAltitude < 10000)) then
        for _, v in pairs(forcefield) do
            v.toggle()
        end
    end
    SaveDataBank()
    if button then
        button.activate()
    end
end

function script.onTick(timerId)
    if timerId == "tenthSecond" then
        if AutopilotTargetName ~= "None" then
            if panelInterplanetary == nil then
                SetupInterplanetaryPanel()
            end
            if AutopilotTargetName ~= nil then
                local customLocation = CustomTarget ~= nil
                planetMaxMass = GetAutopilotMaxMass()
                system.updateData(interplanetaryHeaderText,
                    '{"label": "Target", "value": "' .. AutopilotTargetName .. '", "unit":""}')
                travelTime = GetAutopilotTravelTime() -- This also sets AutopilotDistance so we don't have to calc it again
                if customLocation then 
                    distance = (vec3(core.getConstructWorldPos()) - CustomTarget.position):len()
                else
                    distance = (AutopilotTargetCoords - vec3(core.getConstructWorldPos())):len() -- Don't show our weird variations
                end
                if not TurnBurn then
                    brakeDistance, brakeTime = GetAutopilotBrakeDistanceAndTime(velMag)
                    maxBrakeDistance, maxBrakeTime = GetAutopilotBrakeDistanceAndTime(MaxGameVelocity)
                else
                    brakeDistance, brakeTime = GetAutopilotTBBrakeDistanceAndTime(velMag)
                    maxBrakeDistance, maxBrakeTime = GetAutopilotTBBrakeDistanceAndTime(MaxGameVelocity)
                end
                local displayText, displayUnit = getDistanceDisplayString(distance)
                system.updateData(widgetDistanceText, '{"label": "distance", "value": "' .. displayText
                     .. '", "unit":"' .. displayUnit .. '"}')
                system.updateData(widgetTravelTimeText, '{"label": "Travel Time", "value": "' ..
                    FormatTimeString(travelTime) .. '", "unit":""}')
                displayText, displayUnit = getDistanceDisplayString(brakeDistance)
                system.updateData(widgetCurBrakeDistanceText, '{"label": "Cur Brake distance", "value": "' ..
                    displayText.. '", "unit":"' .. displayUnit .. '"}')
                system.updateData(widgetCurBrakeTimeText, '{"label": "Cur Brake Time", "value": "' ..
                    FormatTimeString(brakeTime) .. '", "unit":""}')
                displayText, displayUnit = getDistanceDisplayString(maxBrakeDistance)
                system.updateData(widgetMaxBrakeDistanceText, '{"label": "Max Brake distance", "value": "' ..
                    displayText.. '", "unit":"' .. displayUnit .. '"}')
                system.updateData(widgetMaxBrakeTimeText, '{"label": "Max Brake Time", "value": "' ..
                    FormatTimeString(maxBrakeTime) .. '", "unit":""}')
                system.updateData(widgetMaxMassText, '{"label": "Maximum Mass", "value": "' ..
                    stringf("%.2f", (planetMaxMass / 1000)) .. '", "unit":" Tons"}')
                displayText, displayUnit = getDistanceDisplayString(AutopilotTargetOrbit)
                system.updateData(widgetTargetOrbitText, '{"label": "Target Orbit", "value": "' ..
                stringf("%.2f", displayText) .. '", "unit":"' .. displayUnit .. '"}')
                if atmosphere() > 0 and not WasInAtmo then
                    system.removeDataFromWidget(widgetMaxBrakeTimeText, widgetMaxBrakeTime)
                    system.removeDataFromWidget(widgetMaxBrakeDistanceText, widgetMaxBrakeDistance)
                    system.removeDataFromWidget(widgetCurBrakeTimeText, widgetCurBrakeTime)
                    system.removeDataFromWidget(widgetCurBrakeDistanceText, widgetCurBrakeDistance)
                    system.removeDataFromWidget(widgetTrajectoryAltitudeText, widgetTrajectoryAltitude)
                    WasInAtmo = true
                end
                if atmosphere() == 0 and WasInAtmo then
                    if system.updateData(widgetMaxBrakeTimeText, widgetMaxBrakeTime) == 1 then
                        system.addDataToWidget(widgetMaxBrakeTimeText, widgetMaxBrakeTime) end
                    if system.updateData(widgetMaxBrakeDistanceText, widgetMaxBrakeDistance) == 1 then
                        system.addDataToWidget(widgetMaxBrakeDistanceText, widgetMaxBrakeDistance) end
                    if system.updateData(widgetCurBrakeTimeText, widgetCurBrakeTime) == 1 then
                        system.addDataToWidget(widgetCurBrakeTimeText, widgetCurBrakeTime) end
                    if system.updateData(widgetCurBrakeDistanceText, widgetCurBrakeDistance) == 1 then
                        system.addDataToWidget(widgetCurBrakeDistanceText, widgetCurBrakeDistance) end
                    if system.updateData(widgetTrajectoryAltitudeText, widgetTrajectoryAltitude) == 1 then
                        system.addDataToWidget(widgetTrajectoryAltitudeText, widgetTrajectoryAltitude) end
                    WasInAtmo = false
                end
            end
        else
            HideInterplanetaryPanel()
        end
        if warpdrive ~= nil then
            if jdecode(warpdrive.getData()).destination ~= "Unknown" and jdecode(warpdrive.getData()).distance > 400000 then
                warpdrive.show()
                showWarpWidget = true
            else
                warpdrive.hide()
                showWarpWidget = false
            end
        end        
    elseif timerId == "oneSecond" then
        -- Timer for evaluation every 1 second
        clearAllCheck = false
        RefreshLastMaxBrake(nil, true) -- force refresh, in case we took damage
        updateDistance()
        updateRadar()
        updateWeapons()
        -- Update odometer output string
        local newContent = {}
        local flightStyle = GetFlightStyle()
        DrawOdometer(newContent, totalDistanceTrip, TotalDistanceTravelled, flightStyle, flightTime)
        if ShouldCheckDamage then
            CheckDamage(newContent)
        end
        lastOdometerOutput = table.concat(newContent, "")
        collectgarbage("collect")
    elseif timerId == "fiveSecond" then
        -- Support for SatNav by Trog
        myAutopilotTarget = dbHud_1.getStringValue("SPBAutopilotTargetName")
        if myAutopilotTarget ~= nil and myAutopilotTarget ~= "" and myAutopilotTarget ~= "SatNavNotChanged" then
            local result = json.decode(dbHud_1.getStringValue("SavedLocations"))
            if result ~= nil then
                _G["SavedLocations"] = result        
                local index = -1        
                local newLocation        
                for k, v in pairs(SavedLocations) do        
                    if v.name and v.name == "SatNav Location" then                   
                        index = k                
                        break                
                    end            
                end        
                if index ~= -1 then       
                    newLocation = SavedLocations[index]            
                    index = -1            
                    for k, v in pairs(atlas[0]) do           
                        if v.name and v.name == "SatNav Location" then               
                            index = k                    
                            break                  
                        end                
                    end            
                    if index > -1 then           
                        atlas[0][index] = newLocation                
                    end            
                    UpdateAtlasLocationsList()           
                    msgText = newLocation.name .. " position updated"            
                end       
            end

            for i=1,#AtlasOrdered do    
                if AtlasOrdered[i].name == myAutopilotTarget then
                    AutopilotTargetIndex = i
                    system.print("Index = "..AutopilotTargetIndex.." "..AtlasOrdered[i].name)          
                    UpdateAutopilotTarget()
                    dbHud_1.setStringValue("SPBAutopilotTargetName", "SatNavNotChanged")
                    break            
                end     
            end
        end
    elseif timerId == "msgTick" then
        -- This is used to clear a message on screen after a short period of time and then stop itself
        local newContent = {}
        DisplayMessage(newContent, "empty")
        msgText = "empty"
        unit.stopTimer("msgTick")
        msgTimer = 3
    elseif timerId == "animateTick" then
        Animated = true
        Animating = false
        simulatedX = 0
        simulatedY = 0
        unit.stopTimer("animateTick")
    elseif timerId == "hudTick" then

        local newContent = {}
        HUDPrologue(newContent)

        if showHud then
            UpdateHud(newContent) -- sets up Content for us
        else
            DisplayOrbitScreen(newContent)
            DrawWarnings(newContent)
        end

        HUDEpilogue(newContent)

        newContent[#newContent + 1] = stringf(
            [[<svg width="100%%" height="100%%" style="position:absolute;top:0;left:0"  viewBox="0 0 %d %d">]],
            ResolutionX, ResolutionY)   
        if msgText ~= "empty" then
            DisplayMessage(newContent, msgText)
        end
        if isRemote() == 0 and userControlScheme == "virtual joystick" then
            DrawDeadZone(newContent)
        end

        if isRemote() == 1 and screen_1 and screen_1.getMouseY() ~= -1 then
            SetButtonContains()
            DrawButtons(newContent)
            if screen_1.getMouseState() == 1 then
                CheckButtons()
            end
            newContent[#newContent + 1] = stringf(
                                              [[<g transform="translate(%d %d)"><circle class="cursor" cx="%fpx" cy="%fpx" r="5"/></g>]],
                                              halfResolutionX, halfResolutionY, simulatedX, simulatedY)
        elseif system.isViewLocked() == 0 then
            if isRemote() == 1 and holdingCtrl then
                SetButtonContains()
                DrawButtons(newContent)

                -- If they're remote, it's kinda weird to be 'looking' everywhere while you use the mouse
                -- We need to add a body with a background color
                if not Animating and not Animated then
                    local collapsedContent = table.concat(newContent, "")
                    newContent = {}
                    newContent[#newContent + 1] = stringf("<style>@keyframes test { from { opacity: 0; } to { opacity: 1; } }  body { animation-name: test; animation-duration: 0.5s; }</style><body><svg width='100%%' height='100%%' position='absolute' top='0' left='0'><rect width='100%%' height='100%%' x='0' y='0' position='absolute' style='fill:rgb(6,5,26);'/></svg><svg width='50%%' height='50%%' style='position:absolute;top:30%%;left:25%%' viewbox='0 0 %d %d'>", ResolutionX, ResolutionY)
                    newContent[#newContent + 1] = GalaxyMapHTML
                    newContent[#newContent + 1] = collapsedContent
                    newContent[#newContent + 1] = "</body>"
                    Animating = true
                    newContent[#newContent + 1] = [[</svg></body>]] -- Uh what.. okay...
                    unit.setTimer("animateTick", 0.5)
                    local content = table.concat(newContent, "")
                    system.setScreen(content)
                elseif Animated then
                    local collapsedContent = table.concat(newContent, "")
                    newContent = {}
                    newContent[#newContent + 1] = stringf("<body style='background-color:rgb(6,5,26)'><svg width='50%%' height='50%%' style='position:absolute;top:30%%;left:25%%' viewbox='0 0 %d %d'>", ResolutionX, ResolutionY)
                    newContent[#newContent + 1] = GalaxyMapHTML
                    newContent[#newContent + 1] = collapsedContent
                    newContent[#newContent + 1] = "</body>"
                end

                if not Animating then
                    newContent[#newContent + 1] = stringf(
                                                      [[<g transform="translate(%d %d)"><circle class="cursor" cx="%fpx" cy="%fpx" r="5"/></g>]],
                                                      halfResolutionX, halfResolutionY, simulatedX, simulatedY)
                end
            else
                CheckButtons()
            end
        else
            if not holdingCtrl and isRemote() == 0 then -- Draw deadzone circle if it's navigating
                CheckButtons()

                if distance > DeadZone then -- Draw a line to the cursor from the screen center
                    -- Note that because SVG lines fucking suck, we have to do a translate and they can't use calc in their params
                    DrawCursorLine(newContent)
                end
            else
                SetButtonContains()
                DrawButtons(newContent)

            end
            -- Cursor always on top, draw it last
            newContent[#newContent + 1] = stringf(
                                              [[<g transform="translate(%d %d)"><circle class="cursor" cx="%fpx" cy="%fpx" r="5"/></g>]],
                                              halfResolutionX, halfResolutionY, simulatedX, simulatedY)
        end
        newContent[#newContent + 1] = [[</svg></body>]]
        content = table.concat(newContent, "")
        if not DidLogOutput then
            system.logInfo(LastContent)
            DidLogOutput = true
        end        
    elseif timerId == "apTick" then
        -- Localized Functions
        rateOfChange = vec3(core.getConstructWorldOrientationForward()):dot(vec3(core.getWorldVelocity()):normalize())
        inAtmo = (atmosphere() > 0)

        local time = system.getTime()
        local deltaTick = time - lastApTickTime
        lastApTickTime = time

        local constrF = vec3(core.getConstructWorldOrientationForward())
        local constrR = vec3(core.getConstructWorldOrientationRight())
        local constrUp = vec3(core.getConstructWorldOrientationUp())
        local worldV = vec3(core.getWorldVertical())

        local localVel = core.getVelocity()
        --local currentYaw = getRelativeYaw(localVel)
        --local currentPitch = getRelativePitch(localVel)
        local roll = getRoll(worldV, constrF, constrR)
        local radianRoll = (roll / 180) * math.pi
        local corrX = math.cos(radianRoll)
        local corrY = math.sin(radianRoll)
        local pitch = getPitch(worldV, constrF, constrR) -- Left in for compat, but we should really use adjustedPitch
        local adjustedPitch = getPitch(worldV, constrF, (constrR * corrX) + (constrUp * corrY)) 

        local currentYaw = -math.deg(signedRotationAngle(constrUp, velocity, constrF))
        local currentPitch = math.deg(signedRotationAngle(constrR, velocity, constrF)) -- Let's use a consistent func that uses global velocity

        stalling = inAtmo and currentYaw < -StallAngle or currentYaw > StallAngle or currentPitch < -StallAngle or currentPitch > StallAngle
        local minRollVelocity = 50 -- Min velocity over which advanced rolling can occur

        deltaX = system.getMouseDeltaX()
        deltaY = system.getMouseDeltaY()
        if InvertMouse and not holdingCtrl then deltaY = -deltaY end
        yawInput2 = 0
        rollInput2 = 0
        pitchInput2 = 0
        velocity = vec3(core.getWorldVelocity())
        velMag = vec3(velocity):len()
        sys = galaxyReference[0]
        planet = sys:closestBody(core.getConstructWorldPos())
        --if planet.name == "Space" then planet = atlas[0][2] end -- Assign to Alioth since otherwise Space gets returned if at Alioth.
        kepPlanet = Kep(planet)
        orbit = kepPlanet:orbitalParameters(core.getConstructWorldPos(), velocity)
        hovGndDet = hoverDetectGround() 
        local gravity = planet:getGravity(core.getConstructWorldPos()):len() * constructMass()
        targetRoll = 0
        
        

        maxKinematicUp = core.getMaxKinematicsParametersAlongAxis("ground", core.getConstructOrientationUp())[1]

        if isRemote() == 1 and screen_1 and screen_1.getMouseY() ~= -1 then
            simulatedX = screen_1.getMouseX() * ResolutionX
            simulatedY = screen_1.getMouseY() * ResolutionY
        elseif system.isViewLocked() == 0 then
            if isRemote() == 1 and holdingCtrl then
                if not Animating then
                    simulatedX = simulatedX + deltaX
                    simulatedY = simulatedY + deltaY
                end
            else
                simulatedX = 0
                simulatedY = 0 -- Reset after they do view things, and don't keep sending inputs while unlocked view
                -- Except of course autopilot, which is later.
            end
        else
            simulatedX = simulatedX + deltaX
            simulatedY = simulatedY + deltaY
            distance = math.sqrt(simulatedX * simulatedX + simulatedY * simulatedY)
            if not holdingCtrl and isRemote() == 0 then -- Draw deadzone circle if it's navigating
                if userControlScheme == "virtual joystick" then -- Virtual Joystick
                    -- Do navigation things

                    if simulatedX > 0 and simulatedX > DeadZone then
                        yawInput2 = yawInput2 - (simulatedX - DeadZone) * MouseXSensitivity
                    elseif simulatedX < 0 and simulatedX < (DeadZone * -1) then
                        yawInput2 = yawInput2 - (simulatedX + DeadZone) * MouseXSensitivity
                    else
                        yawInput2 = 0
                    end

                    if simulatedY > 0 and simulatedY > DeadZone then
                        pitchInput2 = pitchInput2 - (simulatedY - DeadZone) * MouseYSensitivity
                    elseif simulatedY < 0 and simulatedY < (DeadZone * -1) then
                        pitchInput2 = pitchInput2 - (simulatedY + DeadZone) * MouseYSensitivity
                    else
                        pitchInput2 = 0
                    end
                elseif userControlScheme == "mouse" then -- Mouse Direct
                    simulatedX = 0
                    simulatedY = 0
                    -- pitchInput2 = pitchInput2 - deltaY * MousePitchFactor
                    -- yawInput2 = yawInput2 - deltaX * MouseYawFactor
                    -- So... this is weird.  
                    -- It's doing some odd things and giving us some weird values. 

                    -- utils.smoothstep(progress, low, high)*2-1
                    pitchInput2 = (-utils.smoothstep(deltaY, -100, 100) + 0.5) * 2 * MousePitchFactor
                    yawInput2 = (-utils.smoothstep(deltaX, -100, 100) + 0.5) * 2 * MouseYawFactor
                else -- Keyboard mode
                    simulatedX = 0
                    simulatedY = 0
                    -- Don't touch anything, they have it with kb only.  
                end
                -- Right so.  We can't detect a mouse click.  That's stupid.  
                -- We have two options.  1. Use mouse wheel movement as a click, or 2. If you're hovered over a button and let go of Ctrl, it's a click
                -- I think 2 is a much smoother solution.  Even if we later want to have them input some coords
                -- We'd have to hook 0-9 in their events, and they'd have to point at the target, so it wouldn't be while this screen is open

                -- What that means is, if we get here, check our hovers.  If one of them is active, trigger the thing and deactivate the hover
            end
        end

        local isWarping = (velMag > 8334)
        if velMag > SpaceSpeedLimit/3.6 and not inAtmo and not Autopilot and not isWarping then
            msgText = "Space Speed Engine Shutoff reached"
            if Nav.axisCommandManager:getAxisCommandType(0) == 1 then
                Nav.control.cancelCurrentControlMasterMode()
            end
            Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0)
        end
        if not isWarping and LastIsWarping then
            if not BrakeIsOn then
                BrakeToggle()
            end
            if Autopilot then
                ToggleAutopilot()
            end
        end
        LastIsWarping = isWarping
        if inAtmo and atmosphere() > 0.09 then
            --if not speedLimitBreaking  then
            if velMag > (AtmoSpeedLimit / 3.6) then
            --        BrakeIsOn = true
            --        speedLimitBreaking  = true
                if Nav.axisCommandManager:getAxisCommandType(0) == axisCommandType.byThrottle then
                    Nav.control.cancelCurrentControlMasterMode()
                end
            end
            --else
            --    if velMag < (AtmoSpeedLimit / 3.6) then
            --        BrakeIsOn = false
            --        speedLimitBreaking = false
            --    end
            --end    
        end
        if BrakeIsOn then
            brakeInput = 1
        else
            brakeInput = 0
        end
        coreAltitude = core.getAltitude()
        if coreAltitude == 0 then
            coreAltitude = (vec3(core.getConstructWorldPos()) - planet.center):len() - planet.radius
        end
        if ProgradeIsOn then
            if velMag > minAutopilotSpeed then -- Help with div by 0 errors and careening into terrain at low speed
                local align = AlignToWorldVector(vec3(velocity),0.01) 
                if spaceLand then 
                    autoRoll = true
                    if velMag < (ReentrySpeed/3.6) then
                            BrakeIsOn = false
                            ProgradeIsOn = false
                            reentryMode = true
                            spaceLand = false   
                            finalLand = true
                            Autopilot = false
                            autoRoll = autoRollPreference   
                            BeginReentry()
                    else
                        BrakeIsOn = true
                    end
                end
            end
        end
        if RetrogradeIsOn then
            if inAtmo then 
                RetrogradeIsOn = false
            elseif velMag > minAutopilotSpeed then -- Help with div by 0 errors and careening into terrain at low speed
                AlignToWorldVector(-(vec3(velocity)))
            end
        end
        if not ProgradeIsOn and spaceLand then 
            if atmosphere() == 0 then 
                reentryMode = true
                BeginReentry()
                spaceLand = false
                finalLand = true
            else
                spaceLand = false
                ToggleAutopilot()
            end
        end
        if finalLand and (coreAltitude < (ReentryAltitude + 100)) and ((velMag*3.6) > (ReentrySpeed-100)) then
            ToggleAutopilot()
            finalLand = false
        end
        if Autopilot and atmosphere() == 0 and not spaceLand then
            -- Planetary autopilot engaged, we are out of atmo, and it has a target
            -- Do it.  
            -- And tbh we should calc the brakeDistance live too, and of course it's also in meters
            local brakeDistance, brakeTime
            if not TurnBurn then
                brakeDistance, brakeTime = GetAutopilotBrakeDistanceAndTime(velMag)
            else
                brakeDistance, brakeTime = GetAutopilotTBBrakeDistanceAndTime(velMag)
            end
            brakeDistance = brakeDistance
            brakeTime = brakeTime -- * 1.05 -- Padding?
            -- Maybe instead of pointing at our vector, we point at our vector + how far off our velocity vector is
            -- This is gonna be hard to get the negatives right.
            -- If we're still in orbit, don't do anything, that velocity will suck
            local targetCoords = AutopilotTargetCoords
            local skipAlign = false
            AutopilotDistance = (vec3(targetCoords) - vec3(core.getConstructWorldPos())):len()
            local displayDistance = (AutopilotTargetCoords - vec3(core.getConstructWorldPos())):len() -- Don't show our weird variations
            local displayText, displayUnit = getDistanceDisplayString(displayDistance)
            system.updateData(widgetDistanceText, '{"label": "distance", "value": "' ..
                displayText.. '", "unit":"' .. displayUnit .. '"}')
            local aligned = true -- It shouldn't be used if the following condition isn't met, but just in case

            local projectedAltitude = (autopilotTargetPlanet.center -
                                          (vec3(core.getConstructWorldPos()) +
                                              (vec3(velocity):normalize() * AutopilotDistance))):len() -
                                          autopilotTargetPlanet.radius
            displayText, displayUnit = getDistanceDisplayString(projectedAltitude)
            system.updateData(widgetTrajectoryAltitudeText, '{"label": "Projected Altitude", "value": "' ..
                displayText.. '", "unit":"' .. displayUnit .. '"}')

            if orbit.apoapsis == nil and velMag > 300 and AutopilotAccelerating then
                -- Get the angle between forward and velocity
                -- Get the magnitude for each of yaw and pitch
                -- Consider a right triangle, with side a being distance to our target
                -- get side b, where have the angle.  Do this once for each of yaw and pitch
                -- The result of each of those would then be multiplied by something to make them vectors...

                -- Okay another idea.
                -- Normalize forward and velocity, then get the ratio of normvelocity:velocity
                -- And scale forward back up by that amount.  Then take forward-velocity, the 

                -- No no.
                -- Okay so, first, when we realign, we store shipright and shipup, just for this
                -- Get the difference between ship forward and normalized worldvel
                -- Get the components in each of the stored shipright and shipup directions
                -- Get the ratio of velocity to normalized velocity and scale up that component (Hey this is just velmag btw)
                -- Add that component * shipright or shipup
                --local velVectorOffset = (vec3(AutopilotTargetCoords) - vec3(core.getConstructWorldPos())):normalize() -
                --                            vec3(velocity):normalize()
                --local pitchComponent = getMagnitudeInDirection(velVectorOffset, AutopilotShipUp)
                --local yawComponent = getMagnitudeInDirection(velVectorOffset, AutopilotShipRight)
                --local leftAmount = -yawComponent * AutopilotDistance * velMag * TrajectoryAlignmentStrength
                --local downAmount = -pitchComponent * AutopilotDistance * velMag * TrajectoryAlignmentStrength
                --targetCoords = AutopilotTargetCoords + (-leftAmount * vec3(AutopilotShipRight)) +
                --                   (-downAmount * vec3(AutopilotShipUp))

                -- All of that's stupid.  Use signedRotationAngle to get the yaw and pitch angles with shipUp and shipRight as the normals, respectively
                -- Then use a PID
                local targetVec = (vec3(targetCoords) - vec3(core.getConstructWorldPos()))
                local targetYaw = utils.clamp(math.deg(signedRotationAngle(constrUp, velocity:normalize(), targetVec:normalize()))*(velMag/500),-90,90)
                local targetPitch = utils.clamp(math.deg(signedRotationAngle(constrR, velocity:normalize(), targetVec:normalize()))*(velMag/500),-90,90)

                -- If the values are particularly small, give us a lot of extra oomph
                --if math.abs(targetYaw) < 1 then
                --    targetYaw = utils.clamp(targetYaw*10,-90,90)
                --end
                --if math.abs(targetPitch) < 1 then
                --    targetPitch = utils.clamp(targetPitch*10,-90,90)
                --end

                -- If they're both very small, scale them both up a lot to converge that last bit
                if math.abs(targetYaw) < 5 and math.abs(targetPitch) < 5 then
                    targetYaw = targetYaw * 2
                    targetPitch = targetPitch * 2
                end
                -- If they're both very very small even after scaling them the first time, do it again
                if math.abs(targetYaw) < 2 and math.abs(targetPitch) < 2 then
                    targetYaw = targetYaw * 2
                    targetPitch = targetPitch * 2
                end

                -- We'll do our own currentYaw and Pitch
                local currentYaw = -math.deg(signedRotationAngle(constrUp, constrF, velocity:normalize()))
                local currentPitch = -math.deg(signedRotationAngle(constrR, constrF, velocity:normalize()))

                --system.print("Target yaw " .. targetYaw .. " - Target pitch " .. targetPitch)
                --system.print ("Current " .. currentYaw .. " - " .. currentPitch)
                if (apPitchPID == nil) then
                    apPitchPID = pid.new(2 * 0.01, 0, 2 * 0.1) -- magic number tweaked to have a default factor in the 1-10 range
                end
                apPitchPID:inject(targetPitch - currentPitch)
                local autoPitchInput = utils.clamp(apPitchPID:get(),-1,1)

                pitchInput2 = pitchInput2 + autoPitchInput

                if (apYawPID == nil) then -- Changed from 2 to 8 to tighten it up around the target
                    apYawPID = pid.new(2 * 0.01, 0, 2 * 0.1) -- magic number tweaked to have a default factor in the 1-10 range
                end
                --yawPID:inject(yawDiff) -- Aim for 85% stall angle, not full
                apYawPID:inject(targetYaw - currentYaw)
                local autoYawInput = utils.clamp(apYawPID:get(),-1,1) -- Keep it reasonable so player can override
                yawInput2 = yawInput2 + autoYawInput
                

                skipAlign = true
                
            end

            if projectedAltitude < AutopilotTargetOrbit*1.5 then
                -- Recalc end speeds for the projectedAltitude since it's reasonable... 
                if CustomTarget ~= nil and CustomTarget.planetname == "Space" then 
                    AutopilotEndSpeed = 0
                else
                    _, AutopilotEndSpeed = Kep(autopilotTargetPlanet):escapeAndOrbitalSpeed(projectedAltitude)
                end
            end

            if not AutopilotCruising and not AutopilotBraking and not skipAlign then
                aligned = AlignToWorldVector((targetCoords - vec3(core.getConstructWorldPos())):normalize())
            elseif TurnBurn and not skipAlign then
                aligned = AlignToWorldVector(-vec3(velocity):normalize())
            end
            if AutopilotAccelerating then
                if not aligned or BrakeIsOn then
                    AutopilotStatus = "Adjusting Trajectory"
                else
                    AutopilotStatus = "Accelerating"
                end
                --if vec3(core.getConstructWorldOrientationForward()):dot(velocity) < 0 and velMag > 300 then
                --    BrakeIsOn = true
                --    Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0)
                --    apThrottleSet = false
                --elseif not apThrottleSet then
                if not apThrottleSet then
                    BrakeIsOn = false
                    Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, AutopilotInterplanetaryThrottle)
                    apThrottleSet = true
                end
                if (vec3(core.getVelocity()):len() >= MaxGameVelocity or (unit.getThrottle() == 0 and apThrottleSet)) then
                    AutopilotAccelerating = false
                    AutopilotStatus = "Cruising"
                    AutopilotCruising = true
                    Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0)
                    apThrottleSet = false
                end
                -- Check if accel needs to stop for braking
                if AutopilotDistance <= brakeDistance then
                    AutopilotAccelerating = false
                    AutopilotStatus = "Braking"
                    AutopilotBraking = true
                    Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0)
                    apThrottleSet = false
                end
            elseif AutopilotBraking then
                BrakeIsOn = true
                brakeInput = 1
                if TurnBurn then
                    Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 100) -- This stays 100 to not mess up our calculations
                end
                -- Check if an orbit has been established and cut brakes and disable autopilot if so

                -- We'll try <0.9 instead of <1 so that we don't end up in a barely-orbit where touching the controls will make it an escape orbit
                -- Though we could probably keep going until it starts getting more eccentric, so we'd maybe have a circular orbit

                if (CustomTarget ~=nil and CustomTarget.planetname == "Space" and velMag < 50) then
                    msgText = "Autopilot complete, arrived at space location"
                    AutopilotBraking = false
                    Autopilot = false
                    AutopilotStatus = "Aligning" -- Disable autopilot and reset
                elseif (CustomTarget ==nil or (CustomTarget ~= nil and CustomTarget.planetname ~= "Space")) and orbit.periapsis ~= nil and orbit.eccentricity < 1 then
                    AutopilotStatus = "Circularizing"
                    -- Calculate the appropriate speed for the altitude we are from the target planet.  These speeds would be lower further out so, shouldn't trigger early
                    local _, endSpeed = Kep(autopilotTargetPlanet):escapeAndOrbitalSpeed((vec3(core.getConstructWorldPos())-planet.center):len()-planet.radius)
                    --system.print("Ecc " .. orbit.eccentricity .. ", last: " .. lastEccentricity .. ", apo " .. orbit.apoapsis.altitude .. ", peri " .. orbit.periapsis.altitude .. ", target " .. AutopilotTargetOrbit)
                    --if (orbit.eccentricity > lastEccentricity and orbit.eccentricity < 0.5) or
                    if velMag <= endSpeed then --or(orbit.apoapsis.altitude < AutopilotTargetOrbit and orbit.periapsis.altitude < AutopilotTargetOrbit) then
                        BrakeIsOn = false
                        AutopilotBraking = false
                        Autopilot = false
                        AutopilotStatus = "Aligning" -- Disable autopilot and reset
                        -- TODO: This is being added to newContent *after* we already drew the screen, so it'll never get displayed
                        msgText = "Autopilot completed, orbit established"
                        brakeInput = 0
                        Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0)
                        apThrottleSet = false
                        if CustomTarget ~= nil and CustomTarget.planetname ~= "Space" then
                            ProgradeIsOn = true
                            spaceLand = true
                        end
                    end
                end
            elseif AutopilotCruising then
                if AutopilotDistance <= brakeDistance then
                    AutopilotAccelerating = false
                    AutopilotStatus = "Braking"
                    AutopilotBraking = true
                end
                if unit.getThrottle() > 0 then
                    AutopilotAccelerating = true
                    AutopilotStatus = "Accelerating"
                    AutopilotCruising = false
                end
            else
                -- It's engaged but hasn't started accelerating yet.
                if aligned then
                    -- Re-align to 200km from our aligned right                    
                    if not AutopilotRealigned and CustomTarget == nil or (not AutopilotRealigned and CustomTarget ~= nil and CustomTarget.planetname ~= "Space") then
                        if not spaceLand then
                            AutopilotTargetCoords = vec3(autopilotTargetPlanet.center) +
                                                        ((AutopilotTargetOrbit + autopilotTargetPlanet.radius) *
                                                            vec3(core.getConstructWorldOrientationRight()))
                            AutopilotShipUp = core.getConstructWorldOrientationUp()
                            AutopilotShipRight = core.getConstructWorldOrientationRight()
                        end
                        AutopilotRealigned = true
                    elseif aligned then
                        AutopilotAccelerating = true
                        AutopilotStatus = "Accelerating"
                        -- Set throttle to max
                        if not apThrottleSet then
                            Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal,
                            AutopilotInterplanetaryThrottle)
                            apThrottleSet = true
                            BrakeIsOn = false
                        end
                    end
                end
                -- If it's not aligned yet, don't try to burn yet.
            end
        end
        if followMode then
            -- User is assumed to be outside the construct
            autoRoll = true -- Let Nav handle that while we're here
            local targetPitch = 0
            -- Keep brake engaged at all times unless: 
            -- Ship is aligned with the target on yaw (roll and pitch are locked to 0)
            -- and ship's speed is below like 5-10m/s
            local pos = vec3(core.getConstructWorldPos()) + vec3(unit.getMasterPlayerRelativePosition()) -- Is this related to core forward or nah?
            local distancePos = (pos - vec3(core.getConstructWorldPos()))
            -- local distance = distancePos:len()
            -- distance needs to be calculated using only construct forward and right
            local distanceForward = vec3(distancePos):project_on(vec3(core.getConstructWorldOrientationForward())):len()
            local distanceRight = vec3(distancePos):project_on(vec3(core.getConstructWorldOrientationRight())):len()
            -- local distanceDown = vec3(distancePos):project_on(-vec3(core.getConstructWorldOrientationRight())):len()
            local distance = math.sqrt(distanceForward * distanceForward + distanceRight * distanceRight)
            AlignToWorldVector(distancePos:normalize())
            local targetDistance = 40
            -- local onShip = false
            -- if distanceDown < 1 then 
            --    onShip = true
            -- end
            local nearby = (distance < targetDistance)
            local maxSpeed = 100 -- Over 300kph max, but, it scales down as it approaches
            local targetSpeed = utils.clamp((distance - targetDistance) / 2, 10, maxSpeed)
            pitchInput2 = 0
            local aligned = (math.abs(yawInput2) < 0.1)
            if (aligned and velMag < targetSpeed and not nearby) then -- or (not BrakeIsOn and onShip) then
                -- if not onShip then -- Don't mess with brake if they're on ship
                BrakeIsOn = false
                -- end
                targetPitch = -20
            else
                -- if not onShip then
                BrakeIsOn = true
                -- end
                targetPitch = 0
            end
            
            local autoPitchThreshold = 1.0
            -- Copied from autoroll let's hope this is how a PID works... 
            if math.abs(targetPitch - pitch) > autoPitchThreshold then
                if (pitchPID == nil) then
                    pitchPID = pid.new(2 * 0.01, 0, 2 * 0.1) -- magic number tweaked to have a default factor in the 1-10 range
                end
                pitchPID:inject(targetPitch - pitch)
                local autoPitchInput = pitchPID:get()

                pitchInput2 = autoPitchInput
            end
        end
        local up = vec3(core.getWorldVertical()) * -1
        if AltitudeHold or BrakeLanding or Reentry or VectorToTarget or LockPitch ~= nil then
            -- HoldAltitude is the alt we want to hold at
            local nearPlanet = unit.getClosestPlanetInfluence() > 0
            -- Dampen this.
            local altDiff = HoldAltitude - coreAltitude
            -- This may be better to smooth evenly regardless of HoldAltitude.  Let's say, 2km scaling?  Should be very smooth for atmo
            -- Even better if we smooth based on their velocity
            local minmax = 500 + velMag
            -- Smooth the takeoffs with a velMag multiplier that scales up to 100m/s
            local targetPitch = (utils.smoothstep(altDiff, -minmax, minmax) - 0.5) * 2 * MaxPitch * utils.clamp(velMag/100,0.1,1)

            if not AltitudeHold then
                targetPitch = 0
            end
            if LockPitch ~= nil then 
                if nearPlanet then 
                    targetPitch = LockPitch 
                else
                    LockPitch = nil
                end
            end
            autoRoll = true
            
            if Reentry then
                local fasterSpeed = ReentrySpeed
                if Nav.axisCommandManager:getTargetSpeed(axisCommandId.longitudinal) ~= fasterSpeed then -- This thing is dumb.
                    Nav.axisCommandManager:setTargetSpeedCommand(axisCommandId.longitudinal, fasterSpeed)
                    Nav.axisCommandManager:setTargetSpeedCommand(axisCommandId.vertical, 0)
                    Nav.axisCommandManager:setTargetSpeedCommand(axisCommandId.lateral, 0)
                end 
                if not reentryMode then
                    targetPitch = -80
                    if atmosphere() > 0.02 then
                        msgText = "PARACHUTE DEPLOYED"
                        Reentry = false
                        BrakeLanding = true
                        targetPitch = 0
                        autoRoll = autoRollPreference
                    end
                elseif Nav.axisCommandManager:getTargetSpeed(axisCommandId.longitudinal) == ReentrySpeed then
                    reentryMode = false
                    Reentry = false
                    autoRoll = autoRollPreference
                end    
            end

            -- The clamp should now be redundant
            -- local targetPitch = utils.clamp(altDiff,-20,20) -- Clamp to reasonable values
            -- Align it prograde but keep whatever pitch inputs they gave us before, and ignore pitch input from alignment.
            -- So, you know, just yaw.
            local oldInput = pitchInput2
            if velMag > minAutopilotSpeed and not spaceLaunch and not VectorToTarget and not BrakeLanding then -- When do we even need this, just alt hold? lol
                AlignToWorldVector(vec3(velocity))
            end
            if VectorToTarget and CustomTarget ~= nil and AutopilotTargetIndex > 0 then
                local targetVec = CustomTarget.position - vec3(core.getConstructWorldPos())

                -- Okay so, screw AlignToWorldVector.  Pitch is already handled, we just need to detect a Yaw value
                -- then PID the yaw to that value, with a max value of StallAngle
                -- Of course, only works if speed is high enough

                local constrUp = vec3(core.getConstructWorldOrientationUp())
                --local vectorInYawDirection = targetVec:project_on_plane(worldV):normalize()
                --local flatForward = velocity:normalize():project_on_plane(worldV):normalize() -- Possibly necessary after 3d to 2d conversion
                -- :angle_to uses only .x and .y, literal 2d
                -- So project it on a plane first, with ship up as the normal

                -- Hilariously, angle_to uses atan2 which isn't in the game
                --local targetYaw = math.deg(constrF:angle_to(vectorInYawDirection))
                -- And is wrong?
                --local targetYaw = math.deg(math.atan(flatForward.y-vectorInYawDirection.y, flatForward.x-vectorInYawDirection.x))
                local targetYaw = math.deg(signedRotationAngle(worldV,velocity:normalize(),targetVec:normalize()))*2
                --local targetYaw = math.deg(math.acos((vectorInYawDirection:dot(flatForward)))) * -utils.sign(targetVec:dot(velocity:cross(worldV)))*2
                
                -- Let's go twice what they tell us to, which should converge quickly, within our clamp


                --if stalling then
                --    system.print("Stalled - Target yaw is " .. targetYaw .. " - Current: " .. currentYaw)
                --else
                --    system.print("Target yaw is " .. targetYaw .. " - Current: " .. currentYaw)
                --end
                --system.print("Roll is " .. roll .. " - Target yaw is " .. targetYaw .. " - Current: " .. currentYaw .. " - Prev targetPitch is " .. targetPitch)
                -- We can try it with roll... 
                local rollRad = math.rad(math.abs(roll))
                if velMag > minRollVelocity then
                    targetRoll = utils.clamp(targetYaw/2, -90, 90)
                    local origTargetYaw = targetYaw
                    -- I have no fucking clue why we add currentYaw to StallAngle when currentYaw is already potentially a large value outside of the velocity vector
                    -- But it doesn't work otherwise and stalls if we don't do it like that.  I don't fucking know.  
                    targetYaw = utils.clamp((currentYaw-targetYaw),currentYaw-StallAngle*0.85,currentYaw+StallAngle*0.85)*math.cos(rollRad) + utils.clamp(targetPitch-adjustedPitch,-StallAngle*0.85,StallAngle*0.85)*math.sin(math.rad(roll)) --  Try signing the pitch component of this
                    targetPitch = utils.clamp(targetPitch*math.cos(rollRad),-StallAngle*0.85,StallAngle*0.85) + utils.clamp(math.abs(origTargetYaw),-StallAngle*0.85,StallAngle*0.85)*math.sin(rollRad)
                end -- We're just taking abs of the yaw for pitch, because we just want to pull up, and it rolled the right way already.
                -- And the pitch now gets info about yaw too?
                -- cos(roll) should give 0 at 90 and 1/-1 at 0 and 180
                -- So targetYaw*cos(roll) goes into yaw
                -- Then sin(roll) gives high values at the 90's
                -- so yaw would end up being -targetYaw*cos(roll) + targetPitch*sin(roll)
                -- and pitch would be targetPitch*cos(roll) - targetYaw*sin(roll) cuz yaw and pitch are reversed from eachother


                local yawDiff = targetYaw

                if not stalling and velMag > minRollVelocity then
                    if (yawPID == nil) then -- Changed from 2 to 8 to tighten it up around the target
                        yawPID = pid.new(2 * 0.01, 0, 2 * 0.1) -- magic number tweaked to have a default factor in the 1-10 range
                    end
                    --yawPID:inject(yawDiff) -- Aim for 85% stall angle, not full
                    yawPID:inject(yawDiff)
                    local autoYawInput = utils.clamp(yawPID:get(),-1,1) -- Keep it reasonable so player can override
                    yawInput2 = yawInput2 + autoYawInput
                elseif hovGndDet > -1 or velMag < minRollVelocity then
                    AlignToWorldVector(targetVec) -- Point to the target if on the ground and 'stalled'
                else
                    AlignToWorldVector(velocity) -- Otherwise try to pull out of the stall
                end

                --local distanceToTarget = targetVec:project_on(velocity):len() -- Probably not strictly accurate with curvature but it should work
                -- Well, maybe not.  Really we have a triangle.  Of course.  
                -- We know C, our distance to target.  We know the height we'll be above the target (should be the same as our current height)
                -- We just don't know the last leg
                -- a2 + b2 = c2.  c2 - b2 = a2
                local targetAltitude = planet:getAltitude(CustomTarget.position)
                local distanceToTarget = math.sqrt(targetVec:len()^2-(coreAltitude-targetAltitude)^2)

                -- We want current brake value, not max
                local curBrake = LastMaxBrakeInAtmo
                if curBrake then
                    curBrake = curBrake * utils.clamp(velMag/100,0.1,1) * atmosphere()
                else
                    curBrake = LastMaxBrake
                end
                
                local vSpd = (velocity.x * up.x) + (velocity.y * up.y) + (velocity.z * up.z)
                local hSpd = velocity:len() - math.abs(vSpd)
                local airFrictionVec = vec3(core.getWorldAirFrictionAcceleration())
                local airFriction = math.sqrt(airFrictionVec:len() - airFrictionVec:project_on(up):len()) * constructMass()
                -- Assume it will halve over our duration, if not sqrt.  We'll try sqrt because it's underestimating atm
                -- First calculate stopping to 100 - that all happens with full brake power
                if velMag > 100 then
                    brakeDistance, brakeTime = Kinematic.computeDistanceAndTime(velMag, 100, constructMass(), 0, 0,
                                                    curBrake + airFriction)
                    -- Then add in stopping from 100 to 0 at what averages to half brake power.  Assume no friction for this
                    local lastDist, brakeTime2 = Kinematic.computeDistanceAndTime(100, 0, constructMass(), 0, 0, curBrake/2)
                    brakeDistance = brakeDistance + lastDist
                else -- Just calculate it regularly assuming the value will be halved while we do it, assuming no friction
                    brakeDistance, brakeTime = Kinematic.computeDistanceAndTime(velMag, 0, constructMass(), 0, 0, curBrake/2)
                end
               

                --StrongBrakes = ((planet.gravity * 9.80665 * constructMass()) < LastMaxBrakeInAtmo)
                StrongBrakes = true -- We don't care about this or glide landing anymore and idk where all it gets used
                --system.print(distanceToTarget .. " to target, can brake to 0 in " .. brakeDistance .. " , deltaVelocity is " .. (velMag*deltaTick))
                
                -- Fudge it with the distance we'll travel in a tick - or half that and the next tick accounts for the other? idk
                if distanceToTarget <= brakeDistance + (velMag*deltaTick)/2 then 
                    VectorStatus = "Finalizing Approach" -- Left for compatibility
                    if Nav.axisCommandManager:getAxisCommandType(0) == axisCommandType.byTargetSpeed then
                        Nav.control.cancelCurrentControlMasterMode()
                    end
                    Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0) -- Kill throttle in case they weren't in cruise
                    if AltitudeHold then
                        ToggleAltitudeHold() -- Don't need this anymore
                        VectorToTarget = true -- But keep this on
                    end
                    BrakeIsOn = true

                    if hSpd < 1 or distanceToTarget < 1 then
                        BrakeLanding = true
                        VectorToTarget = false
                    end

                elseif not AutoTakeoff then
                    BrakeIsOn = false
                end
                
            end
            pitchInput2 = oldInput
            local groundDistance = -1
            local autoPitchThreshold = 0.1

            if BrakeLanding then
                targetPitch = 0
                local vSpd = (velocity.x * up.x) + (velocity.y * up.y) + (velocity.z * up.z)
                local skipLandingRate = false
                local distanceToStop = 30 
                if maxKinematicUp ~= nil and maxKinematicUp > 0 then
                    -- Calculate a landing rate instead since we know what their hovers can do
                    
                    --local gravity = planet:getGravity(core.getConstructWorldPos()):len() * constructMass() -- We'll use a random BS value of a guess
                    --local airFriction = math.sqrt(vec3(core.getWorldAirFrictionAcceleration()):len() * constructMass())
                    -- airFriction falls off on a square

                    -- Let's try not using airFriction
                    local airFriction = 0

                    -- Funny enough, LastMaxBrakeInAtmo has stuff done to it to convert to a flat value
                    -- But we need the instant one back, to know how good we are at braking at this exact moment
                    --system.print("Max brake Gs: " .. LastMaxBrakeInAtmo/gravity)
                    local atmos = utils.clamp(atmosphere(),0.4,2) -- Assume at least 40% atmo when they land, to keep things fast in low atmo
                    local curBrake = LastMaxBrakeInAtmo * utils.clamp(velMag/100,0.1,1) * atmos
                    local totalNewtons = maxKinematicUp * atmos + curBrake + airFriction - gravity -- Ignore air friction for leeway, KinematicUp and Brake are already in newtons
                    local brakeNewtons = curBrake + airFriction - gravity
                    local weakBreakNewtons = curBrake/2 + airFriction - gravity

                    -- Compute the travel time from current speed, with brake acceleration, for 20m
                    --local brakeTravelTime = Kinematic.computeTravelTime(velMag, -brakeNewtons , 20)

                    -- Big problem here, computeTravelTime only works with positive acceleration values
                    -- This means we can't calculate how long it would take to decelerate for 20 meters
                    -- But we could calculate how long it'd take to accelerate for that distance... but that's not right
                    -- Cuz it'll be increasing speed and decreasing time over that duration

                    -- I need to know the velocity after applying a force for a distance
                    -- W = Fd = 0.5*mass*velocity^2
                    -- W = math.abs(lowBrakeNewtons)*20 = 0.5*constructMass()*v^2
                    -- math.sqrt((math.abs(lowBrakeNewtons)*20)/(0.5*constructMass()))
                    
                    -- For leniency just always assume it's weak
                    local speedAfterBraking = velMag - math.sqrt((math.abs(weakBreakNewtons/2)*20)/(0.5*constructMass()))*utils.sign(weakBreakNewtons)
                    --system.print("Speed now: " .. velMag .. " - After braking for 20m, speed will be " .. speedAfterBraking)
                    if speedAfterBraking < 0 then  
                        speedAfterBraking = 0 -- Just in case it gives us negative values
                    end
                    -- So then see if hovers can finish the job in the remaining distance

                    local brakeStopDistance
                    if velMag > 100 then
                        local brakeStopDistance1, _ = Kinematic.computeDistanceAndTime(velMag, 100, constructMass(), 0, 0, curBrake)
                        local brakeStopDistance2, _ = Kinematic.computeDistanceAndTime(100, 0, constructMass(), 0, 0, math.sqrt(curBrake))
                        brakeStopDistance = brakeStopDistance1+brakeStopDistance2
                    else
                        brakeStopDistance = Kinematic.computeDistanceAndTime(velMag, 0, constructMass(), 0, 0, math.sqrt(curBrake))
                    end
                    if brakeStopDistance < 20 then
                        BrakeIsOn = false -- We can stop in less than 20m from just brakes, we don't need to do anything
                        -- This gets overridden later if we don't know the altitude or don't want to calculate
                    else
                        local stopDistance = 0
                        if speedAfterBraking > 100 then
                            local stopDistance1, _ = Kinematic.computeDistanceAndTime(speedAfterBraking, 100, constructMass(), 0, 0, totalNewtons) 
                            local stopDistance2, _ = Kinematic.computeDistanceAndTime(100, 0, constructMass(), 0, 0, maxKinematicUp * atmos + math.sqrt(curBrake) + airFriction - gravity) -- Low brake power for the last 100kph
                            stopDistance = stopDistance1 + stopDistance2
                        else
                            stopDistance, _ = Kinematic.computeDistanceAndTime(speedAfterBraking, 0, constructMass(), 0, 0, maxKinematicUp * atmos + math.sqrt(curBrake) + airFriction - gravity) 
                        end

                        --system.print("Can stop to 0 in " .. stopDistance .. "m with " .. totalNewtons .. "N of force (" .. totalNewtons/gravity .. "G)")
                        --if LandingGearGroundHeight == 0 then
                        stopDistance = (stopDistance+15+(velMag*deltaTick))*1.1 -- Add leeway for large ships with forcefields or landing gear, and for lag
                        -- And just bad math I guess
                        local knownAltitude = (CustomTarget ~= nil and planet:getAltitude(CustomTarget.position) > 0)
                        
                        if knownAltitude then
                            local targetAltitude = planet:getAltitude(CustomTarget.position)
                            local distanceToGround = coreAltitude - targetAltitude - 100 -- Try to aim for like 100m above the ground, give it lots of time
                            -- We don't have to squeeze out the little bits of performance
                            local targetVec = CustomTarget.position - vec3(core.getConstructWorldPos())
                            local horizontalDistance = math.sqrt(targetVec:len()^2-(coreAltitude-targetAltitude)^2)

                            if horizontalDistance > 100 then
                                -- We are too far off, don't trust our altitude data
                                knownAltitude = false
                            elseif distanceToGround <= stopDistance or stopDistance == -1 then
                                BrakeIsOn = true
                                skipLandingRate = true
                            else
                                BrakeIsOn = false
                                skipLandingRate = true
                            end
                        end
                        
                        if not knownAltitude and CalculateBrakeLandingSpeed then
                            if stopDistance >= distanceToStop then -- 10% padding
                                BrakeIsOn = true
                            else
                                BrakeIsOn = false
                            end
                            skipLandingRate = true
                        end
                    end
                end
                if Nav.axisCommandManager:getAxisCommandType(0) == 1 then
                    Nav.control.cancelCurrentControlMasterMode()
                end
                Nav.axisCommandManager:setTargetGroundAltitude(500)
                Nav.axisCommandManager:activateGroundEngineAltitudeStabilization(500)

                groundDistance = hovGndDet
                if groundDistance > -1 then 
                    --if math.abs(targetPitch - pitch) < autoPitchThreshold then 
                        autoRoll = autoRollPreference                
                        if velMag < 1 or velocity:normalize():dot(worldV) < 0 then -- Or if they start going back up
                            BrakeLanding = false
                            AltitudeHold = false
                            GearExtended = true
                            Nav.control.extendLandingGears()
                            Nav.axisCommandManager:setTargetGroundAltitude(LandingGearGroundHeight)
                            upAmount = 0
                            BrakeIsOn = true
                        else
                            BrakeIsOn = true
                        end
                    --end
                elseif StrongBrakes and (velocity:normalize():dot(-up) < 0.999) then
                    --system.print("Too much HSpeed, braking")
                    BrakeIsOn = true
                elseif vSpd < -brakeLandingRate and not skipLandingRate then
                    BrakeIsOn = true
                elseif not skipLandingRate then
                    BrakeIsOn = false
                end
            end
            if AutoTakeoff or spaceLaunch then
                if targetPitch < 15 and (coreAltitude/HoldAltitude) > 0.75 then
                    AutoTakeoff = false -- No longer in ascent
                    if not spaceLaunch then 
                        if Nav.axisCommandManager:getAxisCommandType(0) == 0 then
                            Nav.control.cancelCurrentControlMasterMode()
                        end
                    elseif spaceLaunch and velMag < minAutopilotSpeed then
                        Autopilot = true
                        spaceLaunch = false
                        AltitudeHold = false
                        if Nav.axisCommandManager:getAxisCommandType(0) == 1 then
                            Nav.control.cancelCurrentControlMasterMode()
                        end
                        Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0)
                    elseif spaceLaunch then
                        if Nav.axisCommandManager:getAxisCommandType(0) ~= 0 then
                            Nav.control.cancelCurrentControlMasterMode()
                        end
                        Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0)
                        BrakeIsOn = true
                    end
                elseif spaceLaunch and atmosphere() == 0 and coreAltitude > 75000 then
                    if Nav.axisCommandManager:getAxisCommandType(0) == 0 then
                        Nav.control.cancelCurrentControlMasterMode()
                    end
                    if Nav.axisCommandManager:getTargetSpeed(axisCommandId.longitudinal) ~= 1500 then -- This thing is dumb.
                        Nav.axisCommandManager:setTargetSpeedCommand(axisCommandId.longitudinal, 1500)
                        Nav.axisCommandManager:setTargetSpeedCommand(axisCommandId.vertical, 0)
                        Nav.axisCommandManager:setTargetSpeedCommand(axisCommandId.lateral, 0)
                    end
                end
            end
            -- Copied from autoroll let's hope this is how a PID works... 
            -- Don't pitch if there is significant roll, or if there is stall
            local onGround = hoverDetectGround() > -1
            local pitchToUse = pitch

            if VectorToTarget and not onGround and velMag > minRollVelocity then
                local rollRad = math.rad(math.abs(roll))
                pitchToUse = pitch*math.cos(rollRad)+currentPitch*math.sin(rollRad)
                --pitchToUse = adjustedPitch -- Use velocity vector pitch instead, we're potentially sideways
                -- Except.  We should use sin and cosine to get the value between this and our real one
                -- Because 30 regular pitch is fine, but 30 pitch above what was already 30 regular pitch isn't - it'll eventually flip us in theory
                -- What if we get the pitch of our velocity vector tho
                --utils.clamp(targetYaw,-StallAngle, StallAngle)*math.cos(rollRad) - targetPitch*math.sin(rollRad)

                -- The 'pitch' of our velocity vector plus the pitch we are in relation to it, should be our real world pitch

                -- then currentPitch*math.sin(rollRad)+pitch*math.cos(rollRad) = absolutePitch
                --system.print("Target Pitch: " .. targetPitch .. " - Current: " .. pitchToUse)
            end
            local pitchDiff = utils.clamp(targetPitch-pitchToUse, -StallAngle*0.85, StallAngle*0.85)
            if math.abs(pitchDiff) > autoPitchThreshold and ((not stalling and (math.abs(roll) < 5 or VectorToTarget)) or BrakeLanding or onGround) then
                if (pitchPID == nil) then -- Changed from 2 to 8 to tighten it up around the target
                    pitchPID = pid.new(8 * 0.01, 0, 8 * 0.1) -- magic number tweaked to have a default factor in the 1-10 range
                end
                pitchPID:inject(pitchDiff)
                local autoPitchInput = pitchPID:get()
                pitchInput2 = pitchInput2 + autoPitchInput
            end
        end
        lastEccentricity = orbit.eccentricity

        if antigrav and not ExternalAGG and coreAltitude < 200000 then
                if AntigravTargetAltitude == nil or AntigravTargetAltitude < 1000 then AntigravTargetAltitude = 1000 end
                if desiredBaseAltitude ~= AntigravTargetAltitude then
                    desiredBaseAltitude = AntigravTargetAltitude
                    antigrav.setBaseAltitude(desiredBaseAltitude)
                end
        end
    end
end

function script.onFlush()
    if antigrav  and not ExternalAGG then
        if antigrav.getState() == 0 and antigrav.getBaseAltitude() ~= AntigravTargetAltitude then 
            antigrav.setBaseAltitude(AntigravTargetAltitude) 
        end
    end


    -- validate params
    pitchSpeedFactor = math.max(pitchSpeedFactor, 0.01)
    yawSpeedFactor = math.max(yawSpeedFactor, 0.01)
    rollSpeedFactor = math.max(rollSpeedFactor, 0.01)
    torqueFactor = math.max(torqueFactor, 0.01)
    brakeSpeedFactor = math.max(brakeSpeedFactor, 0.01)
    brakeFlatFactor = math.max(brakeFlatFactor, 0.01)
    autoRollFactor = math.max(autoRollFactor, 0.01)
    turnAssistFactor = math.max(turnAssistFactor, 0.01)

    -- final inputs
    local finalPitchInput = utils.clamp(pitchInput + pitchInput2 + system.getControlDeviceForwardInput(),-1,1)
    local finalRollInput = utils.clamp(rollInput + rollInput2 + system.getControlDeviceYawInput(),-1,1)
    local finalYawInput = utils.clamp((yawInput + yawInput2) - system.getControlDeviceLeftRightInput(),-1,1)
    local finalBrakeInput = brakeInput

    -- Axis
    local worldVertical = vec3(core.getWorldVertical()) -- along gravity
    local constructUp = vec3(core.getConstructWorldOrientationUp())
    local constructForward = vec3(core.getConstructWorldOrientationForward())
    local constructRight = vec3(core.getConstructWorldOrientationRight())
    local constructVelocity = vec3(core.getWorldVelocity())
    local constructVelocityDir = vec3(core.getWorldVelocity()):normalize()
    local currentRollDeg = getRoll(worldVertical, constructForward, constructRight)
    local currentRollDegAbs = math.abs(currentRollDeg)
    local currentRollDegSign = utils.sign(currentRollDeg)
    local atmosphere = atmosphere()

    -- Rotation
    local constructAngularVelocity = vec3(core.getWorldAngularVelocity())
    local targetAngularVelocity =
        finalPitchInput * pitchSpeedFactor * constructRight + finalRollInput * rollSpeedFactor * constructForward +
            finalYawInput * yawSpeedFactor * constructUp

    -- In atmosphere or aligning prograde with orbit?
    if (worldVertical:len() > 0.01 and atmosphere > 0.0) or ProgradeIsOn then
        -- autoRoll on AND currentRollDeg is big enough AND player is not rolling
        if autoRoll == true and math.abs(targetRoll-currentRollDeg) > autoRollRollThreshold and finalRollInput == 0 then
            local targetRollDeg = targetRoll
            --system.print("Trying to roll to " .. targetRoll)
            local rollFactor = autoRollFactor
            --if targetRoll ~= 0 then
            --    rollFactor = rollFactor*4
            --end
            if (rollPID == nil) then
                rollPID = pid.new(rollFactor * 0.01, 0, rollFactor * 0.1) -- magic number tweaked to have a default factor in the 1-10 range
            end
            rollPID:inject(targetRollDeg - currentRollDeg)
            local autoRollInput = rollPID:get()

            targetAngularVelocity = targetAngularVelocity + autoRollInput * constructForward
        end
    end
    if worldVertical:len() > 0.01 and atmosphere > 0.0 then
        local turnAssistRollThreshold = 20.0
        -- turnAssist AND currentRollDeg is big enough AND player is not pitching or yawing
        if turnAssist == true and currentRollDegAbs > turnAssistRollThreshold and finalPitchInput == 0 and finalYawInput ==
            0 then
            local rollToPitchFactor = turnAssistFactor * 0.1 -- magic number tweaked to have a default factor in the 1-10 range
            local rollToYawFactor = turnAssistFactor * 0.025 -- magic number tweaked to have a default factor in the 1-10 range

            -- rescale (turnAssistRollThreshold -> 180) to (0 -> 180)
            local rescaleRollDegAbs =
                ((currentRollDegAbs - turnAssistRollThreshold) / (180 - turnAssistRollThreshold)) * 180
            local rollVerticalRatio = 0
            if rescaleRollDegAbs < 90 then
                rollVerticalRatio = rescaleRollDegAbs / 90
            elseif rescaleRollDegAbs < 180 then
                rollVerticalRatio = (180 - rescaleRollDegAbs) / 90
            end

            rollVerticalRatio = rollVerticalRatio * rollVerticalRatio

            local turnAssistYawInput = -currentRollDegSign * rollToYawFactor * (1.0 - rollVerticalRatio)
            local turnAssistPitchInput = rollToPitchFactor * rollVerticalRatio

            targetAngularVelocity = targetAngularVelocity + turnAssistPitchInput * constructRight + turnAssistYawInput *
                                        constructUp
        end
    end

    -- Engine commands
    local keepCollinearity = 1 -- for easier reading
    local dontKeepCollinearity = 0 -- for easier reading
    local tolerancePercentToSkipOtherPriorities = 1 -- if we are within this tolerance (in%), we don't go to the next priorities

    -- Rotation
    local angularAcceleration = torqueFactor * (targetAngularVelocity - constructAngularVelocity)
    local airAcceleration = vec3(core.getWorldAirFrictionAngularAcceleration())
    angularAcceleration = angularAcceleration - airAcceleration -- Try to compensate air friction
    
    Nav:setEngineTorqueCommand('torque', angularAcceleration, keepCollinearity, 'airfoil', '', '',
        tolerancePercentToSkipOtherPriorities)

    -- Brakes
    local brakeAcceleration = -finalBrakeInput *
                                  (brakeSpeedFactor * constructVelocity + brakeFlatFactor * constructVelocityDir)
    Nav:setEngineForceCommand('brake', brakeAcceleration)

    -- AutoNavigation regroups all the axis command by 'TargetSpeed'
    local autoNavigationEngineTags = ''
    local autoNavigationAcceleration = vec3()
    local autoNavigationUseBrake = false

    -- Longitudinal Translation
    local longitudinalEngineTags = 'thrust analog longitudinal '
    if ExtraLongitudeTags ~= "none" then longitudinalEngineTags = longitudinalEngineTags..ExtraLongitudeTags end
    local longitudinalCommandType = Nav.axisCommandManager:getAxisCommandType(axisCommandId.longitudinal)
    if (longitudinalCommandType == axisCommandType.byThrottle) then
        local longitudinalAcceleration = Nav.axisCommandManager:composeAxisAccelerationFromThrottle(
                                             longitudinalEngineTags, axisCommandId.longitudinal)
        Nav:setEngineForceCommand(longitudinalEngineTags, longitudinalAcceleration, keepCollinearity)
    elseif (longitudinalCommandType == axisCommandType.byTargetSpeed) then
        local longitudinalAcceleration = Nav.axisCommandManager:composeAxisAccelerationFromTargetSpeed(
                                             axisCommandId.longitudinal)
        autoNavigationEngineTags = autoNavigationEngineTags .. ' , ' .. longitudinalEngineTags
        autoNavigationAcceleration = autoNavigationAcceleration + longitudinalAcceleration
        if (Nav.axisCommandManager:getTargetSpeed(axisCommandId.longitudinal) == 0 or -- we want to stop
            Nav.axisCommandManager:getCurrentToTargetDeltaSpeed(axisCommandId.longitudinal) <
            -Nav.axisCommandManager:getTargetSpeedCurrentStep(axisCommandId.longitudinal) * 0.5) -- if the longitudinal velocity would need some braking
         -- if the longitudinal velocity would need some braking
        then
            autoNavigationUseBrake = true
        end

    end

    -- Lateral Translation
    local lateralStrafeEngineTags = 'thrust analog lateral '
    if ExtraLateralTags ~= "none" then lateralStrafeEngineTags = lateralStrafeEngineTags..ExtraLateralTags end
    local lateralCommandType = Nav.axisCommandManager:getAxisCommandType(axisCommandId.lateral)
    if (lateralCommandType == axisCommandType.byThrottle) then
        local lateralStrafeAcceleration = Nav.axisCommandManager:composeAxisAccelerationFromThrottle(
                                              lateralStrafeEngineTags, axisCommandId.lateral)
        Nav:setEngineForceCommand(lateralStrafeEngineTags, lateralStrafeAcceleration, keepCollinearity)
    elseif (lateralCommandType == axisCommandType.byTargetSpeed) then
        local lateralAcceleration = Nav.axisCommandManager:composeAxisAccelerationFromTargetSpeed(axisCommandId.lateral)
        autoNavigationEngineTags = autoNavigationEngineTags .. ' , ' .. lateralStrafeEngineTags
        autoNavigationAcceleration = autoNavigationAcceleration + lateralAcceleration
    end

    -- Vertical Translation
    local verticalStrafeEngineTags = 'thrust analog vertical '
    if ExtraVerticalTags ~= "none" then verticalStrafeEngineTags = verticalStrafeEngineTags..ExtraVerticalTags end
    local verticalCommandType = Nav.axisCommandManager:getAxisCommandType(axisCommandId.vertical)
    if (verticalCommandType == axisCommandType.byThrottle) then
        local verticalStrafeAcceleration = Nav.axisCommandManager:composeAxisAccelerationFromThrottle(
                                               verticalStrafeEngineTags, axisCommandId.vertical)
        if upAmount ~= 0 or (BrakeLanding and BrakeIsOn) then
            Nav:setEngineForceCommand(verticalStrafeEngineTags, verticalStrafeAcceleration, keepCollinearity, 'airfoil',
                'ground', '', tolerancePercentToSkipOtherPriorities)
        else
            Nav:setEngineForceCommand(verticalStrafeEngineTags, vec3(), keepCollinearity) -- Reset vertical engines but not airfoils or ground
            Nav:setEngineForceCommand('airfoil vertical', verticalStrafeAcceleration, keepCollinearity, 'airfoil',
            '', '', tolerancePercentToSkipOtherPriorities)
            Nav:setEngineForceCommand('ground vertical', verticalStrafeAcceleration, keepCollinearity, 'ground',
            '', '', tolerancePercentToSkipOtherPriorities)
        end
    elseif (verticalCommandType == axisCommandType.byTargetSpeed) then
        if upAmount == 0 then 
            Nav:setEngineForceCommand('hover', vec3(), keepCollinearity) 
        end
        local verticalAcceleration = Nav.axisCommandManager:composeAxisAccelerationFromTargetSpeed(
                                         axisCommandId.vertical)
        autoNavigationEngineTags = autoNavigationEngineTags .. ' , ' .. verticalStrafeEngineTags
        autoNavigationAcceleration = autoNavigationAcceleration + verticalAcceleration
    end

    -- Auto Navigation (Cruise Control)
    if (autoNavigationAcceleration:len() > constants.epsilon) then
        if (brakeInput ~= 0 or autoNavigationUseBrake or math.abs(constructVelocityDir:dot(constructForward)) < 0.95) -- if the velocity is not properly aligned with the forward
         -- if the velocity is not properly aligned with the forward
        then
            autoNavigationEngineTags = autoNavigationEngineTags .. ', brake'
        end
        Nav:setEngineForceCommand(autoNavigationEngineTags, autoNavigationAcceleration, dontKeepCollinearity, '', '',
            '', tolerancePercentToSkipOtherPriorities)
    end

    -- Rockets
    Nav:setBoosterCommand('rocket_engine')
    -- Dodgin's Don't Die Rocket Govenor - Cruise Control Edition
    if isBoosting and not VanillaRockets then 
        local speed = vec3(core.getVelocity()):len()
        local maxSpeedLag = 0.15
        if Nav.axisCommandManager:getAxisCommandType(0) == 1 then -- Cruise control rocket boost assist, Dodgin's modified.
            local cc_speed = Nav.axisCommandManager:getTargetSpeed(axisCommandId.longitudinal)
            if speed * 3.6 > (cc_speed * (1 - maxSpeedLag)) and IsRocketOn then
                IsRocketOn = false
                Nav:toggleBoosters()
            elseif speed * 3.6 < (cc_speed * (1 - maxSpeedLag)) and not IsRocketOn then
                IsRocketOn = true
                Nav:toggleBoosters()
            end
        else -- Atmosphere Rocket Boost Assist Not in Cruise Control by Azraeil
            local throttle = unit.getThrottle()
            local targetSpeed = (throttle/100)
            if atmosphere == 0 then
                targetSpeed = targetSpeed * MaxGameVelocity
                if speed >= (targetSpeed * (1- maxSpeedLag)) and IsRocketOn then
                    IsRocketOn = false
                    Nav:toggleBoosters()
                elseif speed < (targetSpeed * (1- maxSpeedLag)) and not IsRocketOn then
                    IsRocketOn = true
                    Nav:toggleBoosters()
                end
            else
                targetSpeed = targetSpeed * ReentrySpeed / 3.6 -- 1100km/hr being max safe speed in atmo for most ships
                if speed >= (targetSpeed * (1- maxSpeedLag)) and IsRocketOn then
                    IsRocketOn = false
                    Nav:toggleBoosters()
                elseif speed < (targetSpeed * (1- maxSpeedLag)) and not IsRocketOn then 
                    IsRocketOn = true
                    Nav:toggleBoosters()
                end
            end
        end
    end
end

function script.onUpdate()
    if not SetupComplete then
        local _, result = coroutine.resume(beginSetup)
        if result then
            SetupComplete = true
        end
    else
        Nav:update()
        if not Animating and content ~= LastContent then
            system.setScreen(content)
        end
        LastContent = content
    end
end

function script.onActionStart(action)
    if action == "gear" then
        --if hasGear then
        --    GearExtended = (Nav.control.isAnyLandingGearExtended() == 1)
        --else
            GearExtended = not GearExtended
        --end    
        
        if GearExtended then
            VectorToTarget = false
            LockPitch = nil
            if Nav.axisCommandManager:getAxisCommandType(0) == 1 then
                Nav.control.cancelCurrentControlMasterMode()
            end
            Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0)
            if (vBooster or hover) and hovGndDet == -1 and (atmosphere() > 0 or coreAltitude < ReentryAltitude) then
                StrongBrakes = ((planet.gravity * 9.80665 * constructMass()) < LastMaxBrakeInAtmo)
                if not StrongBrakes and velMag > minAutopilotSpeed then
                    msgText = "WARNING: Insufficient Brakes - Attempting landing anyway"
                end
                Reentry = false
                AutoTakeoff = false
                AltitudeHold = false
                BrakeLanding = true
                autoRoll = true
                GearExtended = false -- Don't actually toggle the gear yet though
            else
                BrakeIsOn = true
                Nav.control.extendLandingGears()
                Nav.axisCommandManager:setTargetGroundAltitude(LandingGearGroundHeight)
            end

            if hasGear and not BrakeLanding then
                Nav.control.extendLandingGears() -- Actually extend
            end
        else
            if hasGear then
                Nav.control.retractLandingGears()
            end
            Nav.axisCommandManager:setTargetGroundAltitude(TargetHoverHeight)
        end
    elseif action == "light" then
        if Nav.control.isAnyHeadlightSwitchedOn() == 1 then
            Nav.control.switchOffHeadlights()
        else
            Nav.control.switchOnHeadlights()
        end
    elseif action == "forward" then
        pitchInput = pitchInput - 1
    elseif action == "backward" then
        pitchInput = pitchInput + 1
    elseif action == "left" then
        rollInput = rollInput - 1
    elseif action == "right" then
        rollInput = rollInput + 1
    elseif action == "yawright" then
        yawInput = yawInput - 1
    elseif action == "yawleft" then
        yawInput = yawInput + 1
    elseif action == "straferight" then
        Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.lateral, 1.0)
    elseif action == "strafeleft" then
        Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.lateral, -1.0)
    elseif action == "up" then
        upAmount = upAmount + 1
        Nav.axisCommandManager:deactivateGroundEngineAltitudeStabilization()
        Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.vertical, 1.0)
    elseif action == "down" then
        upAmount = upAmount - 1
        Nav.axisCommandManager:deactivateGroundEngineAltitudeStabilization()
        Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.vertical, -1.0)
    elseif action == "groundaltitudeup" then
        OldButtonMod = holdAltitudeButtonModifier
        OldAntiMod = antiGravButtonModifier
        if antigrav and not ExternalAGG and antigrav.getState() == 1 then
            if AntigravTargetAltitude ~= nil  then
                if AltitudeHold and AntigravTargetAltitude < HoldAltitude + 10 and AntigravTargetAltitude > HoldAltitude - 10 then 
                    AntigravTargetAltitude = AntigravTargetAltitude + antiGravButtonModifier
                    HoldAltitude = AntigravTargetAltitude
                else
                    AntigravTargetAltitude = AntigravTargetAltitude + antiGravButtonModifier
                end
            else
                AntigravTargetAltitude = desiredBaseAltitude + 100
            end
        elseif AltitudeHold then
            HoldAltitude = HoldAltitude + holdAltitudeButtonModifier
        else
            Nav.axisCommandManager:updateTargetGroundAltitudeFromActionStart(1.0)
        end
    elseif action == "groundaltitudedown" then
        OldButtonMod = holdAltitudeButtonModifier
        OldAntiMod = antiGravButtonModifier
        if antigrav and not ExternalAGG and antigrav.getState() == 1 then
            if AntigravTargetAltitude ~= nil then
                if AltitudeHold and AntigravTargetAltitude < HoldAltitude + 10 and AntigravTargetAltitude > HoldAltitude - 10 then 
                    AntigravTargetAltitude = AntigravTargetAltitude - antiGravButtonModifier
                    if AntigravTargetAltitude < 1000 then AntigravTargetAltitude = 1000 end
                    HoldAltitude = AntigravTargetAltitude
                else
                    AntigravTargetAltitude = AntigravTargetAltitude - antiGravButtonModifier
                    if AntigravTargetAltitude < 1000 then AntigravTargetAltitude = 1000 end
                end
            else
                AntigravTargetAltitude = desiredBaseAltitude
            end
        elseif AltitudeHold then
            HoldAltitude = HoldAltitude - holdAltitudeButtonModifier
        else
            Nav.axisCommandManager:updateTargetGroundAltitudeFromActionStart(-1.0)
        end
    elseif action == "option1" then
        IncrementAutopilotTargetIndex()
        toggleView = false
    elseif action == "option2" then
        DecrementAutopilotTargetIndex()
        toggleView = false
    elseif action == "option3" then
        if hideHudOnToggleWidgets then
            if showHud then
                showHud = false
            else
                showHud = true
            end
        end
        toggleView = false
        ToggleWidgets()
    elseif action == "option4" then
        ToggleAutopilot()
        toggleView = false
    elseif action == "option5" then
        ToggleLockPitch()
        toggleView = false
    elseif action == "option6" then
        ToggleAltitudeHold()
        toggleView = false
    elseif action == "option7" then
        wipeSaveVariables()
        toggleView = false
    elseif action == "option8" then
        ToggleFollowMode()
        toggleView = false
    elseif action == "option9" then
        if gyro ~= nil then
            gyro.toggle()
            gyroIsOn = gyro.getState() == 1
        end
        toggleView = false
    elseif action == "lshift" then
        if system.isViewLocked() == 1 then
            holdingCtrl = true
            PrevViewLock = system.isViewLocked()
            system.lockView(1)
        elseif isRemote() == 1 and ShiftShowsRemoteButtons then
            holdingCtrl = true
            Animated = false
            Animating = false
        end
    elseif action == "brake" then
        if BrakeToggleStatus then
            BrakeToggle()
        elseif not BrakeIsOn then
            BrakeToggle() -- Trigger the cancellations
        else
            BrakeIsOn = true -- Should never happen
        end
    elseif action == "lalt" then
        if isRemote() == 0 and not freeLookToggle and userControlScheme == "keyboard" then
            system.lockView(1)
        end
    elseif action == "booster" then
        -- Dodgin's Don't Die Rocket Govenor - Cruise Control Edition
        if VanillaRockets then 
            Nav:toggleBoosters()
        elseif not isBoosting then 
           if not IsRocketOn then 
               Nav:toggleBoosters()
               IsRocketOn = true
           end
           isBoosting = true
       else
           if IsRocketOn then
               Nav:toggleBoosters()
               IsRocketOn = false
           end
           isBoosting = false
       end
    elseif action == "stopengines" then
        Nav.axisCommandManager:resetCommand(axisCommandId.longitudinal)
        clearAll()
    elseif action == "speedup" then
        if not holdingCtrl then
            Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.longitudinal, speedChangeLarge)
        else
            IncrementAutopilotTargetIndex()
        end
    elseif action == "speeddown" then
        if not holdingCtrl then
            Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.longitudinal, -speedChangeLarge)
        else
            DecrementAutopilotTargetIndex()
        end
    elseif action == "antigravity" and not ExternalAGG then
        if antigrav ~= nil then
            ToggleAntigrav()
        end
    end
end

function script.onActionStop(action)
    if action == "forward" then
        pitchInput = 0
    elseif action == "backward" then
        pitchInput = 0
    elseif action == "left" then
        rollInput = 0
    elseif action == "right" then
        rollInput = 0
    elseif action == "yawright" then
        yawInput = 0
    elseif action == "yawleft" then
        yawInput = 0
    elseif action == "straferight" then
        Nav.axisCommandManager:updateCommandFromActionStop(axisCommandId.lateral, -1.0)
    elseif action == "strafeleft" then
        Nav.axisCommandManager:updateCommandFromActionStop(axisCommandId.lateral, 1.0)
    elseif action == "up" then
        upAmount = 0
        Nav.axisCommandManager:updateCommandFromActionStop(axisCommandId.vertical, -1.0)
        Nav.axisCommandManager:activateGroundEngineAltitudeStabilization(currentGroundAltitudeStabilization)
        Nav:setEngineForceCommand('hover', vec3(), 1) 
    elseif action == "down" then
        upAmount = 0
        Nav.axisCommandManager:updateCommandFromActionStop(axisCommandId.vertical, 1.0)
        Nav.axisCommandManager:activateGroundEngineAltitudeStabilization(currentGroundAltitudeStabilization)
        Nav:setEngineForceCommand('hover', vec3(), 1) 
    elseif action == "groundaltitudeup" then
        if antigrav and not ExternalAGG and antigrav.getState() == 1 then
            antiGravButtonModifier = OldAntiMod
        end
        if AltitudeHold then
            holdAltitudeButtonModifier = OldButtonMod
        end
        toggleView = false
    elseif action == "groundaltitudedown" then
        if antigrav and not ExternalAGG and antigrav.getState() == 1 then
            antiGravButtonModifier = OldAntiMod
        end
        if AltitudeHold then
            holdAltitudeButtonModifier = OldButtonMod
        end
        toggleView = false
    elseif action == "lshift" then
        if system.isViewLocked() == 1 then
            holdingCtrl = false
            simulatedX = 0
            simulatedY = 0 -- Reset for steering purposes
            system.lockView(PrevViewLock)
        elseif isRemote() == 1 and ShiftShowsRemoteButtons then
            holdingCtrl = false
            Animated = false
            Animating = false
        end
    elseif action == "brake" then
        if not BrakeToggleStatus then
            if BrakeIsOn then
                BrakeToggle()
            else
                BrakeIsOn = false -- Should never happen
            end
        end
    elseif action == "lalt" then
        if isRemote() == 0 and freeLookToggle then
            if toggleView then
                if system.isViewLocked() == 1 then
                    system.lockView(0)
                else
                    system.lockView(1)
                end
            else
                toggleView = true
            end
        elseif isRemote() == 0 and not freeLookToggle and userControlScheme == "keyboard" then
            system.lockView(0)
        end
    end
end

function script.onActionLoop(action)
    if action == "groundaltitudeup" then
        if antigrav and not ExternalAGG and antigrav.getState() == 1 then
            if AntigravTargetAltitude ~= nil then 
                if AltitudeHold and AntigravTargetAltitude < HoldAltitude + 10 and AntigravTargetAltitude > HoldAltitude - 10 then 
                    AntigravTargetAltitude = AntigravTargetAltitude + antiGravButtonModifier
                    HoldAltitude = AntigravTargetAltitude
                else
                    AntigravTargetAltitude = AntigravTargetAltitude + antiGravButtonModifier
                end
                antiGravButtonModifier = antiGravButtonModifier * 1.05
                BrakeIsOn = false
            else
                AntigravTargetAltitude = desiredBaseAltitude + 100
                BrakeIsOn = false
            end
        elseif AltitudeHold then
            HoldAltitude = HoldAltitude + holdAltitudeButtonModifier
            holdAltitudeButtonModifier = holdAltitudeButtonModifier * 1.05
        else
            Nav.axisCommandManager:updateTargetGroundAltitudeFromActionLoop(1.0)
        end
    elseif action == "groundaltitudedown" then
        if antigrav and not ExternalAGG and antigrav.getState() == 1 then
            if AntigravTargetAltitude ~= nil then
                if AltitudeHold and AntigravTargetAltitude < HoldAltitude + 10 and AntigravTargetAltitude > HoldAltitude - 10 then 
                    AntigravTargetAltitude = AntigravTargetAltitude - antiGravButtonModifier
                    if AntigravTargetAltitude < 1000 then AntigravTargetAltitude = 1000 end
                    HoldAltitude = AntigravTargetAltitude
                else
                    AntigravTargetAltitude = AntigravTargetAltitude - antiGravButtonModifier
                    if AntigravTargetAltitude < 1000 then AntigravTargetAltitude = 1000 end
                end
                antiGravButtonModifier = antiGravButtonModifier * 1.05
                BrakeIsOn = false
            else
                AntigravTargetAltitude = desiredBaseAltitude - 100
                BrakeIsOn = false
            end
        elseif AltitudeHold then
            HoldAltitude = HoldAltitude - holdAltitudeButtonModifier
            holdAltitudeButtonModifier = holdAltitudeButtonModifier * 1.05
        else
            Nav.axisCommandManager:updateTargetGroundAltitudeFromActionLoop(-1.0)
        end
    elseif action == "speedup" then
        if not holdingCtrl then
            Nav.axisCommandManager:updateCommandFromActionLoop(axisCommandId.longitudinal, speedChangeSmall)
        end
    elseif action == "speeddown" then
        if not holdingCtrl then
            Nav.axisCommandManager:updateCommandFromActionLoop(axisCommandId.longitudinal, -speedChangeSmall)
        end
    end
end

function script.onInputText(text)
    local i
    local commands = "/commands /setname /G /agg /addlocation /copydatabank"
    local command, arguement = nil, nil
    local commandhelp = "Command List:\n/commands \n/setname <newname> - Updates current selected saved position name\n/G VariableName newValue - Updates global variable to new value\n"..
            "/G dump - shows all updatable variables with /G\n/agg <targetheight> - Manually set agg target height\n"..
            "/addlocation savename ::pos{0,2,46.4596,-155.1799,22.6572} - adds a saved location by waypoint, not as accurate as making one at location\n"..
            "/copydatabank - copies dbHud databank to a blank databank"
    i = string.find(text, " ")
    command = text
    if i ~= nil then
        command = string.sub(text, 0, i-1)
        arguement = string.sub(text, i+1)
    elseif not string.find(commands, command) then
        for str in string.gmatch(commandhelp, "([^\n]+)") do
            sprint(str)
        end
        return
    end
    if command == "/setname" then 
        if arguement == nil or arguement == "" then
            msgText = "Usage: /setname Newname"
            return
        end
        if AutopilotTargetIndex > 0 and CustomTarget ~= nil then
            UpdatePosition(arguement)
        else
            msgText = "Select a saved target to rename first"
        end
    elseif command == "/addlocation" then
        if arguement == nil or arguement == "" or string.find(arguement, "::") == nil then
            msgText = "Usage: /addlocation savename ::pos{0,2,46.4596,-155.1799,22.6572}"
            return
        end
        i = string.find(arguement, "::")
        local savename = string.sub(arguement, 1, i-2)
        local pos = string.sub(arguement, i)
        local num        = ' *([+-]?%d+%.?%d*e?[+-]?%d*)'
        local posPattern = '::pos{' .. num .. ',' .. num .. ',' ..  num .. ',' .. num ..  ',' .. num .. '}'    
        local systemId, bodyId, latitude, longitude, altitude = string.match(pos, posPattern);
        local planet = atlas[tonumber(systemId)][tonumber(bodyId)]
        AddNewLocationByWaypoint(savename, planet, pos)   
        msgText = "Added "..savename.." to saved locations,\nplanet "..planet.name.." at "..pos
        msgTimer = 5    
    elseif command == "/agg" then
        if arguement == nil or arguement == "" then
            msgText = "Usage: /agg targetheight"
            return
        end
        arguement = tonumber(arguement)
        if arguement < 1000 then arguement = 1000 end
        AntigravTargetAltitude = arguement
        msgText = "AGG Target Height set to "..arguement
    elseif command == "/G" then
        if arguement == nil or arguement == "" then
            msgText = "Usage: /G VariableName variablevalue\n/G dump - shows all variables"
            return
        end
        if arguement == "dump" then
            for k, v in pairs(saveableVariables) do
                if type(_G[v]) == "boolean" then
                    if _G[v] == true then
                        sprint(v.." true")
                    else
                        sprint(v.." false")
                    end
                elseif _G[v] == nil then
                    sprint(v.." nil")
                else
                    sprint(v.." ".._G[v])
                end
            end
            return
        end
        i = string.find(arguement, " ")
        local globalVariableName = string.sub(arguement,0, i-1)
        local newGlobalValue = string.sub(arguement,i+1)
        for k, v in pairs(saveableVariables) do
            if v == globalVariableName then
                msgText = "Variable "..globalVariableName.." changed to "..newGlobalValue
                local varType = type(_G[v])
                if varType == "number" then
                    newGlobalValue = tonumber(newGlobalValue)
                elseif varType == "boolean" then
                    if string.lower(newGlobalValue) == "true" then
                        newGlobalValue = true
                    else
                        newGlobalValue = false
                    end
                end
                _G[v] = newGlobalValue
                return
            end
        end
        msgText = "No such global variable: "..globalVariableName
    elseif command == "/copydatabank" then 
        if dbHud_2 then 
            SaveDataBank(true) 
        else
            msgText = "Databank required to copy databank"
        end
    end
end

script.onStart()
