local module = {}
local cache = {}
module.TypeChecker = {
	Optional = { XAxis = "number", YAxis = "number", ZAxis = "number", BasedOnRotation = "boolean" },
	Dependencies = { BasedOnRotation = { BaseSpeed = "number" } },
}

module.Packages = {
	PlayerService = "PlayerService",
}

module.Options = {
	ThreadPriority = -4,
}

function module.Boot(partReference, partData)
	local ps = module.Packages.PlayerService
	cache[partReference] = {
		Active = false,
		BasedOnRotation = partData.BasedOnRotation and partData.BasedOnRotation == true,
		BaseSpeed = partData.BaseSpeed or 0,
		Direction = Vector3.new(partData.XAxis or 0, partData.YAxis or 0, partData.ZAxis or 0),
	}

	partReference.Touched:Connect(function(hit)
		if ps.IsPlayerCharacter(hit) then
			cache[partReference].Active = true
		end
	end)

	partReference.TouchEnded:Connect(function(hit)
		if cache[partReference] then
			cache[partReference].Active = false
		end
	end)
end

function module.Thread(dt)
	local PS = module.Packages.PlayerService

	for part, data in pairs(cache) do
		if not data.Active then
			continue
		end

		local velocity

		if data.BasedOnRotation then
			velocity = part.CFrame.LookVector * data.BaseSpeed
		else
			velocity = data.Direction
		end

		PS.AddPlayerVelocity(velocity)
	end
end

return module
