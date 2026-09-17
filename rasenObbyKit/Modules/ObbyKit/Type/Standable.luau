local module = {}
local cache = {}
module.TypeChecker = {}

function module.Init(partReference, partData) 
    cache[partReference._id] = partData
end
function module.Thread(dt) end

return module