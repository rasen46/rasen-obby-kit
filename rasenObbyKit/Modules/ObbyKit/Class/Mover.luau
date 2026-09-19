local module = {}
local cache = {}
module.TypeChecker = {
	TargetPosition = "table",
	Optional = {
		LoopDelay = "number",
		TweenInfo = "table",
		TweenIn = "table",
		TweenOut = "table",
		Duration = "number",
	},
}

function module.Boot(partReference, partData)
	local TweenTT = TweenService:Create(partReference, partData.TweenIn or partData.TweenInfo or TweenInfo.new(partData.Duration), {
		Position = partData.TargetPosition.Position or partData.TargetPosition,
	})
	local TweenTO = TweenService:Create(
		partReference,
		partData.TweenOut or partData.TweenInfo or TweenInfo.new(partData.Duration),
		{ Position = partReference.Position }
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

return module
