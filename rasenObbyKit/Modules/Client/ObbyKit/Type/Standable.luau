local currentStandableId = nil
local lastCf = nil

local Standable = {}
local module = {}

module.Packages = {
	PlayerService = "PlayerService",
}

module.Options = {
	ThreadPriority = -5,
}

module.TypeChecker = {
	FunctionCheck = function(part)
		return part:IsA("BasePart")
	end,
}

function module.Boot(_, partReference)
	Standable[partReference._id] = true
end

function module.Thread(dt)
	local PS = module.Packages.PlayerService

	local rayResult = PS.StandingOn()
	local instance = rayResult and rayResult.Instance
	local standableId = instance and instance._id

	if not standableId or not Standable[standableId] then
		standableId = nil
		instance = nil
	end
	
	if standableId ~= currentStandableId then
		currentStandableId = standableId
		lastCf = instance and instance.CFrame or nil
		return
	end

	if not instance or not lastCf then
		return
	end

	local currentCf = instance.CFrame
	local playerCf = PS.Data.playerNextPivot
	local relativePlayerCf = lastCf:ToObjectSpace(playerCf)

	PS.Data.playerNextPivot = currentCf:ToWorldSpace(relativePlayerCf)
	lastCf = currentCf
end

return module