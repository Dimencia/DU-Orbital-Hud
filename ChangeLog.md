## ChangeLog - Most recent changes at the top

Version 4.174
- Added DU version number in lower right hand corner of screen.

Version 4.173
- added displayOrbit user variable for those who do not want the KSP style orbit in upper corner.  Default true (to show)

Version 4.172
- Save autoroll preference when using Brake Landing
- Fix shifting to Cruise Control on autotakeoff.

Version 4.171 
- Added safety check to Brake landing.  If current mass * gravity at sea level > maxBrake power, it will not try an automatic Brake Landing.
- Added user variable for loss of altitude rate, brakeLandingRate, when using brake landing. Default is 30 m/s

Version 4.17 - Brake Landing
- While flying, if you have hover or vertical boosters, and you hit G, your ship will attempt to brake land.  If you are at max load of low altitude lift, or of brakes, do not use.  This does not replace hitting G for autoland while in altitude hold.  To brake land you must cancel altitude hold first.  As with most auto features, toggle brakes to turn off.

Version 4.162
- localized Nav.control.isRemoteControlled() function in unit.start and apTick 
- Only show Follow Mode button if on a Remote.  Alt-8 while on seat will give message only works when on remote.
- Hide autopilot engage button in atmo, give message if use alt-4 in atmo.
- Hide retrograde button if in atmo
- Shift to cruise control once reach takeoff altitude.

Version 4.161
- Updated new values to show n/a if out of gravity.

Version 4.16
- Ship now shows Required forward thrust for current mass at current gravity and Max Mass for max available forward thrust in current gravity.  Note this does not consider lift, just values if you pointed 90deg up.

Version 4.15
- Gyro's autoconnect again.  If you have a gyro on ship and run autoconf after it is placed, this will let you hit alt-9 the gyro will activate.  This can be used to change your controls perceived orientation from Core orientation to Gyro orientation.

Version 4.146
- Must press alt-7 2 times to wipe databank.  A wiped databank prevents saving of flight status variable.
- Attempt to fix calculation of fuelTankOptimization when setting up fuel tanks.

Version 4.145
- Fixed bugs with dimming, more elements are now undimmed when in freelook, dimmed elements are dimmer, artifical horizon is not displayed in freelook
- Fixed fuel display problem with remote control
- Readded brighthud

Version 4.144
- Track trip time and total run time on ship.

Version 4.143
- More optimization refactoring
- Fixed new DU bug with vertical engines firing constantly

Version 4.142
- More optimization refactoring from Chronos.

Version 4.141
- Fix for structural damage showing 99% when no voxels damaged.  Damage report only appears if any damage.

Version 4.14
- Updated damage report to show Structural Integrity (Voxel damage) and Element Integrity (Element damage). Element integrity still shows # of disabled and # of damaged elements.
Max Voxel integrity is set when you sit in the seat and autosaved if you have a databank attached.  To reset it you must perform normal save wipe (ALT-7) per Readme.

Version 4.13
- Added maxBrake to odometer
- Added maxThrust to odometer
- Modified mass to use function call, no need for extraMass anymore.

Version 4.126
- localized unit.getAtmosphereDensity

Version 4.125
- Added to user variables: brightHud = false --export: Enable to prevent hud dimming when in freelook.

Version 4.12
- Optimizations and fix save feature

Version 4.11
- Optimaztions with function localizations

Version 4.1 
- Major change in how html text is formatted, should result in improved performance but report any bugs.

Version 4.065
- Bug fixes.

Version 4.06
- added player variables speedChangeLarge and speedChangeSmall so you can control the rate of throttle change.  Large happens when you tap speed up or down, small happens when you hold speed up or down.
- doors and ramps will not auto open when exiting seat/remote while in space 

Version 4.05 - Odometers, Mass, and Rocket change
- Added a Trip and Lifetime odometer.  Note that trip resets if you get out of seat.  Lifetime doesnt reset unless you clear databank (and only saves with databank)
- Added Total Mass of ship, and a new user parameter extraMass because i cannot calculate honeycomb mass.  set extraMass to honeycomb mass as shown in Builder info
- Modified Rocket Engine performance.  In Cruise Mode it will fire till you reach cruise speed and then again to keep you at that speed till toggled off.  In Travel Mode it will fire continuous till you toggle it back off.

Version 4.04 - Cruise Control with Altitude Hold
- Modified alt-6 to turn on cruise control and altitude hold at same time.  Cruise speed set to current speed, altitude to current altitude.
- Use ALT-C and ALT-SPACE to change set altitude height.
- Hitting G while in altitude hold will start an autolanding like normal, but will also cancel cruise control for you.
-- Reverted 4.05 due to issues with AutoLand caused by fixing vertical engine problems

Version 4.03 More cleanups
- Cleaned  up code
- Removed vertical speed change if altitude is gone (200km)
- Cleaned up time displays and fuel location to account for planet name when in space.

Version 4.02
- Cleaned up comment lines to reduce code size.

Version 4.01
- Fixed time remaining when using multiple tanks.
- Fixed script limit issue where other players couldn't use the seat (and you had to reload it every time you relog)

Version 4.0 - More slots please  
(NOTE: This change means the default vanilla fuel widgets will no longer be shown unless you manually link fuel tanks to control chair/remote)
- Removed automatic slotting of all fuel tanks, freeing up slots for other items. Fuel percentages and time remaining are still shown.  The value for 100% will be the larger of vanilla volume or your current fuel volume when you get in the seat. 
- Added fuelTankOptimization = 0 For accurate fuel levels, set this to the fuel tank optimization level * 0.05 (so level 1 = 0.05, level 5 = 0.25) of the PERSON WHO PLACED the tank. This will be 0 for most people for now.

- Minor bugfix for when that DU bug starts your ship spinning, the ship should stop when you get out now

Version 3.97 -
- Moved functions back to unit.start

Version 3.96 -
- Changed altitude rate of change to meter vice just number
- Moved functions to system.start() that are not affected by a reset

Version 3.95 - I love merges
- Readded more things that got lost in the merge
- Fixed altitude
- Adjusted rate to be negative when toward the planet

Version 3.94 - Minor fixes
- Remerged some things that got lost from 3.93
- Adjusted vspeed to be in km/h like the rest of the readouts
- Radar checks moved to a less demanding timer

Version 3.93 - I honestly don't remember anymore
- Adjusted changing of altitude-hold (With Alt+C/Space while in Alt Hold or Takeoff) to be exponential to more easily altitude-hold to space
- Better smoothing for altitude hold
- Increased update rate of vertical speed and adjusted to use vector math
- Added galaxy map to Remote Controller buttons screen
- Lots of fixes for some of the buttons not enabling/disabling related programs
- IDK a lot of stuff I've been holding on to for a while

Version 3.92
- Radar periscope only opens when locked target
- Added toggle that supports having hud and widgets open at same time

Version 3.91
- Added constant damage check.  Shows Structural Integrity (percentage of total of max hit points of all elements versus current hit points) and the number of disabled or damaged elements.
- Added Radar: No Contacts message or total contacts shown under minimap above fuel status.

Version 3.90
- Initial Damage reporting in place, currently does a check of all elements hp's when you get in seat and reports as a percent

Version 3.88
- Moved fuel tank info under minimap

Version 3.87
- Renamed fuel tanks will display their name on the fuel status (up to 12 characters)

Version 3.86
- Added initial pass on rate of change of altitude
- Fixed locations of tank information

Version 3.85
- Added support for rocketfuel tanks
- Fuel Tank Name blinks if < 5% fuel or less than 2 min burn time left

Version 3.84
- Adjusted so keyboards have viewlock again so they can see the buttons.  Woops.

Version 3.83 - Fixed altitude not showing when in space.

Version 3.82 - 
- Adjusted so keyboards no longer have their view locked when pressing alt
- Fixed a potential issue that might have caused autopilot to abort before achieving orbit

Version 3.81 - Fixed BrakeToggle() error
- Was unrelated to brake, assigning a nil value to targetGroundAltitude

Version 3.80 - Cleanup
- Moved collectgarbage to end of unit.start
- Consolidated widgets into ToggleWidgets (still alt-3 to show/hide hud/widgets)

Version 3.799 - Minor Tweaks
- Tried changing a few miscellaneous things to try to find and address some users having script errors
- Fixed an issue with remembering variables during autopilot

Version 3.79 - What do you think
- Fixed an issue when brakeToggle was off
- Changed brake button on HUD to be a Brake Toggle On/Off button so you can change this on the fly

Version 3.78 - More fixes
- Fixed issues with the new buttons (that were unintentionally released early because other bugs were found)
- Added parameter to set your target hover height when retracting landing gear
- Added parameter to set your target throttle amount when engaging interplanetary autopilot
- Adjusted Autopilot behavior to no longer lock the throttle; it will set it once for each stage, and you can then change it as desired

Version 3.77 - TurnBurn and Brake bugfixes
- Fixed a problem where brake toggle wasn't being reliable
- Fixed TurnBurn calculations (hopefully)
- Removed buttons from Remote Controller again because they're just, not good like that.  Investigating other options.

Version 3.76 - Fixes and cleanups
- Fixed radar to only turn on if it senses someone

Version 3.75 - Fixes and requests
- Allowed altimeter to show negative values (make your submarine, but i think you'll blow up)
- Fixed altimeter to be same size as pitch bar (was blocking altitude and atmosphere)

Version 3.7 - Radar updates
- Modified hud to hide space radar in atmo and atmo radar in space.

Version 3.61 - Fix for braking values disappearing

Version 3.6 - Optimisation
- Resolved framerate issues entirely (excluding the tab-click-slideshow bug)
- Created persistent state; ship remembers how you left it when you exit and re-enter, or swap to a remote controller
- Resolved many problems with autotakeoff: You now control your speed and when to takeoff, and the ascent is much smoother
- Increased descent rate on autolanding to -10degrees
- Removed minor lines on meters (for FPS reasons), other minor HUD tweaks such as fonts
- Ability to adjust Hold Altitude with Alt+C and Alt+Space while in Altitude Hold mode
- Auto-landing will now cancel if you hit the brake while it's running, as will all Altitude Hold modes

Version 3.5 - Atmospheric Autopilot
- Added Altitude Hold, Auto Takeoff, Auto Landing modes
- Adjusted databank to no longer have to clear the entire bank
- Adjusted LAlt-3 to toggle between HUD and normal widgets on one key

Version 3.0 - Follow her to school one day!
- Added autofollow when on foot if using remote unit
- Added ability to hide hud and still have all other features available. LALT-3
- Moved AutoBrake to LAlt-9
- LALT-6 now shows or hides all normal widgets (not radar, weapons, or periscope)
- Added all variables shown in Advanced-Edit LUA Parameters to save values (25 now)

Version 2.07 - Hide Hude
- Added ability to not show (or calculate) hud but still use autopilot
- Added autoRoll and showHud to saved variables.

Version 2.06 - Follow Mode
- Added follow mode to allow a remote controller to call their ship to them

Version 2.05 - Remote Controller
- Updated HUD to recognize when a Remote Controller is used and move information out of the way

Version 2.04 - Altimeter
- Updated altimeter to not be so spastic by changing its scale.

Version 2.03 - Save work
- Updated saveable variables and ones that show in Edit LUA Parameters.  You will need to hit alt-7 to delete current and restave them

Version 2.02 - Player Feedback
- Added ability for messages to pop up on screen for limited time to provide user feedback.

Version 2.01 - Minor fixes
- Fixed padding problems with orbit map
- Fixed AutoBrake to use current brake instead of max brake

Version 2.0 - MAJOR change to code, please report any issues.
- Moved all system.start() code to unit.start()
- Made HUD update rate editable with apTickRate in Edit Lua Parameters
- Added apTickRate to save variables to keep track of user preferred tick rate
- Added PrimaryR, PrimaryG, PrimaryB to save to track preferred HUD color

Version 1.1
- Added fix for nil error when processing total fuel tanks
- Added ability to use default braking, plus added that to save variables.
