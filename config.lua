Config = {}
Config.3DScaleforms = {
    {
        id = "casinoEntrance_menu",
        menu = {
            title = "CASINO",
            description = "Selecciona tu próximo destino",
            options = {
                position    = vector3(940.15, 44.7, 79.79),
                rotation    = vector3(-2.99, 2.5, 75.38),
                scale       = vector3(12.0, 5.0, 8.0)
            },
            elements = {
                { label = "Ir al Casino", value = "teleport_to_casino" },
                { label = "Ir a la Azotea", value = "teleport_to_roof"}
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