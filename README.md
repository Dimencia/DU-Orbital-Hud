## We now have a [Discord](https://discord.gg/sRaqzmS)!  

We have tons of code snippets, help channels, a github feed, and we focus on everything LUA and open source.  It's also a centralized place to get tech support: https://discord.gg/sRaqzmS

We've also just added a lua-commissions channel!  Non-scripters can post requests here, and scripters can freelance those requests for pay (or not)

We're also recruting for our in-game lua-focused org (with a bit of PVP focus on the side).  Check the discord for details

## SAVE UPDATE
> We have changed how saving settings works.  Put a databank on your ship and run (rerun) the autoconf.  Then right click seat, Advanced->Edit Lua Parameters.  Set your parameters.  Saving now occurs when you exit the seat/remote.  Loading occurs when you sit down in the chair.  If you need to override what is on the databank with new changes, toggle on the useTheseSettings parameter in Edit Lua Parameters.  Then when you sit down, it will use the parameters shown in Edit Lua Parameters.  It will still save them when you stand up, but will continue to use the Edit Lua Parameters until you turn off useTheseSettings. Alt-7 is only used to WIPE all parameters/flight status variables.

# Overview

This is a general-purpose HUD for Dual Universe.  It includes a wide array of features including:

* Heads-up display with artificial horizon, pitch, roll/yaw, altimeter, vertical speed, and more... (originally based on Rezoix's pitch/roll HUD)
* Auto-pilot features including transit-to-orbit, inter-planetary transit routes, orbital insertion, automatic braking, autopilot to saved location in atmosphere and more...
* Emergency Warp if target too close
* Trip odometers and information display.
* Fuel level displays for all types of fuel tanks.  Ability to unslot fuel tanks to save slots.
* Brake hold, altitude hold, auto-landing and takeoff functionality
* Brake Landing if strong brakes, else Coast Landing.
* Warp Engine widget hide if not meeting requirements to warp unless toggled on.
* Orbital alignment and maneuver assistants
* Radar and periscope for situational awareness
* Ability to hide the built-in display windows to keep your flight aesthetic clean and focused
* Free-look mode
* User Parameters for customizing to your flight preference and ship capabilities.
* Save parameters between HUD version updates

> NOTE: The HUD works with all control units, but Cockpit support is experimental and may cause more FPS loss than normal.  Use the Cockpit branch if you wish to use this anyway


## Examples and Tutorials

https://www.twitch.tv/videos/748340916 - Demonstration of Use and Features

![Example](/ButtonHUD_example_1.png)

**Donations are accepted!**  We have a Donation Station in Sanctuary District 3 and more to come, or you can always contact us and do a VR trade.    Basically I keep running into problems where I can't afford the cool stuff I want to play with next because I spent all my time writing stuff.  You saw what happened when I finally got a remote controller.  So, a few people were asking, and I figured why not offer.  And of course, Arche gets a cut too.  **Just make sure that for any Donation Station you see, that the owner is Dimencia or Archaegeo.**  I fully expect to see fake ones out there.

## Version Information

Check the [changelog](./ChangeLog.md) file for information about the most recent changes.  This is updated very frequently.

# Installation
## While a databank element is not required, it is strongly recommended.  They are cheap, or easy to make, and take up 1x1x1 cube space and fit nicely in front of seat.  Having one on your ship prior to doing the below steps will save your user preferences and some longterm variables, as well as flight status if you get up and sit back down in some situations.
1. Download the latest version of [ButtonHUD.conf](https://github.com/Dimencia/DU-Orbital-Hud/releases/latest/download/ButtonHUD.conf).
1. Save the file to *`%ProgramData%\Dual Universe\Game\data\lua\autoconf\custom`*, the filename does not matter (as long as it's still .conf)
1. In-game, right click your seat and go to *Advanced -> Update custom autoconf list*  - If you get a YAML error, you did not follow the above directions correctly.
1. Again, right click your seat and select *Advanced -> Run Custom Autoconfigure -> ButtonsHud - Dimencia and Archaegeo*
1. IMPORTANT: Right click the ship and set the user control scheme to `Keyboard` (*Advanced -> Change Control Scheme -> Keyboard*). This is necessary for the HUD to work, but you can change the actual control scheme in the next step - fear not virtual joystick aces!
1. Right click the seat, choose *Advanced -> Edit LUA Parameters*.  Change the `userControlScheme` to the actual control scheme you wish to use (e.g. `Virtual Joystick`).  You may mouse over the other parameters and set them as you wish - there are many, you should familiarize yourself with them.
1. If you have a Databank installed on your vehicle you may save your parameters using the `Option 7` key (normally mapped to `ALT-7`).  Saved parameters will be restored any time you upgrade the HUD to a new version.

At this point you should be ready to fly!

> NOTE: You may manually connect doors or forcefields to the seat and it will remember them each time you configure it, and automatically open them when exiting the seat and close them when entering.  When connecting doors/forcefields, ensure they are shut when linking to seat first tiem.  If the ship contains a databank, it will be connected to the seat for use with storing variables (but it will never truly clear a databank, so you can use the databank for other things as well).  If the seat has a connect button, it will be pressed when exiting the seat.  Fuel tanks are not automatically slotted but you still get fuel status. They can be manually slotted if desired for more accurate readings and non-hud fuel widget.

# Warnings

> DISCLAIMER: We do not accept any responsibility for incorrect use of the autopilot, which may result in fiery reentry, mountain impacts or undesired entrance into PvP if used carelessly.  Read and heed the warnings below!

* Autopilot to Saved Location:  Go to location you wish to mark.  In seat, hold shift and click Save Location.  When wishing to return to a saved point, use ALT-1/2 or SHIFT T/R till you see saved location.  If not on ground, be sure to be pointing in general direction to avoid yaw stall.  Hit Alt-4 to engage.  You may use yaw once brake landing begins to spin in place.  Saved locations may be deleted by selecting it as target and the holding shift and choosing Clear Position.  It is fairly accurate and you should arrive within 15m of marked location assuming good brakes (brake landing).  If you see Coast Landing, be prepared to take over the arrival.  If atmo radar installed, saved location will use nearest target for naming, otherwise will be named #.planet (i.e. 0.Alioth)

* AUTO-REENTRY: The default altitude is not suitable for Thades or other planets with strange altitudes; you must use alt+Space or alt+C to adjust it to an appropriate level.  Do not use auto-reentry into planets you haven't visited before or don't know the surface level of.  Do not attempt to use this on planets without atmosphere

* TURN & BURN: Turn & Burn Mode assumes your ship will be able to face the correct direction to burn before you must begin braking, and should be used with caution for short trips

* LANDING GEAR: When your gear is extended, your hover height is set to 0.  This helps with landings but don't attempt to put out your gear before you're hovering on the surface.  There is a warning if the gear is extended

* AUTOPILOT: Autopilot may be unstable for short range trips (<2SU or so), and will almost certainly send you through atmosphere if you're too close to the target

* AUTOPILOT: **Do not engage the autopilot if you do not have clear line of sight to the target!**  It cannot detect if there is a planet in the way.  It'll just go for it.

* AUTO-LAND: Auto-Landing should be used with supervision.  Autolanding utilizes your brakes and hovers to bring you to a safe landing.  It will not let you engage it if you are over mass for your brakes.

# Usage

The HUD uses a combination of on-screen buttons and keyboard controls.  Please refer to the sections below on how these are properly used.

## Hotkeys Reference

This is a quick reference for the functions.  See the detailed feature descriptions in the next section.

* UI OVERLAY (hold `SHIFT`) - Show the UI overlay with buttons.  Mouse over a button and let go of `SHIFT` to select it.  While holding `SHIFT`, press `R`/`T` (speedup/speeddown) to cycle between autopilot targets.
* FREE LOOK (`ALT`) - Toggles free-look.  Because of the way we had to use Keyboard mode, it can't re-center when you lock it back, but that can be desirable in some situations.  If you need to zoom out in 3rd person view, you must toggle free-look because the game will not recognize Shift when it's being used for the UI.
* AUTOPILOT DESTINATION (Option 1 and Option 2, `ALT-1` and `ALT-2`) - Cycle between destination planets for the autopilot. You may also use `SHIFT-R` and `SHIFT-T`, as described above.
* TOGGLE HUD (Option 3, `ALT-3`) - Toggles the primary hud display HUD on/off
* AUTOPILOT (Option 4, `ALT-4`) - Engages the autopilot if a destination is set and you are in space.
* TURN & BURN (Option 5, `ALT-5`) - Will use the main engines in addition to retro-rockets to perform braking when necessary.
* ALTITUDE HOLD (Option 6, `ALT-6`) - Toggle the altitude hold functionality.  Set hold height with `LALT-C` (down) and `LALT-SPACE` (up).  Disable
* SAVE/CLEAR SETTINGS (Option 7, `ALT-7`) - Save or clear the currently saved configuration settings.
* FOLLOW MODE (Option 8, `ALT-8`) - Engage follow mode if you are using Remote Control
* AUTO-BRAKE (Option 9, `ALT-9`) - Attempts to bring you to a stop.
    > WARNING - Unreliable because it is unable to align your trajectory, and tends to over-brake if it's not perfectly aligned.  Use Autopilot if you need auto-brake, so that it can align properly. 

## Features and Controls explanation

This HUD uses on-screen buttons, and so needs to be able to use your mouse.  The only way to keep DU from trying to use your mouse for input is to set the Control Scheme to Keyboard.  You can then right click the seat, *Advanced -> Edit LUA Parameters* and find the checkboxes to choose which control scheme you would actually like to use.

![ButtonHUD Example](/ButtonHUD_example_2.png)

The usual hotkeys apply, but it should be easier to use the new button system.  We will be converting this to work with screens and a Remote Controller once the screen flicker bug is fixed.  For now, many options are missing from the buttons since Remote Controllers must use the hotkeys

### UI Overlay
Hold `SHIFT` to show the UI overlay with buttons.  Mouse over a button and let go of `SHIFT` to select it.  

While holding `SHIFT`, press `R`/`T` (speedup/speeddown) to cycle between autopilot targets.

### Free Look
`ALT` is now a toggle for free-look.  Because of the way we had to use Keyboard mode, it can't re-center when you lock it back, but that can be desirable in some situations

If you need to zoom out in 3rd person view, you must toggle free-look because the game will not recognize Shift when it's being used for the UI

### Radar
**Radar** indicates below minimap number of targets or if it is jammed (atmo in space or space in atmo).  The radar widget only pops up if targets are detected.  The periscope widget only pops up if you click a target and successfully identify it.  All widgets close automagically.

### Destination Select
`ALT-1` and `ALT-2` (Option1 and Option2) **to scroll between target planets for Autopilot and display**.  This also works using `SHIFT-R` and `SHIFT-T` to scroll. This widget will not display if no planet is selected (ie you must press one of these hotkeys after entering the seat in order to show the widget)

### HUD Toggle
`ALT-3` toggles the **HUD** and other widgets off/on.  Orbital display and autopilot information will still show if hud is off.  There is a parameter you can set to have HUD and Widgets on at same time

### Autopilot
`ALT-4` to engage **Autopilot** for interplanetary travel, if you are in space and have a planet targeted.  Ensure you have a clear line of sight to the target.  This will align to the target, realign slightly to point 200km to the side of the target, accelerate, cut engines when at max, start braking when appropriate, and hopefully achieve a stable orbit around the target.  You can set your target orbit distance in parameters, default is 100km.  Recommend do not go less then 35km.

### Turn and Burn
`ALT-5` to toggle **Turn & Burn Mode**, which changes all your braking readouts to assume you will be turning and burning.  Be sure to set *warmup* in the Parameters if you use this; the default warmup is assumed to be 32s.  Autopilot will also turn and burn for you (Auto-Braking will not).  Note that Turn & Burn Mode assumes your ship will be able to face the correct direction to burn before you must begin braking, and should be used with caution for short trips.

### Altitude Hold  - MaxPitch affects all of the below, autotake off, landing, and re-entry.  Default value is 20 degrees.
`ALT-6` to toggle **Altitude Hold**.  If used while flying (with gear up), this will attempt to hold at the altitude you turned it on at and put you in cruise control at current speed.  You can modify target height with LALT+C (down) and LALT+spacebar (up).  Cruise speed is modifiied like normal.  Hitting ALT-6 again or tapping brake will take stop Alt-Hold mode but leave you in cruise control.
`ALT-6` while landed (with gear down) to turn on **Auto Takeoff** - this is simply Altitude Hold that sets you to a paramater-defined distance above your starting position (default 1km).  You must control your own thrust and release the brake to takeoff.
`G` (Gear) is a very loaded key.  While in atmosphere it will attempt to Brake Land if your brakes are strong enough (stop you and float to ground).  If not it will attempt to coast land (angle down till slow enough and within hover/vbooster height then land).  If in space it will initiate re-entry to a specific altitude (2500m by default) at a specific re-entry speed (1050km/hr default).  You may modify the target values via Edit LUA Parameters, or use alt-C and alt-spacebar to lower and raise target height, and mousewheel to change target cruise speed.

<<<<<<< HEAD
### Save/Clear Variables in Databank
`ALT-7` to **Wipe variables in a databank, you must press it a second time to confirm** - Hitting ALT-7 2x will wipe all data except saved locations from databank.  To wipe saved locations you must select them as a target and then use Clear button shown while holding shift.  Or you can pick up the databank, remove dynamic properties, and then put it back down, this clears everything from it.
=======
### Wipe Variables in Databank
`ALT-7` to **Wipe variables in a databank** - This will ask you to press it again to confirm, and then wipe all data on databank except for saved locations.
>>>>>>> Minify of Code, AGG addition, Save Changes

### Follow Mode
`ALT-8` will toggle **Follow Mode** when using a **Remote Controller**.  This makes your craft lift off and try to follow you wherever you go.  It will not go below ground unless you dig out a big enough hole that it would naturally go down while hovering.

### Toggle Gyro
`ALT-9` to engage **Toggle Gyro**.  If a gyro is installed on your ship, this will change your ships perceived orientation from Core to Gyro.  This is used to allow you to control flight based on gyro orientation and not core orientation. 

Auto-Brake is not on the UI this version; it is unreliable because it is unable to align your trajectory, and tends to over-brake if it's not perfectly aligned.  .

## Persistence

As mentioned briefly above, your custom variables are saved between reloading configurations if you attach a databank to the ship (and use Alt+7 to save them).  However, all variables in the program are saved in the databank when you exit the seat.  This means it will be exactly as you left it - if you were landed when you got out, it won't jump off the ground when you get it.  

This also means that when using autopilot, you can relatively easily move between a seat and Remote Controller; it will be down for a short time while you swap, but everything is saved and it will pick up where it left off.

# Customization
The following LUA parameters were added

*PrimaryR*, *PrimaryG*, *PrimaryB* - To set the primary color for the HUD

*warmup* - How long your engines take to warmup, or T50.  Defaults to 32.  For everything but freight engines, these values for space engines are: XS 0.25, S 1, M 4, L 16, XL 32.  If you're using freight engines, you should probably check https://hq.hyperion-corporation.de/ingame-engine-library

*userControlScheme* - This is how you define what control scheme you'd like to use - Keyboard, Mouse, or Virtual Joystick.  Hover your mouse over the name in the Parameter editor to see the exactly values you can enter.  Note that your in-game control scheme must be set to keyboard so that the buttons can be used, which is why you must set it here instead.

And many more for customization - Right click the seat and go to *Advanced -> Edit Lua Parameters* to see them all.  Mouse over a name to see its purpose and potential settings.

# Features List

**Rezoix HUD** (i.e. pitch/roll/yaw indicators), with LUA-parameter RGB values so you can set the base color, and with fixes (yaw is displayed in space properly instead of pitch, throttle indicator is fixed, gyro no longer required) - https://github.com/Rezoix/DU-hud

**Orbital Information widget** - Shows apoapsis, periapsis, apogee, perigee, eccentricity for the nearest planet, using these libraries: https://gitlab.com/JayleBreak/dualuniverse/-/tree/master/DUflightfiles/autoconf/custom

**Brake Indicator/Toggle** - Brake is now a toggle, and is on by default when entering the seat.  There is an onscreen text indicator to show you when the brake is on.  You can set brake to work like default with an Edit LUA Parameter setting.

**Interplanetary Helper** - Use Alt+1 and Alt+2 or SHIFT-R/SHIFT-T to cycle through target planets.  Shows distance, travel time (including acceleration, travel, and braking - absolute total), brake time (current and max).  Note that currently, Brake Time is inaccurate if you're inside atmosphere. Once you're in space, it will properly read the space brakes and give the correct values.  Shows max mass for your ship on planet at sea level based on brakes.  Note: If going to a planet with atmo, you must get the max mass reading while in atmo, and same if going to planet with no atmo.

**Auto-Brake** - Use Alt+9 when you have a target selected with the Interplanetary Helper, and it will toggle Auto-Brake.  The script will automatically engage the brake when within the max braking distance for that planet.  This does not guarantee that you will not hit the planet - even with Auto-Brake, do not aim directly at the planet.  It targets an end speed of 0, though you will generally have a much higher end speed, so has some leeway.  It will continue braking until stable orbit is achieved, if possible from the trajectory.

**AutoPilot** - Use Alt+4 when you have a target selected with the Interplanetary Helper, and you are in space with clear line of sight to the target.  The script will align to the optimal vector to place you in a 1SU orbit from the target, accelerate, cut engines when appropriate, and brake until orbit is achieved.  
> NOTE: As of right now, this will almost definitely get you to the safe zone of the planet without smashing into it.  It should achieve a stable orbit, but being there at the end of the trip is recommended. 

**Turn & Burn** - Use Alt+5 to toggle Turn & Burn mode, which changes all your readouts to assume you will turn and burn when braking, and sets autopilot to turn and burn for you.  

**Dodgin's Don't Die Rocket Governor** - Set your speed with cruise control and press B to have your rocket engines fire up to that speed and no faster

**Auto-Land on Gear Down** - Putting down your landing gear sets your hover height to 0, raising it sets it to max.  Entering a vehicle with gear down sets the height to 0, entering a vehicle with the gear up sets it to max

**Door/Ramp Automation** - Automatically closes doors/ramps when entering, and opens them when exiting.  Requires you to link these to the seat once, and it will remember and relink them each time you configure it afterward.  No renaming required.

**(ButtonHUD) Buttons and custom controls** - Custom implementations of virtual joystick and mouse controls, allowing you to use virtual joystick without that disgusting giant circle on your screen.  Buttons to use many of the features.

**Atmospheric Package** - Auto-Takeoff, Auto-Land, Altitude Hold, and for Remote Controllers, Follow Mode

**Fuel Tanks** - These are no longer automatically slotted to seat.  You still get fuel readouts under the minimap.  If you want the standard fuel widget, you will need to link the fuel tank(s) to the seat one time and then run the autoconfig.

### Credits

Rezoix and his HUD - https://github.com/Rezoix/DU-hud

JayleBreak and his orbital maths/atlas - https://gitlab.com/JayleBreak/dualuniverse/-/tree/master/DUflightfiles/autoconf/custom

Archeageo and his work on the HUD
