## DU-Orbital-Hud

![Example](/MINHUD%20example.png)

Dual Universe HUD and autopilot with orbital information, braking distances, and Rezoix's pitch/roll hud with some fixes
Works with Command Seat and Hover Seat, not Cockpit

If you wish to save your current config, right click your seat and Copy Lua Configuration to Clipboard, and save it somewhere

## Version Information
MINHUD and Archeageo HUD are working versions that aren't likely to receive further improvements; everything is accessible by hotkeys.  

The newest ButtonHUD version includes Archeageo's HUD, as well as new capability like aligning to prograde and retrograde, a button system, and will continue to receive updates.

# Usage
Click on **D_flying_construct_MIN_HUD.conf** or **flying_construct_Archeago_Hud.conf** or **buttonHUD.conf** above.  Archaego HUD has a lot of extra HUD features, such as altitude and speed meters.  The Button HUD is the latest and most recent version but comes with a few caveats (read below).  On the top right, right click the 'RAW' button and click Save Link As...

Save the file to *%ProgramData%\Dual Universe\Game\data\lua\autoconf\custom*, the filename does not matter (as long as it's still .conf)


In-game, right click your seat and go to *Advanced -> Update custom autoconf list*

Then *Advanced -> Run Custom Autoconfigure -> D's Flying Construct with HUD Archaegeo V1*

This should set everything up and you're good to go

# Warnings
If you are in atmosphere, the Max Brake Distance listed on the Interplanetary widget will be inaccurate, since it will be using your atmospheric brakes to calculate.  Once you enter space, it should be accurate.

The autopilot is relatively untested at this stage.  Do not rely on it if you go AFK, and let me know of any issues you encounter with it.

Note that Turn & Burn Mode assumes your ship will be able to face the correct direction to burn before you must begin braking, and should be used with caution for short trips

### When your gear is extended, your hover height is set to 0.  This helps with landings but don't attempt to put out your gear before you're hovering on the surface.  There is a warning if the gear is extended

# Do not engage the autopilot if you do not have clear line of sight to the target

It cannot detect if there is a planet in the way.  It'll just go for it.

## Autopilot is mostly tested, but you should use with supervision; in current state I can't guarantee it will achieve a stable orbit

## Controls/Info - ButtonHUD
This HUD uses on-screen buttons, and so needs to be able to use your mouse.  The only way to keep DU from trying to use your mouse for input is to set the Control Scheme to Keyboard.  You can then right click the seat, *Advanced -> Edit LUA Parameters* and find the checkboxes to choose which control scheme you would actually like to use.

The usual hotkeys from the MINHUD versions apply, but it should be easier to use the new button system.

Hold **Shift** to show the UI overlay with buttons.  Mouse over a button and let go of Shift to select it.  

While holding Shift, press **R/T** (speedup/speeddown) to cycle between autopilot targets.

Auto-Brake is not on the UI this version; it is unreliable because it is unable to align your trajectory, and tends to over-brake if it's not perfectly aligned.  Use Autopilot if you need auto-brake, so that it can align properly.  Auto-brake is still accessible on **Alt+3** if you want it.

**Alt** is now a toggle for free-look.  Because of the way we had to use Keyboard mode, it can't re-center when you lock it back, but that can be desirable in some situations

If you need to zoom out in 3rd person view, you must toggle free-look because the game will not recognize Shift when it's being used for the UI

**Turn & Burn Mode** is still accessible with **Alt+5** (will be added to UI soon)

## Controls - MINHUD and Archeageo HUD
**Alt+1** and **Alt+2** (Option1 and Option2) **to scroll between target planets for Autopilot and display**.  This widget will not display if no planet is selected (ie you must press one of these hotkeys after entering the seat in order to show the widget)

**Alt+3** to engage **Auto-Brake**.  This will simply engage the brake if you come within the max braking distance of the planet targeted with Alt+1 and Alt+2, and disengage it once it's gotten as close to an orbit as it can just by braking.  This is an alternative to auto-pilot if you don't want to give the autopilot control over where your ship is facing or thrusters

**Alt+4** to engage **Autopilot** for interplanetary travel, if you are in space and have a planet targeted with Alt+1/Alt+2.  Ensure you have a clear line of sight to the target.  This will align to the target, realign slightly to point 200km to the side of the target, accelerate, cut engines when at max, start braking when appropriate, and hopefully achieve a stable orbit around the target.

**Alt+5** to toggle **Turn & Burn Mode**, which changes all your braking readouts to assume you will be turning and burning.  Be sure to set *warmup* in the Parameters if you use this; the default warmup is assumed to be 32s.  Autopilot will also turn and burn for you (Auto-Braking will not).  Note that Turn & Burn Mode assumes your ship will be able to face the correct direction to burn before you must begin braking, and should be used with caution for short trips

**Alt+6** to toggle **Fuel Widgets On and Off** - Results in a cleaner hud if you dont need fuel status

**Alt+7** to toggle **Unit Widget On and Off**.  All important information is present on the HUD, but it is still enabled by default since we're often used to reading from it

## Customization
The following LUA parameters were added

*PrimaryR*, *PrimaryG*, *PrimaryB* - To set the primary color for the HUD

*AutopilotStrength*, *DampingMultiplier* - If you find the autopilot is aligning too slowly, you can try increasing the strength.  If it overshoots and has to realign, you can try increasing the DampingMultiplier.  Note that, when going at max speed, ships seem to turn much slower than normal as a whole, and while traveling the target will be moving constantly, so it may bounce from the target slightly even with good settings.  

*alignmentTolerance* - How closely the ship must align to the target planet before it considers itself 'aligned'.  On ships with low torque, it may take a very long time to align with small values, but smaller values help ensure there is less error over the large distances it will be traveling

*warmup* - How long your engines take to warmup, or T50.  Defaults to 32.  For everything but freight engines, these values for space engines are: XS 0.25, S 1, M 4, L 16, XL 32.  If you're using freight engines, you should probably check https://hq.hyperion-corporation.de/ingame-engine-library

*circleRad* - to set the size of the altimeter circle in the middle of the screen, setting it to 0 will remove the circle.

### Features
**Rezoix HUD** (i.e. pitch/roll/yaw indicators), with LUA-parameter RGB values so you can set the base color, and with fixes (yaw is displayed in space properly instead of pitch, throttle indicator is fixed, gyro no longer required) - https://github.com/Rezoix/DU-hud

**Orbital Information widget** - Shows apoapsis, periapsis, apogee, perigee, eccentricity for the nearest planet, using these libraries: https://gitlab.com/JayleBreak/dualuniverse/-/tree/master/DUflightfiles/autoconf/custom

**Brake Indicator/Toggle** - Brake is now a toggle, and is on by default when entering the seat.  There is an onscreen text indicator to show you when the brake is on

**Interplanetary Helper** - Use Alt+1 and Alt+2 to cycle through target planets.  Shows distance, travel time (including acceleration, travel, and braking - absolute total), brake time (current and max).  Note that currently, Brake Time is inaccurate if you're inside atmosphere.  Once you're in space, it will properly read the space brakes and give the correct values

**Auto-Brake** - Use Alt+3 when you have a target selected with the Interplanetary Helper, and it will toggle Auto-Brake.  The script will automatically engage the brake when within the max braking distance for that planet.  This does not guarantee that you will not hit the planet - even with Auto-Brake, do not aim directly at the planet.  It targets an end speed of 0, though you will generally have a much higher end speed, so has some leeway.  It will continue braking until stable orbit is achieved, if possible from the trajectory.

**AutoPilot** - Use Alt+4 when you have a target selected with the Interplanetary Helper, and you are in space with clear line of sight to the target.  The script will align to the optimal vector to place you in a 1SU orbit from the target, accelerate, cut engines when appropriate, and brake until orbit is achieved.  
**NOTE** As of right now, this will almost definitely get you to the safe zone of the planet without smashing into it, but will likely not achieve a stable orbit.  You must be present at the end of the trip 

**Turn & Burn** - Use Alt+5 to toggle Turn & Burn mode, which changes all your readouts to assume you will turn and burn when braking, and sets autopilot to turn and burn for you.  

**Dodgin's Don't Die Rocket Governor** - Set your speed with cruise control and press B to have your rocket engines fire up to that speed and no faster

**Auto-Land on Gear Down** - Putting down your landing gear sets your hover height to 0, raising it sets it to max.  Entering a vehicle with gear down sets the height to 0, entering a vehicle with the gear up sets it to max

**(ButtonHUD) Buttons and custom controls** - Custom implementations of virtual joystick and mouse controls, allowing you to use virtual joystick without that disgusting giant circle on your screen.  Buttons to use many of the features.

### Credits

Rezoix and his HUD - https://github.com/Rezoix/DU-hud

JayleBreak and his orbital maths/atlas - https://gitlab.com/JayleBreak/dualuniverse/-/tree/master/DUflightfiles/autoconf/custom

Archeageo and his work on the HUD
