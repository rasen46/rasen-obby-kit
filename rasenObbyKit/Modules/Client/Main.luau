local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local player = Players.LocalPlayer

local playerWalkspeed = 16
local playerJumpPower = 50

local module = {}

module.Packages = {
	ClientConfigs = "ClientConfigs",
	PlayerService = "PlayerService",
	TypeSolverv1 = "TypeSolverv1",
	Event = "Event",
	FFlags = "FFlags",
	Debugger = "Debugger",
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
	local E = Packages.Event
	local D = Packages.Debugger

	local MainBindable = E.Bindables.Main

	local PSData = PS.Data

	CC.DCLI_CONFIGS = DCLI_CONFIGS

	if not E.Remotes.PlayerEvent then
		LOGF("WARN", "Damage bricks will not work due to the server-side not being installed!")
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
	local toBoot = {}

	for _, CEntries in pairs(SCLI_CONFIGS) do
		for CEntryName, CEntryAttributes in pairs(CEntries) do
			local gotModule = ModuleLoader.Get(CEntryName)
			if gotModule then
				local Boot = gotModule.Boot

				if Boot then
					toBoot[Boot] = CEntryAttributes
				end

				local TypeChecker = gotModule.TypeChecker

				if TypeChecker then
					TypeSolver.Rules[CEntryName] = TypeChecker
				end

				local Thread = gotModule.Thread
				local threadPriority = gotModule.Options and gotModule.Options.ThreadPriority or 0

				if Thread then
					threadedCalls[#threadedCalls + 1] = {
						Thread = Thread,
						Priority = threadPriority,
					}
				end

				table.sort(threadedCalls, function(a, b)
					return a.Priority > b.Priority
				end)
			end
		end
	end

	if FFlags.FFlagEnableTypeCheckerExperiment then
		SCLI_CONFIGS = TypeSolver.TypeSolve(SCLI_CONFIGS)
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

	local function combine(c, A, B)
		local a = A.Position
		local b = B.Position

		local delta = b - a
		local length = delta.Magnitude

		c.Size = Vector3.new(length, 0.25, 0.25)
		c.CFrame = CFrame.new((a + b) * 0.5, b) * CFrame.Angles(0, math.rad(90), 0)
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

	for boot, CEntryAttributes in pairs(toBoot) do
		for partRef, partAttributes in pairs(CEntryAttributes) do
			boot(partRef, partAttributes)
		end
	end

	toBoot = nil

	RunService.Heartbeat:Connect(function(dt)
		if not PSData.CurrentCharacter then
			PSData.CurrentCharacter = character
		end

		PS.ChangePlayerPivot(character:GetPivot())

		for i = 1, #threadedCalls do
			threadedCalls[i].Thread(dt)
		end

		MainBindable:Fire("ThreadCallEnd")

		humanoid.WalkSpeed = playerWalkspeed + PSData.AddedWalkspeed
		humanoid.JumpPower = playerJumpPower + PSData.AddedJumppower

		if PSData.ShouldUpdatePlayerPivot then
			if character:GetPivot() ~= PS.GetPlayerCurrentPivot() then
				if FFlags.FFlagEnableDebugParts then
					D.CreateDebugPart(0, {
						CanCollide = false,
						Color = Color3.new(0, 0, 0.5),
						CFrame = PS.GetPlayerCurrentPivot() + Vector3.new(0, 2.5, 0),
						Size = Vector3.new(0.5, 0.5, 0.5),
					})
					local dbg = D.CreateDebugPart(0, {
						CanCollide = false,
						Color = Color3.new(0, 0, 1),
					})

					combine(
						dbg,
						character:GetPivot() + Vector3.new(0, 2.5, 0),
						PS.GetPlayerCurrentPivot() + Vector3.new(0, 2.5, 0)
					)
				end

				character:PivotTo(PS.GetPlayerCurrentPivot())
			end

			local velocity = PS.GetPlayerVelocity()

			if velocity ~= Vector3.zero and character.Velocity ~= velocity then
				if FFlags.FFlagEnableDebugParts then
					D.CreateDebugPart(0, {
						CanCollide = false,
						Color = Color3.new(0, 0.5, 0),
						CFrame = PS.GetPlayerCurrentPivot() + Vector3.new(0, 2.5, 0) + PS.GetPlayerVelocity(),
						Size = Vector3.new(0.5, 0.5, 0.5),
					})
					local dbg = D.CreateDebugPart(0, {
						CanCollide = false,
						Color = Color3.new(0, 1, 0),
					})

					combine(
						dbg,
						character:GetPivot() + Vector3.new(0, 2.5, 0),
						PS.GetPlayerCurrentPivot() + Vector3.new(0, 2.5, 0) + PS.GetPlayerVelocity()
					)
				end

				character.Velocity += velocity
				PS.SetPlayerVelocity(Vector3.zero)
			end
		end
	end)
end

return module
