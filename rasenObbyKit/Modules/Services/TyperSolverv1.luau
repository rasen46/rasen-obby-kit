local module = {}
module.Packages = {
	FFlags = "FFlags",
}
module.Rules = {}

local function getObjectDataType(value)
	local t = typeof(value)
	if t == "table" then
		if value.X or value.x then
			if value.qx then
				return "CFrame"
			end
			return "Vector3"
		elseif value._id then
			return "Instance"
		else
			return t
		end
	end
	return t
end

local function CheckValue(value, expectedType)
	if typeof(expectedType) == "function" then
		return getObjectDataType(value)
	end

	if typeof(expectedType) == "string" then
		return getObjectDataType(value) == expectedType
	end

	return false
end

local function ValidateClass(className, object, data, rules)
	if not rules then
		print(`[TypeSolver/WARN]: Unknown class: "{className}"`)
		return false
	end

	if rules.FunctionCheck and not rules.FunctionCheck(object) then
		LOGF("warn", `[{className}][{object.Name}]: object failed FunctionCheck`)
		return false
	end

	for propertyName, expectedType in pairs(rules) do
		if propertyName ~= "Optional" and propertyName ~= "Dependencies" and propertyName ~= "FunctionCheck" then
			local value = data[propertyName]

			if value == nil then
				print(
					`[TypeSolver/WARN] [{className}][{object.Name}]: missing required property "{propertyName}", or value got is invalid/non-existent: 'nil'`
				)
				return false
			end

			if not CheckValue(value, expectedType) then
				print(
					`[TypeSolver/WARN] [{className}][{object.Name}]: "{propertyName}" expected {expectedType}, got {getObjectDataType(
						value
					)}`
				)
				return false
			end
		end
	end

	if rules.Optional then
		for propertyName, value in pairs(data) do
			local expectedType = rules.Optional[propertyName]

			if expectedType then
				if not CheckValue(value, expectedType) then
					print(
						`[TypeSolver/WARN] [{className}][{object.Name}]: "{propertyName}" expected {expectedType}, got {getObjectDataType(
							value
						)}`
					)
					return false
				end
			end
		end
	end

	if rules.Dependencies then
		for propertyName, dependencyRules in pairs(rules.Dependencies) do
			local propertyValue = data[propertyName]

			if propertyValue ~= nil then
				for dependencyName, expectedType in pairs(dependencyRules) do
					local value = data[dependencyName]

					if value == nil then
						print(
							`[TypeSolver/WARN] [{className}][{object.Name}]: "{dependencyName}" is required when "{propertyName}" is set`
						)
						return false
					end

					if not CheckValue(value, expectedType) then
						print(
							`[TypeSolver/WARN] [{className}][{object.Name}]: "{dependencyName}" expected {expectedType}, got {getObjectDataType(
								value
							)}`
						)
						return false
					end
				end
			end
		end
	end

	if module.Packages.FFlags.FFlagEnableWarningOnExtraProperties then
		for propertyName in pairs(data) do
			local known = rules[propertyName] or (rules.Optional and rules.Optional[propertyName])

			if not known and rules.Dependencies then
				for _, dependencies in pairs(rules.Dependencies) do
					if dependencies[propertyName] then
						known = true
						break
					end
				end
			elseif not known then
				print(`[TypeSolver/WARN] [{className}][{object.Name}]: unknown property "{propertyName}"`)
			end
		end
	end

	return true
end

function module.TypeSolve(table)
	local throwError = false
	for containerClass, containerObjects in pairs(table) do
		if containerClass ~= "Classes" and containerClass ~= "Types" then
			continue
		end

		for className, classChildren in pairs(containerObjects) do
			local rules = module.Rules[className]
			if not rules then
				print(`[TypeSolver/WARN]: Unknown {containerClass} "{className}"`)
				throwError = true
				continue
			end

			if containerClass == "Classes" then
				for object, data in pairs(classChildren) do
					if not object:IsA("BasePart") then
						print(`[TypeSolver/WARN] [{className}] [{object.Name}]: dictionary key must be an BasePart`)

						throwError = true
						continue
					end

					if typeof(data) ~= "table" then
						print(
							`[TypeSolver/WARN] [{className}] [{object.Name}]: configuration for {object.Name} must be a table`
						)

						throwError = true
						continue
					end

					local result = ValidateClass(className, object, data, rules)

					if not result then
						throwError = true
					end
				end
			elseif containerClass == "Types" then
				if typeof(classChildren) ~= "table" then
					print(`[TypeSolver/WARN] [{className}]: type must be an array`)
					throwError = true
					continue
				end
				for i = #classChildren, 1, -1 do
					local object = classChildren[i]

					if rules.FunctionCheck and not rules.FunctionCheck(object) then
						print(`[TypeSolver/WARN] [{className}] [{object.Name}]: object failed FunctionCheck`)
						throwError = true
					end
				end
			end
		end
	end

	if throwError then
		error("an error was found in obby data, stopping engine")
	end
end

return module
