require 'src.slots'

script = {}

function script.onStart()
    SetupComplete = false
    beginSetup = coroutine.create(function()
        Nav = Navigator.new(system, core, unit)
        Nav.axisCommandManager:setupCustomTargetSpeedRanges(axisCommandId.longitudinal,
            {1000, 5000, 10000, 20000, 30000})

        -- Written by Dimencia and Archaegeo. Optimization and Automation of scripting by ChronosWS  Linked sources where appropriate, most have been modified.
        VERSION_NUMBER = 4.76
        -- function localizations
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

        -- USER DEFINABLE GLOBAL AND LOCAL VARIABLES THAT SAVE
        useTheseSettings = false -- export: Toggle on to use the below preferences.  Toggle off to use saved preferences.  Preferences will save regardless when exiting seat. 
        freeLookToggle = true -- export: Set to false for default free look behavior.
        BrakeToggleDefault = true -- export: Whether your brake toggle is on/off by default.  Can be adjusted in the button menu
        RemoteFreeze = false -- export: Whether or not to freeze you when using a remote controller.  Breaks some things, only freeze on surfboards
        userControlScheme = "Virtual Joystick" -- export: Set to "Virtual Joystick", "Mouse", or "Keyboard"
        brightHud = false -- export: Enable to prevent hud dimming when in freelook.
        PrimaryR = 130 -- export: Primary HUD color
        PrimaryG = 224 -- export: Primary HUD color
        PrimaryB = 255 -- export: Primary HUD color
        centerX = 960 -- export: X postion of Artifical Horizon (KSP Navball), also determines placement of throttle. (use 1920x1080, it will scale) Use centerX=700 and centerY=980 for lower left placement.
        centerY = 540 -- export: Y postion of Artifical Horizon (KSP Navball), also determines placement of throttle. (use 1920x1080, it will scale) Use centerX=700 and centerY=980 for lower left placement. 
        throtPosX = 1110 -- export: X position of Throttle Indicator, default 1110 to put it to right of default AH centerX parameter.
        throtPosY = 540 -- export: Y position of Throttle indicator, default is 540 to place it centered on default AH centerY parameter.
        vSpdMeterX = 1525  -- export: X postion of Vertical Speed Meter.  Default 1525 (use 1920x1080, it will scale)
        vSpdMeterY = 250 -- export: Y postion of Vertical Speed Meter.  Default 250 (use 1920x1080, it will scale)
        altMeterX = 712  -- export: X postion of Vertical Speed Meter.  Default 712 (use 1920x1080, it will scale)
        altMeterY = 520 -- export: Y postion of Vertical Speed Meter.  Default 520 (use 1920x1080, it will scale)
        fuelX = 100 -- export: X position of fuel tanks, default is 100 for left side
        fuelY = 350 -- export: Y position of fuel tanks, default 350 for left side
        circleRad = 100 -- export: The size of the artifical horizon circle, set to 0 to remove.
        DeadZone = 50 -- export: Number of pixels of deadzone at the center of the screen
        showHud = true -- export: Uncheck to hide the HUD and only use autopilot features via ALT+# keys.
        hideHudOnToggleWidgets = true -- export: Uncheck to keep showing HUD when you toggle on the widgets via ALT+3.
        ShiftShowsRemoteButtons = true -- export: Whether or not pressing Shift in remote controller mode shows you the buttons (otherwise no access to them)
        speedChangeLarge = 5 -- export: The speed change that occurs when you tap speed up/down, default is 5 (25% throttle change). 
        speedChangeSmall = 1 -- export: the speed change that occurs while you hold speed up/down, default is 1 (5% throttle change).
        brakeLandingRate = 30 -- export: Max loss of altitude speed in m/s when doing a brake landing, default 30.  This is to prevent "bouncing" as hover/boosters catch you.  Do not use negative number.
        MaxPitch = 20 -- export: Maximum allowed pitch during takeoff and altitude changes while in altitude hold.  Default is 20 deg.  You can set higher or lower depending on your ships capabilities.
        ReentrySpeed = 1050 -- export: Target re-entry speed once in atmosphere in m/s.  291 = 1050 km/hr, higher might cause reentry burn.
        ReentryAltitude = 2500 -- export: Target alititude when using re-entry.
        EmergencyWarpDistance = 320000 -- export: Set to distance as which an emergency warp will occur if radar target within that distance.  320000 is lock range for large radar on large ship no special skills.
        AutoTakeoffAltitude = 1000 -- export: How high above your starting position AutoTakeoff tries to put you
        TargetHoverHeight = 50 -- export: Hover height when retracting landing gear
        LandingGearGroundHeight = 0 --export: Set to hover height reported - 1 when you use alt-spacebar to just lift off ground from landed postion.  4 is M size landing gear,
        MaxGameVelocity = 8333.00 -- export: Max speed for your autopilot in m/s, do not go above 8333.055 (30000 km/hr), can be reduced to safe fuel, use 6944.4444 for 25000km/hr
        AutopilotTargetOrbit = 100000 -- export: How far you want the orbit to be from the planet in m.  200,000 = 1SU
        AutopilotInterplanetaryThrottle = 1.0 -- export: How much throttle, 0.0 to 1.0, you want it to use when in autopilot to another planet to reach MaxGameVelocity
        warmup = 32 -- export: How long it takes your engines to warmup.  Basic Space Engines, from XS to XL: 0.25,1,4,16,32
        MouseYSensitivity = 0.003 --export:1 For virtual joystick only
        MouseXSensitivity = 0.003 -- export: For virtual joystick only
        autoRollPreference = false -- export: [Only in atmosphere]<br>When the pilot stops rolling,  flight model will try to get back to horizontal (no roll)
        turnAssist = true -- export: [Only in atmosphere]<br>When the pilot is rolling, the flight model will try to add yaw and pitch to make the construct turn better<br>The flight model will start by adding more yaw the more horizontal the construct is and more pitch the more vertical it is
        turnAssistFactor = 2 -- export: [Only in atmosphere]<br>This factor will increase/decrease the turnAssist effect<br>(higher value may be unstable)<br>Valid values: Superior or equal to 0.01
        pitchSpeedFactor = 0.8 -- export: For keyboard control
        yawSpeedFactor = 1 -- export: For keyboard control
        rollSpeedFactor = 1.5 -- export: This factor will increase/decrease the player input along the roll axis<br>(higher value may be unstable)<br>Valid values: Superior or equal to 0.01
        brakeSpeedFactor = 3 -- export: When braking, this factor will increase the brake force by brakeSpeedFactor * velocity<br>Valid values: Superior or equal to 0.01
        brakeFlatFactor = 1 -- export: When braking, this factor will increase the brake force by a flat brakeFlatFactor * velocity direction><br>(higher value may be unstable)<br>Valid values: Superior or equal to 0.01
        autoRollFactor = 2 -- export: [Only in atmosphere]<br>When autoRoll is engaged, this factor will increase to strength of the roll back to 0<br>Valid values: Superior or equal to 0.01
        DampingMultiplier = 40 -- export: How strongly autopilot dampens when nearing the correct orientation
        fuelTankOptimizationAtmo = 0 -- export: For accurate estimates, set this to the fuel tank optimization level of the person who placed the element. Ignored for slotted tanks.
        fuelTankOptimizationSpace = 0 -- export: For accurate estimates, set this to the fuel tank optimization level of the person who placed the element. Ignored for slotted tanks.
        fuelTankOptimizationRocket = 0 -- export: For accurate estimates, set this to the fuel tank optimization level of the person who placed the element. Ignored for slotted tanks.
        fuelTankHandlingAtmo = 0 -- export: For accurate estimates, set this to the fuel tank handling level of the person who placed the element. Ignored for slotted tanks.
        fuelTankHandlingSpace = 0 -- export: For accurate estimates, set this to the fuel tank handling level of the person who placed the element. Ignored for slotted tanks.
        fuelTankHandlingRocket = 0 -- export: For accurate estimates, set this to the fuel tank handling level of the person who placed the element. Ignored for slotted tanks.
        apTickRate = 0.0166667 -- export: Set the Tick Rate for your HUD.  0.016667 is effectively 60 fps and the default value. 0.03333333 is 30 fps.  The bigger the number the less often the autopilot and hud updates but may help peformance on slower machings.

        -- GLOBAL VARIABLES SECTION, USED OUTSIDE OF onStart
        ToggleView = true
        MinAutopilotSpeed = 55 -- Minimum speed for autopilot to maneuver in m/s.  Keep above 25m/s to prevent nosedives when boosters kick in
        LastMaxBrake = 0
        LastMaxBrakeInAtmo = 0
        EmergencyWarp = false
        ReentryMode = false
        MousePitchFactor = 1 -- Mouse control only
        MouseYawFactor = 1 -- Mouse control only
        HasGear = false
        PitchInput = 0
        PitchInput2 = 0
        YawInput2 = 0
        RollInput = 0
        YawInput = 0
        BrakeInput = 0
        RollInput2 = 0
        RetrogradeIsOn = false
        ProgradeIsOn = false
        Reentry = false
        FollowMode = false
        TurnBurn = false
        AutopilotAccelerating = false
        AutopilotRealigned = false
        HoldingCtrl = false
        PrevViewLock = 1
        MsgText = "empty"
        LastEccentricity = 1
        HoldAltitudeButtonModifier = 5
        AntiGravButtonModifier = 5
        IsBoosting = false -- Dodgin's Don't Die Rocket Govenor - Cruise Control Edition
        BrakeDistance, BrakeTime = 0
        MaxBrakeDistance, MaxBrakeTime = 0
        HasSpaceRadar = false
        HasAtmoRadar = false
        AutopilotTargetIndex = 0
        AutopilotTargetName = "None"
        AutopilotTargetPlanet = nil
        TotalDistanceTravelled = 0.0
        TotalDistanceTrip = 0
        InEmergencyWarp = false
        NotTriedEmergencyWarp = true
        FlightTime = 0
        WipedDatabank = false
        LocationIndex = 0
        UpAmount = 0
        BrakeIsOn = false
        Autopilot = false
        AltitudeHold = false
        BrakeLanding = false
        AutoTakeoff = false
        HoldAltitude = 1000 -- In case something goes wrong, give this a decent start value
        AutopilotBraking = false
        AutopilotCruising = false
        VectorToTarget = false    
        SimulatedX = 0
        SimulatedY = 0        
        AutopilotStatus = "Aligning"
        MsgTimer = 3
        TargetGroundAltitude = nil -- So it can tell if one loaded or not
        GearExtended = nil
        Distance = 0
        RadarMessage = ""
        LastOdometerOutput = ""
        Peris = 0
        AntigravTargetAltitude = nil
        CoreAltitude = core.getAltitude()
        ElementsID = core.getElementIdList()
        LastTravelTime = system.getTime()
        TotalFlightTime = 0
        HasGear = false
        AutopilotPlanetGravity = 0
        DisplayOrbit = true
        AutopilotEndSpeed = 0
        SavedLocations = {}
        LandingGearGroundHeight = 0
        AntigravJustToggledOn = false

        -- Local Variables used only within onStart
        local markers = {}
        local PreviousYawAmount = 0
        local PreviousPitchAmount = 0
        local damageMessage = ""
        local UnitHidden = true
        local Buttons = {}
        local AutopilotStrength = 1 -- How strongly autopilot tries to point at a target
        local alignmentTolerance = 0.001 -- How closely it must align to a planet before accelerating to it
        local ResolutionWidth = 2560
        local ResolutionHeight = 1440
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
        local RepairArrows = false
        local fuelTimeLeftR = {}
        local fuelPercentR = {}
        local FuelUpdateDelay = mfloor(1 / apTickRate) * 2
        local fuelTimeLeftS = {}
        local fuelPercentS = {}
        local fuelTimeLeft = {}
        local fuelPercent = {}
        local updateTanks = false
        local honeyCombMass = 0
        local lastConstructMass = constructMass()
        local coreOffset = 16
        local UpdateCount = 0

        -- VARIABLES TO BE SAVED GO HERE
        SaveableVariables = {"userControlScheme", "AutopilotTargetOrbit", "apTickRate", "freeLookToggle", "turnAssist",
                             "PrimaryR", "PrimaryG", "PrimaryB", "warmup", "DeadZone", "circleRad", "MouseXSensitivity",
                             "MouseYSensitivity", "MaxGameVelocity", "showHud", "autoRollPreference",
                             "pitchSpeedFactor", "yawSpeedFactor", "rollSpeedFactor", "brakeSpeedFactor",
                             "brakeFlatFactor", "autoRollFactor", "turnAssistFactor", "torqueFactor",
                             "AutoTakeoffAltitude", "TargetHoverHeight", "AutopilotInterplanetaryThrottle",
                             "hideHudOnToggleWidgets", "DampingMultiplier", "fuelTankOptimizationAtmo",
                             "fuelTankOptimizationSpace", "fuelTankOptimizationRocket", "fuelTankHandlingAtmo",
                             "fuelTankHandlingSpace", "fuelTankHandlingRocket", "RemoteFreeze",
                             "speedChangeLarge", "speedChangeSmall", "brightHud", "brakeLandingRate", "MaxPitch",
                             "ReentrySpeed", "ReentryAltitude", "EmergencyWarpDistance", "centerX", "centerY",
                             "vSpdMeterX", "vSpdMeterY", "altMeterX", "altMeterY", "LandingGearGroundHeight"}
        AutoVariables = {"EmergencyWarp", "brakeToggle", "BrakeIsOn", "RetrogradeIsOn", "ProgradeIsOn",
                         "Autopilot", "TurnBurn", "AltitudeHold", "DisplayOrbit", "BrakeLanding",
                         "Reentry", "AutoTakeoff", "HoldAltitude", "AutopilotAccelerating", "AutopilotBraking",
                         "AutopilotCruising", "AutopilotRealigned", "AutopilotEndSpeed", "AutopilotStatus",
                         "AutopilotPlanetGravity", "PrevViewLock", "AutopilotTargetName", "AutopilotTargetCoords",
                         "AutopilotTargetIndex", "GearExtended", "TargetGroundAltitude", "TotalDistanceTravelled",
                         "TotalFlightTime", "SavedLocations", "VectorToTarget", "LocationIndex", "LastMaxBrake", "LastMaxBrakeInAtmo",
                        "AntigravJustToggledOn"}

        -- BEGIN CONDITIONAL CHECKS DURING STARTUP
        -- Load Saved Variables
        if dbHud then
            local hasKey = dbHud.hasKey
            if not useTheseSettings then
                for k, v in pairs(SaveableVariables) do
                    if hasKey(v) then
                        local result = jdecode(dbHud.getStringValue(v))
                        if result ~= nil then
                            system.print(v .. " " .. dbHud.getStringValue(v))
                            _G[v] = result
                            valuesAreSet = true
                        end
                    end
                end
            end
            for k, v in pairs(AutoVariables) do
                if hasKey(v) then
                    local result = jdecode(dbHud.getStringValue(v))
                    if result ~= nil then
                        system.print(v .. " " .. dbHud.getStringValue(v))
                        _G[v] = result
                        valuesAreSet = true
                    end
                end
            end
            if valuesAreSet then
                MsgText = "Loaded Saved Variables (see Lua Chat Tab for list)"
            elseif useTheseSettings then
                MsgText = "Updated user preferences used.  Will be saved when you exit seat.  Toggle off useTheseSettings to use saved values"
            else
                MsgText = "No Saved Variables Found - Stand up / leave remote to save settings"
            end
        else
            MsgText = "No databank found, install one anywhere and rerun the autoconfigure to save variables"
        end
       -- Loading saved vars is hard on it
        brakeToggle = BrakeToggleDefault
        autoRoll = autoRollPreference
        honeyCombMass = lastConstructMass - updateMass()
        rgb = [[rgb(]] .. mfloor(PrimaryR + 0.5) .. "," .. mfloor(PrimaryG + 0.5) .. "," .. mfloor(PrimaryB + 0.5) ..
                  [[)]]
        local rgbdim = [[rgb(]] .. mfloor(PrimaryR * 0.9 + 0.5) .. "," .. mfloor(PrimaryG * 0.9 + 0.5) .. "," ..
                     mfloor(PrimaryB * 0.9 + 0.5) .. [[)]]
        coroutine.yield() -- Give it some time to breathe before we do the rest
        for k in pairs(ElementsID) do
            local name = eleType(ElementsID[k])
            if (name == "landing gear") then
                HasGear = true
            end
            if (name == "dynamic core") then
                local hp = eleMaxHp(ElementsID[k])
                if hp > 10000 then
                    coreOffset = 128
                elseif hp > 1000 then
                    coreOffset = 64
                elseif hp > 150 then
                    coreOffset = 32
                end
            end
            eleTotalMaxHp = eleTotalMaxHp + eleMaxHp(ElementsID[k])
            if (name == "atmospheric fuel-tank" or name == "space fuel-tank" or name == "rocket fuel-tank") then
                local hp = eleMaxHp(ElementsID[k])
                local mass = eleMass(ElementsID[k])
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
                    curMass = mass - massEmpty
                    if fuelTankHandlingAtmo > 0 then
                        vanillaMaxVolume = vanillaMaxVolume + (vanillaMaxVolume * (fuelTankHandlingAtmo * 0.2))
                    end
                    if fuelTankOptimizationAtmo > 0 then
                        vanillaMaxVolume = vanillaMaxVolume + (vanillaMaxVolume * (fuelTankOptimizationAtmo * 0.05))
                    end
                    if curMass > vanillaMaxVolume then
                        vanillaMaxVolume = curMass
                    end
                    atmoTanks[#atmoTanks + 1] = {ElementsID[k], core.getElementNameById(ElementsID[k]),
                                                 vanillaMaxVolume, massEmpty, curMass, curTime}
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
                    curMass = mass - massEmpty
                    if fuelTankHandlingRocket > 0 then
                        vanillaMaxVolume = vanillaMaxVolume + (vanillaMaxVolume * (fuelTankHandlingRocket * 0.2))
                    end
                    if fuelTankOptimizationRocket > 0 then
                        vanillaMaxVolume = vanillaMaxVolume + (vanillaMaxVolume * (fuelTankOptimizationRocket * 0.05))
                    end
                    if curMass > vanillaMaxVolume then
                        vanillaMaxVolume = curMass
                    end
                    rocketTanks[#rocketTanks + 1] = {ElementsID[k], core.getElementNameById(ElementsID[k]),
                                                     vanillaMaxVolume, massEmpty, curMass, curTime}
                end
                if (name == "space fuel-tank") then
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
                    if fuelTankOptimizationSpace > 0 then
                        vanillaMaxVolume = vanillaMaxVolume + (vanillaMaxVolume * (fuelTankOptimizationSpace * 0.05))
                    end
                    if curMass > vanillaMaxVolume then
                        vanillaMaxVolume = curMass
                    end
                    spaceTanks[#spaceTanks + 1] = {ElementsID[k], core.getElementNameById(ElementsID[k]),
                                                   vanillaMaxVolume, massEmpty, curMass, curTime}
                end
            end
        end
        if gyro ~= nil then
            GyroIsOn = gyro.getState() == 1
        end

        if userControlScheme ~= "Keyboard" then
            system.lockView(1)
        else
            system.lockView(0)
        end
        if atmosphere() > 0 then
            BrakeIsOn = true
        end
        if radar_1 then
            if eleType(radar_1.getId()) == "Space Radar" then
                HasSpaceRadar = true
            else
                HasAtmoRadar = true
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
        if HasGear then
            GearExtended = (Nav.control.isAnyLandingGearExtended() == 1)
            if GearExtended then
                Nav.control.extendLandingGears()
            else
                Nav.control.retractLandingGears()
            end
        end
        if TargetGroundAltitude ~= nil then
            Nav.axisCommandManager:setTargetGroundAltitude(TargetGroundAltitude)
            if TargetGroundAltitude == 0 and not HasGear then 
                GearExtended = true 
            end
        else 
            if GearExtended or not HasGear then
                Nav.axisCommandManager:setTargetGroundAltitude(LandingGearGroundHeight)
                GearExtended = true
            else
                Nav.axisCommandManager:setTargetGroundAltitude(TargetHoverHeight)
            end
        end
        if atmosphere() > 0 and not dbHud and (GearExtended or not HasGear) then
            BrakeIsOn = true
        end
        WasInAtmo = (atmosphere() > 0)
        unit.hide()

        -- BEGIN FUNCTION DEFINITIONS

        function refreshLastMaxBrake(gravity, force)
            if gravity == nil then
                gravity = core.g()
            end

            gravity = round(gravity, 5) -- round to avoid insignificant updates
            if (force ~= nil and force) or (lastMaxBrakeAtG == nil or lastMaxBrakeAtG ~= gravity) then
                local maxBrake = jdecode(unit.getData()).maxBrake

                if maxBrake ~= nil then
                    LastMaxBrake = maxBrake
                end
                if atmosphere() > 0 then
                    LastMaxBrakeInAtmo = maxBrake
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

        function AddNewLocation() -- Don't call this unless they have a databank or it's kinda pointless
            -- Add a new location to SavedLocations
            if dbHud then
                local position = vec3(core.getConstructWorldPos())
                local name = planet.name .. ". " .. #SavedLocations
                                                      
                if radar_1 then -- Just match the first one
                    local id,_ = radar_1.getData():match('"constructId":"([0-9]*)","distance":([%d%.]*)')
                    if id ~= nil and id ~= "" then
                        name = name .. " " .. radar_1.getConstructName(id)
                    end
                end
                local newLocation = {
                    position = position,
                    name = name,
                    atmosphere = unit.getAtmosphereDensity(),
                    planetname = planet.name,
                    gravity = unit.getClosestPlanetInfluence()
                }
                SavedLocations[#SavedLocations + 1] = newLocation
                -- Nearest planet, gravity also important - if it's 0, we don't autopilot to the target planet, the target isn't near a planet.                      
                table.insert(atlas[0], newLocation)
                UpdateAtlasLocationsList()
                -- Store atmosphere so we know whether the location is in space or not
                MsgText = "Location saved as " .. name
            else
                MsgText = "Databank must be installed to save locations"
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
                    MsgText = v.name .. " saved location cleared"
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
            if radarPanelID ~= nil and Peris == 0 then
                system.destroyWidgetPanel(radarPanelID)
                radarPanelID = nil
                if perisPanelID ~= nil then
                    system.destroyWidgetPanel(perisPanelID)
                    perisPanelID = nil
                end
            else
                -- If radar is installed but no weapon, don't show periscope
                if Peris == 1 then
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
                Peris = 0
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

        -- Interplanetary helper
        function SetupInterplanetaryPanel()
            InAtmo = (atmosphere() > 0)
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
            widgetMaxMass = system.createWidget(panelInterplanetary, "value")
            widgetMaxMassText = system.createData('{"label": "Maximum Mass", "value": "N/A", "unit":""}')
            system.addDataToWidget(widgetMaxMassText, widgetMaxMass)
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
            widgetTrajectoryAltitudeText = system.createData(
                                               '{"label": "Projected Altitude", "value": "N/A", "unit":""}')
            if not InAtmo then
                system.addDataToWidget(widgetTrajectoryAltitudeText, widgetTrajectoryAltitude)
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

        function ToggleVectorToTarget()
            -- This is a feature to vector toward the target destination in atmo or otherwise on-planet
            -- Uses altitude hold.  
            VectorToTarget = not VectorToTarget
            if VectorToTarget then
                TurnBurn = false
                if not AltitudeHold then
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
                StrongBrakes = ((planet.gravity * 9.80665 * core.getConstructMass()) < LastMaxBrake)
                if not StrongBrakes and velMag > MinAutopilotSpeed then
                    MsgText = "WARNING: Insufficient Brakes - Attempting coast landing, beware obstacles"
                end
                if not AltitudeHold then
                    ToggleAltitudeHold()
                end
                AutoTakeoff = false
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
                HoldAltitude = CoreAltitude + AutoTakeoffAltitude
                GearExtended = false
                Nav.control.retractLandingGears()
                Nav.axisCommandManager:setTargetGroundAltitude(500) -- Hard set this for takeoff, you wouldn't use takeoff from a hangar
                BrakeIsOn = true
            end
        end

        function ToggleAltitudeHold()
            AltitudeHold = not AltitudeHold
            if AltitudeHold then
                Autopilot = false
                ProgradeIsOn = false
                RetrogradeIsOn = false
                FollowMode = false
                BrakeLanding = false
                Reentry = false
                autoRoll = true
                if (not GearExtended and not BrakeIsOn) or atmosphere() == 0 then -- Never autotakeoff in space
                    AutoTakeoff = false
                    HoldAltitude = CoreAltitude
                    if Nav.axisCommandManager:getAxisCommandType(0) == 0 then
                        Nav.control.cancelCurrentControlMasterMode()
                    end
                else
                    AutoTakeoff = true
                    HoldAltitude = CoreAltitude + AutoTakeoffAltitude
                    GearExtended = false
                    Nav.control.retractLandingGears()
                    Nav.axisCommandManager:setTargetGroundAltitude(500)
                    BrakeIsOn = true -- Engage brake for warmup
                end
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
                FollowMode = not FollowMode
                if FollowMode then
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
                    Nav.axisCommandManager:setTargetGroundAltitude(500) -- Hard-set this for auto-follow
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
                MsgText = "Follow Mode only works with Remote controller"
                FollowMode = false
            end
        end

        function ToggleAutopilot()
            -- Toggle Autopilot, as long as the target isn't None
            if AutopilotTargetIndex > 0 and not Autopilot then
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

                if CustomTarget ~= nil then
                    StrongBrakes = ((planet.gravity * 9.80665 * core.getConstructMass()) < LastMaxBrake)
                    if not StrongBrakes and velMag > MinAutopilotSpeed then
                        MsgText = "Insufficient Brake Force\nCoast landing will be inaccurate"
                    end
                    -- Going to need to add all those conditions here.  Let's start with the easiest.
                    if unit.getAtmosphereDensity() > 0 then
                        if not AltitudeHold then
                            -- Autotakeoff gets engaged inside the toggle if conditions are met
                            if not VectorToTarget then
                                ToggleVectorToTarget()
                            end
                        else
                            -- Vector to target
                            if not VectorToTarget then
                                ToggleVectorToTarget()
                            end
                        end -- TBH... this is the only thing we need to do, make sure Alt Hold is on.  
                    end
                elseif unit.getAtmosphereDensity() == 0 then -- Planetary autopilot
                    Autopilot = true
                    RetrogradeIsOn = false
                    ProgradeIsOn = false
                    AutopilotRealigned = false
                    FollowMode = false
                    AltitudeHold = false
                    BrakeLanding = false
                    Reentry = false
                    AutoTakeoff = false
                end
            else
                Autopilot = false
                AutopilotRealigned = false
                VectorToTarget = false
            end
        end

        function ProgradeToggle()
            -- Toggle Progrades
            ProgradeIsOn = not ProgradeIsOn
            RetrogradeIsOn = false -- Don't let both be on
            Autopilot = false
            AltitudeHold = false
            FollowMode = false
            BrakeLanding = false
            Reentry = false
            AutoTakeoff = false
        end

        function RetrogradeToggle()
            -- Toggle Retrogrades
            RetrogradeIsOn = not RetrogradeIsOn
            ProgradeIsOn = false -- Don't let both be on
            Autopilot = false
            AltitudeHold = false
            FollowMode = false
            BrakeLanding = false
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
                autoRoll = autoRollPreference
            end
        end

        function checkDamage(newContent)
            local percentDam = 0
            damageMessage = ""
            currentConstructMass = constructMass()
            local maxShipHP = eleTotalMaxHp
            local curShipHP = 0
            local voxelDam = 100
            local damagedElements = 0
            local disabledElements = 0
            local colorMod = 0
            local color = ""
            for k in pairs(ElementsID) do
                local hp = 0
                local mhp = 0
                mhp = eleMaxHp(ElementsID[k])
                hp = eleHp(ElementsID[k])
                curShipHP = curShipHP + hp
                if (hp < mhp) then
                    if (hp == 0) then
                        disabledElements = disabledElements + 1
                    else
                        damagedElements = damagedElements + 1
                    end
                    -- Thanks to Jerico for the help and code starter for arrow markers!
                    if RepairArrows and #markers == 0 then
                        position = vec3(core.getElementPositionById(ElementsID[k]))
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
                        table.insert(markers, ElementsID[k])
                    end
                elseif RepairArrows and #markers > 0 and markers[11] == ElementsID[k] then
                    for j in pairs(markers) do
                        core.deleteSticker(markers[j])
                    end
                    markers = {}
                end
            end
            percentDam = mfloor((curShipHP / maxShipHP)*100)
            if currentConstructMass < lastConstructMass then
                voxelDam = math.ceil( ((currentConstructMass - updateMass()) / honeyCombMass) * 100)
                lastConstructMass = currentConstructMass
            end
            if voxelDam < 100 or percentDam < 100 then
                newContent[#newContent + 1] = [[<g class="pbright txt">]]
                if voxelDam < 100 then
                    colorMod = mfloor(voxelDam * 2.55)
                    color = stringf("rgb(%d,%d,%d)", 255 - colorMod, colorMod, 0)
                    newContent[#newContent + 1] = stringf(
                                                      [[<text class="txtbig txtmid" x=50%% y="1015" style="fill:%s">Structural Integrity: %i %%</text>]],
                                                      color, voxelDam)
                end
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
            local strokeColor = mfloor(utils.clamp((Distance / (ResolutionWidth / 4)) * 255, 0, 255))
            newContent[#newContent + 1] = stringf(
                                              "<line x1='0' y1='0' x2='%fpx' y2='%fpx' style='stroke:rgb(%d,%d,%d);stroke-width:2;transform:translate(50%%, 50%%)' />",
                                              SimulatedX, SimulatedY, mfloor(PrimaryR + 0.5) + strokeColor,
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

        function wipeSaveVariables()
            if not dbHud then
                MsgText =
                    "No Databank Found, unable to wipe. \nYou must have a Databank attached to ship prior to running the HUD autoconfigure"
                MsgTimer = 5
            elseif valuesAreSet then
                if doubleCheck then
                    -- If any values are set, wipe them all
                    for k, v in pairs(SaveableVariables) do
                        dbHud.setStringValue(v, jencode(nil))
                    end
                    for k, v in pairs(AutoVariables) do
                        if v ~= "SavedLocations" then dbHud.setStringValue(v, jencode(nil)) end
                    end
                    MsgText =
                        "Databank wiped. New variables will save after re-enter seat and exit"
                    MsgTimer = 5
                    doubleCheck = false
                    valuesAreSet = false
                    WipedDatabank = true
                else
                    MsgText = "Press ALT-7 again to confirm wipe"
                    doubleCheck = true
                end
            end
        end

        function CheckButtons()
            for _, v in pairs(Buttons) do
                if v.hovered then
                    v.toggleFunction()
                    v.hovered = false
                end
            end
        end

        function SetButtonContains()
            local x = SimulatedX + ResolutionWidth / 2
            local y = SimulatedY + ResolutionHeight / 2
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
            if isRemote() == 1 then
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
                        if tankTable[i][tankName] == json.decode(unit[slottedTankType .. "_" .. j].getData()).name then
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
                            fuelPercentTable[i] = json.decode(unit[slottedTankType .. "_" .. slottedIndex].getData())
                                                      .percentage
                            fuelTimeLeftTable[i] = json.decode(unit[slottedTankType .. "_" .. slottedIndex].getData())
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
            local yaw = math.deg(math.atan(velocity.y, velocity.x)) - 90
            if yaw < -180 then
                yaw = 360 + yaw
            end
            return yaw
        end

        function AlignToWorldVector(vector, tolerance)
            -- Sets inputs to attempt to point at the autopilot target
            -- Meant to be called from Update or Tick repeatedly
            if tolerance == nil then
                tolerance = alignmentTolerance
            end
            vector = vec3(vector):normalize()
            local targetVec = (vec3(core.getConstructWorldOrientationForward()) - vector)
            local yawAmount = -getMagnitudeInDirection(targetVec, core.getConstructWorldOrientationRight()) *
                                  AutopilotStrength
            local pitchAmount = -getMagnitudeInDirection(targetVec, core.getConstructWorldOrientationUp()) *
                                    AutopilotStrength

            YawInput2 = YawInput2 - (yawAmount + (yawAmount - PreviousYawAmount) * DampingMultiplier)
            PitchInput2 = PitchInput2 + (pitchAmount + (pitchAmount - PreviousPitchAmount) * DampingMultiplier)
            PreviousYawAmount = yawAmount
            PreviousPitchAmount = pitchAmount
            -- Return true or false depending on whether or not we're aligned
            if math.abs(yawAmount) < tolerance and math.abs(pitchAmount) < tolerance then
                return true
            end
            return false
        end

        function getAPEnableName()
            local name = AutopilotTargetName
            if name == nil then
                name = CustomTarget.name .. " " ..
                           getDistanceDisplayString((vec3(core.getConstructWorldPos()) - CustomTarget.position):len())
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
            if antigrav then
                if antigrav.getState() == 1 then
                    antigrav.deactivate()
                    AntigravTargetAltitude = nil
                    antigrav.hide()
                    AntigravJustToggledOn = false
                else
                    AntigravTargetAltitude = CoreAltitude
                    if AntigravTargetAltitude < 1000 then
                        AntigravTargetAltitude = 1000
                    end
                    antigrav.activate()
                    AntigravJustToggledOn = true
                    antigrav.show()
                end
            end
        end

        function BeginReentry()
            if Reentry then
                MsgText = "Re-Entry cancelled"
                Reentry = false
                autoRoll = autoRollPreference
                AltitudeHold = false
            elseif unit.getAtmosphereDensity() ~= 0 or unit.getClosestPlanetInfluence() <= 0 or Reentry or not planet.atmos then
                MsgText = "Re-Entry requirements not met: you must start out of atmosphere and within a planets gravity well over a planet with atmosphere"
                MsgTimer = 5
            elseif not ReentryMode then-- Parachute ReEntry
                StrongBrakes = ((planet.gravity * 9.80665 * core.getConstructMass()) < LastMaxBrakeInAtmo)
                if not StrongBrakes  then
                    MsgText = "WARNING: Insufficient Brakes for Parachute Re-Entry"
                else
                    Reentry = true
                    if Nav.axisCommandManager:getAxisCommandType(0) ~= controlMasterModeId.cruise then
                        Nav.control.cancelCurrentControlMasterMode()
                    end                
                    autoroll = true
                    BrakeIsOn = false
                    MsgText = "Beginning Parachute Re-Entry - Strap In.  Target speed: " .. ReentrySpeed
                end
            else --Glide Reentry
                Reentry = true
                if Nav.axisCommandManager:getAxisCommandType(0) ~= controlMasterModeId.cruise then
                    Nav.control.cancelCurrentControlMasterMode()
                end
                AltitudeHold = true
                autoroll = true
                BrakeIsOn = false
                HoldAltitude = ReentryAltitude
                MsgText = "Beginning Re-entry.  Target speed: " .. ReentrySpeed .. " Target Altitude: " ..
                            ReentryAltitude
            end
        end
        -- BEGIN BUTTON DEFINITIONS

        -- enableName, disableName, width, height, x, y, toggleVar, toggleFunction, drawCondition
        local buttonHeight = 50
        local buttonWidth = 260 -- Defaults
        local brake = MakeButton("Enable Brake Toggle", "Disable Brake Toggle", buttonWidth, buttonHeight,
                          ResolutionWidth / 2 - buttonWidth / 2, ResolutionHeight / 2 + 350, function()
                return brakeToggle
            end, function()
                brakeToggle = not brakeToggle
                if (brakeToggle) then
                    MsgText = "Brakes in Toggle Mode"
                else
                    MsgText = "Brakes in Default Mode"
                end
            end)
        MakeButton("Align Prograde", "Disable Prograde", buttonWidth, buttonHeight,
            ResolutionWidth / 2 - buttonWidth / 2 - 50 - brake.width, ResolutionHeight / 2 - buttonHeight + 380,
            function()
                return ProgradeIsOn
            end, ProgradeToggle)
        MakeButton("Align Retrograde", "Disable Retrograde", buttonWidth, buttonHeight,
            ResolutionWidth / 2 - buttonWidth / 2 + brake.width + 50, ResolutionHeight / 2 - buttonHeight + 380,
            function()
                return RetrogradeIsOn
            end, RetrogradeToggle, function()
                return unit.getAtmosphereDensity() == 0
            end) -- Hope this works
        local apbutton = MakeButton(getAPEnableName, getAPDisableName, 600, 60, ResolutionWidth / 2 - 600 / 2,
                             ResolutionHeight / 2 - 60 / 2 - 400, function()
                return Autopilot
            end, ToggleAutopilot)
        MakeButton("Save Position", "Save Position", 200, apbutton.height, apbutton.x + apbutton.width + 30, apbutton.y,
            function()
                return false
            end, AddNewLocation)
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
        local y = ResolutionHeight / 2 - 300
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
                    MsgText = "Orbit Display Enabled"
                else
                    MsgText = "Orbit Display Disabled"
                end
            end)
        MakeButton("Enable Emergency Warp", "Disable Emergency Warp", buttonWidth, buttonHeight, x + buttonWidth + 20, y, function()
            return EmergencyWarp
        end, function()
            EmergencyWarp = not EmergencyWarp
            if (EmergencyWarp) then
                MsgText = "Emergency Warp Enabled"
            else
                MsgText = "Emergency Warp Disabled"
            end
        end, function()
            return warpdrive ~= nil
        end)
        y = y + buttonHeight + 20
        MakeButton("Glide Re-Entry", "Cancel Glide Re-Entry", buttonWidth, buttonHeight, x, y,
            function() return Reentry end, function() ReentryMode = true BeginReentry() end, function() return (CoreAltitude > ReentryAltitude) end )
        MakeButton("Parachute Re-Entry", "Cancel Parachute Re-Entry", buttonWidth, buttonHeight, x + buttonWidth + 20, y,
            function() return Reentry end, BeginReentry, function() return (CoreAltitude > ReentryAltitude) end )
        y = y + buttonHeight + 20
        MakeButton("Engage Follow Mode", "Disable Follow Mode", buttonWidth, buttonHeight, x, y, function()
            return FollowMode
        end, ToggleFollowMode, function()
            return isRemote() == 1
        end)
        MakeButton("Enable Repair Arrows", "Disable Repair Arrows", buttonWidth, buttonHeight, x + buttonWidth + 20, y, function()
            return RepairArrows
        end, function()
            RepairArrows = not RepairArrows
            if (RepairArrows) then
                MsgText = "Repair Arrows Enabled"
            else
                MsgText = "Repair Arrows Diabled"
            end
        end, function()
            return isRemote() == 1
        end)
        y = y + buttonHeight + 20
        MakeButton("Enable AGG", "Disable AGG", buttonWidth, buttonHeight, x, y, function()
            return antigrav.getState() == 0 end, ToggleAntigrav, function()
            return antigrav ~= nil
        end)   
        y = y + buttonHeight + 20
        MakeButton(function()
            return string.format("Toggle Control Scheme - Current: %s", userControlScheme)
        end, function()
            return string.format("Control Scheme: %s", userControlScheme)
        end, buttonWidth * 2, buttonHeight, x, y, function()
            return false
        end, function()
            if userControlScheme == "Keyboard" then
                userControlScheme = "Mouse"
            elseif userControlScheme == "Mouse" then
                userControlScheme = "Virtual Joystick"
            else
                userControlScheme = "Keyboard"
            end
        end)
        coroutine.yield() -- Just to make sure

        -- HUD - https://github.com/Rezoix/DU-hud with major modifications by Archeageo
        function updateHud(newContent)

            local altitude = CoreAltitude
            local velocity = core.getVelocity()
            local speed = vec3(velocity):len()
            local worldV = vec3(core.getWorldVertical())
            local constrF = vec3(core.getConstructWorldOrientationForward())
            local constrR = vec3(core.getConstructWorldOrientationRight())
            local pitch = getPitch(worldV, constrF, constrR) -- 180 - getRoll(worldV, constrR, constrF)
            local roll = getRoll(worldV, constrF, constrR) -- getRoll(worldV, constrF, constrR)
            local originalRoll = roll
            local originalPitch = pitch
            local atmos = atmosphere()
            local throt = mfloor(unit.getThrottle())
            local spd = speed * 3.6
            local flightValue = unit.getAxisCommandValue(0)
            local flightStyle = GetFlightStyle()

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

            -- CRUISE/ODOMETER

            newContent[#newContent + 1] = LastOdometerOutput

            -- DAMAGE

            newContent[#newContent + 1] = damageMessage

            -- RADAR

            newContent[#newContent + 1] = RadarMessage

            -- FUEL TANKS

            if (UpdateCount % FuelUpdateDelay == 0) then
                updateTanks = true
            end
            if (fuelX ~= 0 and fuelY ~= 0) then
                DrawTank(newContent, updateTanks, fuelX, "Atmospheric ", "ATMO", atmoTanks, fuelTimeLeft, fuelPercent)
                DrawTank(newContent, updateTanks, fuelX+100, "Space fuel t", "SPACE", spaceTanks, fuelTimeLeftS, fuelPercentS)
                DrawTank(newContent, updateTanks, fuelX+200, "Rocket fuel ", "ROCKET", rocketTanks, fuelTimeLeftR, fuelPercentR)
            end

            if updateTanks then
                updateTanks = false
                UpdateCount = 0
            end
            UpdateCount = UpdateCount + 1

            -- PRIMARY FLIGHT INSTRUMENTS

            DrawVerticalSpeed(newContent, altitude, atmos) -- Weird this is draw during remote control...?


            if isRemote() == 0 then
                -- Don't even draw this in freelook
               if not IsInFreeLook() or brightHud then
                    if unit.getClosestPlanetInfluence() > 0 then
                        DrawArtificialHorizon(newContent, originalPitch, originalRoll, atmos, centerX, centerY, "ROLL")
                        DrawPrograde(newContent, atmos, velocity, speed, centerX, centerY)
                        DrawAltitudeDisplay(newContent, altitude, atmos)
                    else
                        DrawArtificialHorizon(newContent, pitch, roll, atmos, centerX, centerY, "YAW")
                        DrawPrograde(newContent, atmos, velocity, speed, centerX, centerY)
                    end
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
            return system.isViewLocked() == 0 and userControlScheme ~= "Keyboard" and isRemote() == 0
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
                        .ah {opacity:0.1;fill:#0083cb;stroke:black;stroke-width:2px}
                        .ahg {opacity:0.3;fill:#6b5835}
                    </style>
                </head>
                <body>
                    <svg height="100%%" width="100%%" viewBox="0 0 1920 1080">
                    ]], bright, bright, brightOrig, brightOrig, dim, dim, dimOrig, dimOrig)
        end

        function HUDEpilogue(newContent)
            newContent[#newContent + 1] = "</svg>"
        end

        function DrawSpeed(newContent, spd)
            local ys2 = altMeterY + 40
            local x1 = altMeterX
            newContent[#newContent + 1] = [[<g class="pdim txt txtend">]]
            if isRemote() == 1 then
                ys2 = 75
            end
            newContent[#newContent + 1] = stringf([[
                <g class="pbright txtstart">
                    <text class="txtbig" x="%d" y="%d">%d km/h</text>
                </g>
            </g>]], x1, ys2, mfloor(spd))
        end

        function DrawOdometer(newContent, TotalDistanceTrip, TotalDistanceTravelled, flightStyle, flightTime)
            local xg = 1240
            local yg1 = 55
            local yg2 = 65
            local atmos = atmosphere()
            local gravity = core.g()
            local maxMass = 0
            local reqThrust = 0
            refreshLastMaxBrake(gravity)
            maxThrust = Nav:maxForceForward()
            totalMass = constructMass()
            local accel = (vec3(core.getWorldAcceleration()):len() / 9.80665)
            if gravity > 0.1 then
                reqThrust = totalMass * gravity
                maxMass = maxThrust / gravity
            end
            newContent[#newContent + 1] = [[<g class="pdim txt txtend">]]
            if isRemote() == 1 then
                xg = 1120
                yg1 = 55
                yg2 = 65
            elseif atmos > 0 then -- We only show atmo when not remote
                newContent[#newContent + 1] = stringf([[
                    <text x="770" y="55">ATMOSPHERE</text>
                    <text x="770" y="65">%.2f</text>
                ]], atmos)
            end
            newContent[#newContent + 1] = stringf([[
                <g class="pbright txtend">
                </g>
                <text x="%d" y="%d">GRAVITY</text>
                <text x="%d" y="%d">%.2f g</text>
                <text x="%d" y="%d">ACCEL</text>
                <text x="%d" y="%d">%.2f g</text>
                ]], xg, yg1, xg, yg2, (gravity / 9.80665), xg, yg1 + 20, xg, yg2 + 20, accel)
            newContent[#newContent + 1] = [[<g class="pbright txt">
                    <path class="linethick" d="M 660 0 L 700 35 Q 960 55 1240 35 L 1280 0"/>]]
            if isRemote() == 0 then
                newContent[#newContent + 1] = stringf([[
                    <text class="txtstart" x="700" y="20" >Trip: %.2f km</text>
                    <text class="txtstart" x="700" y="30">Lifetime: %.2f Mm</text>
                    <text class="txtstart" x="830" y="20">Trip Time: %s</text>
                    <text class="txtstart" x="830" y="30">Total Time: %s</text>
                    <text class="txtstart" x="970" y="20">Mass: %.2f Tons</text>
                    <text class="txtend" x="1240" y="10">Max Brake: %.2f kN</text>
                    <text class="txtend" x="1240" y="30">Max Thrust: %.2f kN</text>
                    <text class="txtbig txtmid" x="960" y="130">%s</text>
                ]], TotalDistanceTrip, (TotalDistanceTravelled / 1000), FormatTimeString(flightTime),
                                                  FormatTimeString(TotalFlightTime), (totalMass / 1000),
                                                  (LastMaxBrake / 1000), (maxThrust / 1000), flightStyle)
                if gravity > 0.1 then
                    newContent[#newContent + 1] = stringf([[
                            <text class="txtstart" x="970" y="30">Max Mass: %.2f Tons</text>
                            <text class="txtend" x="1240" y="20">Req Thrust: %.2f kN</text>
                    ]], (maxMass / 1000), (reqThrust / 1000))
                else
                    newContent[#newContent + 1] = [[
                        <text class="txtstart" x="970" y="30" text-anchor="start">Max Mass: n/a</text>
                        <text class="txtend" x="1240" y="20" text-anchor="end">Req Thrust: n/a</text>
                    ]]
                end
            else -- If remote controlled, draw stuff near the top so it's out of the way
                newContent[#newContent + 1] = stringf([[<text class="txtbig txtmid" x="960" y="33">%s</text>]],
                                                  flightStyle)
            end
            newContent[#newContent + 1] = "</g>"
        end

        function DrawThrottle(newContent, flightStyle, throt, flightValue)

            local y1 = throtPosY+65
            local y2 = throtPosY+75
            if isRemote() == 1 then
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
                    throtPosX-20, throtPosY+50, throtPosX-25, throtPosY+53, throtPosX-25, throtPosY+47)
            end
            newContent[#newContent + 1] = stringf([[
                <g class="pbright txtstart">
                        <text x="%d" y="%d">%s</text>
                        <text x="%d" y="%d">%d %s</text>
                </g>
            </g>]], throtPosX, y1, label, throtPosX, y2, value, unit)
        end

        -- Draw vertical speed indicator - Code by lisa-lionheart 
        function DrawVerticalSpeed(newContent, altitude, atmos)
            if (altitude < 200000 and atmos == 0) or (altitude and atmos > 0) then
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

        function DrawArtificialHorizon(newContent, originalPitch, originalRoll, atmos, centerX, centerY, bottomText)
            -- ** CIRCLE ALTIMETER  - Base Code from Discord @Rainsome = Youtube CaptainKilmar** 
            local horizonRadius = circleRad -- Aliased global
            if horizonRadius > 0 then
                local pitchC = mfloor(originalPitch)
                local rollC = mfloor(originalRoll)
                local len = 0
                local tickerPath = stringf([[<path transform="rotate(%f,%d,%d)" class="dim line" d="]], (-1 * originalRoll), centerX, centerY)
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
                        tickerPath = stringf([[%s M %d %f h %d]], tickerPath, centerX-15, y, len)
                    else
                        tickerPath = stringf([[%s M %d %f h %d]], tickerPath, centerX-10, y, len)
                    end
                end
                newContent[#newContent + 1] = tickerPath .. [["/>]]
                local pitchstring = "PITCH"                
                if bottomText == "YAW" then 
                    pitchstring = "REL PITCH"
                end
                if originalPitch > 90 and atmos == 0 then
                    originalPitch = 90 - (originalPitch - 90)
                elseif originalPitch < -90 and atmos == 0 then
                    originalPitch = -90 - (originalPitch + 90)
                end
                newContent[#newContent + 1] = stringf([[<path d="m %d,%d 35,0 15,15 15,-15 35,0" stroke-width="2" style="fill:none;stroke:#F5B800;" />]],
                    centerX-50, centerY)
                newContent[#newContent + 1] = stringf([[
                    <circle class="ah" r="%f" cx="%d" cy="%d"/>
                        
                        <rect class="ahg" x="%f" y="%f" height="%f" width="%f" transform="rotate(%f %d %d)"/>]],
                                                  horizonRadius, centerX, centerY, (centerX - horizonRadius),
                                                  (centerY + horizonRadius * (originalPitch / 20)), (horizonRadius * 9), -- Cover 180 degrees
                                                  (horizonRadius * 2), (-1 * originalRoll), centerX, centerY)
                newContent[#newContent + 1] = "</g>"
                -- body
                newContent[#newContent + 1] = stringf([["
                <g class="pdim txt txtmid">
                    <text x="%d" y="%d">%s</text>
                    <text x="%d" y="%d">%d deg</text>
                </g>
                ]], centerX, centerY-horizonRadius-20, pitchstring, centerX, centerY-horizonRadius-10, pitchC)
                newContent[#newContent + 1] = stringf([["
                <g class="pdim txt txtmid">
                    <text x="%d" y="%d">%s</text>
                    <text x="%d" y="%d">%d deg</text>
                </g>
                ]], centerX-horizonRadius-20, centerY, bottomText, centerX-horizonRadius-20, centerY+10, rollC)
            end
        end

        function DrawAltitudeDisplay(newContent, altitude, atmos)
            if (altitude < 200000 and atmos == 0) or (altitude and atmos > 0) then

                local rectX = altMeterX
                local rectY = altMeterY
                local rectW = 78
                local rectH = 19

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

        function DrawPrograde (newContent, atmos, velocity, speed, centerX, centerY)
            if (speed > 5 and atmos == 0) or (speed > MinAutopilotSpeed) then
                local horizonRadius = circleRad -- Aliased globa
                local pitchRange = 20
                local yawRange = 20
                local velo = vec3(velocity)
                local relativePitch = getRelativePitch(velo)
                local relativeYaw = getRelativeYaw(velo)
                
                local dx = (-relativeYaw/yawRange)*horizonRadius -- Values from -1 to 1 indicating offset from the center
                local dy = (relativePitch/pitchRange)*horizonRadius
                local x = centerX + dx
                local y = centerY + dy

                local distance = math.sqrt((dx)^2 + (dy)^2)
                    
                if distance < horizonRadius then
                    newContent[#newContent + 1] = stringf('<circle cx="%f" cy="%f" r="2" stroke="white" stroke-width="2" fill="white" />', x, y)
                    -- Draw a dot or whatever at x,y, it's inside the AH
                else
                    -- x,y is outside the AH.  Figure out how to draw an arrow on the edge of the circle pointing to it.
                    -- First get the angle
                    -- tan(ang) = o/a, tan(ang) = x/y
                    -- atan(x/y) = ang (in radians)
                    -- There is a special overload for doing this on a circle and setting up the signs correctly for the quadrants
                    local angle = math.atan(dy,dx) 
                     -- Project this onto the circle
                    -- These are backwards from what they're supposed to be.  Don't know why, that's just what makes it work apparently
                    local projectedX = centerX + horizonRadius*math.cos(angle) -- Needs to be converted to deg?  Probably not
                    local projectedY = centerY + horizonRadius*math.sin(angle)
                        newContent[#newContent + 1] = stringf('<circle cx="%f" cy="%f" r="2" stroke="white" stroke-width="2" fill="white" />', projectedX, projectedY)
                end
                relativePitch = getRelativePitch(-velo)
                relativeYaw = getRelativeYaw(-velo)
                
                dx = (-relativeYaw/yawRange)*horizonRadius -- Values from -1 to 1 indicating offset from the center
                dy = (relativePitch/pitchRange)*horizonRadius
                x = centerX + dx
                y = centerY + dy

                distance = math.sqrt((dx)^2 + (dy)^2)
                -- Retrograde Dot
                if( atmos == 0) then
                    if distance < horizonRadius then
                        newContent[#newContent + 1] = stringf('<circle cx="%f" cy="%f" r="2" stroke="red" stroke-width="2" fill="red" />', x, y)
                        -- Draw a dot or whatever at x,y, it's inside the AH
                    else
                        local angle = math.atan(dy,dx) 
                        local projectedX = centerX + horizonRadius*math.cos(angle) -- Needs to be converted to deg?  Probably not
                        local projectedY = centerY + horizonRadius*math.sin(angle)
                        newContent[#newContent + 1] = stringf('<circle cx="%f" cy="%f" r="2" stroke="red" stroke-width="2" fill="red" />', projectedX, projectedY)
                    end
                end
            end
        end

        function DrawWarnings(newContent)
            newContent[#newContent + 1] = stringf(
                                              [[<text class="hudver" x="1900" y="1070">DU Hud Version: %.3f</text>]],
                                              VERSION_NUMBER)

            newContent[#newContent + 1] = [[<g class="warnings">]]
            if unit.isMouseControlActivated() == 1 then
                newContent[#newContent + 1] = [[<text x="960" y="550">Warning: Invalid Control Scheme Detected</text>]]
                newContent[#newContent + 1] = [[<text x="960" y="600">Keyboard Scheme must be selected</text>]]
                newContent[#newContent + 1] =
                    [[<text x="960" y="650">Set your preferred scheme in Lua Parameters instead</text>]]
            end
            local warningX = 960
            local brakeY = 860
            local gearY = 900
            local hoverY = 930
            local ewarpY = 960
            local apY = 200
            local turnBurnY = 150
            local gyroY = 960
            if isRemote() == 1 then
                brakeY = 135
                gearY = 155
                hoverY = 175
                apY = 115
                turnBurnY = 95
            end
            if BrakeIsOn then
                newContent[#newContent + 1] = stringf([[<text x="%d" y="%d">Brake Engaged</text>]], warningX, brakeY)
            end
            if GyroIsOn then
                newContent[#newContent + 1] = stringf([[<text x="%d" y="%d">Gyro Enabled</text>]], warningX, gyroY)
            end
            if GearExtended then
                if HasGear then
                    newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Gear Extended</text>]],
                                                      warningX, gearY)
                else
                    newContent[#newContent + 1] = stringf([[<text x="%d" y="%d">Landed (G: Takeoff)</text>]], warningX,
                                                      gearY)
                end
                newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Hover Height: %s</text>]],
                                                  warningX, hoverY,
                                                  getDistanceDisplayString(Nav:getTargetGroundAltitude()))
            end
            if EmergencyWarp then
                newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">E-WARP ENGAGED</text>]],
                                                  warningX, ewarpY)
            end                
            if IsBoosting then
                newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">ROCKET BOOST ENABLED</text>]],
                                                  warningX, ewarpY+20)
            end                  if antigrav and antigrav.getState() == 1 and AntigravTargetAltitude ~= nil then
                newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Target AGG Altitude: %s</text>]],
                    warningX, apY, getDistanceDisplayString2(AntigravTargetAltitude))
            elseif Autopilot and AutopilotTargetName ~= "None" then
                newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Autopilot %s</text>]],
                                                  warningX, apY, AutopilotStatus)
            elseif FollowMode then
                newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Follow Mode Engaged</text>]],
                                                  warningX, apY)
            elseif AltitudeHold then
                if AutoTakeoff then
                    newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Ascent to %s</text>]],
                                                      warningX, apY, getDistanceDisplayString(HoldAltitude))
                    if BrakeIsOn then
                        newContent[#newContent + 1] = stringf(
                                                          [[<text class="crit" x="%d" y="%d">Throttle Up and Disengage Brake For Takeoff</text>]],
                                                          warningX, apY + 50)
                    end
                else
                    newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Altitude Hold: %s</text>]],
                                                      warningX, apY, getDistanceDisplayString2(HoldAltitude))
                end
            elseif Reentry then
                newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Parachute Re-entry in Progress</text>]],
                                                      warningX, apY)
            end
            if BrakeLanding then
                if StrongBrakes then
                    newContent[#newContent + 1] = stringf([[<text x="%d" y="%d">Brake-Landing</text>]], warningX, apY)
                else
                    newContent[#newContent + 1] = stringf([[<text x="%d" y="%d">Coast-Landing</text>]], warningX, apY)
                end
            end
            if TurnBurn then
                newContent[#newContent + 1] = stringf([[<text class="crit" x="%d" y="%d">Turn & Burn Braking</text>]],
                                                  warningX, turnBurnY)
            end
            if VectorToTarget then
                newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">%s</text>]], warningX,
                                                  turnBurnY, VectorStatus)
            end

            newContent[#newContent + 1] = "</g>"
        end

        function DisplayOrbitScreen(newContent)
            if orbit ~= nil and unit.getAtmosphereDensity() < 0.2 and planet ~= nil and orbit.apoapsis ~= nil and
                orbit.periapsis ~= nil and orbit.period ~= nil and orbit.apoapsis.speed > 5 and DisplayOrbit then
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
                    newContent[#newContent + 1] = stringf([[<text x="%f" y="%f">%s</text>]], x, y,
                                                      getDistanceDisplayString(orbit.apoapsis.altitude))
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
                    newContent[#newContent + 1] = stringf([[<text x="%f" y="%f">%s</text>]], x, y,
                                                      getDistanceDisplayString(orbit.periapsis.altitude))
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
                        radius = 44300,
                        atmos = true,
                        gravity = 0.36
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
                        radius = 126068,
                        atmos = true,
                        gravity = 1.01
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
                        radius = 49000,
                        atmos = true,
                        gravity = 0.50
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
                        radius = 57450,
                        atmos = true,
                        gravity = 0.46                    
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
                        radius = 60000,
                        atmos = true,
                        gravity = 0.48                    
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
                        radius = 51100,
                        atmos = true,
                        gravity = 0.41                    
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
                        radius = 54950,
                        atmos = true,
                        gravity = 0.44                    
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
                        radius = 62000,
                        atmos = true,
                        gravity = 0.49
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
                        radius = 61590,
                        atmos = true,
                        gravity = 0.50
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
                        radius = 10000,
                        atmos = false,
                        gravity = 0.08
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
                        radius = 11000,
                        atmos = false,
                        gravity = 0.10
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
                        radius = 15005,
                        atmos = false,
                        gravity = 0.12
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
                        radius = 30000,
                        atmos = false,
                        gravity = 0.24
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
                        radius = 30330,
                        atmos = false,
                        gravity = 0.24
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
                        radius = 83400,
                        atmos = true,
                        gravity = 1.00
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
                        radius = 14002,
                        atmos = false,
                        gravity = 0.11
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
                        radius = 15000,
                        atmos = false,
                        gravity = 0.12
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
                        radius = 12000,
                        atmos = false,
                        gravity = 0.10
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
                        radius = 11000,
                        atmos = false,
                        gravity = 0.09
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
                        radius = 15000,
                        atmos = false,
                        gravity = 0.12
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
                        radius = 14000,
                        atmos = false,
                        gravity = 0.11
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
                        radius = 17000,
                        atmos = false,
                        gravity = 0.14
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
                        radius = 55650,
                        atmos = true,
                        gravity = 0.46
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
                        radius = 15000,
                        atmos = false,
                        gravity = 0.12
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
                        radius = 18000,
                        atmos = false,
                        gravity = 0.14
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
                        radius = 14000,
                        atmos = false,
                        gravity = 0.11
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
                        radius = 49050,
                        atmos = true,
                        gravity = 0.39
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
                        radius = 44950,
                        atmos = true,
                        gravity = 0.36
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
                        radius = 11000,
                        atmos = false,
                        gravity = 0.09
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
                        radius = 15000,
                        atmos = false,
                        gravity = 0.12
                    },
                }
            }
        end
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
            return mfloor(round(speed * 3.6, 0) + 0.5) .. " km/h" -- And generally it's not accurate enough to not twitch unless we round 0
        end

        function FormatTimeString(seconds)
            local days = mfloor(seconds / 86400)
            local hours = mfloor(seconds / 3600)
            local minutes = mfloor(seconds / 60 % 60)
            local seconds = mfloor(seconds % 60)
            if seconds < 0 or hours < 0 or minutes < 0 then
                return "0s"
            end
            if days > 0 then 
                return days .. "d " .. hours .."h "
            elseif hours > 0 then
                return hours .. "h " .. minutes .. "m "
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

            local atlasIndex = AtlasOrdered[AutopilotTargetIndex].index
            local autopilotEntry = atlas[0][atlasIndex]
            if autopilotEntry.center then -- Is a real atlas entry
                AutopilotTargetName = autopilotEntry.name
                AutopilotTargetPlanet = galaxyReference[0][atlasIndex]
                AutopilotTargetCoords = vec3(AutopilotTargetPlanet.center) -- Aim center until we align
                -- Determine the end speed
                _, AutopilotEndSpeed = Kep(AutopilotTargetPlanet):escapeAndOrbitalSpeed(AutopilotTargetOrbit)
                -- AutopilotEndSpeed = 0
                -- AutopilotPlanetGravity = AutopilotTargetPlanet:getGravity(AutopilotTargetPlanet.center + vec3({1,0,0}) * AutopilotTargetOrbit):len() -- Any direction, at our orbit height
                AutopilotPlanetGravity = 0 -- This is inaccurate unless we integrate and we're not doing that.  
                AutopilotAccelerating = false
                AutopilotBraking = false
                AutopilotCruising = false
                Autoilot = false
                AutopilotRealigned = false
                AutopilotStatus = "Aligning"
                if CustomTarget ~= nil then
                    if unit.getAtmosphereDensity() == 0 then
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
                    end
                    if system.updateData(widgetMaxMassText, widgetMaxMass) == 1 then
                        system.addDataToWidget(widgetMaxMassText, widgetMaxMass) end
                    if system.updateData(widgetTravelTimeText, widgetTravelTime) == 1 then
                        system.addDataToWidget(widgetTravelTimeText, widgetTravelTime) end
                end
                CustomTarget = nil
                return true
            else -- Is one of our fake locations with a .name, .position, and .atmosphere
                -- AutopilotTargetName = "None"
                AutopilotTargetPlanet = nil
                AutopilotTargetName = nil
                CustomTarget = autopilotEntry
            end
            return false
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
            local apmaxmass = LastMaxBrake /
                                  (AutopilotTargetPlanet:getGravity(
                                      AutopilotTargetPlanet.center + (vec3(0, 0, 1) * AutopilotTargetPlanet.radius))
                                      :len())
            return apmaxmass
        end

        function GetAutopilotTravelTime()
            AutopilotDistance = (AutopilotTargetPlanet.center - vec3(core.getConstructWorldPos())):len()
            local velocity = core.getWorldVelocity()
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
                _, curBrakeTime = GetAutopilotBrakeDistanceAndTime(vec3(velocity):len())
            else
                _, curBrakeTime = GetAutopilotTBBrakeDistanceAndTime(vec3(velocity):len())
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
            if atmosphere() == 0 then
                refreshLastMaxBrake()
                return Kinematic.computeDistanceAndTime(speed, AutopilotEndSpeed, constructMass(), 0, 0,
                           LastMaxBrake - (AutopilotPlanetGravity * constructMass()))
            else
                if LastMaxBrake and LastMaxBrake > 0 then
                    return Kinematic.computeDistanceAndTime(speed, AutopilotEndSpeed, constructMass(), 0, 0,
                               LastMaxBrake - (AutopilotPlanetGravity * constructMass()))
                else
                    return 0, 0
                end
            end
        end

        function GetAutopilotTBBrakeDistanceAndTime(speed) -- Uses thrust and a configured T50
            refreshLastMaxBrake()
            return Kinematic.computeDistanceAndTime(speed, AutopilotEndSpeed, constructMass(), Nav:maxForceForward(),
                       warmup, LastMaxBrake - (AutopilotPlanetGravity * constructMass()))
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

        function hoverDetectGround()
            local groundDistance = -1
            if vBooster then
                groundDistance = vBooster.distance()
            elseif hover then
                groundDistance = hover.distance()
            end
            return groundDistance
        end            

        function round(num, numDecimalPlaces)
            local mult = 10 ^ (numDecimalPlaces or 0)
            return mfloor(num * mult + 0.5) / mult
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
            system.print(string.format("SUM: %.4f AVG: %.4f MIN: %.4f MAX: %.4f CNT: %d", totalTime, averageTime, min,
                             max, samples))
        end

    

        Animating = false
        Animated = false
        AddLocationsToAtlas()
        UpdateAutopilotTarget()

        -- That was a lot of work with dirty strings and json.  Clean up
        collectgarbage("collect")
        unit.setTimer("apTick", apTickRate)
        unit.setTimer("oneSecond", 1)
        unit.setTimer("tenthSecond", 1/10)
    end)
end

function script.onStop()
    _autoconf.hideCategoryPanels()
    if antigrav ~= nil then
        antigrav.hide()
    end
    if warpdrive ~= nil then
        warpdrive.hide()
    end
    core.hide()
    Nav.control.switchOffHeadlights()
    -- Open door and extend ramp if available
    local atmo = unit.getAtmosphereDensity()
    if door and (atmo > 0 or (atmo == 0 and CoreAltitude < 10000)) then
        for _, v in pairs(door) do
            v.activate()
        end
    end
    if forcefield and (atmo > 0 or (atmo == 0 and CoreAltitude < 10000)) then
        for _, v in pairs(forcefield) do
            v.activate()
        end
    end
    -- Save variables
    if dbHud then
        if not WipedDatabank then
            for k, v in pairs(AutoVariables) do
                dbHud.setStringValue(v, json.encode(_G[v]))
            end
            for k, v in pairs(SaveableVariables) do
                dbHud.setStringValue(v, json.encode(_G[v]))
            end
            system.print("Saved Variables to Datacore")
        end
    end
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
                planetMaxMass = GetAutopilotMaxMass()
                system.updateData(interplanetaryHeaderText,
                    '{"label": "Target", "value": "' .. AutopilotTargetName .. '", "unit":""}')
                travelTime = GetAutopilotTravelTime() -- This also sets AutopilotDistance so we don't have to calc it again
                Distance = AutopilotDistance
                if not TurnBurn then
                    BrakeDistance, BrakeTime = GetAutopilotBrakeDistanceAndTime(velMag)
                    MaxBrakeDistance, MaxBrakeTime = GetAutopilotBrakeDistanceAndTime(MaxGameVelocity)
                else
                    BrakeDistance, BrakeTime = GetAutopilotTBBrakeDistanceAndTime(velMag)
                    MaxBrakeDistance, MaxBrakeTime = GetAutopilotTBBrakeDistanceAndTime(MaxGameVelocity)
                end
                system.updateData(widgetDistanceText, '{"label": "Distance", "value": "' ..
                    getDistanceDisplayString(Distance) .. '", "unit":""}')
                system.updateData(widgetTravelTimeText, '{"label": "Travel Time", "value": "' ..
                    FormatTimeString(travelTime) .. '", "unit":""}')
                system.updateData(widgetCurBrakeDistanceText, '{"label": "Cur Brake Distance", "value": "' ..
                    getDistanceDisplayString(BrakeDistance) .. '", "unit":""}')
                system.updateData(widgetCurBrakeTimeText, '{"label": "Cur Brake Time", "value": "' ..
                    FormatTimeString(BrakeTime) .. '", "unit":""}')
                system.updateData(widgetMaxBrakeDistanceText, '{"label": "Max Brake Distance", "value": "' ..
                    getDistanceDisplayString(MaxBrakeDistance) .. '", "unit":""}')
                system.updateData(widgetMaxBrakeTimeText, '{"label": "Max Brake Time", "value": "' ..
                    FormatTimeString(MaxBrakeTime) .. '", "unit":""}')
                system.updateData(widgetMaxMassText, '{"label": "Maximum Mass", "value": "' ..
                    string.format("%.2f tons", (planetMaxMass / 1000)) .. '", "unit":""}')
                if unit.getAtmosphereDensity() > 0 and not WasInAtmo then
                    system.removeDataFromWidget(widgetMaxBrakeTimeText, widgetMaxBrakeTime)
                    system.removeDataFromWidget(widgetMaxBrakeDistanceText, widgetMaxBrakeDistance)
                    system.removeDataFromWidget(widgetCurBrakeTimeText, widgetCurBrakeTime)
                    system.removeDataFromWidget(widgetCurBrakeDistanceText, widgetCurBrakeDistance)
                    system.removeDataFromWidget(widgetTrajectoryAltitudeText, widgetTrajectoryAltitude)
                    WasInAtmo = true
                end
                if unit.getAtmosphereDensity() == 0 and WasInAtmo then
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
            else
                system.updateData(interplanetaryHeaderText,
                    '{"label": "Target", "value": "' .. CustomTarget.name .. '", "unit":""}')
                Distance = (vec3(core.getConstructWorldPos()) - CustomTarget.position):len()
                system.updateData(widgetDistanceText, '{"label": "Distance", "value": "' ..
                    getDistanceDisplayString(Distance) .. '", "unit":""}')
                system.removeDataFromWidget(widgetMaxBrakeTimeText, widgetMaxBrakeTime)
                system.removeDataFromWidget(widgetMaxBrakeDistanceText, widgetMaxBrakeDistance)
                system.removeDataFromWidget(widgetCurBrakeTimeText, widgetCurBrakeTime)
                system.removeDataFromWidget(widgetCurBrakeDistanceText, widgetCurBrakeDistance)
                system.removeDataFromWidget(widgetTrajectoryAltitudeText, widgetTrajectoryAltitude)
                system.removeDataFromWidget(widgetMaxMassText, widgetMaxMass)
                system.removeDataFromWidget(widgetTravelTimeText, widgetTravelTime)
            end
        else
            HideInterplanetaryPanel()
        end
        if warpdrive ~= nil then
            if InEmergencyWarp then
                if json.decode(warpdrive.getData()).buttonMsg ~= "CANNOT WARP" then
                    MsgText = "EMERGENCY WARP IN 5 SECONDS - PRESS ALT-J to CANCEL"
                    MsgTimer = 5
                    unit.setTimer("emergencyWarpTick", 5)
                    InEmergencyWarp = false
                else
                    MsgText = "Emergency Warp Condition Met - Cannot Warp, will retry in 1 second\n" ..
                                  (json.decode(warpdrive.getData()).errorMsg)
                    msgTick = 1
                    InEmergencyWarp = false
                    unit.setTimer("reEmergencyWarp", 1)
                end
            end
            if json.decode(warpdrive.getData()).destination ~= "Unknown" and json.decode(warpdrive.getData()).distance > 400000 then
                warpdrive.show()
                showWarpWidget = true
            else
                warpdrive.hide()
                showWarpWidget = false
            end
        end        
    elseif timerId == "oneSecond" then
        -- Timer for evaluation every 1 second
        refreshLastMaxBrake(nil, true) -- force refresh, in case we took damage
        updateDistance()
        if (radar_1 and #radar_1.getEntries() > 0) then
            local target
            target = radar_1.getData():find('identifiedConstructs":%[%]')
            if HasSpaceRadar and EmergencyWarp then
                local id, distance = radar_1.getData():match('"constructId":"([0-9]*)","distance":([%d%.]*)')
                if id ~= nil and id ~= "" then
                    if (math.floor(distance) < EmergencyWarpDistance) and NotTriedEmergencyWarp  and json.decode(warpdrive.getData()).errorMsg ~= "PLANET TOO CLOSE" then
                        InEmergencyWarp = true
                        NotTriedEmergencyWarp = false
                    end
                end
            end
            if target == nil and perisPanelID == nil then
                Peris = 1
                ToggleRadarPanel()
            end
            if target ~= nil and perisPanelID ~= nil then
                ToggleRadarPanel()
            end
            if radarPanelID == nil then
                ToggleRadarPanel()
            end

            local radarContacts = radar_1.getEntries()
            RadarMessage = string.format(
                               [[<text class="pbright txtbig txtmid" x="1770" y="330">Radar: %i contacts</text>]],
                               #radarContacts)

            local friendlies = {}
            for k, v in pairs(radarContacts) do
                if radar_1.hasMatchingTransponder(v) == 1 then
                    friendlies[#friendlies + 1] = v
                end
            end
            if #friendlies > 0 then
                local y = 15
                RadarMessage = string.format(
                                   [[%s<text class="pbright txtbig txtmid" x="1370" y="%s">Friendlies In Range</text>]],
                                   RadarMessage, y)
                for k, v in pairs(friendlies) do
                    y = y + 20
                    RadarMessage = string.format([[%s<text class="pdim txtmid" x="1370" y="%s">%s</text>]],
                                       RadarMessage, y, radar_1.getConstructName(v))
                end
            end

        elseif radar_1 then
            local data
            data = radar_1.getData():find('worksInEnvironment":false')
            if data then
                RadarMessage = [[<text class="pbright txtbig txtmid" x="1770" y="330">Radar: Jammed</text>]]
            else
                RadarMessage = [[<text class="pbright txtbig txtmid" x="1770" y="330">Radar: No Contacts</text>]]
            end
            if radarPanelID ~= nil then
                Peris = 0
                ToggleRadarPanel()
            end
        end

        -- Update odometer output string
        local newContent = {}
        local flightStyle = GetFlightStyle()
        DrawOdometer(newContent, TotalDistanceTrip, TotalDistanceTravelled, flightStyle, FlightTime)
        checkDamage(newContent)
        LastOdometerOutput = table.concat(newContent, "")
        collectgarbage("collect")
    elseif timerId == "reEmergencyWarp" then
        if EmergencyWarp then
            NotTriedEmergencyWarp = true
            InEmergencyWarp = true
        end
        unit.stopTimer("reEmergencyWarp")
    elseif timerId == "msgTick" then
        -- This is used to clear a message on screen after a short period of time and then stop itself
        local newContent = {}
        DisplayMessage(newContent, "empty")
        MsgText = "empty"
        unit.stopTimer("msgTick")
        MsgTimer = 3
    elseif timerId == "emergencyWarpTick" then
        if EmergencyWarp then 
            MsgText = "EMERGENCY WARP ACTIVATED"
            MsgTimer = 5
            warpdrive.activateWarp()
            warpdrive.show()
            showWarpWidget = true
            EmergencyWarp = false
        end
        unit.stopTimer("emergencyWarpTick")
    elseif timerId == "animateTick" then
        Animated = true
        Animating = false
        SimulatedX = 0
        SimulatedY = 0
        unit.stopTimer("animateTick")
    elseif timerId == "apTick" then
        -- Localized Functions
        local isRemote = Nav.control.isRemoteControlled

        YawInput2 = 0
        RollInput2 = 0
        PitchInput2 = 0
        LastApsDiff = -1
        velocity = vec3(core.getWorldVelocity())
        velMag = vec3(velocity):len()
        sys = galaxyReference[0]
        planet = sys:closestBody(core.getConstructWorldPos())
        kepPlanet = Kep(planet)
        orbit = kepPlanet:orbitalParameters(core.getConstructWorldPos(), velocity)
        local deltaX = system.getMouseDeltaX()
        local deltaY = system.getMouseDeltaY()
        TargetGroundAltitude = Nav:getTargetGroundAltitude()
        local TrajectoryAlignmentStrength = 0.002 -- How strongly AP tries to align your velocity vector to the target when not in orbit
        local isWarping = (velMag > 8334)
        if not isWarping and LastIsWarping then
            if not BrakeIsOn then
                BrakeToggle()
            end
            if Autopilot then
                ToggleAutopilot()
            end
        end
        LastIsWarping = isWarping
        if antigrav and ((antigrav.getState() == 1 and not desiredBaseAltitude) or AntigravJustToggledOn) then -- initialise if needed
            desiredBaseAltitude = antigrav.getBaseAltitude()
            if AntigravJustToggledOn then AntigravJustToggledOn = false end
        end
        if BrakeIsOn then
            BrakeInput = 1
        else
            BrakeInput = 0
        end
        CoreAltitude = core.getAltitude()
        if CoreAltitude == 0 then
            CoreAltitude = (vec3(core.getConstructWorldPos()) - planet.center):len() - planet.radius
        end

        local newContent = {}
        HUDPrologue(newContent)

        if showHud then
            updateHud(newContent) -- sets up Content for us
        else
            DisplayOrbitScreen(newContent)
            DrawWarnings(newContent)
        end

        HUDEpilogue(newContent)

        newContent[#newContent + 1] =
            [[<svg width="100%" height="100%" style="position:absolute;top:0;left:0"  viewBox="0 0 2560 1440">]]
        if MsgText ~= "empty" then
            DisplayMessage(newContent, MsgText)
        end
        if isRemote() == 0 and userControlScheme == "Virtual Joystick" then
            DrawDeadZone(newContent)
        end

        if isRemote() == 1 and screen_1 and screen_1.getMouseY() ~= -1 then
            SimulatedX = screen_1.getMouseX() * 2560
            SimulatedY = screen_1.getMouseY() * 1440
            SetButtonContains()
            DrawButtons(newContent)
            if screen_1.getMouseState() == 1 then
                CheckButtons()
            end
            newContent[#newContent + 1] = string.format(
                                              [[<g transform="translate(1280 720)"><circle class="cursor" cx="%fpx" cy="%fpx" r="5"/></g>]],
                                              SimulatedX, SimulatedY)
        elseif system.isViewLocked() == 0 then
            if isRemote() == 1 and HoldingCtrl then
                if not Animating then
                    SimulatedX = SimulatedX + deltaX
                    SimulatedY = SimulatedY + deltaY
                end
                SetButtonContains()
                DrawButtons(newContent)

                -- If they're remote, it's kinda weird to be 'looking' everywhere while you use the mouse
                -- We need to add a body with a background color
                if not Animating and not Animated then
                    local collapsedContent = table.concat(newContent, "")
                    newContent = {}
                    newContent[#newContent + 1] =
                        "<style>@keyframes test { from { opacity: 0; } to { opacity: 1; } }  body { animation-name: test; animation-duration: 0.5s; }</style><body><svg width='100%' height='100%' position='absolute' top='0' left='0'><rect width='100%' height='100%' x='0' y='0' position='absolute' style='fill:rgb(6,5,26);'/></svg><svg width='50%' height='50%' style='position:absolute;top:30%;left:25%' viewbox='0 0 1920 1080'>"
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
                    newContent[#newContent + 1] =
                        "<body style='background-color:rgb(6,5,26)'><svg width='50%' height='50%' style='position:absolute;top:30%;left:25%' viewbox='0 0 1920 1080'>"
                    newContent[#newContent + 1] = GalaxyMapHTML
                    newContent[#newContent + 1] = collapsedContent
                    newContent[#newContent + 1] = "</body>"
                end

                if not Animating then
                    newContent[#newContent + 1] = string.format(
                                                      [[<g transform="translate(1280 720)"><circle class="cursor" cx="%fpx" cy="%fpx" r="5"/></g>]],
                                                      SimulatedX, SimulatedY)
                end
            else
                CheckButtons()
                SimulatedX = 0
                SimulatedY = 0 -- Reset after they do view things, and don't keep sending inputs while unlocked view
                -- Except of course autopilot, which is later.
            end
        else
            SimulatedX = SimulatedX + deltaX
            SimulatedY = SimulatedY + deltaY
            Distance = math.sqrt(SimulatedX * SimulatedX + SimulatedY * SimulatedY)
            if not HoldingCtrl and isRemote() == 0 then -- Draw deadzone circle if it's navigating
                if userControlScheme == "Virtual Joystick" then -- Virtual Joystick
                    -- Do navigation things

                    if SimulatedX > 0 and SimulatedX > DeadZone then
                        YawInput2 = YawInput2 - (SimulatedX - DeadZone) * MouseXSensitivity
                    elseif SimulatedX < 0 and SimulatedX < (DeadZone * -1) then
                        YawInput2 = YawInput2 - (SimulatedX + DeadZone) * MouseXSensitivity
                    else
                        YawInput2 = 0
                    end

                    if SimulatedY > 0 and SimulatedY > DeadZone then
                        PitchInput2 = PitchInput2 - (SimulatedY - DeadZone) * MouseYSensitivity
                    elseif SimulatedY < 0 and SimulatedY < (DeadZone * -1) then
                        PitchInput2 = PitchInput2 - (SimulatedY + DeadZone) * MouseYSensitivity
                    else
                        PitchInput2 = 0
                    end
                elseif userControlScheme == "Mouse" then -- Mouse Direct
                    SimulatedX = 0
                    SimulatedY = 0
                    -- PitchInput2 = PitchInput2 - deltaY * MousePitchFactor
                    -- YawInput2 = YawInput2 - deltaX * MouseYawFactor
                    -- So... this is weird.  
                    -- It's doing some odd things and giving us some weird values. 

                    -- utils.smoothstep(progress, low, high)*2-1
                    PitchInput2 = (-utils.smoothstep(deltaY, -100, 100) + 0.5) * 2 * MousePitchFactor
                    YawInput2 = (-utils.smoothstep(deltaX, -100, 100) + 0.5) * 2 * MouseYawFactor
                else -- Keyboard mode
                    SimulatedX = 0
                    SimulatedY = 0
                    -- Don't touch anything, they have it with kb only.  
                end

                -- Right so.  We can't detect a mouse click.  That's stupid.  
                -- We have two options.  1. Use mouse wheel movement as a click, or 2. If you're hovered over a button and let go of Ctrl, it's a click
                -- I think 2 is a much smoother solution.  Even if we later want to have them input some coords
                -- We'd have to hook 0-9 in their events, and they'd have to point at the target, so it wouldn't be while this screen is open

                -- What that means is, if we get here, check our hovers.  If one of them is active, trigger the thing and deactivate the hover
                CheckButtons()

                if Distance > DeadZone then -- Draw a line to the cursor from the screen center
                    -- Note that because SVG lines fucking suck, we have to do a translate and they can't use calc in their params
                    DrawCursorLine(newContent)
                end
            else
                -- Ctrl is being held, draw buttons.
                -- Brake toggle, face prograde, face retrograde (for now)
                -- We've got some vars setup in Start for them to make this easier to work with
                SetButtonContains()
                DrawButtons(newContent)

            end
            -- Cursor always on top, draw it last
            newContent[#newContent + 1] = string.format(
                                              [[<g transform="translate(1280 720)"><circle class="cursor" cx="%fpx" cy="%fpx" r="5"/></g>]],
                                              SimulatedX, SimulatedY)
        end
        newContent[#newContent + 1] = [[</svg></body>]]
        content = table.concat(newContent, "")
        -- if content ~= LastContent then
        -- if isRemote() == 1 and screen_1 then -- Once the screens are fixed we can do this.
        --    screen_1.setHTML(content) -- But also this is disgusting and the resolution's terrible.  We're doing something wrong.
        -- else

        if not DidLogOutput then
            system.logInfo(LastContent)
            DidLogOutput = true
        end

       if ProgradeIsOn then
            if velMag > MinAutopilotSpeed then -- Help with div by 0 errors and careening into terrain at low speed
                AlignToWorldVector(vec3(velocity))
            end
        end
        if RetrogradeIsOn then
            if velMag > MinAutopilotSpeed then -- Help with div by 0 errors and careening into terrain at low speed
                AlignToWorldVector(-(vec3(velocity)))
            end
        end
        if Autopilot and unit.getAtmosphereDensity() == 0 then
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
                local velVectorOffset = (vec3(AutopilotTargetCoords) - vec3(core.getConstructWorldPos())):normalize() -
                                            vec3(velocity):normalize()
                local pitchComponent = getMagnitudeInDirection(velVectorOffset, AutopilotShipUp)
                local yawComponent = getMagnitudeInDirection(velVectorOffset, AutopilotShipRight)
                local leftAmount = -yawComponent * AutopilotDistance * velMag * TrajectoryAlignmentStrength
                local downAmount = -pitchComponent * AutopilotDistance * velMag * TrajectoryAlignmentStrength
                targetCoords = AutopilotTargetCoords + (-leftAmount * vec3(AutopilotShipRight)) +
                                   (-downAmount * vec3(AutopilotShipUp))
            end
            -- If we're here, sadly, we really need to calc the distance every update (or tick)
            AutopilotDistance = (vec3(targetCoords) - vec3(core.getConstructWorldPos())):len()
            system.updateData(widgetDistanceText, '{"label": "Distance", "value": "' ..
                getDistanceDisplayString(AutopilotDistance) .. '", "unit":""}')
            local aligned = true -- It shouldn't be used if the following condition isn't met, but just in case

            local projectedAltitude = (AutopilotTargetPlanet.center -
                                          (vec3(core.getConstructWorldPos()) +
                                              (vec3(velocity):normalize() * AutopilotDistance))):len() -
                                          AutopilotTargetPlanet.radius
            system.updateData(widgetTrajectoryAltitudeText, '{"label": "Projected Altitude", "value": "' ..
                getDistanceDisplayString(projectedAltitude) .. '", "unit":""}')

            if not AutopilotCruising and not AutopilotBraking then
                aligned = AlignToWorldVector((targetCoords - vec3(core.getConstructWorldPos())):normalize())
            elseif TurnBurn then
                aligned = AlignToWorldVector(-vec3(velocity):normalize())
            end
            if AutopilotAccelerating then
                if not aligned then
                    AutopilotStatus = "Adjusting Trajectory"
                else
                    AutopilotStatus = "Accelerating"
                end

                if vec3(core.getVelocity()):len() >= MaxGameVelocity then -- This is 29999 kph
                    AutopilotAccelerating = false
                    AutopilotStatus = "Cruising"
                    AutopilotCruising = true
                    Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0)
                end
                -- Check if accel needs to stop for braking
                if AutopilotDistance <= brakeDistance then
                    AutopilotAccelerating = false
                    AutopilotStatus = "Braking"
                    AutopilotBraking = true
                    Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0)
                end
            elseif AutopilotBraking then
                BrakeIsOn = true
                BrakeInput = 1
                if TurnBurn then
                    Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 100) -- This stays 100 to not mess up our calculations
                end
                -- Check if an orbit has been established and cut brakes and disable autopilot if so

                -- We'll try <0.9 instead of <1 so that we don't end up in a barely-orbit where touching the controls will make it an escape orbit
                -- Though we could probably keep going until it starts getting more eccentric, so we'd maybe have a circular orbit

                if orbit.periapsis ~= nil and orbit.eccentricity < 1 then
                    AutopilotStatus = "Circularizing"
                    if orbit.eccentricity > LastEccentricity or
                        (orbit.apoapsis.altitude < AutopilotTargetOrbit and orbit.periapsis.altitude <
                            AutopilotTargetOrbit) then
                        BrakeIsOn = false
                        AutopilotBraking = false
                        Autopilot = false
                        AutopilotStatus = "Aligning" -- Disable autopilot and reset
                        -- TODO: This is being added to newContent *after* we already drew the screen, so it'll never get displayed
                        DisplayMessage(newContent, "Autopilot completed, orbit established")
                        BrakeInput = 0
                        Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0)
                    end
                end
            elseif AutopilotCruising then
                if AutopilotDistance <= brakeDistance then
                    AutopilotAccelerating = false
                    AutopilotStatus = "Braking"
                    AutopilotBraking = true
                end
            else
                -- It's engaged but hasn't started accelerating yet.
                if aligned then
                    -- Re-align to 200km from our aligned right                    
                    if not AutopilotRealigned then -- Removed radius from this because it makes our readouts look inaccurate?
                        AutopilotTargetCoords = vec3(AutopilotTargetPlanet.center) +
                                                    ((AutopilotTargetOrbit + AutopilotTargetPlanet.radius) *
                                                        vec3(core.getConstructWorldOrientationRight()))
                        AutopilotRealigned = true
                        AutopilotShipUp = core.getConstructWorldOrientationUp()
                        AutopilotShipRight = core.getConstructWorldOrientationRight()
                    elseif aligned then
                        AutopilotAccelerating = true
                        AutopilotStatus = "Accelerating"
                        -- Set throttle to max
                        Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal,
                            AutopilotInterplanetaryThrottle)
                    end
                end
                -- If it's not aligned yet, don't try to burn yet.
            end
        end
        if FollowMode then
            -- User is assumed to be outside the construct
            autoRoll = true -- Let Nav handle that while we're here
            local targetPitch = 0
            -- Keep brake engaged at all times unless: 
            -- Ship is aligned with the target on yaw (roll and pitch are locked to 0)
            -- and ship's speed is below like 5-10m/s
            local pos = vec3(core.getConstructWorldPos()) + vec3(unit.getMasterPlayerRelativePosition()) -- Is this related to core forward or nah?
            local distancePos = (pos - vec3(core.getConstructWorldPos()))
            -- local distance = distancePos:len()
            -- Distance needs to be calculated using only construct forward and right
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
            PitchInput2 = 0
            local aligned = (math.abs(YawInput2) < 0.1)
            if (aligned and velMag < targetSpeed and not nearby) then -- or (not BrakeIsOn and onShip) then
                -- if not onShip then -- Don't mess with brake if they're on ship
                BrakeIsOn = false
                -- end
                targetPitch = -10
            else
                -- if not onShip then
                BrakeIsOn = true
                -- end
                targetPitch = 0
            end
            local constrF = vec3(core.getConstructWorldOrientationForward())
            local constrR = vec3(core.getConstructWorldOrientationRight())
            local worldV = vec3(core.getWorldVertical())
            local pitch = getPitch(worldV, constrF, constrR)
            local autoPitchThreshold = 1.0
            -- Copied from autoroll let's hope this is how a PID works... 
            if math.abs(targetPitch - pitch) > autoPitchThreshold then
                if (pitchPID == nil) then
                    pitchPID = pid.new(2 * 0.01, 0, 2 * 0.1) -- magic number tweaked to have a default factor in the 1-10 range
                end
                pitchPID:inject(targetPitch - pitch)
                local autoPitchInput = pitchPID:get()

                PitchInput2 = autoPitchInput
            end
        end
        local up = vec3(core.getWorldVertical()) * -1
        if AltitudeHold or BrakeLanding or Reentry or VectorToTarget then
            -- HoldAltitude is the alt we want to hold at
            local altitude = CoreAltitude
            -- Dampen this.
            local altDiff = HoldAltitude - altitude
            -- This may be better to smooth evenly regardless of HoldAltitude.  Let's say, 2km scaling?  Should be very smooth for atmo
            -- Even better if we smooth based on their velocity
            local minmax = 500 + velMag
            local targetPitch = (utils.smoothstep(altDiff, -minmax, minmax) - 0.5) * 2 * MaxPitch
            if not AltitudeHold then
                targetPitch = 0
            end
            autoRoll = true
            
            if Reentry then
                local fasterSpeed = ReentrySpeed
                if CoreAltitude > 15000 and not ReentryMode then fasterSpeed = fasterSpeed * math.floor(CoreAltitude / 10000) end
                if Nav.axisCommandManager:getTargetSpeed(axisCommandId.longitudinal) ~= fasterSpeed then -- This thing is dumb.
                    Nav.axisCommandManager:setTargetSpeedCommand(axisCommandId.longitudinal, fasterSpeed)
                    Nav.axisCommandManager:setTargetSpeedCommand(axisCommandId.vertical, 0)
                    Nav.axisCommandManager:setTargetSpeedCommand(axisCommandId.lateral, 0)
                end 
                if not ReentryMode then
                    targetPitch = -80
                    if unit.getAtmosphereDensity() > 0.05 then
                        MsgText = "PARACHUTE DEPLOYED"
                        Reentry = false
                        BrakeLanding = true
                        targetPitch = 0
                    end
                elseif Nav.axisCommandManager:getTargetSpeed(axisCommandId.longitudinal) == ReentrySpeed then
                    ReentryMode = false
                    Reentry = false
                end    
            end

            -- The clamp should now be redundant
            -- local targetPitch = utils.clamp(altDiff,-20,20) -- Clamp to reasonable values
            -- Align it prograde but keep whatever pitch inputs they gave us before, and ignore pitch input from alignment.
            -- So, you know, just yaw.
            local oldInput = PitchInput2
            if velMag > MinAutopilotSpeed then
                AlignToWorldVector(vec3(velocity))
            end
            if VectorToTarget and CustomTarget ~= nil and AutopilotTargetIndex > 0 then
                local targetVec = CustomTarget.position - vec3(core.getConstructWorldPos())
                -- We're overriding pitch and roll so, this will just set yaw, we can do this directly
                AlignToWorldVector(targetVec)

                local distanceToTarget = targetVec:len() - targetVec:project_on(up):len() -- Probably not strictly accurate with curvature but it should work
                -- Well, maybe not.  Really we have a triangle.  Of course.  
                -- We know C, our distance to target.  We know the height we'll be above the target (should be the same as our current height)
                -- We just don't know the last leg
                -- a2 + b2 = c2.  c2 - b2 = a2
                -- local distanceToTarget = math.sqrt(targetVec:len()^2-(HoldAltitude-targetAltitude)^2)
                local maxBrake = json.decode(unit.getData()).maxBrake
                local vSpd = (velocity.x * up.x) + (velocity.y * up.y) + (velocity.z * up.z)
                local hSpd = velocity:len() - math.abs(vSpd)
                local airFriction = vec3(core.getWorldAirFrictionAcceleration()) -- Maybe includes lift?
                if maxBrake ~= nil then
                    LastMaxBrake = maxBrake
                    BrakeDistance, BrakeTime = Kinematic.computeDistanceAndTime(hSpd, 0, core.getConstructMass(), 0, 0,
                                                   maxBrake + (airFriction:len() - airFriction:project_on(up):len()) *
                                                       core.getConstructMass())
                else
                    BrakeDistance, BrakeTime = Kinematic.computeDistanceAndTime(hSpd, 0, core.getConstructMass(), 0, 0,
                                                   LastMaxBrake + vec3(core.getWorldAirFrictionAcceleration()):len() *
                                                       core.getConstructMass())
                end
                StrongBrakes = ((planet.gravity * 9.80665 * core.getConstructMass()) < LastMaxBrake)
                if distanceToTarget <= BrakeDistance then
                    VectorStatus = "Finalizing Approach"
                    if Nav.axisCommandManager:getAxisCommandType(0) == 1 then
                        Nav.control.cancelCurrentControlMasterMode()
                    end
                    if AltitudeHold then
                        ToggleAltitudeHold() -- Don't need this anymore
                        VectorToTarget = true -- But keep this part on... 
                    end
                    if StrongBrakes then
                        BrakeIsOn = true
                    else
                        VectorToTarget = false -- We're done here.  Toggle on the landing routine for coast-landing
                        BrakeLanding = true
                    end

                elseif not AutoTakeoff then
                    BrakeIsOn = false
                end
                if LastTargetDistance ~= nil and distanceToTarget > LastTargetDistance and not AltitudeHold and
                    not AutoTakeoff then
                    BrakeLanding = true
                    VectorToTarget = false
                end
                LastTargetDistance = distanceToTarget
            end
            PitchInput2 = oldInput
            local constrF = vec3(core.getConstructWorldOrientationForward())
            local constrR = vec3(core.getConstructWorldOrientationRight())
            local worldV = vec3(core.getWorldVertical())
            local groundDistance = -1
            local pitch = getPitch(worldV, constrF, constrR)
            local autoPitchThreshold = 0.1
            if BrakeLanding then
                targetPitch = 0
                if Nav.axisCommandManager:getAxisCommandType(0) == 1 then
                    Nav.control.cancelCurrentControlMasterMode()
                end
                Nav.axisCommandManager:setTargetGroundAltitude(500)
                Nav.axisCommandManager:activateGroundEngineAltitudeStabilization(500)
                local vSpd = (velocity.x * up.x) + (velocity.y * up.y) + (velocity.z * up.z)
                groundDistance = hoverDetectGround()
                if groundDistance > -1 then
                    if math.abs(targetPitch - pitch) < autoPitchThreshold then
                        autoRoll = autoRollPreference
                        if velMag < 1 then
                            BrakeLanding = false
                            AltitudeHold = false
                            GearExtended = true
                            Nav.control.extendLandingGears()
                            Nav.axisCommandManager:setTargetGroundAltitude(LandingGearGroundHeight)
                            UpAmount = 0
                            BrakeIsOn = true
                        else
                            BrakeIsOn = true
                        end
                    end
                elseif StrongBrakes and (velocity:normalize():dot(-up) < 0.99) then
                    BrakeIsOn = true
                elseif vSpd < -brakeLandingRate then
                    BrakeIsOn = true
                else
                    BrakeIsOn = false
                end
            end
            if AutoTakeoff then
                if targetPitch < 20 then
                    AutoTakeoff = false -- No longer in ascent
                    if Nav.axisCommandManager:getAxisCommandType(0) == 0 then
                        Nav.control.cancelCurrentControlMasterMode()
                    end
                end
            end
            -- Copied from autoroll let's hope this is how a PID works... 
            if math.abs(targetPitch - pitch) > autoPitchThreshold then
                if (pitchPID == nil) then -- Changed from 2 to 8 to tighten it up around the target
                    pitchPID = pid.new(8 * 0.01, 0, 8 * 0.1) -- magic number tweaked to have a default factor in the 1-10 range
                end
                pitchPID:inject(targetPitch - pitch)
                local autoPitchInput = pitchPID:get()
                PitchInput2 = PitchInput2 + autoPitchInput
            end
        end
        LastEccentricity = orbit.eccentricity
        -- antigrav by zerofg
        -- it's very rough but get the job done, AGG are weird
        if antigrav and CoreAltitude < 200000 and antigrav.getState() == 1 then
            if AntigravTargetAltitude == nil then -- no target : try to stabilize if too far from actual altitude (
                local AGGtargetDistance = CoreAltitude - antigrav.getBaseAltitude()
                if CoreAltitude > 800 and AGGtargetDistance < -200 then
                    desiredBaseAltitude = math.max(CoreAltitude + 100, 1000)
                elseif AGGtargetDistance > 200 then
                    desiredBaseAltitude = CoreAltitude - 100
                end

            else -- I tried using a PID but didn't work that well, so I'm just regulating speed instead
                local AGGtargetDistance = AntigravTargetAltitude - CoreAltitude
                -- totaly stole the code from lisa-lionheart for vSpeed
                local velocity = vec3(core.getWorldVelocity())
                local up = vec3(core.getWorldVertical()) * -1
                local vSpd = (velocity.x * up.x) + (velocity.y * up.y) + (velocity.z * up.z)

                -- this is about as fast as AGG can go, and is conveniently below the atmos burn speed (1044 km/h)
                local maxVSpeed = 290
                local minVSpeed = -290

                -- when under "strong" planet influence, you can easily get below you AGG base altitude if not carefull
                if unit.getClosestPlanetInfluence() > 0.3 then
                    minVSpeed = -190
                end

                -- adjust max speed based on distance, but at least 10m/s
                minVSpeed = math.min(math.max(minVSpeed, -math.abs(AGGtargetDistance) / 20.0), -10)
                maxVSpeed = math.max(math.min(maxVSpeed, math.abs(AGGtargetDistance) / 20.0), 10)

                if vSpd < minVSpeed then -- oh sh*t! oh sh*t! oh sh*t!
                    desiredBaseAltitude = CoreAltitude + 100

                elseif vSpd > maxVSpeed then -- not as bad as going too fast down but still need to slow down or at least stop accelerating
                    desiredBaseAltitude = math.max(CoreAltitude - 100, 1000) -- I would be pretty hard for the math.max to matter but I kept it for good measure

                elseif math.abs(AGGtargetDistance) > 150 or math.abs(vSpd) > 15 then
                    if math.abs(vSpd) > 10 then
                        desiredBaseAltitude = CoreAltitude +
                                                  math.max(math.min(AGGtargetDistance - vSpd / 10.0, 100), -100)
                    else
                        desiredBaseAltitude = CoreAltitude + math.max(math.min(AGGtargetDistance, 100), -100)
                    end

                else -- getting close to the target
                    desiredBaseAltitude = AntigravTargetAltitude
                    if math.abs(vSpd) < 10 and math.abs(AGGtargetDistance) < 30 then -- very close and not much speed let's stop there
                        AntigravTargetAltitude = nil
                    end

                end
            end
        end
    end
end

function script.onFlush()
    local torqueFactor = 2 -- Force factor applied to reach rotationSpeed<br>(higher value may be unstable)<br>Valid values: Superior or equal to 0.01

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
    local finalPitchInput = PitchInput + PitchInput2 + system.getControlDeviceForwardInput()
    local finalRollInput = RollInput + RollInput2 + system.getControlDeviceYawInput()
    local finalYawInput = (YawInput + YawInput2) - system.getControlDeviceLeftRightInput()
    local finalBrakeInput = BrakeInput

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
    local atmosphere = unit.getAtmosphereDensity()

    -- Rotation
    local constructAngularVelocity = vec3(core.getWorldAngularVelocity())
    local targetAngularVelocity =
        finalPitchInput * pitchSpeedFactor * constructRight + finalRollInput * rollSpeedFactor * constructForward +
            finalYawInput * yawSpeedFactor * constructUp

    -- In atmosphere?
    if worldVertical:len() > 0.01 and atmosphere > 0.0 then
        local autoRollRollThreshold = 1.0
        -- autoRoll on AND currentRollDeg is big enough AND player is not rolling
        if autoRoll == true and currentRollDegAbs > autoRollRollThreshold and finalRollInput == 0 then
            local targetRollDeg = utils.clamp(0, currentRollDegAbs - 30, currentRollDegAbs + 30); -- we go back to 0 within a certain limit
            if (rollPID == nil) then
                rollPID = pid.new(autoRollFactor * 0.01, 0, autoRollFactor * 0.1) -- magic number tweaked to have a default factor in the 1-10 range
            end
            rollPID:inject(targetRollDeg - currentRollDeg)
            local autoRollInput = rollPID:get()

            targetAngularVelocity = targetAngularVelocity + autoRollInput * constructForward
        end
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
    local longitudinalEngineTags = 'thrust analog longitudinal'
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
    local lateralStrafeEngineTags = 'thrust analog lateral'
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
    local verticalStrafeEngineTags = 'thrust analog vertical'
    local verticalCommandType = Nav.axisCommandManager:getAxisCommandType(axisCommandId.vertical)
    if (verticalCommandType == axisCommandType.byThrottle) then
        local verticalStrafeAcceleration = Nav.axisCommandManager:composeAxisAccelerationFromThrottle(
                                               verticalStrafeEngineTags, axisCommandId.vertical)
        if UpAmount ~= 0 or BrakeLanding then
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
        local verticalAcceleration = Nav.axisCommandManager:composeAxisAccelerationFromTargetSpeed(
                                         axisCommandId.vertical)
        autoNavigationEngineTags = autoNavigationEngineTags .. ' , ' .. verticalStrafeEngineTags
        autoNavigationAcceleration = autoNavigationAcceleration + verticalAcceleration
    end

    -- Auto Navigation (Cruise Control)
    if (autoNavigationAcceleration:len() > constants.epsilon) then
        if (BrakeInput ~= 0 or autoNavigationUseBrake or math.abs(constructVelocityDir:dot(constructForward)) < 0.95) -- if the velocity is not properly aligned with the forward
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
    if(IsBoosting) then
        local speed = vec3(core.getVelocity()):len()
        local setEngineThrust = unit.setEngineThrust
        local maxSpeedLag = 0.15
        if Nav.axisCommandManager:getAxisCommandType(0) == 1 then -- Cruise control rocket boost assist, Dodgin's modified.
            local cc_speed = Nav.axisCommandManager:getTargetSpeed(axisCommandId.longitudinal)
            if speed * 3.6 > (cc_speed * (1 - maxSpeedLag)) then
                setEngineThrust('rocket_engine', 0)
            elseif (IsBoosting) then
                setEngineThrust('rocket_engine', 1)
            end
        else -- Atmosphere Rocket Boost Assist Not in Cruise Control by Azraeil
            local throttle = unit.getThrottle()
            local targetSpeed = (throttle/100)
            if atmosphere == 0 then
                targetSpeed = targetSpeed * MaxGameVelocity
                if speed >= (targetSpeed * (1- maxSpeedLag)) then
                    setEngineThrust('rocket_engine', 0)
                elseif (IsBoosting) then
                    setEngineThrust('rocket_engine', 1)
                end
            else
                targetSpeed = targetSpeed * 1050 / 3.6 -- 1100km/hr being max safe speed in atmo for most ships
                if speed >= (targetSpeed * (1- maxSpeedLag)) then
                    setEngineThrust('rocket_engine', 0)
                elseif (IsBoosting) then
                    setEngineThrust('rocket_engine', 1)
                end
            end
        end
    end

    -- antigrav
    if antigrav and antigrav.getState() == 1 and desiredBaseAltitude ~= antigrav.getBaseAltitude() then
        antigrav.setBaseAltitude(desiredBaseAltitude)
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
        GearExtended = not GearExtended
        if GearExtended then
            VectorToTarget = false
            if (vBooster or hover) and (unit.getAtmosphereDensity() > 0 or CoreAltitude < ReentryAltitude) then
                StrongBrakes = ((planet.gravity * 9.80665 * core.getConstructMass()) < LastMaxBrake)
                if not StrongBrakes and velMag > MinAutopilotSpeed then
                    MsgText = "WARNING: Insufficient Brakes - Attempting landing anyway"
                end
                if Nav.axisCommandManager:getAxisCommandType(0) == 1 then
                    Nav.control.cancelCurrentControlMasterMode()
                end
                Reentry = false
                AutoTakeoff = false
                AltitudeHold = false
                BrakeLanding = true
                autoRoll = true
                GearExtended = false -- Don't actually do it
                Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0)
            else
                Nav.control.extendLandingGears()
                Nav.axisCommandManager:setTargetGroundAltitude(LandingGearGroundHeight)
            end
        else
            Nav.control.retractLandingGears()
            Nav.axisCommandManager:setTargetGroundAltitude(TargetHoverHeight)
        end
    elseif action == "light" then
        if Nav.control.isAnyHeadlightSwitchedOn() == 1 then
            Nav.control.switchOffHeadlights()
        else
            Nav.control.switchOnHeadlights()
        end
    elseif action == "forward" then
        PitchInput = PitchInput - 1
    elseif action == "backward" then
        PitchInput = PitchInput + 1
    elseif action == "left" then
        RollInput = RollInput - 1
    elseif action == "right" then
        RollInput = RollInput + 1
    elseif action == "yawright" then
        YawInput = YawInput - 1
    elseif action == "yawleft" then
        YawInput = YawInput + 1
    elseif action == "straferight" then
        Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.lateral, 1.0)
    elseif action == "strafeleft" then
        Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.lateral, -1.0)
    elseif action == "up" then
        UpAmount = UpAmount + 1
        Nav.axisCommandManager:deactivateGroundEngineAltitudeStabilization()
        Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.vertical, 1.0)
    elseif action == "down" then
        UpAmount = UpAmount - 1
        Nav.axisCommandManager:deactivateGroundEngineAltitudeStabilization()
        Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.vertical, -1.0)
    elseif action == "groundaltitudeup" then
        OldButtonMod = HoldAltitudeButtonModifier
        OldAntiMod = AntiGravButtonModifier
        if antigrav and antigrav.getState() == 1 then
            if AntigravTargetAltitude ~= nil  then
                AntigravTargetAltitude = AntigravTargetAltitude + AntiGravButtonModifier
            else
                AntigravTargetAltitude = desiredBaseAltitude + 100
            end
        elseif AltitudeHold then
            HoldAltitude = HoldAltitude + HoldAltitudeButtonModifier
        else
            Nav.axisCommandManager:updateTargetGroundAltitudeFromActionStart(1.0)
        end
    elseif action == "groundaltitudedown" then
        OldButtonMod = HoldAltitudeButtonModifier
        OldAntiMod = AntiGravButtonModifier
        if antigrav and antigrav.getState() == 1 then
            if AntigravTargetAltitude ~= nil then
                AntigravTargetAltitude = AntigravTargetAltitude - AntiGravButtonModifier
                if AntigravTargetAltitude < 1000 then AntigravTargetAltitude = 1000 end
            else
                AntigravTargetAltitude = desiredBaseAltitude
            end
        elseif AltitudeHold then
            HoldAltitude = HoldAltitude - HoldAltitudeButtonModifier
        else
            Nav.axisCommandManager:updateTargetGroundAltitudeFromActionStart(-1.0)
        end
    elseif action == "option1" then
        IncrementAutopilotTargetIndex()
        ToggleView = false
    elseif action == "option2" then
        DecrementAutopilotTargetIndex()
        ToggleView = false
    elseif action == "option3" then
        if hideHudOnToggleWidgets then
            if showHud then
                showHud = false
            else
                showHud = true
            end
        end
        ToggleView = false
        ToggleWidgets()
    elseif action == "option4" then
        ToggleAutopilot()
        ToggleView = false
    elseif action == "option5" then
        ToggleTurnBurn()
        ToggleView = false
    elseif action == "option6" then
        ToggleAltitudeHold()
        ToggleView = false
    elseif action == "option7" then
        wipeSaveVariables()
        ToggleView = false
    elseif action == "option8" then
        ToggleFollowMode()
        ToggleView = false
    elseif action == "option9" then
        if gyro ~= nil then
            gyro.toggle()
            GyroIsOn = gyro.getState() == 1
        end
        ToggleView = false
    elseif action == "lshift" then
        if system.isViewLocked() == 1 then
            HoldingCtrl = true
            PrevViewLock = system.isViewLocked()
            system.lockView(1)
        elseif Nav.control.isRemoteControlled() == 1 and ShiftShowsRemoteButtons then
            HoldingCtrl = true
            Animated = false
            Animating = false
        end
    elseif action == "brake" then
        if brakeToggle then
            BrakeToggle()
        elseif not BrakeIsOn then
            BrakeToggle() -- Trigger the cancellations
        else
            BrakeIsOn = true -- Should never happen
        end
    elseif action == "lalt" then
        if Nav.control.isRemoteControlled() == 0 and not freeLookToggle and userControlScheme == "Keyboard" then
            system.lockView(1)
        end
    elseif action == "booster" then
        -- Nav:toggleBoosters()
        -- Dodgin's Don't Die Rocket Govenor - Cruise Control Edition
        IsBoosting = not IsBoosting
        if (IsBoosting) then
            unit.setEngineThrust('rocket_engine', 1)
        else
            unit.setEngineThrust('rocket_engine', 0)
        end
    elseif action == "stopengines" then
        Nav.axisCommandManager:resetCommand(axisCommandId.longitudinal)
    elseif action == "speedup" then
        if not HoldingCtrl then
            Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.longitudinal, speedChangeLarge)
        else
            IncrementAutopilotTargetIndex()
        end
    elseif action == "speeddown" then
        if not HoldingCtrl then
            Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.longitudinal, -speedChangeLarge)
        else
            DecrementAutopilotTargetIndex()
        end
    elseif action == "antigravity" then
        if antigrav ~= nil then
            ToggleAntigrav()
        end
    elseif action == "warp" then
        if warpdrive ~= nil then
            if not InEmergencyWarp then
                if showWarpWidget then
                    warpdrive.hide()
                    showWarpWidget = false
                else
                    warpdrive.show()
                    showWarpWidget = true
                end
                if json.decode(warpdrive.getData()).buttonMsg == "CANNOT WARP" then
                    MsgText = json.decode(warpdrive.getData()).errorMsg
                else
                    warpdrive.activateWarp()
                    warpdrive.show()
                    showWarpWidget = true
                end
            else
                unit.stopTimer("emergencyWarpTick")
                InEmergencyWarp = false -- lower case is IN situation
                EmergencyWarp = false -- upper case is if to monitor for situation
                MsgText = "Emergency Warp Cancelled"
            end
        end
    end
end

function script.onActionStop(action)
    if action == "forward" then
        PitchInput = PitchInput + 1
    elseif action == "backward" then
        PitchInput = PitchInput - 1
    elseif action == "left" then
        RollInput = RollInput + 1
    elseif action == "right" then
        RollInput = RollInput - 1
    elseif action == "yawright" then
        YawInput = YawInput + 1
    elseif action == "yawleft" then
        YawInput = YawInput - 1
    elseif action == "straferight" then
        Nav.axisCommandManager:updateCommandFromActionStop(axisCommandId.lateral, -1.0)
    elseif action == "strafeleft" then
        Nav.axisCommandManager:updateCommandFromActionStop(axisCommandId.lateral, 1.0)
    elseif action == "up" then
        UpAmount = UpAmount - 1
        Nav.axisCommandManager:updateCommandFromActionStop(axisCommandId.vertical, -1.0)
        Nav.axisCommandManager:activateGroundEngineAltitudeStabilization()
    elseif action == "down" then
        UpAmount = UpAmount + 1
        Nav.axisCommandManager:updateCommandFromActionStop(axisCommandId.vertical, 1.0)
        Nav.axisCommandManager:activateGroundEngineAltitudeStabilization()
    elseif action == "groundaltitudeup" then
        if antigrav and antigrav.getState() == 1 then
            AntiGravButtonModifier = OldAntiMod
        elseif AltitudeHold then
            HoldAltitudeButtonModifier = OldButtonMod
        end
        ToggleView = false
    elseif action == "groundaltitudedown" then
        if antigrav and antigrav.getState() == 1 then
            AntiGravButtonModifier = OldAntiMod
        elseif AltitudeHold then
            HoldAltitudeButtonModifier = OldButtonMod
        end
        ToggleView = false
    elseif action == "lshift" then
        if system.isViewLocked() == 1 then
            HoldingCtrl = false
            SimulatedX = 0
            SimulatedY = 0 -- Reset for steering purposes
            system.lockView(PrevViewLock)
        elseif Nav.control.isRemoteControlled() == 1 and ShiftShowsRemoteButtons then
            HoldingCtrl = false
            Animated = false
            Animating = false
        end
    elseif action == "brake" then
        if not brakeToggle then
            if BrakeIsOn then
                BrakeToggle()
            else
                BrakeIsOn = false -- Should never happen
            end
        end
    elseif action == "lalt" then
        if Nav.control.isRemoteControlled() == 0 and freeLookToggle then
            if ToggleView then
                if system.isViewLocked() == 1 then
                    system.lockView(0)
                else
                    system.lockView(1)
                end
            else
                ToggleView = true
            end
        elseif Nav.control.isRemoteControlled() == 0 and not freeLookToggle and userControlScheme == "Keyboard" then
            system.lockView(0)
        end
    end
end

function script.onActionLoop(action)
    if action == "groundaltitudeup" then
        if antigrav and antigrav.getState() == 1 then
            if AntigravTargetAltitude ~= nil then 
                AntigravTargetAltitude = AntigravTargetAltitude + AntiGravButtonModifier
                AntiGravButtonModifier = AntiGravButtonModifier * 1.05
            else
                AntigravTargetAltitude = desiredBaseAltitude + 100
            end
        elseif AltitudeHold then
            HoldAltitude = HoldAltitude + HoldAltitudeButtonModifier
            HoldAltitudeButtonModifier = HoldAltitudeButtonModifier * 1.05
        else
            Nav.axisCommandManager:updateTargetGroundAltitudeFromActionLoop(1.0)
        end
    elseif action == "groundaltitudedown" then
        if antigrav and antigrav.getState() == 1 then
            if AntigravTargetAltitude ~= nil then
                AntigravTargetAltitude = AntigravTargetAltitude - AntiGravButtonModifier
                AntiGravButtonModifier = AntiGravButtonModifier * 1.05
                if AntigravTargetAltitude < 1000 then AntigravTargetAltitude = 1000 end
            else
                AntigravTargetAltitude = desiredBaseAltitude - 100
            end
        elseif AltitudeHold then
            HoldAltitude = HoldAltitude - HoldAltitudeButtonModifier
            HoldAltitudeButtonModifier = HoldAltitudeButtonModifier * 1.05
        else
            Nav.axisCommandManager:updateTargetGroundAltitudeFromActionLoop(-1.0)
        end
    elseif action == "speedup" then
        if not HoldingCtrl then
            Nav.axisCommandManager:updateCommandFromActionLoop(axisCommandId.longitudinal, speedChangeSmall)
        end
    elseif action == "speeddown" then
        if not HoldingCtrl then
            Nav.axisCommandManager:updateCommandFromActionLoop(axisCommandId.longitudinal, -speedChangeSmall)
        end
    end
end

function DisplayMessage(newContent, displayText)
    if displayText ~= "empty" then
        newContent[#newContent + 1] = [[<text class="msg" x="50%%" y="310" >]]
        for str in string.gmatch(displayText, "([^\n]+)") do
            newContent[#newContent + 1] = string.format([[<tspan x="50%%" dy="35">%s</tspan>]], str)
        end
        newContent[#newContent + 1] = [[</text>]]
    end
    if MsgTimer ~= 0 then
        unit.setTimer("msgTick", MsgTimer)
        MsgTimer = 0
    end
end

function updateDistance()
    local curTime = system.getTime()
    local velocity = vec3(core.getWorldVelocity())
    local spd = vec3(velocity):len()
    local elapsedTime = curTime - LastTravelTime
    if (spd > 1.38889) then
        spd = spd / 1000
        local newDistance = spd * (curTime - LastTravelTime)
        TotalDistanceTravelled = TotalDistanceTravelled + newDistance
        TotalDistanceTrip = TotalDistanceTrip + newDistance
    end
    FlightTime = FlightTime + elapsedTime
    TotalFlightTime = TotalFlightTime + elapsedTime
    LastTravelTime = curTime
end

function updateMass()
    local totMass = 0
    for k in pairs(ElementsID) do
        totMass = totMass + core.getElementMassById(ElementsID[k])
    end
    return totMass
end    

script.onStart()

