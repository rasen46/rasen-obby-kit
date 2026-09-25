local ReplicatedStorage = game:GetService("ReplicatedStorage")

local module = {
	Remotes = {
		PlayerEvent = ReplicatedStorage:WaitForChild("rOK_PlayerEvent"),
	},
	BindableEvents = {

	},
	Instance = {
		new = function(instance) 
			if instance == "BindableEvent" then
				module.BindableEvent = {
					Connect = {},
					Once = {},
					Wait = {}
				}
			else
				error(`Could not create {instance}, when creating new Event`)
			end
		end,
	}
}

function module.fireBindable(binName, ...)
	local bin = module.Binables[binName]

	if bin then
		local Connect = bin.Connect
		local Once = bin.Once

		for i=1, #Connect do
			Connect(...)
		end

		for i=1, #Once do
			Once(...)
		end

		table.clear(bin.Once)
	end
end

function module.Instance()

return module
