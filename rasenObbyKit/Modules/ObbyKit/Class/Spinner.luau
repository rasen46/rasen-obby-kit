local module = {}
local cache = {}
module.TypeChecker = {
	Optional = {
		XAxis = "number",
		YAxis = "number",
		ZAxis = "number",
		AngleXOffset = "number",
		AngleYOffset = "number",
		AngleZOffset = "number",
	},
}

function module.Init(partReference, partData)
	part.Rotation += Vector3.new(partData.AngleXOffset or 0, partData.AngleYOffset or 0, partData.AngleZOffset or 0)
	cache[partReference._id] = { math.rad(partData.XAxis or 0), math.rad(partData.YAxis or 0), math.rad(partData.ZAxis or 0) }
end
function module.Thread(dt) end

return module
