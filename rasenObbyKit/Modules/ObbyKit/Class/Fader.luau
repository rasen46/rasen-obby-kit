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

function module.Init(partReference, partData)
	local canFade = true
	local originalTransparency = part.Transparency
	local origin = part.Position
	local TweenTT = TweenService:Create(part, partData.TweenOut or partData.TweenInfo or TweenInfo.new(partData.Duration), {
		Transparency = partData.TargetTransparency or 1,
		Position = partData.TargetPosition
				and (SCLI_CONFIGS.FFlagsEditor.FFlagUsePartInstanceOverVector3 and partData.TargetPosition.Position or partData.TargetPosition)
			or origin,
	})
	local TweenTO =
		TweenService:Create(part, partData.TweenIn or partData.TweenInfo or TweenInfo.new(partData.RespawnDuration or 1), {
			Transparency = originalTransparency,
			Position = origin,
		})

	if partData.AllowPlayer == nil then
		partData.AllowPlayer = true
	end

	part.Touched:Connect(function(hit)
		if not canFade then
			return
		end
		if partData.AllowPlayer and hit and hit._id == playerCharacter._id then
			canFade = false
			if partData.ConnectOnTrigger then
				partData.ConnectOnTrigger(part)
			end

			TweenTT:Play()
			TweenTT.Completed:Wait()
			part.CanCollide = false
			task.wait(partData.RespawnDelay or 1)

			part.CanCollide = true
			TweenTO:Play()
			TweenTO.Completed:Wait()

			canFade = true
		elseif partData.AllowParts then
			canFade = false
			if partData.ConnectOnTrigger then
				partData.ConnectOnTrigger(part)
			end

			TweenTT:Play()
			TweenTT.Completed:Wait()
			part.CanCollide = false
			task.wait(partData.RespawnDelay or 0)

			part.CanCollide = true
			TweenTO:Play()
			TweenTO.Completed:Wait()

			canFade = true
		end
	end)
end
function module.Thread(dt) end

return module
