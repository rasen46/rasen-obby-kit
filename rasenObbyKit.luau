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
version 0.3.2 dev release

please dont strip credits from this
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local RunService = game:GetService("RunService")
local TweenService = game:GetService("TweenService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")
local UIS = game:GetService("UserInputService")

-- settings that can be changed by the player in game (i cant rlly allow in game configuration yet deu to lack of ui, so you have to configure ur settings here)
local DCLI_CONFIGS = {
	KEYBINDS = { -- keybinds for actions, just change the letter after 'KeyCode.' to the capitalized key you want
		[Enum.KeyCode.E] = "SetCheckpoint",
		[Enum.KeyCode.R] = "GoToLatestCheckpoint",
		[Enum.KeyCode.G] = "RemoveLatestCheckpoint",
		[Enum.KeyCode.T] = "QuickReset",
	},
	VALUES = { -- changes some configs with how stuff look and work
		LegitMode = false, -- Toggles the ability to use All-jump Utilities
		EnableQuickReset = false, -- Toggles the ability to Quick Reset (disabled for now)
		QRClearCheckpoints = false, -- Toggles if using Quick Reset will clear all-jump progress
		RespawnAtLastCheckPoint = true, -- Toggles if dying will spawn you at your last checkpoint or at the default SpawnLocation
		ActivePartDistance = 100, -- The maximum distance where spinners, orbital, and conveyors will remain active from the player (MIN: 50) (not inplemented yet)
		QuickResetDuration = 2, -- The amount of time required to have the Quick Reset Key being held down to reset the game

		AllJumpConfig = { -- configurations with how All-jump indicators look like
			ShowIndicators = true,
			CentertoHRP = true,
			Color3 = Color3.new(1, 1, 1),
			Size = Vector3.new(0.25, 0.25, 0.25),
		},
	},
}

-- the obby kit (practically) (dont change this if ur playing the obby, as it could modify gameplay)
local SCLI_CONFIGS = {
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
				TweenInfo = TweenInfo.new(...)           -- sets a custom tween for movement instead of linear movement, overrides Duration arg (optional, default linear)
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
				AllowHumanoids = true, -- sets if Humanoids (or player characters) can be teleported by teleporters (optional, default true)
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
				AllowHumanoids = true   -- sets if humanoids can trigger the fader (optional, default true)
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

		-- V ANYTHING BELOW THIS IS NOT EXPECTED TO WORK 100% OF THE TIME DUE TO STUDIO UPDATES BREAKING AND FIXING THINGS AND CHANGES TO PART PROPERTIES V
		Damager = {
			--[[
			Example Damager
			[Workspace.Killbrick] = { -- set the part you want to become a damager to the name of the part (this example shows a part named 'Killbrick')
				Damage = 5, -- sets the amount of damage it will give to a player if they touch it
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
				ButtonToDeactivate = workspace.Button -- sets what button to deactivate (required)
			}
			]]
		},
	},

	Types = {
		Standable = {}, -- [THIS IS SOMEWHAT NON-FUNCTIONABLE] this will give parts will drag the player if moving, format (ex: {workspace.Part2, workspace.Part})
		IsPushable = {}, -- this will give parts under this table to be repspawned from touching parts with "PartRespawner" type, format (ex: {workspace.Part2, workspace.Part})
		PartRespawner = {}, -- this will respawn parts listed as "IsPushable", format (ex: {workspace.Part2, workspace.Part})
		Instakill = {}, -- this will kill the player immediately if they touch it, format (ex: {workspace.Part2, workspace.Part})
	},

	Groups = {
		BeatBlockGroup = { -- ill add size changing next update
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

	FFlagsEditor = { -- devtools, dont touch unless yk what ur doing
		["DFFlagExportTextToOutput"] = true,
		["FFlagUsePartInstanceOverVector3"] = true,
		["FFlagEnableTypeCheckerExperiment"] = true,
		["FFlagEnableWarningOnExtraProperties"] = true,
		["FFlagDeferMainThread"] = true,
	},
}

-- i wouldn't interact with anything past this!!!

local CLI_Cache = {
	Map = {},
	Temp = {
		Orbitial = {},
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
local playerWalkspeed = 16
local playerJumppower = 50
local playerAddedWalkspeed = 0
local playerAddedJumppower = 0

local currentTouchedStandable = nil
local lastCf = nil

local elapsed = 0

local player = Players.LocalPlayer
local spawnLocation = Workspace:FindFirstChild("SpawnLocation")

local rOK_PlayerEvent = ReplicatedStorage:WaitForChild("rOK_PlayerEvent") -- for obby loading from server -> client

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

-- imported
local CheckRules = {
	Spinner = {
		Optional = {
			XAxis = "number",
			YAxis = "number",
			ZAxis = "number",
			AngleXOffset = "number",
			AngleYOffset = "number",
			AngleZOffset = "number",
		},
	},
	Orbital = {
		OrbitalOrigin = SCLI_CONFIGS.FFlagsEditor.FFlagUsePartInstanceOverVector3 and "table" or "Vector3",
		OrbitalOffset = "number",
		Optional = {
			OrbitalFaceCenter = "boolean",
			XTilt = "number",
			YRotation = "number",
			ZTilt = "number",
			TiltXOffset = "number",
			AngleYOffset = "number",
			TiltZOffset = "number",
			Speed = "number",
		},
	},
	Mover = {
		TargetPosition = SCLI_CONFIGS.FFlagsEditor.FFlagUsePartInstanceOverVector3 and "table" or "Vector3",
		Duration = "number",
		Optional = { LoopDelay = "number", TweenInfo = "table" },
	},
	Conveyor = {
		Optional = { XAxis = "number", YAxis = "number", ZAxis = "number", BasedOnRotation = "boolean" },
		Dependencies = { BasedOnRotation = { BaseSpeed = "number" } },
	},
	Teleporter = {
		TargetPosition = "table",
		Optional = {
			AllowParts = "boolean",
			AllowHumanoids = "boolean",
		},
	},
	Damager = {
		Damage = "number",
	},
	Fader = {
		Duration = "number",
		Optional = {
			RespawnDelay = "number",
			LerpTransparency = "boolean",
			TargetTransparency = "number",
			AllowParts = "boolean",
			AllowHumanoids = "boolean",
			ConnectOnTrigger = "function",
		},
	},
	PlayerProperty = {
		Optional = {
			Duration = "number",
			Walkspeed = "number",
			Jumppower = "number",
		},
	},
	ButtonDeactivate = {
		ButtonToDeactivate = "table",
		Optional = {
			ActivateOnHumanoid = "boolean",
			ActivateOnPart = "boolean",
		},
	},
	Button = {
		Optional = {
			Duration = "number",
			ActivateOnHumanoid = "boolean",
			ActivateOnPart = "boolean",
			Modify = "table",
			OnActivate = "function",
			OnAOnDeactivatectivate = "function",
		},
	},
	Standable = {
		FunctionCheck = function(b)
			return b:IsA("BasePart")
		end,
	},
	IsPushable = {},
	PartRespawner = {
		FunctionCheck = function(b)
			return b:IsA("BasePart")
		end,
	},
	Instakill = {
		FunctionCheck = function(b)
			return b:IsA("BasePart")
		end,
	},
}
--TypeChecker.luau (would be in a module, but they dont exist yet)
local function CheckValue(value, expectedType)
	if typeof(expectedType) == "function" then
		return expectedType(value)
	end

	if typeof(expectedType) == "string" then
		return typeof(value) == expectedType
	end

	return false
end

local function ValidateClass(className, object, data, rules)
	if not rules then
		LOGF("warn", `Unknown class: "{className}"`)
		return false
	end

	if rules.FunctionCheck and not rules.FunctionCheck(object) then
		LOGF("warn", `[{className}][{object.Name}]: object failed FunctionCheck`)
		return false
	end

	for propertyName, expectedType in pairs(rules) do
		if propertyName ~= "Optional" and propertyName ~= "Dependencies" and propertyName ~= "FunctionCheck" then
			local value = data[propertyName]

			if value == nil then
				LOGF("warn", `[{className}][{object.Name}]: missing required property "{propertyName}"`)
				return false
			end

			if not CheckValue(value, expectedType) then
				LOGF(
					"warn",
					`[{className}][{object.Name}]: "{propertyName}" expected {expectedType}, got {typeof(value)}`
				)
				return false
			end
		end
	end

	if rules.Optional then
		for propertyName, value in pairs(data) do
			local expectedType = rules.Optional[propertyName]

			if expectedType then
				if not CheckValue(value, expectedType) then
					LOGF(
						"warn",
						`[{className}][{object.Name}]: "{propertyName}" expected {expectedType}, got {typeof(value)}`
					)
					return false
				end
			end
		end
	end

	if rules.Dependencies then
		for propertyName, dependencyRules in pairs(rules.Dependencies) do
			local propertyValue = data[propertyName]

			if propertyValue ~= nil then
				for dependencyName, expectedType in pairs(dependencyRules) do
					local value = data[dependencyName]

					if value == nil then
						LOGF(
							"warn",
							`[{className}][{object.Name}]: "{dependencyName}" is required when "{propertyName}" is set`
						)
						return false
					end

					if not CheckValue(value, expectedType) then
						LOGF(
							"warn",
							`[{className}][{object.Name}]: "{dependencyName}" expected {expectedType}, got {typeof(
								value
							)}`
						)
						return false
					end
				end
			end
		end
	end

	if SCLI_CONFIGS.FFlagsEditor.FFlagEnableWarningOnExtraProperties then
		for propertyName in pairs(data) do
			local known = rules[propertyName] or (rules.Optional and rules.Optional[propertyName])

			if not known and rules.Dependencies then
				for _, dependencies in pairs(rules.Dependencies) do
					if dependencies[propertyName] then
						known = true
						break
					end
				end
			end
		end
	end

	return true
end

-- raycast function (multi part) [@LowPolyCat]
local allParts = nil
local lastBlockedSet = {}
local lastBlockedCount = 0

local function blockedListChanged(blocked)
	if #blocked ~= lastBlockedCount then
		return true
	end

	for _, p in pairs(blocked) do
		if not lastBlockedSet[p._id] then
			return true -- same size but not the same parts, so its a swap
		end
	end

	return false
end

local function buildPartsList(blocked)
	local blockedSet = {}
	for _, p in pairs(blocked) do
		blockedSet[p._id] = true
	end

	allParts = {}

	local function scan(inst, list)
		for _, child in pairs(list and inst or inst:GetChildren()) do
			if child:IsA("BasePart") and not blockedSet[child._id] then
				table.insert(allParts, child)
			end
			scan(child)
		end
	end

	scan(SCLI_CONFIGS.Types.Standable, true)

	lastBlockedSet = blockedSet
	lastBlockedCount = #blocked
end

local function raycastPart(pos, rayDir, maxDist, part)
	local cf = part.CFrame
	local half = part.Size * 0.5

	-- move the ray into the parts local space so rotated parts work fine too
	local localPos = cf:PointToObjectSpace(pos)
	local localDir = cf:VectorToObjectSpace(rayDir)

	local minB = -half
	local maxB = half

	local tMin = -math.huge
	local tMax = math.huge
	local normal = Vector3.new(0, 0, 0) -- please make Vector3.zero halo

	-- X axis
	if localDir.X ~= 0 then
		local t1 = (minB.X - localPos.X) / localDir.X
		local t2 = (maxB.X - localPos.X) / localDir.X

		local sign = 1
		if t1 > t2 then
			t1, t2 = t2, t1
			sign = -1
		end

		if t1 > tMin then
			tMin = t1
			normal = Vector3.new(-sign, 0, 0)
		end

		if t2 < tMax then
			tMax = t2
		end
	elseif localPos.X < minB.X or localPos.X > maxB.X then
		return nil
	end

	-- Y axis
	if localDir.Y ~= 0 then
		local t1 = (minB.Y - localPos.Y) / localDir.Y
		local t2 = (maxB.Y - localPos.Y) / localDir.Y

		local sign = 1
		if t1 > t2 then
			t1, t2 = t2, t1
			sign = -1
		end

		if t1 > tMin then
			tMin = t1
			normal = Vector3.new(0, -sign, 0)
		end

		if t2 < tMax then
			tMax = t2
		end
	elseif localPos.Y < minB.Y or localPos.Y > maxB.Y then
		return nil
	end

	-- Z axis
	if localDir.Z ~= 0 then
		local t1 = (minB.Z - localPos.Z) / localDir.Z
		local t2 = (maxB.Z - localPos.Z) / localDir.Z

		local sign = 1
		if t1 > t2 then
			t1, t2 = t2, t1
			sign = -1
		end

		if t1 > tMin then
			tMin = t1
			normal = Vector3.new(0, 0, -sign)
		end

		if t2 < tMax then
			tMax = t2
		end
	elseif localPos.Z < minB.Z or localPos.Z > maxB.Z then
		return nil
	end

	if tMin > tMax or tMin < 0 or tMin > maxDist then
		return nil
	end

	return {
		part = part,
		position = pos + rayDir * tMin,
		normal = cf:VectorToWorldSpace(normal),
		distance = tMin,
	}
end

local function raycast(pos, dir, blocked)
	blocked = blocked or {}

	if allParts == nil or blockedListChanged(blocked) then
		buildPartsList(blocked)
	end

	local maxDist = math.sqrt(dir.X ^ 2 + dir.Y ^ 2 + dir.Z ^ 2)
	local rayDir = Vector3.new(dir.X / maxDist, dir.Y / maxDist, dir.Z / maxDist)

	local closest = nil

	for _, part in pairs(allParts) do
		local result = raycastPart(pos, rayDir, maxDist, part)
		if result and (not closest or result.distance < closest.distance) then
			closest = result
		end
	end

	return closest
end

local function createAJPart()
	local newPart = Instance.new("Part")
	newPart.CanCollide = false
	newPart.Anchored = true
	newPart.Transparency = DCLI_CONFIGS.VALUES.AllJumpConfig.ShowIndicators and 0.5 or 1
	newPart.Color = DCLI_CONFIGS.VALUES.AllJumpConfig.Color3
	newPart.Size = DCLI_CONFIGS.VALUES.AllJumpConfig.Size
	newPart.Parent = workspace

	return newPart
end

UIS.InputBegan:Connect(function(inp, pro)
	if pro then
		return
	end

	local keyEvent = DCLI_CONFIGS.KEYBINDS[inp.KeyCode]
	local playerCharacter = player.Character

	if keyEvent then
		if not DCLI_CONFIGS.VALUES.LegitMode then
			if keyEvent == "SetCheckpoint" then
				cCount += 1
				local n = createAJPart()
				n.Position = DCLI_CONFIGS.VALUES.AllJumpConfig.CentertoHRP
						and (playerCharacter.Position + Vector3.new(0, 2.5, 0))
					or playerCharacter.Position
				CheckpointParts[cCount] = n
				Checkpoints[cCount] = playerCharacter.Position
			elseif keyEvent == "GoToLatestCheckpoint" then
				local pos = Checkpoints[cCount] or spawnLocation.Position
				if not pos then
					return
				end
				playerCharacter.Position = pos
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

		if keyEvent == "QuickReset" then
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
	-- boot

	if SCLI_CONFIGS.FFlagsEditor.FFlagEnableTypeCheckerExperiment then
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
						if object.ClassName ~= "Part" then
							LOGF(
								"warn",
								`[{className}] [{object.Name}]: dictionary key must be an BasePart or MeshPart`
							)

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

					for _, object in ipairs(classChildren) do
						if rules.FunctionCheck and not rules.FunctionCheck(object) then
							LOGF("warn", `[{className}] [{object.Name}]: object failed FunctionCheck`)
						end
					end
				end
			end
		end
	end

	for part, data in pairs(SCLI_CONFIGS.Classes.Spinner) do
		part.CFrame *= CFrame.Angles(
			data.AngleXOffset and math.rad(data.AngleXOffset) or 0,
			data.AngleYOffset and math.rad(data.AngleYOffset) or 0,
			data.AngleZOffset and math.rad(data.AngleZOffset) or 0
		)
	end

	for part, data in pairs(SCLI_CONFIGS.Classes.Mover) do
		local TweenTT = TweenService:Create(part, data.Tween or TweenInfo.new(data.Duration, Enum.EasingStyle.Linear), {
			Position = SCLI_CONFIGS.FFlagsEditor.FFlagUsePartInstanceOverVector3 and data.TargetPosition.Position
				or data.TargetPosition,
		})
		local TweenTO = TweenService:Create(
			part,
			data.Tween or TweenInfo.new(data.Duration, Enum.EasingStyle.Linear),
			{ Position = part.Position }
		)

		task.defer(function()
			while task.wait() do
				TweenTT:Play()
				TweenTT.Completed:Wait()
				task.wait(data.LoopDelay)

				TweenTO:Play()
				TweenTO.Completed:Wait()
				task.wait(data.LoopDelay)
			end
		end)
	end

	for part, data in pairs(SCLI_CONFIGS.Classes.Orbital) do
		CLI_Cache.Temp.Orbitial[part] = 0
	end

	for part, data in pairs(SCLI_CONFIGS.Classes.Conveyor) do
		part.Touched:Connect(function(hit)
			CLI_Cache.Temp.Conveyor[part] = true
		end)

		part.TouchEnded:Connect(function(hit)
			CLI_Cache.Temp.Conveyor[part] = nil
		end)
	end

	for part, data in pairs(SCLI_CONFIGS.Classes.Teleporter) do
		local playerCharacter = player.Character

		if data.AllowHumanoids == nil then
			data.AllowHumanoids = true
		end

		part.Touched:Connect(function(hit)
			if
				data.AllowHumanoids
				and hit.Parent
				and hit.Parent.Humanoid
				and hit.Parent.Humanoid == playerCharacter.Humanoid
			then
				playerCharacter.Position = SCLI_CONFIGS.FFlagsEditor.FFlagUsePartInstanceOverVector3
						and data.TargetPosition.Position
					or data.TargetPosition
			elseif data.AllowParts then
				hit.Position = SCLI_CONFIGS.FFlagsEditor.FFlagUsePartInstanceOverVector3
						and data.TargetPosition.Position
					or data.TargetPosition
			end
		end)
	end

	for part, data in pairs(SCLI_CONFIGS.Classes.Damager) do
		part.Touched:Connect(function()
			rOK_PlayerEvent:FireServer("damage", data.Damage)
		end)
	end

	for part, data in pairs(SCLI_CONFIGS.Classes.Fader) do
		local canFade = true
		local originalTransparency = part.Transparency
		local origin = part.Position
		local TweenTT = TweenService:Create(part, TweenInfo.new(data.Duration, Enum.EasingStyle.Linear), {
			Transparency = data.LerpTransparency and originalTransparency or data.TargetTransparency or 1,
			Position = data.TargetPosition
					and (SCLI_CONFIGS.FFlagsEditor.FFlagUsePartInstanceOverVector3 and data.TargetPosition.Position or data.TargetPosition)
				or origin,
		})
		local TweenTO = TweenService:Create(part, TweenInfo.new(data.RespawnDuration or 1, Enum.EasingStyle.Linear), {
			Transparency = originalTransparency,
			Position = origin,
		})

		if data.AllowHumanoids == nil then
			data.AllowHumanoids = true
		end

		part.Touched:Connect(function(hit)
			if not canFade then
				return
			end
			local humanoid = hit.Parent and hit.Parent.Humanoid
			if data.AllowHumanoids and humanoid then
				canFade = false
				if data.ConnectOnTrigger then
					data.ConnectOnTrigger(part)
				end

				TweenTT:Play()
				TweenTT.Completed:Wait()
				part.CanCollide = false
				task.wait(data.RespawnDelay or 1)

				part.CanCollide = true
				TweenTO:Play()
				TweenTO.Completed:Wait()

				canFade = true
			end
			if data.AllowParts then
				canFade = false
				if data.ConnectOnTrigger then
					data.ConnectOnTrigger(part)
				end

				TweenTT:Play()
				TweenTT.Completed:Wait()
				part.CanCollide = false
				task.wait(data.RespawnDelay or 0)

				part.CanCollide = true
				TweenTO:Play()
				TweenTO.Completed:Wait()

				canFade = true
			end
		end)
	end

	for part, data in pairs(SCLI_CONFIGS.Classes.PlayerProperty) do
		local active = false
		part.Touched:Connect(function(hit)
			if active then
				return
			end
			local humanoid = hit.Parent and hit.Parent.Humanoid

			if humanoid then
				active = true

				playerAddedWalkspeed += data.Walkspeed or 0
				playerAddedJumppower += data.Jumppower or 0

				task.delay(data.Duration or 1, function()
					playerAddedWalkspeed -= data.Walkspeed or 0
					playerAddedJumppower -= data.Jumppower or 0

					active = false
				end)
			end
		end)
	end

	for part, data in pairs(SCLI_CONFIGS.Classes.Button) do
		local active = false

		local originalTransparency = {}
		local breakDelay = false
		for part1 in pairs(data.Modify) do
			originalTransparency[part1] = part1.Transparency
		end

		local function deactivate()
			if breakDelay then
				breakDelay = false
				return
			end
			if not active then
				return
			end

			if data.OnDeactivate then
				data.OnDeactivate(part)
			end

			active = false

			for bpart, bpartdata in pairs(data.Modify) do
				local newTween =
					TweenService:Create(bpart, bpartdata.Tween or TweenInfo.new(0, Enum.EasingStyle.Linear), {
						Transparency = originalTransparency[bpart],
					})
				bpart.CanCollide = not bpartdata.CanCollide

				newTween:Play()
			end
		end

		part.Touched:Connect(function(hit)
			local humanoid = hit.Parent and hit.Parent:FindFirstChild("Humanoid")

			if (data.ActivateOnHumanoid ~= false and humanoid) or data.ActivateOnPart then
				if active then
					return
				end

				active = true

				if data.OnActivate then
					data.OnActivate(part)
				end

				for bpart, bpartdata in pairs(data.Modify) do
					local newTween =
						TweenService:Create(bpart, bpartdata.Tween or TweenInfo.new(0, Enum.EasingStyle.Linear), {
							Transparency = bpartdata.Transparency,
						})
					bpart.CanCollide = bpartdata.CanCollide

					newTween:Play()
				end

				if data.Duration and data.Duration > 0 then
					task.delay(data.Duration, deactivate)
				end
			end
		end)

		for dpart, ddata in pairs(SCLI_CONFIGS.Classes.ButtonDeactivate) do
			if ddata.ButtonToDeactivate == part then
				dpart.Touched:Connect(function(hit)
					local humanoid = hit.Parent and hit.Parent:FindFirstChild("Humanoid")

					local shouldDeactivate = (ddata.ActivateOnHumanoid ~= false and humanoid ~= nil)
						or (ddata.ActivateOnPart and hit:IsA("BasePart"))

					if shouldDeactivate and active then
						breakDelay = true
						deactivate()
					end
				end)
			end
		end
	end

	for i = 1, #SCLI_CONFIGS.Types.IsPushable do
		local part = SCLI_CONFIGS.Types.IsPushable[i]
		CLI_Cache.Temp.IsPushable[part] = { CFrame = part.CFrame }
	end

	for i = 1, #SCLI_CONFIGS.Types.PartRespawner do
		local part = SCLI_CONFIGS.Types.PartRespawner[i]
		part.Touched:Connect(function(hit)
			local cachedir = CLI_Cache.Temp.IsPushable[hit]

			if cachedir then
				hit.CFrame = CLI_Cache.Temp.IsPushable[part].CFrame
			end
		end)
	end

	for i = 1, #SCLI_CONFIGS.Types.Instakill do
		local part = SCLI_CONFIGS.Types.Instakill[i]
		part.Touched:Connect(function(hit)
			local humanoid = hit.Parent and hit.Parent.Humanoid and hit.Parent.Humanoid == player.Character.Humanoid
			if humanoid then
				rOK_PlayerEvent:FireServer("damage", humanoid.Health)
			end
		end)
	end

	local function applyBeatProperties(parts, properties)
		for _, part in ipairs(parts) do
			local tweenInfo = properties.Tween

			if tweenInfo then
				local tweenProperties = table.clone(properties)
				tweenProperties.Tween = nil

				TweenService:Create(part, tweenInfo, tweenProperties):Play()
			else
				for property, value in pairs(properties) do
					part[property] = value
				end
			end
		end
	end

	-- thread
	while true do
		local dt = RunService.Heartbeat:Wait()
		local playerCharacter = player.Character
		elapsed += dt

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

			for part, data in pairs(SCLI_CONFIGS.Classes.Spinner) do
				if (part.Position - playerCharacter.Position).Magnitude > DCLI_CONFIGS.VALUES.ActivePartDistance then
					continue
				end

				part.CFrame *= CFrame.Angles(
					data.XAxis and math.rad(data.XAxis * dt) or 0,
					data.YAxis and math.rad(data.YAxis * dt) or 0,
					data.ZAxis and math.rad(data.ZAxis * dt) or 0
				)
			end

			for part, data in pairs(SCLI_CONFIGS.Classes.Orbital) do
				if (part.Position - playerCharacter.Position).Magnitude > DCLI_CONFIGS.VALUES.ActivePartDistance then
					continue
				end

				local cAngle = CLI_Cache.Temp.Orbitial[part]

				cAngle += math.rad(data.Speed) * dt

				local orbitRotation =
					CFrame.Angles(math.rad(data.XTilt or 0), math.rad(data.YRotation or 0), math.rad(data.ZTilt or 0))
				local offsetRotation = CFrame.Angles(
					math.rad(data.TiltXOffset or 0),
					math.rad(data.AngleYOffset or 0),
					math.rad(data.TiltZOffset or 0)
				)
				local orbitCFrame = orbitRotation * offsetRotation
				local off = orbitCFrame:VectorToWorldSpace(
					Vector3.new(
						math.cos(cAngle) * (data.OrbitalOffset or 0),
						0,
						math.sin(cAngle) * (data.OrbitalOffset or 0)
					)
				)

				local pos = (
					SCLI_CONFIGS.FFlagsEditor.FFlagUsePartInstanceOverVector3 and data.OrbitalOrigin.Position
					or data.OrbitalOrigin
				) + off

				if data.OrbitalFaceCenter then
					part.CFrame = CFrame.lookAt(pos, data.OrbitalOrigin.Position)
				else
					part.Position = pos
				end

				CLI_Cache.Temp.Orbitial[part] = cAngle
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

			for part in pairs(CLI_Cache.Temp.Conveyor) do
				local data = SCLI_CONFIGS.Classes.Conveyor[part]

				if data.BasedOnRotation then
					playerCharacter.Position += part.CFrame.LookVector * (data.BaseSpeed or 0) * dt
				else
					playerCharacter.Position += Vector3.new(data.XAxis or 0, data.YAxis or 0, data.ZAxis or 0) * dt
				end
			end

			local result = raycast(playerCharacter.Position + Vector3.new(0, 3, 0), Vector3.new(0, -3, 0), {})

			if result and result.normal.Y > 0.5 then
				local standable = result.part
				if currentTouchedStandable ~= standable then
					currentTouchedStandable = standable
					lastCf = standable.CFrame
				end
			else
				currentTouchedStandable = nil
				lastCf = nil
			end

			if currentTouchedStandable and lastCf then
				local currentCf = currentTouchedStandable.CFrame
				local offset = playerCharacter.Position - lastCf.Position

				local localX = offset:Dot(lastCf.XVector)
				local localY = offset:Dot(lastCf.YVector)
				local localZ = offset:Dot(lastCf.ZVector)

				local newPosition = currentCf.Position
					+ currentCf.XVector * localX
					+ currentCf.YVector * localY
					+ currentCf.ZVector * localZ

				playerCharacter.Position += newPosition - playerCharacter.Position

				lastCf = currentCf
			end

			playerCharacter.Humanoid.WalkSpeed = playerWalkspeed + playerAddedWalkspeed
			playerCharacter.Humanoid.JumpPower = playerJumppower + playerAddedJumppower
		end, function(err)
			return tostring(err)
		end)

		if not ok then
			LOGF("WARN", tostring(result))
		end
	end
end)
