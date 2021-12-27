Config = {}
-- EXAMPLE FOR POSIBLE CONFIG SCRIPT WITH POLYZONE
-- This config not work!
Config.3DScaleforms = {
    {
        id = "casinoEntrance_menu",
        menu = {
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
        },
        zone = {
            positions = {
                vector2(937.6, 46.18),
                vector2(929.3, 49.6),
                vector2(925.7, 44.47),
                vector2(935.13, 41.11),
            },
            data = {
                minZ = 79.0,
                maxZ = 82.0,
                lazyGrid = true,
                debugPoly = true,
            }
        },
        functions = {
            onAction = function(action)
                if action == "teleport_to_casino" then
                    NEX.Game.Teleport(PlayerPedId(), vector4(1089.8228, 206.11833, -49.99974, 352.26))
                elseif action == "teleport_to_roof" then
                    NEX.Game.Teleport(PlayerPedId(), vector4(962.08, 60.47, 112.92, 62.0))
                end
            end
        }
    }
}