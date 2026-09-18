local module = {}
module.TypeChecker = {
    Damage = "number"
}

module.Packages = {
	PlayerService = "PlayerService",
}

function module.Init(partReference, partData)
    local ps = module.Packages.PlayerService
	partReference.Touched:Connect(function(hit)
		local humanoid = hit
			and hit._id
			and hit._id == ps.Data.CurrentCharacter._id
			and ps.Data.CurrentCharacter:FindFirstChildOfClass("Humanoid")

		if humanoid then
			rOK_PlayerEvent:FireServer("damage", partData.Damage)
		end
	end)
end

return module
