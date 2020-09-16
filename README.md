## DU-Orbital-Hud
Dual Universe HUD with orbital information, braking distances, and Rezoix's pitch/roll hud with some fixes
Works with Command Seat and Hover Seat, not Cockpit

If you wish to save your current config, right click your seat and Copy Lua Configuration to Clipboard, and save it somewhere

# Usage
Click on **D_flying_construct_HUD.conf** above.  On the top right, right click the 'RAW' button and click Save Link As...

Save the file to %ProgramData%\Dual Universe\Game\data\lua\autoconf\custom, the filename does not matter (as long as it's still .conf)


In-game, right click your seat and go to Advanced -> Update custom autoconf list
Then Advanced -> Run Custom Autoconfigure -> D's Flying Construct with HUD

This should set everything up and you're good to go

# Warnings
If you are in atmosphere, the Max Brake Distance listed on the Interplanetary widget will be inaccurate, since it will be using your atmospheric brakes to calculate.  Once you enter space, it should be accurate.

## Controls
Alt+1 and Alt+2 (Option1 and Option2) to scroll between target planets for the Interplanetary Helper.  This widget will not display if no planet is selected (ie you must press one of these hotkeys after entering the seat in order to show the widget)

## Customization
You may edit the R,G,B LUA parameters to set the main color of the HUD


### Features
**Rezoix HUD** (i.e. pitch/roll/yaw indicators), with LUA-parameter RGB values so you can set the base color, and with fixes (yaw is displayed in space properly instead of pitch, throttle indicator is fixed, gyro no longer required) - https://github.com/Rezoix/DU-hud

**Orbital Information widget** - Shows apoapsis, periapsis, apogee, perigee, eccentricity for the nearest planet, using these libraries: https://gitlab.com/JayleBreak/dualuniverse/-/tree/master/DUflightfiles/autoconf/custom

**Interplanetary Helper** - Use Alt+1 and Alt+2 to cycle through target planets.  Shows distance, travel time (including acceleration, travel, and braking - absolute total), brake time (current and max).  Note that currently, Brake Time is inaccurate if you're inside atmosphere.  Once you're in space, it will properly read the space brakes and give the correct values

**Brake Indicator/Toggle** - Brake is now a toggle, and is on by default when entering the seat.  There is an onscreen text indicator to show you when the brake is on
