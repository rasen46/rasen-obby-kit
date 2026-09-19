local module = {}
local cache = {}
module.TypeChecker = {
	Optional = {
		Duration = "number",
		Walkspeed = "number",
		Jumppower = "number",
	},
}

module.Packages = {
	PlayerService = "PlayerService",
}

function module.Boot(partReference, partData)
	local active = false
	local ps = module.Packages.PlayerService

	local jp = partData.Jumppower or 0
	local ws = partData.Walkspeed or 0

	partReference.Touched:Connect(function(hit)
		if active then
			return
		end

		if hit and ps.IsPlayerCharacter(hit) then
			active = true

			ps.ChangeHumanoidAttributes("walkspeed", ws)
			ps.ChangeHumanoidAttributes("jumppower", jp)

			task.delay(partData.Duration or 1, function()
				ps.ChangeHumanoidAttributes("walkspeed", -ws)
				ps.ChangeHumanoidAttributes("jumppower", -jp)

				active = false
			end)
		end
	end)
end

return module
