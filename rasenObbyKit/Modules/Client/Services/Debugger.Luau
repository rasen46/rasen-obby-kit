local module = {
    debug = {}
}

function module.CreateDebugPart(shouldDelete, partProps)
    local newPart = Instance.new("Part")
    
    for propName, prop in pairs(partProps) do
        newPart[propName] = prop
    end
    
    if shouldDelete then
        task.delay(shouldDelete, function()
            local index = table.find(module.debug, newPart)
			if index then
 			   module.debug[index]:Destroy()
  			  table.remove(module.debug, index)
			end
        end)
    end
    
    module.debug[#module.debug + 1] = newPart
    
    return newPart
end

return module
