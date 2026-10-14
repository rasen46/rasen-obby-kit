local module = {}
local cache = {}
module.TypeChecker = {}

module.Packages = {
	TempStorage = "TempStorage",
}

function module.Boot(partReference, partData)
	local ts = module.Packages.TempStorage
	if not ts.GetClass("Pushables") then
		ts.AddClass("Pushables")
	end

	partReference.Touched:Connect(function(hit)
		local dir = ts.GetClass("Pushables")[hit._id]

		if dir then
			hit.CFrame = dir.CFrame
		end
	end)
end

return module
