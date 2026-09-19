local module = {}
local cache = {}
module.TypeChecker = {
	OrbitalOrigin = "table",
	OrbitalOffset = "number",
	Optional = {
		OrbitalFaceCenter = "boolean",
		XTilt = "number",
		YRotation = "number",
		ZTilt = "number",
		TiltXOffset = "number",
		AngleYOffset = "number",
		TiltZOffset = "number",
		Speed = "number",
	},
}

function module.Boot(partReference, partData)
	local origin = partData.OrbitalOrigin

	cache[partReference] = {
		Angle = 0,
		Speed = math.rad(partData.Speed or 0),
		Offset = partData.OrbitalOffset or 0,
		Origin = origin,
		OrbitCFrame = CFrame.Angles(
			math.rad((partData.XTilt or 0) + (partData.TiltXOffset or 0)),
			math.rad((partData.YRotation or 0) + (partData.AngleYOffset or 0)),
			math.rad((partData.ZTilt or 0) + (partData.TiltZOffset or 0))
		),
		FaceCenter = partData.OrbitalFaceCenter == true,
	}
end

function module.Thread(dt)
	for part, data in pairs(cache) do
		data.Angle += data.Speed * dt
		local offset = data.OrbitCFrame:VectorToWorldSpace(
			Vector3.new(math.cos(data.Angle) * data.Offset, 0, math.sin(data.Angle) * data.Offset)
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
