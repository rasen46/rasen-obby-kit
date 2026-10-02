local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local module = {}

module.Packages = {
	Debugger = "Debugger",
	FFlags = "FFlags",
}

module.Data = {
	CurrentCharacter = Character,
	CurrentVelocity = Character.Velocity,
	playerNextPivot = Character:GetPivot(),
	AddedWalkspeed = 0,
	AddedJumppower = 0,
	ShouldUpdatePlayerPivot = true,
}

function module.GetPlayerCurrentPivot()
	return module.Data.playerNextPivot
end

function module.ChangePlayerPivot(newPivot)
	module.Data.playerNextPivot = newPivot
end

function module.GetPlayerVelocity()
	return module.Data.CurrentVelocity
end

function module.AddPlayerVelocity(vector3)
	module.Data.CurrentVelocity += vector3
end

function module.SetPlayerVelocity(vector3)
	module.Data.CurrentVelocity = vector3
end

function module.AddPlayerPivotDelta(delta)
	module.Data.playerNextPivot = delta * module.Data.playerNextPivot
end

function module.ChangeHumanoidAttributes(attribute, value)
	local hum = Character:FindFirstChildOfClass("Humanoid")

	if attribute and string.lower(tostring(attribute)) == "walkspeed" then
		module.Data.AddedWalkspeed += value
	elseif attribute and string.lower(tostring(attribute)) == "jumppower" then
		module.Data.AddedJumppower += value
	end

	if hum and hum[attribute] then
		hum[attribute] += value
	end
end

function module.IsPlayerCharacter(model)
	return model and model._id and module.Data.CurrentCharacter._id == model._id
end

function module.StandingOn()
	local r = workspace:Blockcast(module.Data.playerNextPivot, Vector3.new(2, 2, 1), Vector3.new(0, 0.9, 0), {
		FilterDescendantsInstances = { module.Data.CurrentCharacter, module.Packages.Debugger.debug },
		FilterType = 0,
	})

	if module.Packages.FFlags.FFlagEnableDebugParts then
		module.Packages.Debugger.CreateDebugPart(0.2, {
			Size = Vector3.new(2, 2, 1),
			CFrame = module.Data.playerNextPivot + Vector3.new(0, 0.9, 0),
			CanCollide = false,
		})
	end

	return r
end

return module
