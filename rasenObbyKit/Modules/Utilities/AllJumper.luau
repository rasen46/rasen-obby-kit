local UIS = game:GetService("UserInputService")
local spawnLocation = workspace:FindFirstChild("SpawnLocation")

local CheckpointParts = {}
local Checkpoints = {}
local cCount = 0

local module = {}

module.Packages = {
	FFlags = "FFlags",
	ClientConfigs = "ClientConfigs",
	PlayerService = "PlayerService",
}

function module.Init()
	local FFLags = module.Packages.FFlags
	local CC = module.Packages.ClientConfigs
	local PS = module.Packages.PlayerService

	if not spawnLocation then
		print("[WARN]: Could not find any part named SpawnLocation, defaulting to 0, 0, 0")
		spawnLocation = { CFrame = CFrame.new(0, 0, 0) }
	end

	local function createAJPart()
		local newPart = Instance.new("Part")
		newPart.CanCollide = false
		newPart.Anchored = true
		newPart.Transparency = CC.DCLI_CONFIGS.VALUES.AllJumpConfig.ShowIndicators and 0.5 or 1
		newPart.Color = CC.DCLI_CONFIGS.VALUES.AllJumpConfig.Color3
		newPart.Size = CC.DCLI_CONFIGS.VALUES.AllJumpConfig.Size
		newPart.Parent = workspace

		return newPart
	end

	UIS.InputBegan:Connect(function(inp, pro)
		if pro then
			return
		end

		local keyEvent = CC.DCLI_CONFIGS.KEYBINDS[inp.KeyCode]
		local playerCharacter = PS.Data.CurrentCharacter
		local charPivot = playerCharacter:GetPivot() :: CFrame

		if keyEvent then
			if not CC.DCLI_CONFIGS.VALUES.LegitMode then
				if keyEvent == "SetCheckpoint" then
					cCount += 1
					local n = createAJPart()
					n.CFrame = CC.DCLI_CONFIGS.VALUES.AllJumpConfig.CentertoHRP and (charPivot + CFrame.new(0, 2.5, 0))
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
		end
	end)
end

return module
