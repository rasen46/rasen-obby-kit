local module = {}
local cache = {}

function module.Boot(groupName, groupData)
    local partOffsets = {}
    local rootCF = groupData.PrimaryPart.CFrame
    
    if groupData.ClassName == "Model" then
        local children = groupData:GetChildren()
        for i=1, #children do
            local part = children[i]
            if part and part._id == rootCF._id then
                continue 
            end
            
            partOffsets[part] = rootCF:ToObjectSpace(part.CFrame)
        end
    else
   	 for i=1, #groupData.Parts do
        	local part = groupData.Parts[i]
        
      	  partOffsets[part] = rootCF:ToObjectSpace(part.CFrame)
  	  end
    end
    
    cache[groupName] = {
        PrimaryPart = groupData.PrimaryPart,
        offsets = partOffsets,
        lastPos = groupData.PrimaryPart.CFrame
    }
end

function module.Thread()
    for i=1, #cache do
        local weldData = cache[i]
        local rootCF = weldData.PrimaryPart.CFrame
        
        if weldData.lastPos == rootCF then continue end

		for part, offset in pairs(weldData.offsets) do
    		part.CFrame = rootCF * offset
		end
    end
end

return module