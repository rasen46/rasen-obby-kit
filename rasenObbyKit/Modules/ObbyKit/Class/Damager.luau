local module = {}
module.TypeChecker = {
    Damage = "number"
}

module.Packages = {
	PlayerService = "PlayerService",
	RemoteEvent = "RemoteEvent"
}

function module.Boot(partReference, partData)
    local PS = module.Packages.PlayerService
    local RE = module.Packages.RemoteEvent
    
    local plrEvent = RE.PlayerEvent
    
    if not plrEvent then return end
    
	partReference.Touched:Connect(function(hit)
		local humanoid = hit
			and PS.IsPlayerCharacter(hit)
			and PS.Data.CurrentCharacter:FindFirstChildOfClass("Humanoid")

		if humanoid then
			plrEvent:FireServer("damage", partData.Damage)
		end
	end)
end

return module
