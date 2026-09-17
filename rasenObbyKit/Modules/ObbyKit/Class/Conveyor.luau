local module = {}
local cache = {}
module.TypeChecker = {
	Optional = { XAxis = "number", YAxis = "number", ZAxis = "number", BasedOnRotation = "boolean" },
	Dependencies = { BasedOnRotation = { BaseSpeed = "number" } },
}

module.Packages = {
	PivotService = "PivotService",
}

function module.Init(partReference, partData)
	cache[partReference._id] = {
		Active = false,
		BasedOnRotation = partData.BasedOnRotation == true,
		BaseSpeed = partData.BaseSpeed or 0,
		Direction = Vector3.new(partData.XAxis or 0, partData.YAxis or 0, partData.ZAxis or 0),
	}

	part.Touched:Connect(function(hit)
		if hit and hit._id and hit._id == playerCharacter._id then
			cache[partReference._id].Active = true
		end
	end)

	part.TouchEnded:Connect(function(hit)
		if cache[partReference._id] then
			cache[partReference._id].Active = false
		end
	end)
end
function module.Thread(dt)
    local gotCache = cache[partReference._id]
	if not gotCache or not gotCache.Active then
		return
	end

	local currentPiv = module.Packages.PivotService.GetPlayerCurrentPivot()
	if gotCache.BasedOnRotation then
		module.Packages.PivotService.ChangePlayerPivot(
			currentPiv + partReference.CFrame.LookVector * gotCache.BaseSpeed * dt
		)
	else
		module.Packages.PivotService.ChangePlayerPivot(
			currentPiv + gotCache.Direction * dt
		)
	end
end

return module
