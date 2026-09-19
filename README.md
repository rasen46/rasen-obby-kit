# rasen-obby-kit
a client-side object handler for a game named "Vortex"

## Installation
1. Get the place file from `places`, you can either choose from `obbyutils.vrtx` which has premade client side objects or get `obbyutilsBlank.vrtx` which has none
2. And you're done (im hoping that Halo adds a way to export models soon, as this method of installation is not very efficient)

OR

1. Get the place file from `places`, specifically `obbyutilsBlank.vrtx` 
2. Copy the `rasenObbyKit` local script from `StarterPlayerScripts`
3. Close the place
4. Open the place you want to have the kit in
5. Paste it inside `StarterPlayerScripts`
6. Do the same for the `rasenServerSide` script inside `ServerScriptService` and put it inside `ServerScriptService` instead of `StarterPlayerScripts`
7. Make a RemoteEvent inside ReplicatedStorage and name it specifically `rOK_PlayerEvent` (this is so it won't interfere with other remotes if u have any)
8. And you're done!

## Updating or downgrading the kit
### Refer to the second install option if updating*

You can simply transfer the `obbydata` from your current kit to the one you want to use

or in a somewhat more detailed explaination...

The way I would recommend to update/downgrade your kit is by first getting the kit you want, then deleting the `obbydata` table from the kit you just got from it and replacing it with the `obbydata` from the old kit you were using

to transfer objects from place to place, you can simply select everything from workspace and copy and paste it to another place

## Documentation
Most of the documentation is already shown inside the `rasenObbyKit.luau` file as comments

## Features
### Client/server-side objects
|-|Object Type|Description|
|-|-|-|
|Spinner|Class|Spins a part on any axis|
|Orbital|Class|Makes a part orbit a target part|
|Mover|Class|Moves a part back and forth from its original position to a target part|
|Conveyor|Class|Pushes a player on any axis as long as the player touches the part|
|Teleporter|Class|Teleports the player to a target position|
|Damager|Class|Damages the player|
|Fader|Class|Makes a part fade if touched|
|Button|Class|Modifies a object's properties or runs a function after being triggered|
|ButtonDeactivate|Class|Deactivates a button (does not work for now)|
|PlayerProperties|Class|Changes the properties of the player for an amount of time|
|Standable|Type|Makes a part able to hold players|
|Instakill|Type|Instakills the player|
|BeatBlockGroup|Group|Allows for cycling of part property changes|

### Additional utilities
- Alljumper
- Noclip (temu edition)

## Road Map
|-|Coming in 0.4.1|Waiting for Studio updates|
|-|-|-|
|PartRespawner (Type)|yes|no|
|IsPushable (Type)|yes|no|
|PartReseter (Type)|yes|no|
|LDM Mode (Config)|framework|no|
|Weld (Group)|yes|no|
|XPusher (Class)|maybe|no|
|Vines (Class)|maybe|no|
|Summoner (Class)|yes|no|
|Ziplines (Group)|maybe|no|
|Quick Reset|maybe|no|
|Multi-Obby loading|yes|no|
