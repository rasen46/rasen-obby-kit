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
version 0.4.0 dev release

please dont strip credits from this
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

-- change ur settings inside the Configurations module script
local DCLI_CONFIGS = {}

-- the obby kit (practically) (dont change this if ur playing the obby, as it could modify gameplay)
local SCLI_CONFIGS = {
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
				OrbitalOrigin = Workspace.ExampleOrbitOrigin, -- this defines what the part should orbit around (required)
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
					[Workspace.Part] = {Transparency = 1, CanCollide = false}
				}
				OnActivate = function(part) end, -- runs a function when the button is activated (optional)
				OnDeactivate = function(part) end, -- runs a function when the button is deactivated (optional)
			}
			]]
		},

		ButtonDeactivate = { -- does not work for now, ill fix next update
			--[[
			[Workspace.ButtonDeactivate] = {
				ActivateOnHumanoid = true,  -- sets if the button can be activated via players (optional, default true)
				ActivateOnPart = false,     -- sets if the button can be activated via parts (optional, default false)
				ButtonToDeactivate = Workspace.Button -- sets what button to deactivate (required)
			}
			]]
		},

		-- V ANYTHING BELOW THIS IS NOT EXPECTED TO WORK 100% OF THE TIME DUE TO STUDIO UPDATES BREAKING AND FIXING THINGS AND CHANGES TO PART PROPERTIES V
		Damager = {
			--[[
			Example Damager
			[Workspace.Killbrick] = { -- set the part you want to become a damager to the name of the part (this example shows a part named 'Killbrick')
				Damage = 5, -- sets the amount of damage it will give to a player if they touch it
			}
			]]
		},
	},

	Types = {
		Standable = {}, -- [THIS IS SOMEWHAT NON-FUNCTIONABLE] this will give parts will drag the player if moving, format (ex: {Workspace.Part2, Workspace.Part})
		IsPushable = {}, -- [THIS IS NON-FUNCTIONABLE] this will give parts under this table to be repspawned from touching parts with "PartRespawner" type, format (ex: {Workspace.Part2, Workspace.Part})
		PartRespawner = {}, --  [THIS IS NON-FUNCTIONABLE] this will respawn parts listed as "IsPushable", format (ex: {Workspace.Part2, Workspace.Part})
		Instakill = {}, -- this will kill the player immediately if they touch it, format (ex: {Workspace.Part2, Workspace.Part})
	},

	Groups = {
		BeatBlockGroup = { -- ill add size changing next update
			--[[
			["BBG1"] = { -- sets the name of the beat block group 
				BeatInterval = 1, -- sets the interval between beats in seconds (required)
				ActiveBeatBlocks = { -- parts under this class will be given these properties when active
					[1] = {Transparency = 0, CanCollide = true, TweenInfo = TweenInfo.new(...)},
					[2] = {Transparency = 0, CanCollide = true, TweenInfo = TweenInfo.new(...)}
				},
				InactiveBeatBlocks = { -- parts under this class will be given these properties when inactive
					[1] = {Transparency = 0.5, CanCollide = false, TweenInfo = TweenInfo.new(...)},
					[2] = {Transparency = 0.5, CanCollide = false, TweenInfo = TweenInfo.new(...)}
				},
				BeatBlocks = { -- sets what group a part should be in this group
					[1] = {Workspace.BeatPart1, Workspace.BeatPart2},
					[2] = {Workspace.BeatPart1, Workspace.BeatPart2}
				}
			}
			]]
		},
	}
}

-- i wouldn't interact with anything past this!!!

local CLI_Cache = {
	Map = {},
	Temp = {
		Spinner = {},
		Orbital = {},
		Mover = {},
		Conveyor = {},
		IsPushable = {},
		BeatBlockGroup = {},
	},
}

local CheckpointParts = {}
local Checkpoints = {}
local cCount = 0

local holdingQR = false
local heldQRTime = 0

local playerAddedForce = Vector3.zero
local playerWalkspeed = SCLI_CONFIGS.Player and SCLI_CONFIGS.Player.Walkspeed or 16
local playerJumppower = SCLI_CONFIGS.Player and SCLI_CONFIGS.Player.JumpPower or 50
local playerAddedWalkspeed = 0
local playerAddedJumppower = 0

local currentTouchedStandable = nil
local lastCf = nil

local elapsed = 0

local player = Players.LocalPlayer
local spawnLocation = Workspace:FindFirstChild("SpawnLocation")

if not spawnLocation then
	print("[WARN Could not find any part named SpawnLocation, defaulting to 0, 0, 0")
	spawnLocation = { CFrame = CFrame.new(0, 0, 0) }
end

local rOK_PlayerEvent = ReplicatedStorage:WaitForChild("rOK_PlayerEvent", 2) -- for obby loading from server -> client

local function LOGF(LType, log)
	if SCLI_CONFIGS.FFlagsEditor.DFFlagExportTextToOutput then
		print("[" .. tostring(LType):upper() .. "] " .. log)
	end
end

local function resetObby()
	-- untested
	for part, data in pairs(CLI_Cache) do
		if data.Original then
			data.Original:Destroy()
		end
		local newPart = part:Clone()
		newPart.Position = data.Position

		task.wait()
	end
end

-- check
local function isStandingOn(part, characterCf)
	local localPos = part.CFrame:PointToObjectSpace(characterCf.Position)
	local half = part.Size * 0.5

	if math.abs(localPos.X) > half.X then
		return false
	end

	if math.abs(localPos.Z) > half.Z then
		return false
	end

	local topY = half.Y
	local verticalDistance = localPos.Y - topY

	return verticalDistance >= -0.25 and verticalDistance <= 0.25
end
local function createAJPart()
	local newPart = Instance.new("Part")
	newPart.CanCollide = false
	newPart.Anchored = true
	newPart.Transparency = DCLI_CONFIGS.VALUES.AllJumpConfig.ShowIndicators and 0.5 or 1
	newPart.Color = DCLI_CONFIGS.VALUES.AllJumpConfig.Color3
	newPart.Size = DCLI_CONFIGS.VALUES.AllJumpConfig.Size
	newPart.Parent = Workspace

	return newPart
end

UIS.InputBegan:Connect(function(inp, pro)
	if pro then
		return
	end

	local keyEvent = DCLI_CONFIGS.KEYBINDS[inp.KeyCode]
	local playerCharacter = player.Character
	local charPivot = playerCharacter:GetPivot() :: CFrame

	if keyEvent then
		if not DCLI_CONFIGS.VALUES.LegitMode then
			if keyEvent == "SetCheckpoint" then
				cCount += 1
				local n = createAJPart()
				n.CFrame = DCLI_CONFIGS.VALUES.AllJumpConfig.CentertoHRP and (charPivot + CFrame.new(0, 2.5, 0))
					or charPivot
				CheckpointParts[cCount] = n
				Checkpoints[cCount] = charPivot
			elseif keyEvent == "GoToLatestCheckpoint" then
				local data = Checkpoints[cCount] or spawnLocation.CFrame
				if not data then
					return
				end

				playerCharacter:PivotTo(data)
			elseif keyEvent == "RemoveLatestCheckpoint" then
				if not Checkpoints[cCount] then
					return
				end
				CheckpointParts[cCount]:Destroy()
				CheckpointParts[cCount] = nil
				Checkpoints[cCount] = nil
				cCount -= 1
			end
		end

		if DCLI_CONFIGS.VALUES.EnableQuickReset and keyEvent == "QuickReset" then
			holdingQR = true
		end
	end
end)

UIS.InputEnded:Connect(function(inp)
	local keyEvent = DCLI_CONFIGS.KEYBINDS[inp.KeyCode]

	if keyEvent then
		if keyEvent == "QuickReset" then
			holdingQR = false
		end
	end
end)

-- Main Thread
task[SCLI_CONFIGS.FFlagsEditor.FFlagDeferMainThread and "defer" or "spawn"](function()
	if SCLI_CONFIGS.FFlagsEditor.FFlagDisableClientSideObjects then
		return
	end

	-- boot
	local playerCharacter = player.Character
	local charPivot = playerCharacter:GetPivot() :: CFrame

	local Values = DCLI_CONFIGS.VALUES

	local Classes = SCLI_CONFIGS.Classes
	local Types = SCLI_CONFIGS.Types
	local FFlags = SCLI_CONFIGS.FFlagsEditor

	local Temp = CLI_Cache.Temp

	local ad = Values.ActivePartDistance
	local adsq = ad * ad

	if not rOK_PlayerEvent then
		LOGF("WARN", "Damage bricks will not work due to the server-side not being installed!")
	end

	if FFlags.FFlagEnableTypeCheckerExperiment then
		for containerClass, containerObjects in pairs(SCLI_CONFIGS) do
			if containerClass ~= "Classes" and containerClass ~= "Types" then
				continue
			end

			for className, classChildren in pairs(containerObjects) do
				local rules = CheckRules[className]

				if not rules then
					LOGF("warn", `Unknown {containerClass} "{className}"`)
					continue
				end

				if containerClass == "Classes" then
					for object, data in pairs(classChildren) do
						if not object:IsA("BasePart") then
							LOGF("warn", `[{className}] [{object.Name}]: dictionary key must be an BasePart`)

							SCLI_CONFIGS[containerClass][className][object] = nil
							continue
						end

						if typeof(data) ~= "table" then
							LOGF(
								"warn",
								`[{className}] [{object.Name}]: configuration for {object.Name} must be a table`
							)

							SCLI_CONFIGS[containerClass][className][object] = nil
							continue
						end

						local result = ValidateClass(className, object, data, rules)

						if not result then
							SCLI_CONFIGS[containerClass][className][object] = nil
						end
					end
				elseif containerClass == "Types" then
					if typeof(classChildren) ~= "table" then
						LOGF("warn", `[{className}]: type must be an array`)
						continue
					end

					for i = #classChildren, 1, -1 do
						local object = classChildren[i]

						if rules.FunctionCheck and not rules.FunctionCheck(object) then
							LOGF("warn", `[{className}] [{object.Name}]: object failed FunctionCheck`)
							table.remove(classChildren, i)
						end
					end
				end
			end
		end
	end

	local function applyBeatProperties(parts, properties)
		for i = 1, #parts do
			local tweenInfo = properties.TweenInfo
			local part = parts[i]

			if tweenInfo then
				local tweenProperties = table.clone(properties)
				tweenProperties.TweenInfo = nil

				TweenService:Create(part, tweenInfo, tweenProperties):Play()
			else
				for property, value in pairs(properties) do
					part[property] = value
				end
			end
		end
	end

	-- thread
	RunService.Heartbeat:Connect(function(dt)
		playerCharacter = player.Character
		charPivot = playerCharacter:GetPivot() :: CFrame
		elapsed += dt

		local newPivot = charPivot

		local ok, result = xpcall(function()
			if holdingQR then
				heldQRTime += dt

				if heldQRTime >= DCLI_CONFIGS.VALUES.QuickResetDuration then
					holdingQR = false
					heldQRTime = 0

					--resetObby()
					LOGF("info", "reseted")
				end
			else
				heldQRTime = 0
			end

			local result, detectedStandable

			for i = 1, #Standable do
				local standablePart = Standable[i]

				if isStandingOn(standablePart, charPivot) then
					detectedStandable = standablePart
					break
				end
			end

			if detectedStandable ~= currentTouchedStandable then
				currentTouchedStandable = detectedStandable
				lastCf = detectedStandable and detectedStandable.CFrame or nil
			end

			for part, data in pairs(Spinner) do
				local offset = part.Position - charPivot.Position
				if offset:Dot(offset) < adsq then
					local dir = CLI_Cache.Temp.Spinner[part]
					part.CFrame *= CFrame.Angles(dir[1] * dt, dir[2] * dt, dir[3] * dt)
				end
			end

			for part, data in pairs(Orbital) do
				local offset = part.Position - charPivot.Position
				if offset:Dot(offset) < adsq then
					local dir = Temp.Orbital[part]

					dir.Angle += dir.Speed * dt

					local angle = dir.Angle
					local offset = dir.OrbitCFrame:VectorToWorldSpace(
						Vector3.new(math.cos(angle) * dir.Offset, 0, math.sin(angle) * dir.Offset)
					)

					local position = dir.Origin.Position + offset

					if dir.FaceCenter then
						part.CFrame = CFrame.lookAt(position, dir.Origin.Position)
					else
						part.Position = position
					end
				end
			end

			for groupName, groupData in pairs(SCLI_CONFIGS.Groups.BeatBlockGroup) do
				local dir = CLI_Cache.Temp.BeatBlockGroup[groupName]

				if not dir then
					CLI_Cache.Temp.BeatBlockGroup[groupName] = {
						Elapsed = 0,
						Index = 1,
					}
					dir = CLI_Cache.Temp.BeatBlockGroup[groupName]
				end

				dir.Elapsed += dt

				if dir.Elapsed >= groupData.BeatInterval then
					dir.Elapsed -= groupData.BeatInterval
					dir.Index += 1

					if dir.Index > #groupData.BeatBlocks then
						dir.Index = 1
					end

					for index, parts in pairs(groupData.BeatBlocks) do
						applyBeatProperties(parts, groupData.InactiveBeatBlocks[index])
					end
					applyBeatProperties(groupData.BeatBlocks[dir.Index], groupData.ActiveBeatBlocks[dir.Index])
				end
			end

			if currentTouchedStandable and lastCf then
				local currentCf = currentTouchedStandable.CFrame
				local delta = currentCf * lastCf:Inverse()

				newPivot = delta * newPivot

				lastCf = currentCf
			end

			if newPivot ~= charPivot then
				playerCharacter:PivotTo(newPivot)
			end

			playerCharacter.Humanoid.WalkSpeed = playerWalkspeed + playerAddedWalkspeed
			playerCharacter.Humanoid.JumpPower = playerJumppower + playerAddedJumppower
		end, function(err)
			return tostring(err)
		end)

		if not ok then
			LOGF("WARN", tostring(result))
		end
	end)
end)
