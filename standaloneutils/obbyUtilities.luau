--[[
	Obby Utilities (standalone version)
	by rasen46

	last update: 9/20/2026
	v1.0.1
]]

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer
local character = player.Character
local camera = Workspace.CurrentCamera

local Configuration = {
	KEYBINDS = {
		-- alljump
		[Enum.KeyCode.F] = "SetCheckpoint",
		[Enum.KeyCode.R] = "GoToLastCheck",
		[Enum.KeyCode.X] = "RemoveLastCheck",

		-- noclip
		[Enum.KeyCode.M] = "NoclipSlow",
		[Enum.KeyCode.N] = "NoclipSpeed",
		[Enum.KeyCode.Comma] = "NoclipSpeedReset",
		[Enum.KeyCode.One] = "Noclip",
		[Enum.KeyCode.Space] = "NoclipUp",
		[Enum.KeyCode.LeftControl] = "NoclipDown",
	},

	AJ = {
		Size = Vector3.new(0.25, 0.25, 0.25),
		Color3 = Color3.new(1, 1, 1),
		Transparency = 0.5,
		ShowIndicators = true,
		CentertoHRP = true,
	},

	NC = {
		NoclipSpeedDefault = 50,
		NoclipSpeedIncrement = 5,
	}
}

local keys = {
	W = false,
	A = false,
	S = false,
	D = false,
	up = false,
	down = false,
}

local noclip = false
local speed = Configuration.NC.NoclipSpeedDefault
local targetPosition

local cCount = 0
local Checkpoints = {}
local CheckpointParts = {}

local spawnLocation = workspace:FindFirstChild("SpawnLocation")
local spawnCFrame = spawnLocation and spawnLocation.CFrame or CFrame.new(0, 0, 0)

if not spawnLocation then
	warn("Could not find any part named SpawnLocation, defaulting to 0, 0, 0")
end

local function createAJPart()
	local part = Instance.new("Part")

	part.Anchored = true
	part.CanCollide = false

	part.Size = Configuration.AJ.Size
	part.Color = Configuration.AJ.Color3
	part.Transparency = Configuration.AJ.ShowIndicators and Configuration.AJ.Transparency or 1

	part.Parent = Workspace

	return part
end

UIS.InputBegan:Connect(function(inp, pro)
	if pro then
		return
	end

	local key = inp.KeyCode.Name
	local keyEvent = Configuration.KEYBINDS[inp.KeyCode]
	local CurChar = player.Character
	local charPivot = CurChar:GetPivot()

	if keys[key] ~= nil then
		keys[key] = true
	end

	if keyEvent == "Noclip" then
		noclip = not noclip
		if noclip then
			targetPosition = player.Character:GetPivot()
		end
	elseif keyEvent == "NoclipUp" then
		keys.up = true
	elseif keyEvent == "NoclipDown" then
		keys.down = true
	elseif keyEvent == "SetCheckpoint" then
		cCount += 1

		local n = createAJPart()
		n.CFrame = Configuration.AJ.CentertoHRP and (charPivot + CFrame.new(0, 2.5, 0)) or charPivot

		CheckpointParts[cCount] = n
		Checkpoints[cCount] = charPivot
	elseif keyEvent == "GoToLastCheck" then
		local data = Checkpoints[cCount] or spawnLocation.CFrame

		if not data then
			return
		end

		CurChar:PivotTo(data)
	elseif keyEvent == "RemoveLastCheck" then
		if not Checkpoints[cCount] then
			return
		end

		CheckpointParts[cCount]:Destroy()
		CheckpointParts[cCount] = nil
		Checkpoints[cCount] = nil

		cCount -= 1
	elseif keyEvent == "NoclipSlow" then
		speed -= Configuration.NC.NoclipSpeedIncrement
	elseif keyEvent == "NoclipSpeed" then
		speed += Configuration.NC.NoclipSpeedIncrement
	elseif keyEvent == "NoclipSpeedReset" then
		speed = Configuration.NC.NoclipSpeedDefault
	end

	speed = math.max(0,speed)
end)

UIS.InputEnded:Connect(function(inp)
	local key = inp.KeyCode.Name
	local keyEvent = Configuration.KEYBINDS[inp.KeyCode]

	if keys[key] ~= nil then
		keys[key] = false
	elseif keyEvent == "NoclipUp" then
		keys.up = false
	elseif keyEvent == "NoclipDown" then
		keys.down = false
	end
end)

RunService.Heartbeat:Connect(function(dt)
	if not noclip then
		return
	end

	local character = player.Character
	if not character then
		return
	end

	local cameraCF = Workspace.CurrentCamera.CFrame
	local forward = Vector3.new(cameraCF.LookVector.X, 0, cameraCF.LookVector.Z)
	local right = Vector3.new(cameraCF.RightVector.X, 0, cameraCF.RightVector.Z)

	if forward.Magnitude > 0 then
		forward = forward.Unit
	end
	if right.Magnitude > 0 then
		right = right.Unit
	end

	local direction = Vector3.zero

	if keys.W then
		direction += forward
	end
	if keys.S then
		direction -= forward
	end
	if keys.D then
		direction += right
	end
	if keys.A then
		direction -= right
	end

	if keys.up then
		direction += Vector3.yAxis
	end
	if keys.down then
		direction -= Vector3.yAxis
	end

	if direction.Magnitude > 0 then
		direction = direction.Unit
	end

	local pivot = targetPosition
	local newPosition = pivot.Position + direction * speed * dt
	local final = CFrame.lookAt(newPosition, newPosition + forward)

	targetPosition = final
	character:PivotTo(final)
end)
