local ReplicatedStorage = game:GetService("ReplicatedStorage")

local module = {
	Remotes = {},
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
				Active = true,
			}

			local _Events = newInst._Events

			function newInst.Event:Connect(func)
				if not newInst.Active then
					return
				end

				_Events.Connect[#_Events.Connect + 1] = func
			end

			function newInst.Event:Once(func)
				if not newInst.Active then
					return
				end

				_Events.Once[#_Events.Once + 1] = func
			end

			function newInst.Event:Wait()
				if not newInst.Active then
					return
				end

				local thread = coroutine.running()
				_Events.Wait[#_Events.Wait + 1] = thread

				return coroutine.yield()
			end

			function newInst:Fire(...)
				if not self.Active then
					return
				end

				local args = table.pack(...)

				local once = _Events.Once
				local waiting = _Events.Wait

				_Events.Once = {}
				_Events.Wait = {}

				for i = 1, #_Events.Connect do
					_Events.Connect[i](table.unpack(args, 1, args.n))
				end

				for i = 1, #once do
					once[i](table.unpack(args, 1, args.n))
				end

				for i = 1, #waiting do
					task.spawn(coroutine.resume, waiting[i], table.unpack(args, 1, args.n))
				end
			end

			function newInst:Destroy()
				if not self.Active then
					return
				end

				self.Active = false

				table.clear(_Events.Connect)
				table.clear(_Events.Once)
				table.clear(_Events.Wait)

				for name, bindable in pairs(module.Bindables) do
					if bindable == self then
						module.Bindables[name] = nil
					end
				end
			end

			return newInst
		end,
	},
}

function module.Init()
	local newBindable = module.Instance.new("BindableEvent")

	module.Bindables.Main = newBindable
	module.Remotes.PlayerEvent = ReplicatedStorage:WaitForChild("rOK_PlayerEvent", 1) or false
end

return module
