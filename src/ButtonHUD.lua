require 'src.slots'
-- Script is laid out variables, functions, control, control (the Hud proper) starts around line 4000
Nav = Navigator.new(system, core, unit)

script = {}  -- wrappable container for all the code. Different than normal DU Lua in that things are not seperated out.

-- Edit LUA Variable user settings.  Must be global to work with databank system as set up due to using _G assignment
useTheseSettings = false -- export: (Default: false) Toggle on to use the below preferences.  Toggle off to use saved preferences.  Preferences will save regardless when exiting seat. 
freeLookToggle = true -- export: (Default: true)
BrakeToggleDefault = true -- export: (Default: true)
RemoteFreeze = false -- export: (Default: false)
RemoteHud = false -- export: (Default: false)
brightHud = false -- export: (Default: false)
VanillaRockets = false -- export: (Default: false)
InvertMouse = false -- export: (Default: false)
userControlScheme = "virtual joystick" -- export: (Default: "virtual joystick") Set to "virtual joystick", "mouse", or "keyboard"
ResolutionX = 1920 -- export: (Default: 1920)
ResolutionY = 1080 -- export: (Default: 1080) 
SafeR = 130 -- export: (Default: 130)
SafeG = 224 -- export: (Default: 224)
SafeB = 255 -- export: (Default: 255)
PvPR = 255 -- export: (Default: 255)
PvPG = 0 -- export: (Default: 0)
PvPB = 0 -- export: (Default: 0)
centerX = 960 -- export: (Default: 960)
centerY = 540 -- export: (Default: 540)
throtPosX = 1300 -- export: (Default: 1300)
throtPosY = 540 -- export: (Default: 540)
vSpdMeterX = 1525  -- export: (Default: 1525)
vSpdMeterY = 325 -- export: (Default: 325)
altMeterX = 550  -- export: (Default: 550)
altMeterY = 540 -- export: (Default: 540) 
fuelX = 100 -- export: (Default: 100)
fuelY = 350 -- export: (Default: 350)
circleRad = 400 -- export: (Default: 400)
DeadZone = 50 -- export: (Default: 50)
DisplayOrbit = true -- export: (Default: true) 
OrbitMapSize = 250 -- export: (Default: 250)
OrbitMapX = 75 -- export: (Default: 75)
OrbitMapY = 0 -- export: (Default: 0)
showHud = true -- export: (Default: true) 
ShowOdometer = true -- export: (Default: true)
hideHudOnToggleWidgets = true -- export: (Default: true)
ShiftShowsRemoteButtons = true -- export: (Default: true)
YawStallAngle = 35 --export: (Default: 35)
PitchStallAngle = 35 --export: (Default: 35)
speedChangeLarge = 5 -- export: (Default: 5)
speedChangeSmall = 1 -- export: (Default: 1)
brakeLandingRate = 30 -- export: (Default: 30)
MaxPitch = 30 -- export: (Default: 30)
ReentrySpeed = 1050 -- export: (Default: 1050)
AtmoSpeedLimit = 1050 -- export: (Default: 1050)
SpaceSpeedLimit = 30000 -- export: (Default: 30000).
ReentryAltitude = 2500 -- export: (Default: 2500)
AutoTakeoffAltitude = 1000 -- export: (Default: 1000)
TargetHoverHeight = 50 -- export: (Default: 50)
LandingGearGroundHeight = 0 --export: (Default: 0)
MaxGameVelocity = 8333.00 -- export: (Default: 8333.00)
TargetOrbitRadius = 1.4 -- export: (Default: 1.4)
AutopilotInterplanetaryThrottle = 1.0 -- export: (Default: 1.0)
warmup = 32 -- export: (Default: 32)
MouseYSensitivity = 0.003 --export: (Default: 0.003)
MouseXSensitivity = 0.003 -- export: (Default: 0.003)
autoRollPreference = false -- export: (Default: false)
autoRollFactor = 2 -- export: (Default: 2)
rollSpeedFactor = 1.5 -- export: (Default: 1.5)
turnAssist = true -- export: (Default: true)
turnAssistFactor = 2 -- export: (Default: 2)
TrajectoryAlignmentStrength = 0.002 -- export: (Default: 0.002)
torqueFactor = 2 -- export: (Default: 2)
pitchSpeedFactor = 0.8 -- export: (Default: 0.8)
yawSpeedFactor = 1 -- export: (Default: 1)
brakeSpeedFactor = 3 -- export: (Default: 3)
brakeFlatFactor = 1 -- export: (Default: 1)
DampingMultiplier = 40 -- export: (Default: 40) 
fuelTankHandlingAtmo = 0 -- export: (Default: 0)
fuelTankHandlingSpace = 0 -- export: (Default: 0)
fuelTankHandlingRocket = 0 -- export: (Default: 0)
ContainerOptimization = 0 -- export: (Default: 0)
FuelTankOptimization = 0 -- export: (Default: 0)
ExtraLongitudeTags = "none" -- export: (Default: "none")
ExtraLateralTags = "none" -- export: (Default: "none")
ExtraVerticalTags = "none" -- export: (Default: "none")
ExternalAGG = false -- export: (Default: false)
UseSatNav = false -- export: (Default: false)
apTickRate = 0.0166667 -- export: (Default: 0.0166667)  
hudTickRate = 0.0666667 -- export: (Default: 0.0666667)
ShouldCheckDamage = true --export: (Default: true)
CalculateBrakeLandingSpeed = false --export: (Default: false)
autoRollRollThreshold = 0 --export: (Default: 0)
AtmoSpeedAssist = true --export: (Default: true)
ForceAlignment = false --export: (Default: false)
minRollVelocity = 150 --export: (Default: 150)
VertTakeOffEngine = false --export: (Default: false)
DisplayDeadZone = true -- export: (Default: true)

-- Auto Variable declarations that store status of ship. Must be global because they get saved/read to Databank due to using _G assignment
BrakeToggleStatus = BrakeToggleDefault
BrakeIsOn = false
RetrogradeIsOn = false
ProgradeIsOn = false
Autopilot = false
TurnBurn = false
AltitudeHold = false
BrakeLanding = false
AutoTakeoff = false
Reentry = false
VertTakeOff = false
HoldAltitude = 1000 -- In case something goes wrong, give this a decent start value
AutopilotAccelerating = false
AutopilotRealigned = false
AutopilotBraking = false
AutopilotCruising = false
AutopilotEndSpeed = 0
AutopilotStatus = "Aligning"
AutopilotPlanetGravity = 0
PrevViewLock = 1
AutopilotTargetName = "None"
AutopilotTargetCoords = nil
AutopilotTargetIndex = 0
GearExtended = nil
TotalDistanceTravelled = 0.0
TotalFlightTime = 0
SavedLocations = {}
VectorToTarget = false    
LocationIndex = 0
LastMaxBrake = 0
LockPitch = nil
LastMaxBrakeInAtmo = 0
AntigravTargetAltitude = core.getAltitude()
LastStartTime = 0
SpaceTarget = false
LeftAmount = 0
IntoOrbit = false


-- VARIABLES TO BE SAVED GO HERE, SAVEABLE are Edit LUA Parameter settable, AUTO are ship status saves that occur over get up and sit down.
local saveableVariables = {"userControlScheme", "TargetOrbitRadius", "apTickRate", "freeLookToggle", "turnAssist",
                        "SafeR", "SafeG", "SafeB", "warmup", "DeadZone", "circleRad", "MouseXSensitivity",
                        "MouseYSensitivity", "MaxGameVelocity", "showHud", "autoRollPreference", "InvertMouse",
                        "pitchSpeedFactor", "yawSpeedFactor", "rollSpeedFactor", "brakeSpeedFactor",
                        "brakeFlatFactor", "autoRollFactor", "turnAssistFactor", "torqueFactor",
                        "AutoTakeoffAltitude", "TargetHoverHeight", "AutopilotInterplanetaryThrottle",
                        "hideHudOnToggleWidgets", "DampingMultiplier", "fuelTankHandlingAtmo", "ExternalAGG", "ShouldCheckDamage",
                        "fuelTankHandlingSpace", "fuelTankHandlingRocket", "RemoteFreeze", "hudTickRate",
                        "speedChangeLarge", "speedChangeSmall", "brightHud", "brakeLandingRate", "MaxPitch",
                        "ReentrySpeed", "AtmoSpeedLimit", "ReentryAltitude", "centerX", "centerY", "SpaceSpeedLimit", "AtmoSpeedAssist",
                        "vSpdMeterX", "vSpdMeterY", "altMeterX", "altMeterY", "fuelX","fuelY", "LandingGearGroundHeight", "TrajectoryAlignmentStrength",
                        "RemoteHud", "YawStallAngle", "PitchStallAngle", "ResolutionX", "ResolutionY", "UseSatNav", "FuelTankOptimization", "ContainerOptimization",
                        "ExtraLongitudeTags", "ExtraLateralTags", "ExtraVerticalTags", "OrbitMapSize", "OrbitMapX", "OrbitMapY", "DisplayOrbit", "CalculateBrakeLandingSpeed",
                        "ForceAlignment", "autoRollRollThreshold", "minRollVelocity", "VertTakeOffEngine", "PvPR", "PvPG", "PvPB", "DisplayDeadZone"}

local autoVariables = {"SpaceTarget","BrakeToggleStatus", "BrakeIsOn", "RetrogradeIsOn", "ProgradeIsOn",
                    "Autopilot", "TurnBurn", "AltitudeHold", "BrakeLanding",
                    "Reentry", "AutoTakeoff", "HoldAltitude", "AutopilotAccelerating", "AutopilotBraking",
                    "AutopilotCruising", "AutopilotRealigned", "AutopilotEndSpeed", "AutopilotStatus",
                    "AutopilotPlanetGravity", "PrevViewLock", "AutopilotTargetName", "AutopilotTargetCoords",
                    "AutopilotTargetIndex", "TotalDistanceTravelled",
                    "TotalFlightTime", "SavedLocations", "VectorToTarget", "LocationIndex", "LastMaxBrake", 
                    "LockPitch", "LastMaxBrakeInAtmo", "AntigravTargetAltitude", "LastStartTime"}


-- function localizations for improved performance when used frequently or in loops.
local sprint = system.print
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
local atan = math.atan

function round(num, numDecimalPlaces)
    local mult = 10 ^ (numDecimalPlaces or 0)
    return mfloor(num * mult + 0.5) / mult
end

-- Variables that we declare local outside script because they will be treated as global but get local effectiveness
local PrimaryR = SafeR
local PrimaryB = SafeB
local PrimaryG = SafeG
local pvpZone = false
local pvpDist = 0
local pvpName = ""
local PlayerThrottle = 0
local brakeInput2 = 0
        Nav=Navigator.new(system,core,unit)script={}BrakeToggleStatus=BrakeToggleDefault;BrakeIsOn=false;RetrogradeIsOn=false;ProgradeIsOn=false;Autopilot=false;TurnBurn=false;AltitudeHold=false;BrakeLanding=false;AutoTakeoff=false;Reentry=false;VertTakeOff=false;HoldAltitude=1000;AutopilotAccelerating=false;AutopilotRealigned=false;AutopilotBraking=false;AutopilotCruising=false;AutopilotEndSpeed=0;AutopilotStatus="Aligning"AutopilotPlanetGravity=0;PrevViewLock=1;AutopilotTargetName="None"AutopilotTargetCoords=nil;AutopilotTargetIndex=0;GearExtended=nil;TotalDistanceTravelled=0.0;TotalFlightTime=0;SavedLocations={}VectorToTarget=false;LocationIndex=0;LastMaxBrake=0;LockPitch=nil;LastMaxBrakeInAtmo=0;AntigravTargetAltitude=core.getAltitude()LastStartTime=0;SpaceTarget=false;LeftAmount=0;IntoOrbit=false;local a={"userControlScheme","TargetOrbitRadius","apTickRate","freeLookToggle","turnAssist","SafeR","SafeG","SafeB","warmup","DeadZone","circleRad","MouseXSensitivity","MouseYSensitivity","MaxGameVelocity","showHud","autoRollPreference","InvertMouse","pitchSpeedFactor","yawSpeedFactor","rollSpeedFactor","brakeSpeedFactor","brakeFlatFactor","autoRollFactor","turnAssistFactor","torqueFactor","AutoTakeoffAltitude","TargetHoverHeight","AutopilotInterplanetaryThrottle","hideHudOnToggleWidgets","DampingMultiplier","fuelTankHandlingAtmo","ExternalAGG","ShouldCheckDamage","fuelTankHandlingSpace","fuelTankHandlingRocket","RemoteFreeze","hudTickRate","speedChangeLarge","speedChangeSmall","brightHud","brakeLandingRate","MaxPitch","ReentrySpeed","AtmoSpeedLimit","ReentryAltitude","centerX","centerY","SpaceSpeedLimit","AtmoSpeedAssist","vSpdMeterX","vSpdMeterY","altMeterX","altMeterY","fuelX","fuelY","LandingGearGroundHeight","TrajectoryAlignmentStrength","RemoteHud","YawStallAngle","PitchStallAngle","ResolutionX","ResolutionY","UseSatNav","FuelTankOptimization","ContainerOptimization","ExtraLongitudeTags","ExtraLateralTags","ExtraVerticalTags","OrbitMapSize","OrbitMapX","OrbitMapY","DisplayOrbit","CalculateBrakeLandingSpeed","ForceAlignment","autoRollRollThreshold","minRollVelocity","VertTakeOffEngine","PvPR","PvPG","PvPB","DisplayDeadZone"}local b={"SpaceTarget","BrakeToggleStatus","BrakeIsOn","RetrogradeIsOn","ProgradeIsOn","Autopilot","TurnBurn","AltitudeHold","BrakeLanding","Reentry","AutoTakeoff","HoldAltitude","AutopilotAccelerating","AutopilotBraking","AutopilotCruising","AutopilotRealigned","AutopilotEndSpeed","AutopilotStatus","AutopilotPlanetGravity","PrevViewLock","AutopilotTargetName","AutopilotTargetCoords","AutopilotTargetIndex","TotalDistanceTravelled","TotalFlightTime","SavedLocations","VectorToTarget","LocationIndex","LastMaxBrake","LockPitch","LastMaxBrakeInAtmo","AntigravTargetAltitude","LastStartTime"}local c=system.print;local d=math.floor;local e=string.format;local f=json.decode;local g=json.encode;local h=core.getElementMaxHitPointsById;local j=unit.getAtmosphereDensity;local k=core.getElementHitPointsById;local l=core.getElementTypeById;local m=core.getElementMassById;local n=core.getConstructMass;local o=Nav.control.isRemoteControlled;local p=math.atan;function round(q,r)local s=10^(r or 0)return d(q*s+0.5)/s end;local t=SafeR;local u=SafeB;local v=SafeG;local w=false;local x=0;local y=""local z=0;local A=0;local B=false;local C=0;local D=false;local E=round(ResolutionX/2,0)local F=round(ResolutionY/2,0)local G=false;local H=true;local I=55;local J=false;local K=1;local L=1;local M=false;local N=0;local O=0;local P=0;local Q=0;local R=0;local S=0;local T=0;local U=false;local V=false;local W="empty"local X=5;local Y=5;local Z=X;local a0=Y;local a1=false;local a2,a3=0;local a4,a5=0;local a6=nil;local a7=0;local a8=0;local a9=false;local aa=0;local ab=0;local ac=0;local ad=3;local ae=0;local af=""local ag=""local ah=0;local ai=false;local aj=false;local ak=false;local al=-1;local am=false;local an=""local ao=j()>0;local ap=core.getAltitude()local aq=core.getElementIdList()local ar=system.getTime()local as=nil;local at=false;local au=[[rgb(]]..d(t+0.5)..","..d(v+0.5)..","..d(u+0.5)..[[)]]local av=[[rgb(]]..d(t*0.9+0.5)..","..d(v*0.9+0.5)..","..d(u*0.9+0.5)..[[)]]local aw={}local ax=0;local ay=0;local az=""local aA=true;local aB={}local aC=1;local aD=0.001;local aE=ResolutionX;local aF=ResolutionY;local aG=nil;local aH=nil;local aI=nil;local aJ=nil;local aK=false;local aL=false;local aM=0;local aN=nil;local aO={}local aP={}local aQ={}local aR=0;local aS=false;local aT={}local aU={}local aV=d(1/apTickRate)*2;local aW={}local aX={}local aY={}local aZ={}local a_=false;local b0=16;local b1=0;local b2=nil;local b3=""local b4=nil;local b5=nil;local b6=nil;local b7=nil;local b8=nil;local b9=nil;local ba=nil;local bb=nil;local bc=false;local bd=false;local be=autoRollPreference;local bf=vec3(core.getWorldVelocity())local bg=vec3(bf):len()local bh=LandingGearGroundHeight;local bi=system.getMouseDeltaX()local bj=system.getMouseDeltaY()local bk=false;local bl=system.getTime()local bm=0;local bn=0;local bo=0;local bp=AtmoSpeedLimit;local bq=0;local br=nil;local bs=0;local bt=0;local bu=false;local bv=false;local bw={VectorToTarget,AutopilotAlign}local bx=false;local by=0;local bz=nil;local bA=false;local bB=false;local bC=false;local bD=false;local bE=0;function LoadVariables()if dbHud_1 then local bF=dbHud_1.hasKey;if not useTheseSettings then for bG,bH in pairs(a)do if bF(bH)then local bI=f(dbHud_1.getStringValue(bH))if bI~=nil then c(bH.." "..dbHud_1.getStringValue(bH))_G[bH]=bI;aK=true end end end end;coroutine.yield()for bG,bH in pairs(b)do if bF(bH)then local bI=f(dbHud_1.getStringValue(bH))if bI~=nil then c(bH.." "..dbHud_1.getStringValue(bH))_G[bH]=bI;aK=true end end end;if useTheseSettings then W="Updated user preferences used.  Will be saved when you exit seat.\nToggle off useTheseSettings to use saved values"ad=5 elseif aK then W="Loaded Saved Variables (see Lua Chat Tab for list)"else W="No Saved Variables Found - Stand up / leave remote to save settings"end else W="No databank found, install one anywhere and rerun the autoconfigure to save variables"end;local bJ=system.getTime()if LastStartTime+180<bJ then LastMaxBrakeInAtmo=0 end;if aK then E=round(ResolutionX/2,0)F=round(ResolutionY/2,0)aE=ResolutionX;aF=ResolutionY;BrakeToggleStatus=BrakeToggleDefault;userControlScheme=string.lower(userControlScheme)be=autoRollPreference end;LastStartTime=bJ;if string.find("keyboard virtual joystick mouse",userControlScheme)==nil then W="Invalid User Control Scheme selected.  Change userControlScheme in Lua Parameters to keyboard, mouse, or virtual joystick\nOr use shift and button in screen"ad=5 end;if antigrav and not ExternalAGG then if AntigravTargetAltitude==nil then AntigravTargetAltitude=ap end;antigrav.setBaseAltitude(AntigravTargetAltitude)end;au=[[rgb(]]..d(t+0.5)..","..d(v+0.5)..","..d(u+0.5)..[[)]]av=[[rgb(]]..d(t*0.9+0.5)..","..d(v*0.9+0.5)..","..d(u*0.9+0.5)..[[)]]bp=AtmoSpeedLimit end;function CalculateFuelVolume(bK,bL)if bK>bL then bL=bK end;if ContainerOptimization>0 then bL=bL-bL*ContainerOptimization*0.05 end;if FuelTankOptimization>0 then bL=bL-bL*FuelTankOptimization*0.05 end;return bL end;function ProcessElements()local bM=fuelX~=0 and fuelY~=0;for bG in pairs(aq)do local type=l(aq[bG])if string.match(type,'^.*Space Engine$')then bD=true;if string.match(tostring(core.getElementTagsById(aq[bG])),'^.*vertical.*$')then local bN=core.getElementRotationById(aq[bG])if bN[4]<0 then if utils.round(-bN[4],0.1)==0.5 then bB=true;system.print("Space Engine Up detected")end else if utils.round(bN[4],0.1)==0.5 then bC=true;system.print("Space Engine Down detected")end end end end;if type=="Landing Gear"then M=true end;if type=="Dynamic Core Unit"then local bO=h(aq[bG])if bO>10000 then b0=128 elseif bO>1000 then b0=64 elseif bO>150 then b0=32 end end;aR=aR+h(aq[bG])if bM and(type=="Atmospheric Fuel Tank"or type=="Space Fuel Tank"or type=="Rocket Fuel Tank")then local bO=h(aq[bG])local bP=m(aq[bG])local bK=0;local bQ=system.getTime()if type=="Atmospheric Fuel Tank"then local bL=400;local bR=35.03;if bO>10000 then bL=51200;bR=5480 elseif bO>1300 then bL=6400;bR=988.67 elseif bO>150 then bL=1600;bR=182.67 end;bK=bP-bR;if fuelTankHandlingAtmo>0 then bL=bL+bL*fuelTankHandlingAtmo*0.2 end;bL=CalculateFuelVolume(bK,bL)aO[#aO+1]={aq[bG],core.getElementNameById(aq[bG]),bL,bR,bK,bQ}end;if type=="Rocket Fuel Tank"then local bL=320;local bR=173.42;if bO>65000 then bL=40000;bR=25740 elseif bO>6000 then bL=5120;bR=4720 elseif bO>700 then bL=640;bR=886.72 end;bK=bP-bR;if fuelTankHandlingRocket>0 then bL=bL+bL*fuelTankHandlingRocket*0.1 end;bL=CalculateFuelVolume(bK,bL)aQ[#aQ+1]={aq[bG],core.getElementNameById(aq[bG]),bL,bR,bK,bQ}end;if type=="Space Fuel Tank"then local bL=2400;local bR=182.67;if bO>10000 then bL=76800;bR=5480 elseif bO>1300 then bL=9600;bR=988.67 end;bK=bP-bR;if fuelTankHandlingSpace>0 then bL=bL+bL*fuelTankHandlingSpace*0.2 end;bL=CalculateFuelVolume(bK,bL)aP[#aP+1]={aq[bG],core.getElementNameById(aq[bG]),bL,bR,bK,bQ}end end end end;function SetupChecks()if gyro~=nil then as=gyro.getState()==1 end;if userControlScheme~="keyboard"then system.lockView(1)else system.lockView(0)end;local bS=j()if door and(bS>0 or bS==0 and ap<10000)then for _,bH in pairs(door)do bH.toggle()end end;if switch then for _,bH in pairs(switch)do bH.toggle()end end;if forcefield and(bS>0 or bS==0 and ap<10000)then for _,bH in pairs(forcefield)do bH.toggle()end end;if antigrav~=nil and not ExternalAGG then if antigrav.getState()==1 then antigrav.show()end end;if o()==1 and RemoteFreeze then system.freeze(1)else system.freeze(0)end;if M then GearExtended=Nav.control.isAnyLandingGearExtended()==1;if GearExtended then Nav.control.extendLandingGears()else Nav.control.retractLandingGears()end end;local bT=AboveGroundLevel()if bT~=-1 or not ao and vec3(core.getVelocity()):len()<50 then BrakeIsOn=true;if not M then GearExtended=true end else BrakeIsOn=false end;if bh~=nil then Nav.axisCommandManager:setTargetGroundAltitude(bh)if bh==0 and not M then GearExtended=true;BrakeIsOn=true end else bh=Nav:getTargetGroundAltitude()if GearExtended then Nav.axisCommandManager:setTargetGroundAltitude(LandingGearGroundHeight)else Nav.axisCommandManager:setTargetGroundAltitude(TargetHoverHeight)end end;if ao and bT~=-1 then ba=core.getMaxKinematicsParametersAlongAxis("ground",core.getConstructOrientationUp())[1]end;userControlScheme=string.lower(userControlScheme)WasInAtmo=ao end;function ConvertResolutionX(bH)if ResolutionX==1920 then return bH else return round(ResolutionX*bH/1920,0)end end;function ConvertResolutionY(bH)if ResolutionY==1080 then return bH else return round(ResolutionY*bH/1080,0)end end;function RefreshLastMaxBrake(bU,bV)if bU==nil then bU=core.g()end;bU=round(bU,5)local bW=j()if bV~=nil and bV or(aN==nil or aN~=bU)then local bf=core.getVelocity()local bX=vec3(bf):len()local bY=f(unit.getData()).maxBrake;if bY~=nil and bY>0 and ao then bY=bY/utils.clamp(bX/100,0.1,1)bY=bY/bW;if bW>0.10 then if LastMaxBrakeInAtmo then LastMaxBrakeInAtmo=(LastMaxBrakeInAtmo+bY)/2 else LastMaxBrakeInAtmo=bY end end end;if bY~=nil and bY>0 then LastMaxBrake=bY end;aN=bU end end;function MakeButton(bZ,b_,c0,c1,c2,c3,c4,c5,c6)local c7={enableName=bZ,disableName=b_,width=c0,height=c1,x=c2,y=c3,toggleVar=c4,toggleFunction=c5,drawCondition=c6,hovered=false}table.insert(aB,c7)return c7 end;function UpdateAtlasLocationsList()AtlasOrdered={}for bG,bH in pairs(b2[0])do table.insert(AtlasOrdered,{name=bH.name,index=bG})end;local function c8(c9,ca)return c9.name<ca.name end;table.sort(AtlasOrdered,c8)end;function AddLocationsToAtlas()for bG,bH in pairs(SavedLocations)do table.insert(b2[0],bH)end;UpdateAtlasLocationsList()end;function float_eq(cb,cc)if cb==0 then return math.abs(cc)<1e-09 end;if cc==0 then return math.abs(cb)<1e-09 end;return math.abs(cb-cc)<math.max(math.abs(cb),math.abs(cc))*epsilon end;function zeroConvertToMapPosition(cd,ce)local cf=vec3(ce)if cd.bodyId==0 then return setmetatable({latitude=cf.x,longitude=cf.y,altitude=cf.z,bodyId=0,systemId=cd.planetarySystemId},MapPosition)end;local cg=cf-cd.center;local ae=cg:len()local ch=ae-cd.radius;local ci=0;local cj=0;if not float_eq(ae,0)then local ck=math.atan(cg.y,cg.x)cj=ck>=0 and ck or 2*math.pi+ck;ci=math.pi/2-math.acos(cg.z/ae)end;return setmetatable({latitude=math.deg(ci),longitude=math.deg(cj),altitude=ch,bodyId=cd.bodyId,systemId=cd.planetarySystemId},MapPosition)end;function zeroConvertToWorldCoordinates(cl)local q=' *([+-]?%d+%.?%d*e?[+-]?%d*)'local cm='::pos{'..q..','..q..','..q..','..q..','..q..'}'local cn,co,ci,cj,ch=string.match(cl,cm)if cn=="0"and co=="0"then return vec3(tonumber(ci),tonumber(cj),tonumber(ch))end;cj=math.rad(cj)ci=math.rad(ci)local planet=b2[tonumber(cn)][tonumber(co)]local cp=math.cos(ci)local cq=vec3(cp*math.cos(cj),cp*math.sin(cj),math.sin(ci))return planet.center+(planet.radius+ch)*cq end;function AddNewLocationByWaypoint(cr,planet,cl)if dbHud_1 then local cs={}local position=zeroConvertToWorldCoordinates(cl)if planet.name=="Space"then cs={position=position,name=cr,atmosphere=false,planetname=planet.name,gravity=planet.gravity}else local bS=false;if planet.hasAtmosphere then bS=true else bS=false end;cs={position=position,name=cr,atmosphere=bS,planetname=planet.name,gravity=planet.gravity}end;SavedLocations[#SavedLocations+1]=cs;table.insert(b2[0],cs)UpdateAtlasLocationsList()else W="Databank must be installed to save locations"end end;function AddNewLocation()if dbHud_1 then local position=vec3(core.getConstructWorldPos())local ct=planet.name..". "..#SavedLocations;if radar_1 then local cu,_=radar_1.getData():match('"constructId":"([0-9]*)","distance":([%d%.]*)')if cu~=nil and cu~=""then ct=ct.." "..radar_1.getConstructName(cu)end end;local cs={}local bS=false;if planet.hasAtmosphere then bS=true end;cs={position=position,name=ct,atmosphere=bS,planetname=planet.name,gravity=planet.gravity,safe=true}SavedLocations[#SavedLocations+1]=cs;table.insert(b2[0],cs)UpdateAtlasLocationsList()W="Location saved as "..ct else W="Databank must be installed to save locations"end end;function UpdatePosition(cv)local cw=-1;local cs;for bG,bH in pairs(SavedLocations)do if bH.name and bH.name==CustomTarget.name then cw=bG;break end end;if cw~=-1 then local cx;if cv~=nil then cs={position=SavedLocations[cw].position,name=cv,atmosphere=SavedLocations[cw].atmosphere,planetname=SavedLocations[cw].planetname,gravity=SavedLocations[cw].gravity}else cs={position=vec3(core.getConstructWorldPos()),name=SavedLocations[cw].name,atmosphere=j(),planetname=planet.name,gravity=unit.getClosestPlanetInfluence(),safe=true}end;SavedLocations[cw]=cs;cw=-1;for bG,bH in pairs(b2[0])do if bH.name and bH.name==CustomTarget.name then cw=bG end end;if cw>-1 then b2[0][cw]=cs end;UpdateAtlasLocationsList()W=CustomTarget.name.." position updated"AutopilotTargetIndex=0;UpdateAutopilotTarget()else W="Name Not Found"end end;function ClearCurrentPosition()local cw=-1;for bG,bH in pairs(b2[0])do if bH.name and bH.name==CustomTarget.name then cw=bG end end;if cw>-1 then table.remove(b2[0],cw)end;cw=-1;for bG,bH in pairs(SavedLocations)do if bH.name and bH.name==CustomTarget.name then W=bH.name.." saved location cleared"cw=bG;break end end;if cw~=-1 then table.remove(SavedLocations,cw)end;DecrementAutopilotTargetIndex()UpdateAtlasLocationsList()end;function DrawDeadZone(cy)cy[#cy+1]=e([[<circle class="dim line" style="fill:none" cx="50%%" cy="50%%" r="%d"/>]],DeadZone)end;function ToggleRadarPanel()if radarPanelID~=nil and ah==0 then system.destroyWidgetPanel(radarPanelID)radarPanelID=nil;if perisPanelID~=nil then system.destroyWidgetPanel(perisPanelID)perisPanelID=nil end else if ah==1 then system.destroyWidgetPanel(radarPanelID)radarPanelID=nil;_autoconf.displayCategoryPanel(radar,radar_size,L_TEXT("ui_lua_widget_periscope", "Periscope"),"periscope")perisPanelID=_autoconf.panels[_autoconf.panels_size]end;placeRadar=true;if radarPanelID==nil and placeRadar then _autoconf.displayCategoryPanel(radar,radar_size,L_TEXT("ui_lua_widget_radar", "Radar"),"radar")radarPanelID=_autoconf.panels[_autoconf.panels_size]placeRadar=false end;ah=0 end end;function ToggleWidgets()if aA then unit.show()core.show()if atmofueltank_size>0 then _autoconf.displayCategoryPanel(atmofueltank,atmofueltank_size,L_TEXT("ui_lua_widget_atmofuel", "Atmo Fuel"),"fuel_container")fuelPanelID=_autoconf.panels[_autoconf.panels_size]end;if spacefueltank_size>0 then _autoconf.displayCategoryPanel(spacefueltank,spacefueltank_size,L_TEXT("ui_lua_widget_spacefuel", "Space Fuel"),"fuel_container")spacefuelPanelID=_autoconf.panels[_autoconf.panels_size]end;if rocketfueltank_size>0 then _autoconf.displayCategoryPanel(rocketfueltank,rocketfueltank_size,L_TEXT("ui_lua_widget_rocketfuel", "Rocket Fuel"),"fuel_container")rocketfuelPanelID=_autoconf.panels[_autoconf.panels_size]end;aA=false else unit.hide()core.hide()if fuelPanelID~=nil then system.destroyWidgetPanel(fuelPanelID)fuelPanelID=nil end;if spacefuelPanelID~=nil then system.destroyWidgetPanel(spacefuelPanelID)spacefuelPanelID=nil end;if rocketfuelPanelID~=nil then system.destroyWidgetPanel(rocketfuelPanelID)rocketfuelPanelID=nil end;aA=true end end;function SetupInterplanetaryPanel()panelInterplanetary=system.createWidgetPanel("Interplanetary Helper")interplanetaryHeader=system.createWidget(panelInterplanetary,"value")interplanetaryHeaderText=system.createData('{"label": "Target Planet", "value": "N/A", "unit":""}')system.addDataToWidget(interplanetaryHeaderText,interplanetaryHeader)widgetDistance=system.createWidget(panelInterplanetary,"value")widgetDistanceText=system.createData('{"label": "distance", "value": "N/A", "unit":""}')system.addDataToWidget(widgetDistanceText,widgetDistance)widgetTravelTime=system.createWidget(panelInterplanetary,"value")widgetTravelTimeText=system.createData('{"label": "Travel Time", "value": "N/A", "unit":""}')system.addDataToWidget(widgetTravelTimeText,widgetTravelTime)widgetMaxMass=system.createWidget(panelInterplanetary,"value")widgetMaxMassText=system.createData('{"label": "Maximum Mass", "value": "N/A", "unit":""}')system.addDataToWidget(widgetMaxMassText,widgetMaxMass)widgetCurBrakeDistance=system.createWidget(panelInterplanetary,"value")widgetCurBrakeDistanceText=system.createData('{"label": "Cur Brake distance", "value": "N/A", "unit":""}')if not ao then system.addDataToWidget(widgetCurBrakeDistanceText,widgetCurBrakeDistance)end;widgetCurBrakeTime=system.createWidget(panelInterplanetary,"value")widgetCurBrakeTimeText=system.createData('{"label": "Cur Brake Time", "value": "N/A", "unit":""}')if not ao then system.addDataToWidget(widgetCurBrakeTimeText,widgetCurBrakeTime)end;widgetMaxBrakeDistance=system.createWidget(panelInterplanetary,"value")widgetMaxBrakeDistanceText=system.createData('{"label": "Max Brake distance", "value": "N/A", "unit":""}')if not ao then system.addDataToWidget(widgetMaxBrakeDistanceText,widgetMaxBrakeDistance)end;widgetMaxBrakeTime=system.createWidget(panelInterplanetary,"value")widgetMaxBrakeTimeText=system.createData('{"label": "Max Brake Time", "value": "N/A", "unit":""}')if not ao then system.addDataToWidget(widgetMaxBrakeTimeText,widgetMaxBrakeTime)end;widgetTrajectoryAltitude=system.createWidget(panelInterplanetary,"value")widgetTrajectoryAltitudeText=system.createData('{"label": "Projected Altitude", "value": "N/A", "unit":""}')if not ao then system.addDataToWidget(widgetTrajectoryAltitudeText,widgetTrajectoryAltitude)end;widgetTargetOrbit=system.createWidget(panelInterplanetary,"value")widgetTargetOrbitText=system.createData('{"label": "Target Altitude", "value": "N/A", "unit":""}')system.addDataToWidget(widgetTargetOrbitText,widgetTargetOrbit)end;function Contains(cz,cA,c2,c3,c0,c1)if cz>c2 and cz<c2+c0 and cA>c3 and cA<c3+c1 then return true else return false end end;function ToggleTurnBurn()TurnBurn=not TurnBurn end;function ToggleVectorToTarget(SpaceTarget)VectorToTarget=not VectorToTarget;if VectorToTarget then TurnBurn=false;if not AltitudeHold and not SpaceTarget then ToggleAltitudeHold()end end;VectorStatus="Proceeding to Waypoint"end;function ToggleAutoLanding()if BrakeLanding then BrakeLanding=false else StrongBrakes=planet.gravity*9.80665*n()<LastMaxBrake;AltitudeHold=false;AutoTakeoff=false;LockPitch=nil;BrakeLanding=true;Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal,0)z=0 end end;function ToggleAutoTakeoff()if AutoTakeoff then AutoTakeoff=false;if AltitudeHold then ToggleAltitudeHold()end elseif VertTakeOff then BrakeLanding=true;VertTakeOff=false;AltitudeHold=false else if VertTakeOffEngine then VertTakeOff=true;AltitudeHold=false else if not AltitudeHold then ToggleAltitudeHold()end;AutoTakeoff=true;HoldAltitude=ap+AutoTakeoffAltitude end;bA=false;GearExtended=false;Nav.control.retractLandingGears()Nav.axisCommandManager:setTargetGroundAltitude(500)BrakeIsOn=true end end;function ToggleIntoOrbit()if j()==0 then if IntoOrbit then bA=false;IntoOrbit=false;bu=false;bs=nil;bt=nil;bz=nil;bE=0;be=autoRollPreference;if AltitudeHold then AltitudeHold=false;AutoTakeoff=false end;bw.VectorToTarget=false;bw.AutopilotAlign=false;bx=false elseif unit.getClosestPlanetInfluence()>0 then IntoOrbit=true;be=true;bA=false;bs=nil;bt=nil;bE=0;if bz==nil then bz=planet end;if AltitudeHold then AltitudeHold=false;AutoTakeoff=false end else W="Unable to engage orbiting, not near planet"end else bA=false;IntoOrbit=false;bu=false;bs=nil;bt=nil;bz=nil;bE=0;be=autoRollPreference;if AltitudeHold then ToggleAltitudeHold()end;bw.VectorToTarget=false;bw.AutopilotAlign=false;bx=false end end;function ToggleLockPitch()if LockPitch==nil then local cB=vec3(core.getConstructWorldOrientationForward())local cC=vec3(core.getConstructWorldOrientationRight())local cD=vec3(core.getWorldVertical())local cE=getPitch(cD,cB,cC)LockPitch=cE;AutoTakeoff=false;AltitudeHold=false;BrakeLanding=false else LockPitch=nil end end;function ToggleAltitudeHold()local bJ=system.getTime()if bJ-bn<1.5 then local cF=false;if planet.hasAtmosphere and(j()>0 and HoldAltitude==planet.spaceEngineMinAltitude-50)then cF=true;if IntoOrbit then ToggleIntoOrbit()end;bn=0;return end;if planet.hasAtmosphere and not cF then if j()>0 then HoldAltitude=planet.spaceEngineMinAltitude-50 else if unit.getClosestPlanetInfluence()>0 then HoldAltitude=planet.noAtmosphericDensityAltitude+1000;by=HoldAltitude;bx=true;if not IntoOrbit then ToggleIntoOrbit()end;bu=true end end;bn=-1;if AltitudeHold or IntoOrbit then return end end else bn=bJ end;if unit.getClosestPlanetInfluence()>0 and j()==0 then by=ap;bx=true;bu=true;ToggleIntoOrbit()if IntoOrbit then bn=bJ else bn=0 end;return end;AltitudeHold=not AltitudeHold;if AltitudeHold then Autopilot=false;ProgradeIsOn=false;RetrogradeIsOn=false;U=false;BrakeLanding=false;Reentry=false;be=true;LockPitch=nil;bA=false;if hoverDetectGround()==-1 or not ao then AutoTakeoff=false;if not aj and Nav.axisCommandManager:getAxisCommandType(0)==0 and not AtmoSpeedAssist then Nav.control.cancelCurrentControlMasterMode()end else AutoTakeoff=true;if bn>-1 then HoldAltitude=ap+AutoTakeoffAltitude end;GearExtended=false;Nav.control.retractLandingGears()BrakeIsOn=true;Nav.axisCommandManager:setTargetGroundAltitude(TargetHoverHeight)end;if aj then HoldAltitude=100000 end;bn=bJ else be=autoRollPreference;AutoTakeoff=false;BrakeLanding=false;Reentry=false;AutoTakeoff=false;VectorToTarget=false;if IntoOrbit then ToggleIntoOrbit()end;bn=0 end end;function ToggleFollowMode()if o()==1 then U=not U;if U then Autopilot=false;RetrogradeIsOn=false;ProgradeIsOn=false;AltitudeHold=false;Reentry=false;BrakeLanding=false;AutoTakeoff=false;OldGearExtended=GearExtended;GearExtended=false;Nav.control.retractLandingGears()Nav.axisCommandManager:setTargetGroundAltitude(TargetHoverHeight)else BrakeIsOn=true;be=autoRollPreference;GearExtended=OldGearExtended;if GearExtended then Nav.control.extendLandingGears()Nav.axisCommandManager:setTargetGroundAltitude(LandingGearGroundHeight)end end else W="Follow Mode only works with Remote controller"U=false end end;function ToggleAutopilot()local bJ=system.getTime()if bJ-bo<1.5 and ao then if not bD then W="No space engines detected, Orbital Hop not supported"return end;if planet.hasAtmosphere then if j()>0 then HoldAltitude=planet.noAtmosphericDensityAltitude+1000 end;bo=-1;if Autopilot or VectorToTarget then return end end else bo=bJ end;TargetSet=false;if AutopilotTargetIndex>0 and not Autopilot and not VectorToTarget and not aj then UpdateAutopilotTarget()local cG=zeroConvertToMapPosition(a6,AutopilotTargetCoords)cG="::pos{"..cG.systemId..","..cG.bodyId..","..cG.latitude..","..cG.longitude..","..cG.altitude.."}"system.setWaypoint(cG)if CustomTarget~=nil then LockPitch=nil;SpaceTarget=CustomTarget.planetname=="Space"if SpaceTarget then if j()~=0 then aj=true;ToggleAltitudeHold()else Autopilot=true end elseif planet.name==CustomTarget.planetname then StrongBrakes=true;if j()>0 then if bo==-1 then bn=0 end;HoldAltitude=ap;if not VectorToTarget then ToggleVectorToTarget(SpaceTarget)end else if ap>100000 or ap==0 then bA=false;Autopilot=true elseif ap<=100000 then if IntoOrbit then ToggleIntoOrbit()end;by=planet.noAtmosphericDensityAltitude+1000;bx=true;bw.AutopilotAlign=true;bw.VectorToTarget=true;bu=false;if not IntoOrbit then ToggleIntoOrbit()end end end else RetrogradeIsOn=false;ProgradeIsOn=false;if j()~=0 then aj=true;ToggleAltitudeHold()else Autopilot=true end end elseif j()==0 then local cH=unit.getClosestPlanetInfluence()>0;if CustomTarget==nil and(a6.name==planet.name and cH)and not IntoOrbit then bA=false;bu=false;ToggleIntoOrbit()else Autopilot=true;RetrogradeIsOn=false;ProgradeIsOn=false;AutopilotRealigned=false;U=false;AltitudeHold=false;BrakeLanding=false;Reentry=false;AutoTakeoff=false;G=false;LockPitch=nil;WaypointSet=false end else aj=true;ToggleAltitudeHold()end else aj=false;Autopilot=false;AutopilotRealigned=false;VectorToTarget=false;G=false;AutoTakeoff=false;AltitudeHold=false;VectorToTarget=false;HoldAltitude=ap;TargetSet=false;Reentry=false;if IntoOrbit then ToggleIntoOrbit()end end;bo=bJ end;function ProgradeToggle()ProgradeIsOn=not ProgradeIsOn;RetrogradeIsOn=false;Autopilot=false;AltitudeHold=false;U=false;BrakeLanding=false;LockPitch=nil;Reentry=false;AutoTakeoff=false end;function RetrogradeToggle()RetrogradeIsOn=not RetrogradeIsOn;ProgradeIsOn=false;Autopilot=false;AltitudeHold=false;U=false;BrakeLanding=false;LockPitch=nil;Reentry=false;AutoTakeoff=false end;function BrakeToggle()BrakeIsOn=not BrakeIsOn;if BrakeLanding then BrakeLanding=false;be=autoRollPreference end;if BrakeIsOn then AltitudeHold=false;VectorToTarget=false;AutoTakeoff=false;VertTakeOff=false;Reentry=false;ProgradeIsOn=false;BrakeLanding=false;AutoLanding=false;AltitudeHold=false;if IntoOrbit then ToggleIntoOrbit()end;LockPitch=nil;be=autoRollPreference;ai=false;ak=false;aa=0 end end;function CheckDamage(cy)local cI=0;az=""local cJ=aR;local cK=0;local cL=0;local cM=0;local cN=0;local cO=""for bG in pairs(aq)do local bO=0;local cP=0;cP=h(aq[bG])bO=k(aq[bG])cK=cK+bO;if bO<cP then if bO==0 then cM=cM+1 else cL=cL+1 end;if aS and#aw==0 then position=vec3(core.getElementPositionById(aq[bG]))local c2=position.x-b0;local c3=position.y-b0;local cQ=position.z-b0;table.insert(aw,core.spawnArrowSticker(c2,c3,cQ+1,"down"))table.insert(aw,core.spawnArrowSticker(c2,c3,cQ+1,"down"))core.rotateSticker(aw[2],0,0,90)table.insert(aw,core.spawnArrowSticker(c2+1,c3,cQ,"north"))table.insert(aw,core.spawnArrowSticker(c2+1,c3,cQ,"north"))core.rotateSticker(aw[4],90,90,0)table.insert(aw,core.spawnArrowSticker(c2-1,c3,cQ,"south"))table.insert(aw,core.spawnArrowSticker(c2-1,c3,cQ,"south"))core.rotateSticker(aw[6],90,-90,0)table.insert(aw,core.spawnArrowSticker(c2,c3-1,cQ,"east"))table.insert(aw,core.spawnArrowSticker(c2,c3-1,cQ,"east"))core.rotateSticker(aw[8],90,0,90)table.insert(aw,core.spawnArrowSticker(c2,c3+1,cQ,"west"))table.insert(aw,core.spawnArrowSticker(c2,c3+1,cQ,"west"))core.rotateSticker(aw[10],-90,0,90)table.insert(aw,aq[bG])end elseif aS and#aw>0 and aw[11]==aq[bG]then for cR in pairs(aw)do core.deleteSticker(aw[cR])end;aw={}end end;cI=d(cK/cJ*100)if cI<100 then cy[#cy+1]=[[<g class="pbright txt">]]cN=d(cI*2.55)cO=e("rgb(%d,%d,%d)",255-cN,cN,0)if cI<100 then cy[#cy+1]=e([[<text class="txtbig txtmid" x=50%% y="1035" style="fill:%s">Elemental Integrity: %i %%</text>]],cO,cI)if cM>0 then cy[#cy+1]=e([[<text class="txtbig txtmid" x=50%% y="1055" style="fill:%s">Disabled Modules: %i Damaged Modules: %i</text>]],cO,cM,cL)elseif cL>0 then cy[#cy+1]=e([[<text class="txtbig txtmid" x=50%% y="1055"style="fill:%s">Damaged Modules: %i</text>]],cO,cL)end end;cy[#cy+1]=[[<\g>]]end end;function DrawCursorLine(cy)local cS=d(utils.clamp(ae/(aE/4)*255,0,255))cy[#cy+1]=e("<line x1='0' y1='0' x2='%fpx' y2='%fpx' style='stroke:rgb(%d,%d,%d);stroke-width:2;transform:translate(50%%, 50%%)' />",ab,ac,d(t+0.5)+cS,d(v+0.5)-cS,d(u+0.5)-cS)end;function getPitch(cT,cU,ca)local cV=cT:cross(ca):normalize_inplace()local cE=math.acos(utils.clamp(cV:dot(-cU),-1,1))*constants.rad2deg;if cV:cross(-cU):dot(ca)<0 then cE=-cE end;return cE end;local function cW(cX,cY,cZ)cY=cY:project_on_plane(cX)cZ=cZ:project_on_plane(cX)return p(cY:cross(cZ):dot(cX),cY:dot(cZ))end;function clearAll()if am then am=false;AutopilotAccelerating=false;AutopilotBraking=false;AutopilotCruising=false;Autopilot=false;AutopilotRealigned=false;AutopilotStatus="Aligning"RetrogradeIsOn=false;ProgradeIsOn=false;AltitudeHold=false;Reentry=false;BrakeLanding=false;BrakeIsOn=false;AutoTakeoff=false;VertTakeOff=false;U=false;G=false;ai=false;aj=false;J=false;be=autoRollPreference;VectorToTarget=false;TurnBurn=false;as=false;LockPitch=nil else am=true end end;function wipeSaveVariables()if not dbHud_1 then W="No Databank Found, unable to wipe. \nYou must have a Databank attached to ship prior to running the HUD autoconfigure"ad=5 else if aL then for bG,bH in pairs(a)do dbHud_1.setStringValue(bH,g(nil))end;for bG,bH in pairs(b)do if bH~="SavedLocations"then dbHud_1.setStringValue(bH,g(nil))end end;W="Databank wiped. New variables will save after re-enter seat and exit"ad=5;aL=false;aK=false;a9=true else W="Press ALT-7 again to confirm wipe of ALL data"aL=true end end end;function CheckButtons()for _,bH in pairs(aB)do if bH.hovered then if not bH.drawCondition or bH.drawCondition()then bH.toggleFunction()end;bH.hovered=false end end end;function SetButtonContains()local c2=ab+aE/2;local c3=ac+aF/2;for _,bH in pairs(aB)do bH.hovered=Contains(c2,c3,bH.x,bH.y,bH.width,bH.height)end end;function DrawButton(cy,c_,hover,c2,c3,d0,d1,d2,d3,d4,d5)if type(d4)=="function"then d4=d4()end;if type(d5)=="function"then d5=d5()end;cy[#cy+1]=e("<rect x='%f' y='%f' width='%f' height='%f' fill='",c2,c3,d0,d1)if c_ then cy[#cy+1]=e("%s'",d2)else cy[#cy+1]=d3 end;if hover then cy[#cy+1]=" style='stroke:white; stroke-width:2'"else cy[#cy+1]=" style='stroke:black; stroke-width:1'"end;cy[#cy+1]="></rect>"cy[#cy+1]=e("<text x='%f' y='%f' font-size='24' fill='",c2+d0/2,c3+d1/2+5)if c_ then cy[#cy+1]="black"else cy[#cy+1]="white"end;cy[#cy+1]="' text-anchor='middle' font-family='Montserrat'>"if c_ then cy[#cy+1]=e("%s</text>",d4)else cy[#cy+1]=e("%s</text>",d5)end end;function DrawButtons(cy)local d6="rgb(50,50,50)'"local d7="rgb(210,200,200)"local d8=DrawButton;for _,bH in pairs(aB)do local b_=bH.disableName;local bZ=bH.enableName;if type(b_)=="function"then b_=b_()end;if type(bZ)=="function"then bZ=bZ()end;if not bH.drawCondition or bH.drawCondition()then d8(cy,bH.toggleVar(),bH.hovered,bH.x,bH.y,bH.width,bH.height,d7,d6,b_,bZ)end end end;function DrawTank(cy,a_,c2,d9,da,db,dc,dd)local de=1;local df=2;local dg=3;local dh=4;local di=5;local dj=6;local dk=""local dl=0;local dm=fuelY;local dn=fuelY+10;if o()==1 and not RemoteHud then dm=dm-50;dn=dn-50 end;cy[#cy+1]=[[<g class="pdim txtfuel">]]if da=="ATMO"then dk="atmofueltank"elseif da=="SPACE"then dk="spacefueltank"else dk="rocketfueltank"end;dl=_G[dk.."_size"]if#db>0 then for i=1,#db do local ct=string.sub(db[i][df],1,12)local dp=0;for cR=1,dl do if db[i][df]==f(unit[dk.."_"..cR].getData()).name then dp=cR;break end end;if a_ or dc[i]==nil or dd[i]==nil then local dq=0;local dr=0;local ds=0;local dt=0;local bQ=system.getTime()if dp~=0 then dd[i]=f(unit[dk.."_"..dp].getData()).percentage;dc[i]=f(unit[dk.."_"..dp].getData()).timeLeft;if dc[i]=="n/a"then dc[i]=0 end else ds=m(db[i][de])-db[i][dh]dq=db[i][dg]dd[i]=d(0.5+ds*100/dq)dr=db[i][di]dt=db[i][dj]if dr<=ds then dc[i]=0 else dc[i]=d(0.5+ds/((dr-ds)/(bQ-dt)))end;db[i][di]=ds;db[i][dj]=bQ end end;if ct==d9 then ct=e("%s %d",da,i)end;if dp==0 then ct=ct.." *"end;local du;if dc[i]==0 then du="n/a"else du=FormatTimeString(dc[i])end;if dd[i]~=nil then local cN=d(dd[i]*2.55)local cO=e("rgb(%d,%d,%d)",255-cN,cN,0)local dv=""if du~="n/a"and dc[i]<120 or dd[i]<5 then if a_ then dv=[[class="red"]]end end;cy[#cy+1]=e([[
local apThrottleSet = false -- Do not save this, because when they re-enter, throttle won't be set anymore
local toggleView = true
local minAutopilotSpeed = 55 -- Minimum speed for autopilot to maneuver in m/s.  Keep above 25m/s to prevent nosedives when boosters kick in
local reentryMode = false
local MousePitchFactor = 1 -- Mouse control only
local MouseYawFactor = 1 -- Mouse control only
local hasGear = false
local pitchInput = 0
local pitchInput2 = 0
local yawInput2 = 0
local rollInput = 0
local yawInput = 0
local brakeInput = 0
local rollInput2 = 0
local followMode = false
local holdingCtrl = false
local msgText = "empty"
local holdAltitudeButtonModifier = 5
local antiGravButtonModifier = 5
local currentHoldAltModifier = holdAltitudeButtonModifier
local currentAggModifier = antiGravButtonModifier
local isBoosting = false -- Dodgin's Don't Die Rocket Govenor
local brakeDistance, brakeTime = 0
local maxBrakeDistance, maxBrakeTime = 0
local autopilotTargetPlanet = nil
local totalDistanceTrip = 0
local flightTime = 0
local wipedDatabank = false
local upAmount = 0
local simulatedX = 0
local simulatedY = 0        
local msgTimer = 3
local distance = 0
local radarMessage = ""
local lastOdometerOutput = ""
local peris = 0
local spaceLand = false
local spaceLaunch = false
local finalLand = false
local hovGndDet = -1
local clearAllCheck = false
local myAutopilotTarget=""
local inAtmo = (atmosphere() > 0)
local coreAltitude = core.getAltitude()
local elementsID = core.getElementIdList()
local lastTravelTime = system.getTime()
local gyroIsOn = nil
local speedLimitBreaking = false
local rgb = [[rgb(]] .. mfloor(PrimaryR + 0.5) .. "," .. mfloor(PrimaryG + 0.5) .. "," .. mfloor(PrimaryB + 0.5) .. [[)]]
local rgbdim = [[rgb(]] .. mfloor(PrimaryR * 0.9 + 0.5) .. "," .. mfloor(PrimaryG * 0.9 + 0.5) .. "," ..   mfloor(PrimaryB * 0.9 + 0.5) .. [[)]]

local markers = {}
local previousYawAmount = 0
local previousPitchAmount = 0
local damageMessage = ""
local UnitHidden = true
local Buttons = {}
local autopilotStrength = 1 -- How strongly autopilot tries to point at a target
local alignmentTolerance = 0.001 -- How closely it must align to a planet before accelerating to it
local resolutionWidth = ResolutionX
local resolutionHeight = ResolutionY
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
local repairArrows = false
local fuelTimeLeftR = {}
local fuelPercentR = {}
local fuelUpdateDelay = mfloor(1 / apTickRate) * 2
local fuelTimeLeftS = {}
local fuelPercentS = {}
local fuelTimeLeft = {}
local fuelPercent = {}
local updateTanks = false
local coreOffset = 16
local updateCount = 0
local atlas = nil
local GalaxyMapHTML = ""
local MapXRatio = nil
local MapYRatio = nil
local YouAreHere = nil
local PlanetaryReference = nil
local galaxyReference = nil
local Kinematic = nil
local maxKinematicUp = nil
local Kep = nil
local Animating = false
local Animated = false
local autoRoll = autoRollPreference
local velocity = vec3(core.getWorldVelocity())
local velMag = vec3(velocity):len()
local targetGroundAltitude = LandingGearGroundHeight -- So it can tell if one loaded or not
local deltaX = system.getMouseDeltaX()
local deltaY = system.getMouseDeltaY()
local stalling = false
local lastApTickTime = system.getTime()
local targetRoll = 0
local ahDoubleClick = 0
local apDoubleClick = 0
local adjustedAtmoSpeedLimit = AtmoSpeedLimit
local VtPitch = 0
local orbitMsg = nil
local orbitPitch = 0
local orbitRoll = 0
local orbitAligned = false
local orbitalRecover = false
local orbitalParams = { VectorToTarget = false } --, AltitudeHold = false }
local OrbitTargetSet = false
local OrbitTargetOrbit = 0
local OrbitTargetPlanet = nil
local OrbitAchieved = false
local SpaceEngineVertUp = false
local SpaceEngineVertDn = false
local SpaceEngines = false
local OrbitTicks = 0

-- BEGIN FUNCTION DEFINITIONS

function LoadVariables()
    if dbHud_1 then
        local hasKey = dbHud_1.hasKey
        if not useTheseSettings then
            for k, v in pairs(saveableVariables) do
                if hasKey(v) then
                    local result = jdecode(dbHud_1.getStringValue(v))
                    if result ~= nil then
                        sprint(v .. " " .. dbHud_1.getStringValue(v))
                        _G[v] = result
                        valuesAreSet = true
                    end
                end
            end
        end
        coroutine.yield()
        for k, v in pairs(autoVariables) do
            if hasKey(v) then
                local result = jdecode(dbHud_1.getStringValue(v))
                if result ~= nil then
                    sprint(v .. " " .. dbHud_1.getStringValue(v))
                    _G[v] = result
                    valuesAreSet = true
                end
            end
        end
        if useTheseSettings then
            msgText = "Updated user preferences used.  Will be saved when you exit seat.\nToggle off useTheseSettings to use saved values"
            msgTimer = 5
        elseif valuesAreSet then
            msgText = "Loaded Saved Variables (see Lua Chat Tab for list)"
        else
            msgText = "No Saved Variables Found - Stand up / leave remote to save settings"
        end
    else
        msgText = "No databank found, install one anywhere and rerun the autoconfigure to save variables"
    end
    local time = system.getTime()
    if (LastStartTime + 180) < time then -- Variables to reset if out of seat (and not on hud) for more than 3 min
        LastMaxBrakeInAtmo = 0
    end
    if valuesAreSet then
        halfResolutionX = round(ResolutionX / 2,0)
        halfResolutionY = round(ResolutionY / 2,0)
        resolutionWidth = ResolutionX
        resolutionHeight = ResolutionY
        BrakeToggleStatus = BrakeToggleDefault
        userControlScheme = string.lower(userControlScheme)
        autoRoll = autoRollPreference
    end
    LastStartTime = time
    if string.find("keyboard virtual joystick mouse", userControlScheme) == nil then 
        msgText = "Invalid User Control Scheme selected.  Change userControlScheme in Lua Parameters to keyboard, mouse, or virtual joystick\nOr use shift and button in screen"
        msgTimer = 5
    end

    if antigrav and not ExternalAGG then
        if AntigravTargetAltitude == nil then 
            AntigravTargetAltitude = coreAltitude
        end
        antigrav.setBaseAltitude(AntigravTargetAltitude)
    end
    rgb = [[rgb(]] .. mfloor(PrimaryR + 0.5) .. "," .. mfloor(PrimaryG + 0.5) .. "," .. mfloor(PrimaryB + 0.5) ..
                        transform="rotate(-90,]]..c2 ..[[,]]..c3 ..[[)"/>]]cy[#cy+1]=fc end end end end;function DrawWarnings(cy)cy[#cy+1]=e([[<text class="hudver" x="%d" y="%d">DU Hud Version: %.3f</text>]],ConvertResolutionX(1900),ConvertResolutionY(1070),VERSION_NUMBER)cy[#cy+1]=[[<g class="warnings">]]if unit.isMouseControlActivated()==1 then cy[#cy+1]=e([[
                    <text x="%d" y="%d">Warning: Invalid Control Scheme Detected</text>]],ConvertResolutionX(960),ConvertResolutionY(550))cy[#cy+1]=e([[
                    <text x="%d" y="%d">Keyboard Scheme must be selected</text>]],ConvertResolutionX(960),ConvertResolutionY(600))cy[#cy+1]=e([[
                    <text x="%d" y="%d">Set your preferred scheme in Lua Parameters instead</text>]],ConvertResolutionX(960),ConvertResolutionY(650))end;local fd=ConvertResolutionX(960)local fe=ConvertResolutionY(860)local ff=ConvertResolutionY(880)local fg=ConvertResolutionY(900)local fh=ConvertResolutionY(960)local fi=ConvertResolutionY(200)local fj=ConvertResolutionY(150)local fk=ConvertResolutionY(960)if o()==1 and not RemoteHud then fe=ConvertResolutionY(135)ff=ConvertResolutionY(155)fg=ConvertResolutionY(175)fi=ConvertResolutionY(115)fj=ConvertResolutionY(95)end;if BrakeIsOn then cy[#cy+1]=e([[<text x="%d" y="%d">Brake Engaged</text>]],fd,fe)elseif A>0 then cy[#cy+1]=e([[<text x="%d" y="%d" style="opacity:%s">Auto-Brake Engaged</text>]],fd,fe,A)end;if ao and bk and hoverDetectGround()==-1 then cy[#cy+1]=e([[<text x="%d" y="%d">** STALL WARNING **</text>]],fd,fi+50)end;if as then cy[#cy+1]=e([[<text x="%d" y="%d">Gyro Enabled</text>]],fd,fk)end;if GearExtended then if M then cy[#cy+1]=e([[<text class="warn" x="%d" y="%d">Gear Extended</text>]],fd,ff)else cy[#cy+1]=e([[<text x="%d" y="%d">Landed (G: Takeoff)</text>]],fd,ff)end;local dE,dF=getDistanceDisplayString(Nav:getTargetGroundAltitude())cy[#cy+1]=e([[<text class="warn" x="%d" y="%d">Hover Height: %s</text>]],fd,fg,dE..dF)end;if a1 then cy[#cy+1]=e([[<text class="warn" x="%d" y="%d">ROCKET BOOST ENABLED</text>]],fd,fh+20)end;if antigrav and not ExternalAGG and antigrav.getState()==1 and AntigravTargetAltitude~=nil then if math.abs(ap-antigrav.getBaseAltitude())<501 then cy[#cy+1]=e([[<text class="warn" x="%d" y="%d">AGG On - Target Altitude: %d Singluarity Altitude: %d</text>]],fd,fi+20,d(AntigravTargetAltitude),d(antigrav.getBaseAltitude()))else cy[#cy+1]=e([[<text x="%d" y="%d">AGG On - Target Altitude: %d Singluarity Altitude: %d</text>]],fd,fi+20,d(AntigravTargetAltitude),d(antigrav.getBaseAltitude()))end elseif Autopilot and AutopilotTargetName~="None"then cy[#cy+1]=e([[<text class="warn" x="%d" y="%d">Autopilot %s</text>]],fd,fi+20,AutopilotStatus)elseif LockPitch~=nil then cy[#cy+1]=e([[<text class="warn" x="%d" y="%d">LockedPitch: %d</text>]],fd,fi+20,d(LockPitch))elseif U then cy[#cy+1]=e([[<text class="warn" x="%d" y="%d">Follow Mode Engaged</text>]],fd,fi+20)elseif Reentry then cy[#cy+1]=e([[<text class="warn" x="%d" y="%d">Re-entry in Progress</text>]],fd,fi+20)end;local fl,fm,fn=b8:getPlanetarySystem(0):castIntersections(vec3(core.getConstructWorldPos()),bf:normalize(),function(fo)if fo.noAtmosphericDensityAltitude>0 then return fo.radius+fo.noAtmosphericDensityAltitude else return fo.radius+fo.surfaceMaxAltitude*1.5 end end)local fp=fm;if fn~=nil and fm~=nil then fp=math.min(fn,fm)end;if AltitudeHold then if AutoTakeoff and not IntoOrbit then local dE,dF=getDistanceDisplayString(HoldAltitude)cy[#cy+1]=e([[<text class="warn" x="%d" y="%d">Ascent to %s</text>]],fd,fi,dE..dF)if BrakeIsOn then cy[#cy+1]=e([[<text class="crit" x="%d" y="%d">Throttle Up and Disengage Brake For Takeoff</text>]],fd,fi+50)end else local dE,dF=getDistanceDisplayString2(HoldAltitude)cy[#cy+1]=e([[<text class="warn" x="%d" y="%d">Altitude Hold: %s</text>]],fd,fi,dE..dF)end end;if VertTakeOff and(antigrav~=nil and antigrav)then if j()>0.1 then cy[#cy+1]=e([[<text class="warn" x="%d" y="%d">Beginning ascent</text>]],fd,fi)elseif j()<0.09 and j()>0.05 then cy[#cy+1]=e([[<text class="warn" x="%d" y="%d">Aligning trajectory</text>]],fd,fi)elseif j()<0.05 then cy[#cy+1]=e([[<text class="warn" x="%d" y="%d">Leaving atmosphere</text>]],fd,fi)end end;if IntoOrbit then if br~=nil then cy[#cy+1]=e([[<text class="warn" x="%d" y="%d">%s</text>]],fd,fi,br)end end;if BrakeLanding then if StrongBrakes then cy[#cy+1]=e([[<text x="%d" y="%d">Brake-Landing</text>]],fd,fi)else cy[#cy+1]=e([[<text x="%d" y="%d">Coast-Landing</text>]],fd,fi)end end;if ProgradeIsOn then cy[#cy+1]=e([[<text class="crit" x="%d" y="%d">Prograde Alignment</text>]],fd,fi)end;if RetrogradeIsOn then cy[#cy+1]=e([[<text class="crit" x="%d" y="%d">Retrograde Alignment</text>]],fd,fi)end;if TurnBurn then cy[#cy+1]=e([[<text class="crit" x="%d" y="%d">Turn & Burn Braking</text>]],fd,fj)elseif fp~=nil and j()==0 then local dE,dF=getDistanceDisplayString(fp)local travelTime=b9.computeTravelTime(bg,0,fp)local fq="Collision"if fl.noAtmosphericDensityAltitude>0 then fq="Atmosphere"end;cy[#cy+1]=e([[<text class="crit" x="%d" y="%d">%s %s In %s (%s)</text>]],fd,fj,fl.name,fq,FormatTimeString(travelTime),dE..dF)end;if VectorToTarget and not IntoOrbit then cy[#cy+1]=e([[<text class="warn" x="%d" y="%d">%s</text>]],fd,fi+30,VectorStatus)end;cy[#cy+1]="</g>"end;function DisplayOrbitScreen(cy)if orbit~=nil and j()<0.2 and planet~=nil and orbit.apoapsis~=nil and orbit.periapsis~=nil and orbit.period~=nil and orbit.apoapsis.speed>5 and DisplayOrbit then local fr=OrbitMapX;local fs=OrbitMapY;local ft=OrbitMapSize;local fu=4;fs=fs+fu;local fv=15;local c2=fr+ft+fr/2+fu;local c3=fs+ft/2+5+fu;local fw,fx,fy,fz;fw=ft/4;fz=0;cy[#cy+1]=[[<g class="pbright txtorb txtmid">]]cy[#cy+1]=e('<rect width="%f" height="%d" rx="10" ry="10" x="%d" y="%d" style="fill:rgb(0,0,100);stroke-width:4;stroke:white;fill-opacity:0.3;" />',ft+fr*2,ft+fs,fu,fu)if orbit.periapsis~=nil and orbit.apoapsis~=nil then fy=(orbit.apoapsis.altitude+orbit.periapsis.altitude+planet.radius*2)/(fw*2)fx=(planet.radius+orbit.periapsis.altitude+(orbit.apoapsis.altitude-orbit.periapsis.altitude)/2)/fy*(1-orbit.eccentricity)fz=fw-orbit.periapsis.altitude/fy-planet.radius/fy;local fA=""if orbit.periapsis.altitude<=0 then fA='redout'end;cy[#cy+1]=e([[<ellipse class="%s line" cx="%f" cy="%f" rx="%f" ry="%f"/>]],fA,fr+ft/2+fz+fu,fs+ft/2+fu,fw,fx)cy[#cy+1]=e('<circle cx="%f" cy="%f" r="%f" stroke="white" stroke-width="3" fill="blue" />',fr+ft/2+fu,fs+ft/2+fu,planet.radius/fy)end;if orbit.apoapsis~=nil and orbit.apoapsis.speed<MaxGameVelocity and orbit.apoapsis.speed>1 then cy[#cy+1]=e([[<line class="pdim op30 linethick" x1="%f" y1="%f" x2="%f" y2="%f"/>]],c2-35,c3-5,fr+ft/2+fw+fz,c3-5)cy[#cy+1]=e([[<text x="%f" y="%f">Apoapsis</text>]],c2,c3)c3=c3+fv;local dE,dF=getDistanceDisplayString(orbit.apoapsis.altitude)cy[#cy+1]=e([[<text x="%f" y="%f">%s</text>]],c2,c3,dE..dF)c3=c3+fv;cy[#cy+1]=e([[<text x="%f" y="%f">%s</text>]],c2,c3,FormatTimeString(orbit.timeToApoapsis))c3=c3+fv;cy[#cy+1]=e([[<text x="%f" y="%f">%s</text>]],c2,c3,getSpeedDisplayString(orbit.apoapsis.speed))end;c3=fs+ft/2+5+fu;c2=fr-fr/2+10+fu;if orbit.periapsis~=nil and orbit.periapsis.speed<MaxGameVelocity and orbit.periapsis.speed>1 then cy[#cy+1]=e([[<line class="pdim op30 linethick" x1="%f" y1="%f" x2="%f" y2="%f"/>]],c2+35,c3-5,fr+ft/2-fw+fz,c3-5)cy[#cy+1]=e([[<text x="%f" y="%f">Periapsis</text>]],c2,c3)c3=c3+fv;local dE,dF=getDistanceDisplayString(orbit.periapsis.altitude)cy[#cy+1]=e([[<text x="%f" y="%f">%s</text>]],c2,c3,dE..dF)c3=c3+fv;cy[#cy+1]=e([[<text x="%f" y="%f">%s</text>]],c2,c3,FormatTimeString(orbit.timeToPeriapsis))c3=c3+fv;cy[#cy+1]=e([[<text x="%f" y="%f">%s</text>]],c2,c3,getSpeedDisplayString(orbit.periapsis.speed))end;cy[#cy+1]=e([[<text class="txtorbbig" x="%f" y="%d">%s</text>]],fr+ft/2+fu,20+fu,planet.name)if orbit.period~=nil and orbit.periapsis~=nil and orbit.apoapsis~=nil and orbit.apoapsis.speed>1 then local fB=orbit.timeToApoapsis/orbit.period*2*math.pi;local fC=fw*math.cos(fB)local fD=fx*math.sin(fB)cy[#cy+1]=e('<circle cx="%f" cy="%f" r="5" stroke="white" stroke-width="3" fill="white" />',fr+ft/2+fC+fz+fu,fs+ft/2+fD+fu)end;cy[#cy+1]=[[</g>]]end end;function getDistanceDisplayString(ae)local fE=ae>100000;local bI,dF=""if fE then bI,dF=round(ae/1000/200,1),"SU"elseif ae<1000 then bI,dF=round(ae,1),"m"else bI,dF=round(ae/1000,1),"Km"end;return bI,dF end;function getDistanceDisplayString2(ae)local fE=ae>100000;local bI,dF=""if fE then bI,dF=round(ae/1000/200,2)," SU"elseif ae<1000 then bI,dF=round(ae,2)," M"else bI,dF=round(ae/1000,2)," KM"end;return bI,dF end;function getSpeedDisplayString(bX)return d(round(bX*3.6,0)+0.5).." km/h"end;function FormatTimeString(fF)local fG=0;local fH=0;local fI=0;if fF<60 then fF=d(fF)elseif fF<3600 then fG=d(fF/60)fF=d(fF%60)elseif fF<86400 then fH=d(fF/3600)fG=d(fF%3600/60)else fI=d(fF/86400)fH=d(fF%86400/3600)end;if fI>0 then return fI.."d "..fH.."h "elseif fH>0 then return fH.."h "..fG.."m "elseif fG>0 then return fG.."m "..fF.."s"elseif fF>0 then return fF.."s"else return"0s"end end;function getMagnitudeInDirection(dx,fJ)dx=vec3(dx)fJ=vec3(fJ):normalize()local bI=dx*fJ;return bI.x+bI.y+bI.z end;function UpdateAutopilotTarget()if AutopilotTargetIndex==0 then AutopilotTargetName="None"a6=nil;CustomTarget=nil;return true end;local fK=AtlasOrdered[AutopilotTargetIndex].index;local fL=b2[0][fK]if fL.center then AutopilotTargetName=fL.name;a6=b8[0][fK]if CustomTarget~=nil then if j()==0 then if system.updateData(widgetMaxBrakeTimeText,widgetMaxBrakeTime)~=1 then system.addDataToWidget(widgetMaxBrakeTimeText,widgetMaxBrakeTime)end;if system.updateData(widgetMaxBrakeDistanceText,widgetMaxBrakeDistance)~=1 then system.addDataToWidget(widgetMaxBrakeDistanceText,widgetMaxBrakeDistance)end;if system.updateData(widgetCurBrakeTimeText,widgetCurBrakeTime)~=1 then system.addDataToWidget(widgetCurBrakeTimeText,widgetCurBrakeTime)end;if system.updateData(widgetCurBrakeDistanceText,widgetCurBrakeDistance)~=1 then system.addDataToWidget(widgetCurBrakeDistanceText,widgetCurBrakeDistance)end;if system.updateData(widgetTrajectoryAltitudeText,widgetTrajectoryAltitude)~=1 then system.addDataToWidget(widgetTrajectoryAltitudeText,widgetTrajectoryAltitude)end end;if system.updateData(widgetMaxMassText,widgetMaxMass)~=1 then system.addDataToWidget(widgetMaxMassText,widgetMaxMass)end;if system.updateData(widgetTravelTimeText,widgetTravelTime)~=1 then system.addDataToWidget(widgetTravelTimeText,widgetTravelTime)end;if system.updateData(widgetTargetOrbitText,widgetTargetOrbit)~=1 then system.addDataToWidget(widgetTargetOrbitText,widgetTargetOrbit)end end;CustomTarget=nil else CustomTarget=fL;for _,bH in pairs(b8[0])do if bH.name==CustomTarget.planetname then a6=bH;AutopilotTargetName=CustomTarget.name;break end end;if system.updateData(widgetMaxMassText,widgetMaxMass)~=1 then system.addDataToWidget(widgetMaxMassText,widgetMaxMass)end;if system.updateData(widgetTravelTimeText,widgetTravelTime)~=1 then system.addDataToWidget(widgetTravelTimeText,widgetTravelTime)end end;if CustomTarget==nil then AutopilotTargetCoords=vec3(a6.center)else AutopilotTargetCoords=CustomTarget.position end;if a6.planetname~="Space"then if a6.hasAtmosphere then AutopilotTargetOrbit=math.floor(a6.radius*(TargetOrbitRadius-1)+a6.noAtmosphericDensityAltitude)else AutopilotTargetOrbit=math.floor(a6.radius*(TargetOrbitRadius-1)+a6.surfaceMaxAltitude)end else AutopilotTargetOrbit=1000 end;if CustomTarget~=nil and CustomTarget.planetname=="Space"then AutopilotEndSpeed=0 else _,AutopilotEndSpeed=bb(a6):escapeAndOrbitalSpeed(AutopilotTargetOrbit)end;AutopilotPlanetGravity=0;AutopilotAccelerating=false;AutopilotBraking=false;AutopilotCruising=false;Autopilot=false;AutopilotRealigned=false;AutopilotStatus="Aligning"return true end;function IncrementAutopilotTargetIndex()AutopilotTargetIndex=AutopilotTargetIndex+1;if AutopilotTargetIndex>#AtlasOrdered then AutopilotTargetIndex=0 end;if AutopilotTargetIndex==0 then UpdateAutopilotTarget()else local fK=AtlasOrdered[AutopilotTargetIndex].index;local fL=b2[0][fK]if fL.name=="Space"then IncrementAutopilotTargetIndex()else UpdateAutopilotTarget()end end end;function DecrementAutopilotTargetIndex()AutopilotTargetIndex=AutopilotTargetIndex-1;if AutopilotTargetIndex<0 then AutopilotTargetIndex=#AtlasOrdered end;if AutopilotTargetIndex==0 then UpdateAutopilotTarget()else local fK=AtlasOrdered[AutopilotTargetIndex].index;local fL=b2[0][fK]if fL.name=="Space"then DecrementAutopilotTargetIndex()else UpdateAutopilotTarget()end end end;function GetAutopilotMaxMass()local fM=LastMaxBrakeInAtmo/a6:getGravity(a6.center+vec3(0,0,1)*a6.radius):len()return fM end;function GetAutopilotTravelTime()if not Autopilot then if CustomTarget==nil or CustomTarget.planetname~=planet.name then AutopilotDistance=(a6.center-vec3(core.getConstructWorldPos())):len()else AutopilotDistance=(CustomTarget.position-vec3(core.getConstructWorldPos())):len()end end;local bf=core.getWorldVelocity()local bX=vec3(bf):len()local fN=unit.getThrottle()/100;if AtmoSpeedAssist then fN=z end;local fO,fP=b9.computeDistanceAndTime(vec3(bf):len(),MaxGameVelocity,n(),Nav:maxForceForward()*fN,warmup,0)local a2,a3;if not TurnBurn then a2,a3=GetAutopilotBrakeDistanceAndTime(MaxGameVelocity)else a2,a3=GetAutopilotTBBrakeDistanceAndTime(MaxGameVelocity)end;local _,fQ;if not TurnBurn and bX>0 then _,fQ=GetAutopilotBrakeDistanceAndTime(bX)else _,fQ=GetAutopilotTBBrakeDistanceAndTime(bX)end;local fR=0;local fS=0;if AutopilotCruising or not Autopilot and bX>5 then fS=b9.computeTravelTime(bX,0,AutopilotDistance)elseif a2+fO<AutopilotDistance then fR=AutopilotDistance-(a2+fO)fS=b9.computeTravelTime(8333.0556,0,fR)else local fT=(AutopilotDistance-a2)/fO;fO=AutopilotDistance-a2;fP=fP*fT end;if CustomTarget~=nil and CustomTarget.planetname==planet.name and not Autopilot then return fS elseif AutopilotBraking then return fQ elseif AutopilotCruising then return fS+fQ else return fP+a3+fS end end;function GetAutopilotBrakeDistanceAndTime(bX)if not ao then RefreshLastMaxBrake()return b9.computeDistanceAndTime(bX,AutopilotEndSpeed,n(),0,0,LastMaxBrake-AutopilotPlanetGravity*n())else if LastMaxBrakeInAtmo and LastMaxBrakeInAtmo>0 then return b9.computeDistanceAndTime(bX,AutopilotEndSpeed,n(),0,0,LastMaxBrakeInAtmo-AutopilotPlanetGravity*n())else return 0,0 end end end;function GetAutopilotTBBrakeDistanceAndTime(bX)RefreshLastMaxBrake()return b9.computeDistanceAndTime(bX,AutopilotEndSpeed,n(),Nav:maxForceForward(),warmup,LastMaxBrake-AutopilotPlanetGravity*n())end;function hoverDetectGround()local fU=-1;local fV=-1;if vBooster then fU=vBooster.distance()end;if hover then fV=hover.distance()end;if fU~=-1 and fV~=-1 then if fU<fV then return fU else return fV end elseif fU~=-1 then return fU elseif fV~=-1 then return fV else return-1 end end;function AboveGroundLevel()local fW=-1;local fX=hoverDetectGround()if telemeter_1 then fW=telemeter_1.getDistance()end;if fX~=-1 and fW~=-1 then if fX<fW then return fX else return fW end elseif fX~=-1 then return fX else return fW end end;function tablelength(fY)local fZ=0;for _ in pairs(fY)do fZ=fZ+1 end;return fZ end;function BeginProfile(f_)ProfileTimeStart=system.getTime()end;function EndProfile(f_)local g0=system.getTime()-ProfileTimeStart;ProfileTimeSum=ProfileTimeSum+g0;ProfileCount=ProfileCount+1;if g0>ProfileTimeMax then ProfileTimeMax=g0 end;if g0<ProfileTimeMin then ProfileTimeMin=g0 end end;function ResetProfiles()ProfileTimeMin=9999;ProfileTimeMax=0;ProfileCount=0;ProfileTimeSum=0 end;function ReportProfiling()local g1=ProfileTimeSum;local g2=ProfileTimeSum/ProfileCount;local g3=ProfileTimeMin;local g4=ProfileTimeMax;local g5=ProfileCount;c(e("SUM: %.4f AVG: %.4f MIN: %.4f MAX: %.4f CNT: %d",g1,g2,g3,g4,g5))end;function updateWeapons()if weapon then if WeaponPanelID==nil and(radarPanelID~=nil or GearExtended)then _autoconf.displayCategoryPanel(weapon,weapon_size,L_TEXT("ui_lua_widget_weapon", "Weapons"),"weapon",true)WeaponPanelID=_autoconf.panels[_autoconf.panels_size]elseif WeaponPanelID~=nil and radarPanelID==nil and not GearExtended then system.destroyWidgetPanel(WeaponPanelID)WeaponPanelID=nil end end end;function updateRadar()if radar_1 then local g6=radar_1.getEntries()local g7=radar_1.getData()local g8=ConvertResolutionX(1770)local g9=ConvertResolutionY(330)if#g6>0 then local ga=g7:find('identifiedConstructs":%[%]')if ga==nil and perisPanelID==nil then ah=1;ToggleRadarPanel()end;if ga~=nil and perisPanelID~=nil then ToggleRadarPanel()end;if radarPanelID==nil then ToggleRadarPanel()end;af=e([[<text class="pbright txtbig txtmid" x="%d" y="%d">Radar: %i contacts</text>]],g8,g9,#g6)local gb={}for bG,bH in pairs(g6)do if radar_1.hasMatchingTransponder(bH)==1 then table.insert(gb,bH)end end;if#gb>0 then local c3=ConvertResolutionY(15)local c2=ConvertResolutionX(1370)af=e([[%s<text class="pbright txtbig txtmid" x="%d" y="%d">Friendlies In Range</text>]],af,c2,c3)for bG,bH in pairs(gb)do c3=c3+20;af=e([[%s<text class="pdim txtmid" x="%d" y="%d">%s</text>]],af,c2,c3,radar_1.getConstructName(bH))end end else local gc;gc=g7:find('worksInEnvironment":false')if gc then af=e([[
                            <text class="pbright txtbig txtmid" x="%d" y="%d">Radar: Jammed</text>]],g8,g9)else af=e([[
                            <text class="pbright txtbig txtmid" x="%d" y="%d">Radar: No Contacts</text>]],g8,g9)end;if radarPanelID~=nil then ah=0;ToggleRadarPanel()end end end end;function DisplayMessage(cy,dE)if dE~="empty"then cy[#cy+1]=[[<text class="msg" x="50%%" y="310" >]]for gd in string.gmatch(dE,"([^\n]+)")do cy[#cy+1]=e([[<tspan x="50%%" dy="35">%s</tspan>]],gd)end;cy[#cy+1]=[[</text>]]end;if ad~=0 then unit.setTimer("msgTick",ad)ad=0 end end;function updateDistance()local bQ=system.getTime()local bf=vec3(core.getWorldVelocity())local d_=vec3(bf):len()local ge=bQ-ar;if d_>1.38889 then d_=d_/1000;local gf=d_*(bQ-ar)TotalDistanceTravelled=TotalDistanceTravelled+gf;a7=a7+gf end;a8=a8+ge;TotalFlightTime=TotalFlightTime+ge;ar=bQ end;function composeAxisAccelerationFromTargetSpeedV(gg,gh)local gi=vec3()local gj=vec3()if gg==axisCommandId.longitudinal then gi=vec3(core.getConstructOrientationForward())gj=vec3(core.getConstructWorldOrientationForward())elseif gg==axisCommandId.vertical then gi=vec3(core.getConstructOrientationUp())gj=vec3(core.getConstructWorldOrientationUp())elseif gg==axisCommandId.lateral then gi=vec3(core.getConstructOrientationRight())gj=vec3(core.getConstructWorldOrientationRight())else return vec3()end;local gk=vec3(core.getWorldGravity())local gl=gk:dot(gj)local gm=vec3(core.getWorldAirFrictionAcceleration())local gn=gm:dot(gj)local go=vec3(core.getVelocity())local gp=go:dot(gi)local gq=gh*constants.kph2m;if targetSpeedPID2==nil then targetSpeedPID2=pid.new(10,0,10.0)end;targetSpeedPID2:inject(gq-gp)local gr=targetSpeedPID2:get()local gs=(gr-gn-gl)*gj;return gs end;function composeAxisAccelerationFromTargetSpeed(gg,gh)local gi=vec3()local gj=vec3()if gg==axisCommandId.longitudinal then gi=vec3(core.getConstructOrientationForward())gj=vec3(core.getConstructWorldOrientationForward())elseif gg==axisCommandId.vertical then gi=vec3(core.getConstructOrientationUp())gj=vec3(core.getConstructWorldOrientationUp())elseif gg==axisCommandId.lateral then gi=vec3(core.getConstructOrientationRight())gj=vec3(core.getConstructWorldOrientationRight())else return vec3()end;local gk=vec3(core.getWorldGravity())local gl=gk:dot(gj)local gm=vec3(core.getWorldAirFrictionAcceleration())local gn=gm:dot(gj)local go=vec3(core.getVelocity())local gp=go:dot(gi)local gq=gh*constants.kph2m;if targetSpeedPID==nil then targetSpeedPID=pid.new(10,0,10.0)end;targetSpeedPID:inject(gq-gp)local gr=targetSpeedPID:get()local gs=(gr-gn-gl)*gj;return gs end;function Atlas()return{[0]={[0]={GM=0,bodyId=0,center={x=0,y=0,z=0},name='Space',planetarySystemId=0,radius=0,hasAtmosphere=false,gravity=0,noAtmosphericDensityAltitude=0,surfaceMaxAltitude=0},[2]={name="Alioth",description="Alioth is the planet selected by the arkship for landfall; it is a typical goldilocks planet where humanity may rebuild in the coming decades. The arkship geological survey reports mountainous regions alongside deep seas and lush forests. This is where it all starts.",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0.9401,atmosphericEngineMaxAltitude=5580,biosphere="Forest",classification="Mesoplanet",bodyId=2,GM=157470826617,gravity=1.0082568597356114,fullAtmosphericDensityMaxAltitude=-10,habitability="High",hasAtmosphere=true,isSanctuary=false,noAtmosphericDensityAltitude=6272,numSatellites=2,positionFromSun=2,center={x=-8,y=-8,z=-126303},radius=126067.8984375,safeAreaEdgeAltitude=500000,size="M",spaceEngineMinAltitude=3410,surfaceArea=199718780928,surfaceAverageAltitude=200,surfaceMaxAltitude=1100,surfaceMinAltitude=-330,systemZone="High",territories=259472,type="Planet",waterLevel=0,planetarySystemId=0},[21]={name="Alioth Moon 1",description="",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0,atmosphericEngineMaxAltitude=0,biosphere="",classification="",bodyId=21,GM=2118960000,gravity=0.24006116402380084,fullAtmosphericDensityMaxAltitude=0,habitability="",hasAtmosphere=false,isSanctuary=false,noAtmosphericDensityAltitude=0,numSatellites=0,positionFromSun=0,center={x=457933,y=-1509011,z=115524},radius=30000,safeAreaEdgeAltitude=500000,size="M",spaceEngineMinAltitude=0,surfaceArea=11309733888,surfaceAverageAltitude=140,surfaceMaxAltitude=200,surfaceMinAltitude=10,systemZone=nil,territories=14522,type="",waterLevel=nil,planetarySystemId=0},[22]={name="Alioth Moon 4",description="",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0,atmosphericEngineMaxAltitude=0,biosphere="",classification="",bodyId=22,GM=2165833514,gravity=0.2427018259886451,fullAtmosphericDensityMaxAltitude=0,habitability="",hasAtmosphere=false,isSanctuary=false,noAtmosphericDensityAltitude=0,numSatellites=0,positionFromSun=0,center={x=-1692694,y=729681,z=-411464},radius=30330,safeAreaEdgeAltitude=500000,size="L",spaceEngineMinAltitude=0,surfaceArea=11559916544,surfaceAverageAltitude=-15,surfaceMaxAltitude=-5,surfaceMinAltitude=-50,systemZone=nil,territories=14522,type="",waterLevel=nil,planetarySystemId=0},[5]={name="Feli",description="Feli is easily identified by its massive and deep crater. Outside of the crater, the arkship geological survey reports a fairly bland and uniform planet, it also cannot explain the existence of the crater. Feli is particular for having an extremely small atmosphere, allowing life to develop in the deeper areas of its crater but limiting it drastically on the actual surface.",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0.5488,atmosphericEngineMaxAltitude=66725,biosphere="Barren",classification="Mesoplanet",bodyId=5,GM=16951680000,gravity=0.4801223280476017,fullAtmosphericDensityMaxAltitude=30,habitability="Low",hasAtmosphere=true,isSanctuary=false,noAtmosphericDensityAltitude=78500,numSatellites=1,positionFromSun=5,center={x=-43534464,y=22565536,z=-48934464},radius=41800,safeAreaEdgeAltitude=500000,size="S",spaceEngineMinAltitude=42800,surfaceArea=21956466688,surfaceAverageAltitude=18300,surfaceMaxAltitude=18500,surfaceMinAltitude=46,systemZone="Low",territories=27002,type="Planet",waterLevel=nil,planetarySystemId=0},[50]={name="Feli Moon 1",description="",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0,atmosphericEngineMaxAltitude=0,biosphere="",classification="",bodyId=50,GM=499917600,gravity=0.11202853997062348,fullAtmosphericDensityMaxAltitude=0,habitability="",hasAtmosphere=false,isSanctuary=false,noAtmosphericDensityAltitude=0,numSatellites=0,positionFromSun=0,center={x=-43902841.78,y=22261034.7,z=-48862386},radius=14000,safeAreaEdgeAltitude=500000,size="S",spaceEngineMinAltitude=0,surfaceArea=2463008768,surfaceAverageAltitude=800,surfaceMaxAltitude=900,surfaceMinAltitude=0,systemZone=nil,territories=3002,type="",waterLevel=nil,planetarySystemId=0},[120]={name="Ion",description="Ion is nothing more than an oversized ice cube frozen through and through. It is a largely inhospitable planet due to its extremely low temperatures. The arkship geological survey reports extremely rough mountainous terrain with little habitable land.",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0.9522,atmosphericEngineMaxAltitude=10480,biosphere="Ice",classification="Hypopsychroplanet",bodyId=120,GM=7135606629,gravity=0.36009174603570127,fullAtmosphericDensityMaxAltitude=-30,habitability="Average",hasAtmosphere=true,isSanctuary=false,noAtmosphericDensityAltitude=17700,numSatellites=2,positionFromSun=12,center={x=2865536.7,y=-99034464,z=-934462.02},radius=44950,safeAreaEdgeAltitude=500000,size="XS",spaceEngineMinAltitude=6410,surfaceArea=25390383104,surfaceAverageAltitude=500,surfaceMaxAltitude=1300,surfaceMinAltitude=250,systemZone="Average",territories=32672,type="Planet",waterLevel=nil,planetarySystemId=0},[121]={name="Ion Moon 1",description="",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0,atmosphericEngineMaxAltitude=0,biosphere="",classification="",bodyId=121,GM=106830900,gravity=0.08802242599860607,fullAtmosphericDensityMaxAltitude=0,habitability="",hasAtmosphere=false,isSanctuary=false,noAtmosphericDensityAltitude=0,numSatellites=0,positionFromSun=0,center={x=2472916.8,y=-99133747,z=-1133582.8},radius=11000,safeAreaEdgeAltitude=500000,size="XS",spaceEngineMinAltitude=0,surfaceArea=1520530944,surfaceAverageAltitude=100,surfaceMaxAltitude=200,surfaceMinAltitude=3,systemZone=nil,territories=1922,type="",waterLevel=nil,planetarySystemId=0},[122]={name="Ion Moon 2",description="",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0,atmosphericEngineMaxAltitude=0,biosphere="",classification="",bodyId=122,GM=176580000,gravity=0.12003058201190042,fullAtmosphericDensityMaxAltitude=0,habitability="",hasAtmosphere=false,isSanctuary=false,noAtmosphericDensityAltitude=0,numSatellites=0,positionFromSun=0,center={x=2995424.5,y=-99275010,z=-1378480.7},radius=15000,safeAreaEdgeAltitude=500000,size="XS",spaceEngineMinAltitude=0,surfaceArea=2827433472,surfaceAverageAltitude=-1900,surfaceMaxAltitude=-1400,surfaceMinAltitude=-2100,systemZone=nil,territories=3632,type="",waterLevel=nil,planetarySystemId=0},[9]={name="Jago",description="Jago is a water planet. The large majority of the planet&apos;s surface is covered by large oceans dotted by small areas of landmass across the planet. The arkship geological survey reports deep seas across the majority of the planet with sub 15 percent coverage of solid ground.",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0.9835,atmosphericEngineMaxAltitude=9695,biosphere="Water",classification="Mesoplanet",bodyId=9,GM=18606274330,gravity=0.5041284298678057,fullAtmosphericDensityMaxAltitude=-90,habitability="Very High",hasAtmosphere=true,isSanctuary=false,noAtmosphericDensityAltitude=10900,numSatellites=0,positionFromSun=9,center={x=-94134462,y=12765534,z=-3634464},radius=61590,safeAreaEdgeAltitude=500000,size="XL",spaceEngineMinAltitude=5900,surfaceArea=47668367360,surfaceAverageAltitude=0,surfaceMaxAltitude=1200,surfaceMinAltitude=-500,systemZone="Very High",territories=60752,type="Planet",waterLevel=0,planetarySystemId=0},[100]={name="Lacobus",description="Lacobus is an ice planet that also features large bodies of water. The arkship geological survey reports deep oceans alongside a frozen and rough mountainous environment. Lacobus seems to feature regional geothermal activity allowing for the presence of water on the surface.",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0.7571,atmosphericEngineMaxAltitude=11120,biosphere="Ice",classification="Psychroplanet",bodyId=100,GM=13975172474,gravity=0.45611622622739767,fullAtmosphericDensityMaxAltitude=-20,habitability="Average",hasAtmosphere=true,isSanctuary=false,noAtmosphericDensityAltitude=12510,numSatellites=3,positionFromSun=10,center={x=98865536,y=-13534464,z=-934461.99},radius=55650,safeAreaEdgeAltitude=500000,size="M",spaceEngineMinAltitude=6790,surfaceArea=38917074944,surfaceAverageAltitude=800,surfaceMaxAltitude=1660,surfaceMinAltitude=250,systemZone="Average",territories=50432,type="Planet",waterLevel=0,planetarySystemId=0},[102]={name="Lacobus Moon 1",description="",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0,atmosphericEngineMaxAltitude=0,biosphere="",classification="",bodyId=102,GM=444981600,gravity=0.14403669598391783,fullAtmosphericDensityMaxAltitude=0,habitability="",hasAtmosphere=false,isSanctuary=false,noAtmosphericDensityAltitude=0,numSatellites=0,positionFromSun=0,center={x=99180968,y=-13783862,z=-926156.4},radius=18000,safeAreaEdgeAltitude=500000,size="XL",spaceEngineMinAltitude=0,surfaceArea=4071504128,surfaceAverageAltitude=150,surfaceMaxAltitude=300,surfaceMinAltitude=10,systemZone=nil,territories=5072,type="",waterLevel=nil,planetarySystemId=0},[103]={name="Lacobus Moon 2",description="",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0,atmosphericEngineMaxAltitude=0,biosphere="",classification="",bodyId=103,GM=211503600,gravity=0.11202853997062348,fullAtmosphericDensityMaxAltitude=0,habitability="",hasAtmosphere=false,isSanctuary=false,noAtmosphericDensityAltitude=0,numSatellites=0,positionFromSun=0,center={x=99250052,y=-13629215,z=-1059341.4},radius=14000,safeAreaEdgeAltitude=500000,size="M",spaceEngineMinAltitude=0,surfaceArea=2463008768,surfaceAverageAltitude=-1380,surfaceMaxAltitude=-1280,surfaceMinAltitude=-1880,systemZone=nil,territories=3002,type="",waterLevel=nil,planetarySystemId=0},[101]={name="Lacobus Moon 3",description="",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0,atmosphericEngineMaxAltitude=0,biosphere="",classification="",bodyId=101,GM=264870000,gravity=0.12003058201190042,fullAtmosphericDensityMaxAltitude=0,habitability="",hasAtmosphere=false,isSanctuary=false,noAtmosphericDensityAltitude=0,numSatellites=0,positionFromSun=0,center={x=98905288.17,y=-13950921.1,z=-647589.53},radius=15000,safeAreaEdgeAltitude=500000,size="L",spaceEngineMinAltitude=0,surfaceArea=2827433472,surfaceAverageAltitude=500,surfaceMaxAltitude=820,surfaceMinAltitude=3,systemZone=nil,territories=3632,type="",waterLevel=nil,planetarySystemId=0},[1]={name="Madis",description="Madis is a barren wasteland of a rock; it sits closest to the sun and temperatures reach extreme highs during the day. The arkship geological survey reports long rocky valleys intermittently separated by small ravines.",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0.8629,atmosphericEngineMaxAltitude=7165,biosphere="Barren",classification="hyperthermoplanet",bodyId=1,GM=6930729684,gravity=0.36009174603570127,fullAtmosphericDensityMaxAltitude=220,habitability="Low",hasAtmosphere=true,isSanctuary=false,noAtmosphericDensityAltitude=8050,numSatellites=3,positionFromSun=1,center={x=17465536,y=22665536,z=-34464},radius=44300,safeAreaEdgeAltitude=500000,size="XS",spaceEngineMinAltitude=4480,surfaceArea=24661377024,surfaceAverageAltitude=750,surfaceMaxAltitude=850,surfaceMinAltitude=670,systemZone="Low",territories=30722,type="Planet",waterLevel=nil,planetarySystemId=0},[10]={name="Madis Moon 1",description="",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0,atmosphericEngineMaxAltitude=0,biosphere="",classification="",bodyId=10,GM=78480000,gravity=0.08002039003323584,fullAtmosphericDensityMaxAltitude=0,habitability="",hasAtmosphere=false,isSanctuary=false,noAtmosphericDensityAltitude=0,numSatellites=0,positionFromSun=0,center={x=17448118.224,y=22966846.286,z=143078.82},radius=10000,safeAreaEdgeAltitude=500000,size="XL",spaceEngineMinAltitude=0,surfaceArea=1256637056,surfaceAverageAltitude=210,surfaceMaxAltitude=420,surfaceMinAltitude=0,systemZone=nil,territories=1472,type="",waterLevel=nil,planetarySystemId=0},[11]={name="Madis Moon 2",description="",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0,atmosphericEngineMaxAltitude=0,biosphere="",classification="",bodyId=11,GM=237402000,gravity=0.09602446196397631,fullAtmosphericDensityMaxAltitude=0,habitability="",hasAtmosphere=false,isSanctuary=false,noAtmosphericDensityAltitude=0,numSatellites=0,positionFromSun=0,center={x=17194626,y=22243633.88,z=-214962.81},radius=12000,safeAreaEdgeAltitude=500000,size="S",spaceEngineMinAltitude=0,surfaceArea=1809557376,surfaceAverageAltitude=-700,surfaceMaxAltitude=300,surfaceMinAltitude=-2900,systemZone=nil,territories=1922,type="",waterLevel=nil,planetarySystemId=0},[12]={name="Madis Moon 3",description="",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0,atmosphericEngineMaxAltitude=0,biosphere="",classification="",bodyId=12,GM=265046609,gravity=0.12003058201190042,fullAtmosphericDensityMaxAltitude=0,habitability="",hasAtmosphere=false,isSanctuary=false,noAtmosphericDensityAltitude=0,numSatellites=0,positionFromSun=0,center={x=17520614,y=22184730,z=-309989.99},radius=15000,safeAreaEdgeAltitude=500000,size="S",spaceEngineMinAltitude=0,surfaceArea=2827433472,surfaceAverageAltitude=700,surfaceMaxAltitude=1100,surfaceMinAltitude=0,systemZone=nil,territories=3632,type="",waterLevel=nil,planetarySystemId=0},[26]={name="Sanctuary",description="",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0.9666,atmosphericEngineMaxAltitude=6935,biosphere="",classification="",bodyId=26,GM=68234043600,gravity=1.0000000427743831,fullAtmosphericDensityMaxAltitude=-30,habitability="",hasAtmosphere=true,isSanctuary=true,noAtmosphericDensityAltitude=7800,numSatellites=0,positionFromSun=0,center={x=-1404835,y=562655,z=-285074},radius=83400,safeAreaEdgeAltitude=0,size="L",spaceEngineMinAltitude=4230,surfaceArea=87406149632,surfaceAverageAltitude=80,surfaceMaxAltitude=500,surfaceMinAltitude=-60,systemZone=nil,territories=111632,type="",waterLevel=0,planetarySystemId=0},[6]={name="Sicari",description="Sicari is a typical desert planet; it has survived for millenniums and will continue to endure. While not the most habitable of environments it remains a relatively untouched and livable planet of the Alioth sector. The arkship geological survey reports large flatlands alongside steep plateaus.",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0.897,atmosphericEngineMaxAltitude=7725,biosphere="Desert",classification="Mesoplanet",bodyId=6,GM=10502547741,gravity=0.4081039739797361,fullAtmosphericDensityMaxAltitude=-625,habitability="Average",hasAtmosphere=true,isSanctuary=false,noAtmosphericDensityAltitude=8770,numSatellites=0,positionFromSun=6,center={x=52765536,y=27165538,z=52065535},radius=51100,safeAreaEdgeAltitude=500000,size="M",spaceEngineMinAltitude=4480,surfaceArea=32813432832,surfaceAverageAltitude=130,surfaceMaxAltitude=220,surfaceMinAltitude=50,systemZone="Average",territories=41072,type="Planet",waterLevel=nil,planetarySystemId=0},[7]={name="Sinnen",description="Sinnen is a an empty and rocky hell. With no atmosphere to speak of it is one of the least hospitable planets in the sector. The arkship geological survey reports mostly flatlands alongside deep ravines which look to have once been riverbeds. This planet simply looks to have dried up and died, likely from solar winds.",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0.9226,atmosphericEngineMaxAltitude=10335,biosphere="Desert",classification="Mesoplanet",bodyId=7,GM=13033380591,gravity=0.4401121421448438,fullAtmosphericDensityMaxAltitude=-120,habitability="Average",hasAtmosphere=true,isSanctuary=false,noAtmosphericDensityAltitude=11620,numSatellites=1,positionFromSun=7,center={x=58665538,y=29665535,z=58165535},radius=54950,safeAreaEdgeAltitude=500000,size="S",spaceEngineMinAltitude=6270,surfaceArea=37944188928,surfaceAverageAltitude=317,surfaceMaxAltitude=360,surfaceMinAltitude=23,systemZone="Average",territories=48002,type="Planet",waterLevel=nil,planetarySystemId=0},[70]={name="Sinnen Moon 1",description="",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0,atmosphericEngineMaxAltitude=0,biosphere="",classification="",bodyId=70,GM=396912600,gravity=0.1360346539426409,fullAtmosphericDensityMaxAltitude=0,habitability="",hasAtmosphere=false,isSanctuary=false,noAtmosphericDensityAltitude=0,numSatellites=0,positionFromSun=0,center={x=58969616,y=29797945,z=57969449},radius=17000,safeAreaEdgeAltitude=500000,size="S",spaceEngineMinAltitude=0,surfaceArea=3631681280,surfaceAverageAltitude=-2050,surfaceMaxAltitude=-1950,surfaceMinAltitude=-2150,systemZone=nil,territories=4322,type="",waterLevel=nil,planetarySystemId=0},[110]={name="Symeon",description="Symeon is an ice planet mysteriously split at the equator by a band of solid desert. Exactly how this phenomenon is possible is unclear but some sort of weather anomaly may be responsible. The arkship geological survey reports a fairly diverse mix of flat-lands alongside mountainous formations.",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0.9559,atmosphericEngineMaxAltitude=6920,biosphere="Ice, Desert",classification="Hybrid",bodyId=110,GM=9204742375,gravity=0.3920998898971822,fullAtmosphericDensityMaxAltitude=-30,habitability="High",hasAtmosphere=true,isSanctuary=false,noAtmosphericDensityAltitude=7800,numSatellites=0,positionFromSun=11,center={x=14165536,y=-85634465,z=-934464.3},radius=49050,safeAreaEdgeAltitude=500000,size="S",spaceEngineMinAltitude=4230,surfaceArea=30233462784,surfaceAverageAltitude=39,surfaceMaxAltitude=450,surfaceMinAltitude=126,systemZone="High",territories=38882,type="Planet",waterLevel=nil,planetarySystemId=0},[4]={name="Talemai",description="Talemai is a planet in the final stages of an Ice Age. It seems likely that the planet was thrown into tumult by a cataclysmic volcanic event which resulted in its current state. The arkship geological survey reports large mountainous regions across the entire planet.",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0.8776,atmosphericEngineMaxAltitude=9685,biosphere="Barren",classification="Psychroplanet",bodyId=4,GM=14893847582,gravity=0.4641182439650478,fullAtmosphericDensityMaxAltitude=-78,habitability="Average",hasAtmosphere=true,isSanctuary=false,noAtmosphericDensityAltitude=10890,numSatellites=3,positionFromSun=4,center={x=-13234464,y=55765536,z=465536},radius=57500,safeAreaEdgeAltitude=500000,size="M",spaceEngineMinAltitude=5890,surfaceArea=41547563008,surfaceAverageAltitude=580,surfaceMaxAltitude=610,surfaceMinAltitude=520,systemZone="Average",territories=52922,type="Planet",waterLevel=nil,planetarySystemId=0},[42]={name="Talemai Moon 1",description="",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0,atmosphericEngineMaxAltitude=0,biosphere="",classification="",bodyId=42,GM=264870000,gravity=0.12003058201190042,fullAtmosphericDensityMaxAltitude=0,habitability="",hasAtmosphere=false,isSanctuary=false,noAtmosphericDensityAltitude=0,numSatellites=0,positionFromSun=0,center={x=-13058408,y=55781856,z=740177.76},radius=15000,safeAreaEdgeAltitude=500000,size="M",spaceEngineMinAltitude=0,surfaceArea=2827433472,surfaceAverageAltitude=720,surfaceMaxAltitude=850,surfaceMinAltitude=0,systemZone=nil,territories=3632,type="",waterLevel=nil,planetarySystemId=0},[40]={name="Talemai Moon 2",description="",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0,atmosphericEngineMaxAltitude=0,biosphere="",classification="",bodyId=40,GM=141264000,gravity=0.09602446196397631,fullAtmosphericDensityMaxAltitude=0,habitability="",hasAtmosphere=false,isSanctuary=false,noAtmosphericDensityAltitude=0,numSatellites=0,positionFromSun=0,center={x=-13503090,y=55594325,z=769838.64},radius=12000,safeAreaEdgeAltitude=500000,size="S",spaceEngineMinAltitude=0,surfaceArea=1809557376,surfaceAverageAltitude=250,surfaceMaxAltitude=450,surfaceMinAltitude=0,systemZone=nil,territories=1922,type="",waterLevel=nil,planetarySystemId=0},[41]={name="Talemai Moon 3",description="",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0,atmosphericEngineMaxAltitude=0,biosphere="",classification="",bodyId=41,GM=106830900,gravity=0.08802242599860607,fullAtmosphericDensityMaxAltitude=0,habitability="",hasAtmosphere=false,isSanctuary=false,noAtmosphericDensityAltitude=0,numSatellites=0,positionFromSun=0,center={x=-12800515,y=55700259,z=325207.84},radius=11000,safeAreaEdgeAltitude=500000,size="XS",spaceEngineMinAltitude=0,surfaceArea=1520530944,surfaceAverageAltitude=190,surfaceMaxAltitude=400,surfaceMinAltitude=0,systemZone=nil,territories=1922,type="",waterLevel=nil,planetarySystemId=0},[8]={name="Teoma",description="[REDACTED] The arkship geological survey [REDACTED]. This planet should not be here.",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0.7834,atmosphericEngineMaxAltitude=5580,biosphere="Forest",classification="Mesoplanet",bodyId=8,GM=18477723600,gravity=0.48812434578525177,fullAtmosphericDensityMaxAltitude=15,habitability="High",hasAtmosphere=true,isSanctuary=false,noAtmosphericDensityAltitude=6280,numSatellites=0,positionFromSun=8,center={x=80865538,y=54665536,z=-934463.94},radius=62000,safeAreaEdgeAltitude=500000,size="L",spaceEngineMinAltitude=3420,surfaceArea=48305131520,surfaceAverageAltitude=700,surfaceMaxAltitude=1100,surfaceMinAltitude=-200,systemZone="High",territories=60752,type="Planet",waterLevel=0,planetarySystemId=0},[3]={name="Thades",description="Thades is a scorched desert planet. Perhaps it was once teaming with life but now all that remains is ash and dust. The arkship geological survey reports a rocky mountainous planet bisected by a massive unnatural ravine; something happened to this planet.",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0.03552,atmosphericEngineMaxAltitude=32180,biosphere="Desert",classification="Thermoplanet",bodyId=3,GM=11776905000,gravity=0.49612641213015557,fullAtmosphericDensityMaxAltitude=150,habitability="Low",hasAtmosphere=true,isSanctuary=false,noAtmosphericDensityAltitude=32800,numSatellites=2,positionFromSun=3,center={x=29165536,y=10865536,z=65536},radius=49000,safeAreaEdgeAltitude=500000,size="M",spaceEngineMinAltitude=21400,surfaceArea=30171856896,surfaceAverageAltitude=13640,surfaceMaxAltitude=13690,surfaceMinAltitude=370,systemZone="Low",territories=38882,type="Planet",waterLevel=nil,planetarySystemId=0},[30]={name="Thades Moon 1",description="",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0,atmosphericEngineMaxAltitude=0,biosphere="",classification="",bodyId=30,GM=211564034,gravity=0.11202853997062348,fullAtmosphericDensityMaxAltitude=0,habitability="",hasAtmosphere=false,isSanctuary=false,noAtmosphericDensityAltitude=0,numSatellites=0,positionFromSun=0,center={x=29214402,y=10907080.695,z=433858.2},radius=14000,safeAreaEdgeAltitude=500000,size="M",spaceEngineMinAltitude=0,surfaceArea=2463008768,surfaceAverageAltitude=60,surfaceMaxAltitude=300,surfaceMinAltitude=0,systemZone=nil,territories=3002,type="",waterLevel=nil,planetarySystemId=0},[31]={name="Thades Moon 2",description="",antiGravMinAltitude=1000,atmosphericDensityAboveSurface=0,atmosphericEngineMaxAltitude=0,biosphere="",classification="",bodyId=31,GM=264870000,gravity=0.12003058201190042,fullAtmosphericDensityMaxAltitude=0,habitability="",hasAtmosphere=false,isSanctuary=false,noAtmosphericDensityAltitude=0,numSatellites=0,positionFromSun=0,center={x=29404193,y=10432768,z=19554.131},radius=15000,safeAreaEdgeAltitude=500000,size="M",spaceEngineMinAltitude=0,surfaceArea=2827433472,surfaceAverageAltitude=70,surfaceMaxAltitude=350,surfaceMinAltitude=0,systemZone=nil,territories=3632,type="",waterLevel=nil,planetarySystemId=0}}}end;function SetupAtlas()b2=Atlas()for bG,bH in pairs(b2[0])do if aG==nil or bH.center.x<aG then aG=bH.center.x end;if aH==nil or bH.center.x>aH then aH=bH.center.x end;if aI==nil or bH.center.y<aI then aI=bH.center.y end;if aJ==nil or bH.center.y>aJ then aJ=bH.center.y end end;b3=""local gt=1.1*(aH-aG)/1920;local gu=1.4*(aJ-aI)/1080;for bG,bH in pairs(b2[0])do local c2=960+bH.center.x/gt;local c3=540+bH.center.y/gu;b3=b3 ..'<circle cx="'..c2 ..'" cy="'..c3 ..'" r="'..bH.radius/gt*30 ..'" stroke="white" stroke-width="3" fill="blue" />'if not string.match(bH.name,"Moon")and not string.match(bH.name,"Sanctuary")and not string.match(bH.name,"Space")then b3=b3 .."<text x='"..c2 .."' y='"..c3+bH.radius/gt*30+20 .."' font-size='28' fill="..au.." text-anchor='middle' font-family='Montserrat'>"..bH.name.."</text>"end end;local cl=vec3(core.getConstructWorldPos())local c2=960+cl.x/gt;local c3=540+cl.y/gu;b3=b3 ..'<circle cx="'..c2 ..'" cy="'..c3 ..'" r="5" stroke="white" stroke-width="3" fill="red"/>'b3=b3 .."<text x='"..c2 .."' y='"..c3-50 .."' font-size='36' fill='darkred' text-anchor='middle' font-family='Bank' font-weight='bold'>You Are Here</text>"b3=b3 ..[[</svg>]]b4=gt;b5=gu;if screen_2 then screen_2.setHTML('<svg width="100%" height="100%" viewBox="0 0 1920 1080">'..b3)local cl=vec3(core.getConstructWorldPos())local c2=960+cl.x/gt;local c3=540+cl.y/gu;b3='<svg><circle cx="80" cy="80" r="5" stroke="white" stroke-width="3" fill="red"/>'b3=b3 .."<text x='80' y='105' font-size='18' fill="..au.." text-anchor='middle' font-family='Montserrat''>You Are Here</text></svg>"b6=screen_2.addContent((c2-80)/19.20,(c3-80)/10.80,b3)end end;function PlanetRef()local function gv(gw)return type(gw)=='number'end;local function gx(gw)return type(tonumber(gw))=='number'end;local function gy(gz)return type(gz)=='table'end;local function gA(gB)return type(gB)=='string'end;local function gC(bH)return gy(bH)and gv(bH.x and bH.y and bH.z)end;local function gD(gE)return gy(gE)and gv(gE.latitude and gE.longitude and gE.altitude and gE.bodyId and gE.systemId)end;local gF=math.pi/180;local gG=180/math.pi;local epsilon=1e-10;local q=' *([+-]?%d+%.?%d*e?[+-]?%d*)'local cm='::pos{'..q..','..q..','..q..','..q..','..q..'}'local utils=require('cpml.utils')local vec3=require('cpml.vec3')local gH=utils.clamp;local function float_eq(cb,cc)if cb==0 then return math.abs(cc)<1e-09 end;if cc==0 then return math.abs(cb)<1e-09 end;return math.abs(cb-cc)<math.max(math.abs(cb),math.abs(cc))*epsilon end;local function gI(gw)local bI=string.gsub(string.reverse(e('%.4f',gw)),'^0*%.?','')return bI==''and'0'or string.reverse(bI)end;local function gJ(gK)if gC(gK)then return e('{x=%.3f,y=%.3f,z=%.3f}',gK.x,gK.y,gK.z)end;if gy(gK)and not getmetatable(gK)then local gL={}local gM=next(gK)if type(gM)=='nil'or gM==1 then gL=gK else for bG,bH in pairs(gK)do local ek=gJ(bH)if type(bG)=='number'then table.insert(gL,e('[%s]=%s',bG,ek))else table.insert(gL,e('%s=%s',bG,ek))end end end;return e('{%s}',table.concat(gL,','))end;if gA(gK)then return e("'%s'",gK:gsub("'",[[\']]))end;return tostring(gK)end;local gN={}gN.__index=gN;gN.__tostring=function(gK,gO)local gP={}for bG in pairs(gK)do table.insert(gP,bG)end;table.sort(gP)local gL={}for _,bG in ipairs(gP)do local ek=gJ(gK[bG])if type(bG)=='number'then table.insert(gL,e('[%s]=%s',bG,ek))else table.insert(gL,e('%s=%s',bG,ek))end end;if gO then return e('%s%s',gO,table.concat(gL,',\n'..gO))end;return e('{%s}',table.concat(gL,','))end;gN.__eq=function(gQ,gR)return gQ.planetarySystemId==gR.planetarySystemId and gQ.bodyId==gR.bodyId and float_eq(gQ.radius,gR.radius)and float_eq(gQ.center.x,gR.center.x)and float_eq(gQ.center.y,gR.center.y)and float_eq(gQ.center.z,gR.center.z)and float_eq(gQ.GM,gR.GM)end;local function gS(cn,co,gT,ce,gU)assert(gx(cn),'Argument 1 (planetarySystemId) must be a number:'..type(cn))assert(gx(co),'Argument 2 (bodyId) must be a number:'..type(co))assert(gx(gT),'Argument 3 (radius) must be a number:'..type(gT))assert(gy(ce),'Argument 4 (worldCoordinates) must be a array or vec3.'..type(ce))assert(gx(gU),'Argument 5 (GM) must be a number:'..type(gU))return setmetatable({planetarySystemId=tonumber(cn),bodyId=tonumber(co),radius=tonumber(gT),center=vec3(ce),GM=tonumber(gU)},gN)end;local MapPosition={}MapPosition.__index=MapPosition;MapPosition.__tostring=function(gV)return e('::pos{%d,%d,%s,%s,%s}',gV.systemId,gV.bodyId,gI(gV.latitude*gG),gI(gV.longitude*gG),gI(gV.altitude))end;MapPosition.__eq=function(gQ,gR)return gQ.bodyId==gR.bodyId and gQ.systemId==gR.systemId and float_eq(gQ.latitude,gR.latitude)and float_eq(gQ.altitude,gR.altitude)and(float_eq(gQ.longitude,gR.longitude)or float_eq(gQ.latitude,math.pi/2)or float_eq(gQ.latitude,-math.pi/2))end;local function gW(gX,co,ci,cj,ch)local cn=gX;if gA(gX)and not cj and not ch and not co and not ci then cn,co,ci,cj,ch=string.match(gX,cm)assert(cn,'Argument 1 (position string) is malformed.')else assert(gx(cn),'Argument 1 (systemId) must be a number:'..type(cn))assert(gx(co),'Argument 2 (bodyId) must be a number:'..type(co))assert(gx(ci),'Argument 3 (latitude) must be in degrees:'..type(ci))assert(gx(cj),'Argument 4 (longitude) must be in degrees:'..type(cj))assert(gx(ch),'Argument 5 (altitude) must be in meters:'..type(ch))end;cn=tonumber(cn)co=tonumber(co)ci=tonumber(ci)cj=tonumber(cj)ch=tonumber(ch)if co==0 then return setmetatable({latitude=ci,longitude=cj,altitude=ch,bodyId=co,systemId=cn},MapPosition)end;return setmetatable({latitude=gF*gH(ci,-90,90),longitude=gF*(cj%360),altitude=ch,bodyId=co,systemId=cn},MapPosition)end;local gY={}gY.__index=gY;gY.__tostring=function(gK,gO)local gZ=gO and gO..'  'local g_={}local gP={}for bG in pairs(gK)do table.insert(gP,bG)end;table.sort(gP)for _,h0 in ipairs(gP)do bdy=gK[h0]local h1=gN.__tostring(bdy,gZ)if gO then table.insert(g_,e('[%s]={\n%s\n%s}',h0,h1,gO))else table.insert(g_,e('  [%s]=%s',h0,h1))end end;if gO then return e('\n%s%s%s',gO,table.concat(g_,',\n'..gO),gO)end;return e('{\n%s\n}',table.concat(g_,',\n'))end;local function h2(h3)local b2={}local pid;for _,bH in pairs(h3)do local cu=bH.planetarySystemId;if type(cu)~='number'then error('Invalid planetary system ID: '..tostring(cu))elseif pid and cu~=pid then error('Mismatch planetary system IDs: '..cu..' and '..pid)end;local h4=bH.bodyId;if type(h4)~='number'then error('Invalid body ID: '..tostring(h4))elseif b2[h4]then error('Duplicate body ID: '..tostring(h4))end;setmetatable(bH.center,getmetatable(vec3.unit_x))b2[h4]=setmetatable(bH,gN)pid=cu end;return setmetatable(b2,gY)end;b7={}local function h5(h3)return setmetatable({galaxyAtlas=h3 or{}},b7)end;b7.__index=function(gz,i)if type(i)=='number'then local system=gz.galaxyAtlas[i]return h2(system)end;return rawget(b7,i)end;b7.__pairs=function(gK)return function(gz,bG)local h6,nv=next(gz,bG)return h6,nv and h2(nv)end,gK.galaxyAtlas,nil end;b7.__tostring=function(gK)local h7={}for _,h8 in pairs(gK or{})do local h9=h8:getPlanetarySystemId()local ha=gY.__tostring(h8,'    ')table.insert(h7,e('  [%s]={%s\n  }',h9,ha))end;return e('{\n%s\n}\n',table.concat(h7,',\n'))end;b7.BodyParameters=gS;b7.MapPosition=gW;b7.PlanetarySystem=h2;function b7.createBodyParameters(hb,co,hc,hd,he,hf,hg)assert(gx(hb),'Argument 1 (planetarySystemId) must be a number:'..type(hb))assert(gx(co),'Argument 2 (bodyId) must be a number:'..type(co))assert(gx(hc),'Argument 3 (surfaceArea) must be a number:'..type(hc))assert(gy(hd),'Argument 4 (aPosition) must be an array or vec3:'..type(hd))assert(gy(he),'Argument 5 (verticalAtPosition) must be an array or vec3:'..type(he))assert(gx(hf),'Argument 6 (altitude) must be in meters:'..type(hf))assert(gx(hg),'Argument 7 (gravityAtPosition) must be number:'..type(hg))local gT=math.sqrt(hc/4/math.pi)local ae=gT+hf;local hh=vec3(hd)+ae*vec3(he)local gU=hg*ae*ae;return gS(hb,co,gT,hh,gU)end;b7.isMapPosition=gD;function b7:getPlanetarySystem(gX)if i==nil then i=0 end;if nv==nil then nv=0 end;local hb=gX;if gD(gX)then hb=gX.systemId end;if type(hb)=='number'then local system=self.galaxyAtlas[i]if system then if getmetatable(nv)~=gY then system=h2(system)end;return system end end end;function gY:castIntersections(hi,fJ,hj,hk)local hj=hj or function(fo)return 1.05*fo.radius end;local hl={}if hk then for _,i in ipairs(hk)do hl[i]=self[i]end else hk={}for bG,fo in pairs(self)do table.insert(hk,bG)hl[bG]=fo end end;local function hm(hn,ho)local hp=hl[hn].center-hi;local hq=hl[ho].center-hi;return hp:len()<hq:len()end;table.sort(hk,hm)local hr=fJ:normalize()for i,cu in ipairs(hk)do local fo=hl[cu]local hs=fo.center-hi;local gT=hj(fo)local ht=hs:dot(hr)local hu=ht^2-(hs:len2()-gT^2)if hu>=0 then local hv=math.sqrt(hu)local fm=ht+hv;local fn=ht-hv;if fn>0 then return fo,fm,fn elseif fm>0 then return fo,fm,nil end end end;return nil,nil,nil end;function gY:closestBody(hw)assert(type(hw)=='table','Invalid coordinates.')local hx,fo;local hy=vec3(hw)for _,hz in pairs(self)do local hA=(hz.center-hy):len2()if(not fo or hA<hx)and hz.name~="Space"then fo=hz;hx=hA end end;return fo end;function gY:convertToBodyIdAndWorldCoordinates(gX)local hB=gX;if gA(gX)then hB=gW(gX)end;if hB.bodyId==0 then return 0,vec3(hB.latitude,hB.longitude,hB.altitude)end;local hz=self:getBodyParameters(hB)if hz then return hB.bodyId,hz:convertToWorldCoordinates(hB)end end;function gY:getBodyParameters(gX)local co=gX;if gD(gX)then co=gX.bodyId end;assert(gx(co),'Argument 1 (bodyId) must be a number:'..type(co))return self[co]end;function gY:getPlanetarySystemId()local _,bH=next(self)return bH and bH.planetarySystemId end;function gN:convertToMapPosition(ce)assert(gy(ce),'Argument 1 (worldCoordinates) must be an array or vec3:'..type(ce))local cf=vec3(ce)if self.bodyId==0 then return setmetatable({latitude=cf.x,longitude=cf.y,altitude=cf.z,bodyId=0,systemId=self.planetarySystemId},MapPosition)end;local cg=cf-self.center;local ae=cg:len()local ch=ae-self.radius;local ci=0;local cj=0;if not float_eq(ae,0)then local ck=math.atan(cg.y,cg.x)cj=ck>=0 and ck or 2*math.pi+ck;ci=math.pi/2-math.acos(cg.z/ae)end;return setmetatable({latitude=ci,longitude=cj,altitude=ch,bodyId=self.bodyId,systemId=self.planetarySystemId},MapPosition)end;function gN:convertToWorldCoordinates(gX)local hB=gA(gX)and gW(gX)or gX;if hB.bodyId==0 then return vec3(hB.latitude,hB.longitude,hB.altitude)end;assert(gD(hB),'Argument 1 (mapPosition) is not an instance of "MapPosition".')assert(hB.systemId==self.planetarySystemId,'Argument 1 (mapPosition) has a different planetary system ID.')assert(hB.bodyId==self.bodyId,'Argument 1 (mapPosition) has a different planetary body ID.')local cp=math.cos(hB.latitude)return self.center+(self.radius+hB.altitude)*vec3(cp*math.cos(hB.longitude),cp*math.sin(hB.longitude),math.sin(hB.latitude))end;function gN:getAltitude(ce)return(vec3(ce)-self.center):len()-self.radius end;function gN:getDistance(ce)return(vec3(ce)-self.center):len()end;function gN:getGravity(ce)local hC=self.center-vec3(ce)local hD=hC:len2()return self.GM/hD*hC/math.sqrt(hD)end;return setmetatable(b7,{__call=function(_,...)return h5(...)end})end;function Keplers()local vec3=require('cpml.vec3')local PlanetRef=PlanetRef()local function gA(gB)return type(gB)=='string'end;local function gy(gz)return type(gz)=='table'end;local function float_eq(cb,cc)if cb==0 then return math.abs(cc)<1e-09 end;if cc==0 then return math.abs(cb)<1e-09 end;return math.abs(cb-cc)<math.max(math.abs(cb),math.abs(cc))*constants.epsilon end;Kepler={}Kepler.__index=Kepler;function Kepler:escapeAndOrbitalSpeed(ch)assert(self.body)local ae=ch+self.body.radius;if not float_eq(ae,0)then local orbit=math.sqrt(self.body.GM/ae)return math.sqrt(2)*orbit,orbit end;return nil,nil end;function Kepler:orbitalParameters(gX,bf)assert(self.body)assert(gy(gX)or gA(gX))assert(gy(bf))local cl=(gA(gX)or PlanetRef.isMapPosition(gX))and self.body:convertToWorldCoordinates(gX)or vec3(gX)local bH=vec3(bf)local hE=cl-self.body.center;local hq=bH:len2()local hF=hE:len()local hG=self.body.GM;local hH=((hq-hG/hF)*hE-hE:dot(bH)*bH)/hG;local cb=hG/(2*hG/hF-hq)local hI=hH:len()local hr=hH:normalize()local hJ=cb*(1-hI)local hK=cb*(1+hI)local hL=hJ*hr+self.body.center;local hM=hI<=1 and-hK*hr+self.body.center or nil;local hN=math.sqrt(cb*hG*(1-hI*hI))local hO=hM and 2*math.pi*math.sqrt(cb^3/hG)local hP=math.acos(hH:dot(hE)/(hI*hF))if hE:dot(bH)<0 then hP=-(hP-2*math.pi)end;local hQ=math.acos((math.cos(hP)+hI)/(1+hI*math.cos(hP)))local hR=hQ;if hR<0 then hR=hR+2*math.pi end;local hS=hR-hI*math.sin(hR)local hT=0;local hU=0;local hV=0;if hO~=nil then hT=hS/(2*math.pi/hO)hU=hO-hT;hV=hU+hO/2;if hP-math.pi>0 then hU=hT;hV=hU+hO/2 end;if hV>hO then hV=hV-hO end end;return{periapsis={position=hL,speed=hN/hJ,circularOrbitSpeed=math.sqrt(hG/hJ),altitude=hJ-self.body.radius},apoapsis=hM and{position=hM,speed=hN/hK,circularOrbitSpeed=math.sqrt(hG/hK),altitude=hK-self.body.radius},currentVelocity=bH,currentPosition=cl,eccentricity=hI,period=hO,eccentricAnomaly=hQ,meanAnomaly=hS,timeToPeriapsis=hU,timeToApoapsis=hV}end;local function hW(hX)local hz=PlanetRef.BodyParameters(hX.planetarySystemId,hX.bodyId,hX.radius,hX.center,hX.GM)return setmetatable({body=hz},Kepler)end;return setmetatable(Kepler,{__call=function(_,...)return hW(...)end})end;function Kinematics()local b9={}local hY=30000000/3600;local hZ=hY*hY;local h_=100;local function i0(bH)return 1/math.sqrt(1-bH*bH/hZ)end;function b9.computeAccelerationTime(i1,i2,i3)local i4=hY*math.asin(i1/hY)return(hY*math.asin(i3/hY)-i4)/i2 end;function b9.computeDistanceAndTime(i1,i3,i5,i6,i7,i8)i7=i7 or 0;i8=i8 or 0;local i9=i1<=i3;local ia=i6*(i9 and 1 or-1)/i5;local ib=-i8/i5;local ic=ia+ib;if i9 and ic<=0 or not i9 and ic>=0 then return-1,-1 end;local id,ie=0,0;if ia~=0 and i7>0 then local i4=math.asin(i1/hY)local ig=math.pi*(ia/2+ib)local ih=ia*i7;local ii=hY*math.pi;local bH=function(gz)local d0=(ig*gz-ih*math.sin(math.pi*gz/2/i7)+ii*i4)/ii;local ij=math.tan(d0)return hY*ij/math.sqrt(ij*ij+1)end;local ik=i9 and function(gB)return gB>=i3 end or function(gB)return gB<=i3 end;ie=2*i7;if ik(bH(ie))then local il=0;while math.abs(ie-il)>0.5 do local gz=(ie+il)/2;if ik(bH(gz))then ie=gz else il=gz end end end;local im=i1;local io=ie/h_;for ip=1,h_ do local bX=bH(ip*io)id=id+(bX+im)*io/2;im=bX end;if ie<2*i7 then return id,ie end;i1=im end;local i4=hY*math.asin(i1/hY)local bJ=(hY*math.asin(i3/hY)-i4)/ic;local iq=hZ*math.cos(i4/hY)/ic;local ae=iq-hZ*math.cos((ic*bJ+i4)/hY)/ic;return ae+id,bJ+ie end;function b9.computeTravelTime(i1,i2,ae)if ae==0 then return 0 end;if i2>0 then local i4=hY*math.asin(i1/hY)local iq=hZ*math.cos(i4/hY)/i2;return(hY*math.acos(i2*(iq-ae)/hZ)-i4)/i2 end;if i1==0 then return-1 end;assert(i1>0,'Acceleration and initial speed are both zero.')return ae/i1 end;function b9.lorentz(bH)return i0(bH)end;return b9 end;function safeZone(ir)local gT=500000;local is,it,iu=math.huge;local iv=false;local iw=vec3({13771471,7435803,-128971})local ix=18000000;is=vec3(ir):dist(iw)if is<ix then return true,math.abs(is-ix),"Safe Zone",0 end;it=vec3(ir):dist(vec3(planet.center))if it<gT then iv=true end;if math.abs(it-gT)<math.abs(is-ix)then return iv,math.abs(it-gT),planet.name,planet.bodyId else return iv,math.abs(is-ix),"Safe Zone",0 end end;function cmdThrottle(ek,iy)if iy==nil then iy=false end;if Nav.axisCommandManager:getAxisCommandType(0)~=axisCommandType.byThrottle and not iy then Nav.control.cancelCurrentControlMasterMode()end;Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal,ek)z=round(ek*100,0)end;function cmdCruise(ek,iy)if Nav.axisCommandManager:getAxisCommandType(0)~=axisCommandType.byTargetSpeed and not iy then Nav.control.cancelCurrentControlMasterMode()end;Nav.axisCommandManager:setTargetSpeedCommand(axisCommandId.longitudinal,ek)end;function SaveDataBank(iz)if dbHud_1 then if not a9 then for bG,bH in pairs(b)do dbHud_1.setStringValue(bH,g(_G[bH]))if iz and dbHud_2 then dbHud_2.setStringValue(bH,g(_G[bH]))end end;for bG,bH in pairs(a)do dbHud_1.setStringValue(bH,g(_G[bH]))if iz and dbHud_2 then dbHud_2.setStringValue(bH,g(_G[bH]))end end;c("Saved Variables to Datacore")if iz and dbHud_2 then W="Databank copied.  Remove copy when ready."end end end end;function script.onStart()VERSION_NUMBER=5.451;SetupComplete=false;beginSetup=coroutine.create(function()Nav.axisCommandManager:setupCustomTargetSpeedRanges(axisCommandId.longitudinal,{1000,5000,10000,20000,30000})LoadVariables()coroutine.yield()ProcessElements()coroutine.yield()SetupChecks()SetupButtons()coroutine.yield()SetupAtlas()b7=PlanetRef()b8=b7(Atlas())b9=Kinematics()bb=Keplers()AddLocationsToAtlas()UpdateAtlasLocationsList()UpdateAutopilotTarget()coroutine.yield()unit.hide()system.showScreen(1)collectgarbage("collect")coroutine.yield()unit.setTimer("apTick",apTickRate)unit.setTimer("hudTick",hudTickRate)unit.setTimer("oneSecond",1)unit.setTimer("tenthSecond",1/10)if UseSatNav then unit.setTimer("fiveSecond",5)end end)end;function script.onStop()_autoconf.hideCategoryPanels()if antigrav~=nil and not ExternalAGG then antigrav.hide()end;if warpdrive~=nil then warpdrive.hide()end;core.hide()Nav.control.switchOffHeadlights()local bS=j()if door and(bS>0 or bS==0 and ap<10000)then for _,bH in pairs(door)do bH.toggle()end end;if switch then for _,bH in pairs(switch)do bH.toggle()end end;if forcefield and(bS>0 or bS==0 and ap<10000)then for _,bH in pairs(forcefield)do bH.toggle()end end;SaveDataBank()if button then button.activate()end end;function script.onTick(iA)if iA=="tenthSecond"then if j()>0 and not WasInAtmo then if Nav.axisCommandManager:getAxisCommandType(0)==axisCommandType.byTargetSpeed and AtmoSpeedAssist and(AltitudeHold or Reentry)then z=1;Nav.control.cancelCurrentControlMasterMode()D=false end end;if AutopilotTargetName~="None"then if panelInterplanetary==nil then SetupInterplanetaryPanel()end;if AutopilotTargetName~=nil then local iB=CustomTarget~=nil;planetMaxMass=GetAutopilotMaxMass()system.updateData(interplanetaryHeaderText,'{"label": "Target", "value": "'..AutopilotTargetName..'", "unit":""}')travelTime=GetAutopilotTravelTime()if iB and not Autopilot then ae=(vec3(core.getConstructWorldPos())-CustomTarget.position):len()else ae=(AutopilotTargetCoords-vec3(core.getConstructWorldPos())):len()end;if not TurnBurn then a2,a3=GetAutopilotBrakeDistanceAndTime(bg)a4,a5=GetAutopilotBrakeDistanceAndTime(MaxGameVelocity)else a2,a3=GetAutopilotTBBrakeDistanceAndTime(bg)a4,a5=GetAutopilotTBBrakeDistanceAndTime(MaxGameVelocity)end;local dE,dF=getDistanceDisplayString(ae)system.updateData(widgetDistanceText,'{"label": "distance", "value": "'..dE..'", "unit":"'..dF..'"}')system.updateData(widgetTravelTimeText,'{"label": "Travel Time", "value": "'..FormatTimeString(travelTime)..'", "unit":""}')dE,dF=getDistanceDisplayString(a2)system.updateData(widgetCurBrakeDistanceText,'{"label": "Cur Brake distance", "value": "'..dE..'", "unit":"'..dF..'"}')system.updateData(widgetCurBrakeTimeText,'{"label": "Cur Brake Time", "value": "'..FormatTimeString(a3)..'", "unit":""}')dE,dF=getDistanceDisplayString(a4)system.updateData(widgetMaxBrakeDistanceText,'{"label": "Max Brake distance", "value": "'..dE..'", "unit":"'..dF..'"}')system.updateData(widgetMaxBrakeTimeText,'{"label": "Max Brake Time", "value": "'..FormatTimeString(a5)..'", "unit":""}')system.updateData(widgetMaxMassText,'{"label": "Maximum Mass", "value": "'..e("%.2f",planetMaxMass/1000)..'", "unit":" Tons"}')dE,dF=getDistanceDisplayString(AutopilotTargetOrbit)system.updateData(widgetTargetOrbitText,'{"label": "Target Orbit", "value": "'..e("%.2f",dE)..'", "unit":"'..dF..'"}')if j()>0 and not WasInAtmo then system.removeDataFromWidget(widgetMaxBrakeTimeText,widgetMaxBrakeTime)system.removeDataFromWidget(widgetMaxBrakeDistanceText,widgetMaxBrakeDistance)system.removeDataFromWidget(widgetCurBrakeTimeText,widgetCurBrakeTime)system.removeDataFromWidget(widgetCurBrakeDistanceText,widgetCurBrakeDistance)system.removeDataFromWidget(widgetTrajectoryAltitudeText,widgetTrajectoryAltitude)WasInAtmo=true end;if j()==0 and WasInAtmo then if system.updateData(widgetMaxBrakeTimeText,widgetMaxBrakeTime)==1 then system.addDataToWidget(widgetMaxBrakeTimeText,widgetMaxBrakeTime)end;if system.updateData(widgetMaxBrakeDistanceText,widgetMaxBrakeDistance)==1 then system.addDataToWidget(widgetMaxBrakeDistanceText,widgetMaxBrakeDistance)end;if system.updateData(widgetCurBrakeTimeText,widgetCurBrakeTime)==1 then system.addDataToWidget(widgetCurBrakeTimeText,widgetCurBrakeTime)end;if system.updateData(widgetCurBrakeDistanceText,widgetCurBrakeDistance)==1 then system.addDataToWidget(widgetCurBrakeDistanceText,widgetCurBrakeDistance)end;if system.updateData(widgetTrajectoryAltitudeText,widgetTrajectoryAltitude)==1 then system.addDataToWidget(widgetTrajectoryAltitudeText,widgetTrajectoryAltitude)end;WasInAtmo=false end end else HideInterplanetaryPanel()end;if warpdrive~=nil then if f(warpdrive.getData()).destination~="Unknown"and f(warpdrive.getData()).distance>400000 then warpdrive.show()showWarpWidget=true else warpdrive.hide()showWarpWidget=false end end elseif iA=="oneSecond"then am=false;RefreshLastMaxBrake(nil,true)updateDistance()updateRadar()updateWeapons()local cy={}local dQ=GetFlightStyle()DrawOdometer(cy,a7,TotalDistanceTravelled,dQ,a8)if ShouldCheckDamage then CheckDamage(cy)end;ag=table.concat(cy,"")collectgarbage("collect")elseif iA=="fiveSecond"then an=dbHud_1.getStringValue("SPBAutopilotTargetName")if an~=nil and an~=""and an~="SatNavNotChanged"then local bI=json.decode(dbHud_1.getStringValue("SavedLocations"))if bI~=nil then _G["SavedLocations"]=bI;local cw=-1;local cs;for bG,bH in pairs(SavedLocations)do if bH.name and bH.name=="SatNav Location"then cw=bG;break end end;if cw~=-1 then cs=SavedLocations[cw]cw=-1;for bG,bH in pairs(b2[0])do if bH.name and bH.name=="SatNav Location"then cw=bG;break end end;if cw>-1 then b2[0][cw]=cs end;UpdateAtlasLocationsList()W=cs.name.." position updated"end end;for i=1,#AtlasOrdered do if AtlasOrdered[i].name==an then AutopilotTargetIndex=i;system.print("Index = "..AutopilotTargetIndex.." "..AtlasOrdered[i].name)UpdateAutopilotTarget()dbHud_1.setStringValue("SPBAutopilotTargetName","SatNavNotChanged")break end end end elseif iA=="msgTick"then local cy={}DisplayMessage(cy,"empty")W="empty"unit.stopTimer("msgTick")ad=3 elseif iA=="animateTick"then bd=true;bc=false;ab=0;ac=0;unit.stopTimer("animateTick")elseif iA=="hudTick"then local cy={}HUDPrologue(cy)if showHud then UpdateHud(cy)else DisplayOrbitScreen(cy)DrawWarnings(cy)end;HUDEpilogue(cy)cy[#cy+1]=e([[<svg width="100%%" height="100%%" style="position:absolute;top:0;left:0"  viewBox="0 0 %d %d">]],ResolutionX,ResolutionY)if W~="empty"then DisplayMessage(cy,W)end;if o()==0 and userControlScheme=="virtual joystick"then if DisplayDeadZone then DrawDeadZone(cy)end end;if o()==1 and screen_1 and screen_1.getMouseY()~=-1 then SetButtonContains()DrawButtons(cy)if screen_1.getMouseState()==1 then CheckButtons()end;cy[#cy+1]=e([[<g transform="translate(%d %d)"><circle class="cursor" cx="%fpx" cy="%fpx" r="5"/></g>]],E,F,ab,ac)elseif system.isViewLocked()==0 then if o()==1 and V then SetButtonContains()DrawButtons(cy)if not bc and not bd then local iC=table.concat(cy,"")cy={}cy[#cy+1]=e("<style>@keyframes test { from { opacity: 0; } to { opacity: 1; } }  body { animation-name: test; animation-duration: 0.5s; }</style><body><svg width='100%%' height='100%%' position='absolute' top='0' left='0'><rect width='100%%' height='100%%' x='0' y='0' position='absolute' style='fill:rgb(6,5,26);'/></svg><svg width='50%%' height='50%%' style='position:absolute;top:30%%;left:25%%' viewbox='0 0 %d %d'>",ResolutionX,ResolutionY)cy[#cy+1]=b3;cy[#cy+1]=iC;cy[#cy+1]="</body>"bc=true;cy[#cy+1]=[[</svg></body>]]unit.setTimer("animateTick",0.5)local content=table.concat(cy,"")system.setScreen(content)elseif bd then local iC=table.concat(cy,"")cy={}cy[#cy+1]=e("<body style='background-color:rgb(6,5,26)'><svg width='50%%' height='50%%' style='position:absolute;top:30%%;left:25%%' viewbox='0 0 %d %d'>",ResolutionX,ResolutionY)cy[#cy+1]=b3;cy[#cy+1]=iC;cy[#cy+1]="</body>"end;if not bc then cy[#cy+1]=e([[<g transform="translate(%d %d)"><circle class="cursor" cx="%fpx" cy="%fpx" r="5"/></g>]],E,F,ab,ac)end else CheckButtons()end else if not V and o()==0 then CheckButtons()if ae>DeadZone then if DisplayDeadZone then DrawCursorLine(cy)end end else SetButtonContains()DrawButtons(cy)end;cy[#cy+1]=e([[<g transform="translate(%d %d)"><circle class="cursor" cx="%fpx" cy="%fpx" r="5"/></g>]],E,F,ab,ac)end;cy[#cy+1]=[[</svg></body>]]content=table.concat(cy,"")if not DidLogOutput then system.logInfo(LastContent)DidLogOutput=true end elseif iA=="apTick"then ao=j()>0;local bJ=system.getTime()local iD=bJ-bl;bl=bJ;local cB=vec3(core.getConstructWorldOrientationForward())local cC=vec3(core.getConstructWorldOrientationRight())local iE=vec3(core.getConstructWorldOrientationUp())local cD=vec3(core.getWorldVertical())local iF=vec3(core.getConstructWorldPos())local dS=getRoll(cD,cB,cC)local dT=dS/180*math.pi;local dU=math.cos(dT)local dV=math.sin(dT)local cE=getPitch(cD,cB,cC)local iG=getPitch(cD,cB,cC*dU+iE*dV)local iH=-math.deg(cW(iE,bf,cB))local iI=math.deg(cW(cC,bf,cB))bk=ao and iH<-YawStallAngle or iH>YawStallAngle or iI<-PitchStallAngle or iI>PitchStallAngle;bi=system.getMouseDeltaX()bj=system.getMouseDeltaY()if InvertMouse and not V then bj=-bj end;P=0;T=0;O=0;bf=vec3(core.getWorldVelocity())bg=vec3(bf):len()sys=b8[0]planet=sys:closestBody(core.getConstructWorldPos())kepPlanet=bb(planet)orbit=kepPlanet:orbitalParameters(core.getConstructWorldPos(),bf)al=hoverDetectGround()local bU=planet:getGravity(core.getConstructWorldPos()):len()*n()bm=0;ba=core.getMaxKinematicsParametersAlongAxis("ground",core.getConstructOrientationUp())[1]w,x,y,_=safeZone(iF)if o()==1 and screen_1 and screen_1.getMouseY()~=-1 then ab=screen_1.getMouseX()*ResolutionX;ac=screen_1.getMouseY()*ResolutionY elseif system.isViewLocked()==0 then if o()==1 and V then if not bc then ab=ab+bi;ac=ac+bj end else ab=0;ac=0 end else ab=ab+bi;ac=ac+bj;ae=math.sqrt(ab*ab+ac*ac)if not V and o()==0 then if userControlScheme=="virtual joystick"then if ab>0 and ab>DeadZone then P=P-(ab-DeadZone)*MouseXSensitivity elseif ab<0 and ab<DeadZone*-1 then P=P-(ab+DeadZone)*MouseXSensitivity else P=0 end;if ac>0 and ac>DeadZone then O=O-(ac-DeadZone)*MouseYSensitivity elseif ac<0 and ac<DeadZone*-1 then O=O-(ac+DeadZone)*MouseYSensitivity else O=0 end elseif userControlScheme=="mouse"then ab=0;ac=0;O=(-utils.smoothstep(bj,-100,100)+0.5)*2*K;P=(-utils.smoothstep(bi,-100,100)+0.5)*2*L else ab=0;ac=0 end end end;local iJ=bg>8334;if bg>SpaceSpeedLimit/3.6 and not ao and not Autopilot and not iJ then W="Space Speed Engine Shutoff reached"if Nav.axisCommandManager:getAxisCommandType(0)==1 then Nav.control.cancelCurrentControlMasterMode()end;Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal,0)z=0 end;if not iJ and LastIsWarping then if not BrakeIsOn then BrakeToggle()end;if Autopilot then ToggleAutopilot()end end;LastIsWarping=iJ;if ao and j()>0.09 then if bg>bp/3.6 and not AtmoSpeedAssist and not at then BrakeIsOn=true;at=true elseif not AtmoSpeedAssist and at then if bg<bp/3.6 then BrakeIsOn=false;at=false end end end;if BrakeIsOn then S=1 else S=0 end;ap=core.getAltitude()if ap==0 then ap=(vec3(core.getConstructWorldPos())-planet.center):len()-planet.radius end;if ProgradeIsOn then if ai then BrakeIsOn=false;local iK=false;if CustomTarget~=nil then iK=AlignToWorldVector(CustomTarget.position-iF,0.01)else iK=AlignToWorldVector(vec3(bf),0.01)end;be=true;if iK and(math.abs(dS)<2 or math.abs(iG)>85)and bg>=bp/3.6-1 then BrakeIsOn=false;ProgradeIsOn=false;J=true;ai=false;ak=true;Autopilot=false;BeginReentry()elseif ao and AtmoSpeedAssist then cmdThrottle(1)else cmdCruise(math.floor(bp))z=0 end elseif bg>I then AlignToWorldVector(vec3(bf),0.01)end end;if RetrogradeIsOn then if ao then RetrogradeIsOn=false elseif bg>I then AlignToWorldVector(-vec3(bf))end end;if not ProgradeIsOn and ai then if j()==0 then J=true;BeginReentry()ai=false;ak=true else ai=false;ToggleAutopilot()end end;local eo=vec3(core.getWorldVertical())*-1;local em=bf.x*eo.x+bf.y*eo.y+bf.z*eo.z;if ak and CustomTarget~=nil and(ap<HoldAltitude+200 and ap>HoldAltitude-200)and bg*3.6>bp-100 and math.abs(em)<20 and j()>=0.1 and(CustomTarget.position-iF):len()>2000+ap then ToggleAutopilot()ak=false end;if VertTakeOff then be=true;if em<-30 then W="Unable to achieve lift. Safety Landing."aa=0;be=autoRollPreference;VertTakeOff=false;BrakeLanding=true elseif antigrav and not ExternalAGG and antigrav.getState()==1 then if ap<antigrav.getBaseAltitude()-100 then bq=0;aa=15;BrakeIsOn=false elseif em>0 then BrakeIsOn=true;aa=0 elseif em<-30 then BrakeIsOn=true;aa=15 elseif ap>=antigrav.getBaseAltitude()then BrakeIsOn=true;aa=0;VertTakeOff=false;W="Takeoff complete. Singularity engaged"end else if j()>0.08 then bq=0;BrakeIsOn=false;aa=20 elseif j()<0.08 and j()>0 then BrakeIsOn=false;if bC then bq=0;aa=20 else aa=0;bq=36;cmdCruise(3500)end else be=autoRollPreference;if not IntoOrbit then bu=true;ToggleIntoOrbit()end;VertTakeOff=false end end;if bq~=nil then if vTpitchPID==nil then vTpitchPID=pid.new(2*0.01,0,2*0.1)end;local iL=utils.clamp(bq-iG,-PitchStallAngle*0.85,PitchStallAngle*0.85)vTpitchPID:inject(iL)local iM=utils.clamp(vTpitchPID:get(),-1,1)O=iM end end;if IntoOrbit then if bz==nil then if VectorToTarget then bz=a6 else bz=planet end end;if not bx then if bz.hasAtmosphere then by=math.floor(bz.radius+bz.noAtmosphericDensityAltitude+1000)else by=math.floor(bz.radius+bz.surfaceMaxAltitude+1000)end;bx=true end;local dB;local iN=false;local iO,iP=getDistanceDisplayString(by)local iQ=iO..iP;if bw.VectorToTarget then dB=CustomTarget.position-iF end;local iR,iS=bb(bz):escapeAndOrbitalSpeed((vec3(core.getConstructWorldPos())-bz.center):len()-bz.radius)local iT=dS;if not bu then cmdThrottle(0)bt=0;br="Aligning to orbital path - OrbitHeight: "..iQ;local iU=false;local iV=false;if bw.VectorToTarget then AlignToWorldVector(dB:normalize():project_on_plane(cD))iN=cB:dot(dB:project_on_plane(iE):normalize())>0.95 else AlignToWorldVector(bf)iN=iH<0.5;if bg<150 then iN=true end end;O=0;bs=0;if iG<=bs+1 and iG>=bs-1 then iU=true else iU=false end;if iT<=bt+1 and iT>=bt-1 then iV=true else iV=false end;if iU and iV and iN then bs=nil;bt=nil;bu=true end else if bw.VectorToTarget then AlignToWorldVector(dB:normalize():project_on_plane(cD))elseif bg>150 then AlignToWorldVector(bf)end;O=0;if bw.VectorToTarget then local a2,_=b9.computeDistanceAndTime(bg,bp/3.6,n(),0,0,LastMaxBrake)if bA and bf:normalize():dot(dB:normalize())>0.5 and dB:len()>15000+a2+ap then br="Orbiting to Target"elseif bA or dB:len()<15000+a2+ap then W="Orbit complete, proceeding with reentry"AutopilotTargetCoords=CustomTarget.position;J=true;ak=true;bw.VectorToTarget,bw.AutopilotAlign=false,false;ToggleIntoOrbit()BeginReentry()end end;if orbit.periapsis~=nil and orbit.apoapsis~=nil and orbit.eccentricity<1 and ap>by*0.9 and ap<by*1.4 then if orbit.apoapsis~=nil then if orbit.periapsis.altitude>=by*0.99 and orbit.apoapsis.altitude>=by*0.99 and orbit.periapsis.altitude<orbit.apoapsis.altitude and orbit.periapsis.altitude*1.05>=orbit.apoapsis.altitude or bA then if bA then BrakeIsOn=false;z=0;cmdThrottle(0)bA=true;bs=0;if not bw.VectorToTarget then ToggleIntoOrbit()end else bE=bE+1;if bE>=2 then bA=true end end else br="Adjusting Orbit - OrbitHeight: "..iQ;bv=true;cmdCruise(iS*3.6+1)if VSpdPID==nil then VSpdPID=pid.new(0.5,0,10*0.1)end;local iW=em;local iX=ap-by;local iY=math.abs(iX)if em<10 and math.abs(iG)<10 and iY<100 then iW=em*2 end;if iW<10 and math.abs(iG)<10 and iY<100 then iW=iW*2 end;if iW<5 and math.abs(iG)<5 and iY<100 then iW=iW*4 end;VSpdPID:inject(iW)bs=utils.clamp(-VSpdPID:get(),-90,90)if OrbitAltPID==nil then OrbitAltPID=pid.new(0.15,0,5*0.1)end;OrbitAltPID:inject(iX)bs=utils.clamp(bs-utils.clamp(OrbitAltPID:get(),-15,15),-90,90)end end else local iZ=2.75;local i_=math.abs(utils.round(iR*iZ))local j0=i_%50;if j0>0 then i_=i_-j0+50 end;BrakeIsOn=false;if ap<by*0.8 then br="Escaping planet gravity - OrbitHeight: "..iQ;bs=utils.map(em,200,0,-15,80)elseif ap>=by*0.8 and ap<by*1.15 then br="Approaching orbital corridor - OrbitHeight: "..iQ;i_=i_*0.75;bs=utils.map(em,100,-100,-15,65)elseif ap>=by*1.15 and ap<by*1.5 then br="Approaching orbital corridor - OrbitHeight: "..iQ;i_=i_*0.75;if em<0 or bv then bs=utils.map(ap,by*1.5,by*1.01,-30,0)else bs=utils.map(ap,by*0.99,by*1.5,0,30)end elseif ap>by*1.5 then br="Reentering orbital corridor - OrbitHeight: "..iQ;bs=-85;local j1=utils.map(em,-150,-400,1,0.55)i_=i_*j1 end;cmdCruise(math.floor(i_))end end;if bs~=nil then if OrbitPitchPID==nil then OrbitPitchPID=pid.new(2*0.01,0,2*0.1)end;local j2=bs-iG;OrbitPitchPID:inject(j2)local j3=utils.clamp(OrbitPitchPID:get(),-0.5,0.5)O=j3 end end;if Autopilot and j()==0 and not ai then local j4,j5=AutopilotTargetCoords,false;if CustomTarget~=nil and CustomTarget.planetname~="Space"then AutopilotRealigned=true;if not TargetSet then local j6=(CustomTarget.position-a6.center):normalize()local j7=j6:project_on_plane((a6.center-iF):normalize()):normalize()local j8=a6.center+j7*(a6.radius+AutopilotTargetOrbit)local j9=CustomTarget.position+(CustomTarget.position-a6.center):normalize()*(AutopilotTargetOrbit-a6:getAltitude(CustomTarget.position))if(iF-j8):len()<(iF-j9):len()then j4=j8;AutopilotTargetCoords=j4 else j4=CustomTarget.position+(CustomTarget.position-a6.center):normalize()*(AutopilotTargetOrbit-a6:getAltitude(CustomTarget.position))AutopilotTargetCoords=j4 end;local cG=zeroConvertToMapPosition(a6,AutopilotTargetCoords)cG="::pos{"..cG.systemId..","..cG.bodyId..","..cG.latitude..","..cG.longitude..","..cG.altitude.."}"system.setWaypoint(cG)j5=true;TargetSet=true end;AutopilotPlanetGravity=0 elseif CustomTarget~=nil and CustomTarget.planetname=="Space"then AutopilotPlanetGravity=0;j5=true;TargetSet=true;AutopilotRealigned=true;j4=CustomTarget.position+(iF-CustomTarget.position)*AutopilotTargetOrbit elseif CustomTarget==nil then AutopilotPlanetGravity=0;if not TargetSet then local j6=(iF+bf*100000-a6.center):normalize()local j7=j6:project_on_plane((a6.center-iF):normalize()):normalize()if j7:len()<1 then j6=(iF+vec3(core.getConstructWorldOrientationForward())*100000-a6.center):normalize()j7=j6:project_on_plane((a6.center-iF):normalize()):normalize()end;j4=a6.center+j7*(a6.radius+AutopilotTargetOrbit)AutopilotTargetCoords=j4;TargetSet=true;j5=true;AutopilotRealigned=true;local cG=zeroConvertToMapPosition(a6,AutopilotTargetCoords)cG="::pos{"..cG.systemId..","..cG.bodyId..","..cG.latitude..","..cG.longitude..","..cG.altitude.."}"system.setWaypoint(cG)end end;AutopilotDistance=(vec3(j4)-vec3(core.getConstructWorldPos())):len()local fl,fm,fn=b8:getPlanetarySystem(0):castIntersections(iF,bf:normalize(),function(fo)if fo.noAtmosphericDensityAltitude>0 then return fo.radius+fo.noAtmosphericDensityAltitude else return fo.radius+fo.surfaceMaxAltitude*1.5 end end)local fp=fm;if fn~=nil and fm~=nil then fp=math.min(fn,fm)end;if fp~=nil and fp<AutopilotDistance and fl.name==a6.name then AutopilotDistance=fp end;local iK=true;local ja=(a6.center-(vec3(core.getConstructWorldPos())+vec3(bf):normalize()*AutopilotDistance)):len()-a6.radius;local dE,dF=getDistanceDisplayString(ja)system.updateData(widgetTrajectoryAltitudeText,'{"label": "Projected Altitude", "value": "'..dE..'", "unit":"'..dF..'"}')local a2,a3;if not TurnBurn then a2,a3=GetAutopilotBrakeDistanceAndTime(bg)else a2,a3=GetAutopilotTBBrakeDistanceAndTime(bg)end;if bg>300 and AutopilotAccelerating then local dB=vec3(j4)-vec3(core.getConstructWorldPos())local jb=utils.clamp(math.deg(cW(iE,bf:normalize(),dB:normalize()))*bg/500,-90,90)local jc=utils.clamp(math.deg(cW(cC,bf:normalize(),dB:normalize()))*bg/500,-90,90)if math.abs(jb)<20 and math.abs(jc)<20 then jb=jb*2;jc=jc*2 end;if math.abs(jb)<2 and math.abs(jc)<2 then jb=jb*2;jc=jc*2 end;local iH=-math.deg(cW(iE,cB,bf:normalize()))local iI=-math.deg(cW(cC,cB,bf:normalize()))if apPitchPID==nil then apPitchPID=pid.new(2*0.01,0,2*0.1)end;apPitchPID:inject(jc-iI)local jd=utils.clamp(apPitchPID:get(),-1,1)O=O+jd;if apYawPID==nil then apYawPID=pid.new(2*0.01,0,2*0.1)end;apYawPID:inject(jb-iH)local je=utils.clamp(apYawPID:get(),-1,1)P=P+je;j5=true;if math.abs(jb)>2 or math.abs(jc)>2 then AutopilotStatus="Adjusting Trajectory"else AutopilotStatus="Accelerating"end end;if ja<AutopilotTargetOrbit*1.5 then if CustomTarget~=nil and CustomTarget.planetname=="Space"then AutopilotEndSpeed=0 elseif CustomTarget==nil then _,AutopilotEndSpeed=bb(a6):escapeAndOrbitalSpeed(ja)end end;if not AutopilotCruising and not AutopilotBraking and not j5 then iK=AlignToWorldVector((j4-vec3(core.getConstructWorldPos())):normalize())elseif TurnBurn then iK=AlignToWorldVector(-vec3(bf):normalize())end;if AutopilotAccelerating then if not G then BrakeIsOn=false;cmdThrottle(AutopilotInterplanetaryThrottle)z=round(AutopilotInterplanetaryThrottle,2)G=true end;local fN=unit.getThrottle()if AtmoSpeedAssist then fN=z end;if vec3(core.getVelocity()):len()>=MaxGameVelocity or fN==0 and G then AutopilotAccelerating=false;AutopilotStatus="Cruising"AutopilotCruising=true;cmdThrottle(0)z=0 end;if AutopilotDistance<=a2 then AutopilotAccelerating=false;AutopilotStatus="Braking"AutopilotBraking=true;cmdThrottle(0)z=0;G=false end elseif AutopilotBraking then if AutopilotStatus~="Orbiting to Target"then BrakeIsOn=true;S=1 end;if TurnBurn then cmdThrottle(100,true)z=1 end;local _,iS=bb(a6):escapeAndOrbitalSpeed((vec3(core.getConstructWorldPos())-planet.center):len()-planet.radius)local dB;if CustomTarget~=nil then dB=CustomTarget.position-iF end;if CustomTarget~=nil and CustomTarget.planetname=="Space"and bg<50 then W="Autopilot complete, arrived at space location"AutopilotBraking=false;Autopilot=false;TargetSet=false;AutopilotStatus="Aligning"elseif CustomTarget~=nil and CustomTarget.planetname~="Space"and bg<=iS and(orbit.apoapsis==nil or orbit.periapsis==nil or orbit.apoapsis.altitude<=0 or orbit.periapsis.altitude<=0)then W="Autopilot complete, proceeding with reentry"AutopilotTargetCoords=CustomTarget.position;AutopilotBraking=false;Autopilot=false;TargetSet=false;AutopilotStatus="Aligning"cmdThrottle(0)z=0;G=false;ProgradeIsOn=true;ai=true;local cG=zeroConvertToMapPosition(a6,AutopilotTargetCoords)cG="::pos{"..cG.systemId..","..cG.bodyId..","..cG.latitude..","..cG.longitude..","..cG.altitude.."}"system.setWaypoint(cG)elseif orbit.periapsis~=nil and orbit.periapsis.altitude>0 and orbit.eccentricity<1 then AutopilotStatus="Circularizing"local _,iS=bb(a6):escapeAndOrbitalSpeed((vec3(core.getConstructWorldPos())-planet.center):len()-planet.radius)if bg<=iS then if CustomTarget~=nil then if bf:normalize():dot(dB:normalize())>0.4 then AutopilotStatus="Orbiting to Target"if not WaypointSet then BrakeIsOn=false;local cG=zeroConvertToMapPosition(a6,CustomTarget.position)cG="::pos{"..cG.systemId..","..cG.bodyId..","..cG.latitude..","..cG.longitude..","..cG.altitude.."}"system.setWaypoint(cG)WaypointSet=true end else W="Autopilot complete, proceeding with reentry"AutopilotTargetCoords=CustomTarget.position;AutopilotBraking=false;Autopilot=false;TargetSet=false;AutopilotStatus="Aligning"cmdThrottle(0)z=0;G=false;ProgradeIsOn=true;ai=true;BrakeIsOn=false;local cG=zeroConvertToMapPosition(a6,CustomTarget.position)cG="::pos{"..cG.systemId..","..cG.bodyId..","..cG.latitude..","..cG.longitude..","..cG.altitude.."}"system.setWaypoint(cG)WaypointSet=false end else BrakeIsOn=false;AutopilotBraking=false;Autopilot=false;TargetSet=false;AutopilotStatus="Aligning"W="Autopilot completed, orbit established"S=0;z=0;G=false;if CustomTarget~=nil and CustomTarget.planetname~="Space"then ProgradeIsOn=true;ai=true end end end end elseif AutopilotCruising then if AutopilotDistance<=a2 then AutopilotAccelerating=false;AutopilotStatus="Braking"AutopilotBraking=true end;local fN=unit.getThrottle()if AtmoSpeedAssist then fN=z end;if fN>0 then AutopilotAccelerating=true;AutopilotStatus="Accelerating"AutopilotCruising=false end else if iK then if not AutopilotRealigned and CustomTarget==nil or not AutopilotRealigned and CustomTarget~=nil and CustomTarget.planetname~="Space"then if not ai then AutopilotTargetCoords=vec3(a6.center)+(AutopilotTargetOrbit+a6.radius)*vec3(core.getConstructWorldOrientationRight())AutopilotShipUp=core.getConstructWorldOrientationUp()AutopilotShipRight=core.getConstructWorldOrientationRight()end;AutopilotRealigned=true elseif iK then AutopilotAccelerating=true;AutopilotStatus="Accelerating"if not G then cmdThrottle(AutopilotInterplanetaryThrottle,true)z=round(AutopilotInterplanetaryThrottle,2)G=true;BrakeIsOn=false end end end end elseif Autopilot and(CustomTarget~=nil and CustomTarget.planetname~="Space"and j()>0)then W="Autopilot complete, proceeding with reentry"AutopilotTargetCoords=CustomTarget.position;BrakeIsOn=false;AutopilotBraking=false;Autopilot=false;TargetSet=false;AutopilotStatus="Aligning"S=0;cmdThrottle(0)z=0;G=false;ProgradeIsOn=true;ai=true;local cG=zeroConvertToMapPosition(a6,CustomTarget.position)cG="::pos{"..cG.systemId..","..cG.bodyId..","..cG.latitude..","..cG.longitude..","..cG.altitude.."}"system.setWaypoint(cG)end;if U then be=true;local jc=0;local cl=vec3(core.getConstructWorldPos())+vec3(unit.getMasterPlayerRelativePosition())local jf=cl-vec3(core.getConstructWorldPos())local jg=vec3(jf):project_on(vec3(core.getConstructWorldOrientationForward())):len()local jh=vec3(jf):project_on(vec3(core.getConstructWorldOrientationRight())):len()local ae=math.sqrt(jg*jg+jh*jh)AlignToWorldVector(jf:normalize())local ji=40;local jj=ae<ji;local jk=100;local gh=utils.clamp((ae-ji)/2,10,jk)O=0;local iK=math.abs(P)<0.1;if iK and bg<gh and not jj then BrakeIsOn=false;jc=-20 else BrakeIsOn=true;jc=0 end;local jl=0;if math.abs(jc-cE)>jl then if pitchPID==nil then pitchPID=pid.new(2*0.01,0,2*0.1)end;pitchPID:inject(jc-cE)local jd=pitchPID:get()O=jd end end;if AltitudeHold or BrakeLanding or Reentry or VectorToTarget or LockPitch~=nil then local cH=unit.getClosestPlanetInfluence()>0;local jm=HoldAltitude-ap;local jn=500+bg;local jo=1;if AutoTakeoff then jo=utils.clamp(bg/100,0.1,1)end;local jc=(utils.smoothstep(jm,-jn,jn)-0.5)*2*MaxPitch*jo;if not Reentry and not ai and not VectorToTarget and cB:dot(bf:normalize())<0.99 then jc=(utils.smoothstep(jm,-jn*utils.clamp(20-19*j()*10,1,20),jn*utils.clamp(20-19*j()*10,1,20))-0.5)*2*MaxPitch*utils.clamp(2-j()*10,1,2)*jo end;if not AltitudeHold then jc=0 end;if LockPitch~=nil then if cH and not IntoOrbit then jc=LockPitch else LockPitch=nil end end;be=true;local jp=O;if Reentry then local ReentrySpeed=math.floor(bp)local jq,jr=b9.computeDistanceAndTime(bg,ReentrySpeed/3.6,n(),0,0,LastMaxBrake-planet.gravity*9.8*n())local js=ap-(planet.noAtmosphericDensityAltitude+5000)if Nav.axisCommandManager:getAxisCommandType(0)==axisCommandType.byTargetSpeed and ap>planet.noAtmosphericDensityAltitude+5000 and bg<=ReentrySpeed/3.6 and bg>ReentrySpeed/3.6-10 and math.abs(bf:normalize():dot(cB))>0.9 then Nav.control.cancelCurrentControlMasterMode()z=0 elseif Nav.axisCommandManager:getAxisCommandType(0)==axisCommandType.byThrottle and(jq>-1 and js<=jq or ap<=planet.noAtmosphericDensityAltitude+5000)then BrakeIsOn=true else BrakeIsOn=false end;cmdCruise(ReentrySpeed,true)if not J then jc=-80;if j()>0.02 then W="PARACHUTE DEPLOYED"Reentry=false;BrakeLanding=true;jc=0;be=autoRollPreference end elseif planet.noAtmosphericDensityAltitude>0 and ap>planet.noAtmosphericDensityAltitude+5000 then be=true elseif ap<=planet.noAtmosphericDensityAltitude+5000 then cmdCruise(ReentrySpeed)if Nav.axisCommandManager:getAxisCommandType(0)==axisCommandType.byTargetSpeed and Nav.axisCommandManager:getTargetSpeed(axisCommandId.longitudinal)==bp then J=false;Reentry=false;be=true end end end;if bg>I and not aj and not VectorToTarget and not BrakeLanding and ForceAlignment then AlignToWorldVector(vec3(bf))end;if(VectorToTarget or aj)and AutopilotTargetIndex>0 and j()>0.01 then local dB;if CustomTarget~=nil then dB=CustomTarget.position-vec3(core.getConstructWorldPos())else dB=a6.center-iF end;local jb=math.deg(cW(cD:normalize(),bf,dB))*2;local jt=math.rad(math.abs(dS))if bg>minRollVelocity and j()>0.01 then local ju=utils.clamp(90-jc*2,-90,90)bm=utils.clamp(jb*2,-ju,ju)local jv=jb;jb=utils.clamp(utils.clamp(jb,-YawStallAngle*0.85,YawStallAngle*0.85)*math.cos(jt)+4*(iG-jc)*math.sin(math.rad(dS)),-YawStallAngle*0.85,YawStallAngle*0.85)jc=utils.clamp(utils.clamp(jc*math.cos(jt),-PitchStallAngle*0.85,PitchStallAngle*0.85)+math.abs(utils.clamp(math.abs(jv)*math.sin(jt),-PitchStallAngle*0.85,PitchStallAngle*0.85)),-PitchStallAngle*0.85,PitchStallAngle*0.85)else bm=0;jb=utils.clamp(jb,-YawStallAngle*0.85,YawStallAngle*0.85)end;local jw=iH-jb;if not bk and bg>minRollVelocity and j()>0.01 then if yawPID==nil then yawPID=pid.new(2*0.01,0,2*0.1)end;yawPID:inject(jw)local je=utils.clamp(yawPID:get(),-1,1)P=P+je elseif ao and al>-1 or bg<minRollVelocity then AlignToWorldVector(dB)elseif bk and j()>0.01 then if(iH<-YawStallAngle or iH>YawStallAngle)and j()>0.01 then AlignToWorldVector(bf)end;if(iI<-PitchStallAngle or iI>PitchStallAngle)and j()>0.01 then jc=utils.clamp(iG-iI,iG-PitchStallAngle*0.85,iG+PitchStallAngle*0.85)end end;if CustomTarget~=nil and not aj then local jx=planet:getAltitude(CustomTarget.position)local js=math.sqrt(dB:len()^2-(ap-jx)^2)local jy=LastMaxBrakeInAtmo;if jy then jy=jy*utils.clamp(bg/100,0.1,1)*j()else jy=LastMaxBrake end;if j()<0.01 then jy=LastMaxBrake end;local jz=bf:len()-math.abs(em)local jA=vec3(core.getWorldAirFrictionAcceleration())local jB=math.sqrt(jA:len()-jA:project_on(eo):len())*n()if bg>100 then a2,a3=b9.computeDistanceAndTime(bg,100,n(),0,0,jy+jB)local jC,jD=b9.computeDistanceAndTime(100,0,n(),0,0,jy/2)a2=a2+jC else a2,a3=b9.computeDistanceAndTime(bg,0,n(),0,0,jy/2)end;StrongBrakes=true;if not aj and not Reentry and js<=a2+bg*iD/2 and(bf:project_on_plane(cD):normalize():dot(dB:project_on_plane(cD):normalize())>0.99 or VectorStatus=="Finalizing Approach")then VectorStatus="Finalizing Approach"cmdThrottle(0)z=0;if AltitudeHold then ToggleAltitudeHold()VectorToTarget=true end;BrakeIsOn=true elseif not AutoTakeoff then BrakeIsOn=false end;if VectorStatus=="Finalizing Approach"and(jz<0.1 or js<0.1 or LastDistanceToTarget~=nil and LastDistanceToTarget<js)then BrakeLanding=true;VectorToTarget=false;VectorStatus="Proceeding to Waypoint"end;LastDistanceToTarget=js end elseif VectorToTarget and j()==0 and HoldAltitude>planet.noAtmosphericDensityAltitude and not(aj or Reentry or IntoOrbit)then if CustomTarget~=nil and a6.name==planet.name then local dB=CustomTarget.position-vec3(core.getConstructWorldPos())local jx=planet:getAltitude(CustomTarget.position)local js=math.sqrt(dB:len()^2-(ap-jx)^2)local jy=LastMaxBrakeInAtmo;jy=LastMaxBrake;a2,a3=b9.computeDistanceAndTime(bg,0,n(),0,0,jy/2)StrongBrakes=true;if js<=a2+bg*iD/2 and bf:project_on_plane(cD):normalize():dot(dB:project_on_plane(cD):normalize())>0.99 then if planet.hasAtmosphere then BrakeIsOn=false;ProgradeIsOn=false;J=true;ai=false;ak=true;Autopilot=false;BeginReentry()end end;LastDistanceToTarget=js end end;if j()==0 and(AltitudeHold and HoldAltitude>planet.noAtmosphericDensityAltitude)and not(aj or IntoOrbit or Reentry)then if not bA and not IntoOrbit then by=HoldAltitude;bx=true;if VectorToTarget then bw.VectorToTarget=true end;ToggleIntoOrbit()VectorToTarget=false;bu=true end end;if bk and j()>0.01 and al==-1 and bg>minRollVelocity and VectorStatus~="Finalizing Approach"then AlignToWorldVector(bf)jc=utils.clamp(iG-iI,iG-PitchStallAngle*0.85,iG+PitchStallAngle*0.85)end;O=jp;local fW=-1;if BrakeLanding then jc=0;local jE=false;local jF=30;if ba~=nil and ba>0 then local jB=0;local dY=utils.clamp(j(),0.4,2)local jy=LastMaxBrakeInAtmo*utils.clamp(bg/100,0.1,1)*dY;local jG=ba*dY+jy+jB-bU;local jH=jy/2+jB-bU;local jI=bg-math.sqrt(math.abs(jH/2)*20/(0.5*n()))*utils.sign(jH)if jI<0 then jI=0 end;local jJ;if bg>100 then local jK,_=b9.computeDistanceAndTime(bg,100,n(),0,0,jy)local jL,_=b9.computeDistanceAndTime(100,0,n(),0,0,math.sqrt(jy))jJ=jK+jL else jJ=b9.computeDistanceAndTime(bg,0,n(),0,0,math.sqrt(jy))end;if jJ<20 then BrakeIsOn=false else local jM=0;if jI>100 then local jN,_=b9.computeDistanceAndTime(jI,100,n(),0,0,jG)local jO,_=b9.computeDistanceAndTime(100,0,n(),0,0,ba*dY+math.sqrt(jy)+jB-bU)jM=jN+jO else jM,_=b9.computeDistanceAndTime(jI,0,n(),0,0,ba*dY+math.sqrt(jy)+jB-bU)end;jM=(jM+15+bg*iD)*1.1;local jP=CustomTarget~=nil and planet:getAltitude(CustomTarget.position)>0 and CustomTarget.safe;if jP then local jx=planet:getAltitude(CustomTarget.position)local jQ=ap-jx-100;local dB=CustomTarget.position-vec3(core.getConstructWorldPos())local jR=math.sqrt(dB:len()^2-(ap-jx)^2)if jR>100 then jP=false elseif jQ<=jM or jM==-1 then BrakeIsOn=true;jE=true else BrakeIsOn=false;jE=true end end;if not jP and CalculateBrakeLandingSpeed then if jM>=jF then BrakeIsOn=true else BrakeIsOn=false end;jE=true end end end;if Nav.axisCommandManager:getAxisCommandType(0)==1 then Nav.control.cancelCurrentControlMasterMode()end;Nav.axisCommandManager:setTargetGroundAltitude(500)Nav.axisCommandManager:activateGroundEngineAltitudeStabilization(500)fW=al;if fW>-1 then be=autoRollPreference;if bg<1 or bf:normalize():dot(cD)<0 then BrakeLanding=false;AltitudeHold=false;GearExtended=true;Nav.control.extendLandingGears()Nav.axisCommandManager:setTargetGroundAltitude(LandingGearGroundHeight)aa=0;BrakeIsOn=true else BrakeIsOn=true end elseif StrongBrakes and bf:normalize():dot(-eo)<0.999 then BrakeIsOn=true elseif em<-brakeLandingRate and not jE then BrakeIsOn=true elseif not jE then BrakeIsOn=false end end;if AutoTakeoff or aj then local fl,fn,fm;if AutopilotTargetCoords~=nil then fl,fn,fm=b8:getPlanetarySystem(0):castIntersections(iF,(AutopilotTargetCoords-iF):normalize(),function(fo)return fo.radius+fo.noAtmosphericDensityAltitude end)end;if antigrav and antigrav.getState()==1 then if ap>=HoldAltitude-50 then AutoTakeoff=false;BrakeIsOn=true;cmdThrottle(0)z=0 else HoldAltitude=antigrav.getBaseAltitude()end elseif math.abs(jc)<15 and ap/HoldAltitude>0.75 then AutoTakeoff=false;if not aj then if Nav.axisCommandManager:getAxisCommandType(0)==0 and not AtmoSpeedAssist then Nav.control.cancelCurrentControlMasterMode()end elseif aj and bg<I then Autopilot=true;aj=false;AltitudeHold=false;AutoTakeoff=false;cmdThrottle(0)z=0 elseif aj then cmdThrottle(0)z=0;BrakeIsOn=true end elseif aj and j()==0 and a6~=nil and(fl==nil or fl.name==a6.name)then Autopilot=true;aj=false;AltitudeHold=false;AutoTakeoff=false;if Nav.axisCommandManager:getAxisCommandType(0)==1 then Nav.control.cancelCurrentControlMasterMode()end;AutopilotAccelerating=true end end;local jS=hoverDetectGround()>-1;local jT=cE;if(VectorToTarget or aj)and not jS and bg>minRollVelocity and j()>0.01 then local jt=math.rad(math.abs(dS))jT=cE*math.abs(math.cos(jt))+iI*math.sin(jt)end;local jU=utils.clamp(jc-jT,-PitchStallAngle*0.85,PitchStallAngle*0.85)if j()<0.01 and VectorToTarget then jU=utils.clamp(jc-jT,-85,MaxPitch)elseif j()<0.01 then jU=utils.clamp(jc-jT,-MaxPitch,MaxPitch)end;if math.abs(dS)<5 or VectorToTarget or BrakeLanding or jS or AltitudeHold then if pitchPID==nil then pitchPID=pid.new(5*0.01,0,5*0.1)end;pitchPID:inject(jU)local jd=pitchPID:get()O=O+jd end end;if antigrav~=nil and(antigrav and not ExternalAGG and ap<200000)then if AntigravTargetAltitude==nil or AntigravTargetAltitude<1000 then AntigravTargetAltitude=1000 end;if desiredBaseAltitude~=AntigravTargetAltitude then desiredBaseAltitude=AntigravTargetAltitude;antigrav.setBaseAltitude(desiredBaseAltitude)end end end end;function script.onFlush()if antigrav~=nil and(antigrav and not ExternalAGG)then if antigrav.getState()==0 and antigrav.getBaseAltitude()~=AntigravTargetAltitude then antigrav.setBaseAltitude(AntigravTargetAltitude)end end;if Nav.axisCommandManager:getAxisCommandType(0)==axisCommandType.byThrottle and D then z=0;Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal,z)D=false elseif Nav.axisCommandManager:getAxisCommandType(0)==axisCommandType.byTargetSpeed and not D then z=0;D=true end;pitchSpeedFactor=math.max(pitchSpeedFactor,0.01)yawSpeedFactor=math.max(yawSpeedFactor,0.01)rollSpeedFactor=math.max(rollSpeedFactor,0.01)torqueFactor=math.max(torqueFactor,0.01)brakeSpeedFactor=math.max(brakeSpeedFactor,0.01)brakeFlatFactor=math.max(brakeFlatFactor,0.01)autoRollFactor=math.max(autoRollFactor,0.01)turnAssistFactor=math.max(turnAssistFactor,0.01)local jV=utils.clamp(N+O+system.getControlDeviceForwardInput(),-1,1)local jW=utils.clamp(Q+T+system.getControlDeviceYawInput(),-1,1)local jX=utils.clamp(R+P-system.getControlDeviceLeftRightInput(),-1,1)local jY=S;local jZ=vec3(core.getWorldVertical())if jZ==nil or jZ:len()==0 then jZ=(planet.center-vec3(core.getConstructWorldPos())):normalize()end;local j_=vec3(core.getConstructWorldOrientationUp())local k0=vec3(core.getConstructWorldOrientationForward())local k1=vec3(core.getConstructWorldOrientationRight())local k2=vec3(core.getWorldVelocity())local k3=vec3(core.getWorldVelocity()):normalize()local k4=getRoll(jZ,k0,k1)local k5=math.abs(k4)local k6=utils.sign(k4)local j=j()local k7=vec3(core.getWorldAngularVelocity())local k8=jV*pitchSpeedFactor*k1+jW*rollSpeedFactor*k0+jX*yawSpeedFactor*j_;if jZ:len()>0.01 and(j>0.0 or ProgradeIsOn or Reentry or ai or AltitudeHold or IntoOrbit)then local dS=getRoll(jZ,k0,k1)local dT=dS/180*math.pi;local dU=math.cos(dT)local dV=math.sin(dT)local iG=getPitch(jZ,k0,k1*dU+j_*dV)if be==true and math.abs(bm-k4)>autoRollRollThreshold and jW==0 and math.abs(iG)<85 then local k9=bm;local ka=autoRollFactor;if j==0 then ka=ka/4;bm=0;k9=0 end;if rollPID==nil then rollPID=pid.new(ka*0.01,0,ka*0.1)end;rollPID:inject(k9-k4)local kb=rollPID:get()k8=k8+kb*k0 end end;if jZ:len()>0.01 and j>0.0 then local kc=20.0;if turnAssist==true and k5>kc and jV==0 and jX==0 then local kd=turnAssistFactor*0.1;local ke=turnAssistFactor*0.025;local kf=(k5-kc)/(180-kc)*180;local kg=0;if kf<90 then kg=kf/90 elseif kf<180 then kg=(180-kf)/90 end;kg=kg*kg;local kh=-k6*ke*(1.0-kg)local ki=kd*kg;k8=k8+ki*k1+kh*j_ end end;local kj=1;local kk=0;local kl=1;if system.getMouseWheel()>0 then if AltIsOn then if j>0 or Reentry then bp=utils.clamp(bp+speedChangeLarge,0,AtmoSpeedLimit)elseif Autopilot then MaxGameVelocity=utils.clamp(MaxGameVelocity+speedChangeLarge/3.6*100,0,8333.00)end;H=false else z=round(utils.clamp(z+speedChangeLarge/100,-1,1),2)end elseif system.getMouseWheel()<0 then if AltIsOn then if j>0 or Reentry then bp=utils.clamp(bp-speedChangeLarge,0,AtmoSpeedLimit)elseif Autopilot then MaxGameVelocity=utils.clamp(MaxGameVelocity-speedChangeLarge/3.6*100,0,8333.00)end;H=false else z=round(utils.clamp(z-speedChangeLarge/100,-1,1),2)end end;A=0;local em=-jZ:dot(k2)if ao and AtmoSpeedAssist and Nav.axisCommandManager:getAxisCommandType(0)==axisCommandType.byThrottle then if throttlePID==nil then throttlePID=pid.new(0.5,0,1)end;throttlePID:inject(bp/3.6-k2:dot(k0))local km=throttlePID:get()C=utils.clamp(km,-1,1)if C<z and j>0.005 then B=true;Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal,utils.clamp(C,0.01,1))else B=false;Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal,z)end;if brakePID==nil then brakePID=pid.new(1*0.01,0,1*0.1)end;brakePID:inject(k2:len()-bp/3.6)local kn=utils.clamp(brakePID:get(),0,1)if j>0 and em<-80 or j>0.005 then A=kn end;if A>0 then if B and C==0.01 then Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal,0)end else C=utils.clamp(C,0.01,1)end;local ko=''local kp=vec3()local kq=composeAxisAccelerationFromTargetSpeedV(axisCommandId.vertical,aa*1000)Nav:setEngineForceCommand("vertical airfoil , vertical ground ",kq,kk)local kr='thrust analog longitudinal 'if ExtraLongitudeTags~="none"then kr=kr..ExtraLongitudeTags end;local ks=Nav.axisCommandManager:getAxisCommandType(axisCommandId.longitudinal)local kt=Nav.axisCommandManager:composeAxisAccelerationFromThrottle(kr,axisCommandId.longitudinal)local ku=composeAxisAccelerationFromTargetSpeed(axisCommandId.lateral,LeftAmount*1000)ko=ko..' , '.."lateral airfoil , lateral ground "kp=kp+ku;if kp:len()>constants.epsilon then Nav:setEngineForceCommand(ko,kp,kk,'','','',kl)end;Nav:setEngineForceCommand(kr,kt,kj)local kv='thrust analog vertical fueled 'local kw='thrust analog lateral fueled 'if ExtraLateralTags~="none"then kw=kw..ExtraLateralTags end;if ExtraVerticalTags~="none"then kv=kv..ExtraVerticalTags end;if aa~=0 or BrakeLanding and BrakeIsOn then Nav:setEngineForceCommand(kv,kq,kj)else Nav:setEngineForceCommand(kv,vec3(),kj)end;if LeftAmount~=0 then Nav:setEngineForceCommand(kw,ku,kj)else Nav:setEngineForceCommand(kw,vec3(),kj)end;if jY==0 then jY=A end;local kx=-jY*(brakeSpeedFactor*k2+brakeFlatFactor*k3)Nav:setEngineForceCommand('brake',kx)else if AtmoSpeedAssist then Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal,z)end;local gh=unit.getAxisCommandValue(0)if Nav.axisCommandManager:getAxisCommandType(0)==axisCommandType.byTargetSpeed then if brakePID==nil then brakePID=pid.new(10*0.1,0,10*0.1)end;brakePID:inject(k2:len()-gh/3.6)local kn=utils.clamp(brakePID:get(),0,1)jY=utils.clamp(jY+kn,0,1)end;local kx=-jY*(brakeSpeedFactor*k2+brakeFlatFactor*k3)Nav:setEngineForceCommand('brake',kx)local ko=''local kp=vec3()local ky=false;local kr='thrust analog longitudinal 'if ExtraLongitudeTags~="none"then kr=kr..ExtraLongitudeTags end;local ks=Nav.axisCommandManager:getAxisCommandType(axisCommandId.longitudinal)if ks==axisCommandType.byThrottle then local kt=Nav.axisCommandManager:composeAxisAccelerationFromThrottle(kr,axisCommandId.longitudinal)Nav:setEngineForceCommand(kr,kt,kj)elseif ks==axisCommandType.byTargetSpeed then local kt=Nav.axisCommandManager:composeAxisAccelerationFromTargetSpeed(axisCommandId.longitudinal)ko=ko..' , '..kr;kp=kp+kt;if Nav.axisCommandManager:getTargetSpeed(axisCommandId.longitudinal)==0 or Nav.axisCommandManager:getCurrentToTargetDeltaSpeed(axisCommandId.longitudinal)<-Nav.axisCommandManager:getTargetSpeedCurrentStep(axisCommandId.longitudinal)*0.5 then ky=true end end;local kw='thrust analog lateral 'if ExtraLateralTags~="none"then kw=kw..ExtraLateralTags end;local kz=Nav.axisCommandManager:getAxisCommandType(axisCommandId.lateral)if kz==axisCommandType.byThrottle then local kA=Nav.axisCommandManager:composeAxisAccelerationFromThrottle(kw,axisCommandId.lateral)Nav:setEngineForceCommand(kw,kA,kj)elseif kz==axisCommandType.byTargetSpeed then local ku=Nav.axisCommandManager:composeAxisAccelerationFromTargetSpeed(axisCommandId.lateral)ko=ko..' , '..kw;kp=kp+ku end;local kv='thrust analog vertical 'if ExtraVerticalTags~="none"then kv=kv..ExtraVerticalTags end;local kB=Nav.axisCommandManager:getAxisCommandType(axisCommandId.vertical)if kB==axisCommandType.byThrottle then local kq=Nav.axisCommandManager:composeAxisAccelerationFromThrottle(kv,axisCommandId.vertical)if aa~=0 or BrakeLanding and BrakeIsOn then Nav:setEngineForceCommand(kv,kq,kj,'airfoil','ground','',kl)else Nav:setEngineForceCommand(kv,vec3(),kj)Nav:setEngineForceCommand('airfoil vertical',kq,kj,'airfoil','','',kl)Nav:setEngineForceCommand('ground vertical',kq,kj,'ground','','',kl)end elseif kB==axisCommandType.byTargetSpeed then if aa<0 then Nav:setEngineForceCommand('hover',vec3(),kj)end;local kC=Nav.axisCommandManager:composeAxisAccelerationFromTargetSpeed(axisCommandId.vertical)ko=ko..' , '..kv;kp=kp+kC end;if kp:len()>constants.epsilon then if S~=0 or ky or k3:dot(k0)<0.8 then ko=ko..', brake'end;Nav:setEngineForceCommand(ko,kp,kk,'','','',kl)end end;local kD=torqueFactor*(k8-k7)local kE=vec3(core.getWorldAirFrictionAngularAcceleration())kD=kD-kE;Nav:setEngineTorqueCommand('torque',kD,kj,'airfoil','','',kl)Nav:setBoosterCommand('rocket_engine')if a1 and not VanillaRockets then local bX=vec3(core.getVelocity()):len()local kF=0.15;if Nav.axisCommandManager:getAxisCommandType(0)==1 then local kG=Nav.axisCommandManager:getTargetSpeed(axisCommandId.longitudinal)if bX*3.6>kG*(1-kF)and IsRocketOn then IsRocketOn=false;Nav:toggleBoosters()elseif bX*3.6<kG*(1-kF)and not IsRocketOn then IsRocketOn=true;Nav:toggleBoosters()end else local fN=unit.getThrottle()if AtmoSpeedAssist then fN=z*100 end;local gh=fN/100;if j==0 then gh=gh*MaxGameVelocity;if bX>=gh*(1-kF)and IsRocketOn then IsRocketOn=false;Nav:toggleBoosters()elseif bX<gh*(1-kF)and not IsRocketOn then IsRocketOn=true;Nav:toggleBoosters()end else gh=gh*ReentrySpeed/3.6;if bX>=gh*(1-kF)and IsRocketOn then IsRocketOn=false;Nav:toggleBoosters()elseif bX<gh*(1-kF)and not IsRocketOn then IsRocketOn=true;Nav:toggleBoosters()end end end end end;function script.onUpdate()if not SetupComplete then local _,bI=coroutine.resume(beginSetup)if bI then SetupComplete=true end else Nav:update()if not bc and content~=LastContent then system.setScreen(content)end;LastContent=content end end;function script.onActionStart(kH)if kH=="gear"then GearExtended=not GearExtended;if GearExtended then VectorToTarget=false;LockPitch=nil;if Nav.axisCommandManager:getAxisCommandType(0)==1 then Nav.control.cancelCurrentControlMasterMode()end;Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal,0)z=0;if(vBooster or hover)and al==-1 and(j()>0 or ap<ReentryAltitude)then StrongBrakes=true;Reentry=false;AutoTakeoff=false;VertTakeOff=false;AltitudeHold=false;BrakeLanding=true;be=true;GearExtended=false else BrakeIsOn=true;Nav.control.extendLandingGears()Nav.axisCommandManager:setTargetGroundAltitude(LandingGearGroundHeight)end;if M and not BrakeLanding then Nav.control.extendLandingGears()end else if M then Nav.control.retractLandingGears()end;Nav.axisCommandManager:setTargetGroundAltitude(TargetHoverHeight)end elseif kH=="light"then if Nav.control.isAnyHeadlightSwitchedOn()==1 then Nav.control.switchOffHeadlights()else Nav.control.switchOnHeadlights()end elseif kH=="forward"then N=N-1 elseif kH=="backward"then N=N+1 elseif kH=="left"then Q=Q-1 elseif kH=="right"then Q=Q+1 elseif kH=="yawright"then R=R-1 elseif kH=="yawleft"then R=R+1 elseif kH=="straferight"then Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.lateral,1.0)LeftAmount=1 elseif kH=="strafeleft"then Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.lateral,-1.0)LeftAmount=-1 elseif kH=="up"then aa=aa+1;Nav.axisCommandManager:deactivateGroundEngineAltitudeStabilization()Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.vertical,1.0)elseif kH=="down"then aa=aa-1;Nav.axisCommandManager:deactivateGroundEngineAltitudeStabilization()Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.vertical,-1.0)elseif kH=="groundaltitudeup"then if antigrav and not ExternalAGG and antigrav.getState()==1 then if AntigravTargetAltitude~=nil then if AltitudeHold and AntigravTargetAltitude<HoldAltitude+10 and AntigravTargetAltitude>HoldAltitude-10 then AntigravTargetAltitude=AntigravTargetAltitude+Y;HoldAltitude=AntigravTargetAltitude else AntigravTargetAltitude=AntigravTargetAltitude+Y end else AntigravTargetAltitude=desiredBaseAltitude+100 end elseif AltitudeHold then HoldAltitude=HoldAltitude+X elseif IntoOrbit then by=by+X else Nav.axisCommandManager:updateTargetGroundAltitudeFromActionStart(1.0)end elseif kH=="groundaltitudedown"then if antigrav and not ExternalAGG and antigrav.getState()==1 then if AntigravTargetAltitude~=nil then if AltitudeHold and AntigravTargetAltitude<HoldAltitude+10 and AntigravTargetAltitude>HoldAltitude-10 then AntigravTargetAltitude=AntigravTargetAltitude-Y;if AntigravTargetAltitude<1000 then AntigravTargetAltitude=1000 end;HoldAltitude=AntigravTargetAltitude else AntigravTargetAltitude=AntigravTargetAltitude-Y;if AntigravTargetAltitude<1000 then AntigravTargetAltitude=1000 end end else AntigravTargetAltitude=desiredBaseAltitude end elseif AltitudeHold then HoldAltitude=HoldAltitude-X elseif IntoOrbit then by=by-X;if by<planet.noAtmosphericDensityAltitude+100 then by=planet.noAtmosphericDensityAltitude+100 end else Nav.axisCommandManager:updateTargetGroundAltitudeFromActionStart(-1.0)end elseif kH=="option1"then if not Autopilot then IncrementAutopilotTargetIndex()H=false end elseif kH=="option2"then if not Autopilot then DecrementAutopilotTargetIndex()H=false end elseif kH=="option3"then if hideHudOnToggleWidgets then if showHud then showHud=false else showHud=true end end;H=false;ToggleWidgets()elseif kH=="option4"then ToggleAutopilot()H=false elseif kH=="option5"then ToggleLockPitch()H=false elseif kH=="option6"then ToggleAltitudeHold()H=false elseif kH=="option7"then wipeSaveVariables()H=false elseif kH=="option8"then ToggleFollowMode()H=false elseif kH=="option9"then if gyro~=nil then gyro.toggle()as=gyro.getState()==1 end;H=false elseif kH=="lshift"then if system.isViewLocked()==1 then V=true;PrevViewLock=system.isViewLocked()system.lockView(1)elseif o()==1 and ShiftShowsRemoteButtons then V=true;bd=false;bc=false end elseif kH=="brake"then if BrakeToggleStatus then BrakeToggle()elseif not BrakeIsOn then BrakeToggle()else BrakeIsOn=true end elseif kH=="lalt"then AltIsOn=true;if o()==0 and not freeLookToggle and userControlScheme=="keyboard"then system.lockView(1)end elseif kH=="booster"then if VanillaRockets then Nav:toggleBoosters()elseif not a1 then if not IsRocketOn then Nav:toggleBoosters()IsRocketOn=true end;a1=true else if IsRocketOn then Nav:toggleBoosters()IsRocketOn=false end;a1=false end elseif kH=="stopengines"then Nav.axisCommandManager:resetCommand(axisCommandId.longitudinal)clearAll()z=0 elseif kH=="speedup"then if not V then if AtmoSpeedAssist and not AltIsOn then z=utils.clamp(z+speedChangeLarge/100,-1,1)else Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.longitudinal,speedChangeLarge)end else IncrementAutopilotTargetIndex()end elseif kH=="speeddown"then if not V then if AtmoSpeedAssist and not AltIsOn then z=utils.clamp(z-speedChangeLarge/100,-1,1)else Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.longitudinal,-speedChangeLarge)end else DecrementAutopilotTargetIndex()end elseif kH=="antigravity"and not ExternalAGG then if antigrav~=nil then ToggleAntigrav()end end end;function script.onActionStop(kH)if kH=="forward"then N=0 elseif kH=="backward"then N=0 elseif kH=="left"then Q=0 elseif kH=="right"then Q=0 elseif kH=="yawright"then R=0 elseif kH=="yawleft"then R=0 elseif kH=="straferight"then Nav.axisCommandManager:updateCommandFromActionStop(axisCommandId.lateral,-1.0)LeftAmount=0 elseif kH=="strafeleft"then Nav.axisCommandManager:updateCommandFromActionStop(axisCommandId.lateral,1.0)LeftAmount=0 elseif kH=="up"then aa=0;Nav.axisCommandManager:updateCommandFromActionStop(axisCommandId.vertical,-1.0)Nav.axisCommandManager:activateGroundEngineAltitudeStabilization(currentGroundAltitudeStabilization)Nav:setEngineForceCommand('hover',vec3(),1)elseif kH=="down"then aa=0;Nav.axisCommandManager:updateCommandFromActionStop(axisCommandId.vertical,1.0)Nav.axisCommandManager:activateGroundEngineAltitudeStabilization(currentGroundAltitudeStabilization)Nav:setEngineForceCommand('hover',vec3(),1)elseif kH=="groundaltitudeup"then a0=Y;Z=X;H=false elseif kH=="groundaltitudedown"then a0=Y;Z=X;H=false elseif kH=="lshift"then if system.isViewLocked()==1 then V=false;ab=0;ac=0;system.lockView(PrevViewLock)elseif o()==1 and ShiftShowsRemoteButtons then V=false;bd=false;bc=false end elseif kH=="brake"then if not BrakeToggleStatus then if BrakeIsOn then BrakeToggle()else BrakeIsOn=false end end elseif kH=="lalt"then if o()==0 and freeLookToggle then if H then if system.isViewLocked()==1 then system.lockView(0)else system.lockView(1)end else H=true end elseif o()==0 and not freeLookToggle and userControlScheme=="keyboard"then system.lockView(0)end;AltIsOn=false end end;function script.onActionLoop(kH)if kH=="groundaltitudeup"then if antigrav and not ExternalAGG and antigrav.getState()==1 then if AntigravTargetAltitude~=nil then if AltitudeHold and AntigravTargetAltitude<HoldAltitude+10 and AntigravTargetAltitude>HoldAltitude-10 then AntigravTargetAltitude=AntigravTargetAltitude+a0;HoldAltitude=AntigravTargetAltitude else AntigravTargetAltitude=AntigravTargetAltitude+a0 end;a0=a0*1.05;BrakeIsOn=false else AntigravTargetAltitude=desiredBaseAltitude+100;BrakeIsOn=false end elseif AltitudeHold then HoldAltitude=HoldAltitude+Z;Z=Z*1.05 elseif IntoOrbit then by=by+Z;Z=Z*1.05 else Nav.axisCommandManager:updateTargetGroundAltitudeFromActionLoop(1.0)end elseif kH=="groundaltitudedown"then if antigrav and not ExternalAGG and antigrav.getState()==1 then if AntigravTargetAltitude~=nil then if AltitudeHold and AntigravTargetAltitude<HoldAltitude+10 and AntigravTargetAltitude>HoldAltitude-10 then AntigravTargetAltitude=AntigravTargetAltitude-a0;if AntigravTargetAltitude<1000 then AntigravTargetAltitude=1000 end;HoldAltitude=AntigravTargetAltitude else AntigravTargetAltitude=AntigravTargetAltitude-a0;if AntigravTargetAltitude<1000 then AntigravTargetAltitude=1000 end end;a0=a0*1.05;BrakeIsOn=false else AntigravTargetAltitude=desiredBaseAltitude-100;BrakeIsOn=false end elseif AltitudeHold then HoldAltitude=HoldAltitude-Z;Z=Z*1.05 elseif IntoOrbit then by=by-Z;if by<planet.noAtmosphericDensityAltitude+100 then by=planet.noAtmosphericDensityAltitude+100 end;Z=Z*1.05 else Nav.axisCommandManager:updateTargetGroundAltitudeFromActionLoop(-1.0)end elseif kH=="speedup"then if not V then if AtmoSpeedAssist and not AltIsOn then z=utils.clamp(z+speedChangeSmall/100,-1,1)else Nav.axisCommandManager:updateCommandFromActionLoop(axisCommandId.longitudinal,speedChangeSmall)end end elseif kH=="speeddown"then if not V then if AtmoSpeedAssist and not AltIsOn then z=utils.clamp(z-speedChangeSmall/100,-1,1)else Nav.axisCommandManager:updateCommandFromActionLoop(axisCommandId.longitudinal,-speedChangeSmall)end end end end;function script.onInputText(dG)local i;local kI="/commands /setname /G /agg /addlocation /copydatabank"local kJ,kK=nil,nil;local kL="Command List:\n/commands \n/setname <newname> - Updates current selected saved position name\n/G VariableName newValue - Updates global variable to new value\n".."/G dump - shows all updatable variables with /G\n/agg <targetheight> - Manually set agg target height\n".."/addlocation savename ::pos{0,2,46.4596,-155.1799,22.6572} - adds a saved location by waypoint, not as accurate as making one at location\n".."/copydatabank - copies dbHud databank to a blank databank"i=string.find(dG," ")kJ=dG;if i~=nil then kJ=string.sub(dG,0,i-1)kK=string.sub(dG,i+1)elseif not string.find(kI,kJ)then for gd in string.gmatch(kL,"([^\n]+)")do c(gd)end;return end;if kJ=="/setname"then if kK==nil or kK==""then W="Usage: /setname Newname"return end;if AutopilotTargetIndex>0 and CustomTarget~=nil then UpdatePosition(kK)else W="Select a saved target to rename first"end elseif kJ=="/addlocation"then if kK==nil or kK==""or string.find(kK,"::")==nil then W="Usage: /addlocation savename ::pos{0,2,46.4596,-155.1799,22.6572}"return end;i=string.find(kK,"::")local cr=string.sub(kK,1,i-2)local cl=string.sub(kK,i)local q=' *([+-]?%d+%.?%d*e?[+-]?%d*)'local cm='::pos{'..q..','..q..','..q..','..q..','..q..'}'local cn,co,ci,cj,ch=string.match(cl,cm)local planet=b2[tonumber(cn)][tonumber(co)]AddNewLocationByWaypoint(cr,planet,cl)W="Added "..cr.." to saved locations,\nplanet "..planet.name.." at "..cl;ad=5 elseif kJ=="/agg"then if kK==nil or kK==""then W="Usage: /agg targetheight"return end;kK=tonumber(kK)if kK<1000 then kK=1000 end;AntigravTargetAltitude=kK;W="AGG Target Height set to "..kK elseif kJ=="/G"then if kK==nil or kK==""then W="Usage: /G VariableName variablevalue\n/G dump - shows all variables"return end;if kK=="dump"then for bG,bH in pairs(a)do if type(_G[bH])=="boolean"then if _G[bH]==true then c(bH.." true")else c(bH.." false")end elseif _G[bH]==nil then c(bH.." nil")else c(bH.." ".._G[bH])end end;return end;i=string.find(kK," ")local kM=string.sub(kK,0,i-1)local kN=string.sub(kK,i+1)for bG,bH in pairs(a)do if bH==kM then W="Variable "..kM.." changed to "..kN;local kO=type(_G[bH])if kO=="number"then kN=tonumber(kN)elseif kO=="boolean"then if string.lower(kN)=="true"then kN=true else kN=false end end;_G[bH]=kN;return end end;W="No such global variable: "..kM elseif kJ=="/copydatabank"then if dbHud_2 then SaveDataBank(true)else W="Databank required to copy databank"end end end;script.onStart()
    end
    return vanillaMaxVolume            
end

function ProcessElements()
    local checkTanks = (fuelX ~= 0 and fuelY ~= 0)
    for k in pairs(elementsID) do
        local type = eleType(elementsID[k])
        if string.match(type, '^.*Space Engine$') then
            SpaceEngines = true
            if string.match(tostring(core.getElementTagsById(elementsID[k])), '^.*vertical.*$') then
                local enrot = core.getElementRotationById(elementsID[k])
                if enrot[4] < 0 then
                    if utils.round(-enrot[4],0.1) == 0.5 then
                        SpaceEngineVertUp = true
                        system.print("Space Engine Up detected")
                    end
                else
                    if utils.round(enrot[4],0.1) == 0.5 then
                        SpaceEngineVertDn = true
                        system.print("Space Engine Down detected")
                    end
                end
            end
        end
        if (type == "Landing Gear") then
            hasGear = true
        end
        if (type == "Dynamic Core Unit") then
            local hp = eleMaxHp(elementsID[k])
            if hp > 10000 then
                coreOffset = 128
            elseif hp > 1000 then
                coreOffset = 64
            elseif hp > 150 then
                coreOffset = 32
            end
        end
        eleTotalMaxHp = eleTotalMaxHp + eleMaxHp(elementsID[k])
        if checkTanks and (type == "Atmospheric Fuel Tank" or type == "Space Fuel Tank" or type == "Rocket Fuel Tank") then
            local hp = eleMaxHp(elementsID[k])
            local mass = eleMass(elementsID[k])
            local curMass = 0
            local curTime = system.getTime()
            if (type == "Atmospheric Fuel Tank") then
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
                vanillaMaxVolume =  CalculateFuelVolume(curMass, vanillaMaxVolume)
                atmoTanks[#atmoTanks + 1] = {elementsID[k], core.getElementNameById(elementsID[k]),
                                            vanillaMaxVolume, massEmpty, curMass, curTime}
            end
            if (type == "Rocket Fuel Tank") then
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
                    vanillaMaxVolume = vanillaMaxVolume + (vanillaMaxVolume * (fuelTankHandlingRocket * 0.1))
                end
                vanillaMaxVolume =  CalculateFuelVolume(curMass, vanillaMaxVolume)
                rocketTanks[#rocketTanks + 1] = {elementsID[k], core.getElementNameById(elementsID[k]),
                                                vanillaMaxVolume, massEmpty, curMass, curTime}
            end
            if (type == "Space Fuel Tank") then
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
                vanillaMaxVolume =  CalculateFuelVolume(curMass, vanillaMaxVolume)
                spaceTanks[#spaceTanks + 1] = {elementsID[k], core.getElementNameById(elementsID[k]),
                                            vanillaMaxVolume, massEmpty, curMass, curTime}
            end
        end
    end
end

function SetupChecks()
    if gyro ~= nil then
        gyroIsOn = gyro.getState() == 1
    end
    if userControlScheme ~= "keyboard" then
        system.lockView(1)
    else
        system.lockView(0)
    end
    -- Close door and retract ramp if available
    local atmo = atmosphere()
    if door and (atmo > 0 or (atmo == 0 and coreAltitude < 10000)) then
        for _, v in pairs(door) do
            v.toggle()
        end
    end
    if switch then 
        for _, v in pairs(switch) do
            v.toggle()
        end
    end    
    if forcefield and (atmo > 0 or (atmo == 0 and coreAltitude < 10000)) then
        for _, v in pairs(forcefield) do
            v.toggle()
        end
    end
    if antigrav ~= nil and not ExternalAGG then
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
    if hasGear then
        GearExtended = (Nav.control.isAnyLandingGearExtended() == 1)
        if GearExtended then
            Nav.control.extendLandingGears()
        else
            Nav.control.retractLandingGears()
        end
    end
    
    local aboveGroundLevel = AboveGroundLevel()

    -- Engage brake and extend Gear if either a hover detects something, or they're in space and moving very slowly
    if aboveGroundLevel ~= -1 or (not inAtmo and vec3(core.getVelocity()):len() < 50) then
        BrakeIsOn = true
        if not hasGear then
            GearExtended = true
        end
    else
        BrakeIsOn = false
    end

    if targetGroundAltitude ~= nil then
        Nav.axisCommandManager:setTargetGroundAltitude(targetGroundAltitude)
        if targetGroundAltitude == 0 and not hasGear then 
            GearExtended = true
            BrakeIsOn = true -- If they were hovering at 0 and have no gear, consider them landed 
        end
    else
        targetGroundAltitude = Nav:getTargetGroundAltitude() 
        if GearExtended then -- or not hasGear then -- And we already tagged GearExtended if they don't have gear, we can just use this
            Nav.axisCommandManager:setTargetGroundAltitude(LandingGearGroundHeight)
            --GearExtended = true -- We don't need to extend gear just because they have a databank, that would have been done earlier if necessary
        else
            Nav.axisCommandManager:setTargetGroundAltitude(TargetHoverHeight)
        end
    end

    -- Store their max kinematic parameters in ship-up direction for use in brake-landing
    if inAtmo and aboveGroundLevel ~= -1 then 
        maxKinematicUp = core.getMaxKinematicsParametersAlongAxis("ground", core.getConstructOrientationUp())[1]
    end
    -- For now, for simplicity, we only do this once at startup and store it.  If it's nonzero, later we use it. 
    userControlScheme = string.lower(userControlScheme)
    WasInAtmo = inAtmo
end

function ConvertResolutionX (v)
    if ResolutionX == 1920 then 
        return v
    else
        return round(ResolutionX * v / 1920, 0)
    end
end

function ConvertResolutionY (v)
    if ResolutionY == 1080 then 
        return v
    else
        return round(ResolutionY * v / 1080, 0)
    end
end

function RefreshLastMaxBrake(gravity, force)
    if gravity == nil then
        gravity = core.g()
    end
    gravity = round(gravity, 5) -- round to avoid insignificant updates
    local atmoden = atmosphere()
    if (force ~= nil and force) or (lastMaxBrakeAtG == nil or lastMaxBrakeAtG ~= gravity) then
        local velocity = core.getVelocity()
        local speed = vec3(velocity):len()
        local maxBrake = jdecode(unit.getData()).maxBrake 
        if maxBrake ~= nil and maxBrake > 0 and inAtmo then 
            maxBrake = maxBrake / utils.clamp(speed/100, 0.1, 1)
            maxBrake = maxBrake / atmoden
            --if maxBrake > LastMaxBrakeInAtmo and atmoden > 0.10 then LastMaxBrakeInAtmo = maxBrake end
            if atmoden > 0.10 then 
                if LastMaxBrakeInAtmo then
                    LastMaxBrakeInAtmo = (LastMaxBrakeInAtmo + maxBrake) / 2
                else
                    LastMaxBrakeInAtmo = maxBrake 
                end
            end -- Now that we're calculating actual brake values, we want this updated
                -- We were ignoring real brake calculations and overriding them with previous wrong, but higher, brake calculations
                -- Also, ideally this would always give us the same value, but because it's DU they don't.  Sometimes it's a bit off.  
                -- We should keep a rolling average to smooth any offness.
        end
        if maxBrake ~= nil and maxBrake > 0 then
            LastMaxBrake = maxBrake
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

function float_eq(a, b)
    if a == 0 then
        return math.abs(b) < 1e-09
    end
    if b == 0 then
        return math.abs(a) < 1e-09
    end
    return math.abs(a - b) < math.max(math.abs(a), math.abs(b)) * epsilon
end

function zeroConvertToMapPosition(targetplanet, worldCoordinates)
    local worldVec = vec3(worldCoordinates)
    if targetplanet.bodyId == 0 then
        return setmetatable({
            latitude = worldVec.x,
            longitude = worldVec.y,
            altitude = worldVec.z,
            bodyId = 0,
            systemId = targetplanet.planetarySystemId
        }, MapPosition)
    end
    local coords = worldVec - targetplanet.center
    local distance = coords:len()
    local altitude = distance - targetplanet.radius
    local latitude = 0
    local longitude = 0
    if not float_eq(distance, 0) then
        local phi = math.atan(coords.y, coords.x)
        longitude = phi >= 0 and phi or (2 * math.pi + phi)
        latitude = math.pi / 2 - math.acos(coords.z / distance)
    end
    return setmetatable({
        latitude = math.deg(latitude),
        longitude = math.deg(longitude),
        altitude = altitude,
        bodyId = targetplanet.bodyId,
        systemId = targetplanet.planetarySystemId
    }, MapPosition)
end

function zeroConvertToWorldCoordinates(pos) -- Many thanks to SilverZero for this.
    local num  = ' *([+-]?%d+%.?%d*e?[+-]?%d*)'
    local posPattern = '::pos{' .. num .. ',' .. num .. ',' ..  num .. ',' .. num ..  ',' .. num .. '}'    
    local systemId, bodyId, latitude, longitude, altitude = string.match(pos, posPattern)
    if (systemId == "0" and bodyId == "0") then
        return vec3(tonumber(latitude),
                    tonumber(longitude),
                    tonumber(altitude))
    end
    longitude = math.rad(longitude)
    latitude = math.rad(latitude)
    local planet = atlas[tonumber(systemId)][tonumber(bodyId)]  
    local xproj = math.cos(latitude);   
    local planetxyz = vec3(xproj*math.cos(longitude),
                          xproj*math.sin(longitude),
                             math.sin(latitude));
    return planet.center + (planet.radius + altitude) * planetxyz
end

function AddNewLocationByWaypoint(savename, planet, pos)
    if dbHud_1 then
        local newLocation = {}
        local position = zeroConvertToWorldCoordinates(pos)
        if planet.name == "Space" then
            newLocation = {
                position = position,
                name = savename,
                atmosphere = false,
                planetname = planet.name,
                gravity = planet.gravity
            }
        else
            local atmo = false
            if planet.hasAtmosphere then
                atmo = true 
            else 
                atmo = false 
            end
            newLocation = {
                position = position,
                name = savename,
                atmosphere = atmo,
                planetname = planet.name,
                gravity = planet.gravity
            }
        end
        SavedLocations[#SavedLocations + 1] = newLocation
        table.insert(atlas[0], newLocation)
        UpdateAtlasLocationsList()
    else
        msgText = "Databank must be installed to save locations"
    end
end

function AddNewLocation() -- Don't call this unless they have a databank or it's kinda pointless
    -- Add a new location to SavedLocations
    if dbHud_1 then
        local position = vec3(core.getConstructWorldPos())
        local name = planet.name .. ". " .. #SavedLocations
        if radar_1 then -- Just match the first one
            local id,_ = radar_1.getData():match('"constructId":"([0-9]*)","distance":([%d%.]*)')
            if id ~= nil and id ~= "" then
                name = name .. " " .. radar_1.getConstructName(id)
            end
        end
        local newLocation = {}
        local atmo = false
        if planet.hasAtmosphere then
            atmo = true 
        end
        newLocation = {
            position = position,
            name = name,
            atmosphere = atmo,
            planetname = planet.name,
            gravity = planet.gravity,
            safe = true -- This indicates we can extreme land here, because this was a real positional waypoint
        }
        SavedLocations[#SavedLocations + 1] = newLocation
        -- Nearest planet, gravity also important - if it's 0, we don't autopilot to the target planet, the target isn't near a planet.                      
        table.insert(atlas[0], newLocation)
        UpdateAtlasLocationsList()
        -- Store atmosphere so we know whether the location is in space or not
        msgText = "Location saved as " .. name
    else
        msgText = "Databank must be installed to save locations"
    end
end

function UpdatePosition(newName)
    local index = -1
    local newLocation
    for k, v in pairs(SavedLocations) do
        if v.name and v.name == CustomTarget.name then
            index = k
            break
        end
    end
    if index ~= -1 then
        local updatedName
        if newName ~= nil then
            newLocation = {
                position = SavedLocations[index].position,
                name = newName,
                atmosphere = SavedLocations[index].atmosphere,
                planetname = SavedLocations[index].planetname,
                gravity = SavedLocations[index].gravity
            } 
        else
            newLocation = {
                position = vec3(core.getConstructWorldPos()),
                name = SavedLocations[index].name,
                atmosphere = atmosphere(),
                planetname = planet.name,
                gravity = unit.getClosestPlanetInfluence(),
                safe = true
            }   
        end
        SavedLocations[index] = newLocation
        index = -1
        for k, v in pairs(atlas[0]) do
            if v.name and v.name == CustomTarget.name then
                index = k
            end
        end
        if index > -1 then
            atlas[0][index] = newLocation
        end
        UpdateAtlasLocationsList()
        msgText = CustomTarget.name .. " position updated"
        AutopilotTargetIndex = 0
        UpdateAutopilotTarget()
    else
        msgText = "Name Not Found"
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
            msgText = v.name .. " saved location cleared"
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
    if radarPanelID ~= nil and peris == 0 then
        system.destroyWidgetPanel(radarPanelID)
        radarPanelID = nil
        if perisPanelID ~= nil then
            system.destroyWidgetPanel(perisPanelID)
            perisPanelID = nil
        end
    else
        -- If radar is installed but no weapon, don't show periscope
        if peris == 1 then
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
        peris = 0
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

function SetupInterplanetaryPanel() -- Interplanetary helper
    panelInterplanetary = system.createWidgetPanel("Interplanetary Helper")
    interplanetaryHeader = system.createWidget(panelInterplanetary, "value")
    interplanetaryHeaderText = system.createData('{"label": "Target Planet", "value": "N/A", "unit":""}')
    system.addDataToWidget(interplanetaryHeaderText, interplanetaryHeader)
    widgetDistance = system.createWidget(panelInterplanetary, "value")
    widgetDistanceText = system.createData('{"label": "distance", "value": "N/A", "unit":""}')
    system.addDataToWidget(widgetDistanceText, widgetDistance)
    widgetTravelTime = system.createWidget(panelInterplanetary, "value")
    widgetTravelTimeText = system.createData('{"label": "Travel Time", "value": "N/A", "unit":""}')
    system.addDataToWidget(widgetTravelTimeText, widgetTravelTime)
    widgetMaxMass = system.createWidget(panelInterplanetary, "value")
    widgetMaxMassText = system.createData('{"label": "Maximum Mass", "value": "N/A", "unit":""}')
    system.addDataToWidget(widgetMaxMassText, widgetMaxMass)
    widgetCurBrakeDistance = system.createWidget(panelInterplanetary, "value")
    widgetCurBrakeDistanceText = system.createData('{"label": "Cur Brake distance", "value": "N/A", "unit":""}')
    if not inAtmo then
        system.addDataToWidget(widgetCurBrakeDistanceText, widgetCurBrakeDistance)
    end
    widgetCurBrakeTime = system.createWidget(panelInterplanetary, "value")
    widgetCurBrakeTimeText = system.createData('{"label": "Cur Brake Time", "value": "N/A", "unit":""}')
    if not inAtmo then
        system.addDataToWidget(widgetCurBrakeTimeText, widgetCurBrakeTime)
    end
    widgetMaxBrakeDistance = system.createWidget(panelInterplanetary, "value")
    widgetMaxBrakeDistanceText = system.createData('{"label": "Max Brake distance", "value": "N/A", "unit":""}')
    if not inAtmo then
        system.addDataToWidget(widgetMaxBrakeDistanceText, widgetMaxBrakeDistance)
    end
    widgetMaxBrakeTime = system.createWidget(panelInterplanetary, "value")
    widgetMaxBrakeTimeText = system.createData('{"label": "Max Brake Time", "value": "N/A", "unit":""}')
    if not inAtmo then
        system.addDataToWidget(widgetMaxBrakeTimeText, widgetMaxBrakeTime)
    end
    widgetTrajectoryAltitude = system.createWidget(panelInterplanetary, "value")
    widgetTrajectoryAltitudeText = system.createData(
                                       '{"label": "Projected Altitude", "value": "N/A", "unit":""}')
    if not inAtmo then
        system.addDataToWidget(widgetTrajectoryAltitudeText, widgetTrajectoryAltitude)
    end


    widgetTargetOrbit = system.createWidget(panelInterplanetary, "value")
    widgetTargetOrbitText = system.createData('{"label": "Target Altitude", "value": "N/A", "unit":""}')
    --if not inAtmo then
        system.addDataToWidget(widgetTargetOrbitText, widgetTargetOrbit)
    --end
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

function ToggleVectorToTarget(SpaceTarget)
    -- This is a feature to vector toward the target destination in atmo or otherwise on-planet
    -- Uses altitude hold.  
    VectorToTarget = not VectorToTarget
    if VectorToTarget then
        TurnBurn = false
        if not AltitudeHold and not SpaceTarget then
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
        StrongBrakes = ((planet.gravity * 9.80665 * constructMass()) < LastMaxBrake)
        --if not StrongBrakes and velMag > minAutopilotSpeed then
        --    msgText = "WARNING: Insufficient Brakes - Attempting coast landing, beware obstacles"
        --end
        AltitudeHold = false
        AutoTakeoff = false
        LockPitch = nil
        BrakeLanding = true
        Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0)
        PlayerThrottle = 0
    end
end

function ToggleAutoTakeoff()
    if AutoTakeoff then
        -- Turn it off, and also AltitudeHold cuz it's weird if you cancel and that's still going 
        AutoTakeoff = false
        if AltitudeHold then
            ToggleAltitudeHold()
        end
    elseif VertTakeOff then
        BrakeLanding = true
        VertTakeOff = false
        AltitudeHold = false
    else
        if VertTakeOffEngine then
            VertTakeOff = true
            AltitudeHold = false
        else
            if not AltitudeHold then
                ToggleAltitudeHold()
            end
            AutoTakeoff = true
            HoldAltitude = coreAltitude + AutoTakeoffAltitude
        end
        OrbitAchieved = false
        GearExtended = false
        Nav.control.retractLandingGears()
        Nav.axisCommandManager:setTargetGroundAltitude(500) -- Hard set this for takeoff, you wouldn't use takeoff from a hangar
        BrakeIsOn = true
    end
end

function ToggleIntoOrbit()
    if atmosphere() == 0 then
        if IntoOrbit then
            OrbitAchieved = false
            IntoOrbit = false
            orbitAligned = false
            orbitPitch = nil
            orbitRoll = nil
            OrbitTargetPlanet = nil
            OrbitTicks = 0
            autoRoll = autoRollPreference
            if AltitudeHold then AltitudeHold = false AutoTakeoff = false end
            orbitalParams.VectorToTarget = false
            orbitalParams.AutopilotAlign = false
            OrbitTargetSet = false
        elseif unit.getClosestPlanetInfluence() > 0 then
            IntoOrbit = true
            autoRoll = true
            OrbitAchieved = false
            orbitPitch = nil
            orbitRoll = nil
            OrbitTicks = 0
            if OrbitTargetPlanet == nil then
                OrbitTargetPlanet = planet
            end
            if AltitudeHold then AltitudeHold = false AutoTakeoff = false end
        else
            CancelIntoOrbit = true
        end
        OrbitAchieved = false
        IntoOrbit = false
        orbitAligned = false
        orbitPitch = nil
        orbitRoll = nil
        OrbitTargetPlanet = nil
        OrbitTicks = 0
        autoRoll = autoRollPreference
        if AltitudeHold then ToggleAltitudeHold() end
        orbitalParams.VectorToTarget = false
        orbitalParams.AutopilotAlign = false
        OrbitTargetSet = false
    end
end

function ToggleLockPitch()
    if LockPitch == nil then
        local constrF = vec3(core.getConstructWorldOrientationForward())
        local constrR = vec3(core.getConstructWorldOrientationRight())
        local worldV = vec3(core.getWorldVertical())
        local pitch = getPitch(worldV, constrF, constrR)
        LockPitch = pitch
        AutoTakeoff = false
        AltitudeHold = false
        BrakeLanding = false
    else
        LockPitch = nil
    end
end

function ToggleAltitudeHold()
    local time = system.getTime()
    if (time - ahDoubleClick) < 1.5 then
        local skip = false
        if planet.hasAtmosphere and ((atmosphere() > 0 and HoldAltitude == planet.spaceEngineMinAltitude-50))  then -- or (atmosphere() == 0 and HoldAltitude == planet.noAtmosphericDensityAltitude + 1000))
            -- We need to cancel alt hold, it's already set at what we want, this is a triple click
            skip = true
            if IntoOrbit then ToggleIntoOrbit() end
            ahDoubleClick = 0
            return
        end
        if planet.hasAtmosphere and not skip then
            if atmosphere() > 0 then
                HoldAltitude = planet.spaceEngineMinAltitude - 50
            else
                if unit.getClosestPlanetInfluence() > 0 then
                    HoldAltitude = planet.noAtmosphericDensityAltitude + 1000
                    OrbitTargetOrbit = HoldAltitude
                    OrbitTargetSet = true
                    if not IntoOrbit then ToggleIntoOrbit() end
                    orbitAligned = true
                end
            end
            ahDoubleClick = -1
            if AltitudeHold or IntoOrbit then 
                return 
            end
        end
    else
        ahDoubleClick = time
    end
    if unit.getClosestPlanetInfluence() > 0 and atmosphere() == 0 then
        OrbitTargetOrbit = coreAltitude
        OrbitTargetSet = true
        orbitAligned = true
        ToggleIntoOrbit()
        if IntoOrbit then
            ahDoubleClick = time
        else
            ahDoubleClick = 0
        end
        return -- return without adjusting whatever alt hold is at right now
    end
    AltitudeHold = not AltitudeHold
    if AltitudeHold then
        Autopilot = false
        ProgradeIsOn = false
        RetrogradeIsOn = false
        followMode = false
        BrakeLanding = false
        Reentry = false
        autoRoll = true
        LockPitch = nil
        OrbitAchieved = false
        if (hoverDetectGround() == -1) then -- Never autotakeoff in space
            AutoTakeoff = false
            if ahDoubleClick > -1 then
                if unit.getClosestPlanetInfluence() > 0 then
                    HoldAltitude = coreAltitude
                end
            end
            if not inAtmo then
                OrbitAchieved = false
                OrbitTargetSet = true
                IntoOrbit = true
                if not spaceLaunch and Nav.axisCommandManager:getAxisCommandType(0) == 0  and not AtmoSpeedAssist then
                    Nav.control.cancelCurrentControlMasterMode()
                end
            end
        else
            AutoTakeoff = true
            if ahDoubleClick > -1 then HoldAltitude = coreAltitude + AutoTakeoffAltitude end
            GearExtended = false
            Nav.control.retractLandingGears()
            BrakeIsOn = true
            Nav.axisCommandManager:setTargetGroundAltitude(TargetHoverHeight)
        end
        if spaceLaunch then HoldAltitude = 100000 end
        ahDoubleClick = time
    else
        if IntoOrbit then ToggleIntoOrbit() end
        autoRoll = autoRollPreference
        AutoTakeoff = false
        BrakeLanding = false
        Reentry = false
        AutoTakeoff = false
        VectorToTarget = false
        if IntoOrbit then ToggleIntoOrbit() end
        ahDoubleClick = 0
    end
    
end

function ToggleFollowMode()
    if isRemote() == 1 then
        followMode = not followMode
        if followMode then
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
            Nav.axisCommandManager:setTargetGroundAltitude(TargetHoverHeight)
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
        msgText = "Follow Mode only works with Remote controller"
        followMode = false
    end
end

function ToggleAutopilot()
    local time = system.getTime()
    if (time - apDoubleClick) < 1.5 and inAtmo then
        if not SpaceEngines then
            msgText = "No space engines detected, Orbital Hop not supported"
            return
        end
        if planet.hasAtmosphere then
            if atmosphere() > 0 then
                HoldAltitude = planet.noAtmosphericDensityAltitude + 1000
            end
            apDoubleClick = -1
            if Autopilot or VectorToTarget then 
                return 
            end
        end
    else
        apDoubleClick = time
    end
    TargetSet = false -- No matter what
    -- Toggle Autopilot, as long as the target isn't None
    if AutopilotTargetIndex > 0 and not Autopilot and not VectorToTarget and not spaceLaunch then
        -- If it's a custom location... 
        -- Behavior is probably 
        -- a. If not at the same nearest planet and in space and the target has gravity, autopilot to that planet
        -- a1. 
        -- b. If at nearest planet but not in atmo (and the destination is win atmo), and destination is less than (radius) away or our orbit is not stable, auto-reentry
        -- (IE if in an orbit, like from AP, it should wait until destination is on the correct side of the planet before engaging reentry)
        -- c.  If at correct planet and in atmo and alt hold isn't on and they aren't landed, engage altitude hold at that alt and speed
        -- d. If alt hold is on and we're within tolerance of our target altitude, slowly yaw toward the target position
        -- e. If our velocity vector is lined up to go over the target position, calculate our brake distance at current speed in atmo
        -- f. If our distance to the target (ignoring altitude) is within our current brakeDistance, engage brake-landing
        -- f2. Should we even try to let this happen on ships with bad brakes.  Eventually, try that.  For now just don't let them use this
        UpdateAutopilotTarget() -- Make sure we're updated
        local waypoint = zeroConvertToMapPosition(autopilotTargetPlanet, AutopilotTargetCoords)
        waypoint = "::pos{"..waypoint.systemId..","..waypoint.bodyId..","..waypoint.latitude..","..waypoint.longitude..","..waypoint.altitude.."}"
        system.setWaypoint(waypoint)
        if CustomTarget ~= nil then
            LockPitch = nil
            SpaceTarget = (CustomTarget.planetname == "Space")
            if SpaceTarget then
                if atmosphere() ~= 0 then 
                    spaceLaunch = true
                    ToggleAltitudeHold()
                else
                    Autopilot = true
                end
            elseif planet.name  == CustomTarget.planetname then
                -- StrongBrakes = ((planet.gravity * 9.80665 * constructMass()) < LastMaxBrakeInAtmo)
                StrongBrakes = true
                --if not StrongBrakes and velMag > minAutopilotSpeed then
                --    msgText = "Insufficient Brake Force\nCoast landing will be inaccurate"
                --end
                -- Going to need to add all those conditions here.  Let's start with the easiest.
                if atmosphere() > 0 then
                   -- if not AltitudeHold then
                        -- Autotakeoff gets engaged inside the toggle if conditions are met
                        -- if not VectorToTarget then
                        --     ToggleVectorToTarget(SpaceTarget)
                        -- end
                   -- else
                        -- Vector to target
                        if apDoubleClick == -1 then
                            ahDoubleClick = 0 -- Don't let alt hold take a double click from us
                        end
                        HoldAltitude = coreAltitude
                        if not VectorToTarget then
                            ToggleVectorToTarget(SpaceTarget)
                        end
                    --end -- TBH... this is the only thing we need to do, make sure Alt Hold is on.  
                else
                    if coreAltitude > 100000 or coreAltitude == 0 then
                        --spaceLaunch = true
                        OrbitAchieved = false
                        Autopilot = true
                    elseif coreAltitude <= 100000 then
                        if IntoOrbit then ToggleIntoOrbit() end -- Reset all appropriate vars
                        OrbitTargetOrbit = planet.noAtmosphericDensityAltitude + 1000
                        OrbitTargetSet = true
                        orbitalParams.AutopilotAlign = true
                        orbitalParams.VectorToTarget = true
                        orbitAligned = false
                        if not IntoOrbit then ToggleIntoOrbit() end
                        -- spaceLand = true
                        -- ProgradeIsOn = true
                    end
                end
            else
                RetrogradeIsOn = false
                ProgradeIsOn = false
                if atmosphere() ~= 0 then 
                    spaceLaunch = true
                    ToggleAltitudeHold() 
                else
                    Autopilot = true
                end
            end
        elseif atmosphere() == 0 then -- Planetary autopilot
            local nearPlanet = unit.getClosestPlanetInfluence() > 0
            if CustomTarget == nil and (autopilotTargetPlanet.name == planet.name and nearPlanet) then
                OrbitAchieved = false
                ToggleIntoOrbit() -- this works much better here
            else
                Autopilot = true
                RetrogradeIsOn = false
                ProgradeIsOn = false
                AutopilotRealigned = false
                followMode = false
                AltitudeHold = false
                BrakeLanding = false
                Reentry = false
                AutoTakeoff = false
                apThrottleSet = false
                LockPitch = nil
                WaypointSet = false
            end
        else
            spaceLaunch = true
            ToggleAltitudeHold()
        end
    else
        spaceLaunch = false
        Autopilot = false
        AutopilotRealigned = false
        VectorToTarget = false
        apThrottleSet = false
        AutoTakeoff = false
        AltitudeHold = false
        VectorToTarget = false
        HoldAltitude = coreAltitude
        TargetSet = false
        Reentry = false
        if IntoOrbit then ToggleIntoOrbit() end
    end
    apDoubleClick = time
end

function ProgradeToggle()
    -- Toggle Progrades
    ProgradeIsOn = not ProgradeIsOn
    RetrogradeIsOn = false -- Don't let both be on
    Autopilot = false
    AltitudeHold = false
    followMode = false
    BrakeLanding = false
    LockPitch = nil
    Reentry = false
    AutoTakeoff = false
end

function RetrogradeToggle()
    -- Toggle Retrogrades
    RetrogradeIsOn = not RetrogradeIsOn
    ProgradeIsOn = false -- Don't let both be on
    Autopilot = false
    AltitudeHold = false
    followMode = false
    BrakeLanding = false
    LockPitch = nil
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
        VertTakeOff = false
        Reentry = false
        -- We won't abort interplanetary because that would fuck everyone.
        ProgradeIsOn = false -- No reason to brake while facing prograde, but retrograde yes.
        BrakeLanding = false
        AutoLanding = false
        AltitudeHold = false -- And stop alt hold
        if IntoOrbit then
            ToggleIntoOrbit()
        end
        LockPitch = nil
        autoRoll = autoRollPreference
        spaceLand = false
        finalLand = false
        upAmount = 0
    end
end

function CheckDamage(newContent)
    local percentDam = 0
    damageMessage = ""
    local maxShipHP = eleTotalMaxHp
    local curShipHP = 0
    local damagedElements = 0
    local disabledElements = 0
    local colorMod = 0
    local color = ""
    for k in pairs(elementsID) do
        local hp = 0
        local mhp = 0
        mhp = eleMaxHp(elementsID[k])
        hp = eleHp(elementsID[k])
        curShipHP = curShipHP + hp
        if (hp < mhp) then
            if (hp == 0) then
                disabledElements = disabledElements + 1
            else
                damagedElements = damagedElements + 1
            end
            -- Thanks to Jerico for the help and code starter for arrow markers!
            if repairArrows and #markers == 0 then
                position = vec3(core.getElementPositionById(elementsID[k]))
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
                table.insert(markers, elementsID[k])
            end
        elseif repairArrows and #markers > 0 and markers[11] == elementsID[k] then
            for j in pairs(markers) do
                core.deleteSticker(markers[j])
            end
            markers = {}
        end
    end
    percentDam = mfloor((curShipHP / maxShipHP)*100)
    if percentDam < 100 then
        newContent[#newContent + 1] = [[<g class="pbright txt">]]
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
    local strokeColor = mfloor(utils.clamp((distance / (resolutionWidth / 4)) * 255, 0, 255))
    newContent[#newContent + 1] = stringf(
                                      "<line x1='0' y1='0' x2='%fpx' y2='%fpx' style='stroke:rgb(%d,%d,%d);stroke-width:2;transform:translate(50%%, 50%%)' />",
                                      simulatedX, simulatedY, mfloor(PrimaryR + 0.5) + strokeColor,
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

local function signedRotationAngle(normal, vecA, vecB)
   vecA = vecA:project_on_plane(normal)
   vecB = vecB:project_on_plane(normal)
  return atan(vecA:cross(vecB):dot(normal), vecA:dot(vecB))
end

function clearAll()
    if clearAllCheck then
        clearAllCheck = false
        AutopilotAccelerating = false
        AutopilotBraking = false
        AutopilotCruising = false
        Autopilot = false
        AutopilotRealigned = false
        AutopilotStatus = "Aligning"                
        RetrogradeIsOn = false
        ProgradeIsOn = false
        AltitudeHold = false
        Reentry = false
        BrakeLanding = false
        BrakeIsOn = false
        AutoTakeoff = false
        VertTakeOff = false
        followMode = false
        apThrottleSet = false
        spaceLand = false
        spaceLaunch = false
        reentryMode = false
        autoRoll = autoRollPreference
        VectorToTarget = false
        TurnBurn = false
        gyroIsOn = false
        LockPitch = nil
    else
        clearAllCheck = true
    end
end

function wipeSaveVariables()
    if not dbHud_1 then
        msgText =
            "No Databank Found, unable to wipe. \nYou must have a Databank attached to ship prior to running the HUD autoconfigure"
        msgTimer = 5
    else--if valuesAreSet then
        if doubleCheck then
            -- If any values are set, wipe them all
            for k, v in pairs(saveableVariables) do
                dbHud_1.setStringValue(v, jencode(nil))
            end
            for k, v in pairs(autoVariables) do
                if v ~= "SavedLocations" then dbHud_1.setStringValue(v, jencode(nil)) end
            end
            --dbHud_1.clear()
            msgText =
                "Databank wiped. New variables will save after re-enter seat and exit"
            msgTimer = 5
            doubleCheck = false
            valuesAreSet = false
            wipedDatabank = true
        else
            msgText = "Press ALT-7 again to confirm wipe of ALL data"
            doubleCheck = true
        end
    end
end

function CheckButtons()
    for _, v in pairs(Buttons) do
        if v.hovered then
            if not v.drawCondition or v.drawCondition() then
                v.toggleFunction()
            end
            v.hovered = false
        end
    end
end

function SetButtonContains()
    local x = simulatedX + resolutionWidth / 2
    local y = simulatedY + resolutionHeight / 2
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
    if isRemote() == 1 and not RemoteHud then
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
                if tankTable[i][tankName] == jdecode(unit[slottedTankType .. "_" .. j].getData()).name then
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
                    fuelPercentTable[i] = jdecode(unit[slottedTankType .. "_" .. slottedIndex].getData())
                                              .percentage
                    fuelTimeLeftTable[i] = jdecode(unit[slottedTankType .. "_" .. slottedIndex].getData())
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

function AlignToWorldVector(vector, tolerance, damping)
    -- Sets inputs to attempt to point at the autopilot target
    -- Meant to be called from Update or Tick repeatedly
    if not inAtmo or not stalling or hovGndDet ~= -1 or velMag < minAutopilotSpeed then
        local dampingMult = damping
        if dampingMult == nil then
            dampingMult = DampingMultiplier
        end

        if tolerance == nil then
            tolerance = alignmentTolerance
        end
        vector = vec3(vector):normalize()
        local targetVec = (vec3(core.getConstructWorldOrientationForward()) - vector)
        local yawAmount = -getMagnitudeInDirection(targetVec, core.getConstructWorldOrientationRight()) * autopilotStrength
        local pitchAmount = -getMagnitudeInDirection(targetVec, core.getConstructWorldOrientationUp()) * autopilotStrength
        if previousYawAmount == 0 then previousYawAmount = yawAmount / 2 end
        if previousPitchAmount == 0 then previousPitchAmount = pitchAmount / 2 end
        -- Skip dampening at very low values, and force it to effectively overshoot so it can more accurately align back
        -- Instead of taking literal forever to converge
        if math.abs(yawAmount) < 0.1 then
            yawInput2 = yawInput2 - yawAmount*2
        else
            yawInput2 = yawInput2 - (yawAmount + (yawAmount - previousYawAmount) * dampingMult)
        end
        if math.abs(pitchAmount) < 0.1 then
            pitchInput2 = pitchInput2 + pitchAmount*2
        else
            pitchInput2 = pitchInput2 + (pitchAmount + (pitchAmount - previousPitchAmount) * dampingMult)
        end


        previousYawAmount = yawAmount
        previousPitchAmount = pitchAmount
        -- Return true or false depending on whether or not we're aligned
        if math.abs(yawAmount) < tolerance and math.abs(pitchAmount) < tolerance then
        --if vec3(core.getConstructWorldOrientationForward()):dot(targetVec:normalize()) > (1-tolerance) then -- Probably better, but untested
            return true
        end
        return false
    elseif stalling and hovGndDet == -1 then
        -- If stalling, align to velocity to fix the stall
        -- IDK I'm just copy pasting all this
        vector = vec3(core.getWorldVelocity())
        local dampingMult = damping
        if dampingMult == nil then
            dampingMult = DampingMultiplier
        end

        if tolerance == nil then
            tolerance = alignmentTolerance
        end
        vector = vec3(vector):normalize()
        local targetVec = (vec3(core.getConstructWorldOrientationForward()) - vector)
        local yawAmount = -getMagnitudeInDirection(targetVec, core.getConstructWorldOrientationRight()) * autopilotStrength
        local pitchAmount = -getMagnitudeInDirection(targetVec, core.getConstructWorldOrientationUp()) * autopilotStrength
        if previousYawAmount == 0 then previousYawAmount = yawAmount / 2 end
        if previousPitchAmount == 0 then previousPitchAmount = pitchAmount / 2 end
        -- Skip dampening at very low values, and force it to effectively overshoot so it can more accurately align back
        -- Instead of taking literal forever to converge
        if math.abs(yawAmount) < 0.1 then
            yawInput2 = yawInput2 - yawAmount*5
        else
            yawInput2 = yawInput2 - (yawAmount + (yawAmount - previousYawAmount) * dampingMult)
        end
        if math.abs(pitchAmount) < 0.1 then
            pitchInput2 = pitchInput2 + pitchAmount*5
        else
            pitchInput2 = pitchInput2 + (pitchAmount + (pitchAmount - previousPitchAmount) * dampingMult)
        end
        previousYawAmount = yawAmount
        previousPitchAmount = pitchAmount
        -- Return true or false depending on whether or not we're aligned
        if math.abs(yawAmount) < tolerance and math.abs(pitchAmount) < tolerance then
            return true
        end
        return false
    end
end

function getAPEnableName()
    local name = AutopilotTargetName
    if name == nil then
        local displayText, displayUnit = getDistanceDisplayString((vec3(core.getConstructWorldPos()) - CustomTarget.position):len())
        name = CustomTarget.name .. " " .. displayText .. displayUnit
                   
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
    if antigrav and not ExternalAGG then
        if antigrav.getState() == 1 then
            antigrav.deactivate()
            antigrav.hide()
        else
            if AntigravTargetAltitude == nil then AntigravTargetAltitude = coreAltitude end
            if AntigravTargetAltitude < 1000 then
                AntigravTargetAltitude = 1000
            end
            antigrav.activate()
            antigrav.show()
        end
    end
end

function BeginReentry()
    if Reentry then
        msgText = "Re-Entry cancelled"
        Reentry = false
        autoRoll = autoRollPreference
        AltitudeHold = false
    elseif not planet.hasAtmosphere then
        msgText = "Re-Entry requirements not met: you must start out of atmosphere\n and within a planets gravity well over a planet with atmosphere"
        msgTimer = 5
    elseif not reentryMode then-- Parachute ReEntry
        StrongBrakes = ((planet.gravity * 9.80665 * constructMass()) < LastMaxBrakeInAtmo)
        if not StrongBrakes  then
            msgText = "WARNING: Insufficient Brakes for Parachute Re-Entry"
        else
            Reentry = true
            if Nav.axisCommandManager:getAxisCommandType(0) ~= controlMasterModeId.cruise then
                Nav.control.cancelCurrentControlMasterMode()
            end                
            autoRoll = true
            BrakeIsOn = false
            msgText = "Beginning Parachute Re-Entry - Strap In.  Target speed: " .. ReentrySpeed
        end
    else --Glide Reentry
        Reentry = true
        AltitudeHold = true
        autoRoll = true
        BrakeIsOn = false
        HoldAltitude = planet.spaceEngineMinAltitude - 50
        local text, altUnit = getDistanceDisplayString(HoldAltitude)
        msgText = "Beginning Re-entry.  Target speed: " .. adjustedAtmoSpeedLimit .. " Target Altitude: " .. text .. altUnit
        cmdCruise(math.floor(adjustedAtmoSpeedLimit))
    end
    AutoTakeoff = false -- This got left on somewhere.. 
end

function SetupButtons()
    -- BEGIN BUTTON DEFINITIONS

    -- enableName, disableName, width, height, x, y, toggleVar, toggleFunction, drawCondition
    local buttonHeight = 50
    local buttonWidth = 260 -- Defaults
    local brake = MakeButton("Enable Brake Toggle", "Disable Brake Toggle", buttonWidth, buttonHeight,
                        resolutionWidth / 2 - buttonWidth / 2, resolutionHeight / 2 + 350, function()
            return BrakeToggleStatus
        end, function()
            BrakeToggleStatus = not BrakeToggleStatus
            if (BrakeToggleStatus) then
                msgText = "Brakes in Toggle Mode"
            else
                msgText = "Brakes in Default Mode"
            end
        end)
    MakeButton("Align Prograde", "Disable Prograde", buttonWidth, buttonHeight,
        resolutionWidth / 2 - buttonWidth / 2 - 50 - brake.width, resolutionHeight / 2 - buttonHeight + 380,
        function()
            return ProgradeIsOn
        end, ProgradeToggle)
    MakeButton("Align Retrograde", "Disable Retrograde", buttonWidth, buttonHeight,
        resolutionWidth / 2 - buttonWidth / 2 + brake.width + 50, resolutionHeight / 2 - buttonHeight + 380,
        function()
            return RetrogradeIsOn
        end, RetrogradeToggle, function()
            return atmosphere() == 0
        end) -- Hope this works
    local apbutton = MakeButton(getAPEnableName, getAPDisableName, 600, 60, resolutionWidth / 2 - 600 / 2,
                            resolutionHeight / 2 - 60 / 2 - 400, function()
            return Autopilot
        end, ToggleAutopilot)
    MakeButton("Save Position", "Save Position", 200, apbutton.height, apbutton.x + apbutton.width + 30, apbutton.y,
        function()
            return false
        end, AddNewLocation, function()
            return AutopilotTargetIndex == 0 or CustomTarget == nil
        end)
    MakeButton("Update Position", "Update Position", 200, apbutton.height, apbutton.x + apbutton.width + 30, apbutton.y,
        function()
            return false
        end, UpdatePosition, function()
            return AutopilotTargetIndex > 0 and CustomTarget ~= nil
        end)
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
    local y = resolutionHeight / 2 - 300
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
    local engageMsg, dengageMsg, tOSwitch
    if VertTakeOffEngine then
        engageMsg = "Engage Vertical Takeoff"
        dengageMsg = "Disable Vertical Takeoff"
        tOSwitch = VertTakeOff
    else
        engageMsg = "Engage Auto Takeoff"
        dengageMsg = "Disable Auto Takeoff"
        tOSwitch = AutoTakeoff
    end
    MakeButton(engageMsg, dengageMsg, buttonWidth, buttonHeight, x + buttonWidth + 20, y,
        function()
            return tOSwitch
        end, ToggleAutoTakeoff)
    y = y + buttonHeight + 20
    MakeButton("Show Orbit Display", "Hide Orbit Display", buttonWidth, buttonHeight, x, y,
        function()
            return DisplayOrbit
        end, function()
            DisplayOrbit = not DisplayOrbit
            if (DisplayOrbit) then
                msgText = "Orbit Display Enabled"
            else
                msgText = "Orbit Display Disabled"
            end
        end)
     -- prevent this button from being an option until you're in atmosphere
    MakeButton("Engage Orbiting", "Cancel Orbiting", buttonWidth, buttonHeight, x + buttonWidth + 20, y,
            function()
                return IntoOrbit
            end, ToggleIntoOrbit, function()
                return (atmosphere() == 0 and unit.getClosestPlanetInfluence() > 0)
            end)
    y = y + buttonHeight + 20
    MakeButton("Glide Re-Entry", "Cancel Glide Re-Entry", buttonWidth, buttonHeight, x, y,
        function() return Reentry end, function() spaceLand = true ProgradeToggle() end, function() return (coreAltitude > ReentryAltitude) end )
    MakeButton("Parachute Re-Entry", "Cancel Parachute Re-Entry", buttonWidth, buttonHeight, x + buttonWidth + 20, y,
        function() return Reentry end, BeginReentry, function() return (coreAltitude > ReentryAltitude) end )
    y = y + buttonHeight + 20
    MakeButton("Engage Follow Mode", "Disable Follow Mode", buttonWidth, buttonHeight, x, y, function()
        return followMode
    end, ToggleFollowMode, function()
        return isRemote() == 1
    end)
    MakeButton("Enable Repair Arrows", "Disable Repair Arrows", buttonWidth, buttonHeight, x + buttonWidth + 20, y, function()
        return repairArrows
    end, function()
        repairArrows = not repairArrows
        if (repairArrows) then
            msgText = "Repair Arrows Enabled"
        else
            msgText = "Repair Arrows Diabled"
        end
    end, function()
        return isRemote() == 1
    end)
    y = y + buttonHeight + 20
    if not ExternalAGG then
        MakeButton("Enable AGG", "Disable AGG", buttonWidth, buttonHeight, x, y, function()
        return antigrav.getState() == 1 end, ToggleAntigrav, function()
        return antigrav ~= nil end)
    end   
    y = y + buttonHeight + 20
    MakeButton(function()
        return stringf("Toggle Control Scheme - Current: %s", userControlScheme)
    end, function()
        return stringf("Control Scheme: %s", userControlScheme)
    end, buttonWidth * 2, buttonHeight, x, y, function()
        return false
    end, function()
        if userControlScheme == "keyboard" then
            userControlScheme = "mouse"
        elseif userControlScheme == "mouse" then
            userControlScheme = "virtual joystick"
        else
            userControlScheme = "keyboard"
        end
    end)
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

function UpdateHud(newContent)

    local altitude = coreAltitude
    local velocity = core.getVelocity()
    local speed = vec3(velocity):len()
    local worldV = vec3(core.getWorldVertical())
    local constrF = vec3(core.getConstructWorldOrientationForward())
    local constrR = vec3(core.getConstructWorldOrientationRight())
    local constrU = vec3(core.getConstructWorldOrientationUp())
    local roll = getRoll(worldV, constrF, constrR) 
    local radianRoll = (roll / 180) * math.pi
    local corrX = math.cos(radianRoll)
    local corrY = math.sin(radianRoll)
    local pitch = getPitch(worldV, constrF, (constrR * corrX) + (constrU * corrY)) -- 180 - getRoll(worldV, constrR, constrF)            
    local originalRoll = roll
    local originalPitch = pitch
    local atmos = atmosphere()
    local throt = mfloor(unit.getThrottle())
    local spd = speed * 3.6
    local flightValue = unit.getAxisCommandValue(0)
    local pvpBoundaryX = ConvertResolutionX(1770)
    local pvpBoundaryY = ConvertResolutionY(310)

    if AtmoSpeedAssist and Nav.axisCommandManager:getAxisCommandType(0) == axisCommandType.byThrottle then
        flightValue = PlayerThrottle
        throt = PlayerThrottle*100
    end

    local flightStyle = GetFlightStyle()
    local bottomText = "ROLL"
    local nearPlanet = unit.getClosestPlanetInfluence() > 0
    if throt == nil then throt = 0 end

    if (not nearPlanet) then
        if (speed > 5) then
            pitch = getRelativePitch(velocity)
            roll = getRelativeYaw(velocity)
        else
            pitch = 0
            roll = 0
        end
        bottomText = "YAW"
    end

    if pvpDist > 50000 and not inAtmo then
        local dist
        if pvpDist > 200000 then
            dist = round((pvpDist/200000),2).." su"
        else
            dist = round((pvpDist/1000),1).." km"
        end
        newContent[#newContent + 1] = stringf([[<text class="pbright txtbig txtmid" x="%d" y="%d">PvP Boundary: %s</text>]], pvpBoundaryX, pvpBoundaryY, dist)
    end

    -- CRUISE/ODOMETER

    newContent[#newContent + 1] = lastOdometerOutput

    -- DAMAGE

    newContent[#newContent + 1] = damageMessage

    -- RADAR

    newContent[#newContent + 1] = radarMessage

    -- FUEL TANKS

    if (updateCount % fuelUpdateDelay == 0) then
        updateTanks = true
    end
    if (fuelX ~= 0 and fuelY ~= 0) then
        DrawTank(newContent, updateTanks, fuelX, "Atmospheric ", "ATMO", atmoTanks, fuelTimeLeft, fuelPercent)
        DrawTank(newContent, updateTanks, fuelX+100, "Space fuel t", "SPACE", spaceTanks, fuelTimeLeftS, fuelPercentS)
        DrawTank(newContent, updateTanks, fuelX+200, "Rocket fuel ", "ROCKET", rocketTanks, fuelTimeLeftR, fuelPercentR)
    end

    if updateTanks then
        updateTanks = false
        updateCount = 0
    end
    updateCount = updateCount + 1

    -- PRIMARY FLIGHT INSTRUMENTS

    DrawVerticalSpeed(newContent, altitude) -- Weird this is draw during remote control...?


    if isRemote() == 0 or RemoteHud then
        -- Don't even draw this in freelook
       if not IsInFreeLook() or brightHud then
            if nearPlanet then -- use real pitch, roll, and heading
                DrawRollLines (newContent, centerX, centerY, originalRoll, bottomText, nearPlanet)
                DrawArtificialHorizon(newContent, originalPitch, originalRoll, centerX, centerY, nearPlanet, mfloor(getRelativeYaw(velocity)), speed)
            else -- use Relative Pitch and Relative Yaw
                DrawRollLines (newContent, centerX, centerY, roll, bottomText, nearPlanet)
                DrawArtificialHorizon(newContent, pitch, roll, centerX, centerY, nearPlanet, mfloor(roll), speed)
            end
            DrawAltitudeDisplay(newContent, altitude, nearPlanet)
            DrawPrograde(newContent, velocity, speed, centerX, centerY)
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
    return system.isViewLocked() == 0 and userControlScheme ~= "keyboard" and isRemote() == 0
end

function HUDPrologue(newContent)
    if not pvpZone then -- misnamed variable, fix later
        PrimaryR = PvPR
        PrimaryG = PvPG
        PrimaryB = PvPB
    else
        PrimaryR = SafeR
        PrimaryG = SafeG
        PrimaryB = SafeB
    end
    rgb = [[rgb(]] .. mfloor(PrimaryR + 0.5) .. "," .. mfloor(PrimaryG + 0.5) .. "," .. mfloor(PrimaryB + 0.5) .. [[)]]
    rgbdim = [[rgb(]] .. mfloor(PrimaryR * 0.9 + 0.5) .. "," .. mfloor(PrimaryG * 0.9 + 0.5) .. "," ..   mfloor(PrimaryB * 0.9 + 0.5) .. [[)]]    
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
            </style>
        </head>
        <body>
            <svg height="100%%" width="100%%" viewBox="0 0 %d %d">
            ]], bright, bright, brightOrig, brightOrig, dim, dim, dimOrig, dimOrig, ResolutionX, ResolutionY)
end

function HUDEpilogue(newContent)
    newContent[#newContent + 1] = "</svg>"
end

function DrawSpeed(newContent, spd)
    local ys = throtPosY-10 
    local x1 = throtPosX + 10
    newContent[#newContent + 1] = [[<g class="pdim txt txtend">]]
    if isRemote() == 1 and not RemoteHud then
        ys = 75
    end
    newContent[#newContent + 1] = stringf([[
        <g class="pbright txtstart">
            <text class="txtbig" x="%d" y="%d">%d km/h</text>
        </g>
    </g>]], x1, ys, mfloor(spd))
end

function DrawOdometer(newContent, totalDistanceTrip, TotalDistanceTravelled, flightStyle, flightTime, atmos)
    local xg = ConvertResolutionX(1240)
    local yg1 = ConvertResolutionY(55)
    local yg2 = yg1+10
    local atmos = atmosphere()
    local gravity = core.g()
    local maxMass = 0
    local reqThrust = 0
    local brakeValue = 0
    RefreshLastMaxBrake(gravity)
    if inAtmo then brakeValue = LastMaxBrakeInAtmo else brakeValue = LastMaxBrake end
    maxThrust = Nav:maxForceForward()
    totalMass = constructMass()
    if not ShowOdometer then return end
    local accel = (vec3(core.getWorldAcceleration()):len() / 9.80665)
    if gravity > 0.1 then
        reqThrust = totalMass * gravity
        maxMass = maxThrust / gravity
    end
    newContent[#newContent + 1] = [[<g class="pdim txt txtend">]]
    if isRemote() == 1 and not RemoteHud then
        xg = ConvertResolutionX(1120)
        yg1 = ConvertResolutionY(55)
        yg2 = yg1+10
    elseif inAtmo then -- We only show atmo when not remote
        local atX = ConvertResolutionX(770)
        newContent[#newContent + 1] = stringf([[
            <text x="%d" y="%d">ATMOSPHERE</text>
            <text x="%d" y="%d">%.2f</text>
        ]], atX, yg1, atX, yg2, atmos)
    end
    newContent[#newContent + 1] = stringf([[
        <g class="pbright txtend">
        </g>
        <text x="%d" y="%d">GRAVITY</text>
        <text x="%d" y="%d">%.2f g</text>
        <text x="%d" y="%d">ACCEL</text>
        <text x="%d" y="%d">%.2f g</text>
        ]], xg, yg1, xg, yg2, (gravity / 9.80665), xg, yg1 + 20, xg, yg2 + 20, accel)
    newContent[#newContent + 1] = stringf([[
        <g class="pbright txt">
        <path class="linethick" d="M %d 0 L %d %d Q %d %d %d %d L %d 0"/>]],
        ConvertResolutionX(660), ConvertResolutionX(700), ConvertResolutionY(35), ConvertResolutionX(960), ConvertResolutionY(55),
        ConvertResolutionX(1240), ConvertResolutionY(35), ConvertResolutionX(1280))
    if isRemote() == 0 or RemoteHud then
        newContent[#newContent + 1] = stringf([[
            <text class="txtstart" x="%d" y="%d" >Trip: %.2f km</text>
            <text class="txtstart" x="%d" y="%d">Lifetime: %.2f Mm</text>
            <text class="txtstart" x="%d" y="%d">Trip Time: %s</text>
            <text class="txtstart" x="%d" y="%d">Total Time: %s</text>
            <text class="txtstart" x="%d" y="%d">Mass: %.2f Tons</text>
            <text class="txtend" x="%d" y="%d">Max Brake: %.2f kN</text>
            <text class="txtend" x="%d" y="%d">Max Thrust: %.2f kN</text>
            <text class="txtbig txtmid" x="%d" y="%d">%s</text>]],
            ConvertResolutionX(700), ConvertResolutionY(20), totalDistanceTrip, ConvertResolutionX(700), ConvertResolutionY(30), (TotalDistanceTravelled / 1000),
            ConvertResolutionX(830), ConvertResolutionY(20), FormatTimeString(flightTime), ConvertResolutionX(830), ConvertResolutionY(30), FormatTimeString(TotalFlightTime),
            ConvertResolutionX(970), ConvertResolutionY(20), (totalMass / 1000), ConvertResolutionX(1240), ConvertResolutionY(10), (brakeValue / 1000),
            ConvertResolutionX(1240), ConvertResolutionY(30), (maxThrust / 1000), ConvertResolutionX(960), ConvertResolutionY(180), flightStyle)
        if gravity > 0.1 then
            newContent[#newContent + 1] = stringf([[
                    <text class="txtstart" x="%d" y="%d">Max Mass: %.2f Tons</text>
                    <text class="txtend" x="%d" y="%d">Req Thrust: %.2f kN</text>
            ]], ConvertResolutionX(970), ConvertResolutionY(30), (maxMass / 1000), ConvertResolutionX(1240), ConvertResolutionY(20), (reqThrust / 1000))
        else
            newContent[#newContent + 1] = stringf([[
                <text class="txtstart" x="%d" y="%d" text-anchor="start">Max Mass: n/a</text>
                <text class="txtend" x="%d" y="%d" text-anchor="end">Req Thrust: n/a</text>
            ]], ConvertResolutionX(970), ConvertResolutionY(30), ConvertResolutionX(1240), ConvertResolutionY(20))
        end
    else -- If remote controlled, draw stuff near the top so it's out of the way
        newContent[#newContent + 1] = stringf([[<text class="txtbig txtmid" x="960" y="33">%s</text>]],
                                        ConvertResolutionX(960), ConvertResolutionY(33), flightStyle)
    end
    newContent[#newContent + 1] = "</g>"
end

function DrawThrottle(newContent, flightStyle, throt, flightValue)
    throt = math.floor(throt+0.5) -- Hard-round it to an int
    local y1 = throtPosY+10
    local y2 = throtPosY+20
    if isRemote() == 1 and not RemoteHud then
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
            <g transform="translate(0 %.0f)">
                <polygon points="%d,%d %d,%d %d,%d"/>
            </g>]], throtclass, throtPosX-7, throtPosY-50, throtPosX, throtPosY-50, throtPosX, throtPosY+50, throtPosX-7, throtPosY+50, (1 - math.abs(throt)), 
            throtPosX-10, throtPosY+50, throtPosX-15, throtPosY+53, throtPosX-15, throtPosY+47)
    end
    newContent[#newContent + 1] = stringf([[
        <g class="pbright txtstart">
                <text x="%s" y="%s">%s</text>
                <text x="%s" y="%s">%.0f %s</text>
        </g>
    </g>]], throtPosX+10, y1, label, throtPosX+10, y2, value, unit)

    if inAtmo and AtmoSpeedAssist and Nav.axisCommandManager:getAxisCommandType(0) == axisCommandType.byThrottle and ThrottleLimited then
        -- Display a marker for where the AP throttle is putting it, calculatedThrottle

        throt = math.floor(calculatedThrottle*100+0.5)
        local throtclass = "red"
        if throt < 0 then
            throtclass = "red" -- TODO
        end
        newContent[#newContent + 1] = stringf([[<g class="%s">
            <g transform="translate(0 %d)">
                <polygon points="%d,%d %d,%d %d,%d"/>
            </g></g>]], throtclass, (1 - math.abs(throt)), 
            throtPosX-10, throtPosY+50, throtPosX-15, throtPosY+53, throtPosX-15, throtPosY+47)
        newContent[#newContent + 1] = stringf([[
                <g class="pbright txtstart">
                        <text x="%s" y="%s">%s</text>
                        <text x="%s" y="%s">%d %s</text>
                </g>]], throtPosX+10, y1+40, "LIMIT", throtPosX+10, y2+40, throt, "%")
    end
    if (inAtmo and AtmoSpeedAssist) or Reentry then
        -- Display AtmoSpeedLimit above the throttle

        newContent[#newContent + 1] = stringf([[
            <g class="dim txtstart">
                <text x="%s" y="%s">%s %s</text>
            </g>
        ]], throtPosX+10, y1-40, "LIMIT: ", adjustedAtmoSpeedLimit .. " km/h")
    elseif not inAtmo and Autopilot then
        -- Display MaxGameVelocity above the throttle
        newContent[#newContent + 1] = stringf([[
            <g class="dim txtstart">
                <text x="%s" y="%s">%s %s</text>
            </g>
        ]], throtPosX+10, y1-40, "LIMIT: ", math.floor(MaxGameVelocity*3.6+0.5) .. " km/h")
    end
end

 
function DrawVerticalSpeed(newContent, altitude) -- Draw vertical speed indicator - Code by lisa-lionheart
    if (altitude < 200000 and not inAtmo) or (altitude and inAtmo) then
        local vSpd = -vec3(core.getWorldVertical()):dot(vec3(core.getWorldVelocity()))
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

function getHeading(forward) -- code provided by tomisunlucky   
    local up = -vec3(core.getWorldVertical())
    forward = forward - forward:project_on(up)
    local north = vec3(0, 0, 1)
    north = north - north:project_on(up)
    local east = north:cross(up)
    local angle = north:angle_between(forward) * constants.rad2deg
    if forward:dot(east) < 0 then
        angle = 360-angle
    end
    return angle
end

function DrawRollLines (newContent, centerX, centerY, originalRoll, bottomText, nearPlanet)
    local horizonRadius = circleRad -- Aliased global
    local OFFSET = 20
    OFFSET = mfloor(OFFSET )
    local rollC = mfloor(originalRoll)
    if nearPlanet then 
        for i = -45, 45, 5 do
            local rot = i
            newContent[#newContent + 1] = stringf([[<g transform="rotate(%f,%d,%d)">]], rot, centerX, centerY)
            len = 5
            if (i % 15 == 0) then
                len = 15
            elseif (i % 10 == 0) then
                len = 10
            end
            newContent[#newContent + 1] = stringf([[<line x1=%d y1=%d x2=%d y2="%d"/></g>]], centerX, centerY + horizonRadius + OFFSET - len, centerX, centerY + horizonRadius + OFFSET)
        end 
        newContent[#newContent + 1] = stringf([["
            <g class="pdim txt txtmid">
                <text x="%d" y="%d">%s</text>
                <text x="%d" y="%d">%d deg</text>
            </g>
            ]], centerX, centerY+horizonRadius+OFFSET-35, bottomText, centerX, centerY+horizonRadius+OFFSET-25, rollC)
        newContent[#newContent + 1] = stringf([[<g transform="rotate(%f,%d,%d)">]], -originalRoll, centerX, centerY)
        newContent[#newContent + 1] = stringf([[<<polygon points="%d,%d %d,%d %d,%d"/>]],
            centerX-5, centerY+horizonRadius+OFFSET-20, centerX+5, centerY+horizonRadius+OFFSET-20, centerX, centerY+horizonRadius+OFFSET-15)
        newContent[#newContent +1] = "</g>"
    end
    local yaw = rollC
    if nearPlanet then yaw = getHeading(vec3(core.getConstructWorldOrientationForward())) end
    local range = 20
    local yawC = mfloor(yaw) 
    local yawlen = 0
    local yawy = (centerY + horizonRadius + OFFSET + 20)
    local yawx = centerX
    if bottomText ~= "YAW" then 
        yawy = ConvertResolutionY(130)
        yawx = ConvertResolutionX(960)
    end
    local tickerPath = [[<path class="txttick line" d="]]
    for i = mfloor(yawC - (range+10) - yawC % 5 + 0.5), mfloor(yawC + (range+10) + yawC % 5 + 0.5), 5 do
        local x = yawx + (-i * 5 + yaw * 5)
        if (i % 10 == 0) then
            yawlen = 10
            local num = i
            if num == 360 then 
                num = 0
            elseif num  > 360 then  
                num = num - 360 
            elseif num < 0 then
                num = num + 360
            end
            newContent[#newContent + 1] = stringf([[
                    <text x="%f" y="%f">%d</text>]],x+5,yawy-12, num)
        elseif (i % 5 == 0) then
            yawlen = 5
        end
        if yawlen == 10 then
            tickerPath = stringf([[%s M %f %f v %d]], tickerPath, x, yawy-5, yawlen)
        else
            tickerPath = stringf([[%s M %f %f v %d]], tickerPath, x, yawy-2.5, yawlen)
        end
    end
    newContent[#newContent + 1] = tickerPath .. [["/>]]
    newContent[#newContent + 1] = stringf([[<<polygon points="%d,%d %d,%d %d,%d"/>]],
        yawx-5, yawy+10, yawx+5, yawy+10, yawx, yawy+5)
    if nearPlanet then bottomText = "HDG" end
    newContent[#newContent + 1] = stringf([["
        <g class="pdim txt txtmid">
        <text x="%d" y="%d">%d deg</text>
        <text x="%d" y="%d">%s</text>
        </g>
        ]], yawx, yawy+25, yawC, yawx, yawy+35, bottomText)
end

function DrawArtificialHorizon(newContent, originalPitch, originalRoll, centerX, centerY, nearPlanet, atmoYaw, speed)
    -- ** CIRCLE ALTIMETER  - Base Code from Discord @Rainsome = Youtube CaptainKilmar** 
    local horizonRadius = circleRad -- Aliased global
    local pitchX = mfloor(horizonRadius * 3 / 5)
    if horizonRadius > 0 then
        local pitchC = mfloor(originalPitch)
        local len = 0
        local tickerPath = stringf([[<path transform="rotate(%f,%d,%d)" class="dim line" d="]], (-1 * originalRoll), centerX, centerY)
        if not inAtmo then
            tickerPath = stringf([[<path transform="rotate(0,%d,%d)" class="dim line" d="]], centerX, centerY)
        end
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
                tickerPath = stringf([[%s M %d %f h %d]], tickerPath, centerX-pitchX-len, y, len)
                if inAtmo then
                    newContent[#newContent + 1] = stringf([[<g path transform="rotate(%f,%d,%d)" class="pdim txt txtmid"><text x="%d" y="%f">%d</text></g>]],(-1 * originalRoll), centerX, centerY, centerX-pitchX+10, y, i)
                    newContent[#newContent + 1] = stringf([[<g path transform="rotate(%f,%d,%d)" class="pdim txt txtmid"><text x="%d" y="%f">%d</text></g>]],(-1 * originalRoll), centerX, centerY, centerX+pitchX-10, y, i)
                    if i == 0 or i == 180 or i == -180 then 
                        newContent[#newContent + 1] = stringf([[<path transform="rotate(%f,%d,%d)" d="m %d,%f %d,0" stroke-width="1" style="fill:none;stroke:#F5B800;" />]],
                            (-1 * originalRoll), centerX, centerY, centerX-pitchX+20, y, pitchX*2-40)
                    end
                else
                    newContent[#newContent + 1] = stringf([[<g class="pdim txt txtmid"><text x="%d" y="%f">%d</text></g>]], centerX-pitchX+10, y, i)
                    newContent[#newContent + 1] = stringf([[<g class="pdim txt txtmid"><text x="%d" y="%f">%d</text></g>]], centerX+pitchX-10, y, i)
                end                            
                tickerPath = stringf([[%s M %d %f h %d]], tickerPath, centerX+pitchX, y, len)
            else
                tickerPath = stringf([[%s M %d %f h %d]], tickerPath, centerX-pitchX-len, y, len)
                tickerPath = stringf([[%s M %d %f h %d]], tickerPath, centerX+pitchX, y, len)
            end
        end
        newContent[#newContent + 1] = tickerPath .. [["/>]]
        local pitchstring = "PITCH"                
        if not nearPlanet then 
            pitchstring = "REL PITCH"
        end
        if originalPitch > 90 and not inAtmo then
            originalPitch = 90 - (originalPitch - 90)
        elseif originalPitch < -90 and not inAtmo then
            originalPitch = -90 - (originalPitch + 90)
        end
        if horizonRadius > 200 then
            if inAtmo then
                if speed > minAutopilotSpeed then
                    newContent[#newContent + 1] = stringf([["
                    <g class="pdim txt txtmid">
                    <text x="%d" y="%d">%s</text>
                    <text x="%d" y="%d">%d deg</text>
                    </g>
                    ]],  centerX, centerY-15, "Yaw", centerX, centerY+20, atmoYaw)                            
                end
                newContent[#newContent + 1] = stringf([[<g transform="rotate(%f,%d,%d)">]], -originalRoll, centerX, centerY)
            else
                newContent[#newContent + 1] = stringf([[<g transform="rotate(0,%d,%d)">]], centerX, centerY)
            end
            newContent[#newContent + 1] = stringf([[<<polygon points="%d,%d %d,%d %d,%d"/> class="pdim txtend"><text x="%d" y="%f">%d</text>]],
            centerX-pitchX+25, centerY-5, centerX-pitchX+20, centerY, centerX-pitchX+25, centerY+5, centerX-pitchX+50, centerY+4, pitchC)
            newContent[#newContent + 1] = stringf([[<<polygon points="%d,%d %d,%d %d,%d"/> class="pdim txtend"><text x="%d" y="%f">%d</text>]],
            centerX+pitchX-25, centerY-5, centerX+pitchX-20, centerY, centerX+pitchX-25, centerY+5, centerX+pitchX-30, centerY+4, pitchC)
            newContent[#newContent +1] = "</g>"
        end
        local thirdHorizontal = mfloor(horizonRadius/3)
        newContent[#newContent + 1] = stringf([[<path d="m %d,%d %d,0" stroke-width="2" style="fill:none;stroke:#F5B800;" />]],
            centerX-thirdHorizontal, centerY, horizonRadius-thirdHorizontal)
        if not inAtmo and nearPlanet then 
            newContent[#newContent + 1] = stringf([[<path transform="rotate(%f,%d,%d)" d="m %d,%f %d,0" stroke-width="1" style="fill:none;stroke:#F5B800;" />]],
                (-1 * originalRoll), centerX, centerY, centerX-pitchX+10, centerY, pitchX*2-20)
        end
        newContent[#newContent + 1] = "</g>"
        if horizonRadius < 200 then
            if inAtmo and speed > minAutopilotSpeed then 
                newContent[#newContent + 1] = stringf([["
                <g class="pdim txt txtmid">
                <text x="%d" y="%d">%s</text>
                <text x="%d" y="%d">%d deg</text>
                <text x="%d" y="%d">%s</text>
                <text x="%d" y="%d">%d deg</text>
                </g>
                ]], centerX, centerY-horizonRadius, pitchstring, centerX, centerY-horizonRadius+10, pitchC, centerX, centerY-15, "Yaw", centerX, centerY+20, atmoYaw)
            else
                newContent[#newContent + 1] = stringf([["
                <g class="pdim txt txtmid">
                <text x="%d" y="%d">%s</text>
                <text x="%d" y="%d">%d deg</text>
                </g>
                ]], centerX, centerY-horizonRadius, pitchstring, centerX, centerY-horizonRadius+15, pitchC )                       
            end
        end
    end
end

function DrawAltitudeDisplay(newContent, altitude, nearPlanet)
    local rectX = altMeterX
    local rectY = altMeterY
    local rectW = 78
    local rectH = 19

    local gndHeight = AboveGroundLevel()

    if gndHeight ~= -1 then
        table.insert(newContent, stringf([[
        <g class="pdim altsm txtend">
        <text x="%d" y="%d">AGL: %.1fm</text>
        </g>
        ]], rectX+rectW, rectY+rectH+20, gndHeight))
    end

    if nearPlanet and ((altitude < 200000 and not inAtmo) or (altitude and inAtmo)) then
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

function DrawPrograde (newContent, velocity, speed, centerX, centerY)
    if (speed > 5 and not inAtmo) or (speed > minAutopilotSpeed) then
        local horizonRadius = circleRad -- Aliased global
        local pitchRange = 20
        local yawRange = 20
        local velo = vec3(velocity)
        local relativePitch = getRelativePitch(velo)
        local relativeYaw = getRelativeYaw(velo)

        local dotSize = 14
        local dotRadius = dotSize/2
        
        local dx = (-relativeYaw/yawRange)*horizonRadius -- Values from -1 to 1 indicating offset from the center
        local dy = (relativePitch/pitchRange)*horizonRadius
        local x = centerX + dx
        local y = centerY + dy

        local distance = math.sqrt((dx)^2 + (dy)^2)

        local progradeDot = [[<circle
        cx="]] .. x .. [["
        cy="]] .. y .. [["
        r="]] .. dotRadius/dotSize .. [["
        style="fill:#d7fe00;stroke:none;fill-opacity:1"/>
     <circle
        cx="]] .. x .. [["
        cy="]] .. y .. [["
        r="]] .. dotRadius .. [["
        style="stroke:#d7fe00;stroke-opacity:1;fill:none" />
     <path
        d="M ]] .. x-dotSize .. [[,]] .. y .. [[ h ]] .. dotRadius .. [["
        style="stroke:#d7fe00;stroke-opacity:1" />
     <path
        d="M ]] .. x+dotRadius .. [[,]] .. y .. [[ h ]] .. dotRadius .. [["
        style="stroke:#d7fe00;stroke-opacity:1" />
     <path
        d="M ]] .. x .. [[,]] .. y-dotSize .. [[ v ]] .. dotRadius .. [["
        style="stroke:#d7fe00;stroke-opacity:1" />]]
            
        if distance < horizonRadius then
            newContent[#newContent + 1] = progradeDot
            -- Draw a dot or whatever at x,y, it's inside the AH
        else
            -- x,y is outside the AH.  Figure out how to draw an arrow on the edge of the circle pointing to it.
            -- First get the angle
            -- tan(ang) = o/a, tan(ang) = x/y
            -- atan(x/y) = ang (in radians)
            -- This is a special overload for doing this on a circle and setting up the signs correctly for the quadrants
            local angle = math.atan(dy,dx)
             -- Project this onto the circle
            -- These are backwards from what they're supposed to be.  Don't know why, that's just what makes it work apparently
            local arrowSize = 4
            local projectedX = centerX + (horizonRadius)*math.cos(angle) -- Needs to be converted to deg?  Probably not
            local projectedY = centerY + (horizonRadius)*math.sin(angle)
            -- Draw an arrow that we will rotate by angle
            -- Convert angle to degrees
            newContent[#newContent + 1] = stringf('<g transform="rotate(%f %f %f)"><rect x="%f" y="%f" width="%f" height="%f" stroke="#d7fe00" fill="#d7fe00" /><path d="M %f %f l %f %f l %f %f z" fill="#d7fe00" stroke="#d7fe00"></g>', angle*(180/math.pi), projectedX, projectedY, projectedX-arrowSize, projectedY-arrowSize/2, arrowSize*2, arrowSize,
                                                                                                                                                projectedX+arrowSize, projectedY - arrowSize, arrowSize, arrowSize, -arrowSize, arrowSize)

            --newContent[#newContent + 1] = stringf('<circle cx="%f" cy="%f" r="2" stroke="white" stroke-width="2" fill="white" />', projectedX, projectedY)
        end

        if(not inAtmo) then
            relativePitch = getRelativePitch(-velo)
            relativeYaw = getRelativeYaw(-velo)
            
            dx = (-relativeYaw/yawRange)*horizonRadius -- Values from -1 to 1 indicating offset from the center
            dy = (relativePitch/pitchRange)*horizonRadius
            x = centerX + dx
            y = centerY + dy

            distance = math.sqrt((dx)^2 + (dy)^2)
            -- Retrograde Dot
            
            if distance < horizonRadius then
                local retrogradeDot = [[<circle
                cx="]] .. x .. [["
                cy="]] .. y .. [["
                r="]] .. dotRadius .. [["
                style="stroke:#d7fe00;stroke-opacity:1;fill:none" />
             <path
                d="M ]] .. x .. [[,]] .. y-dotSize .. [[ v ]] .. dotRadius .. [["
                style="stroke:#d7fe00;stroke-opacity:1" id="l"/>
             <use
                xlink:href="#l"
                transform="rotate(120,]] .. x .. [[,]] .. y .. [[)" />
             <use
                xlink:href="#l"
                transform="rotate(-120,]] .. x .. [[,]] .. y .. [[)" />
             <path
                d="M ]] .. x-dotRadius .. [[,]] .. y .. [[ h ]] .. dotSize .. [["
                style="stroke-width:0.5;stroke:#d7fe00;stroke-opacity:1"
                transform="rotate(-45,]] .. x .. [[,]] .. y .. [[)" id="c"/>
            <use
                xlink:href="#c"
                transform="rotate(-90,]] .. x .. [[,]] .. y .. [[)"/>]]
                newContent[#newContent + 1] = retrogradeDot
                -- Draw a dot or whatever at x,y, it's inside the AH
            end -- Don't draw an arrow for this one, only prograde is that important

        end
    end
end

function DrawWarnings(newContent)
    newContent[#newContent + 1] = stringf(
                                      [[<text class="hudver" x="%d" y="%d">DU Hud Version: %.3f</text>]], 
                                      ConvertResolutionX(1900), ConvertResolutionY(1070), VERSION_NUMBER)
    newContent[#newContent + 1] = [[<g class="warnings">]]
    if unit.isMouseControlActivated() == 1 then
        newContent[#newContent + 1] = stringf([[
            <text x="%d" y="%d">Warning: Invalid Control Scheme Detected</text>]],
            ConvertResolutionX(960), ConvertResolutionY(550))
        newContent[#newContent + 1] = stringf([[
            <text x="%d" y="%d">Keyboard Scheme must be selected</text>]],
            ConvertResolutionX(960), ConvertResolutionY(600))
        newContent[#newContent + 1] = stringf([[
            <text x="%d" y="%d">Set your preferred scheme in Lua Parameters instead</text>]],
            ConvertResolutionX(960), ConvertResolutionY(650))
    end
    local warningX = ConvertResolutionX(960)
    local brakeY = ConvertResolutionY(860)
    local gearY = ConvertResolutionY(880)
    local hoverY = ConvertResolutionY(900)
    local ewarpY = ConvertResolutionY(960)
    local apY = ConvertResolutionY(200)
    local turnBurnY = ConvertResolutionY(150)
    local gyroY = ConvertResolutionY(960)
    if isRemote() == 1 and not RemoteHud then
        brakeY = ConvertResolutionY(135)
        gearY = ConvertResolutionY(155)
        hoverY = ConvertResolutionY(175)
        apY = ConvertResolutionY(115)
        turnBurnY = ConvertResolutionY(95)
    end
    if BrakeIsOn then
        newContent[#newContent + 1] = stringf([[<text x="%d" y="%d">Brake Engaged</text>]], warningX, brakeY)
    elseif brakeInput2 > 0 then
        newContent[#newContent + 1] = stringf([[<text x="%d" y="%d" style="opacity:%s">Auto-Brake Engaged</text>]], warningX, brakeY, brakeInput2)
    end
    if inAtmo and stalling and hoverDetectGround() == -1 then
        newContent[#newContent + 1] = stringf([[<text x="%d" y="%d">** STALL WARNING **</text>]], warningX, apY+50)
    end
    if gyroIsOn then
        newContent[#newContent + 1] = stringf([[<text x="%d" y="%d">Gyro Enabled</text>]], warningX, gyroY)
    end
    if GearExtended then
        if hasGear then
            newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Gear Extended</text>]],
                                              warningX, gearY)
        else
            newContent[#newContent + 1] = stringf([[<text x="%d" y="%d">Landed (G: Takeoff)</text>]], warningX,
                                              gearY)
        end
        local displayText, displayUnit = getDistanceDisplayString(Nav:getTargetGroundAltitude())
        newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Hover Height: %s</text>]],
                                          warningX, hoverY,
                                          displayText.. displayUnit)
    end
    if isBoosting then
        newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">ROCKET BOOST ENABLED</text>]],
                                          warningX, ewarpY+20)
    end                  
    if antigrav and not ExternalAGG and antigrav.getState() == 1 and AntigravTargetAltitude ~= nil then
        if math.abs(coreAltitude - antigrav.getBaseAltitude()) < 501 then
            newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">AGG On - Target Altitude: %d Singluarity Altitude: %d</text>]],
                warningX, apY+20, mfloor(AntigravTargetAltitude), mfloor(antigrav.getBaseAltitude()))
        else
            newContent[#newContent + 1] = stringf([[<text x="%d" y="%d">AGG On - Target Altitude: %d Singluarity Altitude: %d</text>]],
                warningX, apY+20, mfloor(AntigravTargetAltitude), mfloor(antigrav.getBaseAltitude()))
        end
    elseif Autopilot and AutopilotTargetName ~= "None" then
        newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Autopilot %s</text>]],
                                          warningX, apY+20, AutopilotStatus)
    elseif LockPitch ~= nil then
        newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">LockedPitch: %d</text>]],
                                            warningX, apY+20, mfloor(LockPitch))
    elseif followMode then
        newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Follow Mode Engaged</text>]],
                                          warningX, apY+20)
    elseif Reentry then
        newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Re-entry in Progress</text>]],
                                              warningX, apY+20)
    end
    local intersectBody, farSide, nearSide = galaxyReference:getPlanetarySystem(0):castIntersections(vec3(core.getConstructWorldPos()), (velocity):normalize(), function(body) if body.noAtmosphericDensityAltitude > 0 then return (body.radius+body.noAtmosphericDensityAltitude) else return (body.radius+body.surfaceMaxAltitude*1.5) end end)
    local atmoDistance = farSide
    if nearSide ~= nil and farSide ~= nil then
        atmoDistance = math.min(nearSide,farSide)
    end
    if AltitudeHold then
        if AutoTakeoff and not IntoOrbit then
            local displayText, displayUnit = getDistanceDisplayString(HoldAltitude)
            newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Ascent to %s</text>]],
                                              warningX, apY, displayText.. displayUnit)
            if BrakeIsOn then
                newContent[#newContent + 1] = stringf(
                                                  [[<text class="crit" x="%d" y="%d">Throttle Up and Disengage Brake For Takeoff</text>]],
                                                  warningX, apY + 50)
            end
        else
            local displayText, displayUnit = getDistanceDisplayString2(HoldAltitude)
            newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Altitude Hold: %s</text>]],
                                              warningX, apY, displayText.. displayUnit)
        end
    end
    if VertTakeOff and (antigrav ~= nil and antigrav) then
        if atmosphere() > 0.1 then
            newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Beginning ascent</text>]],
            warningX, apY)
        elseif atmosphere() < 0.09 and atmosphere() > 0.05 then
            newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Aligning trajectory</text>]],
            warningX, apY)
        elseif atmosphere() < 0.05 then
            newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">Leaving atmosphere</text>]],
            warningX, apY)
        end
    end
    if IntoOrbit then
        if orbitMsg ~= nil then
            newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">%s</text>]],
            warningX, apY, orbitMsg)
        end
    end
    if BrakeLanding then
        if StrongBrakes then
            newContent[#newContent + 1] = stringf([[<text x="%d" y="%d">Brake-Landing</text>]], warningX, apY)
        else
            newContent[#newContent + 1] = stringf([[<text x="%d" y="%d">Coast-Landing</text>]], warningX, apY)
        end
    end
    if ProgradeIsOn then
        newContent[#newContent + 1] = stringf([[<text class="crit" x="%d" y="%d">Prograde Alignment</text>]],
                                          warningX, apY)
    end
    if RetrogradeIsOn then
        newContent[#newContent + 1] = stringf([[<text class="crit" x="%d" y="%d">Retrograde Alignment</text>]],
                                          warningX, apY)
    end
    if TurnBurn then
        newContent[#newContent + 1] = stringf([[<text class="crit" x="%d" y="%d">Turn & Burn Braking</text>]],
                                          warningX, turnBurnY)
    elseif atmoDistance ~= nil and atmosphere() == 0 then
            local displayText, displayUnit = getDistanceDisplayString(atmoDistance)
            local travelTime = Kinematic.computeTravelTime(velMag, 0, atmoDistance)
            local displayCollisionType = "Collision"
            if intersectBody.noAtmosphericDensityAltitude > 0 then displayCollisionType = "Atmosphere" end
            newContent[#newContent + 1] = stringf([[<text class="crit" x="%d" y="%d">%s %s In %s (%s)</text>]],
                                              warningX, turnBurnY,intersectBody.name,displayCollisionType, FormatTimeString(travelTime), displayText.. displayUnit)
           
    end
    if VectorToTarget and not IntoOrbit then
        newContent[#newContent + 1] = stringf([[<text class="warn" x="%d" y="%d">%s</text>]], warningX,
                                          apY+30, VectorStatus)
    end

    newContent[#newContent + 1] = "</g>"
end

function DisplayOrbitScreen(newContent)
    if orbit ~= nil and atmosphere() < 0.2 and planet ~= nil and orbit.apoapsis ~= nil and
        orbit.periapsis ~= nil and orbit.period ~= nil and orbit.apoapsis.speed > 5 and DisplayOrbit then
        -- If orbits are up, let's try drawing a mockup
        local orbitMapX = OrbitMapX
        local orbitMapY = OrbitMapY
        local orbitMapSize = OrbitMapSize -- Always square
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
            local displayText, displayUnit = getDistanceDisplayString(orbit.apoapsis.altitude)
            newContent[#newContent + 1] = stringf([[<text x="%f" y="%f">%s</text>]], x, y,
                                              displayText.. displayUnit)
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
            local displayText, displayUnit = getDistanceDisplayString(orbit.periapsis.altitude)
            newContent[#newContent + 1] = stringf([[<text x="%f" y="%f">%s</text>]], x, y,
                                              displayText.. displayUnit)
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

function getDistanceDisplayString(distance)
    local su = distance > 100000
    local result, displayUnit = ""
    if su then
        -- Convert to SU
        result, displayUnit = round(distance / 1000 / 200, 1),"SU"
    elseif distance < 1000 then
        result, displayUnit = round(distance, 1),"m"
    else
        -- Convert to KM
        result, displayUnit = round(distance / 1000, 1),"Km"
    end

    return result, displayUnit
end

function getDistanceDisplayString2(distance)
    local su = distance > 100000
    local result, displayUnit = ""
    if su then
        -- Convert to SU
        result, displayUnit = round(distance / 1000 / 200, 2)," SU"
    elseif distance < 1000 then
        result, displayUnit = round(distance, 2)," M"
    else
        -- Convert to KM
        result, displayUnit = round(distance / 1000, 2)," KM"
    end

    return result, displayUnit
end

function getSpeedDisplayString(speed) -- TODO: Allow options, for now just do kph
    return mfloor(round(speed * 3.6, 0) + 0.5) .. " km/h" -- And generally it's not accurate enough to not twitch unless we round 0
end

function FormatTimeString(seconds)
    local minutes = 0
    local hours = 0
    local days = 0
    if seconds < 60 then
        seconds = mfloor(seconds)
    elseif seconds < 3600 then
        minutes = mfloor(seconds / 60)
        seconds = mfloor(seconds % 60) 
    elseif seconds < 86400 then
        hours = mfloor(seconds / 3600)
        minutes = mfloor( (seconds % 3600) / 60)
    else
        days = mfloor ( seconds / 86400)
        hours = mfloor ( (seconds % 86400) / 3600)
    end
    if days > 0 then 
        return days .. "d " .. hours .."h "
    elseif hours > 0 then
        return hours .. "h " .. minutes .. "m "
    elseif minutes > 0 then
        return minutes .. "m " .. seconds .. "s"
    elseif seconds > 0 then 
        return seconds .. "s"
    else
        return "0s"
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
        autopilotTargetPlanet = nil
        CustomTarget = nil
        return true
    end

    local atlasIndex = AtlasOrdered[AutopilotTargetIndex].index
    local autopilotEntry = atlas[0][atlasIndex]
    if autopilotEntry.center then -- Is a real atlas entry
        AutopilotTargetName = autopilotEntry.name
        autopilotTargetPlanet = galaxyReference[0][atlasIndex]
        if CustomTarget ~= nil then
            if atmosphere() == 0 then
                if system.updateData(widgetMaxBrakeTimeText, widgetMaxBrakeTime) ~= 1 then
                    system.addDataToWidget(widgetMaxBrakeTimeText, widgetMaxBrakeTime) end
                if system.updateData(widgetMaxBrakeDistanceText, widgetMaxBrakeDistance) ~= 1 then
                    system.addDataToWidget(widgetMaxBrakeDistanceText, widgetMaxBrakeDistance) end
                if system.updateData(widgetCurBrakeTimeText, widgetCurBrakeTime) ~= 1 then
                    system.addDataToWidget(widgetCurBrakeTimeText, widgetCurBrakeTime) end
                if system.updateData(widgetCurBrakeDistanceText, widgetCurBrakeDistance) ~= 1 then
                    system.addDataToWidget(widgetCurBrakeDistanceText, widgetCurBrakeDistance) end
                if system.updateData(widgetTrajectoryAltitudeText, widgetTrajectoryAltitude) ~= 1 then
                    system.addDataToWidget(widgetTrajectoryAltitudeText, widgetTrajectoryAltitude) end
            end
            if system.updateData(widgetMaxMassText, widgetMaxMass) ~= 1 then
                system.addDataToWidget(widgetMaxMassText, widgetMaxMass) end
            if system.updateData(widgetTravelTimeText, widgetTravelTime) ~= 1 then
                system.addDataToWidget(widgetTravelTimeText, widgetTravelTime) end
            if system.updateData(widgetTargetOrbitText, widgetTargetOrbit) ~= 1 then
                system.addDataToWidget(widgetTargetOrbitText, widgetTargetOrbit) end
        end
        CustomTarget = nil
    else
        CustomTarget = autopilotEntry
        for _, v in pairs(galaxyReference[0]) do
            if v.name == CustomTarget.planetname then
                autopilotTargetPlanet = v
                AutopilotTargetName = CustomTarget.name
                break
            end
        end
        if system.updateData(widgetMaxMassText, widgetMaxMass) ~= 1 then
            system.addDataToWidget(widgetMaxMassText, widgetMaxMass) end
        if system.updateData(widgetTravelTimeText, widgetTravelTime) ~= 1 then
            system.addDataToWidget(widgetTravelTimeText, widgetTravelTime) end
    end
    if CustomTarget == nil then
        AutopilotTargetCoords = vec3(autopilotTargetPlanet.center) -- Aim center until we align
    else
        AutopilotTargetCoords = CustomTarget.position
    end
    -- Determine the end speed
    if autopilotTargetPlanet.planetname ~= "Space" then
        if autopilotTargetPlanet.hasAtmosphere then 
            AutopilotTargetOrbit = math.floor(autopilotTargetPlanet.radius*(TargetOrbitRadius-1) + autopilotTargetPlanet.noAtmosphericDensityAltitude)
        else
            AutopilotTargetOrbit = math.floor(autopilotTargetPlanet.radius*(TargetOrbitRadius-1) + autopilotTargetPlanet.surfaceMaxAltitude)
        end
    else
        AutopilotTargetOrbit = 1000
    end
    if CustomTarget ~= nil and CustomTarget.planetname == "Space" then 
        AutopilotEndSpeed = 0
    else
        _, AutopilotEndSpeed = Kep(autopilotTargetPlanet):escapeAndOrbitalSpeed(AutopilotTargetOrbit)
    end
    AutopilotPlanetGravity = 0 -- This is inaccurate unless we integrate and we're not doing that.  
    AutopilotAccelerating = false
    AutopilotBraking = false
    AutopilotCruising = false
    Autopilot = false
    AutopilotRealigned = false
    AutopilotStatus = "Aligning"
    return true
end

function IncrementAutopilotTargetIndex()
    AutopilotTargetIndex = AutopilotTargetIndex + 1
    if AutopilotTargetIndex > #AtlasOrdered then
        AutopilotTargetIndex = 0
    end
    if AutopilotTargetIndex == 0 then
        UpdateAutopilotTarget()
    else
        local atlasIndex = AtlasOrdered[AutopilotTargetIndex].index
        local autopilotEntry = atlas[0][atlasIndex]
        if autopilotEntry.name == "Space" then 
            IncrementAutopilotTargetIndex() 
        else
            -- if AutopilotTargetIndex > tablelength(atlas[0]) then
            UpdateAutopilotTarget()
        end
    end
end

function DecrementAutopilotTargetIndex()
    AutopilotTargetIndex = AutopilotTargetIndex - 1
    if AutopilotTargetIndex < 0 then
        --    AutopilotTargetIndex = tablelength(atlas[0])
            AutopilotTargetIndex = #AtlasOrdered
    end        
    if AutopilotTargetIndex == 0 then
        UpdateAutopilotTarget()
    else
        local atlasIndex = AtlasOrdered[AutopilotTargetIndex].index
        local autopilotEntry = atlas[0][atlasIndex]
        if autopilotEntry.name == "Space" then 
            DecrementAutopilotTargetIndex() 
        else
            UpdateAutopilotTarget()
        end
    end
end

function GetAutopilotMaxMass()
    local apmaxmass = LastMaxBrakeInAtmo /
                          (autopilotTargetPlanet:getGravity(
                              autopilotTargetPlanet.center + (vec3(0, 0, 1) * autopilotTargetPlanet.radius))
                              :len())
    return apmaxmass
end

function GetAutopilotTravelTime()
    if not Autopilot then
        if CustomTarget == nil or CustomTarget.planetname ~= planet.name then
            AutopilotDistance = (autopilotTargetPlanet.center - vec3(core.getConstructWorldPos())):len() -- This updates elsewhere if we're already piloting
        else
            AutopilotDistance = (CustomTarget.position - vec3(core.getConstructWorldPos())):len()
        end
    end
    local velocity = core.getWorldVelocity()
    local speed = vec3(velocity):len()
    local throttle = unit.getThrottle()/100
    if AtmoSpeedAssist then throttle = PlayerThrottle end
    local accelDistance, accelTime =
        Kinematic.computeDistanceAndTime(vec3(velocity):len(), MaxGameVelocity, -- From currently velocity to max
            constructMass(), Nav:maxForceForward()*throttle, warmup, -- T50?  Assume none, negligible for this
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
    if not TurnBurn and speed > 0 then -- Will this cause problems?  Was spamming something in here was giving 0 speed and 0 accel
        _, curBrakeTime = GetAutopilotBrakeDistanceAndTime(speed)
    else
        _, curBrakeTime = GetAutopilotTBBrakeDistanceAndTime(speed)
    end
    local cruiseDistance = 0
    local cruiseTime = 0
    -- So, time is in seconds
    -- If cruising or braking, use real cruise/brake values
    if AutopilotCruising or (not Autopilot and speed > 5) then -- If already cruising, use current speed
        cruiseTime = Kinematic.computeTravelTime(speed, 0, AutopilotDistance)
    elseif brakeDistance + accelDistance < AutopilotDistance then
        -- Add any remaining distance
        cruiseDistance = AutopilotDistance - (brakeDistance + accelDistance)
        cruiseTime = Kinematic.computeTravelTime(8333.0556, 0, cruiseDistance)
    else
        local accelRatio = (AutopilotDistance - brakeDistance) / accelDistance
        accelDistance = AutopilotDistance - brakeDistance -- Accel until we brake
        
        accelTime = accelTime * accelRatio
    end
    if CustomTarget ~= nil and CustomTarget.planetname == planet.name and not Autopilot then
        return cruiseTime
    elseif AutopilotBraking then
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
    if not inAtmo then
        RefreshLastMaxBrake()
        return Kinematic.computeDistanceAndTime(speed, AutopilotEndSpeed, constructMass(), 0, 0,
                   LastMaxBrake - (AutopilotPlanetGravity * constructMass()))
    else
        if LastMaxBrakeInAtmo and LastMaxBrakeInAtmo > 0 then
            return Kinematic.computeDistanceAndTime(speed, AutopilotEndSpeed, constructMass(), 0, 0,
                       LastMaxBrakeInAtmo - (AutopilotPlanetGravity * constructMass()))
        else
            return 0, 0
        end
    end
end

function GetAutopilotTBBrakeDistanceAndTime(speed) -- Uses thrust and a configured T50
    RefreshLastMaxBrake()
    return Kinematic.computeDistanceAndTime(speed, AutopilotEndSpeed, constructMass(), Nav:maxForceForward(),
               warmup, LastMaxBrake - (AutopilotPlanetGravity * constructMass()))
end

function hoverDetectGround()
    local vgroundDistance = -1
    local hgroundDistance = -1
    if vBooster then
        vgroundDistance = vBooster.distance()
    end
    if hover then
        hgroundDistance = hover.distance()
    end
    if vgroundDistance ~= -1 and hgroundDistance ~= -1 then
        if vgroundDistance < hgroundDistance then
            return vgroundDistance
        else
            return hgroundDistance
        end
    elseif vgroundDistance ~= -1 then
        return vgroundDistance
    elseif hgroundDistance ~= -1 then
        return hgroundDistance
    else
        return -1
    end
end            

function AboveGroundLevel()
    local groundDistance = -1
    local hgroundDet = hoverDetectGround()
    if telemeter_1 then 
        groundDistance = telemeter_1.getDistance()
    end
    if hgroundDet ~= -1 and groundDistance ~= -1 then
        if hgroundDet < groundDistance then 
            return hgroundDet 
        else
            return groundDistance
        end
    elseif hgroundDet ~= -1 then
        return hgroundDet
    else
        return groundDistance
    end
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
    sprint(stringf("SUM: %.4f AVG: %.4f MIN: %.4f MAX: %.4f CNT: %d", totalTime, averageTime, min,
                     max, samples))
end

function updateWeapons()
    if weapon then
        if  WeaponPanelID==nil and (radarPanelID ~= nil or GearExtended)  then
            _autoconf.displayCategoryPanel(weapon, weapon_size, L_TEXT("ui_lua_widget_weapon", "Weapons"), "weapon", true)
            WeaponPanelID = _autoconf.panels[_autoconf.panels_size]
        elseif WeaponPanelID ~= nil and radarPanelID == nil and not GearExtended then
            system.destroyWidgetPanel(WeaponPanelID)
            WeaponPanelID = nil
        end
    end
end

function updateRadar()
    if (radar_1) then
        local radarContacts = radar_1.getEntries()
        local radarData = radar_1.getData()
        local radarX = ConvertResolutionX(1770)
        local radarY = ConvertResolutionY(330)
        if #radarContacts > 0 then
            local target = radarData:find('identifiedConstructs":%[%]')
            if target == nil and perisPanelID == nil then
                peris = 1
                ToggleRadarPanel()
            end
            if target ~= nil and perisPanelID ~= nil then
                ToggleRadarPanel()
            end
            if radarPanelID == nil then
                ToggleRadarPanel()
            end
            radarMessage = stringf(
                            [[<text class="pbright txtbig txtmid" x="%d" y="%d">Radar: %i contacts</text>]],
                            radarX, radarY, #radarContacts)
            local friendlies = {}
            for k, v in pairs(radarContacts) do
                if radar_1.hasMatchingTransponder(v) == 1 then
                    table.insert(friendlies,v)
                end
            end
            if #friendlies > 0 then
                local y = ConvertResolutionY(15)
                local x = ConvertResolutionX(1370)
                radarMessage = stringf(
                                [[%s<text class="pbright txtbig txtmid" x="%d" y="%d">Friendlies In Range</text>]],
                                radarMessage, x, y)
                for k, v in pairs(friendlies) do
                    y = y + 20
                    radarMessage = stringf([[%s<text class="pdim txtmid" x="%d" y="%d">%s</text>]],
                                    radarMessage, x, y, radar_1.getConstructName(v))
                end
            end
        else
            local data
            data = radarData:find('worksInEnvironment":false')
            if data then
                radarMessage = stringf([[
                    <text class="pbright txtbig txtmid" x="%d" y="%d">Radar: Jammed</text>]],
                    radarX, radarY)
            else
                radarMessage = stringf([[
                    <text class="pbright txtbig txtmid" x="%d" y="%d">Radar: No Contacts</text>]],
                    radarX, radarY)
            end
            if radarPanelID ~= nil then
                peris = 0
                ToggleRadarPanel()
            end
        end
    end
end

function DisplayMessage(newContent, displayText)
    if displayText ~= "empty" then
        newContent[#newContent + 1] = [[<text class="msg" x="50%%" y="310" >]]
        for str in string.gmatch(displayText, "([^\n]+)") do
            newContent[#newContent + 1] = stringf([[<tspan x="50%%" dy="35">%s</tspan>]], str)
        end
        newContent[#newContent + 1] = [[</text>]]
    end
    if msgTimer ~= 0 then
        unit.setTimer("msgTick", msgTimer)
        msgTimer = 0
    end
end

function updateDistance()
    local curTime = system.getTime()
    local velocity = vec3(core.getWorldVelocity())
    local spd = vec3(velocity):len()
    local elapsedTime = curTime - lastTravelTime
    if (spd > 1.38889) then
        spd = spd / 1000
        local newDistance = spd * (curTime - lastTravelTime)
        TotalDistanceTravelled = TotalDistanceTravelled + newDistance
        totalDistanceTrip = totalDistanceTrip + newDistance
    end
    flightTime = flightTime + elapsedTime
    TotalFlightTime = TotalFlightTime + elapsedTime
    lastTravelTime = curTime
end

function composeAxisAccelerationFromTargetSpeedV(commandAxis, targetSpeed)

    local axisCRefDirection = vec3()
    local axisWorldDirection = vec3()

    if (commandAxis == axisCommandId.longitudinal) then
        axisCRefDirection = vec3(core.getConstructOrientationForward())
        axisWorldDirection = vec3(core.getConstructWorldOrientationForward())
    elseif (commandAxis == axisCommandId.vertical) then
        axisCRefDirection = vec3(core.getConstructOrientationUp())
        axisWorldDirection = vec3(core.getConstructWorldOrientationUp())
    elseif (commandAxis == axisCommandId.lateral) then
        axisCRefDirection = vec3(core.getConstructOrientationRight())
        axisWorldDirection = vec3(core.getConstructWorldOrientationRight())
    else
        return vec3()
    end

    local gravityAcceleration = vec3(core.getWorldGravity())
    local gravityAccelerationCommand = gravityAcceleration:dot(axisWorldDirection)

    local airResistanceAcceleration = vec3(core.getWorldAirFrictionAcceleration())
    local airResistanceAccelerationCommand = airResistanceAcceleration:dot(axisWorldDirection)

    local currentVelocity = vec3(core.getVelocity())
    local currentAxisSpeedMS = currentVelocity:dot(axisCRefDirection)

    local targetAxisSpeedMS = targetSpeed * constants.kph2m

    if targetSpeedPID2 == nil then -- CHanged first param from 1 to 10...
        targetSpeedPID2 = pid.new(10, 0, 10.0) -- The PID used to compute acceleration to reach target speed
    end

    targetSpeedPID2:inject(targetAxisSpeedMS - currentAxisSpeedMS) -- update PID

    local accelerationCommand = targetSpeedPID2:get()

    local finalAcceleration = (accelerationCommand - airResistanceAccelerationCommand - gravityAccelerationCommand) * axisWorldDirection  -- Try to compensate air friction

    -- The hell are these? Uncommented recently just in case they were important
    --system.addMeasure("dynamic", "acceleration", "command", accelerationCommand)
    --system.addMeasure("dynamic", "acceleration", "intensity", finalAcceleration:len())

    return finalAcceleration
end

function composeAxisAccelerationFromTargetSpeed(commandAxis, targetSpeed)

    local axisCRefDirection = vec3()
    local axisWorldDirection = vec3()

    if (commandAxis == axisCommandId.longitudinal) then
        axisCRefDirection = vec3(core.getConstructOrientationForward())
        axisWorldDirection = vec3(core.getConstructWorldOrientationForward())
    elseif (commandAxis == axisCommandId.vertical) then
        axisCRefDirection = vec3(core.getConstructOrientationUp())
        axisWorldDirection = vec3(core.getConstructWorldOrientationUp())
    elseif (commandAxis == axisCommandId.lateral) then
        axisCRefDirection = vec3(core.getConstructOrientationRight())
        axisWorldDirection = vec3(core.getConstructWorldOrientationRight())
    else
        return vec3()
    end

    local gravityAcceleration = vec3(core.getWorldGravity())
    local gravityAccelerationCommand = gravityAcceleration:dot(axisWorldDirection)

    local airResistanceAcceleration = vec3(core.getWorldAirFrictionAcceleration())
    local airResistanceAccelerationCommand = airResistanceAcceleration:dot(axisWorldDirection)

    local currentVelocity = vec3(core.getVelocity())
    local currentAxisSpeedMS = currentVelocity:dot(axisCRefDirection)

    local targetAxisSpeedMS = targetSpeed * constants.kph2m

    if targetSpeedPID == nil then -- CHanged first param from 1 to 10...
        targetSpeedPID = pid.new(10, 0, 10.0) -- The PID used to compute acceleration to reach target speed
    end

    targetSpeedPID:inject(targetAxisSpeedMS - currentAxisSpeedMS) -- update PID

    local accelerationCommand = targetSpeedPID:get()

    local finalAcceleration = (accelerationCommand - airResistanceAccelerationCommand - gravityAccelerationCommand) * axisWorldDirection  -- Try to compensate air friction

    -- The hell are these? Uncommented recently just in case they were important
    --system.addMeasure("dynamic", "acceleration", "command", accelerationCommand)
    --system.addMeasure("dynamic", "acceleration", "intensity", finalAcceleration:len())

    return finalAcceleration
end

-- Planet Info - https://gitlab.com/JayleBreak/dualuniverse/-/tree/master/DUflightfiles/autoconf/custom with minor modifications
function Atlas()
    return {
        [0] = {
            [0] = {
                GM = 0,
                bodyId = 0,
                center = {
                    x = 0,
                    y = 0,
                    z = 0
                },
                name = 'Space',
                planetarySystemId = 0,
                radius = 0,
                hasAtmosphere = false,
                gravity = 0,
                noAtmosphericDensityAltitude = 0,
                surfaceMaxAltitude = 0
            },
            [2] = {
                name = "Alioth",
                description = "Alioth is the planet selected by the arkship for landfall; it is a typical goldilocks planet where humanity may rebuild in the coming decades. The arkship geological survey reports mountainous regions alongside deep seas and lush forests. This is where it all starts.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.9401,
                atmosphericEngineMaxAltitude = 5580,
                biosphere = "Forest",
                classification = "Mesoplanet",
                bodyId = 2,
                GM = 157470826617,
                gravity = 1.0082568597356114,
                fullAtmosphericDensityMaxAltitude = -10,
                habitability = "High",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 6272,
                numSatellites = 2,
                positionFromSun = 2,
                center = {
                    x = -8,
                    y = -8,
                    z = -126303
                },
                radius = 126067.8984375,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 3410,
                surfaceArea = 199718780928,
                surfaceAverageAltitude = 200,
                surfaceMaxAltitude = 1100,
                surfaceMinAltitude = -330,
                systemZone = "High",
                territories = 259472,
                type = "Planet",
                waterLevel = 0,
                planetarySystemId = 0
            },
            [21] = {
                name = "Alioth Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 21,
                GM = 2118960000,
                gravity = 0.24006116402380084,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 457933,
                    y = -1509011,
                    z = 115524
                },
                radius = 30000,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 0,
                surfaceArea = 11309733888,
                surfaceAverageAltitude = 140,
                surfaceMaxAltitude = 200,
                surfaceMinAltitude = 10,
                systemZone = nil,
                territories = 14522,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [22] = {
                name = "Alioth Moon 4",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 22,
                GM = 2165833514,
                gravity = 0.2427018259886451,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = -1692694,
                    y = 729681,
                    z = -411464
                },
                radius = 30330,
                safeAreaEdgeAltitude = 500000,
                size = "L",
                spaceEngineMinAltitude = 0,
                surfaceArea = 11559916544,
                surfaceAverageAltitude = -15,
                surfaceMaxAltitude = -5,
                surfaceMinAltitude = -50,
                systemZone = nil,
                territories = 14522,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [5] = {
                name = "Feli",
                description = "Feli is easily identified by its massive and deep crater. Outside of the crater, the arkship geological survey reports a fairly bland and uniform planet, it also cannot explain the existence of the crater. Feli is particular for having an extremely small atmosphere, allowing life to develop in the deeper areas of its crater but limiting it drastically on the actual surface.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.5488,
                atmosphericEngineMaxAltitude = 66725,
                biosphere = "Barren",
                classification = "Mesoplanet",
                bodyId = 5,
                GM = 16951680000,
                gravity = 0.4801223280476017,
                fullAtmosphericDensityMaxAltitude = 30,
                habitability = "Low",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 78500,
                numSatellites = 1,
                positionFromSun = 5,
                center = {
                    x = -43534464,
                    y = 22565536,
                    z = -48934464
                },
                radius = 41800,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 42800,
                surfaceArea = 21956466688,
                surfaceAverageAltitude = 18300,
                surfaceMaxAltitude = 18500,
                surfaceMinAltitude = 46,
                systemZone = "Low",
                territories = 27002,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [50] = {
                name = "Feli Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 50,
                GM = 499917600,
                gravity = 0.11202853997062348,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = -43902841.78,
                    y = 22261034.7,
                    z = -48862386
                },
                radius = 14000,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2463008768,
                surfaceAverageAltitude = 800,
                surfaceMaxAltitude = 900,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 3002,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [120] = {
                name = "Ion",
                description = "Ion is nothing more than an oversized ice cube frozen through and through. It is a largely inhospitable planet due to its extremely low temperatures. The arkship geological survey reports extremely rough mountainous terrain with little habitable land.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.9522,
                atmosphericEngineMaxAltitude = 10480,
                biosphere = "Ice",
                classification = "Hypopsychroplanet",
                bodyId = 120,
                GM = 7135606629,
                gravity = 0.36009174603570127,
                fullAtmosphericDensityMaxAltitude = -30,
                habitability = "Average",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 17700,
                numSatellites = 2,
                positionFromSun = 12,
                center = {
                    x = 2865536.7,
                    y = -99034464,
                    z = -934462.02
                },
                radius = 44950,
                safeAreaEdgeAltitude = 500000,
                size = "XS",
                spaceEngineMinAltitude = 6410,
                surfaceArea = 25390383104,
                surfaceAverageAltitude = 500,
                surfaceMaxAltitude = 1300,
                surfaceMinAltitude = 250,
                systemZone = "Average",
                territories = 32672,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [121] = {
                name = "Ion Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 121,
                GM = 106830900,
                gravity = 0.08802242599860607,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 2472916.8,
                    y = -99133747,
                    z = -1133582.8
                },
                radius = 11000,
                safeAreaEdgeAltitude = 500000,
                size = "XS",
                spaceEngineMinAltitude = 0,
                surfaceArea = 1520530944,
                surfaceAverageAltitude = 100,
                surfaceMaxAltitude = 200,
                surfaceMinAltitude = 3,
                systemZone = nil,
                territories = 1922,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [122] = {
                name = "Ion Moon 2",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 122,
                GM = 176580000,
                gravity = 0.12003058201190042,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 2995424.5,
                    y = -99275010,
                    z = -1378480.7
                },
                radius = 15000,
                safeAreaEdgeAltitude = 500000,
                size = "XS",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2827433472,
                surfaceAverageAltitude = -1900,
                surfaceMaxAltitude = -1400,
                surfaceMinAltitude = -2100,
                systemZone = nil,
                territories = 3632,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [9] = {
                name = "Jago",
                description = "Jago is a water planet. The large majority of the planet&apos;s surface is covered by large oceans dotted by small areas of landmass across the planet. The arkship geological survey reports deep seas across the majority of the planet with sub 15 percent coverage of solid ground.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.9835,
                atmosphericEngineMaxAltitude = 9695,
                biosphere = "Water",
                classification = "Mesoplanet",
                bodyId = 9,
                GM = 18606274330,
                gravity = 0.5041284298678057,
                fullAtmosphericDensityMaxAltitude = -90,
                habitability = "Very High",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 10900,
                numSatellites = 0,
                positionFromSun = 9,
                center = {
                    x = -94134462,
                    y = 12765534,
                    z = -3634464
                },
                radius = 61590,
                safeAreaEdgeAltitude = 500000,
                size = "XL",
                spaceEngineMinAltitude = 5900,
                surfaceArea = 47668367360,
                surfaceAverageAltitude = 0,
                surfaceMaxAltitude = 1200,
                surfaceMinAltitude = -500,
                systemZone = "Very High",
                territories = 60752,
                type = "Planet",
                waterLevel = 0,
                planetarySystemId = 0
            },
            [100] = {
                name = "Lacobus",
                description = "Lacobus is an ice planet that also features large bodies of water. The arkship geological survey reports deep oceans alongside a frozen and rough mountainous environment. Lacobus seems to feature regional geothermal activity allowing for the presence of water on the surface.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.7571,
                atmosphericEngineMaxAltitude = 11120,
                biosphere = "Ice",
                classification = "Psychroplanet",
                bodyId = 100,
                GM = 13975172474,
                gravity = 0.45611622622739767,
                fullAtmosphericDensityMaxAltitude = -20,
                habitability = "Average",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 12510,
                numSatellites = 3,
                positionFromSun = 10,
                center = {
                    x = 98865536,
                    y = -13534464,
                    z = -934461.99
                },
                radius = 55650,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 6790,
                surfaceArea = 38917074944,
                surfaceAverageAltitude = 800,
                surfaceMaxAltitude = 1660,
                surfaceMinAltitude = 250,
                systemZone = "Average",
                territories = 50432,
                type = "Planet",
                waterLevel = 0,
                planetarySystemId = 0
            },
            [102] = {
                name = "Lacobus Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 102,
                GM = 444981600,
                gravity = 0.14403669598391783,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 99180968,
                    y = -13783862,
                    z = -926156.4
                },
                radius = 18000,
                safeAreaEdgeAltitude = 500000,
                size = "XL",
                spaceEngineMinAltitude = 0,
                surfaceArea = 4071504128,
                surfaceAverageAltitude = 150,
                surfaceMaxAltitude = 300,
                surfaceMinAltitude = 10,
                systemZone = nil,
                territories = 5072,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [103] = {
                name = "Lacobus Moon 2",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 103,
                GM = 211503600,
                gravity = 0.11202853997062348,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 99250052,
                    y = -13629215,
                    z = -1059341.4
                },
                radius = 14000,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2463008768,
                surfaceAverageAltitude = -1380,
                surfaceMaxAltitude = -1280,
                surfaceMinAltitude = -1880,
                systemZone = nil,
                territories = 3002,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [101] = {
                name = "Lacobus Moon 3",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 101,
                GM = 264870000,
                gravity = 0.12003058201190042,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 98905288.17,
                    y = -13950921.1,
                    z = -647589.53
                },
                radius = 15000,
                safeAreaEdgeAltitude = 500000,
                size = "L",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2827433472,
                surfaceAverageAltitude = 500,
                surfaceMaxAltitude = 820,
                surfaceMinAltitude = 3,
                systemZone = nil,
                territories = 3632,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [1] = {
                name = "Madis",
                description = "Madis is a barren wasteland of a rock; it sits closest to the sun and temperatures reach extreme highs during the day. The arkship geological survey reports long rocky valleys intermittently separated by small ravines.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.8629,
                atmosphericEngineMaxAltitude = 7165,
                biosphere = "Barren",
                classification = "hyperthermoplanet",
                bodyId = 1,
                GM = 6930729684,
                gravity = 0.36009174603570127,
                fullAtmosphericDensityMaxAltitude = 220,
                habitability = "Low",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 8050,
                numSatellites = 3,
                positionFromSun = 1,
                center = {
                    x = 17465536,
                    y = 22665536,
                    z = -34464
                },
                radius = 44300,
                safeAreaEdgeAltitude = 500000,
                size = "XS",
                spaceEngineMinAltitude = 4480,
                surfaceArea = 24661377024,
                surfaceAverageAltitude = 750,
                surfaceMaxAltitude = 850,
                surfaceMinAltitude = 670,
                systemZone = "Low",
                territories = 30722,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [10] = {
                name = "Madis Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 10,
                GM = 78480000,
                gravity = 0.08002039003323584,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 17448118.224,
                    y = 22966846.286,
                    z = 143078.82
                },
                radius = 10000,
                safeAreaEdgeAltitude = 500000,
                size = "XL",
                spaceEngineMinAltitude = 0,
                surfaceArea = 1256637056,
                surfaceAverageAltitude = 210,
                surfaceMaxAltitude = 420,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 1472,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [11] = {
                name = "Madis Moon 2",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 11,
                GM = 237402000,
                gravity = 0.09602446196397631,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 17194626,
                    y = 22243633.88,
                    z = -214962.81
                },
                radius = 12000,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 0,
                surfaceArea = 1809557376,
                surfaceAverageAltitude = -700,
                surfaceMaxAltitude = 300,
                surfaceMinAltitude = -2900,
                systemZone = nil,
                territories = 1922,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [12] = {
                name = "Madis Moon 3",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 12,
                GM = 265046609,
                gravity = 0.12003058201190042,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 17520614,
                    y = 22184730,
                    z = -309989.99
                },
                radius = 15000,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2827433472,
                surfaceAverageAltitude = 700,
                surfaceMaxAltitude = 1100,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 3632,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [26] = {
                name = "Sanctuary",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.9666,
                atmosphericEngineMaxAltitude = 6935,
                biosphere = "",
                classification = "",
                bodyId = 26,
                GM = 68234043600,
                gravity = 1.0000000427743831,
                fullAtmosphericDensityMaxAltitude = -30,
                habitability = "",
                hasAtmosphere = true,
                isSanctuary = true,
                noAtmosphericDensityAltitude = 7800,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = -1404835,
                    y = 562655,
                    z = -285074
                },
                radius = 83400,
                safeAreaEdgeAltitude = 0,
                size = "L",
                spaceEngineMinAltitude = 4230,
                surfaceArea = 87406149632,
                surfaceAverageAltitude = 80,
                surfaceMaxAltitude = 500,
                surfaceMinAltitude = -60,
                systemZone = nil,
                territories = 111632,
                type = "",
                waterLevel = 0,
                planetarySystemId = 0
            },
            [6] = {
                name = "Sicari",
                description = "Sicari is a typical desert planet; it has survived for millenniums and will continue to endure. While not the most habitable of environments it remains a relatively untouched and livable planet of the Alioth sector. The arkship geological survey reports large flatlands alongside steep plateaus.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.897,
                atmosphericEngineMaxAltitude = 7725,
                biosphere = "Desert",
                classification = "Mesoplanet",
                bodyId = 6,
                GM = 10502547741,
                gravity = 0.4081039739797361,
                fullAtmosphericDensityMaxAltitude = -625,
                habitability = "Average",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 8770,
                numSatellites = 0,
                positionFromSun = 6,
                center = {
                    x = 52765536,
                    y = 27165538,
                    z = 52065535
                },
                radius = 51100,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 4480,
                surfaceArea = 32813432832,
                surfaceAverageAltitude = 130,
                surfaceMaxAltitude = 220,
                surfaceMinAltitude = 50,
                systemZone = "Average",
                territories = 41072,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [7] = {
                name = "Sinnen",
                description = "Sinnen is a an empty and rocky hell. With no atmosphere to speak of it is one of the least hospitable planets in the sector. The arkship geological survey reports mostly flatlands alongside deep ravines which look to have once been riverbeds. This planet simply looks to have dried up and died, likely from solar winds.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.9226,
                atmosphericEngineMaxAltitude = 10335,
                biosphere = "Desert",
                classification = "Mesoplanet",
                bodyId = 7,
                GM = 13033380591,
                gravity = 0.4401121421448438,
                fullAtmosphericDensityMaxAltitude = -120,
                habitability = "Average",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 11620,
                numSatellites = 1,
                positionFromSun = 7,
                center = {
                    x = 58665538,
                    y = 29665535,
                    z = 58165535
                },
                radius = 54950,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 6270,
                surfaceArea = 37944188928,
                surfaceAverageAltitude = 317,
                surfaceMaxAltitude = 360,
                surfaceMinAltitude = 23,
                systemZone = "Average",
                territories = 48002,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [70] = {
                name = "Sinnen Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 70,
                GM = 396912600,
                gravity = 0.1360346539426409,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 58969616,
                    y = 29797945,
                    z = 57969449
                },
                radius = 17000,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 0,
                surfaceArea = 3631681280,
                surfaceAverageAltitude = -2050,
                surfaceMaxAltitude = -1950,
                surfaceMinAltitude = -2150,
                systemZone = nil,
                territories = 4322,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [110] = {
                name = "Symeon",
                description = "Symeon is an ice planet mysteriously split at the equator by a band of solid desert. Exactly how this phenomenon is possible is unclear but some sort of weather anomaly may be responsible. The arkship geological survey reports a fairly diverse mix of flat-lands alongside mountainous formations.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.9559,
                atmosphericEngineMaxAltitude = 6920,
                biosphere = "Ice, Desert",
                classification = "Hybrid",
                bodyId = 110,
                GM = 9204742375,
                gravity = 0.3920998898971822,
                fullAtmosphericDensityMaxAltitude = -30,
                habitability = "High",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 7800,
                numSatellites = 0,
                positionFromSun = 11,
                center = {
                    x = 14165536,
                    y = -85634465,
                    z = -934464.3
                },
                radius = 49050,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 4230,
                surfaceArea = 30233462784,
                surfaceAverageAltitude = 39,
                surfaceMaxAltitude = 450,
                surfaceMinAltitude = 126,
                systemZone = "High",
                territories = 38882,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [4] = {
                name = "Talemai",
                description = "Talemai is a planet in the final stages of an Ice Age. It seems likely that the planet was thrown into tumult by a cataclysmic volcanic event which resulted in its current state. The arkship geological survey reports large mountainous regions across the entire planet.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.8776,
                atmosphericEngineMaxAltitude = 9685,
                biosphere = "Barren",
                classification = "Psychroplanet",
                bodyId = 4,
                GM = 14893847582,
                gravity = 0.4641182439650478,
                fullAtmosphericDensityMaxAltitude = -78,
                habitability = "Average",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 10890,
                numSatellites = 3,
                positionFromSun = 4,
                center = {
                    x = -13234464,
                    y = 55765536,
                    z = 465536
                },
                radius = 57500,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 5890,
                surfaceArea = 41547563008,
                surfaceAverageAltitude = 580,
                surfaceMaxAltitude = 610,
                surfaceMinAltitude = 520,
                systemZone = "Average",
                territories = 52922,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [42] = {
                name = "Talemai Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 42,
                GM = 264870000,
                gravity = 0.12003058201190042,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = -13058408,
                    y = 55781856,
                    z = 740177.76
                },
                radius = 15000,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2827433472,
                surfaceAverageAltitude = 720,
                surfaceMaxAltitude = 850,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 3632,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [40] = {
                name = "Talemai Moon 2",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 40,
                GM = 141264000,
                gravity = 0.09602446196397631,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = -13503090,
                    y = 55594325,
                    z = 769838.64
                },
                radius = 12000,
                safeAreaEdgeAltitude = 500000,
                size = "S",
                spaceEngineMinAltitude = 0,
                surfaceArea = 1809557376,
                surfaceAverageAltitude = 250,
                surfaceMaxAltitude = 450,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 1922,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [41] = {
                name = "Talemai Moon 3",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 41,
                GM = 106830900,
                gravity = 0.08802242599860607,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = -12800515,
                    y = 55700259,
                    z = 325207.84
                },
                radius = 11000,
                safeAreaEdgeAltitude = 500000,
                size = "XS",
                spaceEngineMinAltitude = 0,
                surfaceArea = 1520530944,
                surfaceAverageAltitude = 190,
                surfaceMaxAltitude = 400,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 1922,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [8] = {
                name = "Teoma",
                description = "[REDACTED] The arkship geological survey [REDACTED]. This planet should not be here.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.7834,
                atmosphericEngineMaxAltitude = 5580,
                biosphere = "Forest",
                classification = "Mesoplanet",
                bodyId = 8,
                GM = 18477723600,
                gravity = 0.48812434578525177,
                fullAtmosphericDensityMaxAltitude = 15,
                habitability = "High",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 6280,
                numSatellites = 0,
                positionFromSun = 8,
                center = {
                    x = 80865538,
                    y = 54665536,
                    z = -934463.94
                },
                radius = 62000,
                safeAreaEdgeAltitude = 500000,
                size = "L",
                spaceEngineMinAltitude = 3420,
                surfaceArea = 48305131520,
                surfaceAverageAltitude = 700,
                surfaceMaxAltitude = 1100,
                surfaceMinAltitude = -200,
                systemZone = "High",
                territories = 60752,
                type = "Planet",
                waterLevel = 0,
                planetarySystemId = 0
            },
            [3] = {
                name = "Thades",
                description = "Thades is a scorched desert planet. Perhaps it was once teaming with life but now all that remains is ash and dust. The arkship geological survey reports a rocky mountainous planet bisected by a massive unnatural ravine; something happened to this planet.",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0.03552,
                atmosphericEngineMaxAltitude = 32180,
                biosphere = "Desert",
                classification = "Thermoplanet",
                bodyId = 3,
                GM = 11776905000,
                gravity = 0.49612641213015557,
                fullAtmosphericDensityMaxAltitude = 150,
                habitability = "Low",
                hasAtmosphere = true,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 32800,
                numSatellites = 2,
                positionFromSun = 3,
                center = {
                    x = 29165536,
                    y = 10865536,
                    z = 65536
                },
                radius = 49000,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 21400,
                surfaceArea = 30171856896,
                surfaceAverageAltitude = 13640,
                surfaceMaxAltitude = 13690,
                surfaceMinAltitude = 370,
                systemZone = "Low",
                territories = 38882,
                type = "Planet",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [30] = {
                name = "Thades Moon 1",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 30,
                GM = 211564034,
                gravity = 0.11202853997062348,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 29214402,
                    y = 10907080.695,
                    z = 433858.2
                },
                radius = 14000,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2463008768,
                surfaceAverageAltitude = 60,
                surfaceMaxAltitude = 300,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 3002,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            },
            [31] = {
                name = "Thades Moon 2",
                description = "",
                antiGravMinAltitude = 1000,
                atmosphericDensityAboveSurface = 0,
                atmosphericEngineMaxAltitude = 0,
                biosphere = "",
                classification = "",
                bodyId = 31,
                GM = 264870000,
                gravity = 0.12003058201190042,
                fullAtmosphericDensityMaxAltitude = 0,
                habitability = "",
                hasAtmosphere = false,
                isSanctuary = false,
                noAtmosphericDensityAltitude = 0,
                numSatellites = 0,
                positionFromSun = 0,
                center = {
                    x = 29404193,
                    y = 10432768,
                    z = 19554.131
                },
                radius = 15000,
                safeAreaEdgeAltitude = 500000,
                size = "M",
                spaceEngineMinAltitude = 0,
                surfaceArea = 2827433472,
                surfaceAverageAltitude = 70,
                surfaceMaxAltitude = 350,
                surfaceMinAltitude = 0,
                systemZone = nil,
                territories = 3632,
                type = "",
                waterLevel = nil,
                planetarySystemId = 0
            }
        }
    }
end

function SetupAtlas()
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
        if not string.match(v.name, "Moon") and not string.match(v.name, "Sanctuary") and not string.match (v.name, "Space") then
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
            if (not body or distance2 < minDistance2) and params.name ~= "Space" then -- Never return space.  
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
        -- So then what's with all the weird ass sines and cosines?
        if acceleration > 0 then
            local k1 = C * math.asin(initial / C)
            local k2 = C2 * math.cos(k1 / C) / acceleration
            return (C * math.acos(acceleration * (k2 - distance) / C2) - k1) / acceleration
        end
        if initial == 0 then
            return -1 -- IDK something like that should make sure we never hit the assert yelling at us
        end
        assert(initial > 0, 'Acceleration and initial speed are both zero.')
        return distance / initial
    end

    function Kinematic.lorentz(v)
        return lorentz(v)
    end
    return Kinematic
end

function safeZone(WorldPos) -- Thanks to @SeM for the base code, modified to work with existing Atlas
    local radius = 500000
    local distsz, distp, key = math.huge
    local safe = false
    local safeWorldPos = vec3({13771471,7435803,-128971})
    local safeRadius = 18000000 
    distsz = vec3(WorldPos):dist(safeWorldPos)
    if distsz < safeRadius then  
        return true, math.abs(distsz - safeRadius), "Safe Zone", 0
    end
    distp = vec3(WorldPos):dist(vec3(planet.center))
    if distp < radius then safe = true end
    if math.abs(distp - radius) < math.abs(distsz - safeRadius) then 
        return safe, math.abs(distp - radius), planet.name, planet.bodyId
    else
        return safe, math.abs(distsz - safeRadius), "Safe Zone", 0
    end
end

function cmdThrottle(value, dontSwitch)
    if dontSwitch == nil then
        dontSwitch = false
    end
    if Nav.axisCommandManager:getAxisCommandType(0) ~= axisCommandType.byThrottle and not dontSwitch then
        Nav.control.cancelCurrentControlMasterMode()
    end
    Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, value)
    PlayerThrottle = round(value*100,0)
end
function cmdCruise(value, dontSwitch)
    if Nav.axisCommandManager:getAxisCommandType(0) ~= axisCommandType.byTargetSpeed and not dontSwitch then
        Nav.control.cancelCurrentControlMasterMode()
    end
    Nav.axisCommandManager:setTargetSpeedCommand(axisCommandId.longitudinal, value)
end

function SaveDataBank(copy)
    if dbHud_1 then
        if not wipedDatabank then
            for k, v in pairs(autoVariables) do
                dbHud_1.setStringValue(v, jencode(_G[v]))
                if copy and dbHud_2 then
                    dbHud_2.setStringValue(v, jencode(_G[v]))
                end
            end
            for k, v in pairs(saveableVariables) do
                dbHud_1.setStringValue(v, jencode(_G[v]))
                if copy and dbHud_2 then
                    dbHud_2.setStringValue(v, jencode(_G[v]))
                end
            end
            sprint("Saved Variables to Datacore")
            if copy and dbHud_2 then
                msgText = "Databank copied.  Remove copy when ready."
            end
        end
    end
end

-- Start of actual HUD Script. Written by Dimencia and Archaegeo. Optimization and Automation of scripting by ChronosWS  Linked sources where appropriate, most have been modified.

function script.onStart()
    VERSION_NUMBER = 5.451
    SetupComplete = false
    beginSetup = coroutine.create(function()
        Nav.axisCommandManager:setupCustomTargetSpeedRanges(axisCommandId.longitudinal,
            {1000, 5000, 10000, 20000, 30000})

        -- Load Saved Variables
        LoadVariables()
        coroutine.yield() -- Give it some time to breathe before we do the rest

        -- Find elements we care about
        ProcessElements()
        coroutine.yield() -- Give it some time to breathe before we do the rest

        SetupChecks() -- All the if-thens to set up for particular ship.  Specifically override these with the saved variables if available
        SetupButtons() -- Set up all the pushable buttons.
        coroutine.yield() -- Just to make sure

        -- Set up Jaylebreak and atlas
        SetupAtlas()
        PlanetaryReference = PlanetRef()
        galaxyReference = PlanetaryReference(Atlas())
        Kinematic = Kinematics()
        Kep = Keplers()
        AddLocationsToAtlas()
        UpdateAtlasLocationsList()
        UpdateAutopilotTarget()
        coroutine.yield()

        unit.hide()
        system.showScreen(1)
        -- That was a lot of work with dirty strings and json.  Clean up
        collectgarbage("collect")
        -- Start timers
        coroutine.yield()

        unit.setTimer("apTick", apTickRate)
        unit.setTimer("hudTick", hudTickRate)
        unit.setTimer("oneSecond", 1)
        unit.setTimer("tenthSecond", 1/10)

        if UseSatNav then 
            unit.setTimer("fiveSecond", 5) 
        end
    end)
end

function script.onStop()
    _autoconf.hideCategoryPanels()
    if antigrav ~= nil  and not ExternalAGG then
        antigrav.hide()
    end
    if warpdrive ~= nil then
        warpdrive.hide()
    end
    core.hide()
    Nav.control.switchOffHeadlights()
    -- Open door and extend ramp if available
    local atmo = atmosphere()
    if door and (atmo > 0 or (atmo == 0 and coreAltitude < 10000)) then
        for _, v in pairs(door) do
            v.toggle()
        end
    end
    if switch then
        for _, v in pairs(switch) do
            v.toggle()
        end
    end
    if forcefield and (atmo > 0 or (atmo == 0 and coreAltitude < 10000)) then
        for _, v in pairs(forcefield) do
            v.toggle()
        end
    end
    SaveDataBank()
    if button then
        button.activate()
    end

end

function script.onTick(timerId)
    if timerId == "tenthSecond" then
        if atmosphere() > 0 and not WasInAtmo then
            if Nav.axisCommandManager:getAxisCommandType(0) == axisCommandType.byTargetSpeed and AtmoSpeedAssist and (AltitudeHold or Reentry) then
                -- If they're reentering atmo from cruise, and have atmo speed Assist
                -- Put them in throttle mode at 100%
                PlayerThrottle = 1
                Nav.control.cancelCurrentControlMasterMode()
                WasInCruise = false -- And override the thing that would reset it, in this case
            end
        end
        if AutopilotTargetName ~= "None" then
            if panelInterplanetary == nil then
                SetupInterplanetaryPanel()
            end
            if AutopilotTargetName ~= nil then
                local customLocation = CustomTarget ~= nil
                planetMaxMass = GetAutopilotMaxMass()
                system.updateData(interplanetaryHeaderText,
                    '{"label": "Target", "value": "' .. AutopilotTargetName .. '", "unit":""}')
                travelTime = GetAutopilotTravelTime() -- This also sets AutopilotDistance so we don't have to calc it again
                if customLocation and not Autopilot then -- If in autopilot, keep this displaying properly
                    distance = (vec3(core.getConstructWorldPos()) - CustomTarget.position):len()
                else
                    distance = (AutopilotTargetCoords - vec3(core.getConstructWorldPos())):len() -- Don't show our weird variations
                end
                if not TurnBurn then
                    brakeDistance, brakeTime = GetAutopilotBrakeDistanceAndTime(velMag)
                    maxBrakeDistance, maxBrakeTime = GetAutopilotBrakeDistanceAndTime(MaxGameVelocity)
                else
                    brakeDistance, brakeTime = GetAutopilotTBBrakeDistanceAndTime(velMag)
                    maxBrakeDistance, maxBrakeTime = GetAutopilotTBBrakeDistanceAndTime(MaxGameVelocity)
                end
                local displayText, displayUnit = getDistanceDisplayString(distance)
                system.updateData(widgetDistanceText, '{"label": "distance", "value": "' .. displayText
                     .. '", "unit":"' .. displayUnit .. '"}')
                system.updateData(widgetTravelTimeText, '{"label": "Travel Time", "value": "' ..
                    FormatTimeString(travelTime) .. '", "unit":""}')
                displayText, displayUnit = getDistanceDisplayString(brakeDistance)
                system.updateData(widgetCurBrakeDistanceText, '{"label": "Cur Brake distance", "value": "' ..
                    displayText.. '", "unit":"' .. displayUnit .. '"}')
                system.updateData(widgetCurBrakeTimeText, '{"label": "Cur Brake Time", "value": "' ..
                    FormatTimeString(brakeTime) .. '", "unit":""}')
                displayText, displayUnit = getDistanceDisplayString(maxBrakeDistance)
                system.updateData(widgetMaxBrakeDistanceText, '{"label": "Max Brake distance", "value": "' ..
                    displayText.. '", "unit":"' .. displayUnit .. '"}')
                system.updateData(widgetMaxBrakeTimeText, '{"label": "Max Brake Time", "value": "' ..
                    FormatTimeString(maxBrakeTime) .. '", "unit":""}')
                system.updateData(widgetMaxMassText, '{"label": "Maximum Mass", "value": "' ..
                    stringf("%.2f", (planetMaxMass / 1000)) .. '", "unit":" Tons"}')
                displayText, displayUnit = getDistanceDisplayString(AutopilotTargetOrbit)
                system.updateData(widgetTargetOrbitText, '{"label": "Target Orbit", "value": "' ..
                stringf("%.2f", displayText) .. '", "unit":"' .. displayUnit .. '"}')
                if atmosphere() > 0 and not WasInAtmo then
                    system.removeDataFromWidget(widgetMaxBrakeTimeText, widgetMaxBrakeTime)
                    system.removeDataFromWidget(widgetMaxBrakeDistanceText, widgetMaxBrakeDistance)
                    system.removeDataFromWidget(widgetCurBrakeTimeText, widgetCurBrakeTime)
                    system.removeDataFromWidget(widgetCurBrakeDistanceText, widgetCurBrakeDistance)
                    system.removeDataFromWidget(widgetTrajectoryAltitudeText, widgetTrajectoryAltitude)
                    WasInAtmo = true
                end
                if atmosphere() == 0 and WasInAtmo then
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
                    --if Nav.axisCommandManager:getAxisCommandType(0) == axisCommandType.byThrottle then
                        -- Put PlayerThrottle into the real throttle as we exit so no discrepancies
                    --    Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, PlayerThrottle)
                    --end
                    WasInAtmo = false
                end
            end
        else
            HideInterplanetaryPanel()
        end
        if warpdrive ~= nil then
            if jdecode(warpdrive.getData()).destination ~= "Unknown" and jdecode(warpdrive.getData()).distance > 400000 then
                warpdrive.show()
                showWarpWidget = true
            else
                warpdrive.hide()
                showWarpWidget = false
            end
        end        
    elseif timerId == "oneSecond" then
        -- Timer for evaluation every 1 second
        clearAllCheck = false
        RefreshLastMaxBrake(nil, true) -- force refresh, in case we took damage
        updateDistance()
        updateRadar()
        updateWeapons()
        -- Update odometer output string
        local newContent = {}
        local flightStyle = GetFlightStyle()
        DrawOdometer(newContent, totalDistanceTrip, TotalDistanceTravelled, flightStyle, flightTime)
        if ShouldCheckDamage then
            CheckDamage(newContent)
        end
        lastOdometerOutput = table.concat(newContent, "")
        collectgarbage("collect")
    elseif timerId == "fiveSecond" then
        -- Support for SatNav by Trog
        myAutopilotTarget = dbHud_1.getStringValue("SPBAutopilotTargetName")
        if myAutopilotTarget ~= nil and myAutopilotTarget ~= "" and myAutopilotTarget ~= "SatNavNotChanged" then
            local result = json.decode(dbHud_1.getStringValue("SavedLocations"))
            if result ~= nil then
                _G["SavedLocations"] = result        
                local index = -1        
                local newLocation        
                for k, v in pairs(SavedLocations) do        
                    if v.name and v.name == "SatNav Location" then                   
                        index = k                
                        break                
                    end            
                end        
                if index ~= -1 then       
                    newLocation = SavedLocations[index]            
                    index = -1            
                    for k, v in pairs(atlas[0]) do           
                        if v.name and v.name == "SatNav Location" then               
                            index = k                    
                            break                  
                        end                
                    end            
                    if index > -1 then           
                        atlas[0][index] = newLocation                
                    end            
                    UpdateAtlasLocationsList()           
                    msgText = newLocation.name .. " position updated"            
                end       
            end

            for i=1,#AtlasOrdered do    
                if AtlasOrdered[i].name == myAutopilotTarget then
                    AutopilotTargetIndex = i
                    system.print("Index = "..AutopilotTargetIndex.." "..AtlasOrdered[i].name)          
                    UpdateAutopilotTarget()
                    dbHud_1.setStringValue("SPBAutopilotTargetName", "SatNavNotChanged")
                    break            
                end     
            end
        end
    elseif timerId == "msgTick" then
        -- This is used to clear a message on screen after a short period of time and then stop itself
        local newContent = {}
        DisplayMessage(newContent, "empty")
        msgText = "empty"
        unit.stopTimer("msgTick")
        msgTimer = 3
    elseif timerId == "animateTick" then
        Animated = true
        Animating = false
        simulatedX = 0
        simulatedY = 0
        unit.stopTimer("animateTick")
    elseif timerId == "hudTick" then

        local newContent = {}
        
        HUDPrologue(newContent)

        if showHud then
            UpdateHud(newContent) -- sets up Content for us
        else
            DisplayOrbitScreen(newContent)
            DrawWarnings(newContent)
        end

        HUDEpilogue(newContent)

        newContent[#newContent + 1] = stringf(
            [[<svg width="100%%" height="100%%" style="position:absolute;top:0;left:0"  viewBox="0 0 %d %d">]],
            ResolutionX, ResolutionY)   
        if msgText ~= "empty" then
            DisplayMessage(newContent, msgText)
        end
        if isRemote() == 0 and userControlScheme == "virtual joystick" then
            if DisplayDeadZone then DrawDeadZone(newContent) end
        end

        if isRemote() == 1 and screen_1 and screen_1.getMouseY() ~= -1 then
            SetButtonContains()
            DrawButtons(newContent)
            if screen_1.getMouseState() == 1 then
                CheckButtons()
            end
            newContent[#newContent + 1] = stringf(
                                              [[<g transform="translate(%d %d)"><circle class="cursor" cx="%fpx" cy="%fpx" r="5"/></g>]],
                                              halfResolutionX, halfResolutionY, simulatedX, simulatedY)
        elseif system.isViewLocked() == 0 then
            if isRemote() == 1 and holdingCtrl then
                SetButtonContains()
                DrawButtons(newContent)

                -- If they're remote, it's kinda weird to be 'looking' everywhere while you use the mouse
                -- We need to add a body with a background color
                if not Animating and not Animated then
                    local collapsedContent = table.concat(newContent, "")
                    newContent = {}
                    newContent[#newContent + 1] = stringf("<style>@keyframes test { from { opacity: 0; } to { opacity: 1; } }  body { animation-name: test; animation-duration: 0.5s; }</style><body><svg width='100%%' height='100%%' position='absolute' top='0' left='0'><rect width='100%%' height='100%%' x='0' y='0' position='absolute' style='fill:rgb(6,5,26);'/></svg><svg width='50%%' height='50%%' style='position:absolute;top:30%%;left:25%%' viewbox='0 0 %d %d'>", ResolutionX, ResolutionY)
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
                    newContent[#newContent + 1] = stringf("<body style='background-color:rgb(6,5,26)'><svg width='50%%' height='50%%' style='position:absolute;top:30%%;left:25%%' viewbox='0 0 %d %d'>", ResolutionX, ResolutionY)
                    newContent[#newContent + 1] = GalaxyMapHTML
                    newContent[#newContent + 1] = collapsedContent
                    newContent[#newContent + 1] = "</body>"
                end

                if not Animating then
                    newContent[#newContent + 1] = stringf(
                                                      [[<g transform="translate(%d %d)"><circle class="cursor" cx="%fpx" cy="%fpx" r="5"/></g>]],
                                                      halfResolutionX, halfResolutionY, simulatedX, simulatedY)
                end
            else
                CheckButtons()
            end
        else
            if not holdingCtrl and isRemote() == 0 then -- Draw deadzone circle if it's navigating
                CheckButtons()

                if distance > DeadZone then -- Draw a line to the cursor from the screen center
                    -- Note that because SVG lines fucking suck, we have to do a translate and they can't use calc in their params
                    if DisplayDeadZone then DrawCursorLine(newContent) end
                end
            else
                SetButtonContains()
                DrawButtons(newContent)

            end
            -- Cursor always on top, draw it last
            newContent[#newContent + 1] = stringf(
                                              [[<g transform="translate(%d %d)"><circle class="cursor" cx="%fpx" cy="%fpx" r="5"/></g>]],
                                              halfResolutionX, halfResolutionY, simulatedX, simulatedY)
        end
        newContent[#newContent + 1] = [[</svg></body>]]
        content = table.concat(newContent, "")
        if not DidLogOutput then
            system.logInfo(LastContent)
            DidLogOutput = true
        end        
    elseif timerId == "apTick" then
        -- Localized Functions
        inAtmo = (atmosphere() > 0)

        local time = system.getTime()
        local deltaTick = time - lastApTickTime
        lastApTickTime = time

        local constrF = vec3(core.getConstructWorldOrientationForward())
        local constrR = vec3(core.getConstructWorldOrientationRight())
        local constrUp = vec3(core.getConstructWorldOrientationUp())
        local worldV = vec3(core.getWorldVertical())

        local worldPos = vec3(core.getConstructWorldPos())
        --local localVel = core.getVelocity()
        --local currentYaw = getRelativeYaw(localVel)
        --local currentPitch = getRelativePitch(localVel)
        local roll = getRoll(worldV, constrF, constrR)
        local radianRoll = (roll / 180) * math.pi
        local corrX = math.cos(radianRoll)
        local corrY = math.sin(radianRoll)
        local pitch = getPitch(worldV, constrF, constrR) -- Left in for compat, but we should really use adjustedPitch
        local adjustedPitch = getPitch(worldV, constrF, (constrR * corrX) + (constrUp * corrY)) 

        local currentYaw = -math.deg(signedRotationAngle(constrUp, velocity, constrF))
        local currentPitch = math.deg(signedRotationAngle(constrR, velocity, constrF)) -- Let's use a consistent func that uses global velocity

        stalling = inAtmo and currentYaw < -YawStallAngle or currentYaw > YawStallAngle or currentPitch < -PitchStallAngle or currentPitch > PitchStallAngle

        deltaX = system.getMouseDeltaX()
        deltaY = system.getMouseDeltaY()
        if InvertMouse and not holdingCtrl then deltaY = -deltaY end
        yawInput2 = 0
        rollInput2 = 0
        pitchInput2 = 0
        velocity = vec3(core.getWorldVelocity())
        velMag = vec3(velocity):len()
        sys = galaxyReference[0]
        planet = sys:closestBody(core.getConstructWorldPos())
        --if planet.name == "Space" then planet = atlas[0][2] end -- Assign to Alioth since otherwise Space gets returned if at Alioth.
        kepPlanet = Kep(planet)
        orbit = kepPlanet:orbitalParameters(core.getConstructWorldPos(), velocity)
        hovGndDet = hoverDetectGround() 
        local gravity = planet:getGravity(core.getConstructWorldPos()):len() * constructMass()
        targetRoll = 0
        maxKinematicUp = core.getMaxKinematicsParametersAlongAxis("ground", core.getConstructOrientationUp())[1]

        pvpZone, pvpDist, pvpName, _ = safeZone(worldPos)

        if isRemote() == 1 and screen_1 and screen_1.getMouseY() ~= -1 then
            simulatedX = screen_1.getMouseX() * ResolutionX
            simulatedY = screen_1.getMouseY() * ResolutionY
        elseif system.isViewLocked() == 0 then
            if isRemote() == 1 and holdingCtrl then
                if not Animating then
                    simulatedX = simulatedX + deltaX
                    simulatedY = simulatedY + deltaY
                end
            else
                simulatedX = 0
                simulatedY = 0 -- Reset after they do view things, and don't keep sending inputs while unlocked view
                -- Except of course autopilot, which is later.
            end
        else
            simulatedX = simulatedX + deltaX
            simulatedY = simulatedY + deltaY
            distance = math.sqrt(simulatedX * simulatedX + simulatedY * simulatedY)
            if not holdingCtrl and isRemote() == 0 then -- Draw deadzone circle if it's navigating
                if userControlScheme == "virtual joystick" then -- Virtual Joystick
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
                elseif userControlScheme == "mouse" then -- Mouse Direct
                    simulatedX = 0
                    simulatedY = 0
                    -- pitchInput2 = pitchInput2 - deltaY * MousePitchFactor
                    -- yawInput2 = yawInput2 - deltaX * MouseYawFactor
                    -- So... this is weird.  
                    -- It's doing some odd things and giving us some weird values. 

                    -- utils.smoothstep(progress, low, high)*2-1
                    pitchInput2 = (-utils.smoothstep(deltaY, -100, 100) + 0.5) * 2 * MousePitchFactor
                    yawInput2 = (-utils.smoothstep(deltaX, -100, 100) + 0.5) * 2 * MouseYawFactor
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
            end
        end

        local isWarping = (velMag > 8334)
        if velMag > SpaceSpeedLimit/3.6 and not inAtmo and not Autopilot and not isWarping then
            msgText = "Space Speed Engine Shutoff reached"
            if Nav.axisCommandManager:getAxisCommandType(0) == 1 then
                Nav.control.cancelCurrentControlMasterMode()
            end
            Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0)
            PlayerThrottle = 0
        end
        if not isWarping and LastIsWarping then
            if not BrakeIsOn then
                BrakeToggle()
            end
            if Autopilot then
                ToggleAutopilot()
            end
        end
        LastIsWarping = isWarping
        if inAtmo and atmosphere() > 0.09 then
            if velMag > (adjustedAtmoSpeedLimit / 3.6) and not AtmoSpeedAssist and not speedLimitBreaking then
                    BrakeIsOn = true
                    speedLimitBreaking  = true
            elseif not AtmoSpeedAssist and speedLimitBreaking then
                if velMag < (adjustedAtmoSpeedLimit / 3.6) then
                    BrakeIsOn = false
                    speedLimitBreaking = false
                end
            end    
        end
        if BrakeIsOn then
            brakeInput = 1
        else
            brakeInput = 0
        end
        coreAltitude = core.getAltitude()
        if coreAltitude == 0 then
            coreAltitude = (vec3(core.getConstructWorldPos()) - planet.center):len() - planet.radius
        end

        if ProgradeIsOn then
            if spaceLand then 
                BrakeIsOn = false -- wtf how does this keep turning on, and why does it matter if we're in cruise?
                local aligned = false
                if CustomTarget ~= nil then
                    aligned = AlignToWorldVector(CustomTarget.position-worldPos,0.01) 
                else
                    aligned = AlignToWorldVector(vec3(velocity),0.01) 
                end
                autoRoll = true
                if aligned and (math.abs(roll) < 2 or math.abs(adjustedPitch) > 85) and velMag >= adjustedAtmoSpeedLimit/3.6-1 then
                        -- Try to force it to get full speed toward target, so it goes straight to throttle and all is well
                        BrakeIsOn = false
                        ProgradeIsOn = false
                        reentryMode = true
                        spaceLand = false
                        finalLand = true
                        Autopilot = false
                        --autoRoll = autoRollPreference   
                        BeginReentry()
                elseif inAtmo and AtmoSpeedAssist then 
                    cmdThrottle(1) -- Just let them full throttle if they're in atmo
                else
                    cmdCruise(math.floor(adjustedAtmoSpeedLimit)) -- Trouble drawing if it's not an int
                    PlayerThrottle = 0 -- IDK why we do this? 
                end
            elseif velMag > minAutopilotSpeed then
                AlignToWorldVector(vec3(velocity),0.01) 
            end
        end
        if RetrogradeIsOn then
            if inAtmo then 
                RetrogradeIsOn = false
            elseif velMag > minAutopilotSpeed then -- Help with div by 0 errors and careening into terrain at low speed
                AlignToWorldVector(-(vec3(velocity)))
            end
        end
        if not ProgradeIsOn and spaceLand then 
            if atmosphere() == 0 then 
                reentryMode = true
                BeginReentry()
                spaceLand = false
                finalLand = true
            else
                spaceLand = false
                ToggleAutopilot()
            end
        end
        local up = vec3(core.getWorldVertical()) * -1
        local vSpd = (velocity.x * up.x) + (velocity.y * up.y) + (velocity.z * up.z)
        if finalLand and CustomTarget ~= nil and (coreAltitude < (HoldAltitude + 200) and coreAltitude > (HoldAltitude - 200)) and ((velMag*3.6) > (adjustedAtmoSpeedLimit-100)) and math.abs(vSpd) < 20 and atmosphere() >= 0.1
            and (CustomTarget.position-worldPos):len() > 2000 + coreAltitude then -- Only engage if far enough away to be able to turn back for it
            ToggleAutopilot()
            finalLand = false
        end

        if VertTakeOff then
            autoRoll = true
            if vSpd < -30 then -- saftey net
                msgText = "Unable to achieve lift. Safety Landing."
                upAmount = 0
                autoRoll = autoRollPreference
                VertTakeOff = false
                BrakeLanding = true
            elseif antigrav and not ExternalAGG and antigrav.getState() == 1 then
                if coreAltitude < (antigrav.getBaseAltitude() - 100) then
                    VtPitch = 0
                    upAmount = 15
                    BrakeIsOn = false
                elseif vSpd > 0 then
                    BrakeIsOn = true
                    upAmount = 0
                elseif vSpd < -30 then
                    BrakeIsOn = true
                    upAmount = 15
                elseif coreAltitude >= antigrav.getBaseAltitude() then
                    BrakeIsOn = true
                    upAmount = 0
                    VertTakeOff = false
                    msgText = "Takeoff complete. Singularity engaged"
                end
            else
                if atmosphere() > 0.08 then
                    VtPitch = 0
                    BrakeIsOn = false
                    upAmount = 20
                elseif atmosphere() < 0.08 and atmosphere() > 0 then
                    BrakeIsOn = false
                    if SpaceEngineVertDn then
                        VtPitch = 0
                        upAmount = 20
                    else
                        upAmount = 0
                        VtPitch = 36
                        cmdCruise(3500)
                    end
                else
                    autoRoll = autoRollPreference
                    IntoOrbit = true
                    OrbitAchieved = false
                    CancelIntoOrbit = false
                    orbitAligned = false
                    orbitPitch = nil
                    orbitRoll = nil
                    if OrbitTargetPlanet == nil then
                        OrbitTargetPlanet = planet
                    end
                    VertTakeOff = false
                end
            end
            if VtPitch ~= nil then
                if (vTpitchPID == nil) then
                    vTpitchPID = pid.new(2 * 0.01, 0, 2 * 0.1)
                end
                local vTpitchDiff = utils.clamp(VtPitch-adjustedPitch, -PitchStallAngle*0.85, PitchStallAngle*0.85)
                vTpitchPID:inject(vTpitchDiff)
                local vTPitchInput = utils.clamp(vTpitchPID:get(),-1,1)
                pitchInput2 = vTPitchInput
            end
        end

        if IntoOrbit then
            if OrbitTargetPlanet == nil then
                if VectorToTarget then
                    OrbitTargetPlanet = autopilotTargetPlanet
                    
                else
                    OrbitTargetPlanet = planet
                end
            end
            if not OrbitTargetSet then
                if OrbitTargetPlanet.hasAtmosphere then
                    OrbitTargetOrbit = math.floor(OrbitTargetPlanet.radius + OrbitTargetPlanet.noAtmosphericDensityAltitude + 1000)
                else
                    OrbitTargetOrbit = math.floor(OrbitTargetPlanet.radius + OrbitTargetPlanet.surfaceMaxAltitude + 1000)
                end
                OrbitTargetSet = true
            end     
            local targetVec
            local yawAligned = false
            local heightstring, heightunit = getDistanceDisplayString(OrbitTargetOrbit)
            local orbitHeightString = heightstring .. heightunit
            if orbitalParams.VectorToTarget then
                targetVec = CustomTarget.position - worldPos
            end
            local escapeVel, endSpeed = Kep(OrbitTargetPlanet):escapeAndOrbitalSpeed((vec3(core.getConstructWorldPos())-OrbitTargetPlanet.center):len()-OrbitTargetPlanet.radius)
            local orbitalRoll = roll
            -- Getting as close to orbit distance as comfortably possible
            if not orbitAligned then
                cmdThrottle(0)
                orbitRoll = 0
                orbitMsg = "Aligning to orbital path - OrbitHeight: "..orbitHeightString
                local pitchAligned = false
                local rollAligned = false
                if orbitalParams.VectorToTarget then
                    AlignToWorldVector(targetVec:normalize():project_on_plane(worldV)) -- Returns a value that wants both pitch and yaw to align, which we don't do
                    yawAligned = constrF:dot(targetVec:project_on_plane(constrUp):normalize()) > 0.95
                else
                    AlignToWorldVector(velocity)
                    yawAligned = currentYaw < 0.5
                    if velMag < 150 then yawAligned = true end -- Low velocities can never truly align yaw
                end
                pitchInput2 = 0
                orbitPitch = 0
                if adjustedPitch <= orbitPitch+1 and adjustedPitch >= orbitPitch-1 then
                    pitchAligned = true
                else
                    pitchAligned = false
                end
                if orbitalRoll <= orbitRoll+1 and orbitalRoll >= orbitRoll-1 then
                    rollAligned = true
                else
                    rollAligned = false
                end
                if pitchAligned and rollAligned and yawAligned then
                    orbitPitch = nil
                    orbitRoll = nil
                    orbitAligned = true
                end
            else
                if orbitalParams.VectorToTarget then
                    AlignToWorldVector(targetVec:normalize():project_on_plane(worldV))
                elseif velMag > 150 then
                    AlignToWorldVector(velocity)
                end
                pitchInput2 = 0
                if orbitalParams.VectorToTarget then
                    -- Orbit to target...

                    local brakeDistance, _ =  Kinematic.computeDistanceAndTime(velMag, adjustedAtmoSpeedLimit/3.6, constructMass(), 0, 0, LastMaxBrake)
                    if OrbitAchieved and velocity:normalize():dot(targetVec:normalize()) > 0.5 and targetVec:len() > 15000+brakeDistance+coreAltitude then -- Triggers when we get close to passing it or within 12km+height I guess
                        orbitMsg = "Orbiting to Target"
                    elseif OrbitAchieved or targetVec:len() < 15000+brakeDistance+coreAltitude then
                        msgText = "Orbit complete, proceeding with reentry"
                        -- We can skip prograde completely if we're approaching from an orbit?
                        --BrakeIsOn = false -- Leave brakes on to be safe while we align prograde
                        AutopilotTargetCoords = CustomTarget.position -- For setting the waypoint
                        reentryMode = true
                        finalLand = true
                        orbitalParams.VectorToTarget, orbitalParams.AutopilotAlign = false, false -- Let it disable orbit
                        ToggleIntoOrbit()
                        BeginReentry()
                    end
                end
                if orbit.periapsis ~= nil and orbit.apoapsis ~= nil and orbit.eccentricity < 1 and coreAltitude > OrbitTargetOrbit*0.9 and coreAltitude < OrbitTargetOrbit*1.4 then
                    if orbit.apoapsis ~= nil then
                        if (orbit.periapsis.altitude >= OrbitTargetOrbit*0.99 and orbit.apoapsis.altitude >= OrbitTargetOrbit*0.99 and 
                            orbit.periapsis.altitude < orbit.apoapsis.altitude and orbit.periapsis.altitude*1.05 >= orbit.apoapsis.altitude) or OrbitAchieved then -- This should get us a stable orbit within 10% with the way we do it
                            if OrbitAchieved then
                                BrakeIsOn = false
                                PlayerThrottle = 0
                                cmdThrottle(0)
                                OrbitAchieved = true
                                orbitPitch = 0
                                
                                if not orbitalParams.VectorToTarget then
                                    ToggleIntoOrbit()
                                end
                            end
                            if not orbitalParams.VectorToTarget then
                                orbitMsg = nil
                                orbitalRecover = false
                                OrbitTargetSet = false
                                OrbitTargetPlanet = nil
                                autoRoll = autoRollPreference
                                if not finalLand then
                                    msgText = "Orbit established"
                                end
                                orbitalParams.VectorToTarget = false
                                CancelIntoOrbit = false
                                IntoOrbit = false
                                orbitAligned = false
                                orbitPitch = nil
                                orbitRoll = nil
                                OrbitTargetPlanet = nil
                                OrbitAchieved = false
                                OrbitTicks = 0
                            end
                        else
                            orbitMsg = "Adjusting Orbit - OrbitHeight: "..orbitHeightString
                            orbitalRecover = true
                            -- Just set cruise to endspeed...
                            cmdCruise(endSpeed*3.6+1)
                            -- And set pitch to something that scales with vSpd
                            -- Well, a pid is made for this stuff
                            if (VSpdPID == nil) then
                                VSpdPID = pid.new(0.5, 0, 10 * 0.1) -- Has to stay low at base to avoid overshoot
                            end
                            local speedToInject = vSpd
                            local altdiff = coreAltitude - OrbitTargetOrbit
                            local absAltdiff = math.abs(altdiff)
                            if vSpd < 10 and math.abs(adjustedPitch) < 10 and absAltdiff < 100 then
                                speedToInject = vSpd*2 -- Force it to converge when it's close
                            end
                            if speedToInject < 10 and math.abs(adjustedPitch) < 10 and absAltdiff < 100 then -- And do it again when it's even closer
                                speedToInject = speedToInject*2
                            end
                            -- I really hate this, but, it really needs it still/again... 
                            if speedToInject < 5 and math.abs(adjustedPitch) < 5 and absAltdiff < 100 then -- And do it again when it's even closer
                                speedToInject = speedToInject*4
                            end
                            -- TBH these might not be super necessary anymore after changes, might can remove at least one, but two tends to make everything smoother
                            VSpdPID:inject(speedToInject)
                            orbitPitch = utils.clamp(-VSpdPID:get(),-90,90)
                            -- Also, add pitch to try to adjust us to our correct altitude
                            -- Dammit, that's another PID I guess... I don't want another PID... 
                            if (OrbitAltPID == nil) then
                                OrbitAltPID = pid.new(0.15, 0, 5 * 0.1)
                            end
                            OrbitAltPID:inject(altdiff) -- We clamp this to max 15 degrees so it doesn't screw us too hard
                            -- And this will fight with the other PID to keep vspd reasonable
                            orbitPitch = utils.clamp(orbitPitch - utils.clamp(OrbitAltPID:get(),-15,15),-90,90)
                        end
                        
                    else
                        orbitMsg = "Adjusting Orbit - OrbitHeight: "..OrbitTargetOrbit.."m"
                        orbitalRecover = true
                        -- Just set cruise to endspeed...
                        cmdCruise(endSpeed*3.6+1)
                        -- And set pitch to something that scales with vSpd
                        -- Well, a pid is made for this stuff
                        if (VSpdPID == nil) then
                            VSpdPID = pid.new(0.5, 0, 10 * 0.1) -- Has to stay low at base to avoid overshoot
                        end
                        local speedToInject = vSpd
                        local altdiff = coreAltitude - OrbitTargetOrbit
                        local absAltdiff = math.abs(altdiff)
                        if vSpd < 10 and math.abs(adjustedPitch) < 10 and absAltdiff < 100 then
                            speedToInject = vSpd*2 -- Force it to converge when it's close
                        end
                        if speedToInject < 10 and math.abs(adjustedPitch) < 10 and absAltdiff < 100 then -- And do it again when it's even closer
                            speedToInject = speedToInject*2
                        end
                        -- I really hate this, but, it really needs it still/again... 
                        if speedToInject < 5 and math.abs(adjustedPitch) < 5 and absAltdiff < 100 then -- And do it again when it's even closer
                            speedToInject = speedToInject*4
                        end
                        -- TBH these might not be super necessary anymore after changes, might can remove at least one, but two tends to make everything smoother
                        VSpdPID:inject(speedToInject)
                        orbitPitch = utils.clamp(-VSpdPID:get(),-90,90)
                        -- Also, add pitch to try to adjust us to our correct altitude
                        -- Dammit, that's another PID I guess... I don't want another PID... 
                        if (OrbitAltPID == nil) then
                            OrbitAltPID = pid.new(0.1, 0, 5 * 0.1)
                        end
                        OrbitAltPID:inject(altdiff) -- We clamp this to max 15 degrees so it doesn't screw us too hard
                        -- And this will fight with the other PID to keep vspd reasonable
                        orbitPitch = utils.clamp(orbitPitch - utils.clamp(OrbitAltPID:get(),-15,15),-90,90)
                    end
                end
            else
                local orbitalMultiplier = 2.75
                local pcs = math.abs(utils.round(escapeVel*orbitalMultiplier))
                local mod = pcs%50
                if mod > 0 then pcs = (pcs - mod) + 50 end
                BrakeIsOn = false
                if not orbitAligned then
                    local pitchAligned = false
                    local rollAligned = false
                    if coreAltitude < OrbitTargetOrbit then
                        orbitMsg = "Aligning to orbital path - OrbitHeight: "..OrbitTargetOrbit.."m"
                    else
                        -- TODO: Target a point in space at the proper distance and point there.
                        orbitMsg = "Aligning to orbital point - OrbitHeight: "..OrbitTargetOrbit.."m"
                    end
                    orbitPitch = 0
                    orbitRoll = 0
                    if adjustedPitch <= orbitPitch+1 and adjustedPitch >= orbitPitch-1 then
                        pitchAligned = true
                    else
                        pitchAligned = false
                    end
                    if orbitalRoll <= orbitRoll+1 and orbitalRoll >= orbitRoll-1 then
                        rollAligned = true
                    else
                        rollAligned = false
                    end
                    if pitchAligned and rollAligned then
                        orbitPitch = nil
                        orbitRoll = nil
                        orbitAligned = true
                    end
                else
                    local orbitalMultiplier = 2.75
                    local pcs = math.abs(utils.round(escapeVel*orbitalMultiplier))
                    local mod = pcs%50
                    if mod > 0 then pcs = (pcs - mod) + 50 end
                    BrakeIsOn = false
                    if coreAltitude < OrbitTargetOrbit*0.8 then
                        orbitMsg = "Escaping planet gravity - OrbitHeight: "..orbitHeightString
                        orbitPitch = utils.map(vSpd, 200, 0, -15, 80)
                    elseif coreAltitude >= OrbitTargetOrbit*0.8 and coreAltitude < OrbitTargetOrbit*1.15 then
                        orbitMsg = "Approaching orbital corridor - OrbitHeight: "..orbitHeightString
                        pcs = pcs*0.75
                        -- if vSpd > 100 then
                        --     orbitPitch = -30
                        -- else
                        --     orbitPitch = utils.map(coreAltitude, OrbitTargetOrbit*0.6, OrbitTargetOrbit, 45, 10)
                        -- end
                        orbitPitch = utils.map(vSpd, 100, -100, -15, 65)
                    elseif coreAltitude >= OrbitTargetOrbit*1.15 and coreAltitude < OrbitTargetOrbit*1.5 then
                        orbitMsg = "Approaching orbital corridor - OrbitHeight: "..orbitHeightString
                        pcs = pcs*0.75
                        if vSpd < 0 or orbitalRecover then
                            orbitPitch = utils.map(coreAltitude, OrbitTargetOrbit*1.5, OrbitTargetOrbit*1.01, -30, 0) -- Going down? pitch up.
                        else
                            orbitPitch = utils.map(coreAltitude, OrbitTargetOrbit*0.99, OrbitTargetOrbit*1.5, 0, 30) -- Going up? pitch down.
                        end
                    elseif coreAltitude > OrbitTargetOrbit*1.5 then
                        orbitMsg = "Reentering orbital corridor - OrbitHeight: "..orbitHeightString
                        orbitPitch = -85 --utils.map(vSpd, 25, -200, -65, -30)
                        local pcsAdjust = utils.map(vSpd, -150, -400, 1, 0.55)
                        pcs = pcs*pcsAdjust
                    end
                end
                cmdCruise(math.floor(pcs))
            end
            if orbitPitch ~= nil then
                if (OrbitPitchPID == nil) then
                    OrbitPitchPID = pid.new(2 * 0.01, 0, 2 * 0.1)
                end
                local orbitPitchDiff = orbitPitch - adjustedPitch
                OrbitPitchPID:inject(orbitPitchDiff)
                local orbitPitchInput = utils.clamp(OrbitPitchPID:get(),-0.5,0.5)
                pitchInput2 = orbitPitchInput
            end
            if orbitRoll ~= nil then
                if adjustedPitch < 85 then
                    local rollFactor = math.max(autoRollFactor, 0.01)/4
                    if (OrbitRollPID == nil) then
                        OrbitRollPID = pid.new(rollFactor * 0.01, 0, rollFactor * 0.1)
                    end
                    local orbitalRollDiff = orbitRoll - orbitalRoll
                    OrbitRollPID:inject(orbitalRollDiff)
                    local orbitRollInput = utils.clamp(OrbitRollPID:get(),-0.5,0.5)
                    rollInput2 = orbitRollInput
                end
            end
        elseif CancelIntoOrbit then
            OrbitTargetSet = false
            OrbitTargetPlanet = nil
            cmdThrottle(0)
            CancelIntoOrbit = false
        end

        if Autopilot and atmosphere() == 0 and not spaceLand then
            -- Planetary autopilot engaged, we are out of atmo, and it has a target
            -- Do it.  
            -- And tbh we should calc the brakeDistance live too, and of course it's also in meters
            
            -- Maybe instead of pointing at our vector, we point at our vector + how far off our velocity vector is
            -- This is gonna be hard to get the negatives right.
            -- If we're still in orbit, don't do anything, that velocity will suck
            local targetCoords, skipAlign = AutopilotTargetCoords, false
            -- This isn't right.  Maybe, just take the smallest distance vector between the normal one, and the wrongSide calculated one
            --local wrongSide = (CustomTarget.position-worldPos):len() > (autopilotTargetPlanet.center-worldPos):len()
            if CustomTarget ~= nil and CustomTarget.planetname ~= "Space" then
                AutopilotRealigned = true -- Don't realign, point straight at the target.  Or rather, at AutopilotTargetOrbit above it
                if not TargetSet then
                    -- It's on the wrong side of the planet. 
                    -- So, get the 3d direction between our target and planet center.  Note that, this is basically a vector defining gravity at our target, too...
                    local initialDirection = (CustomTarget.position - autopilotTargetPlanet.center):normalize() -- Should be pointing up
                    local finalDirection = initialDirection:project_on_plane((autopilotTargetPlanet.center-worldPos):normalize()):normalize()
                    -- And... actually that's all that I need.  If forward is really gone, this should give us a point on the edge of the planet
                    local wrongSideCoords = autopilotTargetPlanet.center + finalDirection*(autopilotTargetPlanet.radius + AutopilotTargetOrbit)
                    -- This used to be calculated based on our direction instead of gravity, which helped us approach not directly overtop it
                    -- But that caused bad things to happen for nearside/farside detection sometimes
                    local rightSideCoords = CustomTarget.position + (CustomTarget.position - autopilotTargetPlanet.center):normalize() * (AutopilotTargetOrbit - autopilotTargetPlanet:getAltitude(CustomTarget.position))
                    --system.print("WrongSide is " .. (worldPos-wrongSideCoords):len() .. ", rightSide is " .. (worldPos-rightSideCoords):len())
                    if (worldPos-wrongSideCoords):len() < (worldPos-rightSideCoords):len() then
                        --system.print("Taking WrongSide")
                        targetCoords = wrongSideCoords
                        AutopilotTargetCoords = targetCoords
                    else
                        targetCoords = CustomTarget.position + (CustomTarget.position - autopilotTargetPlanet.center):normalize() * (AutopilotTargetOrbit - autopilotTargetPlanet:getAltitude(CustomTarget.position))
                        AutopilotTargetCoords = targetCoords
                    end
                    local waypoint = zeroConvertToMapPosition(autopilotTargetPlanet, AutopilotTargetCoords)
                    waypoint = "::pos{"..waypoint.systemId..","..waypoint.bodyId..","..waypoint.latitude..","..waypoint.longitude..","..waypoint.altitude.."}"
                    system.setWaypoint(waypoint)
                    skipAlign = true
                    TargetSet = true -- Only set the targetCoords once.  Don't let them change as we fly.
                end
                --AutopilotPlanetGravity = autopilotTargetPlanet.gravity*9.8 -- Since we're aiming straight at it, we have to assume gravity?
                AutopilotPlanetGravity = 0
            elseif CustomTarget ~= nil and CustomTarget.planetname == "Space" then
                AutopilotPlanetGravity = 0
                skipAlign = true
                TargetSet = true
                AutopilotRealigned = true
                targetCoords = CustomTarget.position + (worldPos - CustomTarget.position)*AutopilotTargetOrbit
            elseif CustomTarget == nil then -- and not autopilotTargetPlanet.name == planet.name then
                AutopilotPlanetGravity = 0

                if not TargetSet then
                    -- Set the target to something on the radius in the direction closest to velocity
                    -- We have to fudge a high velocity because at standstill this can give us bad results
                    local initialDirection = ((worldPos+(velocity*100000)) - autopilotTargetPlanet.center):normalize() -- Should be pointing up
                    local finalDirection = initialDirection:project_on_plane((autopilotTargetPlanet.center-worldPos):normalize()):normalize()
                    --system.print("Setting target, finalDir " .. finalDirection:len())
                    if finalDirection:len() < 1 then
                        initialDirection = ((worldPos+(vec3(core.getConstructWorldOrientationForward())*100000)) - autopilotTargetPlanet.center):normalize()
                        finalDirection = initialDirection:project_on_plane((autopilotTargetPlanet.center-worldPos):normalize()):normalize() -- Align to nearest to ship forward then
                    end
                    -- And... actually that's all that I need.  If forward is really gone, this should give us a point on the edge of the planet
                    targetCoords = autopilotTargetPlanet.center + finalDirection*(autopilotTargetPlanet.radius + AutopilotTargetOrbit)
                    AutopilotTargetCoords = targetCoords
                    TargetSet = true
                    skipAlign = true
                    AutopilotRealigned = true
                    --AutopilotAccelerating = true
                    local waypoint = zeroConvertToMapPosition(autopilotTargetPlanet, AutopilotTargetCoords)
                    waypoint = "::pos{"..waypoint.systemId..","..waypoint.bodyId..","..waypoint.latitude..","..waypoint.longitude..","..waypoint.altitude.."}"
                    system.setWaypoint(waypoint)
                end
            end

            
            AutopilotDistance = (vec3(targetCoords) - vec3(core.getConstructWorldPos())):len()
            local intersectBody, farSide, nearSide = galaxyReference:getPlanetarySystem(0):castIntersections(worldPos, (velocity):normalize(), function(body) if body.noAtmosphericDensityAltitude > 0 then return (body.radius+body.noAtmosphericDensityAltitude) else return (body.radius+body.surfaceMaxAltitude*1.5) end end)
            local atmoDistance = farSide
            if nearSide ~= nil and farSide ~= nil then
                atmoDistance = math.min(nearSide,farSide)
            end
            if atmoDistance ~= nil and atmoDistance < AutopilotDistance and intersectBody.name == autopilotTargetPlanet.name then
                AutopilotDistance = atmoDistance -- If we're going to hit atmo before our target, use that distance instead.
                -- Can we put this on the HUD easily?
                --local value, units = getDistanceDisplayString(atmoDistance)
                --msgText = "Adjusting Brake Distance, will hit atmo in: " .. value .. units
            end

            
            -- We do this in tenthSecond already.
            --system.updateData(widgetDistanceText, '{"label": "distance", "value": "' ..
            --    displayText.. '", "unit":"' .. displayUnit .. '"}')
            local aligned = true -- It shouldn't be used if the following condition isn't met, but just in case

            local projectedAltitude = (autopilotTargetPlanet.center -
                                          (vec3(core.getConstructWorldPos()) +
                                              (vec3(velocity):normalize() * AutopilotDistance))):len() -
                                          autopilotTargetPlanet.radius
            local displayText, displayUnit = getDistanceDisplayString(projectedAltitude)
            system.updateData(widgetTrajectoryAltitudeText, '{"label": "Projected Altitude", "value": "' ..
                displayText.. '", "unit":"' .. displayUnit .. '"}')
            

            local brakeDistance, brakeTime
            
            if not TurnBurn then
                brakeDistance, brakeTime = GetAutopilotBrakeDistanceAndTime(velMag)
            else
                brakeDistance, brakeTime = GetAutopilotTBBrakeDistanceAndTime(velMag)
            end

            --orbit.apoapsis == nil and 
            if velMag > 300 and AutopilotAccelerating then
                -- Use signedRotationAngle to get the yaw and pitch angles with shipUp and shipRight as the normals, respectively
                -- Then use a PID
                local targetVec = (vec3(targetCoords) - vec3(core.getConstructWorldPos()))
                local targetYaw = utils.clamp(math.deg(signedRotationAngle(constrUp, velocity:normalize(), targetVec:normalize()))*(velMag/500),-90,90)
                local targetPitch = utils.clamp(math.deg(signedRotationAngle(constrR, velocity:normalize(), targetVec:normalize()))*(velMag/500),-90,90)

              
                -- If they're both very small, scale them both up a lot to converge that last bit
                if math.abs(targetYaw) < 20 and math.abs(targetPitch) < 20 then
                    targetYaw = targetYaw * 2
                    targetPitch = targetPitch * 2
                end
                -- If they're both very very small even after scaling them the first time, do it again
                if math.abs(targetYaw) < 2 and math.abs(targetPitch) < 2 then
                    targetYaw = targetYaw * 2
                    targetPitch = targetPitch * 2
                end

                -- We'll do our own currentYaw and Pitch
                local currentYaw = -math.deg(signedRotationAngle(constrUp, constrF, velocity:normalize()))
                local currentPitch = -math.deg(signedRotationAngle(constrR, constrF, velocity:normalize()))

                if (apPitchPID == nil) then
                    apPitchPID = pid.new(2 * 0.01, 0, 2 * 0.1) -- magic number tweaked to have a default factor in the 1-10 range
                end
                apPitchPID:inject(targetPitch - currentPitch)
                local autoPitchInput = utils.clamp(apPitchPID:get(),-1,1)

                pitchInput2 = pitchInput2 + autoPitchInput

                if (apYawPID == nil) then -- Changed from 2 to 8 to tighten it up around the target
                    apYawPID = pid.new(2 * 0.01, 0, 2 * 0.1) -- magic number tweaked to have a default factor in the 1-10 range
                end
                --yawPID:inject(yawDiff) -- Aim for 85% stall angle, not full
                apYawPID:inject(targetYaw - currentYaw)
                local autoYawInput = utils.clamp(apYawPID:get(),-1,1) -- Keep it reasonable so player can override
                yawInput2 = yawInput2 + autoYawInput
                

                skipAlign = true

                if math.abs(targetYaw) > 2 or math.abs(targetPitch) > 2 then
                    AutopilotStatus = "Adjusting Trajectory"
                else
                    AutopilotStatus = "Accelerating"
                end
                
            end

            if projectedAltitude < AutopilotTargetOrbit*1.5 then
                -- Recalc end speeds for the projectedAltitude since it's reasonable... 
                if CustomTarget ~= nil and CustomTarget.planetname == "Space" then 
                    AutopilotEndSpeed = 0
                elseif CustomTarget == nil then
                    _, AutopilotEndSpeed = Kep(autopilotTargetPlanet):escapeAndOrbitalSpeed(projectedAltitude)
                end
            end

            if not AutopilotCruising and not AutopilotBraking and not skipAlign then
                aligned = AlignToWorldVector((targetCoords - vec3(core.getConstructWorldPos())):normalize())
            elseif TurnBurn then
                aligned = AlignToWorldVector(-vec3(velocity):normalize())
            end
            if AutopilotAccelerating then
                --if vec3(core.getConstructWorldOrientationForward()):dot(velocity) < 0 and velMag > 300 then
                --    BrakeIsOn = true
                --    Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0)
                --    apThrottleSet = false
                --elseif not apThrottleSet then
                if not apThrottleSet then
                    BrakeIsOn = false
                    cmdThrottle(AutopilotInterplanetaryThrottle)
                    PlayerThrottle = round(AutopilotInterplanetaryThrottle,2)
                    apThrottleSet = true
                end
                local throttle = unit.getThrottle()
                if AtmoSpeedAssist then throttle = PlayerThrottle end
                if (vec3(core.getVelocity()):len() >= MaxGameVelocity or (throttle == 0 and apThrottleSet)) then
                    AutopilotAccelerating = false
                    AutopilotStatus = "Cruising"
                    AutopilotCruising = true
                    cmdThrottle(0)
                    PlayerThrottle = 0
                    --apThrottleSet = false -- We already did it, if they cancelled let them throttle up again
                end
                -- Check if accel needs to stop for braking
                --if brakeForceRequired >= LastMaxBrake then
                if AutopilotDistance <= brakeDistance then
                    AutopilotAccelerating = false
                    AutopilotStatus = "Braking"
                    AutopilotBraking = true
                    cmdThrottle(0)
                    PlayerThrottle = 0
                    apThrottleSet = false
                end
            elseif AutopilotBraking then
                if AutopilotStatus ~= "Orbiting to Target" then
                    BrakeIsOn = true
                    brakeInput = 1
                end
                if TurnBurn then
                    cmdThrottle(100,true) -- This stays 100 to not mess up our calculations
                    PlayerThrottle = 1
                end
                -- Check if an orbit has been established and cut brakes and disable autopilot if so

                -- We'll try <0.9 instead of <1 so that we don't end up in a barely-orbit where touching the controls will make it an escape orbit
                -- Though we could probably keep going until it starts getting more eccentric, so we'd maybe have a circular orbit
                local _, endSpeed = Kep(autopilotTargetPlanet):escapeAndOrbitalSpeed((vec3(core.getConstructWorldPos())-planet.center):len()-planet.radius)
                

                local targetVec--, targetAltitude, --horizontalDistance
                if CustomTarget ~= nil then
                    targetVec = CustomTarget.position - worldPos
                    --targetAltitude = planet:getAltitude(CustomTarget.position)
                    --horizontalDistance = math.sqrt(targetVec:len()^2-(coreAltitude-targetAltitude)^2)
                    --system.print(horizontalDistance .. "m, or " .. velocity:normalize():dot(targetVec:normalize()))
                end
                if (CustomTarget ~=nil and CustomTarget.planetname == "Space" and velMag < 50) then
                    msgText = "Autopilot complete, arrived at space location"
                    AutopilotBraking = false
                    Autopilot = false
                    TargetSet = false
                    AutopilotStatus = "Aligning" -- Disable autopilot and reset
                    -- We only aim for endSpeed even if going straight in, because it gives us a smoother transition to alignment
                elseif (CustomTarget ~= nil and CustomTarget.planetname ~= "Space") and velMag <= endSpeed and (orbit.apoapsis == nil or orbit.periapsis == nil or orbit.apoapsis.altitude <= 0 or orbit.periapsis.altitude <= 0) then
                    -- They aren't in orbit, that's a problem if we wanted to do anything other than reenter.  Reenter regardless.                  
                    msgText = "Autopilot complete, proceeding with reentry"
                    --BrakeIsOn = false -- Leave brakes on to be safe while we align prograde
                    AutopilotTargetCoords = CustomTarget.position -- For setting the waypoint
                    AutopilotBraking = false
                    Autopilot = false
                    TargetSet = false
                    AutopilotStatus = "Aligning" -- Disable autopilot and reset
                    --brakeInput = 0
                    cmdThrottle(0)
                    PlayerThrottle = 0
                    apThrottleSet = false
                    ProgradeIsOn = true
                    spaceLand = true
                    local waypoint = zeroConvertToMapPosition(autopilotTargetPlanet, AutopilotTargetCoords)
                    waypoint = "::pos{"..waypoint.systemId..","..waypoint.bodyId..","..waypoint.latitude..","..waypoint.longitude..","..waypoint.altitude.."}"
                    system.setWaypoint(waypoint)
                elseif orbit.periapsis ~= nil and orbit.periapsis.altitude > 0 and orbit.eccentricity < 1 then
                    AutopilotStatus = "Circularizing"
                    local _, endSpeed = Kep(autopilotTargetPlanet):escapeAndOrbitalSpeed((vec3(core.getConstructWorldPos())-planet.center):len()-planet.radius)
                    if velMag <= endSpeed then --or(orbit.apoapsis.altitude < AutopilotTargetOrbit and orbit.periapsis.altitude < AutopilotTargetOrbit) then
                        if CustomTarget ~= nil then
                            if velocity:normalize():dot(targetVec:normalize()) > 0.4 then -- Triggers when we get close to passing it
                                AutopilotStatus = "Orbiting to Target"
                                --brakeInput = 0
                                --Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0) -- And throttle if they want.  
                                --PlayerThrottle = 0
                                if not WaypointSet then
                                    BrakeIsOn = false -- We have to set this at least once
                                    local waypoint = zeroConvertToMapPosition(autopilotTargetPlanet, CustomTarget.position)
                                    waypoint = "::pos{"..waypoint.systemId..","..waypoint.bodyId..","..waypoint.latitude..","..waypoint.longitude..","..waypoint.altitude.."}"
                                    system.setWaypoint(waypoint)
                                    WaypointSet = true
                                end
                            else 
                                msgText = "Autopilot complete, proceeding with reentry"
                                --BrakeIsOn = false -- Leave brakes on to be safe while we align prograde
                                AutopilotTargetCoords = CustomTarget.position -- For setting the waypoint
                                AutopilotBraking = false
                                Autopilot = false
                                TargetSet = false
                                AutopilotStatus = "Aligning" -- Disable autopilot and reset
                                --brakeInput = 0
                                cmdThrottle(0)
                                PlayerThrottle = 0
                                apThrottleSet = false
                                ProgradeIsOn = true
                                spaceLand = true
                                BrakeIsOn = false
                                local waypoint = zeroConvertToMapPosition(autopilotTargetPlanet, CustomTarget.position)
                                waypoint = "::pos{"..waypoint.systemId..","..waypoint.bodyId..","..waypoint.latitude..","..waypoint.longitude..","..waypoint.altitude.."}"
                                system.setWaypoint(waypoint)
                                WaypointSet = false -- Don't need it anymore
                            end
                        else
                            BrakeIsOn = false
                            AutopilotBraking = false
                            Autopilot = false
                            TargetSet = false
                            AutopilotStatus = "Aligning" -- Disable autopilot and reset
                            -- TODO: This is being added to newContent *after* we already drew the screen, so it'll never get displayed
                            msgText = "Autopilot completed, orbit established"
                            brakeInput = 0
                            PlayerThrottle = 0
                            apThrottleSet = false
                            if CustomTarget ~= nil and CustomTarget.planetname ~= "Space" then
                                ProgradeIsOn = true
                                spaceLand = true
                            end
                        end
                    end
                end
            elseif AutopilotCruising then
                --if brakeForceRequired >= LastMaxBrake then
                if AutopilotDistance <= brakeDistance then
                    AutopilotAccelerating = false
                    AutopilotStatus = "Braking"
                    AutopilotBraking = true
                end
                local throttle = unit.getThrottle()
                if AtmoSpeedAssist then throttle = PlayerThrottle end
                if throttle > 0 then
                    AutopilotAccelerating = true
                    AutopilotStatus = "Accelerating"
                    AutopilotCruising = false
                end
            else
                -- It's engaged but hasn't started accelerating yet.
                if aligned then
                    -- Re-align to 200km from our aligned right                    
                    if not AutopilotRealigned and CustomTarget == nil or (not AutopilotRealigned and CustomTarget ~= nil and CustomTarget.planetname ~= "Space") then
                        if not spaceLand then
                            AutopilotTargetCoords = vec3(autopilotTargetPlanet.center) +
                                                        ((AutopilotTargetOrbit + autopilotTargetPlanet.radius) *
                                                            vec3(core.getConstructWorldOrientationRight()))
                            AutopilotShipUp = core.getConstructWorldOrientationUp()
                            AutopilotShipRight = core.getConstructWorldOrientationRight()
                        end
                        AutopilotRealigned = true
                    elseif aligned then
                        AutopilotAccelerating = true
                        AutopilotStatus = "Accelerating"
                        -- Set throttle to max
                        if not apThrottleSet then
                            cmdThrottle(AutopilotInterplanetaryThrottle, true)
                            -- Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal,
                            -- AutopilotInterplanetaryThrottle)
                            PlayerThrottle = round(AutopilotInterplanetaryThrottle,2)
                            apThrottleSet = true
                            BrakeIsOn = false
                        end
                    end
                end
                -- If it's not aligned yet, don't try to burn yet.
            end
            -- If we accidentally hit atmo while autopiloting to a custom target, cancel it and go straight to pulling up
        elseif Autopilot and (CustomTarget ~= nil and CustomTarget.planetname ~= "Space" and atmosphere() > 0) then
            msgText = "Autopilot complete, proceeding with reentry"
            AutopilotTargetCoords = CustomTarget.position -- For setting the waypoint
            BrakeIsOn = false -- Leaving these on makes it screw up alignment...?
            AutopilotBraking = false
            Autopilot = false
            TargetSet = false
            AutopilotStatus = "Aligning" -- Disable autopilot and reset
            brakeInput = 0
            cmdThrottle(0)
            PlayerThrottle = 0
            apThrottleSet = false
            ProgradeIsOn = true
            spaceLand = true
            local waypoint = zeroConvertToMapPosition(autopilotTargetPlanet, CustomTarget.position)
            waypoint = "::pos{"..waypoint.systemId..","..waypoint.bodyId..","..waypoint.latitude..","..waypoint.longitude..","..waypoint.altitude.."}"
            system.setWaypoint(waypoint)
        end
        if followMode then
            -- User is assumed to be outside the construct
            autoRoll = true -- Let Nav handle that while we're here
            local targetPitch = 0
            -- Keep brake engaged at all times unless: 
            -- Ship is aligned with the target on yaw (roll and pitch are locked to 0)
            -- and ship's speed is below like 5-10m/s
            local pos = vec3(core.getConstructWorldPos()) + vec3(unit.getMasterPlayerRelativePosition()) -- Is this related to core forward or nah?
            local distancePos = (pos - vec3(core.getConstructWorldPos()))
            -- local distance = distancePos:len()
            -- distance needs to be calculated using only construct forward and right
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
            pitchInput2 = 0
            local aligned = (math.abs(yawInput2) < 0.1)
            if (aligned and velMag < targetSpeed and not nearby) then -- or (not BrakeIsOn and onShip) then
                -- if not onShip then -- Don't mess with brake if they're on ship
                BrakeIsOn = false
                -- end
                targetPitch = -20
            else
                -- if not onShip then
                BrakeIsOn = true
                -- end
                targetPitch = 0
            end
            
            local autoPitchThreshold = 0
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

        if AltitudeHold or BrakeLanding or Reentry or VectorToTarget or LockPitch ~= nil then
            -- HoldAltitude is the alt we want to hold at
            local nearPlanet = unit.getClosestPlanetInfluence() > 0
            -- Dampen this.
            local altDiff = HoldAltitude - coreAltitude
            -- This may be better to smooth evenly regardless of HoldAltitude.  Let's say, 2km scaling?  Should be very smooth for atmo
            -- Even better if we smooth based on their velocity
            local minmax = 500 + velMag
            -- Smooth the takeoffs with a velMag multiplier that scales up to 100m/s
            local velMultiplier = 1
            if AutoTakeoff then velMultiplier = utils.clamp(velMag/100,0.1,1) end
            local targetPitch = (utils.smoothstep(altDiff, -minmax, minmax) - 0.5) * 2 * MaxPitch * velMultiplier

                        -- atmosphere() == 0 and
            --system.print(constrF:dot(velocity:normalize()))
            if not Reentry and not spaceLand and not VectorToTarget and constrF:dot(velocity:normalize()) < 0.99 then
                -- Widen it up and go much harder based on atmo level
                -- Scaled in a way that no change up to 10% atmo, then from 10% to 0% scales to *20 and *2
                targetPitch = (utils.smoothstep(altDiff, -minmax*utils.clamp(20 - 19*atmosphere()*10,1,20), minmax*utils.clamp(20 - 19*atmosphere()*10,1,20)) - 0.5) * 2 * MaxPitch * utils.clamp(2 - atmosphere()*10,1,2) * velMultiplier
                --if coreAltitude > HoldAltitude and targetPitch == -85 then
                --    BrakeIsOn = true
                --else
                --    BrakeIsOn = false
                --end
            end

            if not AltitudeHold then
                targetPitch = 0
            end
            if LockPitch ~= nil then 
                if nearPlanet and not IntoOrbit then 
                    targetPitch = LockPitch 
                else
                    LockPitch = nil
                end
            end
            autoRoll = true

            local oldInput = pitchInput2 
            
            if Reentry then
                -- Figure out brake distance
                -- If distance to 5km above atmo is >= brake distance, set it back to AtmoSpeedLimit
                -- Otherwise give it some high arbitrary target speed like 5000kph
                -- Even though I'd like it if we just had freefall from gravity after we cruised to AtmoSpeedLimit...
                -- So if we can 1. Align at -80 and get our speed within some range of target
                -- And then 2. Swap to throttle and let gravity do the rest til we get within brake range

                local ReentrySpeed = math.floor(adjustedAtmoSpeedLimit)

                local brakeDistancer, brakeTimer = Kinematic.computeDistanceAndTime(velMag, ReentrySpeed/3.6, constructMass(), 0, 0, LastMaxBrake - planet.gravity*9.8*constructMass())
                local distanceToTarget = coreAltitude - (planet.noAtmosphericDensityAltitude + 5000)

                if Nav.axisCommandManager:getAxisCommandType(0) == axisCommandType.byTargetSpeed and coreAltitude > planet.noAtmosphericDensityAltitude + 5000 and velMag <= ReentrySpeed/3.6 and velMag > (ReentrySpeed/3.6)-10 and math.abs(velocity:normalize():dot(constrF)) > 0.9 then
                    -- Swap to throttle for the approach
                    Nav.control.cancelCurrentControlMasterMode()
                    PlayerThrottle = 0
                elseif Nav.axisCommandManager:getAxisCommandType(0) == axisCommandType.byThrottle and ((brakeDistancer > -1 and distanceToTarget <= brakeDistancer) or coreAltitude <= planet.noAtmosphericDensityAltitude + 5000) then
                    --Nav.control.cancelCurrentControlMasterMode()
                    BrakeIsOn = true
                else
                    BrakeIsOn = false
                end

                -- if Nav.axisCommandManager:getAxisCommandType(0) == axisCommandType.byTargetSpeed and Nav.axisCommandManager:getTargetSpeed(axisCommandId.longitudinal) ~= ReentrySpeed then -- This thing is dumb.
                --     Nav.axisCommandManager:setTargetSpeedCommand(axisCommandId.longitudinal, ReentrySpeed)
                --     Nav.axisCommandManager:setTargetSpeedCommand(axisCommandId.vertical, 0)
                --     Nav.axisCommandManager:setTargetSpeedCommand(axisCommandId.lateral, 0)
                -- end
                cmdCruise(ReentrySpeed, true) -- I agree, this is dumb.
                if not reentryMode then
                    targetPitch = -80
                    if atmosphere() > 0.02 then
                        msgText = "PARACHUTE DEPLOYED"
                        Reentry = false
                        BrakeLanding = true
                        targetPitch = 0
                        autoRoll = autoRollPreference
                    end
                elseif planet.noAtmosphericDensityAltitude > 0 and coreAltitude > planet.noAtmosphericDensityAltitude + 5000 then -- 5km is good
                    --if Nav.axisCommandManager:getAxisCommandType(0) == axisCommandType.byTargetSpeed then
                    --    targetPitch = -70 -- Maybe -70 will do better, something is keeping it from pitching up at the right time... 
                    --else
                    --    targetPitch = -MaxPitch
                    --end
                    autoRoll = true -- It shouldn't actually do it, except while aligning
                elseif coreAltitude <= planet.noAtmosphericDensityAltitude + 5000 then
                    --  if Nav.axisCommandManager:getAxisCommandType(0) == axisCommandType.byThrottle then -- Cancel throttle
                    --     Nav.control.cancelCurrentControlMasterMode()
                    --     Nav.axisCommandManager:setTargetSpeedCommand(axisCommandId.longitudinal, ReentrySpeed)
                    --     Nav.axisCommandManager:setTargetSpeedCommand(axisCommandId.vertical, 0)
                    --     Nav.axisCommandManager:setTargetSpeedCommand(axisCommandId.lateral, 0)
                    -- end
                    cmdCruise(ReentrySpeed)-- Then we have to wait a tick for it to take our new speed.
                    if Nav.axisCommandManager:getAxisCommandType(0) == axisCommandType.byTargetSpeed and Nav.axisCommandManager:getTargetSpeed(axisCommandId.longitudinal) == adjustedAtmoSpeedLimit then
                        --targetPitch = -MaxPitch -- It will handle pitching for us after this.
                        reentryMode = false
                        Reentry = false
                        autoRoll = true -- wtf?  On some ships this makes it flail around because of the -80 and never recover
                    end
                    --autoRoll = autoRollPreference -- This can't be reset until after Alt Hold is done
                end
            end

            -- The clamp should now be redundant
            -- local targetPitch = utils.clamp(altDiff,-20,20) -- Clamp to reasonable values
            -- Align it prograde but keep whatever pitch inputs they gave us before, and ignore pitch input from alignment.
            -- So, you know, just yaw.
            if velMag > minAutopilotSpeed and not spaceLaunch and not VectorToTarget and not BrakeLanding and ForceAlignment then -- When do we even need this, just alt hold? lol
                AlignToWorldVector(vec3(velocity))
            end
            if (VectorToTarget or spaceLaunch) and AutopilotTargetIndex > 0 and atmosphere() > 0.01 then
                local targetVec
                if CustomTarget ~= nil then
                    targetVec = CustomTarget.position - vec3(core.getConstructWorldPos())
                else
                    targetVec = autopilotTargetPlanet.center - worldPos
                end

                -- Okay so, screw AlignToWorldVector.  Pitch is already handled, we just need to detect a Yaw value
                -- then PID the yaw to that value, with a max value of StallAngle
                -- Of course, only works if speed is high enough

                --local constrUp = vec3(core.getConstructWorldOrientationUp())
                --local vectorInYawDirection = targetVec:project_on_plane(worldV):normalize()
                --local flatForward = velocity:normalize():project_on_plane(worldV):normalize() -- Possibly necessary after 3d to 2d conversion
                -- :angle_to uses only .x and .y, literal 2d
                -- So project it on a plane first, with ship up as the normal

                -- Hilariously, angle_to uses atan2 which isn't in the game
                --local targetYaw = math.deg(constrF:angle_to(vectorInYawDirection))
                -- And is wrong?
                --local targetYaw = math.deg(math.atan(flatForward.y-vectorInYawDirection.y, flatForward.x-vectorInYawDirection.x))
                -- These projections save it from bugging out at weird angles.
                local targetYaw = math.deg(signedRotationAngle(worldV:normalize(),velocity,targetVec))*2
                --local targetYaw = math.deg(math.acos((vectorInYawDirection:dot(flatForward)))) * -utils.sign(targetVec:dot(velocity:cross(worldV)))*2
                --system.print(math.abs(worldV:dot(targetVec:normalize())))
                -- or math.abs(targetYaw) > 350
                --if math.abs(worldV:dot(targetVec:normalize())) > 0.9 then -- If it's almost directly above or below us in relation to gravity
                --    targetYaw = 0 -- Don't yaw at all in those situations.  
                --end
                -- Let's go twice what they tell us to, which should converge quickly, within our clamp
                --system.print("Target yaw " .. targetYaw)
                -- We can try it with roll... 
                local rollRad = math.rad(math.abs(roll))
                if velMag > minRollVelocity and atmosphere() > 0.01 then
                    local maxRoll = utils.clamp(90-targetPitch*2,-90,90) -- No downwards roll allowed? :( 
                    targetRoll = utils.clamp(targetYaw*2, -maxRoll, maxRoll)
                    local origTargetYaw = targetYaw
                    -- 4x weight to pitch consideration because yaw is often very weak compared and the pid needs help?
                    targetYaw = utils.clamp(utils.clamp(targetYaw,-YawStallAngle*0.85,YawStallAngle*0.85)*math.cos(rollRad) + 4*(adjustedPitch-targetPitch)*math.sin(math.rad(roll)),-YawStallAngle*0.85,YawStallAngle*0.85) -- We don't want any yaw if we're rolled
                    targetPitch = utils.clamp(utils.clamp(targetPitch*math.cos(rollRad),-PitchStallAngle*0.85,PitchStallAngle*0.85) + math.abs(utils.clamp(math.abs(origTargetYaw)*math.sin(rollRad),-PitchStallAngle*0.85,PitchStallAngle*0.85)),-PitchStallAngle*0.85,PitchStallAngle*0.85) -- Always yaw positive 
                else
                    targetRoll = 0
                    targetYaw = utils.clamp(targetYaw,-YawStallAngle*0.85,YawStallAngle*0.85)
                end-- We're just taking abs of the yaw for pitch, because we just want to pull up, and it rolled the right way already.
                -- And the pitch now gets info about yaw too?
                -- cos(roll) should give 0 at 90 and 1/-1 at 0 and 180
                -- So targetYaw*cos(roll) goes into yaw
                -- Then sin(roll) gives high values at the 90's
                -- so yaw would end up being -targetYaw*cos(roll) + targetPitch*sin(roll)
                -- and pitch would be targetPitch*cos(roll) - targetYaw*sin(roll) cuz yaw and pitch are reversed from eachother


                local yawDiff = currentYaw-targetYaw

                if not stalling and velMag > minRollVelocity and atmosphere() > 0.01 then
                    if (yawPID == nil) then
                        yawPID = pid.new(2 * 0.01, 0, 2 * 0.1) -- magic number tweaked to have a default factor in the 1-10 range
                    end
                    yawPID:inject(yawDiff)
                    local autoYawInput = utils.clamp(yawPID:get(),-1,1) -- Keep it reasonable so player can override
                    yawInput2 = yawInput2 + autoYawInput
                elseif (inAtmo and hovGndDet > -1 or velMag < minRollVelocity) then
                    AlignToWorldVector(targetVec) -- Point to the target if on the ground and 'stalled'
                elseif stalling and atmosphere() > 0.01 then
                    -- Do this if we're yaw stalling
                    if (currentYaw < -YawStallAngle or currentYaw > YawStallAngle) and atmosphere() > 0.01 then
                        AlignToWorldVector(velocity) -- Otherwise try to pull out of the stall, and let it pitch into it
                    end
                    -- Only do this if we're stalled for pitch
                    if (currentPitch < -PitchStallAngle or currentPitch > PitchStallAngle) and atmosphere() > 0.01 then
                        targetPitch = utils.clamp(adjustedPitch-currentPitch,adjustedPitch - PitchStallAngle*0.85, adjustedPitch + PitchStallAngle*0.85) -- Just try to get within un-stalling range to not bounce too much
                    end
                end
                
                if CustomTarget ~= nil and not spaceLaunch then
                    --local distanceToTarget = targetVec:project_on(velocity):len() -- Probably not strictly accurate with curvature but it should work
                    -- Well, maybe not.  Really we have a triangle.  Of course.  
                    -- We know C, our distance to target.  We know the height we'll be above the target (should be the same as our current height)
                    -- We just don't know the last leg
                    -- a2 + b2 = c2.  c2 - b2 = a2
                    local targetAltitude = planet:getAltitude(CustomTarget.position)
                    local distanceToTarget = math.sqrt(targetVec:len()^2-(coreAltitude-targetAltitude)^2)

                    -- We want current brake value, not max
                    local curBrake = LastMaxBrakeInAtmo
                    if curBrake then
                        curBrake = curBrake * utils.clamp(velMag/100,0.1,1) * atmosphere()
                    else
                        curBrake = LastMaxBrake
                    end
                    if atmosphere() < 0.01 then
                        curBrake = LastMaxBrake -- Assume space brakes
                    end
                    --local vSpd = (velocity.x * up.x) + (velocity.y * up.y) + (velocity.z * up.z)
                    local hSpd = velocity:len() - math.abs(vSpd)
                    local airFrictionVec = vec3(core.getWorldAirFrictionAcceleration())
                    local airFriction = math.sqrt(airFrictionVec:len() - airFrictionVec:project_on(up):len()) * constructMass()
                    -- Assume it will halve over our duration, if not sqrt.  We'll try sqrt because it's underestimating atm
                    -- First calculate stopping to 100 - that all happens with full brake power
                    if velMag > 100 then 
                        brakeDistance, brakeTime = Kinematic.computeDistanceAndTime(velMag, 100, constructMass(), 0, 0,
                                                        curBrake + airFriction)
                        -- Then add in stopping from 100 to 0 at what averages to half brake power.  Assume no friction for this
                        local lastDist, brakeTime2 = Kinematic.computeDistanceAndTime(100, 0, constructMass(), 0, 0, curBrake/2)
                        brakeDistance = brakeDistance + lastDist
                    else -- Just calculate it regularly assuming the value will be halved while we do it, assuming no friction
                        brakeDistance, brakeTime = Kinematic.computeDistanceAndTime(velMag, 0, constructMass(), 0, 0, curBrake/2)
                    end
                

                    --StrongBrakes = ((planet.gravity * 9.80665 * constructMass()) < LastMaxBrakeInAtmo)
                    StrongBrakes = true -- We don't care about this or glide landing anymore and idk where all it gets used
                    
                    -- Fudge it with the distance we'll travel in a tick - or half that and the next tick accounts for the other? idk
                    if not spaceLaunch and not Reentry and distanceToTarget <= brakeDistance + (velMag*deltaTick)/2 and (velocity:project_on_plane(worldV):normalize():dot(targetVec:project_on_plane(worldV):normalize()) > 0.99 or VectorStatus == "Finalizing Approach") then 
                        VectorStatus = "Finalizing Approach" 
                        cmdThrottle(0) -- Kill throttle in case they weren't in cruise
                        PlayerThrottle = 0
                        if AltitudeHold then
                            -- if not OrbitAchieved then
                                ToggleAltitudeHold() -- Don't need this anymore
                            -- end
                            VectorToTarget = true -- But keep this on
                        end
                        BrakeIsOn = true
                    elseif not AutoTakeoff then
                        BrakeIsOn = false
                    end
                    if VectorStatus == "Finalizing Approach" and (hSpd < 0.1 or distanceToTarget < 0.1 or (LastDistanceToTarget ~= nil and LastDistanceToTarget < distanceToTarget)) then
                        BrakeLanding = true
                        
                        VectorToTarget = false
                        VectorStatus = "Proceeding to Waypoint"
                    end
                    LastDistanceToTarget = distanceToTarget
                end
            elseif VectorToTarget and atmosphere() == 0 and HoldAltitude > planet.noAtmosphericDensityAltitude and not (spaceLaunch or Reentry or IntoOrbit) then
                if CustomTarget ~= nil and autopilotTargetPlanet.name == planet.name then
                    local targetVec = CustomTarget.position - vec3(core.getConstructWorldPos())
                    local targetAltitude = planet:getAltitude(CustomTarget.position)
                    local distanceToTarget = math.sqrt(targetVec:len()^2-(coreAltitude-targetAltitude)^2)
                    local curBrake = LastMaxBrakeInAtmo
                    
                    curBrake = LastMaxBrake
                    --local hSpd = velocity:len() - math.abs(vSpd)
                    brakeDistance, brakeTime = Kinematic.computeDistanceAndTime(velMag, 0, constructMass(), 0, 0, curBrake/2)
                    StrongBrakes = true
                    if distanceToTarget <= brakeDistance + (velMag*deltaTick)/2 and velocity:project_on_plane(worldV):normalize():dot(targetVec:project_on_plane(worldV):normalize()) > 0.99 then 
                        if planet.hasAtmosphere then
                            BrakeIsOn = false
                            ProgradeIsOn = false
                            reentryMode = true
                            spaceLand = false   
                            finalLand = true
                            Autopilot = false
                            -- VectorToTarget = true
                            BeginReentry()
                        end
                    end
                    LastDistanceToTarget = distanceToTarget
                
                end
            end

            -- Altitude hold and AutoTakeoff orbiting
            if atmosphere() == 0 and (AltitudeHold and HoldAltitude > planet.noAtmosphericDensityAltitude) and not (spaceLaunch or IntoOrbit or Reentry ) then
                if not OrbitAchieved and not IntoOrbit then
                    --ToggleAltitudeHold()
                    OrbitTargetOrbit = HoldAltitude -- If AP/VectorToTarget, AP already set this.  
                    OrbitTargetSet = true
                    if VectorToTarget then orbitalParams.VectorToTarget = true end
                    ToggleIntoOrbit() -- Should turn off alt hold
                    VectorToTarget = false -- WTF this gets stuck on? 
                    orbitAligned = true
                end
            end

            if stalling and atmosphere() > 0.01 and hovGndDet == -1 and velMag > minRollVelocity and VectorStatus ~= "Finalizing Approach" then
                AlignToWorldVector(velocity) -- Otherwise try to pull out of the stall, and let it pitch into it
                targetPitch = utils.clamp(adjustedPitch-currentPitch,adjustedPitch - PitchStallAngle*0.85, adjustedPitch + PitchStallAngle*0.85) -- Just try to get within un-stalling range to not bounce too much
            end


            pitchInput2 = oldInput
            local groundDistance = -1
            --local autoPitchThreshold = 0.1

            if BrakeLanding then
                targetPitch = 0
                --local vSpd = (velocity.x * up.x) + (velocity.y * up.y) + (velocity.z * up.z)
                local skipLandingRate = false
                local distanceToStop = 30 
                if maxKinematicUp ~= nil and maxKinematicUp > 0 then
                    -- Calculate a landing rate instead since we know what their hovers can do
                    
                    --local gravity = planet:getGravity(core.getConstructWorldPos()):len() * constructMass() -- We'll use a random BS value of a guess
                    --local airFriction = math.sqrt(vec3(core.getWorldAirFrictionAcceleration()):len() * constructMass())
                    -- airFriction falls off on a square

                    -- Let's try not using airFriction
                    local airFriction = 0

                    -- Funny enough, LastMaxBrakeInAtmo has stuff done to it to convert to a flat value
                    -- But we need the instant one back, to know how good we are at braking at this exact moment
                    local atmos = utils.clamp(atmosphere(),0.4,2) -- Assume at least 40% atmo when they land, to keep things fast in low atmo
                    local curBrake = LastMaxBrakeInAtmo * utils.clamp(velMag/100,0.1,1) * atmos
                    local totalNewtons = maxKinematicUp * atmos + curBrake + airFriction - gravity -- Ignore air friction for leeway, KinematicUp and Brake are already in newtons
                    --local brakeNewtons = curBrake + airFriction - gravity
                    local weakBreakNewtons = curBrake/2 + airFriction - gravity

                    -- Compute the travel time from current speed, with brake acceleration, for 20m
                    --local brakeTravelTime = Kinematic.computeTravelTime(velMag, -brakeNewtons , 20)

                    -- Big problem here, computeTravelTime only works with positive acceleration values
                    -- This means we can't calculate how long it would take to decelerate for 20 meters
                    -- But we could calculate how long it'd take to accelerate for that distance... but that's not right
                    -- Cuz it'll be increasing speed and decreasing time over that duration

                    -- I need to know the velocity after applying a force for a distance
                    -- W = Fd = 0.5*mass*velocity^2
                    -- W = math.abs(lowBrakeNewtons)*20 = 0.5*constructMass()*v^2
                    -- math.sqrt((math.abs(lowBrakeNewtons)*20)/(0.5*constructMass()))
                    
                    -- For leniency just always assume it's weak
                    local speedAfterBraking = velMag - math.sqrt((math.abs(weakBreakNewtons/2)*20)/(0.5*constructMass()))*utils.sign(weakBreakNewtons)
                    if speedAfterBraking < 0 then  
                        speedAfterBraking = 0 -- Just in case it gives us negative values
                    end
                    -- So then see if hovers can finish the job in the remaining distance

                    local brakeStopDistance
                    if velMag > 100 then
                        local brakeStopDistance1, _ = Kinematic.computeDistanceAndTime(velMag, 100, constructMass(), 0, 0, curBrake)
                        local brakeStopDistance2, _ = Kinematic.computeDistanceAndTime(100, 0, constructMass(), 0, 0, math.sqrt(curBrake))
                        brakeStopDistance = brakeStopDistance1+brakeStopDistance2
                    else
                        brakeStopDistance = Kinematic.computeDistanceAndTime(velMag, 0, constructMass(), 0, 0, math.sqrt(curBrake))
                    end
                    if brakeStopDistance < 20 then
                        BrakeIsOn = false -- We can stop in less than 20m from just brakes, we don't need to do anything
                        -- This gets overridden later if we don't know the altitude or don't want to calculate
                    else
                        local stopDistance = 0
                        if speedAfterBraking > 100 then
                            local stopDistance1, _ = Kinematic.computeDistanceAndTime(speedAfterBraking, 100, constructMass(), 0, 0, totalNewtons) 
                            local stopDistance2, _ = Kinematic.computeDistanceAndTime(100, 0, constructMass(), 0, 0, maxKinematicUp * atmos + math.sqrt(curBrake) + airFriction - gravity) -- Low brake power for the last 100kph
                            stopDistance = stopDistance1 + stopDistance2
                        else
                            stopDistance, _ = Kinematic.computeDistanceAndTime(speedAfterBraking, 0, constructMass(), 0, 0, maxKinematicUp * atmos + math.sqrt(curBrake) + airFriction - gravity) 
                        end
                        --if LandingGearGroundHeight == 0 then
                        stopDistance = (stopDistance+15+(velMag*deltaTick))*1.1 -- Add leeway for large ships with forcefields or landing gear, and for lag
                        -- And just bad math I guess
                        local knownAltitude = (CustomTarget ~= nil and planet:getAltitude(CustomTarget.position) > 0 and CustomTarget.safe)
                        
                        if knownAltitude then
                            local targetAltitude = planet:getAltitude(CustomTarget.position)
                            local distanceToGround = coreAltitude - targetAltitude - 100 -- Try to aim for like 100m above the ground, give it lots of time
                            -- We don't have to squeeze out the little bits of performance
                            local targetVec = CustomTarget.position - vec3(core.getConstructWorldPos())
                            local horizontalDistance = math.sqrt(targetVec:len()^2-(coreAltitude-targetAltitude)^2)

                            if horizontalDistance > 100 then
                                -- We are too far off, don't trust our altitude data
                                knownAltitude = false
                            elseif distanceToGround <= stopDistance or stopDistance == -1 then
                                BrakeIsOn = true
                                skipLandingRate = true
                            else
                                BrakeIsOn = false
                                skipLandingRate = true
                            end
                        end
                        
                        if not knownAltitude and CalculateBrakeLandingSpeed then
                            if stopDistance >= distanceToStop then -- 10% padding
                                BrakeIsOn = true
                            else
                                BrakeIsOn = false
                            end
                            skipLandingRate = true
                        end
                    end
                end
                if Nav.axisCommandManager:getAxisCommandType(0) == 1 then
                    Nav.control.cancelCurrentControlMasterMode()
                end
                Nav.axisCommandManager:setTargetGroundAltitude(500)
                Nav.axisCommandManager:activateGroundEngineAltitudeStabilization(500)

                groundDistance = hovGndDet
                if groundDistance > -1 then 
                    --if math.abs(targetPitch - pitch) < autoPitchThreshold then 
                        autoRoll = autoRollPreference                
                        if velMag < 1 or velocity:normalize():dot(worldV) < 0 then -- Or if they start going back up
                            BrakeLanding = false
                            AltitudeHold = false
                            GearExtended = true
                            Nav.control.extendLandingGears()
                            Nav.axisCommandManager:setTargetGroundAltitude(LandingGearGroundHeight)
                            upAmount = 0
                            BrakeIsOn = true
                        else
                            BrakeIsOn = true
                        end
                    --end
                elseif StrongBrakes and (velocity:normalize():dot(-up) < 0.999) then
                    BrakeIsOn = true
                elseif vSpd < -brakeLandingRate and not skipLandingRate then
                    BrakeIsOn = true
                elseif not skipLandingRate then
                    BrakeIsOn = false
                end
            end
            if AutoTakeoff or spaceLaunch then
                local intersectBody, nearSide, farSide
                if AutopilotTargetCoords ~= nil then
                    intersectBody, nearSide, farSide = galaxyReference:getPlanetarySystem(0):castIntersections(worldPos, (AutopilotTargetCoords-worldPos):normalize(), function(body) return (body.radius+body.noAtmosphericDensityAltitude) end)
                end
                if antigrav and antigrav.getState() == 1 then
                    if coreAltitude >= (HoldAltitude-50) then
                        AutoTakeoff = false
                        BrakeIsOn = true
                        cmdThrottle(0)
                        PlayerThrottle = 0
                    else
                        HoldAltitude = antigrav.getBaseAltitude()
                    end
                elseif math.abs(targetPitch) < 15 and (coreAltitude/HoldAltitude) > 0.75 then
                    AutoTakeoff = false -- No longer in ascent
                    if not spaceLaunch then 
                        if Nav.axisCommandManager:getAxisCommandType(0) == 0 and not AtmoSpeedAssist then
                            Nav.control.cancelCurrentControlMasterMode()
                        end
                    elseif spaceLaunch and velMag < minAutopilotSpeed then
                        Autopilot = true
                        spaceLaunch = false
                        AltitudeHold = false
                        AutoTakeoff = false
                        cmdThrottle(0)
                        PlayerThrottle = 0
                    elseif spaceLaunch then
                        cmdThrottle(0)
                        PlayerThrottle = 0
                        BrakeIsOn = true
                    end --coreAltitude > 75000
                elseif spaceLaunch and atmosphere() == 0 and autopilotTargetPlanet ~= nil and (intersectBody == nil or intersectBody.name == autopilotTargetPlanet.name) then
                    Autopilot = true
                    spaceLaunch = false
                    AltitudeHold = false
                    AutoTakeoff = false
                    if Nav.axisCommandManager:getAxisCommandType(0) == 1 then
                        Nav.control.cancelCurrentControlMasterMode()
                    end
                    --Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0)
                    --PlayerThrottle = 0
                    AutopilotAccelerating = true -- Skip alignment and don't warm down the engines
                end
            end
            -- Copied from autoroll let's hope this is how a PID works... 
            -- Don't pitch if there is significant roll, or if there is stall
            local onGround = hoverDetectGround() > -1
            local pitchToUse = pitch

            if (VectorToTarget or spaceLaunch) and not onGround and velMag > minRollVelocity and atmosphere() > 0.01 then
                local rollRad = math.rad(math.abs(roll))
                pitchToUse = pitch*math.abs(math.cos(rollRad))+currentPitch*math.sin(rollRad)
                --pitchToUse = adjustedPitch -- Use velocity vector pitch instead, we're potentially sideways
                -- Except.  We should use sin and cosine to get the value between this and our real one
                -- Because 30 regular pitch is fine, but 30 pitch above what was already 30 regular pitch isn't - it'll eventually flip us in theory
                -- What if we get the pitch of our velocity vector tho
                --utils.clamp(targetYaw,-StallAngle, StallAngle)*math.cos(rollRad) - targetPitch*math.sin(rollRad)

                -- The 'pitch' of our velocity vector plus the pitch we are in relation to it, should be our real world pitch

                -- then currentPitch*math.sin(rollRad)+pitch*math.cos(rollRad) = absolutePitch
            end
            -- TODO: These clamps need to be related to roll and YawStallAngle, we may be dealing with yaw?
            local pitchDiff = utils.clamp(targetPitch-pitchToUse, -PitchStallAngle*0.85, PitchStallAngle*0.85)
            if atmosphere() < 0.01 and VectorToTarget then
                pitchDiff = utils.clamp(targetPitch-pitchToUse, -85, MaxPitch) -- I guess
            elseif atmosphere() < 0.01 then
                pitchDiff = utils.clamp(targetPitch-pitchToUse, -MaxPitch, MaxPitch) -- I guess
            end
            if (((math.abs(roll) < 5 or VectorToTarget)) or BrakeLanding or onGround or AltitudeHold) then
                if (pitchPID == nil) then -- Changed from 8 to 5 to help reduce problems?
                    pitchPID = pid.new(5 * 0.01, 0, 5 * 0.1) -- magic number tweaked to have a default factor in the 1-10 range
                end
                pitchPID:inject(pitchDiff)
                local autoPitchInput = pitchPID:get()
                pitchInput2 = pitchInput2 + autoPitchInput
            end
        end

        if antigrav ~= nil and (antigrav and not ExternalAGG and coreAltitude < 200000) then
                if AntigravTargetAltitude == nil or AntigravTargetAltitude < 1000 then AntigravTargetAltitude = 1000 end
                if desiredBaseAltitude ~= AntigravTargetAltitude then
                    desiredBaseAltitude = AntigravTargetAltitude
                    antigrav.setBaseAltitude(desiredBaseAltitude)
                end
        end
    end
end

function script.onFlush()
    if antigrav ~= nil and (antigrav and not ExternalAGG) then
        if antigrav.getState() == 0 and antigrav.getBaseAltitude() ~= AntigravTargetAltitude then 
            antigrav.setBaseAltitude(AntigravTargetAltitude) 
        end
    end

    if Nav.axisCommandManager:getAxisCommandType(0) == axisCommandType.byThrottle and WasInCruise then
        -- Not in cruise, but was last tick
        PlayerThrottle = 0
        Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, PlayerThrottle) -- Reset throttle
        WasInCruise = false
    elseif Nav.axisCommandManager:getAxisCommandType(0) == axisCommandType.byTargetSpeed and not WasInCruise then
        -- Is in cruise, but wasn't last tick
        PlayerThrottle = 0 -- Reset this here too, because, why not
        WasInCruise = true
    end


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
    local finalPitchInput = utils.clamp(pitchInput + pitchInput2 + system.getControlDeviceForwardInput(),-1,1)
    local finalRollInput = utils.clamp(rollInput + rollInput2 + system.getControlDeviceYawInput(),-1,1)
    local finalYawInput = utils.clamp((yawInput + yawInput2) - system.getControlDeviceLeftRightInput(),-1,1)
    local finalBrakeInput = brakeInput

    -- Axis
    local worldVertical = vec3(core.getWorldVertical()) -- along gravity
    if worldVertical == nil or worldVertical:len() == 0 then
        worldVertical = (planet.center - vec3(core.getConstructWorldPos())):normalize() -- I think also along gravity hopefully?
    end


    local constructUp = vec3(core.getConstructWorldOrientationUp())
    local constructForward = vec3(core.getConstructWorldOrientationForward())
    local constructRight = vec3(core.getConstructWorldOrientationRight())
    local constructVelocity = vec3(core.getWorldVelocity())
    local constructVelocityDir = vec3(core.getWorldVelocity()):normalize()
    local currentRollDeg = getRoll(worldVertical, constructForward, constructRight)
    local currentRollDegAbs = math.abs(currentRollDeg)
    local currentRollDegSign = utils.sign(currentRollDeg)
    local atmosphere = atmosphere()

    -- Rotation
    local constructAngularVelocity = vec3(core.getWorldAngularVelocity())
    local targetAngularVelocity =
        finalPitchInput * pitchSpeedFactor * constructRight + finalRollInput * rollSpeedFactor * constructForward +
            finalYawInput * yawSpeedFactor * constructUp

    if worldVertical:len() > 0.01 and (atmosphere > 0.0 or ProgradeIsOn or Reentry or spaceLand or AltitudeHold) then
        -- autoRoll on AND currentRollDeg is big enough AND player is not rolling
        local roll = getRoll(worldVertical, constructForward, constructRight) 
        local radianRoll = (roll / 180) * math.pi
        local corrX = math.cos(radianRoll)
        local corrY = math.sin(radianRoll)
        local adjustedPitch = getPitch(worldVertical, constructForward, (constructRight * corrX) + (constructUp * corrY)) -- Don't roll if pitch is basically straight up/down
        if autoRoll == true and math.abs(targetRoll-currentRollDeg) > autoRollRollThreshold and finalRollInput == 0 and math.abs(adjustedPitch) < 85 then
            local targetRollDeg = targetRoll
            local rollFactor = autoRollFactor
            if atmosphere == 0 then
                rollFactor = rollFactor/4 -- Better or worse, you think?
                targetRoll = 0 -- Always roll to 0 out of atmo
                targetRollDeg = 0
            end
            if (rollPID == nil) then
                rollPID = pid.new(rollFactor * 0.01, 0, rollFactor * 0.1) -- magic number tweaked to have a default factor in the 1-10 range
            end
            rollPID:inject(targetRollDeg - currentRollDeg)
            local autoRollInput = rollPID:get()

            targetAngularVelocity = targetAngularVelocity + autoRollInput * constructForward
        end
    end
    if worldVertical:len() > 0.01 and atmosphere > 0.0 then
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

    if system.getMouseWheel() > 0 then
        if AltIsOn then
            if atmosphere > 0 or Reentry then
                adjustedAtmoSpeedLimit = utils.clamp(adjustedAtmoSpeedLimit + speedChangeLarge,0,AtmoSpeedLimit)
            elseif Autopilot then
                MaxGameVelocity = utils.clamp(MaxGameVelocity + speedChangeLarge/3.6*100,0, 8333.00)
            end
            toggleView = false
        else
            PlayerThrottle = round(utils.clamp(PlayerThrottle + speedChangeLarge/100, -1, 1),2)
        end
    elseif system.getMouseWheel() < 0 then
        if AltIsOn then
            if atmosphere > 0 or Reentry then
                adjustedAtmoSpeedLimit = utils.clamp(adjustedAtmoSpeedLimit - speedChangeLarge,0,AtmoSpeedLimit)
            elseif Autopilot then
                MaxGameVelocity = utils.clamp(MaxGameVelocity - speedChangeLarge/3.6*100,0, 8333.00)
            end
            toggleView = false
        else
            PlayerThrottle = round(utils.clamp(PlayerThrottle - speedChangeLarge/100, -1, 1),2)
        end
    end

    brakeInput2 = 0
    local vSpd = -worldVertical:dot(constructVelocity)

    if inAtmo and AtmoSpeedAssist and Nav.axisCommandManager:getAxisCommandType(0) == axisCommandType.byThrottle then
        -- This is meant to replace cruise
        -- Uses AtmoSpeedLimit as the desired speed in which to 'cruise'
        -- In atmo, if throttle is 100%, it applies a PID to throttle to try to achieve AtmoSpeedLimit
        -- Since throttle is already 100% this means nothing except, it should slow them as it approaches it, throttling down
            -- Note - Beware reentry.  It will throttle them down due to high fall speeds, but they need that throttle
            -- We could instead only throttle down when the velMag in the direction of ShipFront exceeds AtmoSpeedLimt.  
        -- We also need to do braking if the speed is high enough above the desired limit.  
        -- Braking should happen immediately if the speed is not mostly forward

        -- .. Maybe as a whole we just, also PID brakeForce to keep speed under that limit, so if we barely go over it'll only tap them and throttle down

        -- We're going to want a param, PlayerThrottle, which we always keep (not between loads).  We set it in SpeedUp and SpeedDown
        -- So we only control throttle if their last throttle input was 100%

        -- Well, no.  Even better, do it all the time.  We would show their throttle on the HUD, then a red line separating it from our adjusted throttle
        -- Along with a message like, "Atmospheric Speed Limit Reached - Press Something to Disable Temporarily"
        -- But of course, don't throttle up for them.  Only down. 


        

        if (throttlePID == nil) then
            throttlePID = pid.new(0.5, 0, 1) -- First param, higher means less range in which to PID to a proper value
            -- IE 1 there means it tries to get within 1m/s of target, 0.5 there means it tries to get within 5m/s of target
            -- The smaller the value, the further the end-speed is from the target, but also the sooner it starts reducing throttle
            -- It is also the same as taking the result * (firstParam), it's a direct scalar

            -- Second value makes it change constantly over time.  This doesn't work in this case, it just builds up forever while they're not at max

            -- And third value affects how hard it tries to fix it.  Higher values mean it will very quickly go to negative values as you approach target
            -- Lower values means it steps down slower

            -- 0.5, 0, 20 works pretty great
            -- And I think it was, 0.5, 0, 0.001 is smooth, but gets some braking early
            -- 0.5, 0, 1 is v good.  One early braking bit then stabilizes easily .  10 as the last is way too much, it's bouncy.  Even 2.  1 will do
        end
        -- Add in vertical speed as well as the front speed, to help with ships that have very bad brakes
        throttlePID:inject(adjustedAtmoSpeedLimit/3.6 - constructVelocity:dot(constructForward))
        local pidGet = throttlePID:get()
        calculatedThrottle = utils.clamp(pidGet,-1,1)
        if calculatedThrottle < PlayerThrottle and (atmosphere > 0.005) then -- We can limit throttle all the way to 0.05% probably
            ThrottleLimited = true
            Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, utils.clamp(calculatedThrottle,0.01,1))
        else
            ThrottleLimited = false
            Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, PlayerThrottle)
            
        end

        
        -- Then additionally
        if (brakePID == nil) then
            brakePID = pid.new(1 * 0.01, 0, 1 * 0.1)
        end
        brakePID:inject(constructVelocity:len() - (adjustedAtmoSpeedLimit/3.6)) 
        local calculatedBrake = utils.clamp(brakePID:get(),0,1)
        if (atmosphere > 0 and vSpd < -80) or atmosphere > 0.005 then -- Don't brake-limit them at <5% atmo if going up (or mostly up), it's mostly safe up there and displays 0% so people would be mad
            brakeInput2 = calculatedBrake
        end
        --if calculatedThrottle < 0 then
        --    brakeInput2 = brakeInput2 + math.abs(calculatedThrottle)
        --end
        if brakeInput2 > 0 then
            if ThrottleLimited and calculatedThrottle == 0.01 then
                Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0) -- We clamped it to >0 before but, if braking and it was at that clamp, 0 is good.
            end
        else -- For display purposes, keep calculatedThrottle positive in this case
            calculatedThrottle = utils.clamp(calculatedThrottle,0.01,1)
        end

        -- And finally, do what cruise does for angling wings toward the nose

        local autoNavigationEngineTags = ''
        local autoNavigationAcceleration = vec3()
        

        local verticalStrafeAcceleration = composeAxisAccelerationFromTargetSpeedV(axisCommandId.vertical,upAmount*1000)
        Nav:setEngineForceCommand("vertical airfoil , vertical ground ", verticalStrafeAcceleration, dontKeepCollinearity)
        --autoNavigationEngineTags = autoNavigationEngineTags .. ' , ' .. "vertical airfoil , vertical ground "
        --autoNavigationAcceleration = autoNavigationAcceleration + verticalStrafeAcceleration

        local longitudinalEngineTags = 'thrust analog longitudinal '
        if ExtraLongitudeTags ~= "none" then longitudinalEngineTags = longitudinalEngineTags..ExtraLongitudeTags end
        local longitudinalCommandType = Nav.axisCommandManager:getAxisCommandType(axisCommandId.longitudinal)
        local longitudinalAcceleration = Nav.axisCommandManager:composeAxisAccelerationFromThrottle(
                                                longitudinalEngineTags, axisCommandId.longitudinal)

        local lateralAcceleration = composeAxisAccelerationFromTargetSpeed(axisCommandId.lateral, LeftAmount*1000)
        autoNavigationEngineTags = autoNavigationEngineTags .. ' , ' .. "lateral airfoil , lateral ground " -- We handle the rest later
        autoNavigationAcceleration = autoNavigationAcceleration + lateralAcceleration

        -- Auto Navigation (Cruise Control)
        if (autoNavigationAcceleration:len() > constants.epsilon) then
            Nav:setEngineForceCommand(autoNavigationEngineTags, autoNavigationAcceleration, dontKeepCollinearity, '', '',
                '', tolerancePercentToSkipOtherPriorities)
        end
        -- And let throttle do its thing separately
        Nav:setEngineForceCommand(longitudinalEngineTags, longitudinalAcceleration, keepCollinearity)

        local verticalStrafeEngineTags = 'thrust analog vertical fueled '
        local lateralStrafeEngineTags = 'thrust analog lateral fueled '

        if ExtraLateralTags ~= "none" then lateralStrafeEngineTags = lateralStrafeEngineTags..ExtraLateralTags end
        if ExtraVerticalTags ~= "none" then verticalStrafeEngineTags = verticalStrafeEngineTags..ExtraVerticalTags end

        -- Vertical also handles the non-airfoils separately
        if upAmount ~= 0 or (BrakeLanding and BrakeIsOn) then
            Nav:setEngineForceCommand(verticalStrafeEngineTags, verticalStrafeAcceleration, keepCollinearity)
        else
            Nav:setEngineForceCommand(verticalStrafeEngineTags, vec3(), keepCollinearity) -- Reset vertical engines but not airfoils or ground
        end

        if LeftAmount ~= 0 then
            Nav:setEngineForceCommand(lateralStrafeEngineTags, lateralAcceleration, keepCollinearity)
        else
            Nav:setEngineForceCommand(lateralStrafeEngineTags, vec3(), keepCollinearity) -- Reset vertical engines but not airfoils or ground
        end

        if finalBrakeInput == 0 then -- If player isn't braking, use cruise assist braking
            finalBrakeInput = brakeInput2
        end

        -- Brakes
        local brakeAcceleration = -finalBrakeInput *
        (brakeSpeedFactor * constructVelocity + brakeFlatFactor * constructVelocityDir)
        Nav:setEngineForceCommand('brake', brakeAcceleration)

    else
        --PlayerThrottle = 0
        if AtmoSpeedAssist then
            Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, PlayerThrottle) -- Use PlayerThrottle always.
        end

        local targetSpeed = unit.getAxisCommandValue(0)

        if Nav.axisCommandManager:getAxisCommandType(0) == axisCommandType.byTargetSpeed then -- Use a PID to brake past targetSpeed
            if (brakePID == nil) then
                brakePID = pid.new(1 * 0.01, 0, 1 * 0.1)
            end
            brakePID:inject(constructVelocity:len() - (targetSpeed/3.6)) 
            local calculatedBrake = utils.clamp(brakePID:get(),0,1)
            finalBrakeInput = utils.clamp(finalBrakeInput + calculatedBrake,0,1)
        end

        -- Brakes - Do these first so Cruise can override it
        local brakeAcceleration = -finalBrakeInput *
        (brakeSpeedFactor * constructVelocity + brakeFlatFactor * constructVelocityDir)
        Nav:setEngineForceCommand('brake', brakeAcceleration)

        -- AutoNavigation regroups all the axis command by 'TargetSpeed'
        local autoNavigationEngineTags = ''
        local autoNavigationAcceleration = vec3()
        local autoNavigationUseBrake = false

        -- Longitudinal Translation
        local longitudinalEngineTags = 'thrust analog longitudinal '
        if ExtraLongitudeTags ~= "none" then longitudinalEngineTags = longitudinalEngineTags..ExtraLongitudeTags end
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
            then
                autoNavigationUseBrake = true
            end

        end

        -- Lateral Translation
        local lateralStrafeEngineTags = 'thrust analog lateral '
        if ExtraLateralTags ~= "none" then lateralStrafeEngineTags = lateralStrafeEngineTags..ExtraLateralTags end
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
        local verticalStrafeEngineTags = 'thrust analog vertical '
        if ExtraVerticalTags ~= "none" then verticalStrafeEngineTags = verticalStrafeEngineTags..ExtraVerticalTags end
        local verticalCommandType = Nav.axisCommandManager:getAxisCommandType(axisCommandId.vertical)
        if (verticalCommandType == axisCommandType.byThrottle)  then
            local verticalStrafeAcceleration = Nav.axisCommandManager:composeAxisAccelerationFromThrottle(
                                                verticalStrafeEngineTags, axisCommandId.vertical)
            if upAmount ~= 0 or (BrakeLanding and BrakeIsOn) then
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
            if upAmount < 0 then 
                Nav:setEngineForceCommand('hover', vec3(), keepCollinearity) 
            end
            local verticalAcceleration = Nav.axisCommandManager:composeAxisAccelerationFromTargetSpeed(
                                            axisCommandId.vertical)
            autoNavigationEngineTags = autoNavigationEngineTags .. ' , ' .. verticalStrafeEngineTags
            autoNavigationAcceleration = autoNavigationAcceleration + verticalAcceleration
        end

        -- Auto Navigation (Cruise Control)
        if (autoNavigationAcceleration:len() > constants.epsilon) then -- This means it's in cruise
            if (brakeInput ~= 0 or autoNavigationUseBrake or constructVelocityDir:dot(constructForward) < 0.8)
            then
                autoNavigationEngineTags = autoNavigationEngineTags .. ', brake'
            end
            Nav:setEngineForceCommand(autoNavigationEngineTags, autoNavigationAcceleration, dontKeepCollinearity, '', '',
                '', tolerancePercentToSkipOtherPriorities)
        end
    end

    -- Rotation
    local angularAcceleration = torqueFactor * (targetAngularVelocity - constructAngularVelocity)
    local airAcceleration = vec3(core.getWorldAirFrictionAngularAcceleration())
    angularAcceleration = angularAcceleration - airAcceleration -- Try to compensate air friction
    
    Nav:setEngineTorqueCommand('torque', angularAcceleration, keepCollinearity, 'airfoil', '', '',
        tolerancePercentToSkipOtherPriorities)

    -- Rockets
    Nav:setBoosterCommand('rocket_engine')
    -- Dodgin's Don't Die Rocket Govenor - Cruise Control Edition
    if isBoosting and not VanillaRockets then 
        local speed = vec3(core.getVelocity()):len()
        local maxSpeedLag = 0.15
        if Nav.axisCommandManager:getAxisCommandType(0) == 1 then -- Cruise control rocket boost assist, Dodgin's modified.
            local cc_speed = Nav.axisCommandManager:getTargetSpeed(axisCommandId.longitudinal)
            if speed * 3.6 > (cc_speed * (1 - maxSpeedLag)) and IsRocketOn then
                IsRocketOn = false
                Nav:toggleBoosters()
            elseif speed * 3.6 < (cc_speed * (1 - maxSpeedLag)) and not IsRocketOn then
                IsRocketOn = true
                Nav:toggleBoosters()
            end
        else -- Atmosphere Rocket Boost Assist Not in Cruise Control by Azraeil
            local throttle = unit.getThrottle()
            if AtmoSpeedAssist then throttle = PlayerThrottle*100 end
            local targetSpeed = (throttle/100)
            if atmosphere == 0 then
                targetSpeed = targetSpeed * MaxGameVelocity
                if speed >= (targetSpeed * (1- maxSpeedLag)) and IsRocketOn then
                    IsRocketOn = false
                    Nav:toggleBoosters()
                elseif speed < (targetSpeed * (1- maxSpeedLag)) and not IsRocketOn then
                    IsRocketOn = true
                    Nav:toggleBoosters()
                end
            else
                targetSpeed = targetSpeed * ReentrySpeed / 3.6 -- 1100km/hr being max safe speed in atmo for most ships
                if speed >= (targetSpeed * (1- maxSpeedLag)) and IsRocketOn then
                    IsRocketOn = false
                    Nav:toggleBoosters()
                elseif speed < (targetSpeed * (1- maxSpeedLag)) and not IsRocketOn then 
                    IsRocketOn = true
                    Nav:toggleBoosters()
                end
            end
        end
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
        --if hasGear then
        --    GearExtended = (Nav.control.isAnyLandingGearExtended() == 1)
        --else
            GearExtended = not GearExtended
        --end    
        
        if GearExtended then
            VectorToTarget = false
            LockPitch = nil
            if Nav.axisCommandManager:getAxisCommandType(0) == 1 then
                Nav.control.cancelCurrentControlMasterMode()
            end
            Nav.axisCommandManager:setThrottleCommand(axisCommandId.longitudinal, 0)
            PlayerThrottle = 0
            if (vBooster or hover) and hovGndDet == -1 and (atmosphere() > 0 or coreAltitude < ReentryAltitude) then
                StrongBrakes = true -- We don't care about this anymore
                Reentry = false
                AutoTakeoff = false
                VertTakeOff = false
                AltitudeHold = false
                BrakeLanding = true
                autoRoll = true
                GearExtended = false -- Don't actually toggle the gear yet though
            else
                BrakeIsOn = true
                Nav.control.extendLandingGears()
                Nav.axisCommandManager:setTargetGroundAltitude(LandingGearGroundHeight)
            end

            if hasGear and not BrakeLanding then
                Nav.control.extendLandingGears() -- Actually extend
            end
        else
            if hasGear then
                Nav.control.retractLandingGears()
            end
            Nav.axisCommandManager:setTargetGroundAltitude(TargetHoverHeight)
        end
    elseif action == "light" then
        if Nav.control.isAnyHeadlightSwitchedOn() == 1 then
            Nav.control.switchOffHeadlights()
        else
            Nav.control.switchOnHeadlights()
        end
    elseif action == "forward" then
        pitchInput = pitchInput - 1
    elseif action == "backward" then
        pitchInput = pitchInput + 1
    elseif action == "left" then
        rollInput = rollInput - 1
    elseif action == "right" then
        rollInput = rollInput + 1
    elseif action == "yawright" then
        yawInput = yawInput - 1
    elseif action == "yawleft" then
        yawInput = yawInput + 1
    elseif action == "straferight" then
        Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.lateral, 1.0)
        LeftAmount = 1
    elseif action == "strafeleft" then
        Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.lateral, -1.0)
        LeftAmount = -1
    elseif action == "up" then
        upAmount = upAmount + 1
        Nav.axisCommandManager:deactivateGroundEngineAltitudeStabilization()
        Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.vertical, 1.0)
        
    elseif action == "down" then
        upAmount = upAmount - 1
        Nav.axisCommandManager:deactivateGroundEngineAltitudeStabilization()
        Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.vertical, -1.0)
    elseif action == "groundaltitudeup" then
        if antigrav and not ExternalAGG and antigrav.getState() == 1 then
            if AntigravTargetAltitude ~= nil  then
                if AltitudeHold and AntigravTargetAltitude < HoldAltitude + 10 and AntigravTargetAltitude > HoldAltitude - 10 then 
                    AntigravTargetAltitude = AntigravTargetAltitude + antiGravButtonModifier
                    HoldAltitude = AntigravTargetAltitude
                else
                    AntigravTargetAltitude = AntigravTargetAltitude + antiGravButtonModifier
                end
            else
                AntigravTargetAltitude = desiredBaseAltitude + 100
            end
        elseif AltitudeHold then
            HoldAltitude = HoldAltitude + holdAltitudeButtonModifier
        elseif IntoOrbit then
            OrbitTargetOrbit = OrbitTargetOrbit + holdAltitudeButtonModifier
        else
            Nav.axisCommandManager:updateTargetGroundAltitudeFromActionStart(1.0)
        end
    elseif action == "groundaltitudedown" then
        if antigrav and not ExternalAGG and antigrav.getState() == 1 then
            if AntigravTargetAltitude ~= nil then
                if AltitudeHold and AntigravTargetAltitude < HoldAltitude + 10 and AntigravTargetAltitude > HoldAltitude - 10 then 
                    AntigravTargetAltitude = AntigravTargetAltitude - antiGravButtonModifier
                    if AntigravTargetAltitude < 1000 then AntigravTargetAltitude = 1000 end
                    HoldAltitude = AntigravTargetAltitude
                else
                    AntigravTargetAltitude = AntigravTargetAltitude - antiGravButtonModifier
                    if AntigravTargetAltitude < 1000 then AntigravTargetAltitude = 1000 end
                end
            else
                AntigravTargetAltitude = desiredBaseAltitude
            end
        elseif AltitudeHold then
            HoldAltitude = HoldAltitude - holdAltitudeButtonModifier
        elseif IntoOrbit then
            OrbitTargetOrbit = OrbitTargetOrbit - holdAltitudeButtonModifier
            if OrbitTargetOrbit < planet.noAtmosphericDensityAltitude+100 then OrbitTargetOrbit = planet.noAtmosphericDensityAltitude+100 end
        else
            Nav.axisCommandManager:updateTargetGroundAltitudeFromActionStart(-1.0)
        end
    elseif action == "option1" then
        if not Autopilot then -- added to prevent crash when index == 0
            IncrementAutopilotTargetIndex()
            toggleView = false
        end
    elseif action == "option2" then
        if not Autopilot then -- added to prevent crash when index == 0
            DecrementAutopilotTargetIndex()
            toggleView = false
        end
    elseif action == "option3" then
        if hideHudOnToggleWidgets then
            if showHud then
                showHud = false
            else
                showHud = true
            end
        end
        toggleView = false
        ToggleWidgets()
    elseif action == "option4" then
        ToggleAutopilot()
        toggleView = false
    elseif action == "option5" then
        ToggleLockPitch()
        toggleView = false
    elseif action == "option6" then
        ToggleAltitudeHold()
        toggleView = false
    elseif action == "option7" then
        wipeSaveVariables()
        toggleView = false
    elseif action == "option8" then
        ToggleFollowMode()
        toggleView = false
    elseif action == "option9" then
        if gyro ~= nil then
            gyro.toggle()
            gyroIsOn = gyro.getState() == 1
        end
        toggleView = false
    elseif action == "lshift" then
        if system.isViewLocked() == 1 then
            holdingCtrl = true
            PrevViewLock = system.isViewLocked()
            system.lockView(1)
        elseif isRemote() == 1 and ShiftShowsRemoteButtons then
            holdingCtrl = true
            Animated = false
            Animating = false
        end
    elseif action == "brake" then
        if BrakeToggleStatus then
            BrakeToggle()
        elseif not BrakeIsOn then
            BrakeToggle() -- Trigger the cancellations
        else
            BrakeIsOn = true -- Should never happen
        end
    elseif action == "lalt" then
        AltIsOn = true
        if isRemote() == 0 and not freeLookToggle and userControlScheme == "keyboard" then
            system.lockView(1)
        end
    elseif action == "booster" then
        -- Dodgin's Don't Die Rocket Govenor - Cruise Control Edition
        if VanillaRockets then 
            Nav:toggleBoosters()
        elseif not isBoosting then 
           if not IsRocketOn then 
               Nav:toggleBoosters()
               IsRocketOn = true
           end
           isBoosting = true
       else
           if IsRocketOn then
               Nav:toggleBoosters()
               IsRocketOn = false
           end
           isBoosting = false
       end
    elseif action == "stopengines" then
        Nav.axisCommandManager:resetCommand(axisCommandId.longitudinal)
        clearAll()
        PlayerThrottle = 0
    elseif action == "speedup" then
        if not holdingCtrl then
            if AtmoSpeedAssist and not AltIsOn then
                PlayerThrottle = utils.clamp(PlayerThrottle + speedChangeLarge/100, -1, 1)
            else
                Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.longitudinal, speedChangeLarge)
            end
        else
            IncrementAutopilotTargetIndex()
        end
    elseif action == "speeddown" then
        if not holdingCtrl then
            if AtmoSpeedAssist and not AltIsOn then
                PlayerThrottle = utils.clamp(PlayerThrottle - speedChangeLarge/100, -1, 1)
            else
                Nav.axisCommandManager:updateCommandFromActionStart(axisCommandId.longitudinal, -speedChangeLarge)
            end
            
        else
            DecrementAutopilotTargetIndex()
        end
    elseif action == "antigravity" and not ExternalAGG then
        if antigrav ~= nil then
            ToggleAntigrav()
        end
    end
end

function script.onActionStop(action)
    if action == "forward" then
        pitchInput = 0
    elseif action == "backward" then
        pitchInput = 0
    elseif action == "left" then
        rollInput = 0
    elseif action == "right" then
        rollInput = 0
    elseif action == "yawright" then
        yawInput = 0
    elseif action == "yawleft" then
        yawInput = 0
    elseif action == "straferight" then
        Nav.axisCommandManager:updateCommandFromActionStop(axisCommandId.lateral, -1.0)
        LeftAmount = 0
    elseif action == "strafeleft" then
        Nav.axisCommandManager:updateCommandFromActionStop(axisCommandId.lateral, 1.0)
        LeftAmount = 0
    elseif action == "up" then
        upAmount = 0
        Nav.axisCommandManager:updateCommandFromActionStop(axisCommandId.vertical, -1.0)
        Nav.axisCommandManager:activateGroundEngineAltitudeStabilization(currentGroundAltitudeStabilization)
        Nav:setEngineForceCommand('hover', vec3(), 1) 
    elseif action == "down" then
        upAmount = 0
        Nav.axisCommandManager:updateCommandFromActionStop(axisCommandId.vertical, 1.0)
        Nav.axisCommandManager:activateGroundEngineAltitudeStabilization(currentGroundAltitudeStabilization)
        Nav:setEngineForceCommand('hover', vec3(), 1) 
    elseif action == "groundaltitudeup" then
        currentAggModifier = antiGravButtonModifier
        currentHoldAltModifier = holdAltitudeButtonModifier
        toggleView = false
    elseif action == "groundaltitudedown" then
        currentAggModifier = antiGravButtonModifier
        currentHoldAltModifier = holdAltitudeButtonModifier
        toggleView = false
    elseif action == "lshift" then
        if system.isViewLocked() == 1 then
            holdingCtrl = false
            simulatedX = 0
            simulatedY = 0 -- Reset for steering purposes
            system.lockView(PrevViewLock)
        elseif isRemote() == 1 and ShiftShowsRemoteButtons then
            holdingCtrl = false
            Animated = false
            Animating = false
        end
    elseif action == "brake" then
        if not BrakeToggleStatus then
            if BrakeIsOn then
                BrakeToggle()
            else
                BrakeIsOn = false -- Should never happen
            end
        end
    elseif action == "lalt" then
        if isRemote() == 0 and freeLookToggle then
            if toggleView then
                if system.isViewLocked() == 1 then
                    system.lockView(0)
                else
                    system.lockView(1)
                end
            else
                toggleView = true
            end
        elseif isRemote() == 0 and not freeLookToggle and userControlScheme == "keyboard" then
            system.lockView(0)
        end
        AltIsOn = false
    end
end

function script.onActionLoop(action)
    if action == "groundaltitudeup" then
        if antigrav and not ExternalAGG and antigrav.getState() == 1 then
            if AntigravTargetAltitude ~= nil then 
                if AltitudeHold and AntigravTargetAltitude < HoldAltitude + 10 and AntigravTargetAltitude > HoldAltitude - 10 then 
                    AntigravTargetAltitude = AntigravTargetAltitude + currentAggModifier
                    HoldAltitude = AntigravTargetAltitude
                else
                    AntigravTargetAltitude = AntigravTargetAltitude + currentAggModifier
                end
                currentAggModifier = currentAggModifier * 1.05
                BrakeIsOn = false
            else
                AntigravTargetAltitude = desiredBaseAltitude + 100
                BrakeIsOn = false
            end
        elseif AltitudeHold then
            HoldAltitude = HoldAltitude + currentHoldAltModifier
            currentHoldAltModifier = currentHoldAltModifier * 1.05
        elseif IntoOrbit then
            OrbitTargetOrbit = OrbitTargetOrbit + currentHoldAltModifier
            currentHoldAltModifier = currentHoldAltModifier * 1.05
        else
            Nav.axisCommandManager:updateTargetGroundAltitudeFromActionLoop(1.0)
        end
    elseif action == "groundaltitudedown" then
        if antigrav and not ExternalAGG and antigrav.getState() == 1 then
            if AntigravTargetAltitude ~= nil then
                if AltitudeHold and AntigravTargetAltitude < HoldAltitude + 10 and AntigravTargetAltitude > HoldAltitude - 10 then 
                    AntigravTargetAltitude = AntigravTargetAltitude - currentAggModifier
                    if AntigravTargetAltitude < 1000 then AntigravTargetAltitude = 1000 end
                    HoldAltitude = AntigravTargetAltitude
                else
                    AntigravTargetAltitude = AntigravTargetAltitude - currentAggModifier
                    if AntigravTargetAltitude < 1000 then AntigravTargetAltitude = 1000 end
                end
                currentAggModifier = currentAggModifier * 1.05
                BrakeIsOn = false
            else
                AntigravTargetAltitude = desiredBaseAltitude - 100
                BrakeIsOn = false
            end
        elseif AltitudeHold then
            HoldAltitude = HoldAltitude - currentHoldAltModifier
            currentHoldAltModifier = currentHoldAltModifier * 1.05
        elseif IntoOrbit then
            OrbitTargetOrbit = OrbitTargetOrbit - currentHoldAltModifier
            if OrbitTargetOrbit < planet.noAtmosphericDensityAltitude+100 then OrbitTargetOrbit = planet.noAtmosphericDensityAltitude+100 end
            currentHoldAltModifier = currentHoldAltModifier * 1.05
        else
            Nav.axisCommandManager:updateTargetGroundAltitudeFromActionLoop(-1.0)
        end
    elseif action == "speedup" then
        if not holdingCtrl then
            if AtmoSpeedAssist and not AltIsOn then
                PlayerThrottle = utils.clamp(PlayerThrottle + speedChangeSmall/100, -1, 1)
            else
                Nav.axisCommandManager:updateCommandFromActionLoop(axisCommandId.longitudinal, speedChangeSmall)
            end
        end
    elseif action == "speeddown" then
        if not holdingCtrl then
            if AtmoSpeedAssist and not AltIsOn then
                PlayerThrottle = utils.clamp(PlayerThrottle - speedChangeSmall/100, -1, 1)
            else
                Nav.axisCommandManager:updateCommandFromActionLoop(axisCommandId.longitudinal, -speedChangeSmall)
            end
        end
    end
end

function script.onInputText(text)
    local i
    local commands = "/commands /setname /G /agg /addlocation /copydatabank"
    local command, arguement = nil, nil
    local commandhelp = "Command List:\n/commands \n/setname <newname> - Updates current selected saved position name\n/G VariableName newValue - Updates global variable to new value\n"..
            "/G dump - shows all updatable variables with /G\n/agg <targetheight> - Manually set agg target height\n"..
            "/addlocation savename ::pos{0,2,46.4596,-155.1799,22.6572} - adds a saved location by waypoint, not as accurate as making one at location\n"..
            "/copydatabank - copies dbHud databank to a blank databank"
    i = string.find(text, " ")
    command = text
    if i ~= nil then
        command = string.sub(text, 0, i-1)
        arguement = string.sub(text, i+1)
    elseif not string.find(commands, command) then
        for str in string.gmatch(commandhelp, "([^\n]+)") do
            sprint(str)
        end
        return
    end
    if command == "/setname" then 
        if arguement == nil or arguement == "" then
            msgText = "Usage: /setname Newname"
            return
        end
        if AutopilotTargetIndex > 0 and CustomTarget ~= nil then
            UpdatePosition(arguement)
        else
            msgText = "Select a saved target to rename first"
        end
    elseif command == "/addlocation" then
        if arguement == nil or arguement == "" or string.find(arguement, "::") == nil then
            msgText = "Usage: /addlocation savename ::pos{0,2,46.4596,-155.1799,22.6572}"
            return
        end
        i = string.find(arguement, "::")
        local savename = string.sub(arguement, 1, i-2)
        local pos = string.sub(arguement, i)
        local num        = ' *([+-]?%d+%.?%d*e?[+-]?%d*)'
        local posPattern = '::pos{' .. num .. ',' .. num .. ',' ..  num .. ',' .. num ..  ',' .. num .. '}'    
        local systemId, bodyId, latitude, longitude, altitude = string.match(pos, posPattern);
        local planet = atlas[tonumber(systemId)][tonumber(bodyId)]
        AddNewLocationByWaypoint(savename, planet, pos)   
        msgText = "Added "..savename.." to saved locations,\nplanet "..planet.name.." at "..pos
        msgTimer = 5    
    elseif command == "/agg" then
        if arguement == nil or arguement == "" then
            msgText = "Usage: /agg targetheight"
            return
        end
        arguement = tonumber(arguement)
        if arguement < 1000 then arguement = 1000 end
        AntigravTargetAltitude = arguement
        msgText = "AGG Target Height set to "..arguement
    elseif command == "/G" then
        if arguement == nil or arguement == "" then
            msgText = "Usage: /G VariableName variablevalue\n/G dump - shows all variables"
            return
        end
        if arguement == "dump" then
            for k, v in pairs(saveableVariables) do
                if type(_G[v]) == "boolean" then
                    if _G[v] == true then
                        sprint(v.." true")
                    else
                        sprint(v.." false")
                    end
                elseif _G[v] == nil then
                    sprint(v.." nil")
                else
                    sprint(v.." ".._G[v])
                end
            end
            return
        end
        i = string.find(arguement, " ")
        local globalVariableName = string.sub(arguement,0, i-1)
        local newGlobalValue = string.sub(arguement,i+1)
        for k, v in pairs(saveableVariables) do
            if v == globalVariableName then
                msgText = "Variable "..globalVariableName.." changed to "..newGlobalValue
                local varType = type(_G[v])
                if varType == "number" then
                    newGlobalValue = tonumber(newGlobalValue)
                elseif varType == "boolean" then
                    if string.lower(newGlobalValue) == "true" then
                        newGlobalValue = true
                    else
                        newGlobalValue = false
                    end
                end
                _G[v] = newGlobalValue
                return
            end
        end
        msgText = "No such global variable: "..globalVariableName
    elseif command == "/copydatabank" then 
        if dbHud_2 then 
            SaveDataBank(true) 
        else
            msgText = "Databank required to copy databank"
        end
    end
end

script.onStart()