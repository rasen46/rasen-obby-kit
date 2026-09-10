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
version 0.3.5 beta release

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
	Player = {
		Walkspeed = 16,
		JumpPower = 50,
	},
	Classes = {
		Spinner = {
			[Workspace.SpinnerXYZ] = {
				YAxis = 180,
				XAxis = 20,
				ZAxis = 100,
			},
			[Workspace.SpinnerX] = {
				XAxis = 180,
			},
			[Workspace.SpinnerY] = {
				YAxis = 180,
			},
			[Workspace.SpinnerZ] = {
				ZAxis = 180,
			},
			[Workspace.SpinnerXYZStand] = {
				YAxis = 180,
				XAxis = 20,
				ZAxis = 100,
			},
			[Workspace.SpinnerXStand] = {
				XAxis = 180,
			},
			[Workspace.SpinnerYStand] = {
				YAxis = 180,
			},
			[Workspace.SpinnerZStand] = {
				ZAxis = 180,
			},
			[Workspace.OrbitOutStandSpinner] = {
				YAxis = 180,
			},
			[Workspace.OrbitOutSpinner] = {
				YAxis = 180,
			},
			[Workspace.moverspinner] = {
				YAxis = 180,
			},
			[Workspace.moverspinnerstand] = {
				YAxis = 180,
			},
		},

		Orbital = {
			[Workspace.OrbitOut] = {
				Speed = 180,
				OrbitalOrigin = Workspace.OrbitOrigin,
				OrbitalOffset = 5,
			},
			[Workspace.OrbitOutFace] = {
				Speed = 180,
				OrbitalOrigin = Workspace.OrbitOriginFace,
				OrbitalOffset = 5,
				OrbitalFaceCenter = true,
			},
			[Workspace.OrbitOutStand] = {
				Speed = 180,
				OrbitalOrigin = Workspace.OrbitOriginStand,
				OrbitalOffset = 5,
			},
			[Workspace.OrbitOutStandFace] = {
				Speed = 180,
				OrbitalOrigin = Workspace.OrbitOriginStandFace,
				OrbitalOffset = 5,
				OrbitalFaceCenter = true,
			},
			[Workspace.OrbitOutStandSpinner] = {
				Speed = 180,
				OrbitalOrigin = Workspace.OrbitOriginStandSpinner,
				OrbitalOffset = 10,
			},
			[Workspace.OrbitOutSpinner] = {
				Speed = 180,
				OrbitalOrigin = Workspace.OrbitOriginSpinner,
				OrbitalOffset = 10,
			},
		},

		Mover = {
			[Workspace.mover] = {
				TargetPosition = Workspace.moverorigin,
				Duration = 2,
			},
			[Workspace.moverspinner] = {
				TargetPosition = Workspace.moveroriginspinner,
				Duration = 2,
			},
			[Workspace.moverstand] = {
				TargetPosition = Workspace.moveroriginstand,
				Duration = 2,
			},
			[Workspace.moverspinnerstand] = {
				TargetPosition = Workspace.moveroriginspinnerstand,
				Duration = 2,
			},
		},

		Conveyor = {
			[Workspace.conveyor] = {
				BasedOnRotation = true,
				BaseSpeed = 16,
			},
			[Workspace.conveyor1] = {
				BasedOnRotation = true,
				BaseSpeed = 16,
			},
			[Workspace.conveyor2] = {
				BasedOnRotation = true,
				BaseSpeed = 16,
			},
		},

		Teleporter = {
			[workspace.t1] = {
				TargetPosition = workspace.t2,
				AllowParts = true,
			},
		},

		Fader = {
			[Workspace.fade] = {
				Duration = 4,
				LerpTransparency = false,
			},
			[Workspace.fade1] = {
				Duration = 2,
			},
			[Workspace.fadefall] = {
				Duration = 2,
				RespawnDelay = 1,
				RespawnDuration = 2,
				ConnectOnTrigger = function(part)
					local oldPos = part.Position

					local p =
						TweenService:Create(part, TweenInfo.new(2), { Position = Workspace.fadefallorigin.Position })

					task.defer(function()
						p:Play()
						p.Completed:Wait()
						task.wait(1)
						p = TweenService:Create(part, TweenInfo.new(2), { Position = oldPos })
						p:Play()
					end)
				end,
			},
		},

		PlayerProperty = {
			[Workspace.speed] = {
				Duration = 5,
				Walkspeed = 16,
			},
			[Workspace.jump] = {
				Duration = 5,
				Jumppower = 16,
			},
		},

		-- V ANYTHING BELOW THIS IS NOT EXPECTED TO WORK 100% OF THE TIME DUE TO STUDIO UPDATES BREAKING AND FIXING THINGS AND CHANGES TO PART PROPERTIES V
		Damager = {
			[Workspace.damage] = {
				Damage = 5,
			},
		},

		Button = {
			[Workspace.button] = {
				Duration = 4,
				Modify = {
					[Workspace.door] = {
						Transparency = 0.5,
						CanCollide = false,
						TweenIn = TweenInfo.new(0.2),
						TweenOut = TweenInfo.new(0.2),
					},
				},
			},
			[Workspace.button2] = {
				Duration = 5,
				Modify = {
					[Workspace.door2] = {
						Transparency = 0,
						CanCollide = true,
						TweenIn = TweenInfo.new(0.2),
						TweenOut = TweenInfo.new(0.2),
					},
				},
			},
		},

		ButtonDeactivate = {
			[workspace.deact] = {
				ButtonToDeactivate = Workspace.button,
			},
		},
	},

	Types = {
		Standable = {
			Workspace.SpinnerXYZStand,
			Workspace.SpinnerXStand,
			Workspace.SpinnerYStand,
			Workspace.SpinnerZStand,
			Workspace.OrbitOutStand,
			Workspace.OrbitOutStandFace,
			Workspace.OrbitOutStandSpinner,
			Workspace.moverstand,
			Workspace.moverspinnerstand,
		}, -- [THIS IS SOMEWHAT NON-FUNCTIONABLE] this will give parts will drag the player if moving, format (ex: {Workspace.Part2, Workspace.Part})
		IsPushable = {}, -- this will give parts under this table to be repspawned from touching parts with "PartRespawner" type, format (ex: {Workspace.Part2, Workspace.Part})
		PartRespawner = {}, -- this will respawn parts listed as "IsPushable", format (ex: {Workspace.Part2, Workspace.Part})
		Instakill = { Workspace.insta }, -- this will kill the player immediately if they touch it, format (ex: {Workspace.Part2, Workspace.Part})
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
			["BBG1"] = { -- sets the name of the beat block group
				BeatInterval = 1, -- sets the interval between beats in seconds (required)
				ActiveBeatBlocks = { -- parts under this class will be given these properties when active
					[1] = {
						Transparency = 0,
						Size = Vector3.new(1, 1, 1),
						CanCollide = true,
						TweenInfo = TweenInfo.new(0.2),
					},
					[2] = {
						Transparency = 0,
						Size = Vector3.new(1, 1, 1),
						CanCollide = true,
						TweenInfo = TweenInfo.new(0.2),
					},
					[3] = {
						Transparency = 0,
						Size = Vector3.new(1, 1, 1),
						CanCollide = true,
						TweenInfo = TweenInfo.new(0.2),
					},
					[4] = {
						Transparency = 0,
						Size = Vector3.new(1, 1, 1),
						CanCollide = true,
						TweenInfo = TweenInfo.new(0.2),
					},
				},
				InactiveBeatBlocks = { -- parts under this class will be given these properties when inactive
					[1] = {
						Transparency = 0.5,
						Size = Vector3.new(8, 1, 1),
						CanCollide = false,
						TweenInfo = TweenInfo.new(0.2),
					},
					[2] = {
						Transparency = 0.5,
						Size = Vector3.new(8, 1, 1),
						CanCollide = false,
						TweenInfo = TweenInfo.new(0.2),
					},
					[3] = {
						Transparency = 0.5,
						Size = Vector3.new(8, 1, 1),
						CanCollide = false,
						TweenInfo = TweenInfo.new(0.2),
					},
					[4] = {
						Transparency = 0.5,
						Size = Vector3.new(8, 1, 1),
						CanCollide = false,
						TweenInfo = TweenInfo.new(0.2),
					},
				},
				BeatBlocks = { -- sets what group a part should be in this group
					[1] = { Workspace.beat1 },
					[2] = { Workspace.beat2 },
					[3] = { Workspace.beat3 },
					[4] = { Workspace.beat4 },
				},
			},
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
local playerWalkspeed = SCLI_CONFIGS.Player.Walkspeed
local playerJumppower = SCLI_CONFIGS.Player.JumpPower
local playerAddedWalkspeed = 0
local playerAddedJumppower = 0

local currentTouchedStandable = nil
local lastCf = nil

local elapsed = 0

local player = Players.LocalPlayer
local spawnLocation = Workspace:FindFirstChild("SpawnLocation")

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
		Optional = { LoopDelay = "number", TweenInfo = "table", Duration = "number" },
	},
	Conveyor = {
		Optional = { XAxis = "number", YAxis = "number", ZAxis = "number", BasedOnRotation = "boolean" },
		Dependencies = { BasedOnRotation = { BaseSpeed = "number" } },
	},
	Teleporter = {
		TargetPosition = "table",
		Optional = {
			AllowParts = "boolean",
			AllowPlayer = "boolean",
		},
	},
	Damager = {
		Damage = "number",
	},
	Fader = {
		Duration = "number",
		Optional = {
			RespawnDuration = "number",
			RespawnDelay = "number",
			LerpTransparency = "boolean",
			TargetTransparency = "number",
			AllowParts = "boolean",
			AllowPlayer = "boolean",
			ConnectOnTrigger = "function",
			TargetPosition = "table",
			TweenInfo = "table",
			TweenOut = "table",
			TweenIn = "table",
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
			OnDeactivate = "function",
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
				LOGF(
					"warn",
					`[{className}][{object.Name}]: missing required property "{propertyName}", or value got is invalid/non-existent: 'nil'`
				)
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
			elseif not known then
				LOGF("warn", `[{className}][{object.Name}]: unknown property "{propertyName}"`)
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
	local half = part.Size / 2
	local normal = Vector3.new()
	local localPos, localDir = cf:PointToObjectSpace(pos), cf:VectorToObjectSpace(rayDir)
	local minB, maxB = -half, half
	local tMin, tMax = -math.huge, math.huge
	for i = 1, 3 do
		local direction = (i == 1 and "X") or (i == 2 and "Y") or "Z"
		if localDir[direction] ~= 0 then
			local t1 = (minB[direction] - localPos[direction]) / localDir[direction]
			local t2 = (maxB[direction] - localPos[direction]) / localDir[direction]
			local sign = 1
			if t1 > t2 then
				t1, t2 = t2, t1
				sign = -1
			end
			if t1 > tMin then
				tMin = t1
				normal = Vector3.new(
					direction == "X" and -sign or 0,
					direction == "Y" and -sign or 0,
					direction == "Z" and -sign or 0
				)
			end
			if t2 < tMax then
				tMax = t2
			end
		elseif localPos[direction] < minB[direction] or localPos[direction] > maxB[direction] then
			return nil
		end
	end
	if tMin > tMax or tMin < 0 or tMin > maxDist then
		return nil
	end
	return { part = part, position = pos + rayDir * tMin, normal = cf:VectorToWorldSpace(normal), distance = tMin }
end
local function raycast(pos, dir, blocked)
	blocked = blocked or {}
	if not allParts or blockedListChanged(blocked) then
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
	local playerCharacter = player.Character
	local charPivot = playerCharacter:GetPivot() :: CFrame

	if not rOK_PlayerEvent then
		LOGF("WARN", "Damage bricks will not work due to the server-side not being installed!")
	end

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
		part.Rotation *= Vector3.new(
			data.AngleXOffset and math.rad(data.AngleXOffset) or 0,
			data.AngleYOffset and math.rad(data.AngleYOffset) or 0,
			data.AngleZOffset and math.rad(data.AngleZOffset) or 0
		)

		CLI_Cache.Temp.Spinner[part] =
			{ math.rad(data.XAxis or 0), math.rad(data.YAxis or 0), math.rad(data.ZAxis or 0) }
	end

	for part, data in pairs(SCLI_CONFIGS.Classes.Mover) do
		local TweenTT = TweenService:Create(part, data.TweenIn or data.TweenInfo or TweenInfo.new(data.Duration), {
			Position = SCLI_CONFIGS.FFlagsEditor.FFlagUsePartInstanceOverVector3 and data.TargetPosition.Position
				or data.TargetPosition,
		})
		local TweenTO = TweenService:Create(
			part,
			data.TweenIn or data.TweenInfo or TweenInfo.new(data.Duration),
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
		local orbitRotation =
			CFrame.Angles(math.rad(data.XTilt or 0), math.rad(data.YRotation or 0), math.rad(data.ZTilt or 0))
		local offsetRotation = CFrame.Angles(
			math.rad(data.TiltXOffset or 0),
			math.rad(data.AngleYOffset or 0),
			math.rad(data.TiltZOffset or 0)
		)
		local orbitCFrame = orbitRotation * offsetRotation

		CLI_Cache.Temp.Orbital[part] = {
			curAngle = 0,
			orbitCFrame = orbitCFrame,
		}
	end

	for part, data in pairs(SCLI_CONFIGS.Classes.Conveyor) do
		part.Touched:Connect(function(hit)
			if hit and hit._id and hit._id == playerCharacter._id then
				CLI_Cache.Temp.Conveyor[part] = true
			end
		end)

		part.TouchEnded:Connect(function(hit)
			if CLI_Cache.Temp.Conveyor[part] then
				CLI_Cache.Temp.Conveyor[part] = nil
			end
		end)
	end

	for part, data in pairs(SCLI_CONFIGS.Classes.Teleporter) do
		if data.AllowPlayer == nil then
			data.AllowPlayer = true
		end

		part.Touched:Connect(function(hit)
			if data.AllowPlayer and hit and hit._id and hit._id == playerCharacter._id then
				playerCharacter:PivotTo(
					SCLI_CONFIGS.FFlagsEditor.FFlagUsePartInstanceOverVector3 and data.TargetPosition.CFrame
						or CFrame.new(data.TargetPosition)
				)
			elseif data.AllowParts then
				hit.CFrame = SCLI_CONFIGS.FFlagsEditor.FFlagUsePartInstanceOverVector3 and data.TargetPosition.CFrame
					or CFrame.new(data.TargetPosition)
			end
		end)
	end

	if rOK_PlayerEvent then
		for part, data in pairs(SCLI_CONFIGS.Classes.Damager) do
			part.Touched:Connect(function(hit)
				local humanoid = hit
					and hit._id
					and hit._id == playerCharacter._id
					and playerCharacter:FindFirstChildOfClass("Humanoid")

				if humanoid then
					rOK_PlayerEvent:FireServer("damage", data.Damage)
				end
			end)
		end

		for i = 1, #SCLI_CONFIGS.Types.Instakill do
			local part = SCLI_CONFIGS.Types.Instakill[i]
			part.Touched:Connect(function(hit)
				local humanoid = hit
					and hit._id
					and hit._id == playerCharacter._id
					and playerCharacter:FindFirstChildOfClass("Humanoid")
				if humanoid then
					rOK_PlayerEvent:FireServer("damage", humanoid.Health)
				end
			end)
		end
	end

	for part, data in pairs(SCLI_CONFIGS.Classes.Fader) do
		local canFade = true
		local originalTransparency = part.Transparency
		local origin = part.Position
		local TweenTT = TweenService:Create(part, data.TweenOut or data.TweenInfo or TweenInfo.new(data.Duration), {
			Transparency = data.TargetTransparency or 1,
			Position = data.TargetPosition
					and (SCLI_CONFIGS.FFlagsEditor.FFlagUsePartInstanceOverVector3 and data.TargetPosition.Position or data.TargetPosition)
				or origin,
		})
		local TweenTO =
			TweenService:Create(part, data.TweenIn or data.TweenInfo or TweenInfo.new(data.RespawnDuration or 1), {
				Transparency = originalTransparency,
				Position = origin,
			})

		if data.AllowPlayer == nil then
			data.AllowPlayer = true
		end

		part.Touched:Connect(function(hit)
			if not canFade then
				return
			end
			if data.AllowPlayer and hit and hit._id == playerCharacter._id then
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
			elseif data.AllowParts then
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
			local humanoid = hit
				and hit._id
				and hit._id == playerCharacter._id
				and playerCharacter:FindFirstChildOfClass("Humanoid")

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
		local breakDelay = false

		local deactivateid = 0

		local original = {}

		for part1 in pairs(data.Modify or {}) do
			original[part1] = {
				Transparency = part1.Transparency,
				CFrame = part1.CFrame,
				CanCollide = part1.CanCollide,
				Size = part1.Size,
			}
		end

		local function deactivate()
			if not active then
				return
			end

			if data.OnDeactivate then
				data.OnDeactivate(part)
			end

			active = false

			for bpart, bpartdata in pairs(data.Modify or {}) do
				local newTween = TweenService:Create(bpart, bpartdata.TweenOut or TweenInfo.new(0.2), {
					Transparency = original[bpart].Transparency,
					CFrame = original[bpart].CFrame,
					Size = original[bpart].Size,
				})

				bpart.CanCollide = original[bpart].CanCollide
				newTween:Play()
			end
		end

		part.Touched:Connect(function(hit)
			local humanoid = hit
				and hit._id
				and hit._id == playerCharacter._id
				and playerCharacter:FindFirstChildOfClass("Humanoid")

			if (data.ActivateOnHumanoid ~= false and humanoid) or data.ActivateOnPart then
				if active then
					return
				end

				active = true

				if data.OnActivate then
					data.OnActivate(part)
				end

				for bpart, bpartdata in pairs(data.Modify or {}) do
					local position = bpartdata.Position or bpart.Position
					local rotation = bpartdata.Rotation or bpart.Rotation

					local newTween =
						TweenService:Create(bpart, bpartdata.TweenIn or data.TweenInfo or TweenInfo.new(0.2), {
							Transparency = bpartdata.Transparency or bpart.Transparency,
							CFrame = CFrame.new(position)
								* CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z)),
							Size = bpartdata.Size or bpart.Size,
						})
					bpart.CanCollide = bpartdata.CanCollide or false

					newTween:Play()
				end

				if data.Duration and data.Duration > 0 then
					deactivateid += 1
					local id = deactivateid

					task.delay(data.Duration, function()
						if id == deactivateid then
							deactivate()
						end
					end)
				end
			end
		end)

		for dpart, ddata in pairs(SCLI_CONFIGS.Classes.ButtonDeactivate) do
			if ddata.ButtonToDeactivate._id == part._id then
				dpart.Touched:Connect(function(hit)
					local humanoid = hit
						and hit._id
						and hit._id == playerCharacter._id
						and playerCharacter:FindFirstChildOfClass("Humanoid")

					local shouldDeactivate = (ddata.ActivateOnHumanoid ~= false and humanoid ~= nil)
						or (ddata.ActivateOnPart and hit:IsA("BasePart"))

					if shouldDeactivate and active then
						breakDelay = true
						deactivateid += 1
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
			local dir = CLI_Cache.Temp.IsPushable[hit]

			if dir then
				hit.CFrame = dir.CFrame
			end
		end)
	end

	local function applyBeatProperties(parts, properties)
		for _, part in ipairs(parts) do
			local tweenInfo = properties.TweenInfo

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

			local result = raycast(charPivot.Position + Vector3.new(0, 2, 0), Vector3.new(0, -2.25, 0), {})

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

			for part, data in pairs(SCLI_CONFIGS.Classes.Spinner) do
				if (part.Position - charPivot.Position).Magnitude < DCLI_CONFIGS.VALUES.ActivePartDistance then
					local dir = CLI_Cache.Temp.Spinner[part]
					part.CFrame *= (CFrame.Angles(dir[1] * dt, dir[2] * dt, dir[3] * dt))
				end
			end

			for part, data in pairs(SCLI_CONFIGS.Classes.Orbital) do
				if (part.Position - charPivot.Position).Magnitude < DCLI_CONFIGS.VALUES.ActivePartDistance then
					local cAngle = CLI_Cache.Temp.Orbital[part].curAngle
					local orbitCFrame = CLI_Cache.Temp.Orbital[part].orbitCFrame

					cAngle += math.rad(data.Speed) * dt
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

					CLI_Cache.Temp.Orbital[part].curAngle = cAngle
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

			for part in pairs(CLI_Cache.Temp.Conveyor) do
				local data = SCLI_CONFIGS.Classes.Conveyor[part]

				if data.BasedOnRotation then
					local movement = part.CFrame.LookVector * (data.BaseSpeed or 0) * dt
					playerCharacter:PivotTo(charPivot + movement)
					charPivot += movement
				else
					local movement = Vector3.new(data.XAxis or 0, data.YAxis or 0, data.ZAxis or 0) * dt
					playerCharacter:PivotTo(charPivot + movement)
					charPivot += movement
				end
			end

			if currentTouchedStandable and lastCf then
				local currentCf = currentTouchedStandable.CFrame
				local delta = currentCf * lastCf:Inverse()

				playerCharacter:PivotTo(delta * charPivot)
				charPivot *= delta
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
	end)
end)