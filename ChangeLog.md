## ChangeLog - Most recent changes at the top

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
