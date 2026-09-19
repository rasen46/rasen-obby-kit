local currentTouchedStandable = nil
local lastCf = nil

local Standable = {}
local module = {}

module.Packages = {
	PlayerService = "PlayerService",
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

	local standable = instance and Standable[instance._id] and instance or nil

	local standableId = standable and standable._id
	local currentId = currentTouchedStandable and currentTouchedStandable._id

	if standableId ~= currentId then
		currentTouchedStandable = standable
		lastCf = standable and standable.CFrame or nil
		return
	end

	if not currentTouchedStandable or not lastCf then
		return
	end

	local currentCf = currentTouchedStandable.CFrame
	local playerCf = PS.GetPlayerCurrentPivot()

	local delta = currentCf * lastCf:Inverse()
	local newCf = delta * playerCf

	PS.ChangePlayerPivot(newCf)

	lastCf = currentCf
end

return module
