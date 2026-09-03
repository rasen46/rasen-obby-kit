# rasen-obby-kit
a client-side object handler for a game named "Vortex"

## Installation
1. Get the `rasenObbyKit.luau` file from `github.com/rasen46/rasen-obby-kit/releases` OR get the raw text from `github.com/rasen46/rasen-obby-kit/blob/main/rasenObbyKit.luau`
2. Get the `rasenServerSide.luau` file from `github.com/rasen46/rasen-obby-kit/releases` as well, OR get the raw text from `github.com/rasen46/rasen-obby-kit/blob/main/rasenServerSide.luau`
3. Create a new `LocalScript` under `StarterPlayerScripts` (this script can be named whatever you want it to be)
4. Create a new `Script` under `ServerScriptService` (this script can be also named whatever you want it to be)
5. Paste the contents of `rasenObbyKit.luau` into the `LocalScript` you just created
6.  Paste the contents of `rasenServerSide.luau` into the `Script` you just created
7.  And you're done; you can edit CO inside the `rasenObbyKit.luau` file (or the `LocalScript` under `SCLI_CONFIGS`)

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
|Damager|Class|Damages the player|
|Fader|Class|Makes a part fade if touched
|Standable|Type|Makes a part able to hold players|
|IsPushable|Type|Does not work for now|
|PartReseter|Type|Does not work for now|
|Instakill|Type|Instakills the player|

## Road Map
|-|Coming in 0.4.0|Waiting for Studio updates|
|-|-|-|
|Button (Class)|in progress|no|
|ButtonDeactivate (Class)|in progress|no|
|Beat Block Instance (Class)|in progress|no|
|Beat Block Group (Class)|in progress|no|
|PartRespawner (Type)|in progress|no|
|LDM Mode (Config)|framework|no|
|Quick Reset|yes|no|
|Multi-Obby loading|yes|no|
|Improved Rotation Calculations|no|yes (waiting for better Vector Handling)|
