--[[
	Alljump Utility (standalone version)
	by rasen46

	last update: 9/19/2026
	v1.0.0
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
	local CurCharacter = player.Character or player.CharacterAdded:Wait()
	local charPivot = CurCharacter:GetPivot()

	if keyEvent then
		if keyEvent == "SetCheckpoint" then
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

			CurCharacter:PivotTo(data)
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
