local cache = {}
local module = {}

module.TypeChecker = {
	Axis = "Vector3",

	Optional = {
		SpeedMultiplier = "number",
		Offset = "Vector3",
	},
}

function module.Boot(partReference, partData)
	cache[partReference] = {
		Angle = 0,
		SpeedMultiplier = partData.SpeedMultiplier or 1,
		Axis = partData.Axis or Vector3.zero,
		Offset = partData.AngleOffset or CFrame.identity,
	}
end

function module.Thread(dt)
	for part, data in pairs(cache) do
		data.Angle += math.rad(data.SpeedMultiplier) * dt

		local position = part.Position

		local rotation = data.Offset
			* CFrame.Angles(data.Axis.X * data.Angle, data.Axis.Y * data.Angle, data.Axis.Z * data.Angle)

		part.CFrame = CFrame.new(position) * rotation
	end
end

return module
