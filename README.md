## DU-Orbital-Hud

![Example](/ButtonHUD_example_1.png)

https://www.twitch.tv/videos/748340916 - Demonstration of Use and Features

Dual Universe HUD, custom control scheme, and autopilot with orbital information, braking distances, and Rezoix's pitch/roll hud with some fixes and major adjustments.  Includes a virtual joystick implementation that doesn't have the giant white circle around it.

Option to hide the widget displaying speed, since all important information from that widget is displayed on the HUD

Works with Command Seat and Hover Seat, not Cockpit

If you wish to save your current config, right click your seat and Copy Lua Configuration to Clipboard, and save it somewhere

### Donations are accepted!  We have a Donation Station in Sanctuary District 3 and more to come, or you can always contact us and do a VR trade.  
Basically I keep running into problems where I can't afford the cool stuff I want to play with next because I spent all my time writing stuff.  You saw what happened when I finally got a remote controller.  So, a few people were asking, and I figured why not offer.  And of course, Arche gets a cut too.

Just make sure that for any Donation Station you see, that the owner is Dimencia or Archaegeo.  I fully expect to see fake ones out there.

## Version Information

Check the changelog file for information about the most recent changes.  This is updated very frequently.

# Usage
Click on **buttonHUD.conf** above.  The Button HUD is the latest and most recent version but comes with a few caveats (read below).  On the top right, right click the 'RAW' button and click Save Link As...

Save the file to *%ProgramData%\Dual Universe\Game\data\lua\autoconf\custom*, the filename does not matter (as long as it's still .conf)


In-game, right click your seat and go to *Advanced -> Update custom autoconf list*  - If you get a YAML error, you did not follow the above directions corretly.

Then *Advanced -> Run Custom Autoconfigure -> ButtonsHud - Dimencia and Archaegeo*

By default the HUD overwrites the in game flight Control Schemes.  You must right click the seat and set the control scheme to Keyboard.  Then look at the seat and choose Advanced-Edit LUA Parameters.  Mouse over each for a description, but the major one is userControlScheme.  You may set it to "Virtual Joystick" (which is the default), "Mouse", or "Keyboard".

This should set everything up and you're good to go

You may manually connect doors or forcefields to the seat and it will remember them each time you configure it, and automatically open them when exiting the seat and close them when entering.  If the ship contains a databank, it will be connected to the seat for use with storing variables (but it will never truly clear a databank, so you can use the databank for other things as well)

# Warnings

Turn & Burn Mode assumes your ship will be able to face the correct direction to burn before you must begin braking, and should be used with caution for short trips

### When your gear is extended, your hover height is set to 0.  This helps with landings but don't attempt to put out your gear before you're hovering on the surface.  There is a warning if the gear is extended

## Autopilot may be unstable for short range trips (<2SU or so), and will almost certainly send you through atmosphere if you're too close to the target

## Do not engage the autopilot if you do not have clear line of sight to the target

It cannot detect if there is a planet in the way.  It'll just go for it.

# Auto-Landing should be used with supervision.  It cannot detect mountains or cliffs in the way, and if you try to auto-takeoff from the thades scar, don't blame me

## Button Info
This HUD uses on-screen buttons, and so needs to be able to use your mouse.  The only way to keep DU from trying to use your mouse for input is to set the Control Scheme to Keyboard.  You can then right click the seat, *Advanced -> Edit LUA Parameters* and find the checkboxes to choose which control scheme you would actually like to use.

![ButtonHUD Example](/ButtonHUD_example_2.png)

The usual hotkeys apply, but it should be easier to use the new button system.  We will be converting this to work with screens and a Remote Controller once the screen flicker bug is fixed.  For now, many options are missing from the buttons since Remote Controllers must use the hotkeys

Hold **Shift** to show the UI overlay with buttons.  Mouse over a button and let go of Shift to select it.  

While holding Shift, press **R/T** (speedup/speeddown) to cycle between autopilot targets.

Auto-Brake is not on the UI this version; it is unreliable because it is unable to align your trajectory, and tends to over-brake if it's not perfectly aligned.  Use Autopilot if you need auto-brake, so that it can align properly.  Auto-brake is still accessible on **Alt+3** if you want it.

**Alt** is now a toggle for free-look.  Because of the way we had to use Keyboard mode, it can't re-center when you lock it back, but that can be desirable in some situations

If you need to zoom out in 3rd person view, you must toggle free-look because the game will not recognize Shift when it's being used for the UI

**Turn & Burn Mode** is still accessible with **Alt+5** (will be added to UI soon)

## Controls - MINHUD and Archeageo HUD
**Alt+1** and **Alt+2** (Option1 and Option2) **to scroll between target planets for Autopilot and display**.  This widget will not display if no planet is selected (ie you must press one of these hotkeys after entering the seat in order to show the widget)

**Alt+3 ** toggles the **HUD** and other widgets off/on.  Orbital display and autopilot information will still show if hud is off.

**Alt+4** to engage **Autopilot** for interplanetary travel, if you are in space and have a planet targeted with Alt+1/Alt+2.  Ensure you have a clear line of sight to the target.  This will align to the target, realign slightly to point 200km to the side of the target, accelerate, cut engines when at max, start braking when appropriate, and hopefully achieve a stable orbit around the target.

**Alt+5** to toggle **Turn & Burn Mode**, which changes all your braking readouts to assume you will be turning and burning.  Be sure to set *warmup* in the Parameters if you use this; the default warmup is assumed to be 32s.  Autopilot will also turn and burn for you (Auto-Braking will not).  Note that Turn & Burn Mode assumes your ship will be able to face the correct direction to burn before you must begin braking, and should be used with caution for short trips

**Alt+6** to toggle **Altitude Hold**.  If used while flying (with gear up), this will attempt to hold at the altitude you turned it on at.  
**Alt+6** while landed (with gear down) to turn on **Auto Takeoff** - this is simply Altitude Hold that sets you to a paramater-defined distance above your starting position (default 1km).  You must control your own thrust and release the brake to takeoff.
**Gear** while in Altitude Hold mode will turn on **Auto Landing**.  This is very slow in an attempt to be safe; it pitches down at 5 degrees, cuts throttle, and waits until your vertical boosters or hover engines power on before pitching up and hitting the brake.  This will not trigger if it does not auto-detect a hover engine or vertical booster
**Alt+C,Alt+Space** while in Altitude Hold to change the Holding Altitude (these hotkeys will not affect your hovers/vboosters while in Altitude Hold)

**Alt+7** to **Save/clear variables in a databank** - To use:  Attach a databank to your ship in any location.  Rerun the HUD Autoconfig. Change any variables using Edit LUA Paremeters. Get in seat.  Hit ALT-7 to save.  These will now autoload anytime you get in seat.  To overwrite you must hit alt-7 to wipe the databank, then get out, rerun Autoconfig, then change the values with Edit LUA Parameters, get back in, and alt-7 to save the new values.  

**Alt+8** will toggle **Follow Mode** with a **Remote Controller**.  This makes your craft lift off and try to follow you wherever you go.

**Alt+9** to engage **Auto-Brake**.  This will simply engage the brake if you come within the max braking distance of the planet targeted with Alt+1 and Alt+2, and disengage it once it's gotten as close to an orbit as it can just by braking.  This is an alternative to auto-pilot if you don't want to give the autopilot control over where your ship is facing or thrusters


## Persistence

As mentioned briefly above, your custom variables are saved between reloading configurations if you attach a databank to the ship (and use Alt+7 to save them).  However, all variables in the program are saved in the databank when you exit the seat.  This means it will be exactly as you left it - if you were landed when you got out, it won't jump off the ground when you get it.  

This also means that when using autopilot, you can relatively easily move between a seat and Remote Controller; it will be down for a short time while you swap, but everything is saved and it will pick up where it left off.


## Customization
The following LUA parameters were added

*PrimaryR*, *PrimaryG*, *PrimaryB* - To set the primary color for the HUD

*warmup* - How long your engines take to warmup, or T50.  Defaults to 32.  For everything but freight engines, these values for space engines are: XS 0.25, S 1, M 4, L 16, XL 32.  If you're using freight engines, you should probably check https://hq.hyperion-corporation.de/ingame-engine-library

*userControlScheme* - This is how you define what control scheme you'd like to use - Keyboard, Mouse, or Virtual Joystick.  Hover your mouse over the name in the Parameter editor to see the exactly values you can enter.  Note that your in-game control scheme must be set to keyboard so that the buttons can be used, which is why you must set it here instead.

And many more for customization - Right click the seat and go to *Advanced -> Edit Lua Parameters* to see them all

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

**Door/Ramp Automation** - Automatically closes doors/ramps when entering, and opens them when exiting.  Requires you to link these to the seat once, and it will remember and relink them each time you configure it afterward.  No renaming required.

**(ButtonHUD) Buttons and custom controls** - Custom implementations of virtual joystick and mouse controls, allowing you to use virtual joystick without that disgusting giant circle on your screen.  Buttons to use many of the features.

**Atmospheric Package** - Auto-Takeoff, Auto-Land, Altitude Hold, and for Remote Controllers, Follow Mode

### Credits

Rezoix and his HUD - https://github.com/Rezoix/DU-hud

JayleBreak and his orbital maths/atlas - https://gitlab.com/JayleBreak/dualuniverse/-/tree/master/DUflightfiles/autoconf/custom

Archeageo and his work on the HUD
