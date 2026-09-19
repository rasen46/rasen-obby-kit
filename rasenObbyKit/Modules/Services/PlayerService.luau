local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character or LocalPlayer.CharacterAdded:Wait()

local module = {}
module.Data = {
    CurrentCharacter = Character,
    playerNextPivot = Character:GetPivot(),
    AddedWalkspeed = 0,
    AddedJumppower = 0,
    ShouldUpdatePlayerPivot = true
}

function module.GetPlayerCurrentPivot()
	return module.Data.playerNextPivot
end

function module.ChangePlayerPivot(newPivot) 
    module.Data.playerNextPivot = newPivot
end

function module.GetPlayerAngVelocity()
    return module.Data.CurrentCharacter.HumanoidRootPart.AssemblyAngularVelocity
end

function module.ChangeHumanoidAttributes(attribute, value)
    local hum = Character:FindFirstChildOfClass("Humanoid")

    if attribute and string.lower(tostring(attribute)) == "walkspeed" then
        module.Data.AddedWalkspeed += value
    elseif attribute and string.lower(tostring(attribute)) == "jumppower" then
        module.Data.AddedJumppower += value
    end

    if hum and hum[attribute] then
        hum[attribute] += value
    end
end

function module.IsPlayerCharacter(model)
    return model and model._id and module.Data.CurrentCharacter._id == model._id
end

function module.StandingOn()
    return workspace:Raycast(module.Data.playerNextPivot.Position + Vector3.new(0,-0.25,0), Vector3.new(0,-0.5,0), {module.Data.CurrentCharacter})
end

return module