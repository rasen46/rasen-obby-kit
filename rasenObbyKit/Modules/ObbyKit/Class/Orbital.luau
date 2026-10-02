local module = {}
local cache = {}

module.TypeChecker = {
	OrbitalOrigin = "Instance",
	Distance = "number",
	Axis = "Vector3",

	Optional = {
		OrbitalFaceCenter = "boolean",
		AxisOffset = "Vector3",
		Speed = "number",
	},
}

function module.Boot(partReference, partData)
	local axisOffset = partData.AxisOffset or Vector3.zero

	cache[partReference] = {
		Angle = 0,
		Speed = math.rad(partData.Speed or 0),
		Distance = partData.Distance,
		Origin = partData.OrbitalOrigin,

		OrbitCFrame = CFrame.Angles(
			math.rad(partData.Axis.X + axisOffset.X),
			math.rad(partData.Axis.Y + axisOffset.Y),
			math.rad(partData.Axis.Z + axisOffset.Z)
		),

		FaceCenter = partData.OrbitalFaceCenter == true,
	}
end

function module.Thread(dt)
	for part, data in pairs(cache) do
		data.Angle += data.Speed * dt

		local offset = data.OrbitCFrame:VectorToWorldSpace(
			Vector3.new(math.cos(data.Angle) * data.Distance, 0, math.sin(data.Angle) * data.Distance)
		)

		local position = data.Origin.Position + offset

		if data.FaceCenter then
			part.CFrame = CFrame.lookAt(position, data.Origin.Position)
		else
			part.Position = position
		end
	end
end

return module
