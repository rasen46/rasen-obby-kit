local module = {}
module.TypeChecker = {
	FunctionCheck = function(b)
		return b:IsA("BasePart")
	end,
}

module.Packages = {
	PlayerService = "PlayerService",
	RemoteEvent = "RemoteEvent",
}

function module.Boot(_, partReference)
	local PS = module.Packages.PlayerService
	local RE = module.Packages.RemoteEvent

	local plrEvent = RE.PlayerEvent

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
