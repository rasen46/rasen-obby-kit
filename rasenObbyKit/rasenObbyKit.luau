--[[
            /$$$$$$  /$$   /$$
           /$$__  $$| $$  /$$/
  /$$$$$$ | $$  \ $$| $$ /$$/ 
 /$$__  $$| $$  | $$| $$$$$/  
| $$  \__/| $$  | $$| $$  $$  
| $$      | $$  | $$| $$\  $$ 
| $$      |  $$$$$$/| $$ \  $$
|__/       \______/ |__/  \__/
rasen's obby kit
version 0.4.0 alpha release

please dont strip credits from this
]]

-- the obby kit, change stuff in here to create and modify client objects
local Workspace = game:GetService("Workspace")
local obbyData = {
	Player = {
		Walkspeed = 16,
		JumpPower = 50,
	},
	Classes = {
		Spinner = {
            --[[
			Example Spinner
			[Workspace.ExampleSpinner] = { -- set the part you want to spin to the name of the part (this example shows a part named 'ExampleSpinner')
				XAxis = 500,     -- sets how fast it rotates on the X Axis (optional, default 0)
				YAxis = 20,      -- sets how fast it rotates on the Y Axis (optional, default 0)
				ZAxis = 390,     -- sets how fast it rotates on the Z Axis (optional, default 0)
				AngleXOffset = 0,-- sets how offsetted the X Axis from 0 degrees (optional, default 0)
				AngleYOffset = 0,-- sets how offsetted the Y Axis from 0 degrees (optional, default 0)
				AngleZOffset = 0,-- sets how offsetted the Z Axis from 0 degrees (optional, default 0)
			}
			]]
        },
		Orbital = {
            --[[
			Example Orbital
			[Workspace.ExampleOrbital] = { -- set the part you want to orbit around smth to the name of the part (this example shows a part named 'ExampleOrbital')
				Speed = 500,     -- sets how fast it orbits the origin in degrees/second (optional, default 0)
				XTilt = 20,      -- sets the tilts of the orbit on the X Axis in degrees (optional, default 0)
				YRotation = 23,  -- sets the tilts of the orbit on the Y Axis in degrees (optional, default 0)
				ZTilt = 390,     -- sets the tilts of the orbit on the Z Axis in degrees (optional, default 0)
				TiltXOffset = 0, -- sets how offsetted the X Axis from 0 degrees (optional, default 0)
				AngleYOffset = 0,-- sets how offsetted the Y Axis from 0 degrees (optional, default 0)
				TiltZOffset = 0, -- sets how offsetted the Z Axis from 0 degrees (optional, default 0)
				OrbitalOrigin = Workspace.ExampleOrbitOrigin, -- this defines what the part should orbit around, can be a position (required)
				OrbitalOffset = 5,        -- defines how far away the part should orbit around the origin (required)
				OrbitalFaceCenter = true  -- sets if the part should look at the origin when spinning (optional, default false)
			}
			]]
        },
		Mover = {
            --[[
			Example Moving Part
			[Workspace.ExampleMover] = { -- set the part you want to move to the name of the part (this example shows a part named 'ExampleMover')
				TargetPosition = Workspace.MovingTarget, -- sets where the part will go to (required)
				Duration = 4,                            -- sets how long it will take to get to 'TargetPosition' (required, unless Tweeninfo defined)
				LoopDelay = 2,                           -- sets how long the part will yield until it resumes moving after reaching target (optional, default 0)
				TweenIn = TweenInfo.new(...)             -- sets a custom tween for movement instead of quad movement, overrides Duration and TweenInfo args (optional, default quad)
				TweenOut = TweenInfo.new(...)            -- sets a custom tween for movement instead of quad movement, overrides Duration and TweenInfo args (optional, default quad)
				TweenInfo = TweenInfo.new(...)           -- sets a custom tween for movement instead of quad movement, overrides Duration arg (optional, default quad)
			}
			]]
        },
		Conveyor = {
            --[[
			Example Conveyor
			[Workspace.ExampleConveyor] = { -- set the part you want to convert into a conveyor to the name of the part (this example shows a part named 'ExampleConveyor')
				XAxis = 16,              -- sets the conveyor speed in the X Axis (optional, default 0)
				YAxis = 24,              -- sets the conveyor speed in the Y Axis (optional, default 0)
				ZAxis = 43,              -- sets the conveyor speed in the Z Axis (optional, default 0)
				BasedOnRotation = false, -- this controls if the conveyor should push based on how its rotated, it will override all Axis values
				BaseSpeed = 16,          -- this is only required if 'BasedOnRotation' is set to true, controls the speed of the conveyor
			}
			]]
        },
		Teleporter = {
            --[[
			Example Teleporter
			[Workspace.Teleporter] = { -- set the part you want to become a teleporter to the name of the part (this example shows a part named 'Teleporter')
				TargetPosition = Workspace.Target, -- sets the destination of the teleporter (optional, default 0)
				AllowParts = false, -- sets if parts can be teleported by teleporters (optional, default false)
				AllowPlayer = true, -- sets if Humanoids (or player characters) can be teleported by teleporters (optional, default true)
			}
			]]
        },
		Fader = {
            --[[
			Example Fader
			[Workspace.Fader] = { -- set the part you want to become a damager to the name of the part (this example shows a part named 'Fader')
				Duration = 4,            -- sets how long it takes for the fader to fade (required)
				RespawnDuration = 1,     -- sets how long it should take for the fader to fade back in (optional, default 1)
				RespawnDelay = 2,        -- sets how long it should take for the fader to respawn (optional, default 0)
				LerpTransparency = true, -- sets if the transparency should lerp to the target (optional, default true)
				TargetTransparency = 1,  -- sets the target transparency to end to (optional, default 1)
				ConnectOnTrigger = function(part) end, -- fires immediately with the optional part parameter (optional)
				AllowParts = false,      -- sets if parts can trigger the fader (optional, default false)
				AllowPlayer = true       -- sets if humanoids can trigger the fader (optional, default true)
				TweenIn = TweenInfo.new(...) -- sets a custom tween for movement instead of quad movement, overrides Duration and TweenInfo args (optional, default quad)
				TweenOut = TweenInfo.new(...) -- sets a custom tween for movement instead of quad movement, overrides Duration and TweenInfo args (optional, default quad)
				TweenInfo = TweenInfo.new(...) -- sets a custom tween for movement instead of quad movement, overrides Duration arg (optional, default quad)
			}
			]]
        },
		PlayerProperty = {
            --[[
			[Workspace.BoostPart] = { -- sets the part you want to become a PlayerProperty part (this example shows a part named 'PlayerProperty')
				Duration = 5 -- sets how long the effect lasts (optional, default 1)
				Walkspeed = 16 -- adds this much walkspeed to the player (optional, default 0)
				Jumppower = 40 -- adds this much jumppower to the player (optional, default 0)
			}
			]]
        },
        Button = {
            --[[
			[Workspace.Button] = { -- set the part you want to become a button to the name of the part (this example shows a part named 'Button')
				Duration = 1,               -- sets how long the button lasts, set to 0 for infinite (optional, default 1)
				ActivateOnHumanoid = true,  -- sets if the button can be activated via players (optional, default true)
				ActivateOnPart = false,     -- sets if the button can be activated via parts (optional, default false)
				Modify = {                  -- sets what parts to modify if activated (optional)
					[Workspace.Part] = {Transparency = 1, CanCollide = false} -- this is an example
				}
				OnActivate = function(part) end, -- runs a function when the button is activated (optional)
				OnDeactivate = function(part) end, -- runs a function when the button is deactivated (optional)
			}
			]]
        },
        ButtonDeactivate = {
            --[[
			[Workspace.ButtonDeactivate] = {
				ActivateOnHumanoid = true,  -- sets if the button can be activated via players (optional, default true)
				ActivateOnPart = false,     -- sets if the button can be activated via parts (optional, default false)
				ButtonToDeactivate = Workspace.Button -- sets what button to deactivate (required)
			}
			]]
        },

		-- V ANYTHING BELOW THIS IS NOT EXPECTED TO WORK 100% OF THE TIME DUE TO STUDIO UPDATES BREAKING AND FIXING THINGS AND CHANGES TO PART PROPERTIES V
		Damager = { -- [REQUIRES SERVER]
            --[[
			Example Damager
			[Workspace.Killbrick] = { -- set the part you want to become a damager to the name of the part (this example shows a part named 'Killbrick')
				Damage = 5, -- sets the amount of damage it will give to a player if they touch it
			}
			]]
        },
	},

	Types = {
		Standable = {}, -- [THIS IS SOMEWHAT NON-FUNCTIONABLE ON HIGH FPS (240+)] this will give parts will drag the player if moving, format (ex: {Workspace.Part2, Workspace.Part})
		IsPushable = {}, -- [DOESNT WORK FOR NOW] this will give parts under this table to be repspawned from touching parts with "PartRespawner" type, format (ex: {Workspace.Part2, Workspace.Part})
		PartRespawner = {}, -- [DOESNT WORK FOR NOW] this will respawn parts listed as "IsPushable", format (ex: {Workspace.Part2, Workspace.Part})
		Instakill = {}, -- [REQUIRES SERVER] this will kill the player immediately if they touch it, format (ex: {Workspace.Part2, Workspace.Part})
	},

	Groups = {
		BeatBlock = { -- ill add size changing next update
			--[[
			["BBG1"] = { -- sets the name of the beat block group 
				BeatInterval = 1, -- sets the interval between beats in seconds (required)
				ActiveBeatBlocks = { -- parts under this class will be given these properties when active
					[1] = {Transparency = 0, CanCollide = true, Tween = TweenInfo.new(...)},
					[2] = {Transparency = 0, CanCollide = true, Tween = TweenInfo.new(...)}
				},
				InactiveBeatBlocks = { -- parts under this class will be given these properties when inactive
					[1] = {Transparency = 0.5, CanCollide = false, Tween = TweenInfo.new(...)},
					[2] = {Transparency = 0.5, CanCollide = false, Tween = TweenInfo.new(...)}
				},
				BeatBlocks = { -- sets what group a part should be in this group
					[1] = {Workspace.BeatPart1, Workspace.BeatPart2},
					[2] = {Workspace.BeatPart1, Workspace.BeatPart2}
				}
			}
			]]
		},
	},
}

-- main
local ModuleLoader = require(script.ModuleLoader)
local Configurations = require(script.Configurations)

ModuleLoader.LoadAll()
ModuleLoader.Init()

local Main = ModuleLoader.Get("Main")
Main.Boot(obbyData, Configurations, ModuleLoader)