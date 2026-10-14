local TweenService = game:GetService("TweenService")
local DEFAULT_TWEEN = TweenInfo.new(0.2)
local module = {}

module.TypeChecker = {
	Optional = {
		Duration = "number",
		ActivateOnHumanoid = "boolean",
		ActivateOnPart = "boolean",
		Modify = "table",
		OnActivate = "function",
		OnDeactivate = "function",
	},
}

module.Packages = {
	TempStorage = "TempStorage",
	PlayerService = "PlayerService",
}

function module.Boot(partReference, partData)
	local ts = module.Packages.TempStorage
	local ps = module.Packages.PlayerService

	local modify = partData.Modify or {}

	local active = false
	local deactivateId = 0

	local onActivate = partData.OnActivate
	local onDeactivate = partData.OnDeactivate

	local activateOnHumanoid = partData.ActivateOnHumanoid ~= false
	local activateOnPart = partData.ActivateOnPart == true

	local duration = partData.Duration or 1
	local defaultTween = partData.TweenInfo or DEFAULT_TWEEN

	local original = {}
	local modified = {}

	for bpart, data in pairs(modify) do
		local position = data.Position or bpart.Position
		local rotation = data.Rotation or bpart.Rotation

		original[bpart] = {
			Transparency = bpart.Transparency,
			CFrame = bpart.CFrame,
			CanCollide = bpart.CanCollide,
			Size = bpart.Size,
		}

		modified[bpart] = {
			Transparency = data.Transparency ~= nil and data.Transparency or bpart.Transparency,

			CFrame = CFrame.new(position)
				* CFrame.Angles(math.rad(rotation.X), math.rad(rotation.Y), math.rad(rotation.Z)),

			Size = data.Size or bpart.Size,

			CanCollide = data.CanCollide == true,

			TweenIn = data.TweenIn or defaultTween,
			TweenOut = data.TweenOut or DEFAULT_TWEEN,
		}
	end

	local function deactivate()
		if not active then
			return
		end

		active = false

		if onDeactivate then
			onDeactivate(partReference)
		end

		for bpart, target in pairs(modified) do
			local originalData = original[bpart]

			bpart.CanCollide = originalData.CanCollide

			TweenService:Create(bpart, target.TweenOut, {
				Transparency = originalData.Transparency,
				CFrame = originalData.CFrame,
				Size = originalData.Size,
			}):Play()
		end
	end

	local function activate()
		if active then
			return
		end

		active = true

		if onActivate then
			onActivate(partReference)
		end

		for bpart, target in pairs(modified) do
			bpart.CanCollide = target.CanCollide

			TweenService:Create(bpart, target.TweenIn, {
				Transparency = target.Transparency,
				CFrame = target.CFrame,
				Size = target.Size,
			}):Play()
		end

		if duration and duration > 0 then
			deactivateId += 1

			local id = deactivateId

			task.delay(duration, function()
				if id == deactivateId then
					deactivate()
				end
			end)
		end
	end

	partReference.Touched:Connect(function(hit)
		if not hit then
			return
		end

		local player = activateOnHumanoid and ps.IsPlayerCharacter(hit)

		if player ~= nil or (activateOnPart and hit:IsA("BasePart")) then
			activate()
		end
	end)

	task.defer(function()
		for dpart, ddata in pairs(ts.GetClass("ButtonDeactivate")) do
			local button = ddata.ButtonToDeactivate

			if button and button._id == partReference._id then
				local deactivateOnHumanoid = ddata.ActivateOnHumanoid ~= false
				local deactivateOnPart = ddata.ActivateOnPart == true

				dpart.Touched:Connect(function(hit)
					if not active or not hit then
						return
					end

					local player = activateOnHumanoid and ps.IsPlayerCharacter(hit)

					if player ~= nil or (deactivateOnPart and hit:IsA("BasePart")) then
						deactivateId += 1
						deactivate()
					end
				end)
			end
		end
	end)
end

return module
