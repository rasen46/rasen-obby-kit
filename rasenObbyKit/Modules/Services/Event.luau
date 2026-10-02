local ReplicatedStorage = game:GetService("ReplicatedStorage")

local module = {
	Remotes = {
		PlayerEvent = ReplicatedStorage:WaitForChild("rOK_PlayerEvent"),
	},
	Bindables = {},
	Instance = {
		new = function(instance)
			if instance ~= "BindableEvent" then
				error(`Could not create {instance}, as no instance exists`)
			end

			local newInst = {
				_Events = {
					Connect = {},
					Once = {},
					Wait = {},
				},
				Event = {},
			}

			local _Events = newInst._Events
			
			function newInst.Event:Connect(func)
				_Events.Connect[#_Events.Connect + 1] = func
			end
			
			function newInst.Event:Once(func)
				_Events.Once[#_Events.Once + 1] = func
			end

			function newInst.Event:Wait()
				local thread = coroutine.running()

				_Events.Wait[#_Events.Wait + 1] = thread

				return coroutine.yield()
			end

			function newInst:Fire(...)
				local args = table.pack(...)
				
				local once = _Events.Once
				local waiting = _Events.Wait
				_Events.Wait = {}

				_Events.Once = {}
				
				for i=1, #_Events.Connect do
					_Events.Connect[i](table.unpack(args, 1, args.n))
				end 
				
				for i=1, #once do
					once[i](table.unpack(args, 1, args.n))
				end
				
				for i = 1, #waiting do
					task.spawn(
						coroutine.resume,
						waiting[i],
						table.unpack(args, 1, args.n)
					)
				end
			end
			return newInst
		end,
	},
}

function module.Init()
	local newBindable = module.Instance.new("BindableEvent")

	module.Bindables.Main = newBindable
end

return module