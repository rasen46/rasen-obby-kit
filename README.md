# rasen-obby-kit
a client-side object handler for a game named "Vortex"

## Installation
1. Get the `rasenObbyKit.luau` file from `github.com/rasen46/rasen-obby-kit/releases` OR get the raw text from `github.com/rasen46/rasen-obby-kit/blob/main/rasenObbyKit.luau`
2. Create a new `LocalScript` under `StarterPlayerScripts` (this script can be named whatever you want it to be)
3. Paste the contents of `rasenObbyKit.luau` into the `LocalScript` you just created

## Updating or downgrading the kit
You can simply transfer the `SCLI_CONFIGS` from your current kit to the one you want to use

or in a somewhat more detailed explaination...

The way I would recommend to update/downgrade your kit is by first getting the kit you want, then deleting the `SCLI_CONFIGS` table from it and replacing it with the `SCLI_CONFIGS` from the current kit you were using (the "old" one)

## Documentation
Most of the documentation is already shown inside the `rasenObbyKit.luau` file as comments

## Features
This kit current features:
|-|Object Type|Description|
|-|-|-|
|Spinner|Class|Spins a part on any axis|
|Orbital|Class|Makes a part orbit a target part|
|Mover|Class|Moves a part back and forth from its original position to a target part|
|Conveyor|Class|Pushes a player on any axis as long as the player touches the part|
|Teleporter|Class|Teleports the player to a target position|
|Standable|Type|Makes a part able to hold players|
|IsPushable|Type|Does not work for now|
|PartReseter|Type|Does not work for now|

## Road Map
|-|Coming in 0.3.0|Waiting for Studio updates|
|-|-|-|
|Button (Class)|framework|yes (Part property write access)|
|ButtonDeactivate (Class)|framework|yes (Part property write access)|
|Damager (Class)|no|yes (Humanoid Health write access)|
|Fader (Class)|framework|yes (Part property write access)|
|Beat Block Instance (Class)|framework|no|
|Beat Block Group (Class)|framework|yes (Part property write access)|
|PartRespawner (Type)|framework|yes (Part property write access)|
|IsPushable (Type)|deprecated soon|no|
|Instakill (Type)|no|yes (Humanoid Health write access)|
|LDM Mode (Config)|no|yes (Part property write access)|
|Quick Reset|yes|yes (Part property write access)|
|All jump Indicators|framework| yes (Part property write access)|
|Multi-Obby loading|maybe|yes (Part property write access)|
|Improved Standable Calculations|yes|yes (Character CFrame write access)|
|Improved Rotation Calculations|no|yes (Part Vector3 Improvements)|
