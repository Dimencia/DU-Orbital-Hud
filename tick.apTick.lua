-- NO USER CHANGES
yawInput2 = 0
rollInput2 = 0
pitchInput2 = 0
LastApsDiff = -1
local velocity = vec3(core.getWorldVelocity())
local velMag = vec3(velocity):len()
local sys = galaxyReference[0]
planet = sys:closestBody(core.getConstructWorldPos())
kepPlanet = Kep(planet)
orbit = kepPlanet:orbitalParameters(core.getConstructWorldPos(), velocity)
local deltaX = system.getMouseDeltaX()
local deltaY = system.getMouseDeltaY()
targetGroundAltitude = Nav:getTargetGroundAltitude()
local TrajectoryAlignmentStrength = 0.002 -- How strongly AP tries to align your velocity vector to the target when not in orbit
if BrakeIsOn then
    brakeInput = 1
else
    brakeInput = 0
end
core_altitude = core.getAltitude()
if core_altitude == 0 then
    core_altitude = (vec3(core.getConstructWorldPos()) - planet.center):len() - planet.radius
end

if AutopilotTargetName ~= "None" then

    ShowInterplanetaryPanel()
    system.updateData(interplanetaryHeaderText,
        '{"label": "Target", "value": "' .. AutopilotTargetName .. '", "unit":""}')
    travelTime = GetAutopilotTravelTime() -- This also sets AutopilotDistance so we don't have to calc it again
    distance = AutopilotDistance
    if not TurnBurn then
        brakeDistance, brakeTime = GetAutopilotBrakeDistanceAndTime(velMag)
        maxBrakeDistance, maxBrakeTime = GetAutopilotBrakeDistanceAndTime(MaxGameVelocity)
    else
        brakeDistance, brakeTime = GetAutopilotTBBrakeDistanceAndTime(velMag)
        maxBrakeDistance, maxBrakeTime = GetAutopilotTBBrakeDistanceAndTime(MaxGameVelocity)
    end
    system.updateData(widgetDistanceText,
        '{"label": "Distance", "value": "' .. getDistanceDisplayString(distance) .. '", "unit":""}')
    system.updateData(widgetTravelTimeText,
        '{"label": "Travel Time", "value": "' .. FormatTimeString(travelTime) .. '", "unit":""}')
    system.updateData(widgetCurBrakeDistanceText, '{"label": "Cur Brake Distance", "value": "' ..
        getDistanceDisplayString(brakeDistance) .. '", "unit":""}')
    system.updateData(widgetCurBrakeTimeText,
        '{"label": "Cur Brake Time", "value": "' .. FormatTimeString(brakeTime) .. '", "unit":""}')
    system.updateData(widgetMaxBrakeDistanceText, '{"label": "Max Brake Distance", "value": "' ..
        getDistanceDisplayString(maxBrakeDistance) .. '", "unit":""}')
    system.updateData(widgetMaxBrakeTimeText,
        '{"label": "Max Brake Time", "value": "' .. FormatTimeString(maxBrakeTime) .. '", "unit":""}')
    if unit.getAtmosphereDensity() > 0 and not InAtmo then
        system.removeDataFromWidget(widgetMaxBrakeTimeText, widgetMaxBrakeTime)
        system.removeDataFromWidget(widgetMaxBrakeDistanceText, widgetMaxBrakeDistance)
        system.removeDataFromWidget(widgetCurBrakeTimeText, widgetCurBrakeTime)
        system.removeDataFromWidget(widgetCurBrakeDistanceText, widgetCurBrakeDistance)
        system.removeDataFromWidget(widgetTrajectoryAltitudeText, widgetTrajectoryAltitude)
        InAtmo = true
    elseif unit.getAtmosphereDensity() == 0 and InAtmo then
        system.addDataToWidget(widgetMaxBrakeTimeText, widgetMaxBrakeTime)
        system.addDataToWidget(widgetMaxBrakeDistanceText, widgetMaxBrakeDistance)
        system.addDataToWidget(widgetCurBrakeTimeText, widgetCurBrakeTime)
        system.addDataToWidget(widgetCurBrakeDistanceText, widgetCurBrakeDistance)
        system.addDataToWidget(widgetTrajectoryAltitudeText, widgetTrajectoryAltitude)
        InAtmo = false
    end
else
    HideInterplanetaryPanel()
end
if showHud then
    updateHud() -- sets up Content for us
else
    content = [[<head>
                        <style>
                            body {margin: 0}
                            svg {display:block; position: absolute; top:0; left:0}
                            text {font-family:Montserrat;font-weight:bold}
                        </style>
                        <body>
                            <svg height="100vh" width="100vw" viewbox="0 0 1920 1080">]]
    DisplayOrbit()
    DrawWarnings()
end
content = content ..
              [[<svg width="100vw" height="100vh" style="position:absolute;top:0;left:0"  viewBox="0 0 2560 1440">]]
if msgText ~= "empty" then
    DisplayMessage(msgText)
end
if Nav.control.isRemoteControlled() == 0 and userControlScheme == "Virtual Joystick" then
    DrawDeadZone()
end
if Nav.control.isRemoteControlled() == 1 and screen_1 and screen_1.getMouseY() ~= -1 then
    simulatedX = screen_1.getMouseX() * 2560
    simulatedY = screen_1.getMouseY() * 1440
    SetButtonContains()
    DrawButtons()
    if screen_1.getMouseState() == 1 then
        CheckButtons()
    end
    content =
        content .. "<circle stroke='white' cx='calc(50% + " .. simulatedX .. "px)' cy='calc(50% + " .. simulatedY ..
            "px)' r='5'/>"
elseif system.isViewLocked() == 0 then
    if Nav.control.isRemoteControlled() == 1 and HoldingCtrl then
        if not Animating then
            simulatedX = simulatedX + deltaX
            simulatedY = simulatedY + deltaY
        end
        SetButtonContains()
        DrawButtons()
        -- If they're remote, it's kinda weird to be 'looking' everywhere while you use the mouse
        -- We need to add a body with a background color
        if not Animating and not Animated then
            content =
                "<style>@keyframes test { from { opacity: 0; } to { opacity: 1; } }  body { animation-name: test; animation-duration: 0.5s; }</style><body><svg width='100%' height='100%' position='absolute' top='0' left='0'><rect width='100%' height='100%' x='0' y='0' position='absolute' style='fill:rgb(6,5,26);'/></svg><svg width='50%' height='50%' style='position:absolute;top:30%;left:25%' viewbox='0 0 1920 1080'>" ..
                    GalaxyMapHTML .. content .. "</body>"
            Animating = true
            content = content .. [[</svg></body>]] -- Uh what.. okay...
            unit.setTimer("animateTick", 0.5)
            system.setScreen(content)
        elseif Animated then
            content =
                "<body style='background-color:rgb(6,5,26)'><svg width='50%' height='50%' style='position:absolute;top:30%;left:25%' viewbox='0 0 1920 1080'>" ..
                    GalaxyMapHTML .. content
            content = content .. "</body>"
        end

        if not Animating then
            content = content .. "<circle stroke='white' cx='calc(50% + " .. simulatedX .. "px)' cy='calc(50% + " ..
                          simulatedY .. "px)' r='5'/>"
        end
    else
        CheckButtons()
        simulatedX = 0
        simulatedY = 0 -- Reset after they do view things, and don't keep sending inputs while unlocked view
        -- Except of course autopilot, which is later.
    end
else
    simulatedX = simulatedX + deltaX
    simulatedY = simulatedY + deltaY
    distance = math.sqrt(simulatedX * simulatedX + simulatedY * simulatedY)
    if not HoldingCtrl and Nav.control.isRemoteControlled() == 0 then -- Draw deadzone circle if it's navigating
        if userControlScheme == "Virtual Joystick" then -- Virtual Joystick
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
        elseif userControlScheme == "Mouse" then -- Mouse Direct
            simulatedX = 0
            simulatedY = 0
            -- pitchInput2 = pitchInput2 - deltaY * mousePitchFactor
            -- yawInput2 = yawInput2 - deltaX * mouseYawFactor
            -- So... this is weird.  
            -- It's doing some odd things and giving us some weird values. 

            -- utils.smoothstep(progress, low, high)*2-1
            pitchInput2 = (-utils.smoothstep(deltaY, -100, 100) + 0.5) * 2 * mousePitchFactor
            yawInput2 = (-utils.smoothstep(deltaX, -100, 100) + 0.5) * 2 * mouseYawFactor
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
        CheckButtons()

        if distance > DeadZone then -- Draw a line to the cursor from the screen center
            -- Note that because SVG lines fucking suck, we have to do a translate and they can't use calc in their params
            DrawCursorLine()
        end
    else
        -- Ctrl is being held, draw buttons.
        -- Brake toggle, face prograde, face retrograde (for now)
        -- We've got some vars setup in Start for them to make this easier to work with
        SetButtonContains()
        DrawButtons()

    end
    -- Cursor always on top, draw it last
    content =
        content .. "<circle stroke='white' cx='calc(50% + " .. simulatedX .. "px)' cy='calc(50% + " .. simulatedY ..
            "px)' r='5'/>"

end
content = content .. [[</svg></body>]]
if content ~= LastContent then
    -- if Nav.control.isRemoteControlled() == 1 and screen_1 then -- Once the screens are fixed we can do this.
    --    screen_1.setHTML(content) -- But also this is disgusting and the resolution's terrible.  We're doing something wrong.
    -- else
    if not Animating then
        system.setScreen(content)
    end
    -- end
end
LastContent = content
if AutoBrake and AutopilotTargetPlanetName ~= "None" and
    (vec3(core.getConstructWorldPos()) - vec3(AutopilotTargetPlanet.center)):len() <= brakeDistance then
    brakeInput = 1
    if planet.name == AutopilotTargetPlanet.name and orbit.apoapsis ~= nil and orbit.eccentricity < 1 then
        -- We're increasing eccentricity by braking, time to stop
        brakeInput = 0
        AutoBrake = false
    end
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
                                  (vec3(core.getConstructWorldPos()) + (vec3(velocity):normalize() * AutopilotDistance))):len() -
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
        brakeInput = 1
        if TurnBurn then
            Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 100) -- This stays 100 to not mess up our calculations
        end
        -- Check if an orbit has been established and cut brakes and disable autopilot if so

        -- We'll try <0.9 instead of <1 so that we don't end up in a barely-orbit where touching the controls will make it an escape orbit
        -- Though we could probably keep going until it starts getting more eccentric, so we'd maybe have a circular orbit

        if orbit.periapsis ~= nil and orbit.eccentricity < 1 then
            AutopilotStatus = "Circularizing"
            -- Keep going until the apoapsis and periapsis start getting further apart
            -- Rather than: orbit.periapsis ~= nil and orbit.periapsis.altitude < ((vec3(planet.center) - vec3(core.getConstructWorldPos())):len() - planet.radius)-1000
            -- local apsDiff = math.abs(orbit.apoapsis.altitude - orbit.periapsis.altitude)
            -- if LastApsDiff ~= -1 and apsDiff > LastApsDiff then 
            if orbit.eccentricity > LastEccentricity or
                (orbit.apoapsis.altitude < AutopilotTargetOrbit and orbit.periapsis.altitude < AutopilotTargetOrbit) then
                -- LastApsDiff = -1
                BrakeIsOn = false
                AutopilotBraking = false
                Autopilot = false
                AutopilotStatus = "Aligning" -- Disable autopilot and reset
                DisplayMessage("Autopilot completed, orbit established")
                brakeInput = 0
                Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0)
            end
            LastApsDiff = apsDiff
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
                Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, AutopilotInterplanetaryThrottle)
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
    if onShip then
        maxSpeed = 300
    end
    local targetSpeed = utils.clamp((distance - targetDistance) / 2, 10, maxSpeed)
    pitchInput2 = 0
    local aligned = (math.abs(yawInput2) < 0.1)
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

        pitchInput2 = autoPitchInput
    end
end
if AltitudeHold then
    -- HoldAltitude is the alt we want to hold at
    local altitude = core_altitude
    -- Dampen this.
    local altDiff = HoldAltitude - altitude
    local MaxPitch = 20
    -- This may be better to smooth evenly regardless of HoldAltitude.  Let's say, 2km scaling?  Should be very smooth for atmo
    -- Even better if we smooth based on their velocity
    local minmax = 500 + velMag
    local targetPitch = (utils.smoothstep(altDiff, -minmax, minmax) - 0.5) * 2 * MaxPitch
    -- The clamp should now be redundant
    -- local targetPitch = utils.clamp(altDiff,-20,20) -- Clamp to reasonable values
    -- Align it prograde but keep whatever pitch inputs they gave us before, and ignore pitch input from alignment.
    -- So, you know, just yaw.
    local oldInput = pitchInput2
    if velMag > MinAutopilotSpeed then
        AlignToWorldVector(vec3(velocity))
    end
    pitchInput2 = oldInput

    if AutoLanding then
        -- Okay new strat.
        -- Bring it to like -20 or -30
        -- And when speed stops increasing, move it to -10 or 0 - that should get us to kinda the max safe speed we can do
        targetPitch = -10 -- Some flat, easy value.
        -- local verticalSpeed = velocity:project_on(vec3(core.getWorldVertical())):len() * utils.sign(velocity:dot(vec3(core.getWorldVertical())))
        -- targetPitch = -(utils.smoothstep((AutolandVerticalSpeed*(1-unit.getAtmosphereDensity()^3))-verticalSpeed, -AutolandVerticalSpeed, AutolandVerticalSpeed)-0.5)*2*40 -- Yeesh.  Scary.

        -- local planetGrav = planet:getGravity(planet.center + vec3({1,0,0}) * planet.radius):len() -- Any direction, at sea level
        -- local atmoMaxBrake = json.decode(unit.getData()).maxBrake
        -- Actually... Why don't we base pitch on how good their brakes are.  
        -- Really good brakes can probably pitch down pretty damn far
        -- local brakeRatio = atmoMaxBrake/planetGrav
        -- Such that if brakeRatio >=1, we want max, whatever that is.  -30? No.  -30 is wayyy too much.  
        -- targetPitch = -utils.smoothstep(brakeRatio,0,1)*20 -- See how this goes... 

        -- The following is kinda okay but, slower than normal.  I need to know the distance to ground if I want to do that.
        -- if atmoMaxBrake ~= nil and atmoMaxBrake > planetGrav then -- Just brake straight down, they can take it
        --    targetPitch = 0
        --    if velMag > 200 then
        --        BrakeIsOn = true
        --    else
        --        BrakeIsOn = false
        --    end
        -- end
        -- If within booster distance...
        local groundDistance
        if Nav.axisCommandManager:getAxisCommandType(0) == 1 then
            Nav.control.cancelCurrentControlMasterMode()
        end
        if vBooster then
            groundDistance = vBooster.distance()
        elseif hover then
            groundDistance = hover.distance()
        end
        if groundDistance > -1 then
            targetPitch = 10
            BrakeIsOn = true
            if velMag < 20 then
                targetPitch = 0
            end
            if velMag < 1 then
                AutoLanding = false
                AltitudeHold = false
                gearExtended = true
                Nav.control.extendLandingGears()
                Nav.axisCommandManager:setTargetGroundAltitude(0)
            end
        end
    elseif AutoTakeoff then
        if targetPitch < 10 then
            AutoTakeoff = false -- No longer in ascent
        end
    end
    local constrF = vec3(core.getConstructWorldOrientationForward())
    local constrR = vec3(core.getConstructWorldOrientationRight())
    local worldV = vec3(core.getWorldVertical())
    local pitch = getPitch(worldV, constrF, constrR)
    local autoPitchThreshold = 0.1
    -- Copied from autoroll let's hope this is how a PID works... 
    if math.abs(targetPitch - pitch) > autoPitchThreshold then
        if (pitchPID == nil) then -- Changed from 2 to 8 to tighten it up around the target
            pitchPID = pid.new(8 * 0.01, 0, 8 * 0.1) -- magic number tweaked to have a default factor in the 1-10 range
        end
        pitchPID:inject(targetPitch - pitch)
        local autoPitchInput = pitchPID:get()
        pitchInput2 = pitchInput2 + autoPitchInput
    end
end
LastEccentricity = orbit.eccentricity
