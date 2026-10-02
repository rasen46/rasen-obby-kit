local module = {}
module.TypeChecker = {
	FunctionCheck = function(b)
		return b:IsA("BasePart")
	end,
}

module.Packages = {
	PlayerService = "PlayerService",
	Event = "Event",
}

function module.Boot(_, partReference)
	local PS = module.Packages.PlayerService
	local E = module.Packages.Event

	local plrEvent = E.Remotes.PlayerEvent

	if not plrEvent then
		return
	end

	partReference.Touched:Connect(function(hit)
		local humanoid = hit
			and PS.IsPlayerCharacter(hit)
			and PS.Data.CurrentCharacter:FindFirstChildOfClass("Humanoid")
		if humanoid then
			plrEvent:FireServer("damage", math.huge)
		end
	end)
end

return module
