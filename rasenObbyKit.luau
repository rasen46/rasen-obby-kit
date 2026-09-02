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
version 0.2.1 dev release

please dont strip credits from this
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
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
		EnableQuickReset = false, -- Toggles the ability to Quick Reset (disabled for now due to problems with getting part properties)
		QRClearCheckpoints = false, -- Toggles if using Quick Reset will clear all-jump progress
		RespawnAtLastCheckPoint = true, -- Toggles if dying will spawn you at your last checkpoint or at the default SpawnLocation
		ActivePartDistance = 100, -- The maximum distance where spinners, orbital, and conveyors will remain active from the player (MIN: 50) (not inplemented yet)
		QuickResetDuration = 2, -- The amount of time required to have the Quick Reset Key being held down to reset the game

		AllJumpConfig = { -- configurations with how All-jump indicators look like (disabled for now due to CanCollide read/write restrictions)
			ShowIndicators = false,
			CentertoHRP = true,
			Color3 = Color3.new(1, 1, 1),
			Size = Vector3.new(0.25, 0.25, 0.25),
		},
	},
}

-- the obby kit (practically) (dont change this if ur playing the obby, as it will modify gameplay)
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
               TweenInfo = {duration, style, direction} -- sets a custom tween for movement instead of linear movement, overrides Duration arg (optional, default linear)
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
           	}
           	]]
		},
	},

	Types = {
		Standable = { -- this type defines if the player should be able to move with the part if they're on it, you dont need to give parts this type if they only move up and down
			-- should be in array format (ex: {workspace.Part2, workspace.Part})
		},
		IsPushable = { -- this will give parts unde this table to be repsawned from touching parts listed under the "PartRespawner" type
			-- should be in array format (ex: {workspace.Part2, workspace.Part})
		},
		PartRespawner = { -- this will repspawn parts listed as "IsPushable"
			-- should be in array format (ex: {workspace.Part2, workspace.Part})
		},
	},

	FFlagsEditor = { -- devtools, dont touch unless yk what ur doing
		["DFFlagExportTextToOutput"] = true,
		["FFlagUsePartInstanceOverVector3"] = true,
		["FFlagEnableTypeCheckerExperiment"] = true,
		["FFlageEnableWarningOnExtraProperties"] = true,
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
	},
}

local Checkpoints = {}
local cCount = 0

local holdingQR = false
local heldQRTime = 0

local playerAddedForce = Vector3.zero

local currentTouchedStandable = nil
local lastCf = nil

local elapsed = 0

local player = Players.LocalPlayer
local spawnLocation = Workspace:FindFirstChild("SpawnLocation")

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
		OrbitalOrigin = SCLI_CONFIGS.FFlagsEditor.FFlagUsePartInstanceOverVector3 and "Instance" or "Vector3",
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
		TargetPosition = SCLI_CONFIGS.FFlagsEditor.FFlagUsePartInstanceOverVector3 and "Instance" or "Vector3",
		Duration = "number",
		Optional = { LoopDelay = "number", TweenInfo = "table" },
	},
	Conveyor = {
		Optional = { XAxis = "number", YAxis = "number", ZAxis = "number", BasedOnRotation = "boolean" },
		Dependencies = { BasedOnRotation = { BaseSpeed = "number" } },
	},
	Teleporter = {
		TargetPosition = "Instance",
	},
	Standable = {
		FunctionCheck = function(b)
			return b:IsA("BasePart")
		end,
	},
	IsPushable = {},
	PartRespawner = {},
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
			local known = rules[propertyName]
				or (rules.Optional and rules.Optional[propertyName])
				or (rules.Dependencies and rules.Dependencies[propertyName])

			if not known then
				LOGF("warn", `[{className}][{object.Name}]: unknown property "{propertyName}"`)
				return false
			end
		end
	end

	return true
end

UIS.InputBegan:Connect(function(inp, pro)
	if pro then
		return
	end

	local keyEvent = DCLI_CONFIGS.KEYBINDS[inp.KeyCode]
	local character = player.Character
	if keyEvent then
		if not DCLI_CONFIGS.VALUES.LegitMode then
			if keyEvent == "SetCheckpoint" then
				cCount += 1
				Checkpoints[cCount] = character.Position
			elseif keyEvent == "GoToLatestCheckpoint" then
				local pos = Checkpoints[cCount] or spawnLocation.Position
				if not pos then
					return
				end
				character .Position = pos
			elseif keyEvent == "RemoveLatestCheckpoint" then
				if not Checkpoints[cCount] then
					return
				end
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
		local TweenTT = TweenService:Create(part, data.Tween or { data.Duration, Enum.EasingStyle.Linear }, {
			Position = SCLI_CONFIGS.FFlagsEditor.FFlagUsePartInstanceOverVector3 and data.TargetPosition.Position
				or data.TargetPosition,
		})
		local TweenTO = TweenService:Create(
			part,
			data.Tween or { data.Duration, Enum.EasingStyle.Linear },
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

	for part, data in pairs(SCLI_CONFIGS.Classes.Conveyor) do
		part.Touched:Connect(function(hit)
			CLI_Cache.Temp.Conveyor[part] = true
		end)

		part.TouchEnded:Connect(function(hit)
			CLI_Cache.Temp.Conveyor[part] = nil
		end)
	end

	for part, data in pairs(SCLI_CONFIGS.Classes.Teleporter) do
		part.Touched:Connect(function(hit)
			player.Character.Position = SCLI_CONFIGS.FFlagsEditor.FFlagUsePartInstanceOverVector3
					and data.TargetPosition.Position
				or data.TargetPosition
		end)
	end

	for i=1, #SCLI_CONFIGS.Types.Standable do
		local part = SCLI_CONFIGS.Types.Standable[i]
		part.Touched:Connect(function(hit)
			if currentTouchedStandable ~= part then
				currentTouchedStandable = part
				lastCf = part.CFrame
			end
		end)

		part.TouchEnded:Connect(function(hit)
			if currentTouchedStandable == part then
				currentTouchedStandable = nil
				lastCf = nil
			end
		end)
	end

	for i=1, #CLI_CONFIGS.Types.IsPushable do
		local part = SCLI_CONFIGS.Types.IsPushable[i]
		CLI_Cache.Temp.IsPushable[part] = { CFrame = part.CFrame }
	end

	for i=1, #SCLI_CONFIGS.Types.PartRespawner do
		local part = SCLI_CONFIGS.Types.PartRespawner[i]
		part.Touched:Connect(function(hit)
			local cachedir = CLI_Cache.Temp.IsPushable[hit]

			if cachedir then
				hit.CFrame = CLI_Cache.Temp.IsPushable[part].CFrame
			end
		end)
	end

	-- thread
	while true do
		local dt = task.wait()
		elapsed += dt

		playerAddedForce = Vector3.zero

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

		local character = player.Character

		for part, data in pairs(SCLI_CONFIGS.Classes.Spinner) do
			if (part.Position - character.Position).Magnitude > DCLI_CONFIGS.VALUES.ActivePartDistance then
				continue
			end

			part.CFrame *= CFrame.Angles(
				data.XAxis and math.rad(data.XAxis * dt) or 0,
				data.YAxis and math.rad(data.YAxis * dt) or 0,
				data.ZAxis and math.rad(data.ZAxis * dt) or 0
			)
		end

		for part, data in pairs(SCLI_CONFIGS.Classes.Orbital) do
			if (part.Position - character.Position).Magnitude > DCLI_CONFIGS.VALUES.ActivePartDistance then
				continue
			end

			local dir = CLI_Cache.Temp.Orbitial[part]

			if not dir then
				dir = {
					Angle = 0,
				}
				CLI_Cache.Temp.Orbitial[part] = dir
			end

			dir.Angle += math.rad(data.Speed) * dt

			local orbitRotation =
				CFrame.Angles(math.rad(data.XTilt or 0), math.rad(data.YRotation or 0), math.rad(data.ZAxis or 0))
			local offsetRotation = CFrame.Angles(
				math.rad(data.TiltXOffset or 0),
				math.rad(data.AngleYOffset or 0),
				math.rad(data.TiltZOffset or 0)
			)
			local orbitCFrame = orbitRotation * offsetRotation
			local off = orbitCFrame:VectorToWorldSpace(
				Vector3.new(
					math.cos(dir.Angle) * (data.OrbitalOffset or 0),
					0,
					math.sin(dir.Angle) * (data.OrbitalOffset or 0)
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
		end

		for part in pairs(CLI_Cache.Temp.Conveyor) do
			local data = SCLI_CONFIGS.Classes.Conveyor[part]

			if data.BasedOnRotation then
				playerAddedForce += part.CFrame.LookVector * (data.BaseSpeed or 0)
			else
				playerAddedForce += Vector3.new(data.XAxis or 0, data.YAxis or 0, data.ZAxis or 0)
			end
		end

		character.Position += playerAddedForce * dt

		if currentTouchedStandable and lastCf and character then
			local currentCf = currentTouchedStandable.CFrame
			local relativePosition = lastCf:PointToObjectSpace(character.Position)
			local newPosition = currentCf:PointToWorldSpace(relativePosition)
			character.Position += newPosition - character.Position
			lastCf = currentCf
		end
	end
end)