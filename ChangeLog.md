## ChangeLog - Most recent changes at the top

Version 4.76
- Slightly reduced multiple for Parachute Re-Entry initial speed when > 15000m
- Fixed AGG button showing wrong state action.
- Fix structural integrity 99% flashing, i hope.

Version 4.75
- Fine tuned emergency warp to not try if PLANET TOO CLOSE error condition. So - Must have Emergency Warp enabled, must not be too close to planet, must have a space radar contact within EmergercyWarpDistance, then it will try to warp if all other conditions met.
- Parachute Re-Entry now with more butt-clenching goodness.  Starts at higher speed based on initial height if > 20000m.  (Still ends up at Re-Entry speed when you hit atmo)

Version 4.74 - MAJOR fix to wings and aerilons - Upgrade strongly recommended
- It turns out that when we made the change to prevent vertical space engines firing randomly decaying orbits, we also removed Wing Engines.  This has been restored and you should see vastly improved performance from your lift surfaces, especially if you hit spacebar.  Ask Dimencia for more info.
- Changed warp widget to show up if a target is selected and it is more than 2 SU away.
- Added retrograde red dot to AH while in space.  Smaller dots.  Show prograde dot in atmo when going fast enough for it to matter.
- Added support for Fuel Tank Handling talen for unslotted fuel tank calculation.  Must use value of person who placed the tank, 1-5 for each type of tank.  This is in addition to Fuel Tank Optimization.  Unslotted fuel tank percentage will closely match slotted if values of Handling and Optimization are correct.
- Fixed Elemental Damage sometimes reporting 99% when fully healed and no damaged componet total listed.
- Moved throttle, default position, to right side of AH to make room for Roll value.  Added throttle position x and y user parameters.
- Updated formattime to show days and hours, or hours and min, or min and sec, or sec
- Fixed issue with ships that had landing gear but no longer have it but databank still thought they did.

Version 4.73 - Atmosphere Rocket Engine assist
- Changed landed ground target height to user variable instead of 0 if landing gear used.  Set to hover height reported - 1 when you use alt-spacebar to just lift off ground from landed postion.  4 is M size landing gear, not countersunk, on bottom of ship.  14 appears to be Large landing gear setting.
- Restored Glide Re-Entry as option to Parachute Re-Entry.  Still will not work well for some ships.
- Enhanced AGG when toggling on after already in use so it reacts faster.
- Altimeter support for negative altitude, turns red when < 0 m and counts up as you go down
- Added atmospheric rocket engine assist, code provided by Azraeil.  Lets rockets assist in atmosphere while in throttle mode without firing constantly and wasting fuel, same as with cruise control already.  Rocket will toggle off automatically when at 85% of target speed as determined by either throttle setting * max speed in atmo (1050) or MaxGameVelocity parameter.  In cruise control mode it will toggle at 85% of desired cruise speed.
- Added notification if Rockets are on down bottom.

Version 4.72 - Variable Updates
- IMPORTANT: Databank Wipe is advised. (You will not lose saved locations)
- Proper formatting of local and global variables for consistency.  
- Fixed databank wipe to not wipe saved locations.
- Autopilot locations now in alphabetical order.
- Changed new save locations to be named as PlanetName.# or PlanetName.# "Nearest Atmo Contact" to work with new sorting.
- Reordered button locations to clean up around some that show conditionally.

Version 4.71 - Bug Fixes
- Fixed Interplanetary display updating with change from custom to planet and atmo to space (again)
- Changed upper Warning Messages to not be hidden when Buttons shown
- Fixed script error when using button to cancel Parachute Re-Entry
- Added planet.atmos = true/false and planet.gravity = X.XX (in g) to Atlas for calculations about planets when not there.
- Changed Strongbrakes to StrongBrakes = ((planet.gravity * 9.80665 * core.getConstructMass()) < LastMaxBrake)
- Fixed Landing Gear sensing and operation
- Fixed emergency warp to cancel if Emergency Warp mode toggled off or cancellation key is pressed.
- Fixed hover engines performing brake landing.

Version 4.70 - Updates And Bug Fixes
- Changed Glide Re-Entry to Parachute Re-Entry.  Recommend brown pants.  Do NOT use if you have not performed a Brake Landing in Atmosphere
- Fixed Interplanetary display when shifting atmo to space and custom to target
- removed currentGroundAltitudeStabilization undefined variable
- fuelX and fuelY user positions provided, sets fuel tank text location, (default 100, 350) setting both to 0 turns off fuel tank text display. 
- removed seconds from formattime strings to clean up displays
- changed fueltankoptimization value from 20% per level to 5% per level to reflect actual skill effect (affects unslotted tank amounts only)
- Fixed re-entry button not being able to initiate re-entry
- Fixed issue with AGG Button display and with Repair Arrow button location.

Version 4.693 - Bugfix
- Fixed Saving of Variables
- Removed final references to AutoBrake

Version 4.692 - Bugfix
- Repair arrows should now work for all size cores
- Restored Navbal (Artifical Horizon) to center by default.  Use centerX=700 and centerY=980 for lower left placement.

Version 4.691 - Bugfix
- Fixed bug causing hovers to not fire when not using a landing mode
- Synchronized AH to ticker

Version 4.69 - Cleaning up Local-Global declaration
- Added support for BrightHUD toggle to prevent AH vanishing if toggled on
- Modified Reentry button to engage re-entry vice needing to press G after button.\
- Added E-Warp Engaged message to remind you if it is on

Version 4.68 - Clean up release conf generation
- Update Readme
- Fix version to be pulled from .conf
- Fixes all remaining warnings using vscode

Version 4.67
- Changed interpretation of Autopilot Throttle rate
- Made interplaneterary panel update itself 10 times faster
- Added variables for user to move vSpeed Meter, and Altimter/Speed indication

Version 4.63 - Cleared a lot of unused and misnamed variables.

Version 4.62 - HUD Redesign continued, KSP navball
- The Artificial Horizon is more of a KSP Navball now.  You may put it anywhere with centerX and centerY setting (use 1920x1080, it will scale).  circleRad must either be 0 (off) or 100 right now. Resizing coming.
- Added prograde dot to AH
- Moved most HUD items out of center for cleaner view
- No functionality has been lost.  Just cleaned up the HUD and made the Artifical Horzion much more dynamic.

Version 4.61 - HUD Redesign - Update the hud to be more minimalist yet still provide all the information, shooting for a more KSP Navball
- Moved placement of data to support new AH view
- Replaced altimeter tape with rolling number altimeter
- Replaced roll tape with rolling ticks on artificial horizon
- Replaced pitch tape with pitch lines on artificial horizon
- Moved fuel tank information from right side to left to avoid widget overwrite.
- Fixed Orbit being displayed when stationary (plantets dont rotate here)
- Fix AGG script error when setting value lower via holding alt-c

Version 4.60

- Added AGG support.  Engage AGG > 1000m with ALT-G or Button.  Use alt-c and alt-space to change AGG target height.  NOTE:  turning on brake does not cancel agg for obvious reasons.  You must toggle it off to cancel.
- Updated Save mechanics. Please READ the SAVE section of the README
- Changed emergency warp retry to every second if enabled
- fixed autoroll setting issue
- Brake Toggle or Default mode user variable restored to remember setting
- Testing braking after emergency warp and re-engage of autopilo

Version 4.58
- Change Emergency Warp to retry every 30 seconds if enabled.

Version 4.57
- Glide ReEntry is on a Button now.  Default is off.  If enabled, hitting G will attempt to put you into a glide reentry to ReentryAltitude at ReentrySpeed (2500m and 1050km/hr default, user settable)

Version 4.56
- Damaged components indicated by arrows while in Remote mode.  Allows you to walk around and repair being shown where next one is located.  Toggled on by Button while in remote mode (hold shift to see buttons)
- Removed EmergencyWarp as a user variable. Now toggled by a Button.  Default is off.  If you toggle it on, then when conditions met, EmergencyWarp.  EmergencyWarpRange remains a user variable.
- Removed BrakeToggle as a user variable.  Now toggled by a Button.  Default is Toggle Brakes.  Toggle to enable vanilla Brakes.
- Removed DisplayOrbit as a user variable.  Now toggled by a Button.  Default is on.

Version 4.555
- Fix Cruise text to not be huge.

Version 4.55
- Transponder IFF.  If any radar contacts have a matching transponder tag, they are listed at the top of the screen

Version 4.54
- Emergency Warp support. Set EmergencyWarp to true (default false).  Set EmergencyWarpRange to distance (default 320000 km, farthest default large ship lock range with large radar).  If you have a radar, and a warp engine, and if a target gets within EmergencyWarpRange and all other conditions to warp are met, EmergencyWarp to target will activate.  If it fails to activate, it will not retry.  You can hit ALT-J to stop it within 5 seconds.  NOTE: You can set EmergencyWarp to true and intentionally not put cells in its container and use it as a warning when someone gets within EmergencyWarpRange
- Restored structural integrity (voxel damage).  HUD assumes when you sit down your voxels are at 100% and reports any damage.  Element damage report unchanged.
- Added check for databank before allowing save of locations
- Fixed display of integrity reports.
- Added LastMaxBrake to saved variables to have initial brake value before brakes used if databank used.
- Fixed interplanetary values display when normal planet shown after a local save location.

Version 4.53
- Fixed HUD Color preference not loading from databank properly.

Version 4.52
- Removed structural integrity - too unreliable at this time.  Elemental Intregrity remains.
- Added current acceleration in g's.  Changed gravity reading to g. Currently these are based on 1g earth normal.
- Moved acceleration, gravity, and atmosphere updates to once per second.

Version 4.51 
- Fix for display errors that might have caused control issues.
- Coast Landing will only display if moving at high speed when using gear

Version 4.5 - Autopilot to saved location in atmosphere
- Minified conf file to avoid overflow script limit.  Added a readable version for editing/understanding.
- Initial Pass: Autopilot to a presaved waypoint in atmosphere.  Use: Go to location you wish to mark.  In seat, hold shift and click Save Location.  When wishing to return to a saved point, use ALT-1/2 or SHIFT T/R till you see saved location.  If not on ground, be sure to be pointing in general direction to avoid yaw stall.  Hit Alt-4 to engage.  You may use yaw once brake landing begins to spin in place.  Saved locations may be deleted by selecting it as target and the holding shift and choosing Clear Position.  It is fairly accurate and you should arrive within 15m of marked location assuming good brakes (brake landing).  If you see Coast Landing, be prepared to take over the arrival.  If atmo radar installed, saved location will use nearest target for naming, otherwise will be named #.planet (i.e. 0.Alioth)

Version 4.37
- Fixed damaged display to be visable and color shaded by % damage.

Version 4.36
- Pulled fuel tank fixes
- Pulled mass calculation fixes

Version 4.35
- Initial Warpdrive support.  Warp Widget hidden by default.  Warp Hotkey (default Alt-J) will toggle the widget on if off, off if on, and initiate Warp Jump if conditions met or give message if not.  Widget will autoshow if conditions met to jump.

Version 4.34
- Moved Interplanetary Widget info to slower update (once per second) to save on performance.

Version 4.33
- Fixed throttle arrow to always stay in range for positive and negative throttle.  Throttle color changes to red if in reverse.  Bar removed if in cruise.
- Fixed alt key not to toggle freelook if using alt+# option.  Tapping alt will toggle freelook like normal.

Version 4.32
- Fixed new bug preventing Reentry from occurring

Version 4.31 - Bugfixes and Performance
- On a planet with no atmo, re-rentry will no longer engage if below the designated reentry height (pressing G will enage brake-landing instead)
- Attempt to resolve recent issues - forced garbage collection every second, moved screen drawing to Update instead of on a fixed tick

Version 4.3 - Now with re-entry
- Hitting G while over a planet will attempt to do reentry to a designated altitude hold (default 2500m) at a designated max speed (default 1050km/hr) to avoid re-entry burnup.  ReentrySpeed is user value for speed, ReentryAltitude for height.
- interpret linebreaks for msgText

Version 4.22
- Added MaxPitch as user variable, default value 20 degrees.  Sets max pitch autopilot will use during takeoff and altitude changes while in altitude hold or for re-entry.
- Fixed text display on Orbit panel

Version 4.21 
- Updated non-widget fuel tank display to use slotted tank values (more accurate) for slotted tanks.
- Updated G key to always brake land if gear is up and within capacity of brakes.  Otherwise gear down and manual landing required.

Version 4.2
- Refactored display to more pure CSS for smaller filesize and more efficient frames
- Show Orbit display only if speeds are within max speed and if periapsis and apoapsis exist.
- Modified all automated landings to use brake landing.  This is much safer than the previous autoland, but use under supervision.  Hit G to initiate landing any time.

Version 4.181
- Fixed script error
- Fixed a minor inaccuracy in brake time calculation

Version 4.18
- Added max mass on target planet to Interplanetary info.  Note:  If target planet has atmo, you must be in atmo to get an accurate reading.  The formula is MaxBrakeNewtons / PlanetGravityAtSeaLevel, shown in tons.  So if you are going to a planet with no atmosphere, you must get a reading while in no atmosphere.

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
