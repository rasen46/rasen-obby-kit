local module = {}
local cache = {}
module.TypeChecker = {
	OrbitalOrigin = SCLI_CONFIGS.FFlagsEditor.FFlagUsePartInstanceOverVector3 and "table" or "Vector3",
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

function module.Init(partReference, partData)
	local origin = partpartData.OrbitalOrigin

	cache[partReference._id] = {
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
function module.Thread(dt) end

return module
