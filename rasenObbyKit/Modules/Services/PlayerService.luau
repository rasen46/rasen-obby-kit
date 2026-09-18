local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character

local module = {}
module.Data = {
    CurrentCharacter = Character,
    playerNextPivot = Character:GetPivot(),
    AddedWalkspeed = 0,
    AddedJumppower = 0,
}

function module.GetPlayerCurrentPivot() 
    return module.Data.playerNextPivot or Character:GetPivot()
end

function module.ChangePlayerPivot(newPivot) 
    module.Data.playerNextPivot = newPivot
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
    return model and model._id and CurrentCharacter._id == model_.id
end