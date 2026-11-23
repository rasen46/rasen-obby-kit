--[[
	Alljump Utility (standalone version)
	by rasen46

	last update: 11/23/2026
	v1.0.4
]]

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local player = Players.LocalPlayer
local spawnLocation = workspace:FindFirstChild("SpawnLocation")

local CheckpointParts = {}
local Checkpoints = {}
local cCount = 0

local Configuration = {
	KEYBINDS = {
		[Enum.KeyCode.F] = "SetCheckpoint",
		[Enum.KeyCode.R] = "GoToLastCheck",
		[Enum.KeyCode.X] = "RemoveLastCheck",
	},
	AJ = {
		Size = Vector3.new(0.25, 0.25, 0.25),
		Color3 = Color3.new(1, 1, 1),
		Transparency = 0.5,
		ShowIndicators = true,
		CentertoHRP = true,
	},
}

if not spawnLocation then
	warn("Could not find any part named SpawnLocation, defaulting to 0, 0, 0")
	spawnLocation = { CFrame = CFrame.new(0, 0, 0) }
end

local function createAJPart()
	local newPart = Instance.new("Part")
	newPart.CanCollide = false
	newPart.Anchored = true
	newPart.Transparency = Configuration.AJ.ShowIndicators and Configuration.AJ.Transparency or 1
	newPart.Color = Configuration.AJ.Color3
	newPart.Size = Configuration.AJ.Size
	newPart.Parent = workspace
	return newPart
end

UIS.InputBegan:Connect(function(inp, pro)
	if pro then
		return
	end

	local keyEvent = Configuration.KEYBINDS[inp.KeyCode]
	local CurCharacter = player.Character
	local HRP = CurCharacter:FindFirstChild("HumanoidRootPart")
	local HRPCFrame = HRP.CFrame

	if keyEvent then
		if keyEvent == "SetCheckpoint" then
			cCount += 1

			local n = createAJPart()
			n.CFrame = if Configuration.AJ.CentertoHRP then HRPCFrame else (HRPCFrame + Vector3.new(0, 2.5, 0))

			CheckpointParts[cCount] = n
			Checkpoints[cCount] = { Pivot = HRPCFrame, Velocity = HRP.AssemblyLinearVelocity }
		elseif keyEvent == "GoToLastCheck" then
			local data = Checkpoints[cCount]
				or {
					Pivot = spawnLocation.CFrame
						+ Vector3.new(0, 2.5, 0)
						+ Vector3.new(0, (if spawnLocation.Size then spawnLocation.Size.Y else 0), 0),
					Velocity = Vector3.zero,
				}

			if not data then
				return
			end

			HRP.CFrame = data.Pivot
			HRP.AssemblyLinearVelocity = data.Velocity
		elseif keyEvent == "RemoveLastCheck" then
			if not Checkpoints[cCount] then
				return
			end

			CheckpointParts[cCount]:Destroy()
			CheckpointParts[cCount] = nil
			Checkpoints[cCount] = nil

			cCount -= 1
		end
	end
end)
