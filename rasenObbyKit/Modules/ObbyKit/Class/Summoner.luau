local module = {}

module.TypeChecker = {
	Optional = {
		Duration = "number",
		ShowPreview = "boolean",
		PreviewTransparency = "number",
		ActivateOnHumanoid = "boolean",
		ActivateOnPart = "boolean",
	},
	Spawned = "table",
	TargetPosition = "Instance",
}

module.Packages = {
	PlayerService = "PlayerService",
}

function module.Boot(partReference, partData)
	local PS = module.Packages.PlayerService

	local activateOnHumanoid = partData.ActivateOnHumanoid ~= false
	local activateOnPart = partData.ActivateOnPart == true

	local showInstance = partData.ShowPreview and Instance.new("Part") or false
	local currentInstance

	local delayId = 0

	if showInstance then
		for propName, propValue in pairs(partData.Spawned) do
			showInstance[propName] = propValue
		end

		showInstance.Transparency = partData.PreviewTransparency or 0.5
		showInstance.Anchored = true
		showInstance.CanCollide = false

		showInstance.CFrame = partData.TargetPosition.CFrame
		showInstance.Parent = workspace
	end

	local function createNewPart()
		if currentInstance then
			currentInstance:Destroy()
		end

		delayId += 1
		local id = delayId

		currentInstance = Instance.new("Part")

		for propName, propValue in pairs(partData.Spawned) do
			currentInstance[propName] = propValue
		end

		currentInstance.CFrame = partData.TargetPosition.CFrame
		currentInstance.Parent = workspace

		if partData.Duration and partData.Duration ~= 0 then
			task.delay(partData.Duration, function()
				if currentInstance and delayId == id then
					currentInstance:Destroy()
					currentInstance = nil
				end
			end)
		end
	end

	partReference.Touched:Connect(function(hit)
		if activateOnHumanoid and PS.IsPlayerCharacter(hit) then
			createNewPart()
		elseif activateOnPart then
			if currentInstance then
				currentInstance:Destroy()
			end
			createNewPart()
		end
	end)
end

return module
