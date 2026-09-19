local TweenService = game:GetService("TweenService")

local module = {}
module.TypeChecker = {
	Duration = "number",
	Optional = {
		RespawnDuration = "number",
		RespawnDelay = "number",
		LerpTransparency = "boolean",
		TargetTransparency = "number",
		AllowParts = "boolean",
		AllowPlayer = "boolean",
		ConnectOnTrigger = "function",
		TargetPosition = "table",
		TweenInfo = "table",
		TweenOut = "table",
		TweenIn = "table",
	},
}
module.Packages = {
	PlayerService = "PlayerService",
}

function module.Boot(partReference, partData)
	local PS = module.Packages.PlayerService

	local canFade = true
	local originalTransparency = partReference.Transparency
	local origin = partReference.Position

	local targetPosition = partData.TargetPosition

	if typeof(targetPosition) == "Instance" and targetPosition:IsA("BasePart") then
		targetPosition = targetPosition.Position
	end

	targetPosition = targetPosition or origin

	local TweenTT = TweenService:Create(
		partReference,
		partData.TweenOut or partData.TweenInfo or TweenInfo.new(partData.Duration),
		{
			Transparency = partData.TargetTransparency or 1,
			Position = targetPosition,
		}
	)

	local TweenTO = TweenService:Create(
		partReference,
		partData.TweenIn or partData.TweenInfo or TweenInfo.new(partData.RespawnDuration or 1),
		{
			Transparency = originalTransparency,
			Position = origin,
		}
	)

	if partData.AllowPlayer == nil then
		partData.AllowPlayer = true
	end

	partReference.Touched:Connect(function(hit)
		if not canFade then
			return
		end

		if partData.AllowPlayer and PS.IsPlayerCharacter(hit) then
			canFade = false
			if partData.ConnectOnTrigger then
				partData.ConnectOnTrigger(partReference)
			end

			TweenTT:Play()
			TweenTT.Completed:Wait()
			partReference.CanCollide = false
			task.wait(partData.RespawnDelay or 1)

			partReference.CanCollide = true
			TweenTO:Play()
			TweenTO.Completed:Wait()

			canFade = true
		elseif partData.AllowParts then
			canFade = false
			if partData.ConnectOnTrigger then
				partData.ConnectOnTrigger(partReference)
			end

			TweenTT:Play()
			TweenTT.Completed:Wait()
			partReference.CanCollide = false
			task.wait(partData.RespawnDelay or 0)

			partReference.CanCollide = true
			TweenTO:Play()
			TweenTO.Completed:Wait()

			canFade = true
		end
	end)
end

return module
