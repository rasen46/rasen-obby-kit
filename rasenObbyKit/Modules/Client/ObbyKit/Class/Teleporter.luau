local module = {}
local cache = {}
module.TypeChecker = {
	TargetPosition = "Instance",
	Optional = {
		AllowParts = "boolean",
		AllowPlayer = "boolean",
	},
}

module.Packages = {
	PlayerService = "PlayerService",
	Event = "",
}

function module.Boot(partReference, partData)
	cache[partReference._id] = partData

	if partData.AllowPlayer == nil then
		partData.AllowPlayer = true
	end

	local PS = module.Packages.PlayerService
	local E = module.Packages.Event

	local teleport = false

	partReference.Touched:Connect(function(hit)
		if partData.AllowPlayer and PS.IsPlayerCharacter(hit) then
			local target = partData.TargetPosition
			local cf = target.CFrame or CFrame.new(target)

			teleport = cf
		elseif partData.AllowParts then
			hit.CFrame = partData.TargetPosition.CFrame or CFrame.new(partData.TargetPosition)
		end
	end)

	E.Bindables.Main.Event:Connect(function(EType)
		if EType == "ThreadCallEnd" and teleport then
			PS.ChangePlayerPivot(teleport)
			teleport = nil
		end
	end)
end

return module
