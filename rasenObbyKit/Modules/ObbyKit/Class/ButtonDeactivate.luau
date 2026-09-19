local module = {}

module.TypeChecker = {
	ButtonToDeactivate = "table",
	Optional = {
		ActivateOnHumanoid = "boolean",
		ActivateOnPart = "boolean",
	},
}

module.Packages = {
	TempStorage = "TempStorage"
}

function module.Boot(partReference, partData)
	local ts = module.Packages.TempStorage
	
	if not ts.GetClass("ButtonDeactivate")
then
	    ts.AddClass("ButtonDeactivate")
	end
	
	ts.AppendEntry("ButtonDeactivate", partReference, partData)
end

return module