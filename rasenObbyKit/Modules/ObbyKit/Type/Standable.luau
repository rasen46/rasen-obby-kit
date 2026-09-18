local module = {}
local cache = {}
module.TypeChecker = {
	FunctionCheck = function(b)
		return b:IsA("BasePart")
	end,
}

function module.Init(partReference, partData)
	cache[partReference._id] = partData
end
function module.Thread(dt) end

return module
