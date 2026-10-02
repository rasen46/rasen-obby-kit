local function applyBeatProperties(parts, properties)
	for i = 1, #parts do
		local tweenInfo = properties.TweenInfo
		local part = parts[i]

		if tweenInfo then
			local tweenProperties = table.clone(properties)
			tweenProperties.TweenInfo = nil

			TweenService:Create(part, tweenInfo, tweenProperties):Play()
		else
			for property, value in pairs(properties) do
				part[property] = value
			end
		end
	end
end

local module = {}
local cache = {}

function module.Boot(groupName, groupData)
	cache[groupName] = {
		Elapsed = 0,
		Index = 1,
		groupData = groupData,
	}
end

function module.Thread(dt)
	for groupName, cacheData in pairs(cache) do
		local groupData = cacheData.groupData
		cacheData.Elapsed += dt

		if cacheData.Elapsed >= groupData.BeatInterval then
			cacheData.Elapsed -= groupData.BeatInterval
			cacheData.Index += 1

			if cacheData.Index > #groupData.BeatBlocks then
				cacheData.Index = 1
			end

			for index, parts in pairs(groupData.BeatBlocks) do
				applyBeatProperties(parts, groupData.InactiveBeatBlocks[index])
			end
			applyBeatProperties(groupData.BeatBlocks[cacheData.Index], groupData.ActiveBeatBlocks[cacheData.Index])
		end
	end
end

return module
