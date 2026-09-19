local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer
local rOK_PlayerEvent = ReplicatedStorage:WaitForChild("rOK_PlayerEvent", 1)

local playerWalkspeed = 16
local playerJumpPower = 50

local module = {}

module.Packages = {
	ClientConfigs = "ClientConfigs",
	PlayerService = "PlayerService",
	TypeSolverv1 = "TypeSolverv1",
	FFlags = "FFlags",
}

local function LOGF(LType, log)
	print(("[" .. tostring(LType):upper() .. "] " .. tostring(log)))
end

function module.Boot(SCLI_CONFIGS, DCLI_CONFIGS, ModuleLoader)
	local Packages = module.Packages
	
	local FFlags = Packages.FFlags
	local TypeSolver = Packages.TypeSolverv1
	local CC = Packages.ClientConfigs
	local PS = Packages.PlayerService
	
	local PSData = PS.Data
	
	CC.DCLI_CONFIGS = DCLI_CONFIGS
	
	if not rOK_PlayerEvent then
		LOGF(
			"WARN",
			"Damage bricks will not work due to the server-side not being installed!"
		)
	end
	
	local PlayerConfig = SCLI_CONFIGS.Player
	if PlayerConfig then
		playerWalkspeed = PlayerConfig.Walkspeed or 16
		playerJumpPower = PlayerConfig.JumpPower or 50
	end
	
	if FFlags.FFlagDisableClientSideObjects then
		return
	end

	local threadedCalls = {}
	
	for _, CEntries in pairs(SCLI_CONFIGS) do
		for CEntryName, CEntryAttributes in pairs(CEntries) do
			local gotModule = ModuleLoader.Get(CEntryName)
			if gotModule then
				local Boot = gotModule.Boot
				if Boot then
					for partRef, partAttributes in pairs(CEntryAttributes) do
						Boot(partRef, partAttributes)
					end
				end
				
				local TypeChecker = gotModule.TypeChecker
				
				if TypeChecker then
					TypeSolver.Rules[CEntryName] = TypeChecker
				end
				
				local Thread = gotModule.Thread
				
				if Thread then
					threadedCalls[#threadedCalls + 1] = Thread
				end
			end
		end
	end

	if FFlags.FFlagEnableTypeCheckerExperiment then
		TypeSolver.TypeSolve(SCLI_CONFIGS)
	end
	
	local character, humanoid
	
	local function updateCharacter(newCharacter)
		character = newCharacter

		if newCharacter then
			humanoid = newCharacter:FindFirstChildOfClass("Humanoid")
			PSData.CurrentCharacter = newCharacter
			PSData.playerNextPivot = newCharacter:GetPivot()
		else
			humanoid = nil
			PSData.CurrentCharacter = nil
		end
	end
	
	updateCharacter(player.Character)
	
	player.CharacterAdded:Connect(updateCharacter)
	player.CharacterRemoving:Connect(function(char)
		if character == char then
			character = nil
			humanoid = nil
			PSData.CurrentCharacter = nil
		end
	end)
	
	RunService.Heartbeat:Connect(function(dt)
		if not PSData.CurrentCharacter then
			PSData.CurrentCharacter = character
		end
		
		PS.ChangePlayerPivot(character:GetPivot())
		
		for i = 1, #threadedCalls do
			threadedCalls[i](dt)
		end
		
		humanoid.WalkSpeed = playerWalkspeed + PSData.AddedWalkspeed
		humanoid.JumpPower = playerJumpPower + PSData.AddedJumppower
		
		if PSData.ShouldUpdatePlayerPivot and character:GetPivot() ~= PS.GetPlayerCurrentPivot() then
			character:PivotTo(PS.GetPlayerCurrentPivot())
		end
	end)
end

return module