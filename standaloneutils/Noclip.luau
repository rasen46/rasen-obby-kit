--[[
	Noclip Utility (standalone version)
	by rasen46

	last update: 9/19/2026
	v1.0.0
]]

local UIS = game:GetService("UserInputService")
local Players = game:GetService("Players")
local RunService = game:GetService("RunService")
local Workspace = game:GetService("Workspace")

local player = Players.LocalPlayer

local targetPosition
local noclip = false

local Configuration = {
    KEYBINDS = {
        [Enum.KeyCode.One]         = "Noclip",
		[Enum.KeyCode.Space]       = "NoclipUp",
		[Enum.KeyCode.LeftControl] = "NoclipDown",
	},
	
	NC = {
	    Speed = 50
	}
}

local keys = {
	W = false,
	A = false,
	S = false,
	D = false,
	up = false,
	down = false,
}

local camera = Workspace.CurrentCamera

UIS.InputBegan:Connect(function(inp, pro)
	if pro then
		return
	end

	local key = inp.KeyCode.Name
	local keyEvent = Configuration.KEYBINDS[inp.KeyCode]

	if keys[key] ~= nil then
		keys[key] = true
	end

	if keyEvent == "Noclip" then
		noclip = not noclip
		if noclip then
		    targetPosition = player.Character:GetPivot()
		end
	elseif keyEvent == "NoclipUp" then
		keys.up = true
	elseif keyEvent == "NoclipDown" then
		keys.down = true
	end
end)

UIS.InputEnded:Connect(function(inp)
	local key = inp.KeyCode.Name
	local keyEvent = Configuration.KEYBINDS[inp.KeyCode]

	if keys[key] ~= nil then
		keys[key] = false
	elseif keyEvent == "NoclipUp" then 
		keys.up = false
	elseif keyEvent == "NoclipDown" then
		keys.down = false
	end
end)

RunService.Heartbeat:Connect(function(dt)
	if not noclip then
		return
	end

	local character = player.Character
	if not character then
		return
	end

	local cameraCF = Workspace.CurrentCamera.CFrame
	local forward = Vector3.new(cameraCF.LookVector.X, 0, cameraCF.LookVector.Z)
	local right = Vector3.new(cameraCF.RightVector.X, 0, cameraCF.RightVector.Z)

	if forward.Magnitude > 0 then
		forward = forward.Unit
	end
	if right.Magnitude > 0 then
		right = right.Unit
	end

	local direction = Vector3.zero

	if keys.W then
		direction += forward
	end
	if keys.S then
		direction -= forward
	end
	if keys.D then
		direction += right
	end
	if keys.A then
		direction -= right
	end

	if keys.up then
		direction += Vector3.yAxis
	end
	if keys.down then
		direction -= Vector3.yAxis
	end

	if direction.Magnitude > 0 then
		direction = direction.Unit
	end

	local pivot = targetPosition
	local newPosition = pivot.Position + direction * Configuration.NC.Speed * dt
	local final = CFrame.lookAt(newPosition, newPosition + forward) 
	
	targetPosition = final
	character:PivotTo(final)
end)
