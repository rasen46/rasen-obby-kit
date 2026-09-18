local module = {}
module.TypeChecker = {}

module.Packages = {
	TempStorage = "TempStorage",
}

function module.Init(partReference, partData)
	local ts = module.Packages.TempStorage
	if not ts.GetClass("Pushables") then
		ts.AddClass("Pushables")
	end

	ts.AppendEntry("Pushables", partReference._id, { CFrame = partReference.CFrame })
end

return module