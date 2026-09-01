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
version 0.1.0 beta release

please dont strip credits from this
]]

local Players = game:GetService("Players")
local Workspace = game:GetService("Workspace")
local TweenService = game:GetService("TweenService")
local UIS = game:GetService("UserInputService")

-- settings that can be changed by the player in game (i cant rlly allow in game configuration yet deu to lack of ui, so you have to configure ur settings here)
local DCLI_CONFIGS = {
    KEYBINDS =
    { -- keybinds for actions, just change the letter after 'KeyCode.' to the capitalized key you want
        [Enum.KeyCode.E] = "SetCheckpoint",
        [Enum.KeyCode.R] = "GoToLatestCheckpoint",
        [Enum.KeyCode.G] = "RemoveLatestCheckpoint",
        [Enum.KeyCode.T] = "QuickReset"
    },
    VALUES =
    {                                    -- changes some configs with how stuff look and work
        LegitMode               = false, -- Toggles the ability to use All-jump Utilities
        EnableQuickReset        = false, -- Toggles the ability to Quick Reset (disabled for now due to problems with getting part properties)
        QRClearCheckpoints      = false, -- Toggles if using Quick Reset will clear all-jump progress
        RespawnAtLastCheckPoint = true,  -- Toggles if dying will spawn you at your last checkpoint or at the default SpawnLocation
        ActivePartDistance      = 100,   -- The maximum distance where spinners, orbital, and conveyors will remain active from the player (MIN: 50) (not inplemented yet)
        QuickResetDuration      = 2,     -- The amount of time required to have the Quick Reset Key being held down to reset the game

        AllJumpConfig =
        { -- configurations with how All-jump indicators look like (disabled for now due to CanCollide read/write restrictions)
            ShowIndicators = false,
            CentertoHRP    = true,
            Color3         = Color3.new(1, 1, 1),
            Size           = Vector3.new(0.25, 0.25, 0.25),
        }
    }
}

-- the obby kit (practically) (dont change this if ur playing the obby, as it will modify gameplay)
local SCLI_CONFIGS = {
    Classes =
    {
        Spinner = {
            --[[
           Example Spinner
           [Workspace.ExampleSpinner] = { -- set the part you want to spin to the name of the part (this example shows a part named 'ExampleSpinner')
               XAxis = 500, -- sets how fast it rotates on the X Axis (optional, default 0)
               YAxis = 20,  -- sets how fast it rotates on the Y Axis (optional, default 0)
               ZAxis = 390, -- sets how fast it rotates on the Z Axis (optional, default 0)
           }
           ]]
        },
        Orbital = {
            --[[
           Example Orbital
           [Workspace.ExampleOrbital] = { -- set the part you want to orbit around smth to the name of the part (this example shows a part named 'ExampleOrbital')
               Speed = 500,    -- sets how fast it orbits the origin in degrees/second (optional, default 0)
               XTilt = 20,     -- sets the tilts of the orbit on the X Axis in degrees (optional, default 0)
               YRotation = 23, -- sets the tilts of the orbit on the Y Axis in degrees (optional, default 0)
               ZAxis = 390,    -- sets the tilts of the orbit on the Z Axis in degrees (optional, default 0)
               OrbitalOrigin = Workspace.ExampleOrbitOrigin, -- this defines what the part should orbit around (required)
               OrbitalOffset = 5,        -- defines how far away the part should orbit around the origin (required)
               OrbitalFaceCenter = true  -- sets if the part should look at the origin when spinning (optional, default false)
           }
           ]]
        },
        Mover = {
            --[[
           Example Moving Part
           [Workspace.ExampleMover] = { -- set the part you want to move to the name of the part (this example shows a part named 'ExampleMover')
               TargetPosition = Workspace.MovingTarget, -- sets where the part will go to (required)
               Duration = 4,                            -- sets how long it will take to get to 'TargetPosition' (required, unless Tweeninfo defined)
               LoopDelay = 2,                           -- sets how long the part will yield until it resumes moving after reaching target (optional, default 0)
               TweenInfo = {duration, style, direction} -- sets a custom tween for movement instead of linear movement, overrides Duration arg (optional, default linear)
           }
           ]]
        },
        Conveyor = {
            --[[
           Example Conveyor
           [Workspace.ExampleConveyor] = { -- set the part you want to convert into a conveyor to the name of the part (this example shows a part named 'ExampleConveyor')
               XAxis = 16,              -- sets the conveyor speed in the X Axis (optional, default 0)
               YAxis = 24,              -- sets the conveyor speed in the Y Axis (optional, default 0)
               ZAxis = 43,              -- sets the conveyor speed in the Z Axis (optional, default 0)
               BasedOnRotation = false, -- this controls if the conveyor should push based on how its rotated, it will override all Axis values
               BaseSpeed = 16,          -- this is only required if 'BasedOnRotation' is set to true, controls the speed of the conveyor
           }
           ]]
        },
    },

    Types =
    {
        Standable =
        { -- this type defines if the player should be able to move with the part if they're on it, you dont need to give parts this type if they only move up and down
            -- should be in array format (ie: {workspace.Part2, workspace.Part})
            Workspace.spinner,
            Workspace.spin2
        }
    },

    FFlagsEditor = { -- devtools, dont touch unless yk what ur doing
        ["DFFlagExportTextToOutput"] = true,
        ["FFlagUsePartInstanceOverVector3"] = true
    }
}

local CLI_Cache = {
    Map = {},
    Temp = {
        Orbitial = {},
        Mover = {},
        Conveyor = {}
    }
}

local Checkpoints = {}
local cCount = 0

local holdingQR = false
local heldQRTime = 0

local playerAddedForce = Vector3.zero

local currentTouchedStandable = nil
local lastCf = nil

local elapsed = 0

local player = Players.LocalPlayer
local spawnLocation = Workspace:FindFirstChild("SpawnLocation")

local function LOGF(LType, log)
    if SCLI_CONFIGS.FFlagsEditor.DFFlagExportTextToOutput then
        print("[" .. tostring(LType):upper() .. "] " .. log)
    end
end

local function resetObby()
    -- untested
    for part, data in pairs(CLI_Cache) do
        if data.Original then data.Original:Destroy() end
        local newPart = part:Clone()
        newPart.Position = data.Position

        task.wait()
    end
end

UIS.InputBegan:Connect(function(inp, pro)
    if pro then return end

    local keyEvent = DCLI_CONFIGS.KEYBINDS[inp.KeyCode]
    if keyEvent then
        if not DCLI_CONFIGS.VALUES.LegitMode then
            if keyEvent == "SetCheckpoint" then
                cCount += 1
                Checkpoints[cCount] = player.Character.Position
            elseif keyEvent == "GoToLatestCheckpoint" then
                local pos = Checkpoints[cCount] or spawnLocation.Position
                if not pos then return end
                player.Character.Position = pos
            elseif keyEvent == "RemoveLatestCheckpoint" then
                if not Checkpoints[cCount] then return end
                Checkpoints[cCount] = nil
                cCount -= 1
            end
        end

        if keyEvent == "QuickReset" then
            holdingQR = true
        end
    end
end)

UIS.InputEnded:Connect(function(inp)
    local keyEvent = DCLI_CONFIGS.KEYBINDS[inp.KeyCode]

    if keyEvent then
        if keyEvent == "QuickReset" then
            holdingQR = false
        end
    end
end)

-- Main Thread
task.defer(function()
    -- boot
    for _, part in ipairs(Workspace:GetChildren()) do
        if part.ClassName ~= "Part" then continue end

        if part.Anchored ~= true then
            local ref = part:Clone()
            CLI_Cache.Map[ref] = { Position = part.Position, Original = part }
        end

        task.wait()
    end

    for _, part in ipairs(SCLI_CONFIGS.Types.Standable) do
        part.Touched:Connect(function()
            lastCf = part.CFrame
            currentTouchedStandable = part

            part.TouchEnded:Once(function()
                if currentTouchedStandable == part then
                    currentTouchedStandable = nil
                    lastCf = nil
                end
            end)
        end)
    end

    for part, data in pairs(SCLI_CONFIGS.Classes.Mover) do
        local TweenTT = TweenService:Create(
            part,
            data.Tween or { data.Duration, Enum.EasingStyle.Linear },
            {
                Position = SCLI_CONFIGS.FFlagsEditor.FFlagUsePartInstanceOverVector3 and data.TargetPosition.Position or
                    data.TargetPosition
            }
        )
        local TweenTO = TweenService:Create(part, data.Tween or { data.Duration, Enum.EasingStyle.Linear },
            { Position = part.Position })

        CLI_Cache.Temp.Orbitial[part] = dir

        task.defer(function()
            while task.wait() do
                TweenTT:Play()
                TweenTT.Completed:Wait()
                task.wait(data.LoopDelay)
                TweenTO:Play()
                TweenTO.Completed:Wait()
                task.wait(data.LoopDelay)
            end
        end)
    end

    for part, data in pairs(SCLI_CONFIGS.Classes.Conveyor) do
        part.Touched:Connect(function(hit)
            CLI_Cache.Temp.Conveyor[part] = true
        end)

        part.TouchEnded:Connect(function(hit)
            CLI_Cache.Temp.Conveyor[part] = nil
        end)
    end

    -- thread
    while true do
        local dt = task.wait()
        elapsed += dt

        playerAddedForce = Vector3.zero

        if holdingQR then
            heldQRTime += dt

            if heldQRTime >= DCLI_CONFIGS.VALUES.QuickResetDuration then
                holdingQR = false
                heldQRTime = 0

                --resetObby()
                LOGF("info", "reseted")
            end
        else
            heldQRTime = 0
        end

        for part, data in pairs(SCLI_CONFIGS.Classes.Spinner) do
            part.CFrame *= CFrame.Angles(
                data.XAxis and math.rad(data.XAxis * dt) or 0,
                data.YAxis and math.rad(data.YAxis * dt) or 0,
                data.ZAxis and math.rad(data.ZAxis * dt) or 0
            )
        end

        for part, data in pairs(SCLI_CONFIGS.Classes.Orbital) do
            local dir = CLI_Cache.Temp.Orbitial[part]

            if not dir then
                dir = {
                    Angle = 0
                }
                CLI_Cache.Temp.Orbitial[part] = dir
            end

            dir.Angle += math.rad(data.Speed) * dt

            local off = CFrame.Angles(
                math.rad(data.XTilt or 0),
                math.rad(data.YRotation or 0),
                math.rad(data.ZAxis or 0)
            ):VectorToWorldSpace(Vector3.new(
                math.cos(dir.Angle) * (data.OrbitalOffset or 0),
                0,
                math.sin(dir.Angle) * (data.OrbitalOffset or 0)
            ))

            local pos = (SCLI_CONFIGS.FFlagsEditor.FFlagUsePartInstanceOverVector3 and data.OrbitalOrigin.Position or data.OrbitalOrigin) +
                off

            if data.OrbitalFaceCenter then
                part.CFrame = CFrame.lookAt(
                    pos,
                    data.OrbitalOrigin.Position
                )
            else
                part.Position = pos
            end
        end

        for part in pairs(CLI_Cache.Temp.Conveyor) do
            local data = SCLI_CONFIGS.Classes.Conveyor[part]

            if data.BasedOnRotation then
                playerAddedForce += part.CFrame.LookVector * (data.BaseSpeed or 0)
            else
                playerAddedForce += Vector3.new(
                    data.XAxis or 0,
                    data.YAxis or 0,
                    data.ZAxis or 0
                )
            end
        end

        player.Character.Position += playerAddedForce * dt

        if currentTouchedStandable and lastCf then
            local character = player.Character
            if character then
                local currentCFrame = currentTouchedStandable.CFrame
                local relative = lastCf:ToObjectSpace(CFrame.new(character.Position))

                character.Position = (currentCFrame:ToWorldSpace(relative)).Position
                lastCf = currentCFrame
            end
        end
    end
end)