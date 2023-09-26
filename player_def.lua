--[[
    Player animations.
]]

PLAYER_DEFS = {
    ['player'] = {
        walkSpeed = PLAYER_WALK_SPEED,
        animations = {
            ['walk-left'] = {
                frames = {7, 8, 9},
                interval = 0.155,
                texture = 'fish'
            },
            ['walk-right'] = {
                frames = {10, 11, 12},
                interval = 0.155,
                texture = 'fish'
            },
            ['walk-up'] = {
                frames = {1, 2, 3},
                interval = 0.155,
                texture = 'fish'
            },
            ['walk-down'] = {
                frames = {4, 5, 6},
                interval = 0.155,
                texture = 'fish'
            },
            ['idle-left'] = {
                frames = {9},
                interval = 0.155,
                texture = 'fish'
            },
            ['idle-right'] = {
                frames = {12},
                interval = 0.155,
                texture = 'fish'
            },
            ['idle-up'] = {
                frames = {3},
                interval = 0.155,
                texture = 'fish'
            },
            ['idle-down'] = {
                frames = {6},
                interval = 0.155,
                texture = 'fish'
            }
        }
    }
}