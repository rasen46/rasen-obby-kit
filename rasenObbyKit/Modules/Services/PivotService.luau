local Players = game:GetService("Players")
local LocalPlayer = Players.LocalPlayer
local Character = LocalPlayer.Character

local module = {}
module.Data = {
    playerNextPivot = Character:GetPivot()
}

function module.GetPlayerCurrentPivot() 
    return module.Data.playerNextPivot or Character:GetPivot()
end

function module.ChangePlayerPivot(newPivot) 
    module.Data.playerNextPivot = newPivot
end