# rasen-obby-kit
a client-side object handler for a game named "Vortex"

## Installation
1. Get the `rasenObbyKit.luau` file from `github.com/rasen46/rasen-obby-kit/releases`
2. Create a new `LocalScript` under `StarterPlayerScripts` (this script can be named whatever you want it to be)
3. Paste the contents of `rasenObbyKit.luau` into the `LocalScript` you just created

## Updating or downgrading the kit
You can simply transfer the `SCLI_CONFIGS` from your current kit to the one you want to use

or in a somewhat more detailed explaination...

The way I would recommend to update/downgrade your kit is by first getting the kit you want, then deleting the `SCLI_CONFIGS` table from it and replacing it with the `SCLI_CONFIGS` from the current kit you were using (the "old" one)

## Documentation
Most of the documentation is already shown inside the `rasenObbyKit.luau` file as comments

## Road Map
|-|Coming in 0.2.0|Waiting for Studio updates|
|-|-|-|
|Type Checking V1|yes|no|
|Button (Class)|framework|yes|
|ButtonDeactivate (Class)|framework|yes|
|Damager (Class)|no|yes|
|Fader (Class)|no|yes|
|PartRespawner (Type)|yes|yes|
|IsPushable (Type)|yes|yes|
|Instakill (Type)|no|yes|
|LDM Mode (Config)|no|yes|
|ActivePartDistance (Config)|yes|no|
|Quick Reset|mostly|yes|
|Improved Standable Calculations|maybe|yes|
|Rotation Calculation Improvements|no|yes|
