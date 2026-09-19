-- this will be moved to Modules -> Services -> ClientConfigs soon

local configs = {
	KEYBINDS = { -- Keybinds for actions, just change the letter after 'KeyCode.' to the capitalized key you want
		[Enum.KeyCode.F]   = "SetCheckpoint",
		[Enum.KeyCode.R]   = "GoToLatestCheckpoint",
		[Enum.KeyCode.X]   = "RemoveLatestCheckpoint",
		[Enum.KeyCode.T]   = "QuickReset",
		[Enum.KeyCode.One]         = "Noclip",
		[Enum.KeyCode.Space]       = "NoclipUp",
		[Enum.KeyCode.LeftControl] = "NoclipDown"
	},
	VALUES = { -- Configure how stuff look and work in here
		LegitMode               = false, -- Toggles the ability to use All-jump Utilities
		EnableQuickReset        = false, -- Toggles the ability to Quick Reset (disabled for now)
		QRClearCheckpoints      = false, -- Toggles if using Quick Reset will clear all-jump progress (doesn't work for now)
		RespawnAtLastCheckPoint = true,  -- Toggles if dying will spawn you at your last checkpoint or at the default SpawnLocation
		ActivePartDistance      = 100,   -- Sets the maximum distance where spinners, orbital, and conveyors will remain active from the player (MIN: 50) (still WIP)
		QuickResetDuration      = 2,     -- Sets the amount of time required to have the Quick Reset Key being held down to reset the game

		AllJumpConfig = { -- Configurations with how All-jump indicators look like
			ShowIndicators = true,                          -- Toggles whether position indicators show up or not 
			CentertoHRP    = true,                          -- Toggles whether position indicators spawn at the toes or in the center of the player
			Color3         = Color3.new(1, 1, 1),           -- Sets the color of the position indicators
			Size           = Vector3.new(0.25, 0.25, 0.25), -- Sets the size of the position indicators
		},
		NoclipConfig = {
		    StopPlayerService = true -- Toggles if conveyors and standables should alter your movement when noclipping (excludes teleporters)
		}
	},
}

return configs