local module = {}
module.Rules = {}

function module.CheckValue(value, expectedType)
	if typeof(expectedType) == "function" then
		return expectedType(value)
	end

	if typeof(expectedType) == "string" then
		return typeof(value) == expectedType
	end

	return false
end

function module.ValidateClass(className, object, data, rules)
	if not rules then
		LOGF("warn", `Unknown class: "{className}"`)
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
				LOGF(
					"warn",
					`[{className}][{object.Name}]: missing required property "{propertyName}", or value got is invalid/non-existent: 'nil'`
				)
				return false
			end

			if not CheckValue(value, expectedType) then
				LOGF(
					"warn",
					`[{className}][{object.Name}]: "{propertyName}" expected {expectedType}, got {typeof(value)}`
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
					LOGF(
						"warn",
						`[{className}][{object.Name}]: "{propertyName}" expected {expectedType}, got {typeof(value)}`
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
						LOGF(
							"warn",
							`[{className}][{object.Name}]: "{dependencyName}" is required when "{propertyName}" is set`
						)
						return false
					end

					if not CheckValue(value, expectedType) then
						LOGF(
							"warn",
							`[{className}][{object.Name}]: "{dependencyName}" expected {expectedType}, got {typeof(
								value
							)}`
						)
						return false
					end
				end
			end
		end
	end

	if SCLI_CONFIGS.FFlagsEditor.FFlagEnableWarningOnExtraProperties then
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
				LOGF("warn", `[{className}][{object.Name}]: unknown property "{propertyName}"`)
			end
		end
	end

	return true
end

return module