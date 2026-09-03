--[[
            /$$$$$$  /$$   /$$
           /$$__  $$| $$  /$$/
  /$$$$$$ | $$  \ $$| $$ /$$/ 
 /$$__  $$| $$  | $$| $$$$$/  
| $$  \__/| $$  | $$| $$  $$  
| $$      | $$  | $$| $$\  $$ 
| $$      |  $$$$$$/| $$ \  $$
|__/       \______/ |__/  \__/
rasen's obby kit
version 0.1.0 dev release (server)

please dont strip credits from this
]]

local ReplicatedStorage = game:GetService("ReplicatedStorage")

local rOK_PlayerEvent = Instance.new("RemoteEvent")
rOK_PlayerEvent.Name = "rOK_PlayerEvent"
rOK_PlayerEvent.Parent = ReplicatedStorage

rOK_PlayerEvent.OnServerEvent:Connect(function(player, EType, ...)
    local args = ...
    
    if EType == "damage" then
        local hum = player.Character:FindFirstChildOfClass("Humanoid")
        local dmg = args[1] or 0

        if hum then
            hum:TakeDamage(dmg)
        end
    end
end)