--[[
    House keeping file.
]]

-- require push librarry
push = require 'libraries/push'

-- require class library
Class = require 'libraries/class'

-- require knife library
Timer = require 'libraries/knife.timer'

-- utilities (sprite getter)
require 'source/Utilities'

-- global variables
require 'source/Globals'

-- state machine
require 'source/SM'
require 'source/states/Base'
require 'source/states/Start'
require 'source/states/Play'

-- generate world
require 'source/GenerateWorld'

-- generate beach
require 'source/GenerateBeach'

-- generate river
require 'source/GenerateRiver'

-- player
require 'source/player_def'
require 'source/Player'
require 'source/states/player/PlayerWalk'
require 'source/states/player/PlayerIdle'
require 'source/states/player/PlayerCasting'
require 'source/states/player/PlayerFishing'
require 'source/states/player/PlayerShop'
require 'source/states/player/PlayerInventory'
require 'source/states/player/PlayerAchievement'

-- fish catching functions
require 'source/CatchFish'


-- Sprite Sheets
SpriteSheet = {
    ['fish'] = love.graphics.newImage('graphics/fish.png'),
    ['ground'] = love.graphics.newImage('graphics/ground.png'),
    ['beach'] = love.graphics.newImage('graphics/beach.png'),
    ['inventory'] = love.graphics.newImage('graphics/inventory.png'),
    ['background'] = love.graphics.newImage('graphics/background.png'),
    ['shop_background'] = love.graphics.newImage('graphics/shop_background.png'),
    ['shop'] = love.graphics.newImage('graphics/shop.png'),
    ['title'] = love.graphics.newImage('graphics/start.png')
}

-- Individual Sprites
Sprites = {
    ['small_fish'] = GetSmallFish(SpriteSheet['fish']),
    ['big_fish'] = GetBigFish(SpriteSheet['fish']),
    ['player'] = GetPlayer(SpriteSheet['fish']),
    ['wall'] = GetWall(SpriteSheet['ground']),
    ['wall_ground'] = GetWallGround(SpriteSheet['ground']),
    ['ground'] = GetGround(SpriteSheet['ground']),
    ['ground_path'] = GetGroundPath(SpriteSheet['ground']),
    ['signs'] = GetSigns(SpriteSheet['ground']),
    ['beach'] = GetBeach(SpriteSheet['beach']),
    ['water'] = GetWater(SpriteSheet['ground']),
    ['inventory'] = GetInventory(SpriteSheet['inventory']),
    ['items'] = GetItems(SpriteSheet['fish']),
    ['shop_items'] = GetShop(SpriteSheet['shop']),
    ['title'] = GetTitle(SpriteSheet['title'])
}

-- Fonts
Fonts = {
    ['x-sm'] = love.graphics.newFont('fonts/RetroscapeRegular.ttf', 8),
    ['sm'] = love.graphics.newFont('fonts/RetroscapeRegular.ttf', 16),
    ['md'] = love.graphics.newFont('fonts/RetroscapeRegular.ttf', 32),
    ['lg'] = love.graphics.newFont('fonts/RetroscapeRegular.ttf', 48),
    ['x-lg'] = love.graphics.newFont('fonts/RetroscapeRegular.ttf', 64),
    ['xx-lg'] = love.graphics.newFont('fonts/RetroscapeRegular.ttf', 128)
}

-- Sounds
Sounds = {
    ['background'] = love.audio.newSource("sounds/piano.wav", "static")
}
