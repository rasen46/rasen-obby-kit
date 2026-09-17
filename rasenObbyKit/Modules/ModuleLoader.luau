local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Loader = {}
Loader.Loaded = {}

local loadedModules = 0

local function requireFolder(folder)
	for _, moduleScript in ipairs(folder:GetDescendants()) do
		if not moduleScript:IsA("ModuleScript") then
			continue
		end

		if Loader.Loaded[moduleScript.Name] then
			print(("[Loader/WARN]: Duplicate module '%s'"):format(moduleScript.Name))
			continue
		end

		local success, module = xpcall(function()
			return require(moduleScript)
		end, function(err)
			return tostring(err)
		end)

		if success then
			Loader.Loaded[moduleScript.Name] = module
			loadedModules += 1
		else
			print(("[Loader/WARN]: Failed to require %s\n%s"):format(moduleScript.Name, module))
		end
	end
end

function Loader.LoadAll()
	local startTime = os.clock()
	print("[Loader/INFO]: rasen46 module loader v1.2")
	requireFolder(ReplicatedStorage.Modules.Shared)

	if RunService:IsClient() then
		requireFolder(ReplicatedStorage.Modules.Client)
	else
		--requireFolder(game:GetService("ServerStorage").Server)
	end
end

function Loader.Init()
	for moduleName, module in next, Loader.Loaded do
		if type(module) == "table" and module.Init then
			local success, module = xpcall(function()
				return module:Init()
			end, function(err)
				return tostring(err)
			end)

			if not success then
				print(("[Loader/WARN]: Failed to init %s\n%s"):format(moduleName, module))
			end
		end
	end
end

function Loader.Start()
	for _, module in next, Loader.Loaded do
		if type(module) == "table" and module.Start then
			task.spawn(function()
				module:Start()
			end)
		end
	end
end

function Loader.Get(name)
	return Loader.Loaded[name]
end

return Loader
