local module = {}
local cache = {}
module.TypeChecker = {
	TargetPosition = "table",
	Optional = {
		AllowParts = "boolean",
		AllowPlayer = "boolean",
	},
}

module.Packages = {
	PlayerService = "PlayerService",
}

function module.Init(partReference, partData)
	cache[partReference._id] = partData

	if data.AllowPlayer == nil then
		data.AllowPlayer = true
	end

    local ps = module.Packages.PlayerService

	part.Touched:Connect(function(hit)
		if data.AllowPlayer and ps.IsPlayerCharacter(hit) then
			ps.ChangePlayerPivot(
				FFlags.FFlagUsePartInstanceOverVector3 and data.TargetPosition.CFrame or CFrame.new(data.TargetPosition)
			)
		elseif data.AllowParts then
			hit.CFrame = FFlags.FFlagUsePartInstanceOverVector3 and data.TargetPosition.CFrame
				or CFrame.new(data.TargetPosition)
		end
	end)
end

return module