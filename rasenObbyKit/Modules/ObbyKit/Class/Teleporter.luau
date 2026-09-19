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

function module.Boot(partReference, partData)
	cache[partReference._id] = partData

	if partData.AllowPlayer == nil then
		partData.AllowPlayer = true
	end

	local ps = module.Packages.PlayerService

	partReference.Touched:Connect(function(hit)
		if partData.AllowPlayer and ps.IsPlayerCharacter(hit) then
			local target = partData.TargetPosition
			local cf = target.CFrame or CFrame.new(target)

			ps.Data.CurrentCharacter:PivotTo(cf)
		elseif partData.AllowParts then
			hit.CFrame = partData.TargetPosition.CFrame or CFrame.new(partData.TargetPosition)
		end
	end)
end

return module
