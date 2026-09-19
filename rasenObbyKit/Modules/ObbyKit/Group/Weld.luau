local module = {}
local cache = {}
module.TypeChecker = {}

-- this is coming next update
function module.Init(partReference, partData) 
    cache[partReference._id] = partData
end

return module