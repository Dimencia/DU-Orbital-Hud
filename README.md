## DU-Orbital-Hud
Dual Universe HUD and autopilot with orbital information, braking distances, and Rezoix's pitch/roll hud with some fixes
Works with Command Seat and Hover Seat, not Cockpit

If you wish to save your current config, right click your seat and Copy Lua Configuration to Clipboard, and save it somewhere

# Usage
Click on **D_flying_construct_MIN_HUD.conf** or FULL_HUD above.  MIN_HUD gets rid of the extra UI clutter near the cursor on the Rezoix hud.  On the top right, right click the 'RAW' button and click Save Link As...

Save the file to *%ProgramData%\Dual Universe\Game\data\lua\autoconf\custom*, the filename does not matter (as long as it's still .conf)


In-game, right click your seat and go to *Advanced -> Update custom autoconf list*

Then *Advanced -> Run Custom Autoconfigure -> D's Flying Construct with HUD*

This should set everything up and you're good to go

# Warnings
If you are in atmosphere, the Max Brake Distance listed on the Interplanetary widget will be inaccurate, since it will be using your atmospheric brakes to calculate.  Once you enter space, it should be accurate.

The autopilot is relatively untested at this stage.  Do not rely on it if you go AFK, and let me know of any issues you encounter with it.

# Do not engage the autopilot if you do not have clear line of sight to the target

It cannot detect if there is a planet in the way.  It'll just go for it.

## Controls
**Alt+1** and **Alt+2** (Option1 and Option2) **to scroll between target planets for the Interplanetary Helper**.  This widget will not display if no planet is selected (ie you must press one of these hotkeys after entering the seat in order to show the widget)

**Alt+3** to engage **Auto-Brake**.  This will simply engage the brake if you come within the max braking distance of the planet targeted with Alt+1 and Alt+2, and disengage it once it's gotten as close to an orbit as it can just by braking.  
**Alt+4** to engage **Autopilot** for interplanetary travel, if you are in space and have a planet targeted with Alt+1/Alt+2.  Ensure you have a clear line of sight to the target.  This will align to the target, realign slightly to point 200km to the side of the target, accelerate, cut engines when at max, start braking when appropriate, and hopefully achieve a stable orbit around the target.

## Customization
The following LUA parameters were added

*PrimaryR*, *PrimaryG*, *PrimaryB* - To set the primary color for the Rezoix HUD

*AutopilotStrength*, *DampingMultiplier* - If you find the autopilot is aligning too slowly, you can try increasing the strength.  If it overshoots and has to realign, you can try increasing the DampingMultiplier.  Note that, when going at max speed, ships seem to turn much slower than normal as a whole, and while traveling the target will be moving constantly, so it may bounce from the target slightly even with good settings.  

*alignmentTolerance* - How closely the ship must align to the target planet before it considers itself 'aligned'.  On ships with low torque, it may take a very long time to align with small values, but smaller values help ensure there is less error over the large distances it will be traveling

### Features
**Rezoix HUD** (i.e. pitch/roll/yaw indicators), with LUA-parameter RGB values so you can set the base color, and with fixes (yaw is displayed in space properly instead of pitch, throttle indicator is fixed, gyro no longer required) - https://github.com/Rezoix/DU-hud

**Orbital Information widget** - Shows apoapsis, periapsis, apogee, perigee, eccentricity for the nearest planet, using these libraries: https://gitlab.com/JayleBreak/dualuniverse/-/tree/master/DUflightfiles/autoconf/custom

**Interplanetary Helper** - Use Alt+1 and Alt+2 to cycle through target planets.  Shows distance, travel time (including acceleration, travel, and braking - absolute total), brake time (current and max).  Note that currently, Brake Time is inaccurate if you're inside atmosphere.  Once you're in space, it will properly read the space brakes and give the correct values

**Auto-Brake** - Use Alt+3 when you have a target selected with the Interplanetary Helper, and it will toggle Auto-Brake.  The script will automatically engage the brake when within the max braking distance for that planet.  This does not guarantee that you will not hit the planet - even with Auto-Brake, do not aim directly at the planet.  It targets an end speed of 0, though you will generally have a much higher end speed, so has some leeway.  It will continue braking until stable orbit is achieved, if possible from the trajectory.

**AutoPilot** - Use Alt+4 when you have a target selected with the Interplanetary Helper, and you are in space with clear line of sight to the target.  The script will align to the optimal vector to place you in a 1SU orbit from the target, accelerate, cut engines when appropriate, and brake until orbit is achieved.  
**NOTE** As of right now, this isn't well tested.  I've used it in one flight, and it seemed to do well, but I don't know how well it does at making an orbit.  In its current state, do not rely on this script to finish braking into orbit while you sleep.  

**Brake Indicator/Toggle** - Brake is now a toggle, and is on by default when entering the seat.  There is an onscreen text indicator to show you when the brake is on
