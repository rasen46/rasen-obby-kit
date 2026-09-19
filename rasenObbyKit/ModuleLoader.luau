local RunService = game:GetService("RunService")
local ReplicatedStorage = game:GetService("ReplicatedStorage")

local Loader = {}
Loader.Loaded = {}
Loader.Packages = {}

local loadedModules = 0

local function requireModule(moduleScript)
	local success, module = xpcall(function()
		return require(moduleScript)
	end, function(err)
		return tostring(err)
	end)

	if not success then
		print(("[Loader/WARN]: Failed to require %s\n%s"):format(
			moduleScript.Name,
			module
		))
		return nil
	end

	return module
end

local function requireDescendants(container)
	for _, moduleScript in ipairs(container:GetDescendants()) do
		if not moduleScript:IsA("ModuleScript") then
			continue
		end

		if Loader.Loaded[moduleScript.Name] then
			print(("[Loader/WARN]: Duplicate module '%s'"):format(moduleScript.Name))
			continue
		end

		local module = requireModule(moduleScript)

		if module then
			Loader.Loaded[moduleScript.Name] = module
			Loader.Packages[moduleScript.Name] = moduleScript

			loadedModules += 1
		end
	end
end

function Loader.LoadAll()
	print("[Loader/INFO]: rasen46 module loader v1.3 (pooretx edition)")
	requireDescendants(script.Modules)
end

function Loader.Init()
	for moduleName, module in next, Loader.Loaded do
		if type(module) == "table" and module.Packages then
			for packageName in next, module.Packages do
				local package = Loader.Get(packageName)

				if package then
					module.Packages[packageName] = package
				else
					print(("[Loader/WARN]: Tried to load package '%s', but it doesn't exist")
						:format(packageName))
				end
			end
		end

		if type(module) == "table" and module.Init then
			local success, err = xpcall(function()
				module.Init()
			end, function(errorMessage)
				return tostring(errorMessage)
			end)

			if not success then
				print(("[Loader/WARN]: Failed to init %s\n%s")
					:format(moduleName, err))
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