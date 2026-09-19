local cache = {}
local module = {}

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

function module.Boot(partReference, partData)
	local axis = Vector3.new()

	cache[partReference] = {
		OriginalCFrame = partReference.CFrame,
		Angle = 0,
		Speed = math.rad(partData.Speed or 180),
		Axis = Vector3.new(
		    math.rad(partData.XAxis or 0), math.rad(partData.YAxis or 0), math.rad(partData.ZAxis or 0)
		),
		Offset = CFrame.Angles(
			math.rad(partData.AngleXOffset or 0),
			math.rad(partData.AngleYOffset or 0),
			math.rad(partData.AngleZOffset or 0)
		),
	}
end

function module.Thread(dt)
	for part, data in pairs(cache) do
		part.CFrame = part.CFrame * CFrame.Angles(data.Axis.X * dt, data.Axis.Y * dt, data.Axis.Z * dt) 
	end
end

return module