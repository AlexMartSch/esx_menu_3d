## ESX 3D MENU

### How to install
- Put the folder to your resources folder

### Preview
![image](https://i.imgur.com/pOfzcua.png)
![image](https://i.imgur.com/V1Hn70a.png)

### How to use

```
ESX.UI.Menu.Open('scaleform', GetCurrentResourceName(), 'casino_menu_example', {
    title    =  "Casino",
    description = "Select your next destination",
    options  = {
        position = vector3(940.158, 44.79, 79.79), -- Position is a headache, I hope with the editor you can understand it faster.
        rotation = vector3(-2.99, 2.59, 75.38), -- Rotation is a headache, I hope with the editor you can understand it faster.
        scale = vector3(12.0, 5.0, 8.0), -- Scale: X = Horizontal; Y = Vertical; Z = ?
        values = vector3(1.0, 1.0, 1.0), --(Some values are not yet understood, always must be 1.0)
        heading = 1, -- WIP (Some values are not yet understood)
        canClose = false -- WIP
    },
    elements = {
        { label = "Go to CASINO", value = "teleport_to_casino" },
        { label = "Go to ROOF", value = "teleport_to_roof"}
    }
}, function(data, menu)

    local action = data.current.value
    if action == "teleport_to_casino" then
        print("TELEPORT TO CASINO")
    elseif action == "teleport_to_roof" then
        print("TELEPORT TO ROOF")
    end
    
end, function(data, menu)end)
```

#### Options

```
options  = {
        position = vector3(), -- Position is a headache, I hope with the editor you can understand it faster.
        rotation = vector3(), -- Rotation is a headache, I hope with the editor you can understand it faster.
        scale = vector3(), -- Scale: X = Horizontal; Y = Vertical; Z = ?
        values = vector3(1.0, 1.0, 1.0), --(Some values are not yet understood, always must be 1.0)
        heading = 1, -- WIP (Some values are not yet understood)
        canClose = false -- WIP
}
```


#### Important
This is a test script, so you can experiment with it. I recommend using PolyZone to check when to load / unload the HUD.

#### Credits
I give the corresponding credits to the original author ([Negbook](https://forum.cfx.re/u/negbook)) of [this script](https://forum.cfx.re/t/release-esx-menu-scaleform-by-negbook/1799474) in its 2D version 