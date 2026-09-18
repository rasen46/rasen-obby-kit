local module = {Temp = {}}

function module.AddClass(className)
    module.Temp[className] = {}
end

function module.GetClass(className)
    return module.Temp[className]
end

function module.AppendEntry(className, valueName, valueData) 
    module.Temp[className][valueName] = valueData
end

function module.GetEntry(className, valueName)
    return module.Temp[className][valueName]
end

return module