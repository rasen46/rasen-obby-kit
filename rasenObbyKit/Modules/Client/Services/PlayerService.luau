local Players = game:GetService("Players")
local RunService = game:GetService("RunService")

local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local touchCheck = false

local function getPlayerHitboxes()
	local hitboxes = {
		Torso = Character:WaitForChild("Torso Hitbox"),
		Head = Character:WaitForChild("Head Hitbox"),

		RightArm = Character:WaitForChild("Right Arm Hitbox"),
		LeftArm = Character:WaitForChild("Left Arm Hitbox"),

		RightLeg = Character:WaitForChild("Right Leg Hitbox"),
		LeftLeg = Character:WaitForChild("Left Leg Hitbox"),
	}

	return hitboxes
end

local function getAllHitParts(hitBox)
	local hits = {}
	local excluded = { Character }

	while true do
		local result = workspace:Blockcast(hitBox.CFrame, hitBox.Size, Vector3.new(0, 0.01, 0), {
			FilterDescendantsInstances = excluded,
			FilterType = 0,
		})

		if not result then
			break
		end

		table.insert(hits, result.Instance)
		table.insert(excluded, result.Instance)
	end

	return hits
end

local function getTouchedParts()
	local touching = {}

	local directions = {
		Vector3.xAxis,
		-Vector3.xAxis,
		Vector3.yAxis,
		-Vector3.yAxis,
		Vector3.zAxis,
		-Vector3.zAxis,
	}

	for hitBoxName, hitBox in pairs(getPlayerHitboxes()) do
		local hits = {}

		for i = 1, #directions do
			local direction = directions[i]
			local result = getAllHitParts(hitBox)

			if result then
				for i = 1, #result do
					hits[#hits + 1] = result[i]
				end
			end
		end

		touching[hitBoxName] = hits
	end

	return touching
end

local module = {}

module.Packages = {
	Debugger = "Debugger",
	FFlags = "FFlags",
	Event = "Event",
}

module.Data = {
	CurrentCharacter = Character,
	CurrentVelocity = Character.Velocity,
	playerNextPivot = Character:GetPivot(),
	AddedWalkspeed = 0,
	AddedJumppower = 0,
	ShouldUpdatePlayerPivot = true,
	TouchCheck = false,
}

module._Cache = {}

local function startTouchCheck()
	if module.Data.TouchCheck then
		return
	end

	module.Data.TouchCheck = true

	task.spawn(function()
		while next(module._Cache) do
			RunService.Heartbeat:Wait()

			local touchedParts = getTouchedParts()
			local hit = {}

			for _, hitParts in pairs(touchedParts) do
				for _, part in ipairs(hitParts) do
					if part and part._id then
						hit[part._id] = true
					end
				end
			end

			for id, binds in pairs(module._Cache) do
				if binds[3] and not hit[id] then
					binds[2]:Fire()
					binds[3] = false
				elseif not binds[3] and hit[id] then
					binds[1]:Fire()
					binds[3] = true
				end
			end
		end

		module.Data.TouchCheck = nil
	end)
end

function module.GetPlayerCurrentPivot()
	return module.Data.playerNextPivot
end

function module.ChangePlayerPivot(newPivot)
	module.Data.playerNextPivot = newPivot
end

function module.GetPlayerVelocity()
	return module.Data.CurrentVelocity
end

function module.AddPlayerVelocity(vector3)
	module.Data.CurrentVelocity += vector3
end

function module.SetPlayerVelocity(vector3)
	module.Data.CurrentVelocity = vector3
end

function module.AddPlayerPivotDelta(delta)
	module.Data.playerNextPivot = delta * module.Data.playerNextPivot
end

function module.ChangeHumanoidAttributes(attribute, value)
	local hum = Character:FindFirstChildOfClass("Humanoid")

	if attribute and string.lower(tostring(attribute)) == "walkspeed" then
		module.Data.AddedWalkspeed += value
	elseif attribute and string.lower(tostring(attribute)) == "jumppower" then
		module.Data.AddedJumppower += value
	end

	if hum and hum[attribute] then
		hum[attribute] += value
	end
end

function module.IsPlayerCharacter(model)
	return model and model._id and module.Data.CurrentCharacter._id == model._id
end

function module.StandingOn()
	local r = workspace:Blockcast(module.Data.playerNextPivot, Vector3.new(2, 2, 1), Vector3.new(0, 0.9, 0), {
		FilterDescendantsInstances = { module.Data.CurrentCharacter, module.Packages.Debugger.debug },
		FilterType = 0,
	})

	if module.Packages.FFlags.FFlagEnableDebugParts then
		module.Packages.Debugger.CreateDebugPart(0.2, {
			Size = Vector3.new(2, 2, 1),
			CFrame = module.Data.playerNextPivot + Vector3.new(0, 0.9, 0),
			CanCollide = false,
		})
	end

	return r
end

function module.SignalOnTouch(part)
	local E = module.Packages.Event

	local touchBind = E.Instance.new("BindableEvent")
	local touchEndBind = E.Instance.new("BindableEvent")

	if part.Destroying then
		part.Destroying:Once(function()
			touchBind:Destroy()
			touchEndBind:Destroy()

			module._Cache[part._id] = nil
		end)
	end

	module._Cache[part._id] = { touchBind, touchEndBind, false }
	startTouchCheck()

	return touchBind, touchEndBind
end

return module
