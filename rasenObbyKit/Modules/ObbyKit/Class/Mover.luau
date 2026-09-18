local module = {}
local cache = {}
module.TypeChecker = {
	TargetPosition = SCLI_CONFIGS.FFlagsEditor.FFlagUsePartInstanceOverVector3 and "table" or "Vector3",
	Optional = {
		LoopDelay = "number",
		TweenInfo = "table",
		TweenIn = "table",
		TweenOut = "table",
		Duration = "number",
	},
}

function module.Init(partReference, partData)
	local TweenTT = TweenService:Create(part, partData.TweenIn or partData.TweenInfo or TweenInfo.new(partData.Duration), {
		Position = FFlags.FFlagUsePartInstanceOverVector3 and partData.TargetPosition.Position or partData.TargetPosition,
	})
	local TweenTO = TweenService:Create(
		part,
		partData.TweenOut or partData.TweenInfo or TweenInfo.new(partData.Duration),
		{ Position = part.Position }
	)

	task.defer(function()
		while task.wait() do
			TweenTT:Play()
			TweenTT.Completed:Wait()
			task.wait(partData.LoopDelay)

			TweenTO:Play()
			TweenTO.Completed:Wait()
			task.wait(partData.LoopDelay)
		end
	end)
end
function module.Thread(dt) end

return module
