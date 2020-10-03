Nav = Navigator.new(system, core, unit)
Nav.axisCommandManager:setupCustomTargetSpeedRanges(axisCommandId.longitudinal, {1000, 5000, 10000, 20000, 30000})

-- Written by Dimencia.  Linked sources where appropriate, most have been modified.  HUD by Archeageo

-- USER DEFINABLE GLOBAL AND LOCAL VARIABLES THAT SAVE
AutopilotTargetOrbit = 100000 -- export: How far you want the orbit to be from the planet in m.  200,000 = 1SU
warmup = 32 -- export: How long it takes your engines to warmup.  Basic Space Engines, from XS to XL: 0.25,1,4,16,32
PrimaryR = 130 -- export: Primary HUD color
PrimaryG = 224 -- export: Primary HUD color
PrimaryB = 255 -- export: Primary HUD color
userControlScheme = "Virtual Joystick" -- export: Set to "Virtual Joystick", "Mouse", or "Keyboard"
freeLookToggle = true -- export: Set to false for default free look behavior.
brakeToggle = true -- export: Set to false to use hold to brake vice toggle brake.
apTickRate = 0.0166667 -- export: Set the Tick Rate for your HUD.  0.016667 is effectively 60 fps and the default value. 0.03333333 is 30 fps.  The bigger the number the less often the autopilot and hud updates but may help peformance on slower machings.
MaxGameVelocity = 8333.05 -- export: Max speed for your autopilot in m/s, do not go above 8333.055 (30000 km/hr), use 6944.4444 for 25000km/hr
AutoTakeoffAltitude = 1000 -- export: How high above your starting position AutoTakeoff tries to put you
DeadZone = 50 -- export: Number of pixels of deadzone at the center of the screen
MouseYSensitivity = 0.003 -- export:1 For virtual joystick only
MouseXSensitivity = 0.003 -- export: For virtual joystick only
circleRad = 99 -- export: The size of the artifical horizon circle, set to 0 to remove.
autoRoll = false -- export: [Only in atmosphere]<br>When the pilot stops rolling,  flight model will try to get back to horizontal (no roll)
showHud = true -- export: Uncheck to hide the HUD and only use autopilot features via ALT+# keys.
hideHudOnToggleWidgets = true -- export: Uncheck to keep showing HUD when you toggle on the widgets via ALT+3.
fuelTankOptimization = 0 -- export: For accurate fuel levels, set this to the fuel tank optimization level * 0.05 (so level 1 = 0.05, level 5 = 0.25) of the person who placed the tank. This will be 0 for most people for now.
RemoteFreeze = false -- export: Whether or not to freeze you when using a remote controller.  Breaks some things, only freeze on surfboards
pitchSpeedFactor = 0.8 -- export: For keyboard control
yawSpeedFactor = 1 -- export: For keyboard control
rollSpeedFactor = 1.5 -- export: This factor will increase/decrease the player input along the roll axis<br>(higher value may be unstable)<br>Valid values: Superior or equal to 0.01
brakeSpeedFactor = 3 -- export: When braking, this factor will increase the brake force by brakeSpeedFactor * velocity<br>Valid values: Superior or equal to 0.01
brakeFlatFactor = 1 -- export: When braking, this factor will increase the brake force by a flat brakeFlatFactor * velocity direction><br>(higher value may be unstable)<br>Valid values: Superior or equal to 0.01
autoRollFactor = 2 -- export: [Only in atmosphere]<br>When autoRoll is engaged, this factor will increase to strength of the roll back to 0<br>Valid values: Superior or equal to 0.01
turnAssist = true -- export: [Only in atmosphere]<br>When the pilot is rolling, the flight model will try to add yaw and pitch to make the construct turn better<br>The flight model will start by adding more yaw the more horizontal the construct is and more pitch the more vertical it is
turnAssistFactor = 2 -- export: [Only in atmosphere]<br>This factor will increase/decrease the turnAssist effect<br>(higher value may be unstable)<br>Valid values: Superior or equal to 0.01
TargetHoverHeight = 50 -- export: Hover height when retracting landing gear
AutopilotInterplanetaryThrottle = 100 -- export: How much throttle, in percent, you want it to use when autopiloting to another planet
ShiftShowsRemoteButtons = true -- export: Whether or not pressing Shift in remote controller mode shows you the buttons (otherwise no access to them)
DampingMultiplier = 40 -- export: How strongly autopilot dampens when nearing the correct orientation

-- GLOBAL VARIABLES SECTION, IF NOT USED OUTSIDE UNIT.START, MAKE IT LOCAL
MinAutopilotSpeed = 55 -- Minimum speed for autopilot to maneuver in m/s.  Keep above 25m/s to prevent nosedives when boosters kick in
LastMaxBrake = 0
mousePitchFactor = 1 -- Mouse control only
mouseYawFactor = 1 -- Mouse control only
hasGear = false
pitchInput = 0
rollInput = 0
yawInput = 0
brakeInput = 0
pitchInput2 = 0
rollInput2 = 0
yawInput2 = 0
BrakeIsOn = false
RetrogradeIsOn = false
ProgradeIsOn = false
AutoBrake = false
Autopilot = false
FollowMode = false
TurnBurn = false
AltitudeHold = false
AutoLanding = false
AutoTakeoff = false
HoldAltitude = 1000 -- In case something goes wrong, give this a decent start value
AutopilotAccelerating = false
AutopilotBraking = false
AutopilotCruising = false
AutopilotRealigned = false
AutopilotEndSpeed = 0
AutopilotStatus = "Aligning"
simulatedX = 0
simulatedY = 0
HoldingCtrl = false
PrevViewLock = 1
PreviousYawAmount = 0
PreviousPitchAmount = 0
msgText = "empty"
msgTimer = 3
targetGroundAltitude = nil -- So it can tell if one loaded or not
gearExtended = nil
LastEccentricity = 1
HoldAltitudeButtonModifier = 5
isBoosting = false -- Dodgin's Don't Die Rocket Govenor - Cruise Control Edition
distance = 0
brakeDistance, brakeTime = 0
maxBrakeDistance, maxBrakeTime = 0
hasGear = false
hasDB = false
hasSpaceRadar = false
hasAtmoRadar = false
damageMessage = [[]]
radarMessage = [[]]
peris = 0
BrakeButtonHovered = false
RetrogradeButtonHovered = false
ProgradeButtonHovered = false
AutopilotButtonHovered = false
TurnBurnButtonHovered = false
FollowModeButtonHovered = false
AltitudeHoldButtonHovered = false
LandingButtonHovered = false
TakeoffButtonHovered = false
AutopilotTargetIndex = 0
AutopilotTargetName = "None"
AutopilotTargetPlanet = nil
AutopilotPlanetGravity = 0
UnitHidden = true
ResetAutoVars = false
core_altitude = core.getAltitude()
elementsID = core.getElementIdList()
-- Do not save these, they contain elementID's which can change.
atmoTanks = {}
spaceTanks = {}
rocketTanks = {}

-- updateHud() variables
rgb =
    [[rgb(]] .. math.floor(PrimaryR + 0.5) .. "," .. math.floor(PrimaryG + 0.5) .. "," .. math.floor(PrimaryB + 0.5) ..
        [[)]]
rgbdim = [[rgb(]] .. math.floor(PrimaryR * 0.9 + 0.5) .. "," .. math.floor(PrimaryG * 0.9 + 0.5) .. "," ..
             math.floor(PrimaryB * 0.9 + 0.5) .. [[)]]
rgbdimmer = [[rgb(]] .. math.floor(PrimaryR * 0.8 + 0.5) .. "," .. math.floor(PrimaryG * 0.8 + 0.5) .. "," ..
                math.floor(PrimaryB * 0.8 + 0.5) .. [[)]]
UpdateCount = 0
titlecolR = rgb
titlecol = rgb
titlecolS = rgb
fuelTimeLeftR = {}
fuelPercentR = {}
FuelUpdateDelay = math.floor(1 / apTickRate) * 2
fuelTimeLeftS = {}
fuelPercentS = {}
fuelTimeLeft = {}
fuelPercent = {}
updateTanks = false

-- LOCAL VARIABLES, USERS DO NOT CHANGE
local AutopilotStrength = 1 -- How strongly autopilot tries to point at a target
local alignmentTolerance = 0.001 -- How closely it must align to a planet before accelerating to it
local ResolutionWidth = 2560
local ResolutionHeight = 1440
local ButtonBrakeWidth = 260 -- Size and positioning for brake button
local ButtonBrakeHeight = 50 -- Size and positioning for brake button
local ButtonBrakeX = ResolutionWidth / 2 - ButtonBrakeWidth / 2 -- Size and positioning for brake button
local ButtonBrakeY = ResolutionHeight / 2 - ButtonBrakeHeight + 400 -- Size and positioning for brake button
local ButtonProgradeWidth = 260 -- Size and positioning for prograde button
local ButtonProgradeHeight = 50 -- Size and positioning for prograde button       
local ButtonProgradeX = ResolutionWidth / 2 - ButtonProgradeWidth / 2 - ButtonBrakeWidth - 50 -- Size and positioning for prograde button
local ButtonProgradeY = ResolutionHeight / 2 - ButtonProgradeHeight + 380 -- Size and positioning for prograde button
local ButtonRetrogradeWidth = 260 -- Size and positioning for retrograde button
local ButtonRetrogradeHeight = 50 -- Size and positioning for retrograde button       
local ButtonRetrogradeX = ResolutionWidth / 2 - ButtonRetrogradeWidth / 2 + ButtonBrakeWidth + 50 -- Size and positioning for retrograde button
local ButtonRetrogradeY = ResolutionHeight / 2 - ButtonRetrogradeHeight + 380 -- Size and positioning for retrograde button
local ButtonAutopilotWidth = 600 -- Size and positioning for autopilot button
local ButtonAutopilotHeight = 60 -- Size and positioning for autopilot button
local ButtonAutopilotX = ResolutionWidth / 2 - ButtonAutopilotWidth / 2
local ButtonAutopilotY = ResolutionHeight / 2 - ButtonAutopilotHeight / 2 - 400
local ButtonTurnBurnWidth = 300 -- Size and positioning for TurnBurn button
local ButtonTurnBurnHeight = 60 -- Size and positioning for TurnBurn button
local ButtonTurnBurnX = 10
local ButtonTurnBurnY = ResolutionHeight / 2 - 300
local ButtonAltitudeHoldWidth = 300 -- Size and positioning for AltitudeHold button
local ButtonAltitudeHoldHeight = 60 -- Size and positioning for AltitudeHold button
local ButtonAltitudeHoldX = ButtonTurnBurnX + ButtonTurnBurnWidth + 20
local ButtonAltitudeHoldY = ButtonTurnBurnY
local ButtonLandingWidth = 300 -- Size and positioning for Landing button
local ButtonLandingHeight = 60 -- Size and positioning for Landing button
local ButtonLandingX = ButtonTurnBurnX
local ButtonLandingY = ButtonTurnBurnY + ButtonTurnBurnHeight + 20
local ButtonTakeoffWidth = 300 -- Size and positioning for Takeoff button
local ButtonTakeoffHeight = 60 -- Size and positioning for Takeoff button
local ButtonTakeoffX = ButtonTurnBurnX + ButtonTurnBurnWidth + 20
local ButtonTakeoffY = ButtonLandingY
local ButtonFollowModeWidth = 300 -- Size and positioning for FollowMode button
local ButtonFollowModeHeight = 60 -- Size and positioning for FollowMode button
local ButtonFollowModeX = ButtonTurnBurnX
local ButtonFollowModeY = ButtonTakeoffY + ButtonTakeoffHeight + 20
local minAtlasX = nil
local maxAtlasX = nil
local minAtlasY = nil
local maxAtlasY = nil
local valuesAreSet = false

-- VARIABLES TO BE SAVED GO HERE
SaveableVariables = {"userControlScheme", "AutopilotTargetOrbit", "apTickRate", "brakeToggle", "freeLookToggle",
                     "turnAssist", "PrimaryR", "PrimaryG", "PrimaryB", "warmup", "DeadZone", "circleRad",
                     "MouseXSensitivity", "MouseYSensitivity", "MaxGameVelocity", "showHud", "autoRoll",
                     "pitchSpeedFactor", "yawSpeedFactor", "rollSpeedFactor", "brakeSpeedFactor", "brakeFlatFactor",
                     "autoRollFactor", "turnAssistFactor", "torqueFactor", "AutoTakeoffAltitude", "TargetHoverHeight",
                     "AutopilotInterplanetaryThrottle", "hideHudOnToggleWidgets", "DampingMultiplier",
                     "fuelTankOptimization", "RemoteFreeze"}
AutoVariables = {"OldAutoRoll", "hasGear", "BrakeIsOn", "RetrogradeIsOn", "ProgradeIsOn", "AutoBrake", "Autopilot",
                 "FollowMode", "TurnBurn", "AltitudeHold", "AutoLanding", "AutoTakeoff", "HoldAltitude",
                 "AutopilotAccelerating", "AutopilotBraking", "AutopilotCruising", "AutopilotRealigned",
                 "AutopilotEndSpeed", "AutopilotStatus", "AutopilotPlanetGravity", "PrevViewLock",
                 "AutopilotTargetName", "AutopilotTargetPlanet", "AutopilotTargetCoords", "AutopilotTargetIndex",
                 "gearExtended", "targetGroundAltitude"}

-- BEGIN CONDITIONAL CHECKS DURING STARTUP
-- Load Saved Variables
if dbHud then
    for k, v in pairs(SaveableVariables) do
        if dbHud.hasKey(v) then
            local result = json.decode(dbHud.getStringValue(v))
            if result ~= nil then
                _G[v] = result
                valuesAreSet = true
            end
        end
    end
    for k, v in pairs(AutoVariables) do
        if dbHud.hasKey(v) then
            local result = json.decode(dbHud.getStringValue(v))
            if result ~= nil then
                _G[v] = result
            end
        end
    end
    if valuesAreSet then
        msgText = "Loaded Saved Variables"
    else
        msgText = "No Saved Variables Found - Use Alt-7 to save your LUA parameters"
    end
else
    msgText = "No databank found"
end

for k in pairs(elementsID) do
    local name = core.getElementTypeById(elementsID[k])
    if (name == "landing gear") then
        hasGear = true
    end
    if (name == "atmospheric fuel-tank" or name == "space fuel-tank" or name == "rocket fuel-tank") then
        local hp = core.getElementMaxHitPointsById(elementsID[k])
        local mass = core.getElementMassById(elementsID[k])
        local curMass = 0
        local curTime = system.getTime()
        if (name == "atmospheric fuel-tank") then
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
            name = core.getElementNameById(elementsID[k])
            curMass = mass - massEmpty
            if curMass > vanillaMaxVolume then
                vanillaMaxVolume = curMass
            end
            atmoTanks[#atmoTanks + 1] = {elementsID[k], core.getElementNameById(elementsID[k]), vanillaMaxVolume,
                                         massEmpty, curMass, curTime}
        end
        if (name == "rocket fuel-tank") then
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
            name = core.getElementNameById(elementsID[k])
            curMass = mass - massEmpty
            if curMass > vanillaMaxVolume then
                vanillaMaxVolume = curMass
            end
            rocketTanks[#rocketTanks + 1] = {elementsID[k], core.getElementNameById(elementsID[k]), vanillaMaxVolume,
                                             massEmpty, curMass, curTime}
        end
        if (name == "space fuel-tank") then
            local vanillaMaxVolume = 2400
            local massEmpty = 187.67
            if hp > 10000 then
                vanillaMaxVolume = 76800 -- volume in kg of L tank
                massEmpty = 5480
            elseif hp > 1300 then
                vanillaMaxVolume = 9600 -- volume in kg of M
                massEmpty = 988.67
            end
            name = core.getElementNameById(elementsID[k])
            curMass = mass - massEmpty
            if curMass > vanillaMaxVolume then
                vanillaMaxVolume = curMass
            end
            spaceTanks[#spaceTanks + 1] = {elementsID[k], core.getElementNameById(elementsID[k]), vanillaMaxVolume,
                                           massEmpty, curMass, curTime}
        end
    end
end

if userControlScheme ~= "Keyboard" then
    system.lockView(1)
else
    system.lockView(0)
end
if unit.getAtmosphereDensity() > 0 then
    BrakeIsOn = true
end
if radar_1 then
    if core.getElementTypeById(radar_1.getId()) == "Space Radar" then
        hasSpaceRadar = true
    else
        hasAtmoRadar = true
    end
end
-- Close door and retract ramp if available
if door then
    for _, v in pairs(door) do
        v.deactivate()
    end
end
if forcefield then
    for _, v in pairs(forcefield) do
        v.deactivate()
    end
end
_autoconf.displayCategoryPanel(weapon, weapon_size, L_TEXT("ui_lua_widget_weapon", "Weapons"), "weapon", true)
if antigrav ~= nil then
    antigrav.show()
end
if warpdrive ~= nil then
    warpdrive.show()
end
-- unfreeze the player if he is remote controlling the construct
if Nav.control.isRemoteControlled() == 1 and RemoteFreeze then
    system.freeze(1)
else
    system.freeze(0)
end
if targetGroundAltitude ~= nil then
    Nav.axisCommandManager:setTargetGroundAltitude(targetGroundAltitude)
end
if hasGear then
    if gearExtended == nil then
        gearExtended = (Nav.control.isAnyLandingGearExtended() == 1) -- make sure it's a lua boolean
        -- make sure it's a lua boolean
        if gearExtended then
            Nav.control.extendLandingGears()
        else
            Nav.control.retractLandingGears()
        end
    end
    if targetGroundAltitude == nil then
        if gearExtended then
            Nav.axisCommandManager:setTargetGroundAltitude(0)
        else
            Nav.axisCommandManager:setTargetGroundAltitude(TargetHoverHeight)
        end
    end
elseif targetGroundAltitude == nil then
    if unit.getAtmosphereDensity() == 0 then
        gearExtended = false
        Nav.axisCommandManager:setTargetGroundAltitude(TargetHoverHeight)
    else
        gearExtended = true -- Show warning message and set behavior
        Nav.axisCommandManager:setTargetGroundAltitude(0)
    end
end
if unit.getAtmosphereDensity() > 0 and not dbHud and (gearExtended or not hasGear) then
    BrakeIsOn = true
end

unit.hide()
unit.setTimer("apTick", apTickRate)
unit.setTimer("oneSecond", 1)

-- BEGIN FUNCTION DEFINITIONS
function DrawDeadZone()
    if system.isViewLocked() == 0 then
        content = content .. "<circle cx='50%' cy='50%' r='" .. DeadZone .. "' stroke=rgb(" ..
                      math.floor(PrimaryR * 0.3) .. "," .. math.floor(PrimaryG * 0.3) .. "," ..
                      math.floor(PrimaryB * 0.3) .. ") stroke-width='2' fill='none' />"
    else
        content = content .. "<circle cx='50%' cy='50%' r='" .. DeadZone .. "' stroke=rgb(" ..
                      math.floor(PrimaryR * 0.8) .. "," .. math.floor(PrimaryG * 0.8) .. "," ..
                      math.floor(PrimaryB * 0.8) .. ") stroke-width='2' fill='none' />"
    end
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

-- Draw vertical speed indicator - Code by lisa-lionheart 
function DrawVerticalSpeed()
    local velocity = vec3(core.getWorldVelocity())
    local up = vec3(core.getWorldVertical()) * -1
    local vSpd = (velocity.x * up.x) + (velocity.y * up.y) + (velocity.z * up.z)
    local angle = 0
    if math.abs(vSpd) > 1 then
        angle = 45 * math.log(math.abs(vSpd), 10)
        if vSpd < 0 then
            angle = -angle
        end
    end
    content = content .. [[
                        <g transform="translate(1525 250) scale(0.6)">
                            <g font-size="14px" font-family="sans-serif" fill="]] .. rgb .. [[">
                                <text x="31" y="-41">1000</text>
                                <text x="-10" y="-65">100</text>
                                <text x="-54" y="-45">10</text>
                                <text x="-73" y="3">O</text>
                                <text x="-56" y="52">-10</text>
                                <text x="-14" y="72">-100</text>
                                <text x="29" y="50">-1000</text>
                                <text x="85" y="0" font-size="20px" text-anchor="end" >]] .. math.floor(vSpd) ..
                  [[ m/s</text>
                            </g>
                            <g fill="none" stroke="]] .. rgb .. [[" stroke-width="3px">
                                <path d="m-41 75 2.5-4.4m17 12 1.2-4.9m20 7.5v-10m-75-34 4.4-2.5m-12-17 4.9-1.2m17 40 7-7m-32-53h10m34-75 2.5 4.4m17-12 1.2 4.9m20-7.5v10m-75 34 4.4 2.5m-12 17 4.9 1.2m17-40 7 7m-32 53h10m116 75-2.5-4.4m-17 12-1.2-4.9m40-17-7-7m-12-128-2.5 4.4m-17-12-1.2 4.9m40 17-7 7"/>
                                <circle r="90" />
                            </g>
                            <path transform="rotate(]] .. math.floor(angle) .. [[)" fill="]] .. rgb ..
                  [[" d="m-0.094-7c-22 2.2-45 4.8-67 7 23 1.7 45 5.6 67 7 4.4-0.068 7.8-4.9 6.3-9.1-0.86-2.9-3.7-5-6.8-4.9z" />
                        </g>
                    ]]
end

-- Interplanetary helper
function ShowInterplanetaryPanel()
    if panelInterplanetary == nil then
        panelInterplanetary = system.createWidgetPanel("Interplanetary Helper")
        interplanetaryHeader = system.createWidget(panelInterplanetary, "value")
        interplanetaryHeaderText = system.createData('{"label": "Target Planet", "value": "N/A", "unit":""}')
        system.addDataToWidget(interplanetaryHeaderText, interplanetaryHeader)
        widgetDistance = system.createWidget(panelInterplanetary, "value")
        widgetDistanceText = system.createData('{"label": "Distance", "value": "N/A", "unit":""}')
        system.addDataToWidget(widgetDistanceText, widgetDistance)
        widgetTravelTime = system.createWidget(panelInterplanetary, "value")
        widgetTravelTimeText = system.createData('{"label": "Travel Time", "value": "N/A", "unit":""}')
        system.addDataToWidget(widgetTravelTimeText, widgetTravelTime)
        widgetCurBrakeDistance = system.createWidget(panelInterplanetary, "value")
        widgetCurBrakeDistanceText = system.createData('{"label": "Cur Brake Distance", "value": "N/A", "unit":""}')
        if not InAtmo then
            system.addDataToWidget(widgetCurBrakeDistanceText, widgetCurBrakeDistance)
        end
        widgetCurBrakeTime = system.createWidget(panelInterplanetary, "value")
        widgetCurBrakeTimeText = system.createData('{"label": "Cur Brake Time", "value": "N/A", "unit":""}')
        if not InAtmo then
            system.addDataToWidget(widgetCurBrakeTimeText, widgetCurBrakeTime)
        end
        widgetMaxBrakeDistance = system.createWidget(panelInterplanetary, "value")
        widgetMaxBrakeDistanceText = system.createData('{"label": "Max Brake Distance", "value": "N/A", "unit":""}')
        if not InAtmo then
            system.addDataToWidget(widgetMaxBrakeDistanceText, widgetMaxBrakeDistance)
        end
        widgetMaxBrakeTime = system.createWidget(panelInterplanetary, "value")
        widgetMaxBrakeTimeText = system.createData('{"label": "Max Brake Time", "value": "N/A", "unit":""}')
        if not InAtmo then
            system.addDataToWidget(widgetMaxBrakeTimeText, widgetMaxBrakeTime)
        end
        widgetTrajectoryAltitude = system.createWidget(panelInterplanetary, "value")
        widgetTrajectoryAltitudeText = system.createData('{"label": "Projected Altitude", "value": "N/A", "unit":""}')
        if not InAtmo then
            system.addDataToWidget(widgetTrajectoryAltitudeText, widgetTrajectoryAltitude)
        end
    end
end

function Contains(mousex, mousey, x, y, width, height)
    if mousex > x and mousex < (x + width) and mousey > y and mousey < (y + height) then
        return true
    else
        return false
    end
end

function toggleFollowMode()
    if Nav.control.isRemoteControlled() == 1 then
        FollowMode = not FollowMode
        if FollowMode then
            Autopilot = false
            RetrogradeIsOn = false
            ProgradeIsOn = false
            AutoBrake = false
            if not AltitudeHold then
                OldAutoRoll = autoRoll
            end
            AltitudeHold = false
            AutoLanding = false
            AutoTakeoff = false
            OldGearExtended = gearExtended
            gearExtended = false
            Nav.control.retractLandingGears()
            Nav.axisCommandManager:setTargetGroundAltitude(500) -- Hard-set this for auto-follow
        else
            BrakeIsOn = true
            autoRoll = OldAutoRoll
            gearExtended = OldGearExtended
            if gearExtended then
                Nav.control.extendLandingGears()
                Nav.axisCommandManager:setTargetGroundAltitude(0)
            end
        end
    end
end

function AutopilotToggle()
    -- Toggle Autopilot, as long as the target isn't None
    if AutopilotTargetName ~= "None" and not Autopilot then
        Autopilot = true
        RetrogradeIsOn = false
        ProgradeIsOn = false
        AutopilotButtonHovered = false
        AutopilotRealigned = false
        FollowMode = false
        AltitudeHold = false
        AutoLanding = false
        AutoTakeoff = false
    else
        Autopilot = false
        AutopilotButtonHovered = false
        AutopilotRealigned = false
    end
end

function checkDamage()
    local percentDam = 0
    local color = 0
    local colorMod = [[]]
    local maxShipHP = 0
    local curShipHP = 0
    local damagedElements = 0
    local disabledElements = 0
    for k in pairs(elementsID) do
        local hp = 0
        local mhp = 0
        mhp = core.getElementMaxHitPointsById(elementsID[k])
        hp = core.getElementHitPointsById(elementsID[k])
        maxShipHP = maxShipHP + mhp
        curShipHP = curShipHP + hp
        percentDam = math.floor((curShipHP * 100 / maxShipHP))
        if (hp == 0) then
            disabledElements = disabledElements + 1
        elseif (hp < mhp) then
            damagedElements = damagedElements + 1
        end
    end
    colorMod = percentDam * 2.55
    color = [[rgb(]] .. 255 - colorMod .. "," .. colorMod .. "," .. 0 .. [[)]]
    damageMessage = [[
                        <g class="text"><g font-size=18>
                            <text x=50% y="1015" text-anchor="middle" style="fill:]] .. color ..
                        [[">Structural Integrity: ]] .. percentDam .. [[%</text>]]
    if (disabledElements > 0) then
        damageMessage = damageMessage ..
                            [[<text x=50% y="1035" text-anchor="middle" style="fill:red">Disabled Modules: ]] ..
                            disabledElements .. [[ Damaged Modules: ]] .. damagedElements .. [[</text></g></g>]]
    elseif damagedElements > 0 then
        damageMessage = damageMessage .. [[<text x=50% y="1035" text-anchor="middle" style="fill:]] .. color ..
                            [[">Damaged Modules: ]] .. damagedElements .. [[</text>
                        </g></g>]]
    end
end

function DrawCursorLine()
    local strokeColor = math.floor(utils.clamp((distance / (ResolutionWidth / 4)) * 255, 0, 255))
    content = content .. "<line x1='0' y1='0' x2='" .. simulatedX .. "px' y2='" .. simulatedY ..
                  "px' style='stroke:rgb(" .. math.floor(PrimaryR + 0.5) + strokeColor .. "," ..
                  math.floor(PrimaryG + 0.5) - strokeColor .. "," .. math.floor(PrimaryB + 0.5) - strokeColor ..
                  ");stroke-width:2;transform:translate(50%, 50%)' />"
end

function ToggleAutoBrake()
    if AutopilotTargetPlanetName ~= "None" and brakeInput == 0 and not AutoBrake then
        AutoBrake = true
        Autopilot = false
        ProgradeIsOn = false
        RetrogradeIsOn = false
        FollowMode = false
        AltitudeHold = false
        AutoLanding = false
        AutoTakeoff = false
    else
        AutoBrake = false
    end
end

function getPitch(gravityDirection, forward, right)
    local horizontalForward = gravityDirection:cross(right):normalize_inplace() -- Cross forward?
    local pitch = math.acos(utils.clamp(horizontalForward:dot(-forward), -1, 1)) * constants.rad2deg -- acos?
    
    if horizontalForward:cross(-forward):dot(right) < 0 then
        pitch = -pitch
    end -- Cross right dot forward?
    return pitch
end

function saveVariables()
    if not dbHud then
        msgText =
            "No Databank Found, unable to save. You must have a Databank attached to ship prior to running the HUD autoconfigure"
    elseif valuesAreSet then
        -- If any values are set, wipe them all
        for k, v in pairs(SaveableVariables) do
            dbHud.setStringValue(v, json.encode(nil))
        end
        -- Including the auto vars
        ResetAutoVars = true
        for k, v in pairs(AutoVariables) do
            dbHud.setStringValue(v, json.encode(nil))
        end
        msgText =
            "Databank wiped. Get out of the seat, set the savable variables, then re-enter seat and hit ALT-7 again"
    else
        for k, v in pairs(SaveableVariables) do
            dbHud.setStringValue(v, json.encode(_G[v]))
        end
        msgText = "Saved Variables to Datacore"
    end
end

function ProgradeToggle()
    -- Toggle Progrades
    ProgradeIsOn = not ProgradeIsOn
    RetrogradeIsOn = false -- Don't let both be on
    Autopilot = false
    AltitudeHold = false
    AutoBrake = false
    FollowMode = false
    AutoLanding = false
    AutoTakeoff = false
    ProgradeButtonHovered = false
    local Progradestring = "Off"
    if ProgradeIsOn then
        Progradestring = "On"
    end
end

function RetrogradeToggle()
    -- Toggle Retrogrades
    RetrogradeIsOn = not RetrogradeIsOn
    ProgradeIsOn = false -- Don't let both be on
    Autopilot = false
    AltitudeHold = false
    AutoBrake = false
    FollowMode = false
    AutoLanding = false
    AutoTakeoff = false
    RetrogradeButtonHovered = false
    local Retrogradestring = "Off"
    if RetrogradeIsOn then
        Retrogradestring = "On"
    end
end

function BrakeToggle()
    -- Toggle brakes
    BrakeIsOn = not BrakeIsOn
    BrakeButtonHovered = false
    if BrakeIsOn and not AutoTakeoff then
        -- If they turn on brakes, disable a few things
        AltitudeHold = false
        AutoTakeoff = false
        AutoLanding = false -- If they tap it, we abort, that's the way it goes.
        -- We won't abort interplanetary because that would fuck everyone.
        ProgradeIsOn = false -- No reason to brake while facing prograde, but retrograde yes.
    elseif not AutoTakeoff then
        AutoLanding = false -- If they disable during an autoland that's braking, still need to stop autoland
        AltitudeHold = false -- And stop alt hold
    end
end

function CheckButtons()
    if BrakeButtonHovered then
        brakeToggle = not brakeToggle
    end
    if ProgradeButtonHovered then
        ProgradeToggle()
    end
    if RetrogradeButtonHovered then
        RetrogradeToggle()
    end

    if AutopilotButtonHovered then
        AutopilotToggle()
    end
    if TurnBurnButtonHovered then
        ToggleTurnBurn()
    end
    if LandingButtonHovered then
        if AutoLanding then
            AutoLanding = false
            -- Don't disable alt hold for auto land
        else
            if not AltitudeHold then
                ToggleAltitudeHold()
            end
            AutoTakeoff = false
            AutoLanding = true
            Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0)
        end
    end
    if TakeoffButtonHovered then
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
            HoldAltitude = core_altitude + AutoTakeoffAltitude
            gearExtended = false
            Nav.control.retractLandingGears()
            Nav.axisCommandManager:setTargetGroundAltitude(500) -- Hard set this for takeoff, you wouldn't use takeoff from a hangar
            BrakeIsOn = true
        end
    end
    if AltitudeHoldButtonHovered then
        ToggleAltitudeHold()
    end
    if FollowModeButtonHovered then
        toggleFollowMode()
    end
    BrakeButtonHovered = false
    RetrogradeButtonHovered = false
    ProgradeButtonHovered = false
    AutopilotButtonHovered = false
    TurnBurnButtonHovered = false
    FollowModeButtonHovered = false
    AltitudeHoldButtonHovered = false
    LandingButtonHovered = false
    TakeoffButtonHovered = false -- After checking, clear our flags.
end

function SetButtonContains()
    BrakeButtonHovered = Contains(simulatedX + ResolutionWidth / 2, simulatedY + ResolutionHeight / 2, ButtonBrakeX,
                             ButtonBrakeY, ButtonBrakeWidth, ButtonBrakeHeight)
    ProgradeButtonHovered = Contains(simulatedX + ResolutionWidth / 2, simulatedY + ResolutionHeight / 2,
                                ButtonProgradeX, ButtonProgradeY, ButtonProgradeWidth, ButtonProgradeHeight)
    RetrogradeButtonHovered = Contains(simulatedX + ResolutionWidth / 2, simulatedY + ResolutionHeight / 2,
                                  ButtonRetrogradeX, ButtonRetrogradeY, ButtonRetrogradeWidth, ButtonRetrogradeHeight)
    AutopilotButtonHovered = Contains(simulatedX + ResolutionWidth / 2, simulatedY + ResolutionHeight / 2,
                                 ButtonAutopilotX, ButtonAutopilotY, ButtonAutopilotWidth, ButtonAutopilotHeight)
    AltitudeHoldButtonHovered = Contains(simulatedX + ResolutionWidth / 2, simulatedY + ResolutionHeight / 2,
                                    ButtonAltitudeHoldX, ButtonAltitudeHoldY, ButtonAltitudeHoldWidth,
                                    ButtonAltitudeHoldHeight)
    TakeoffButtonHovered = Contains(simulatedX + ResolutionWidth / 2, simulatedY + ResolutionHeight / 2, ButtonTakeoffX,
                               ButtonTakeoffY, ButtonTakeoffWidth, ButtonTakeoffHeight)
    LandingButtonHovered = Contains(simulatedX + ResolutionWidth / 2, simulatedY + ResolutionHeight / 2, ButtonLandingX,
                               ButtonLandingY, ButtonLandingWidth, ButtonLandingHeight)
    TurnBurnButtonHovered = Contains(simulatedX + ResolutionWidth / 2, simulatedY + ResolutionHeight / 2,
                                ButtonTurnBurnX, ButtonTurnBurnY, ButtonTurnBurnWidth, ButtonTurnBurnHeight)
    FollowModeButtonHovered = Contains(simulatedX + ResolutionWidth / 2, simulatedY + ResolutionHeight / 2,
                                  ButtonFollowModeX, ButtonFollowModeY, ButtonFollowModeWidth, ButtonFollowModeHeight)
    -- And... Check the map if it's up
    -- For now that's RC only
    if Nav.control.isRemoteControlled() == 1 and math.abs(simulatedX) < ResolutionWidth / 2 and math.abs(simulatedY) <
        ResolutionHeight / 2 then
        local count = 1
        local closestMatch = nil
        local distanceToClosest = nil
        for k, v in pairs(Atlas()[0]) do
            local x = v.center.x / MapXRatio -- 1.1
            
            local y = v.center.y / MapYRatio -- 1.4
            -- So our map is 30% from top, 25% from left, and it's 50% width
            -- Our simulatedX and Y are already offsets from center
            -- So if we move it down by 10% and scale it.  So fucking why doesn't it work

            local convertedX = simulatedX / 2 * 1.1
            local convertedY = 1.4 * ((simulatedY / 2) - ResolutionHeight / 20)
            local dist = math.sqrt((x - convertedX) * (x - convertedX) + (y - convertedY) * (y - convertedY))
            if distanceToClosest == nil or dist < distanceToClosest then
                closestMatch = count
                distanceToClosest = dist
            end
            count = count + 1
        end
        if distanceToClosest < 30 then
            -- AutopilotTargetIndex = closestMatch
            -- UpdateAutopilotTarget()
        end
    end
end

function DrawButtons()
    local defaultColor = "rgb(" .. 0 .. "," .. 18 .. "," .. 133 .. ")'"
    -- Brake button
    content = content .. "<rect rx='5' ry='5' x='" .. ButtonBrakeX .. "' y='" .. ButtonBrakeY .. "' width='" ..
                  ButtonBrakeWidth .. "' height='" .. ButtonBrakeHeight .. "' fill='"
    if brakeToggle then
        content = content .. "#CC0000'" -- Red if it's on
    else
        content = content .. defaultColor
    end
    if BrakeButtonHovered then
        content = content .. " style='stroke:white; stroke-width:2'"
    else
        content = content .. " style='stroke:black; stroke-width:1'"
    end
    content = content .. "></rect>"
    content = content .. "<text x='" .. ButtonBrakeX + ButtonBrakeWidth / 2 .. "' y='" .. ButtonBrakeY +
                  (ButtonBrakeHeight / 2) + 5 .. "' font-size='24' fill='"
    if brakeToggle then
        content = content .. "black"
    else
        content = content .. "white"
    end
    content = content .. "' text-anchor='middle' font-family='Montserrat'>"
    if brakeToggle then
        content = content .. "Disable Brake Toggle</text>"
    else
        content = content .. "Enable Brake Toggle</text>"
    end
    -- Prograde button
    content = content .. "<rect rx='5' ry='5' x='" .. ButtonProgradeX .. "' y='" .. ButtonProgradeY .. "' width='" ..
                  ButtonProgradeWidth .. "' height='" .. ButtonProgradeHeight .. "' fill='"
    if ProgradeIsOn then
        content = content .. "#FFEECC'" -- Orange if it's on
    else
        content = content .. defaultColor
    end
    if ProgradeButtonHovered then
        content = content .. " style='stroke:white; stroke-width:2'"
    else
        content = content .. " style='stroke:black; stroke-width:1'"
    end
    content = content .. "></rect>"
    content = content .. "<text x='" .. ButtonProgradeX + ButtonProgradeWidth / 2 .. "' y='" .. ButtonProgradeY +
                  (ButtonProgradeHeight / 2) + 5 .. "' font-size='24' fill='"
    if ProgradeIsOn then
        content = content .. "black"
    else
        content = content .. "white"
    end
    content = content .. "' text-anchor='middle' font-family='Montserrat'>"
    if ProgradeIsOn then
        content = content .. "Disable Prograde</text>"
    else
        content = content .. "Align Prograde</text>"
    end
    -- Retrograde button
    content =
        content .. "<rect rx='5' ry='5' x='" .. ButtonRetrogradeX .. "' y='" .. ButtonRetrogradeY .. "' width='" ..
            ButtonRetrogradeWidth .. "' height='" .. ButtonRetrogradeHeight .. "' fill='"
    if RetrogradeIsOn then
        content = content .. "#42006b'" -- Purple if it's on
    else
        content = content .. defaultColor
    end
    if RetrogradeButtonHovered then
        content = content .. " style='stroke:white; stroke-width:2'"
    else
        content = content .. " style='stroke:black; stroke-width:1'"
    end
    content = content .. "></rect>"
    content = content .. "<text x='" .. ButtonRetrogradeX + ButtonRetrogradeWidth / 2 .. "' y='" .. ButtonRetrogradeY +
                  (ButtonRetrogradeHeight / 2) + 5 .. "' font-size='24' fill='"
    if RetrogradeIsOn then
        content = content .. "black"
    else
        content = content .. "white"
    end
    content = content .. "' text-anchor='middle' font-family='Montserrat'>"
    if RetrogradeIsOn then
        content = content .. "Disable Retrograde</text>"
    else
        content = content .. "Align Retrograde</text>"
    end
    -- Autopilot button
    content = content .. "<rect rx='5' ry='5' x='" .. ButtonAutopilotX .. "' y='" .. ButtonAutopilotY .. "' width='" ..
                  ButtonAutopilotWidth .. "' height='" .. ButtonAutopilotHeight .. "' fill='"
    if Autopilot then
        content = content .. "red'" -- Red if it's on
    else
        content = content .. defaultColor
    end
    if AutopilotButtonHovered then
        content = content .. " style='stroke:white; stroke-width:2'"
    else
        content = content .. " style='stroke:black; stroke-width:1'"
    end
    content = content .. "></rect>"
    content = content .. "<text x='" .. ButtonAutopilotX + ButtonAutopilotWidth / 2 .. "' y='" .. ButtonAutopilotY +
                  (ButtonAutopilotHeight / 2) + 5 .. "' font-size='22' fill='"
    if Autopilot then
        content = content .. "black"
    else
        content = content .. "white"
    end
    content = content .. "' text-anchor='middle' font-family='Montserrat'>"
    if Autopilot then
        content = content .. "Disable Autopilot</text>"
    else
        content = content .. "Engage Autopilot: " .. AutopilotTargetName .. "</text>"
    end
    -- AltitudeHold button
    content = content .. "<rect rx='5' ry='5' x='" .. ButtonAltitudeHoldX .. "' y='" .. ButtonAltitudeHoldY ..
                  "' width='" .. ButtonAltitudeHoldWidth .. "' height='" .. ButtonAltitudeHoldHeight .. "' fill='"
    if AltitudeHold then
        content = content .. "#42006b'" -- Purple if it's on
    else
        content = content .. defaultColor
    end
    if AltitudeHoldButtonHovered then
        content = content .. " style='stroke:white; stroke-width:2'"
    else
        content = content .. " style='stroke:black; stroke-width:1'"
    end
    content = content .. "></rect>"
    content = content .. "<text x='" .. ButtonAltitudeHoldX + ButtonAltitudeHoldWidth / 2 .. "' y='" ..
                  ButtonAltitudeHoldY + (ButtonAltitudeHoldHeight / 2) + 5 .. "' font-size='24' fill='"
    if AltitudeHold then
        content = content .. "black"
    else
        content = content .. "white"
    end
    content = content .. "' text-anchor='middle' font-family='Montserrat'>"
    if AltitudeHold then
        content = content .. "Disable Altitude Hold</text>"
    else
        content = content .. "Enable Altitude Hold</text>"
    end
    -- Takeoff button
    content = content .. "<rect rx='5' ry='5' x='" .. ButtonTakeoffX .. "' y='" .. ButtonTakeoffY .. "' width='" ..
                  ButtonTakeoffWidth .. "' height='" .. ButtonTakeoffHeight .. "' fill='"
    if AutoTakeoff then
        content = content .. "#42006b'" -- Purple if it's on
    else
        content = content .. defaultColor
    end
    if TakeoffButtonHovered then
        content = content .. " style='stroke:white; stroke-width:2'"
    else
        content = content .. " style='stroke:black; stroke-width:1'"
    end
    content = content .. "></rect>"
    content = content .. "<text x='" .. ButtonTakeoffX + ButtonTakeoffWidth / 2 .. "' y='" .. ButtonTakeoffY +
                  (ButtonTakeoffHeight / 2) + 5 .. "' font-size='24' fill='"
    if AutoTakeoff then
        content = content .. "black"
    else
        content = content .. "white"
    end
    content = content .. "' text-anchor='middle' font-family='Montserrat'>"
    if AutoTakeoff then
        content = content .. "Cancel Takeoff</text>"
    else
        content = content .. "Begin Takeoff</text>"
    end
    -- Landing button
    content = content .. "<rect rx='5' ry='5' x='" .. ButtonLandingX .. "' y='" .. ButtonLandingY .. "' width='" ..
                  ButtonLandingWidth .. "' height='" .. ButtonLandingHeight .. "' fill='"
    if AutoLanding then
        content = content .. "#42006b'" -- Purple if it's on
    else
        content = content .. defaultColor
    end
    if LandingButtonHovered then
        content = content .. " style='stroke:white; stroke-width:2'"
    else
        content = content .. " style='stroke:black; stroke-width:1'"
    end
    content = content .. "></rect>"
    content = content .. "<text x='" .. ButtonLandingX + ButtonLandingWidth / 2 .. "' y='" .. ButtonLandingY +
                  (ButtonLandingHeight / 2) + 5 .. "' font-size='24' fill='"
    if AutoLanding then
        content = content .. "black"
    else
        content = content .. "white"
    end
    content = content .. "' text-anchor='middle' font-family='Montserrat'>"
    if AutoLanding then
        content = content .. "Cancel Landing</text>"
    else
        content = content .. "Begin Landing</text>"
    end
    -- TurnBurn button
    content = content .. "<rect rx='5' ry='5' x='" .. ButtonTurnBurnX .. "' y='" .. ButtonTurnBurnY .. "' width='" ..
                  ButtonTurnBurnWidth .. "' height='" .. ButtonTurnBurnHeight .. "' fill='"
    if TurnBurn then
        content = content .. "#42006b'" -- Purple if it's on
    else
        content = content .. defaultColor
    end
    if TurnBurnButtonHovered then
        content = content .. " style='stroke:white; stroke-width:2'"
    else
        content = content .. " style='stroke:black; stroke-width:1'"
    end
    content = content .. "></rect>"
    content = content .. "<text x='" .. ButtonTurnBurnX + ButtonTurnBurnWidth / 2 .. "' y='" .. ButtonTurnBurnY +
                  (ButtonTurnBurnHeight / 2) + 5 .. "' font-size='24' fill='"
    if TurnBurn then
        content = content .. "black"
    else
        content = content .. "white"
    end
    content = content .. "' text-anchor='middle' font-family='Montserrat'>"
    if TurnBurn then
        content = content .. "Disable Turn&Burn</text>"
    else
        content = content .. "Enable Turn&Burn</text>"
    end
    -- FollowMode button
    content =
        content .. "<rect rx='5' ry='5' x='" .. ButtonFollowModeX .. "' y='" .. ButtonFollowModeY .. "' width='" ..
            ButtonFollowModeWidth .. "' height='" .. ButtonFollowModeHeight .. "' fill='"
    if FollowMode then
        content = content .. "#42006b'" -- Purple if it's on
    else
        content = content .. defaultColor
    end
    if FollowModeButtonHovered then
        content = content .. " style='stroke:white; stroke-width:2'"
    else
        content = content .. " style='stroke:black; stroke-width:1'"
    end
    content = content .. "></rect>"
    content = content .. "<text x='" .. ButtonFollowModeX + ButtonFollowModeWidth / 2 .. "' y='" .. ButtonFollowModeY +
                  (ButtonFollowModeHeight / 2) + 5 .. "' font-size='24' fill='"
    if FollowMode then
        content = content .. "black"
    else
        content = content .. "white"
    end
    content = content .. "' text-anchor='middle' font-family='Montserrat'>"
    if FollowMode then
        content = content .. "Disable Follow Mode</text>"
    else
        content = content .. "Enable Follow Mode</text>"
    end
end

function HideInterplanetaryPanel()
    system.destroyWidgetPanel(panelInterplanetary)
    panelInterplanetary = nil
end

function ToggleTurnBurn()
    TurnBurn = not TurnBurn
end

function ToggleAltitudeHold()
    AltitudeHold = not AltitudeHold
    if AltitudeHold then
        AutoBrake = false
        Autopilot = false
        ProgradeIsOn = false
        RetrogradeIsOn = false
        if not FollowMode then
            OldAutoRoll = autoRoll
        end
        FollowMode = false
        AutoLanding = false
        autoRoll = true
        if (not gearExtended and not BrakeIsOn) or unit.getAtmosphereDensity() == 0 then -- Never autotakeoff in space
            AutoTakeoff = false
            HoldAltitude = core_altitude
            if Nav.axisCommandManager:getAxisCommandType(0) == 0 then
                Nav.control.cancelCurrentControlMasterMode()
            end
        else
            AutoTakeoff = true
            HoldAltitude = core_altitude + AutoTakeoffAltitude
            gearExtended = false
            Nav.control.retractLandingGears()
            Nav.axisCommandManager:setTargetGroundAltitude(500)
            BrakeIsOn = true -- Engage brake for warmup
        end
    else
        autoRoll = OldAutoRoll
        AutoTakeoff = false
        AutoLanding = false
    end
end

system.showScreen(1)

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
    return math.deg(math.atan(velocity.y, velocity.x)) - 90
end

function AlignToWorldVector(vector, tolerance)
    -- Sets inputs to attempt to point at the autopilot target
    -- Meant to be called from Update or Tick repeatedly
    if tolerance == nil then
        tolerance = alignmentTolerance
    end
    vector = vec3(vector):normalize()
    local targetVec = (vec3(core.getConstructWorldOrientationForward()) - vector)
    local yawAmount = -getMagnitudeInDirection(targetVec, core.getConstructWorldOrientationRight()) * AutopilotStrength
    local pitchAmount = -getMagnitudeInDirection(targetVec, core.getConstructWorldOrientationUp()) * AutopilotStrength

    yawInput2 = yawInput2 - (yawAmount + (yawAmount - PreviousYawAmount) * DampingMultiplier)
    pitchInput2 = pitchInput2 + (pitchAmount + (pitchAmount - PreviousPitchAmount) * DampingMultiplier)
    PreviousYawAmount = yawAmount
    PreviousPitchAmount = pitchAmount
    -- Return true or false depending on whether or not we're aligned
    if math.abs(yawAmount) < tolerance and math.abs(pitchAmount) < tolerance then
        return true
    end
    return false
end

-- HUD - https://github.com/Rezoix/DU-hud with major modifications by Archeageo
function updateHud()

    local altitude = core_altitude

    local velocity = core.getVelocity()
    local speed = vec3(velocity):len()
    local worldV = vec3(core.getWorldVertical())
    local constrF = vec3(core.getConstructWorldOrientationForward())
    local constrR = vec3(core.getConstructWorldOrientationRight())
    local constrV = vec3(core.getConstructWorldOrientationUp())
    local pitch = getPitch(worldV, constrF, constrR) -- 180 - getRoll(worldV, constrR, constrF)
    local roll = getRoll(worldV, constrF, constrR) -- getRoll(worldV, constrF, constrR)
    local originalRoll = roll
    local originalPitch = math.floor(pitch)
    local bottomText = "ROLL"
    local grav = core.getWorldGravity()
    local gravity = math.floor(vec3(grav):len() * 100) / 100
    local atmos = unit.getAtmosphereDensity()
    local throt = math.floor(unit.getThrottle())
    local spd = speed * 3.6
    local flightValue = unit.getAxisCommandValue(0)
    local flightType = Nav.axisCommandManager:getAxisCommandType(0)
    local flightStyle = "TRAVEL"
    local rgbO = rgb
    local rgbdimO = rgbdim
    local rgbdimmerO = rgbdimmer
    if system.isViewLocked() == 0 and userControlScheme ~= "Keyboard" then
        rgb = [[rgb(]] .. math.floor(PrimaryR * 0.5 + 0.5) .. "," .. math.floor(PrimaryG * 0.5 + 0.5) .. "," ..
                  math.floor(PrimaryB * 0.5 + 0.5) .. [[)]]
        rgbdim = [[rgb(]] .. math.floor(PrimaryR * 0.4 + 0.5) .. "," .. math.floor(PrimaryG * 0.4 + 0.5) .. "," ..
                     math.floor(PrimaryB * 0.4 + 0.5) .. [[)]]
        rgbdimmer = [[rgb(]] .. math.floor(PrimaryR * 0.3 + 0.5) .. "," .. math.floor(PrimaryG * 0.3 + 0.5) .. "," ..
                        math.floor(PrimaryB * 0.3 + 0.5) .. [[)]]
    end
    if (flightType == 1) then
        flightStyle = "CRUISE"

    end
    if Autopilot then
        flightStyle = "AUTOPILOT"
    end

    if (atmos == 0) then
        if (speed > 5) then
            pitch = getRelativePitch(velocity)
            roll = getRelativeYaw(velocity)
        else
            pitch = 0
            roll = 0
        end
        bottomText = "YAW"
    end

    content = [[
                    <head>
                        <style>
                            body {margin: 0}
                            svg {position:absolute; top:0; left:0} 
                            .majorLine {stroke:]] .. rgbO .. [[;stroke-width:3;fill:none;}
                            .minorLine {stroke:]] .. rgb .. [[;stroke-width:3;fill:none;}
                            .text {fill:]] .. rgbdimmer .. [[;font-family:Montserrat;font-weight:bold}
                        </style>
                    </head>
                    <body>
                        <svg height="100vh" width="100vw" viewBox="0 0 1920 1080">
                        <g class="majorLine">
                            <path d="M 700 0 L 740 35 Q 960 55 1180 35 L 1220 0"/>
                        </g>
                        ]]
    if (altitude < 200000 and atmos == 0) or (altitude and atmos > 0) then
        DrawVerticalSpeed()
    end
    if Nav.control.isRemoteControlled() == 0 then
        content = content .. [[
                            <g class="minorLine">
                                <path d="M 792 550 L 785 550 L 785 650 L 792 650"/>
                            </g>
                            <g>
                                <polygon points="1138,540 1120,535 1120,545" style="fill:]] .. rgb .. [["/>
                            </g>
                            <g class="text">
                                <g font-size=10>
                                    <text x="960" y="375" text-anchor="middle" style="fill:]] .. rgbO ..
                      [[">SPEED</text>
                                    <text x="960" y="390" text-anchor="middle" style="fill:]] .. rgbO ..
                      [[;font-size:14;">]] .. math.floor(spd) .. [[ km/h</text>
                                    <text x="1200" y="710" text-anchor="end">GRAVITY</text>
                                    <text x="1200" y="720" text-anchor="end">]] .. gravity .. [[ m/s2</text>
                                </g>
                                <g font-size=15>
                                    <text x="960" y="33" text-anchor="middle" style="fill:]] .. rgbO .. [[">]] ..
                      flightStyle .. [[</text>
                                </g>
                            </g>]]
        if (flightStyle == "TRAVEL" or flightStyle == "AUTOPILOT") then
            content = content .. [[
                                <g class="text">
                                    <g font-size=10>
                                        <text x="790" y="660" text-anchor="start" style="fill:]] .. rgbO ..
                          [[">THROT</text>
                                        <text x="790" y="670" text-anchor="start" style="fill:]] .. rgbO .. [[">]] ..
                          throt .. [[%</text>
                                    </g>
                                </g>]]
        else
            content = content .. [[
                                <g class="text">
                                    <g font-size=10>
                                        <text x="790" y="660" text-anchor="start" style="fill:]] .. rgbO ..
                          [[">CRUISE</text>
                                        <text x="790" y="670" text-anchor="start" style="fill:]] .. rgbO .. [[">]] ..
                          flightValue .. [[ km/h</text>
                                    </g>
                                </g>]]
        end
    else -- If remote controlled, draw stuff near the top so it's out of the way
        content = content .. [[
                            <g class="text">
                                <g font-size=10>
                                    <text x="960" y="60" text-anchor="middle" style="fill:]] .. rgbO .. [[">SPEED</text>
                                    <text x="960" y="75" text-anchor="middle" style="fill:]] .. rgbO ..
                      [[;font-size:14;">]] .. math.floor(spd) .. [[ km/h</text>
                                    <text x="1120" y="55" text-anchor="end" style="fill:]] .. rgbO .. [[">GRAVITY</text>
                                    <text x="1120" y="65" text-anchor="end" style="fill:]] .. rgbO .. [[">]] .. gravity ..
                      [[ m/s2</text>
                                </g>
                                <g font-size=15>
                                    <text x="960" y="33" text-anchor="middle" style="fill:]] .. rgbO .. [[">]] ..
                      flightStyle .. [[</text>
                                </g>
                            </g>]]
        if (flightStyle == "TRAVEL" or flightStyle == "AUTOPILOT") then
            content = content .. [[
                                <g class="text">
                                    <g font-size=10>
                                        <text x="790" y="55" text-anchor="start" style="fill:]] .. rgbO ..
                          [[">THROT</text>
                                        <text x="790" y="65" text-anchor="start" style="fill:]] .. rgbO .. [[">]] ..
                          throt .. [[%</text>
                                    </g>
                                </g>]]
        else
            content = content .. [[
                                <g class="text">
                                    <g font-size=10>
                                        <text x="790" y="55" text-anchor="start" style="fill:]] .. rgbO ..
                          [[">CRUISE</text>
                                        <text x="790" y="65" text-anchor="start" style="fill:]] .. rgbO .. [[">]] ..
                          flightValue .. [[ km/h</text>
                                    </g>
                                </g>]]
        end
    end
    content = content .. damageMessage
    content = content .. radarMessage
    local tankID = 1
    local tankName = 2
    local tankMaxVol = 3
    local tankMassEmpty = 4
    local tankLastMass = 5
    local tankLastTime = 6
    local color, colorMod
    local y1 = 350
    local y2 = 360
    if Nav.control.isRemoteControlled() == 1 then
        y1 = 50
        y2 = 60
    end
    if (UpdateCount % FuelUpdateDelay == 0) then
        updateTanks = true
    end
    if (#atmoTanks > 0) then
        for i = 1, #atmoTanks do
            if updateTanks or fuelTimeLeft[i] == nil or fuelPercent[i] == nil then
                local fuelMassMax = 0
                local fuelMassLast = 0
                local fuelMass = 0
                local fuelLastTime = 0
                local curTime = system.getTime()
                fuelMass = (core.getElementMassById(atmoTanks[i][tankID]) - atmoTanks[i][tankMassEmpty])
                fuelMassMax = atmoTanks[i][tankMaxVol]
                if fuelTankOptimization then
                    fuelMassMax = fuelMassMax + fuelMassMax * fuelTankOptimization
                end
                fuelPercent[i] = math.floor(fuelMass * 100 / fuelMassMax)
                fuelMassLast = atmoTanks[i][tankLastMass]
                fuelLastTime = atmoTanks[i][tankLastTime]
                if fuelMassLast <= fuelMass then
                    fuelTimeLeft[i] = 0
                else
                    fuelTimeLeft[i] = math.floor(fuelMass / ((fuelMassLast - fuelMass) / (curTime - fuelLastTime)))
                end
                atmoTanks[i][tankLastMass] = fuelMass
                atmoTanks[i][tankLastTime] = curTime
            end
            local name = string.sub(atmoTanks[i][tankName], 1, 12)
            if name == "Atmospheric " then
                name = "ATMO " .. i
            end
            local fuelTimeDisplay
            if fuelTimeLeft[i] == 0 then
                fuelTimeDisplay = "n/a"
            else
                fuelTimeDisplay = FormatTimeString(fuelTimeLeft[i])
            end
            if fuelPercent[i] ~= nil then
                colorMod = math.floor(fuelPercent[i] * 2.55)
                color = [[rgb(]] .. 255 - colorMod .. "," .. colorMod .. "," .. 0 .. [[)]]
                if ((fuelTimeDisplay ~= "n/a" and fuelTimeLeft[i] < 120) or fuelPercent[i] < 5) then
                    if updateTanks then
                        if titlecol == rgbO then
                            titlecol = [[rgb(]] .. 255 .. "," .. 0 .. "," .. 0 .. [[)]]
                        else
                            titlecol = rgbO
                        end
                    end
                end
                content = content .. [[
                                    <g class="text">
                                        <g font-size=11>
                                            <text x=1700 y="]] .. y1 .. [[" text-anchor="start" style="fill:]] ..
                              titlecol .. [[">]] .. name .. [[</text>
                                            <text x=1700 y="]] .. y2 .. [[" text-anchor="start" style="fill:]] .. color ..
                              [[">]] .. fuelPercent[i] .. [[% ]] .. fuelTimeDisplay .. [[</text>
                                        </g>
                                    </g>]]
                y1 = y1 + 30
                y2 = y2 + 30
            end
        end
    end
    y1 = 350
    y2 = 360
    if Nav.control.isRemoteControlled() == 1 then
        y1 = 50
        y2 = 60
    end
    if (#spaceTanks > 0) then
        for i = 1, #spaceTanks do
            if updateTanks or fuelTimeLeftS[i] == nil or fuelPercentS[i] == nil then
                local fuelMassMax = 0
                local fuelMassLast = 0
                local fuelMass = 0
                local fuelLastTime = 0
                local curTime = system.getTime()
                fuelMass = (core.getElementMassById(spaceTanks[i][tankID]) - spaceTanks[i][tankMassEmpty])
                fuelMassMax = spaceTanks[i][tankMaxVol]
                if fuelTankOptimization then
                    fuelMassMax = fuelMassMax + fuelMassMax * fuelTankOptimization
                end
                fuelPercentS[i] = math.floor(fuelMass * 100 / fuelMassMax)
                fuelMassLast = spaceTanks[i][tankLastMass]
                fuelLastTime = spaceTanks[i][tankLastTime]
                if fuelMassLast <= fuelMass then
                    fuelTimeLeftS[i] = 0
                else
                    fuelTimeLeftS[i] = math.floor(fuelMass / ((fuelMassLast - fuelMass) / (curTime - fuelLastTime)))
                end
                spaceTanks[i][tankLastMass] = fuelMass
                spaceTanks[i][tankLastTime] = curTime
            end
            local name = string.sub(spaceTanks[i][tankName], 1, 12)
            if name == "Space fuel t" then
                name = "SPACE " .. i
            end
            local fuelTimeDisplay
            if fuelTimeLeftS[i] == 0 then
                fuelTimeDisplay = "n/a"
            else
                fuelTimeDisplay = FormatTimeString(fuelTimeLeftS[i])
            end
            if fuelPercentS[i] ~= nil then
                colorMod = math.floor(fuelPercentS[i] * 2.55)
                color = [[rgb(]] .. 255 - colorMod .. "," .. colorMod .. "," .. 0 .. [[)]]
                if ((fuelTimeDisplay ~= "n/a" and fuelTimeLeftS[i] < 120) or fuelPercentS[i] < 5) then
                    if updateTanks then
                        if titlecol == rgbO then
                            titlecol = [[rgb(]] .. 255 .. "," .. 0 .. "," .. 0 .. [[)]]
                        else
                            titlecol = rgbO
                        end
                    end
                end
                content = content .. [[
                                    <g class="text">
                                        <g font-size=11>
                                            <text x=1800 y="]] .. y1 .. [[" text-anchor="start" style="fill:]] ..
                              titlecol .. [[">]] .. name .. [[</text>
                                            <text x=1800 y="]] .. y2 .. [[" text-anchor="start" style="fill:]] .. color ..
                              [[">]] .. fuelPercentS[i] .. [[% ]] .. fuelTimeDisplay .. [[</text>
                                        </g>
                                    </g>]]
                y1 = y1 + 30
                y2 = y2 + 30
            end
        end
    end
    local y1 = 350
    local y2 = 360
    if Nav.control.isRemoteControlled() == 1 then
        y1 = 50
        y2 = 60
    end
    if (#rocketTanks > 0) then
        for i = 1, #rocketTanks do
            if updateTanks or fuelTimeLeftR[i] == nil or fuelPercentR[i] == nil then
                local fuelMassMax = 0
                local fuelMassLast = 0
                local fuelMass = 0
                local fuelLastTime = 0
                local curTime = system.getTime()
                fuelMass = (core.getElementMassById(rocketTanks[i][tankID]) - rocketTanks[i][tankMassEmpty])
                fuelMassMax = rocketTanks[i][tankMaxVol]
                if fuelTankOptimization then
                    fuelMassMax = fuelMassMax + fuelMassMax * fuelTankOptimization
                end
                fuelPercentR[i] = math.floor(fuelMass * 100 / fuelMassMax)
                fuelMassLast = rocketTanks[i][tankLastMass]
                fuelLastTime = rocketTanks[i][tankLastTime]
                if fuelMassLast <= fuelMass then
                    fuelTimeLeftR[i] = 0
                else
                    fuelTimeLeftR[i] = math.floor(fuelMass / ((fuelMassLast - fuelMass) / (curTime - fuelLastTime)))
                end
                rocketTanks[i][tankLastMass] = fuelMass
                rocketTanks[i][tankLastTime] = curTime
            end
            local name = string.sub(rocketTanks[i][tankName], 1, 12)
            if name == "Rocket fuel " then
                name = "ROCKET " .. i
            end
            local fuelTimeDisplay
            if fuelTimeLeftR[i] == 0 then
                fuelTimeDisplay = "n/a"
            else
                fuelTimeDisplay = FormatTimeString(fuelTimeLeftR[i])
            end
            if fuelPercentR[i] ~= nil then
                colorMod = math.floor(fuelPercentR[i] * 2.55)
                color = [[rgb(]] .. 255 - colorMod .. "," .. colorMod .. "," .. 0 .. [[)]]
                if ((fuelTimeDisplay ~= "n/a" and fuelTimeLeftR[i] < 120) or fuelPercentR[i] < 5) then
                    if updateTanks then
                        if titlecol == rgbO then
                            titlecol = [[rgb(]] .. 255 .. "," .. 0 .. "," .. 0 .. [[)]]
                        else
                            titlecol = rgbO
                        end
                    end
                end
                content = content .. [[
                                    <g class="text">
                                        <g font-size=11>
                                            <text x=1600 y="]] .. y1 .. [[" text-anchor="start" style="fill:]] ..
                              titlecol .. [[">]] .. name .. [[</text>
                                            <text x=1600 y="]] .. y2 .. [[" text-anchor="start" style="fill:]] .. color ..
                              [[">]] .. fuelPercentR[i] .. [[% ]] .. fuelTimeDisplay .. [[</text>
                                        </g>
                                    </g>]]
                y1 = y1 + 30
                y2 = y2 + 30
            end
        end
    end
    speedC = math.floor(spd)
    rollC = math.floor(roll)
    pitchC = math.floor(pitch)
    if Nav.control.isRemoteControlled() == 0 then
        for i = math.floor(pitchC - 25 - pitchC % 5 + 0.5), math.floor(pitchC + 25 + pitchC % 5 + 0.5), 5 do
            if (i % 10 == 0) then
                num = i
                if (num > 180) then
                    num = -180 + (num - 180)
                elseif (num < -180) then
                    num = 180 + (num + 180)
                end
                content = content .. [[<g transform="translate(0 ]] .. (-i * 5 + pitch * 5 + 5) .. [[)">
                                    <text x="1180" y="540" style="fill:]] .. rgbdim ..
                              [[;text-anchor:start;font-size:12;font-family:Montserrat;font-weight:bold">]] .. num ..
                              [[</text></g>]]
            end
            if (i % 10 == 0) then
                len = 30
            elseif (i % 5 == 0) then
                len = 20
            else
                len = 7
            end
            content = content .. [[
                                <g transform="translate(0 ]] .. (-i * 5 + pitch * 5) .. [[)">
                                    <line x1="]] .. (1140 + len) .. [[" y1="540" x2="1140" y2="540"style="stroke:]] ..
                          rgbdim .. [[;stroke-width:2"/></g>]]
        end
        content = content .. [[
                            <g class="text">
                                <g font-size=10>
                                    <text x="1180" y="380" text-anchor="end">PITCH</text>
                                    <text x="1180" y="390" text-anchor="end">]] .. pitchC .. [[ deg</text>
                                </g>
                            </g>
                        ]]

        -- ** CIRCLE ALTIMETER  - Base Code from Discord @Rainsome = Youtube CaptainKilmar** 
        if circleRad > 0 and unit.getClosestPlanetInfluence() > 0 then
            if originalPitch > 90 and atmos == 0 then
                originalPitch = 90 - (originalPitch - 90)
            elseif originalPitch < -90 and atmos == 0 then
                originalPitch = -90 - (originalPitch + 90)
            end
            content = content .. [[<circle r="]] .. circleRad .. [[" cx="960" cy="540" opacity="0.1" fill="]] ..
                          "#0083cb" .. [[" stroke="black" stroke-width="2"/><clipPath id="cut"><circle r="]] ..
                          (circleRad - 1) .. [[" cx="960" cy="540"/></clipPath>
                            <rect x="]] .. (960 - circleRad) .. [[" y="]] .. (540 + circleRad * (originalPitch / 90)) ..
                          [[" height="]] .. (circleRad * 2) .. [[" width="]] .. (circleRad * 2) ..
                          [[" opacity="0.3" fill="]] .. "#6b5835" .. [[" clip-path="url(#cut)" transform="rotate(]] ..
                          (-1 * originalRoll) .. [[ 960 540)"/>]]
        end
        content = content .. [[
                                <g class="text">
                                <g font-size=10>
                                <text x="960" y="688" text-anchor="middle">]] .. bottomText .. [[</text>
                                <text x="960" y="698" text-anchor="middle">]] .. math.floor(roll) .. [[ deg</text>]]
        content = content .. [[<g>
                                <polygon points="960,725 955,707 965,707" style="fill:]] .. rgb .. [["/>
                                </g>]]
        for i = math.floor(rollC - 30 - rollC % 5 + 0.5), math.floor(rollC + 30 + rollC % 5 + 0.5), 5 do
            if (i % 10 == 0) then
                local sign = i / math.abs(i)
                if i == 0 then
                    sign = 0
                end
                num = math.abs(i)
                if (num > 180) then
                    num = 180 + (180 - num)
                end
                content = content .. [[<g transform="rotate(]] .. (i - roll) .. [[,960,460)">
                                        <text x="960" y="760" style="fill:]] .. rgbdim ..
                              [[;text-anchor:middle;font-size:12;font-family:Montserrat;font-weight:bold">]] ..
                              math.floor(sign * num + 0.5) .. [[</text></g>]]
            end
            len = 5
            if (i % 10 == 0) then
                len = 15
            elseif (i % 5 == 0) then
                len = 10
            end
            content = content .. [[<g transform="rotate(]] .. (i - roll) .. [[,960,460)">
                                <line x1="960" y1="730" x2="960" y2="]] .. (730 + len) .. [[" style="stroke:]] ..
                          rgbdimmer .. [[;stroke-width:2"/></g>]]
        end

        if (altitude < 200000 and atmos == 0) or (altitude and atmos > 0) then
            content = content .. [[
                            <g>
                                <polygon points="782,540 800,535 800,545" style="fill:]] .. rgb .. [["/>
                            </g>
                            <g class="text">
                            <g font-size=10>
                                <text x="770" y="380" text-anchor="end">ALTITUDE</text>
                                <text x="770" y="390" text-anchor="end">]] .. math.floor(altitude) .. [[ m</text>
                                ]]
            content = content .. [[
                                <text x="770" y="710" text-anchor="end">ATMOSPHERE</text>
                                <text x="770" y="720" text-anchor="end">]] .. (math.floor((atmos) * 100) / 100) ..
                          [[ m</text>
                            </g>
                            </g>]]
            -- Many thanks to Nistus on Discord for his assistance with the altimeter.
            altC = math.floor((altitude) / 10)
            for i = math.floor(altC - 25 - altC % 5 + 0.5), math.floor(altC + 25 + altC % 5 + 0.5), 5 do
                if (i % 10 == 0) then
                    num = i * 10
                    content = content .. [[<g transform="translate(0 ]] .. (-i * 5 + altitude * .5 + 5) .. [[)">
                                    <text x="745" y="540" style="fill:]] .. rgbdim ..
                                  [[;text-anchor:end;font-size:12;font-family:Montserrat;font-weight:bold">]] .. num ..
                                  [[</text></g>]]
                end
                len = 5
                if (i % 10 == 0) then
                    len = 30
                elseif (i % 5 == 0) then
                    len = 15
                end
                content = content .. [[
                                <g transform="translate(0 ]] .. (-i * 5 + altitude * .5) .. [[)">
                                    <line x1="]] .. (780 - len) .. [[" y1="540" x2="780" y2="540"style="stroke:]] ..
                              rgbdimmer .. [[;stroke-width:2"/></g>]]
            end
        end
        content = content .. [[<g transform="translate(0 ]] .. (1 - throt) .. [[)">
                            <polygon points="798,650 810,647 810,653" style="fill:]] .. rgbdim .. [[;"/></g>]]

    end
    if updateTanks then
        updateTanks = false
        UpdateCount = 0
    end
    UpdateCount = UpdateCount + 1

    -- After the HUD, set RGB values back to undimmed even if view is unlocked
    rgb = rgbO
    rgbdim = rgbdimO
    rgbdimmer = rgbdimmerO
    DrawWarnings()
    DisplayOrbit()
    content = content .. [[</svg>]]
    if screen_2 then
        local pos = vec3(core.getConstructWorldPos())
        local x = 960 + pos.x / MapXRatio
        local y = 450 + pos.y / MapYRatio
        screen_2.moveContent(YouAreHere, (x - 80) / 19.2, (y - 80) / 10.8)
    end

end

function DrawWarnings()
    if unit.isMouseControlActivated() == 1 then
        content = content ..
                      "<text x='960' y='550' font-size='26' font-weight='bold' fill='red' text-anchor='middle' font-family='Bank'>Warning: Invalid Control Scheme Detected</text>"
        content = content ..
                      "<text x='960' y='600' font-size='26' font-weight='bold' fill='red' text-anchor='middle' font-family='Bank'>Keyboard Scheme must be selected</text>"
        content = content ..
                      "<text x='960' y='650' font-size='26' font-weight='bold' fill='red' text-anchor='middle' font-family='Bank'>Set your preferred scheme in Lua Parameters instead</text>"
    end
    local warningX = 960
    local brakeY = 860
    local gearY = 900
    local hoverY = 930
    local apY = 225
    local turnBurnY = 150
    if Nav.control.isRemoteControlled() == 1 then
        brakeY = 135
        gearY = 155
        hoverY = 175
        apY = 115
        turnBurnY = 95
    end
    if BrakeIsOn then
        content = content .. "<text x='" .. warningX .. "' y='" .. brakeY ..
                      "' font-size='26' font-weight='bold' fill='red' text-anchor='middle' font-family='Bank'>Brake Engaged</text>"
    end
    if gearExtended then
        if hasGear then
            content = content .. "<text x='" .. warningX .. "' y='" .. gearY ..
                          "' font-size='24' fill='orange' text-anchor='middle' font-family='Bank'>Gear Extended</text>"
        else
            content = content .. "<text x='" .. warningX .. "' y='" .. gearY ..
                          "' font-size='26' font-weight='bold' fill='red' text-anchor='middle' font-family='Bank'>Landed (G: Takeoff)</text>"
        end
        content = content .. "<text x='" .. warningX .. "' y='" .. hoverY ..
                      "' font-size='24' fill='orange' text-anchor='middle' font-family='Bank'>Hover Height: " ..
                      getDistanceDisplayString(Nav:getTargetGroundAltitude()) .. "</text>"
    end
    if AutoBrake and AutopilotTargetPlanetName ~= "None" then
        if brakeInput == 0 then
            content = content .. "<text x='" .. warningX .. "' y='" .. apY ..
                          "' font-size='26' font-weight='bold' fill='orange' text-anchor='middle' font-family='Bank'>Auto-Braking when within " ..
                          getDistanceDisplayString(maxBrakeDistance) .. " of " .. AutopilotTargetPlanet.name ..
                          "</text>"
        else
            content = content .. "<text x='" .. warningX .. "' y='" .. apY ..
                          "' font-size='26' font-weight='bold' fill='orange' text-anchor='middle' font-family='Bank'>Auto-Braking until eccentricity:" ..
                          round(orbit.eccentricity, 2) .. " begins to increase</text>"
        end
    elseif Autopilot and AutopilotTargetPlanetName ~= "None" then
        content = content .. "<text x='" .. warningX .. "' y='" .. apY ..
                      "' font-size='26' font-weight='bold' fill='orange' text-anchor='middle' font-family='Bank'>Autopilot " ..
                      AutopilotStatus .. "</text>"
    elseif FollowMode then
        content = content .. "<text x='" .. warningX .. "' y='" .. apY ..
                      "' font-size='26' font-weight='bold' fill='orange' text-anchor='middle' font-family='Bank'>Follow Mode Engaged</text>"
    elseif AltitudeHold then
        if AutoLanding then
            content = content .. "<text x='" .. warningX .. "' y='" .. apY ..
                          "' font-size='26' font-weight='bold' fill='red' text-anchor='middle' font-family='Bank'>Auto-Landing</text>"
        elseif AutoTakeoff then
            content = content .. "<text x='" .. warningX .. "' y='" .. apY ..
                          "' font-size='26' font-weight='bold' fill='orange' text-anchor='middle' font-family='Bank'>Ascent to " ..
                          getDistanceDisplayString(HoldAltitude) .. "</text>"
            if BrakeIsOn then
                content = content .. "<text x='" .. warningX .. "' y='" .. apY + 50 ..
                              "' font-size='28' fill='darkred' text-anchor='middle' font-family='Bank'>Throttle Up and Disengage Brake For Takeoff</text>"
            end
        else
            content = content .. "<text x='" .. warningX .. "' y='" .. apY ..
                          "' font-size='26' font-weight='bold' fill='orange' text-anchor='middle' font-family='Bank'>Altitude Hold: " ..
                          getDistanceDisplayString2(HoldAltitude) .. "</text>"
        end
    end
    if TurnBurn then
        content = content .. "<text x='" .. warningX .. "' y='" .. turnBurnY ..
                      "' font-size='26' font-weight='bold' fill='darkred' text-anchor='middle' font-family='Bank'>Turn & Burn Braking</text>"
    end
end

function DisplayOrbit()
    if orbit ~= nil and unit.getAtmosphereDensity() < 0.2 and planet ~= nil then
        -- If orbits are up, let's try drawing a mockup
        local orbitMapX = 75
        local orbitMapY = 0
        local orbitMapSize = 250 -- Always square
        local pad = 4
        orbitMapY = orbitMapY + pad
        local orbitInfoYOffset = 15
        local x = orbitMapX + orbitMapSize + orbitMapX / 2 + pad
        local y = orbitMapY + orbitMapSize / 2 + 5 + pad

        local rx, ry, scale, xOffset
        rx = orbitMapSize / 4
        xOffset = 0

        -- Draw a darkened box around it to keep it visible
        content =
            content .. '<rect width="' .. orbitMapSize + orbitMapX * 2 .. '" height="' .. orbitMapSize + orbitMapY ..
                '" rx="10" ry="10" x="' .. pad .. '" y="' .. pad ..
                '" style="fill:rgb(0,0,100);stroke-width:4;stroke:white;fill-opacity:0.3;" />'

        if orbit.periapsis ~= nil and orbit.apoapsis ~= nil then
            scale = (orbit.apoapsis.altitude + orbit.periapsis.altitude + planet.radius * 2) / (rx * 2)
            ry = (planet.radius + orbit.periapsis.altitude + (orbit.apoapsis.altitude - orbit.periapsis.altitude) / 2) /
                     scale * (1 - orbit.eccentricity)
            xOffset = rx - orbit.periapsis.altitude / scale - planet.radius / scale

            local ellipseColor = rgbdim
            if orbit.periapsis.altitude <= 0 then
                ellipseColor = 'red'
            end
            content = content .. '<ellipse cx="' .. orbitMapX + orbitMapSize / 2 + xOffset + pad .. '" cy="' ..
                          orbitMapY + orbitMapSize / 2 + pad .. '" rx="' .. rx .. '" ry="' .. ry ..
                          '" style="fill:none;stroke:' .. ellipseColor .. ';stroke-width:2" />'
            content = content .. '<circle cx="' .. orbitMapX + orbitMapSize / 2 + pad .. '" cy="' .. orbitMapY +
                          orbitMapSize / 2 + pad .. '" r="' .. planet.radius / scale ..
                          '" stroke="white" stroke-width="3" fill="blue" />'
        end

        if orbit.apoapsis ~= nil then
            content = content .. [[<line x1="]] .. x - 35 .. [[" y1="]] .. y - 5 .. [[" x2="]] .. orbitMapX +
                          orbitMapSize / 2 + rx + xOffset .. [[" y2="]] .. y - 5 .. [["style="stroke:]] .. rgbdim ..
                          [[;opacity:0.3;stroke-width:3"/>]]
            content = content .. "<text x='" .. x .. "' y='" .. y .. "' font-size='14' fill=" .. rgb ..
                          " text-anchor='middle' font-family='Montserrat'>Apoapsis</text>"
            y = y + orbitInfoYOffset
            content = content .. "<text x='" .. x .. "' y='" .. y .. "' font-size='12' fill=" .. rgbdimmer ..
                          " text-anchor='middle' font-family='Montserrat'>" ..
                          getDistanceDisplayString(orbit.apoapsis.altitude) .. "</text>"
            y = y + orbitInfoYOffset
            content = content .. "<text x='" .. x .. "' y='" .. y .. "' font-size='12' fill=" .. rgbdimmer ..
                          " text-anchor='middle' font-family='Montserrat'>" .. FormatTimeString(orbit.timeToApoapsis) ..
                          "</text>"
            y = y + orbitInfoYOffset
            content = content .. "<text x='" .. x .. "' y='" .. y .. "' font-size='12' fill=" .. rgbdimmer ..
                          " text-anchor='middle' font-family='Montserrat'>" ..
                          getSpeedDisplayString(orbit.apoapsis.speed) .. "</text>"
        end

        y = orbitMapY + orbitMapSize / 2 + 5 + pad
        x = orbitMapX - orbitMapX / 2 + 10 + pad

        if orbit.periapsis ~= nil then
            content = content .. "<text x='" .. x .. "' y='" .. y .. "' font-size='14' fill=" .. rgb ..
                          " text-anchor='middle' font-family='Montserrat'>Periapsis</text>"
            content = content .. [[<line x1="]] .. x + 35 .. [[" y1="]] .. y - 5 .. [[" x2="]] .. orbitMapX +
                          orbitMapSize / 2 - rx + xOffset .. [[" y2="]] .. y - 5 .. [["style="stroke:]] .. rgbdim ..
                          [[;opacity:0.3;stroke-width:3"/>]]
            y = y + orbitInfoYOffset
            content = content .. "<text x='" .. x .. "' y='" .. y .. "' font-size='12' fill=" .. rgbdimmer ..
                          " text-anchor='middle' font-family='Montserrat'>" ..
                          getDistanceDisplayString(orbit.periapsis.altitude) .. "</text>"
            y = y + orbitInfoYOffset
            content = content .. "<text x='" .. x .. "' y='" .. y .. "' font-size='12' fill=" .. rgbdimmer ..
                          " text-anchor='middle' font-family='Montserrat'>" .. FormatTimeString(orbit.timeToPeriapsis) ..
                          "</text>"
            y = y + orbitInfoYOffset
            content = content .. "<text x='" .. x .. "' y='" .. y .. "' font-size='12' fill=" .. rgbdimmer ..
                          " text-anchor='middle' font-family='Montserrat'>" ..
                          getSpeedDisplayString(orbit.periapsis.speed) .. "</text>"

        end

        -- Add a label for the planet
        content = content .. "<text x='" .. orbitMapX + orbitMapSize / 2 + pad .. "' y='" .. 20 + pad ..
                      "' font-size='18' fill=" .. rgb .. " text-anchor='middle' font-family='Montserrat'>" ..
                      planet.name .. "</text>"

        if orbit.period ~= nil and orbit.periapsis ~= nil and orbit.apoapsis ~= nil then
            local apsisRatio = (orbit.timeToApoapsis / orbit.period) * 2 * math.pi
            -- x = xr * cos(t)
            -- y = yr * sin(t)
            local shipX = rx * math.cos(apsisRatio)
            local shipY = ry * math.sin(apsisRatio)

            content = content .. '<circle cx="' .. orbitMapX + orbitMapSize / 2 + shipX + xOffset + pad .. '" cy="' ..
                          orbitMapY + orbitMapSize / 2 + shipY + pad ..
                          '" r="5" stroke="white" stroke-width="3" fill="white" />'
        end
        -- Once we have all that, we should probably rotate the entire thing so that the ship is always at the bottom so you can see AP and PE move?

    end
end

-- Planet Info - https://gitlab.com/JayleBreak/dualuniverse/-/tree/master/DUflightfiles/autoconf/custom with minor modifications
function Atlas()
    return {
        [0] = {
            [1] = {
                GM = 6930729684,
                bodyId = 1,
                center = {
                    x = 17465536.000,
                    y = 22665536.000,
                    z = -34464.000
                },
                name = 'Madis',
                planetarySystemId = 0,
                radius = 44300
            },
            [2] = {
                GM = 157470826617,
                bodyId = 2,
                center = {
                    x = -8.000,
                    y = -8.000,
                    z = -126303.000
                },
                name = 'Alioth',
                planetarySystemId = 0,
                radius = 126068
            },
            [3] = {
                GM = 11776905000,
                bodyId = 3,
                center = {
                    x = 29165536.000,
                    y = 10865536.000,
                    z = 65536.000
                },
                name = 'Thades',
                planetarySystemId = 0,
                radius = 49000
            },
            [4] = {
                GM = 14893847582,
                bodyId = 4,
                center = {
                    x = -13234464.000,
                    y = 55765536.000,
                    z = 465536.000
                },
                name = 'Talemai',
                planetarySystemId = 0,
                radius = 57450
            },
            [5] = {
                GM = 16951680000,
                bodyId = 5,
                center = {
                    x = -43534464.000,
                    y = 22565536.000,
                    z = -48934464.000
                },
                name = 'Feli',
                planetarySystemId = 0,
                radius = 60000
            },
            [6] = {
                GM = 10502547741,
                bodyId = 6,
                center = {
                    x = 52765536.000,
                    y = 27165538.000,
                    z = 52065535.000
                },
                name = 'Sicari',
                planetarySystemId = 0,
                radius = 51100
            },
            [7] = {
                GM = 13033380591,
                bodyId = 7,
                center = {
                    x = 58665538.000,
                    y = 29665535.000,
                    z = 58165535.000
                },
                name = 'Sinnen',
                planetarySystemId = 0,
                radius = 54950
            },
            [8] = {
                GM = 18477723600,
                bodyId = 8,
                center = {
                    x = 80865538.000,
                    y = 54665536.000,
                    z = -934463.940
                },
                name = 'Teoma',
                planetarySystemId = 0,
                radius = 62000
            },
            [9] = {
                GM = 18606274330,
                bodyId = 9,
                center = {
                    x = -94134462.000,
                    y = 12765534.000,
                    z = -3634464.000
                },
                name = 'Jago',
                planetarySystemId = 0,
                radius = 61590
            },
            [10] = {
                GM = 78480000,
                bodyId = 10,
                center = {
                    x = 17448118.224,
                    y = 22966846.286,
                    z = 143078.820
                },
                name = 'Madis Moon 1',
                planetarySystemId = 0,
                radius = 10000
            },
            [11] = {
                GM = 237402000,
                bodyId = 11,
                center = {
                    x = 17194626.000,
                    y = 22243633.880,
                    z = -214962.810
                },
                name = 'Madis Moon 2',
                planetarySystemId = 0,
                radius = 11000
            },
            [12] = {
                GM = 265046609,
                bodyId = 12,
                center = {
                    x = 17520614.000,
                    y = 22184730.000,
                    z = -309989.990
                },
                name = 'Madis Moon 3',
                planetarySystemId = 0,
                radius = 15005
            },
            [21] = {
                GM = 2118960000,
                bodyId = 21,
                center = {
                    x = 457933.000,
                    y = -1509011.000,
                    z = 115524.000
                },
                name = 'Alioth Moon 1',
                planetarySystemId = 0,
                radius = 30000
            },
            [22] = {
                GM = 2165833514,
                bodyId = 22,
                center = {
                    x = -1692694.000,
                    y = 729681.000,
                    z = -411464.000
                },
                name = 'Alioth Moon 4',
                planetarySystemId = 0,
                radius = 30330
            },
            [26] = {
                GM = 68234043600,
                bodyId = 26,
                center = {
                    x = -1404835.000,
                    y = 562655.000,
                    z = -285074.000
                },
                name = 'Sanctuary',
                planetarySystemId = 0,
                radius = 83400
            },
            [30] = {
                GM = 211564034,
                bodyId = 30,
                center = {
                    x = 29214402.000,
                    y = 10907080.695,
                    z = 433858.200
                },
                name = 'Thades Moon 1',
                planetarySystemId = 0,
                radius = 14002
            },
            [31] = {
                GM = 264870000,
                bodyId = 31,
                center = {
                    x = 29404193.000,
                    y = 10432768.000,
                    z = 19554.131
                },
                name = 'Thades Moon 2',
                planetarySystemId = 0,
                radius = 15000
            },
            [40] = {
                GM = 141264000,
                bodyId = 40,
                center = {
                    x = -13503090.000,
                    y = 55594325.000,
                    z = 769838.640
                },
                name = 'Talemai Moon 2',
                planetarySystemId = 0,
                radius = 12000
            },
            [41] = {
                GM = 106830900,
                bodyId = 41,
                center = {
                    x = -12800515.000,
                    y = 55700259.000,
                    z = 325207.840
                },
                name = 'Talemai Moon 3',
                planetarySystemId = 0,
                radius = 11000
            },
            [42] = {
                GM = 264870000,
                bodyId = 42,
                center = {
                    x = -13058408.000,
                    y = 55781856.000,
                    z = 740177.760
                },
                name = 'Talemai Moon 1',
                planetarySystemId = 0,
                radius = 15000
            },
            [50] = {
                GM = 499917600,
                bodyId = 50,
                center = {
                    x = -43902841.780,
                    y = 22261034.700,
                    z = -48862386.000
                },
                name = 'Feli Moon 1',
                planetarySystemId = 0,
                radius = 14000
            },
            [70] = {
                GM = 396912600,
                bodyId = 70,
                center = {
                    x = 58969616.000,
                    y = 29797945.000,
                    z = 57969449.000
                },
                name = 'Sinnen Moon 1',
                planetarySystemId = 0,
                radius = 17000
            },
            [100] = {
                GM = 13975172474,
                bodyId = 100,
                center = {
                    x = 98865536.000,
                    y = -13534464.000,
                    z = -934461.990
                },
                name = 'Lacobus',
                planetarySystemId = 0,
                radius = 55650
            },
            [101] = {
                GM = 264870000,
                bodyId = 101,
                center = {
                    x = 98905288.170,
                    y = -13950921.100,
                    z = -647589.530
                },
                name = 'Lacobus Moon 3',
                planetarySystemId = 0,
                radius = 15000
            },
            [102] = {
                GM = 444981600,
                bodyId = 102,
                center = {
                    x = 99180968.000,
                    y = -13783862.000,
                    z = -926156.400
                },
                name = 'Lacobus Moon 1',
                planetarySystemId = 0,
                radius = 18000
            },
            [103] = {
                GM = 211503600,
                bodyId = 103,
                center = {
                    x = 99250052.000,
                    y = -13629215.000,
                    z = -1059341.400
                },
                name = 'Lacobus Moon 2',
                planetarySystemId = 0,
                radius = 14000
            },
            [110] = {
                GM = 9204742375,
                bodyId = 110,
                center = {
                    x = 14165536.000,
                    y = -85634465.000,
                    z = -934464.300
                },
                name = 'Symeon',
                planetarySystemId = 0,
                radius = 49050
            },
            [120] = {
                GM = 7135606629,
                bodyId = 120,
                center = {
                    x = 2865536.700,
                    y = -99034464.000,
                    z = -934462.020
                },
                name = 'Ion',
                planetarySystemId = 0,
                radius = 44950
            },
            [121] = {
                GM = 106830900,
                bodyId = 121,
                center = {
                    x = 2472916.800,
                    y = -99133747.000,
                    z = -1133582.800
                },
                name = 'Ion Moon 1',
                planetarySystemId = 0,
                radius = 11000
            },
            [122] = {
                GM = 176580000,
                bodyId = 122,
                center = {
                    x = 2995424.500,
                    y = -99275010.000,
                    z = -1378480.700
                },
                name = 'Ion Moon 2',
                planetarySystemId = 0,
                radius = 15000
            }
        }
    }
end

for k, v in pairs(Atlas()[0]) do
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
for k, v in pairs(Atlas()[0]) do
    -- Draw a circle at the scaled coordinates
    local x = 960 + (v.center.x / xRatio)
    local y = 540 + (v.center.y / yRatio)
    GalaxyMapHTML = GalaxyMapHTML .. '<circle cx="' .. x .. '" cy="' .. y .. '" r="' .. (v.radius / xRatio) * 30 ..
                        '" stroke="white" stroke-width="3" fill="blue" />'
    if not string.match(v.name, "Moon") and not string.match(v.name, "Sanctuary") then
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
    screen_2.setHTML('<svg width="100vw" height="100vh" viewBox="0 0 1920 1080">' .. GalaxyMapHTML) -- This is permanent and doesn't change
    -- Draw a 'You Are Here' - screen edition
    local pos = vec3(core.getConstructWorldPos())
    local x = 960 + pos.x / xRatio
    local y = 540 + pos.y / yRatio
    GalaxyMapHTML = '<svg><circle cx="80" cy="80" r="5" stroke="white" stroke-width="3" fill="red"/>'
    GalaxyMapHTML = GalaxyMapHTML .. "<text x='80' y='105' font-size='18' fill=" .. rgb ..
                        " text-anchor='middle' font-family='Montserrat''>You Are Here</text></svg>"
    YouAreHere = screen_2.addContent((x - 80) / 19.20, (y - 80) / 10.80, GalaxyMapHTML)
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
        local result = string.gsub(string.reverse(string.format('%.4f', n)), '^0*%.?', '')
        return result == '' and '0' or string.reverse(result)
    end
    local function formatValue(obj)
        if isVector(obj) then
            return string.format('{x=%.3f,y=%.3f,z=%.3f}', obj.x, obj.y, obj.z)
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
                        table.insert(list, string.format('[%s]=%s', k, value))
                    else
                        table.insert(list, string.format('%s=%s', k, value))
                    end
                end
            end
            return string.format('{%s}', table.concat(list, ','))
        end
        if isString(obj) then
            return string.format("'%s'", obj:gsub("'", [[\']]))
        end
        return tostring(obj)
    end
    -- CLASSES
    -- BodyParameters: Attributes of planetary bodies (planets and moons)
    local BodyParameters = {}
    BodyParameters.__index = BodyParameters
    BodyParameters.__tostring = function(obj, indent)
        local sep = indent or ''
        local keys = {}
        for k in pairs(obj) do
            table.insert(keys, k)
        end
        table.sort(keys)
        local list = {}
        for _, k in ipairs(keys) do
            local value = formatValue(obj[k])
            if type(k) == 'number' then
                table.insert(list, string.format('[%s]=%s', k, value))
            else
                table.insert(list, string.format('%s=%s', k, value))
            end
        end
        if indent then
            return string.format('%s%s', indent, table.concat(list, ',\n' .. indent))
        end
        return string.format('{%s}', table.concat(list, ','))
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
        return string.format('::pos{%d,%d,%s,%s,%s}', p.systemId, p.bodyId, formatNumber(p.latitude * rad2deg),
                   formatNumber(p.longitude * rad2deg), formatNumber(p.altitude))
    end
    MapPosition.__eq = function(lhs, rhs)
        return lhs.bodyId == rhs.bodyId and lhs.systemId == rhs.systemId and float_eq(lhs.latitude, rhs.latitude) and
                   float_eq(lhs.altitude, rhs.altitude) and
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
                table.insert(bdylist, string.format('[%s]={\n%s\n%s}', bi, bdys, indent))
            else
                table.insert(bdylist, string.format('  [%s]=%s', bi, bdys))
            end
        end
        if indent then
            return string.format('\n%s%s%s', indent, table.concat(bdylist, ',\n' .. indent), indent)
        end
        return string.format('{\n%s\n}', table.concat(bdylist, ',\n'))
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
            table.insert(pslist, string.format('  [%s]={%s\n  }', psi, pss))
        end
        return string.format('{\n%s\n}\n', table.concat(pslist, ',\n'))
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
        assert(isSNumber(altitudeAtPosition), 'Argument 6 (altitude) must be in meters:' .. type(altitudeAtPosition))
        assert(isSNumber(gravityAtPosition), 'Argument 7 (gravityAtPosition) must be number:' .. type(gravityAtPosition))
        local radius = math.sqrt(surfaceArea / 4 / math.pi)
        local distance = radius + altitudeAtPosition
        local center = vec3(aPosition) + distance * vec3(verticalAtPosition)
        local GM = gravityAtPosition * distance * distance
        return mkBodyParameters(planetarySystemId, bodyId, radius, center, GM)
    end

    PlanetaryReference.isMapPosition = isMapPosition

    function PlanetaryReference:getPlanetarySystem(overload)
        -- if galaxyAtlas then
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
            if not body or distance2 < minDistance2 then
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
        local k, v = next(self)
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
        return math.abs(a - b) < math.max(math.abs(a), math.abs(b)) * epsilon
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
        local tau0 = lorentz(initial)
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

PlanetaryReference = PlanetRef()
galaxyReference = PlanetaryReference(Atlas())
Kinematic = Kinematics()
Kep = Keplers()

InAtmo = (unit.getAtmosphereDensity() > 0)

function getDistanceDisplayString(distance)
    local su = distance > 100000
    local result = ""
    if su then
        -- Convert to SU
        result = round(distance / 1000 / 200, 1) .. " SU"
    elseif distance < 1000 then
        result = round(distance, 1) .. " M"
    else
        -- Convert to KM
        result = round(distance / 1000, 1) .. " KM"
    end

    return result
end

function getDistanceDisplayString2(distance)
    local su = distance > 100000
    local result = ""
    if su then
        -- Convert to SU
        result = round(distance / 1000 / 200, 2) .. " SU"
    elseif distance < 1000 then
        result = round(distance, 2) .. " M"
    else
        -- Convert to KM
        result = round(distance / 1000, 2) .. " KM"
    end

    return result
end

function getSpeedDisplayString(speed) -- TODO: Allow options, for now just do kph
    return math.floor(round(speed * 3.6, 0) + 0.5) .. " km/h" -- And generally it's not accurate enough to not twitch unless we round 0
end

function FormatTimeString(seconds)
    local hours = math.floor(seconds / 3600)
    local minutes = math.floor(seconds / 60 % 60)
    local seconds = math.floor(seconds % 60)
    if seconds < 0 or hours < 0 or minutes < 0 then
        return "0s"
    end
    if hours > 0 then
        return hours .. "h " .. minutes .. "m " .. seconds .. "s"
    elseif minutes > 0 then
        return minutes .. "m " .. seconds .. "s"
    else
        return seconds .. "s"
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
        AutopilotTargetPlanet = nil
        return true
    end
    local count = 0
    for k, v in pairs(Atlas()[0]) do
        count = count + 1
        if count == AutopilotTargetIndex then
            AutopilotTargetName = v.name
            AutopilotTargetPlanet = galaxyReference[0][k]
            AutopilotTargetCoords = vec3(AutopilotTargetPlanet.center) -- Aim center until we align
            -- Determine the end speed
            _, AutopilotEndSpeed = kepPlanet:escapeAndOrbitalSpeed(AutopilotTargetOrbit)
            -- AutopilotEndSpeed = 0
            -- AutopilotPlanetGravity = AutopilotTargetPlanet:getGravity(AutopilotTargetPlanet.center + vec3({1,0,0}) * AutopilotTargetOrbit):len() -- Any direction, at our orbit height
            AutopilotPlanetGravity = 0 -- This is inaccurate unless we integrate and we're not doing that.  
            AutopilotAccelerating = false
            AutopilotBraking = false
            AutopilotCruising = false
            Autoilot = false
            AutopilotRealigned = false
            AutopilotStatus = "Aligning"
            return true
        end
    end
    return false
end

function IncrementAutopilotTargetIndex()
    AutopilotTargetIndex = AutopilotTargetIndex + 1
    if AutopilotTargetIndex > tablelength(Atlas()[0]) then
        AutopilotTargetIndex = 0
    end
    UpdateAutopilotTarget()
end

function DecrementAutopilotTargetIndex()
    AutopilotTargetIndex = AutopilotTargetIndex - 1
    if AutopilotTargetIndex < 0 then
        AutopilotTargetIndex = tablelength(Atlas()[0])
    end
    UpdateAutopilotTarget()
end

function GetAutopilotTravelTime()
    AutopilotDistance = (AutopilotTargetPlanet.center - vec3(core.getConstructWorldPos())):len()
    local velocity = core.getWorldVelocity()
    local accelDistance, accelTime =
        Kinematic.computeDistanceAndTime(vec3(velocity):len(), MaxGameVelocity, -- From currently velocity to max
        core.getConstructMass(), Nav:maxForceForward(), warmup, -- T50?  Assume none, negligible for this
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
    local curBrakeDistance, curBrakeTime
    if not TurnBurn then
        curBrakeDistance, curBrakeTime = GetAutopilotBrakeDistanceAndTime(vec3(velocity):len())
    else
        curBrakeDistance, curBrakeTime = GetAutopilotTBBrakeDistanceAndTime(vec3(velocity):len())
    end
    local cruiseDistance = 0
    local cruiseTime = 0
    -- So, time is in seconds
    -- If cruising or braking, use real cruise/brake values
    if brakeDistance + accelDistance < AutopilotDistance then
        -- Add any remaining distance
        cruiseDistance = AutopilotDistance - (brakeDistance + accelDistance)
        cruiseTime = Kinematic.computeTravelTime(8333.0556, 0, cruiseDistance)
    else
        local accelRatio = (AutopilotDistance - brakeDistance) / accelDistance
        accelDistance = AutopilotDistance - brakeDistance -- Accel until we brake
        
        accelTime = accelTime * accelRatio
    end
    if AutopilotBraking then
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
    if unit.getAtmosphereDensity() == 0 then
        local maxBrake = json.decode(unit.getData()).maxBrake
        if maxBrake ~= nil then
            LastMaxBrake = maxBrake
            return Kinematic.computeDistanceAndTime(speed, AutopilotEndSpeed, core.getConstructMass(), 0, 0,
                       maxBrake - (AutopilotPlanetGravity * core.getConstructMass()))
        else
            return Kinematic.computeDistanceAndTime(speed, AutopilotEndSpeed, core.getConstructMass(), 0, 0,
                       LastMaxBrake - (AutopilotPlanetGravity * core.getConstructMass()))
        end
    else
        if LastMaxBrake and LastMaxBrake > 0 then
            return Kinematic.computeDistanceAndTime(speed, AutopilotEndSpeed, core.getConstructMass(), 0, 0,
                       LastMaxBrake - (AutopilotPlanetGravity * core.getConstructMass()))
        else
            return 0, 0
        end
    end
end

function GetAutopilotTBBrakeDistanceAndTime(speed) -- Uses thrust and a configured T50
    local maxBrake = json.decode(unit.getData()).maxBrake
    if maxBrake ~= nil then
        LastMaxBrake = maxBrake
        return Kinematic.computeDistanceAndTime(speed, AutopilotEndSpeed, core.getConstructMass(),
                   Nav:maxForceForward(), warmup, maxBrake - (AutopilotPlanetGravity * core.getConstructMass()))
    else
        return Kinematic.computeDistanceAndTime(speed, AutopilotEndSpeed, core.getConstructMass(),
                   Nav:maxForceForward(), warmup, LastMaxBrake - (AutopilotPlanetGravity * core.getConstructMass()))
    end
end

function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return math.floor(num * mult + 0.5) / mult
end

function tablelength(T)
    local count = 0
    for _ in pairs(T) do
        count = count + 1
    end
    return count
end

Animating = false
Animated = false

-- That was a lot of work with dirty strings and json.  Clean up
collectgarbage("collect")
